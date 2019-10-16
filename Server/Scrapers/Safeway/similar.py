from difflib import SequenceMatcher
import jellyfish

def similar(a, b):
    return SequenceMatcher(None, a, b).token_sort_ratio()

#print(similar("Cheez-It Crackers Baked Snack Family Size - 21 Oz", "Cheez-It Baked Snack Crackers, Original Cheddar, Family Size, 21 oz"))

#print(similar("Cheez-It Crackers Baked Snack Family Size - 21 Oz", "Cheez-It Baked Snack Crackers, White Cheddar, Family Size, 21 oz"))

#print(similar("blah","blah"))

a = input('')
b = input('')

print(jellyfish.levenshtein_distance(a,b))
#print(similar(a,b))
