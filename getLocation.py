import csv

f = open("Regions.txt", "r")
word_names = [line.strip() for line in f]
f.close()


with open("innovators.csv", "w+") as file:
    writer = csv.writer(file)

    for word in word_names:
        newWord = ""
        started = False
        k = 0
        for i in range(len(word_names)):
            if word[i] == ",":
                started = True
            elif started == True:
                k=i
                break

        result = word.find(",2020-")
        newWord = word[k:result]
        newWord = newWord.replace("*","")
        newWord = newWord.replace("\"","")

        coolio = newWord.split(",")
        if not "unknown" in [x.lower() for x in coolio]:
            while len(coolio) < 3:
                coolio.insert(0, "")
            writer.writerow(coolio)

#import csv
#with open('innovators.csv', 'w') as file:
#    writer = csv.writer(file)
#    writer.writerow(["SN", "Name", "Contribution"])
#    writer.writerow([1, "Linus Torvalds", "Linux Kernel"])
#    writer.writerow([2, "Tim Berners-Lee", "World Wide Web"])
#    writer.writerow([3, "Guido van Rossum", "Python Programming"])
