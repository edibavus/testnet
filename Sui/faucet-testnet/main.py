import requests
import random
import os
import time

channel = 'https://discord.com/api/v9/channels/1037811694564560966/messages'


def crete_message():
    msg = "!faucet "
    # get wallet from first line
    with open(r"wallets.txt", 'r') as file:
        lines = file.readlines()
    msg += lines[0][:-1]
    return msg


def is_empty(file_path):
    if os.path.getsize(file_path) == 0:
        # File is empty, there is no wallets to deposit
        return True
    else:
        # File is not empty
        return False


def delete_wallet():
    # read lines
    lines = []
    with open(r"wallets.txt", 'r') as file:
        lines = file.readlines()

    # delete first line
    with open(r"wallets.txt", 'w') as file:
        for number, line in enumerate(lines):
            if number not in [0]:
                file.write(line)


def main(chnl):
    while not is_empty("wallets.txt"):
        try:
            # loop through discord tokens
            with open(r"discord_auth.txt", 'r') as file:
                lines = file.readlines()
                # shuffle discord account for some randomness
                random.shuffle(lines)
                for line in lines:
                    discord_token = line[:-1]
                    message = crete_message()

                    # send request to discord channel
                    payload = {'content': message, }
                    header = {'authorization': discord_token, }
                    print(payload, header)
                    response = requests.post(chnl, data=payload, headers=header)
                    print(response.text)
                    if response.status_code == 200:
                        delete_wallet()

        except Exception as err:
            print(err)

        random_int = random.randint(7300, 7500)
        print(f"Sleeping for a {random_int} seconds")
        time.sleep(random_int)


if __name__ == "__main__":
    main(channel)


