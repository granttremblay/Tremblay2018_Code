from astroquery.alma import Alma

alma = Alma()
alma.cache_location = Alma.cache_location = '.'
alma.login('gtremblay')

results = Alma.query(payload=dict(project_code='2012.1.00988.S'), public=True, cache=False)

alma.retrieve_data_from_uid(results['Member ous id'])
