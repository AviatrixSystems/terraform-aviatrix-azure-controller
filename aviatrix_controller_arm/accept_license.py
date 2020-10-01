import subprocess
import json

# Get the details if Azure Marketplace image terms
process = subprocess.Popen(['az','vm', 'image',
                            'terms', 'show', '--urn',
                            'aviatrix-systems:aviatrix-bundle-payg:aviatrix-enterprise-bundle-byol:latest'],
                            stdout=subprocess.PIPE)

out = process.communicate()[0]

# Accept Azure Marketplace image terms so that the image can be used to create VMs
py_dict = json.loads(out)
if not py_dict['accepted']:
    process = subprocess.Popen(['az','vm', 'image',
                                'terms', 'accept', '--urn',
                                'aviatrix-systems:aviatrix-bundle-payg:aviatrix-enterprise-bundle-byol:latest'],
                                stdout=subprocess.PIPE)
