from bs4 import BeautifulSoup
import xml.etree.ElementTree as ET
import pandas as pd

def cat12_extract_xml(files: list, atlas: str, tpm: str):
    '''
    Extracts data from a list of XML files based on a specified atlas and TPM (Tissue Probability Map) type. 
    The function processes each XML file, extracts relevant volumetric data for gray matter (Vgm), white matter (Vwm), 
    or cerebrospinal fluid (Vcsf) based on the atlas provided, and returns the data in a pandas DataFrame.

    Parameters:
    - files (list): A list of XML file paths to process.
    - atlas (str): The brain atlas name used to extract relevant data (e.g., 'cobra', 'hammers', etc.). 
                   Only atlases that are predefined in the `atlas_rules` dictionary are supported. 
                   If an unsupported atlas is provided, an exception is raised.
    - tpm (str): The tissue probability map type (e.g., 'Vgm', 'Vwm', 'Vcsf', 'thickness') to extract from the XML files. 
                 The TPM type must be supported by the specified atlas.

    Returns:
    - pd.DataFrame: A DataFrame where each row corresponds to the extracted data from an XML file.
                    The DataFrame contains:
                    - 'SubjectID': The identifier extracted from the file name.
                    - One or more columns representing the extracted TPM data (e.g., Vgm, Vwm).

    Raises:
    - Exception: If the specified atlas is not supported, it raises an exception listing the supported atlas types.
    - TypeError: If the specified TPM type is not supported by the given atlas, it raises a TypeError with the allowed TPM types.

    Example usage:
    >>> extract_from_xml(['file1.xml', 'file2.xml'], 'hammers', 'Vgm')
    '''

    atlas_rules = {
        "cobra": ['Vgm','Vwm'],
        "hammers": ['Vgm','Vwm','Vcsf'],
        "ibsr": ['Vgm','Vwm','Vcsf'],
        "lpba40": ['Vgm','Vwm'],
        "neuromorphometrics": ['Vgm','Vwm','Vcsf'],
        "suit": ['Vgm','Vwm'],
        "thalamic_nuclei": ['Vgm'],
        "thalamus": ['Vgm'],
        "aparc_a2009s" : ['thickness'],
        "aparc_DK40" : ['thickness']
    }
    
    # Check if the provided atlas is valid
    if atlas not in atlas_rules.keys():
        raise Exception(f"{atlas} not found. Supported atlas types are {list(atlas_rules.keys())}")
    
    data_list = []  # This will store the final results
    column = []

    for file in files:
        with open(file, 'r') as f:
            file_data = f.read()  # Read the content of the file

        bs_data = BeautifulSoup(file_data, "xml")  # Parse the file using BeautifulSoup
        xml_data_str = str(bs_data.find_all(atlas)[0])  # Extract the relevant atlas data as a string
        sub_id = file.split("\\")[-1]  # Extract the subject ID from the file name
        
        # Parse the XML string
        root = ET.fromstring(xml_data_str)  # Use ElementTree to parse the XML
        if tpm in atlas_rules.get(atlas):
            # Extract ids, names, and the specified TPM (e.g., Vgm, Vwm, Vcsf) data
            ids = root.find('ids').text.strip('[]').split(';')
            names = [item.text for item in root.find('names').findall('item')]
            tpm_data = list(map(float, root.find('data').find(tpm).text.strip('[]').split(';')))
            
            # Append the subject ID and extracted TPM data to the data list
            data_list.append([sub_id] + tpm_data)
            column = names
        else:
            raise TypeError(f"Allowed TPM types for '{atlas}' are {atlas_rules.get(atlas)}")

    # Return the data as a pandas DataFrame
    return pd.DataFrame(data_list, columns=['SubjectID'] + column)