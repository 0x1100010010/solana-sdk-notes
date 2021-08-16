#!/bin/bash
solana config set --url https://api.devnet.solana.com && echo "URL configured to: https://api.devnet.solana.com"
solana-keygen new --no-bip39-passphrase --outfile ~/.config/solana/wallet-keypair.json | > ~/.config/solana/wallet-keypair.info && echo "~/.config/solana/wallet-keypair.json generated! "
solana airdrop 10 ~/.config/solana/wallet-keypair.json && echo "Airdropped 10 Sol in ~/.config/solana/wallet-keypair.json"
solana balance ~/.config/solana/wallet-keypair.json | xargs echo "Wallet-keypair Balance: "
solana-keygen new --no-bip39-passphrase --outfile ~/.config/solana/validator-keypair.json | > ~/.config/solana/validator-keypair.info  && echo "~/.config/solana/validator-keypair.json generated! "
solana config set --keypair ~/.config/solana/validator-keypair.json && echo "Set validator-keypair as default "
solana transfer ~/.config/solana/validator-keypair.json 1.3 --allow-unfunded-recipient --fee-payer ~/.config/solana/wallet-keypair.json --from ~/.config/solana/wallet-keypair.json  && echo "Transfered Balance to validator-keypair from wallet-keypair"
solana balance | xargs echo "Validator-keypair Balance: "
solana-keygen new --no-bip39-passphrase --outfile ~/.config/solana/vote-account-keypair.json | > ~/.config/solana/vote-account-keypair.info && echo "~/.config/solana/vote-account-keypair.json generated! "
solana create-vote-account --authorized-withdrawer ~/.config/solana/wallet-keypair.json ~/.config/solana/vote-account-keypair.json ~/.config/solana/validator-keypair.json && echo "Created Vote account from ~/.config/solana/vote-account-keypair.json"
mkdir ~/.config/solana/log && echo "Created Log Dir"
echo "Executing Validator..."
solana-validator \
 --entrypoint entrypoint.devnet.solana.com:8001 \
 --trusted-validator dv1LfzJvDF7S1fBKpFgKoKXK5yoSosmkAdfbxBo1GqJ \
 --expected-genesis-hash EtWTRABZaYq6iMfeYKouRu166VU2xqa1wcaWoxPkrZBG \
 --rpc-port 8899 \
 --dynamic-port-range 8000-8010 \
 --no-untrusted-rpc \
 --wal-recovery-mode skip_any_corrupted_record \
 --identity ~/.config/solana/validator-keypair.json \
 --vote-account ~/.config/solana/vote-account-keypair.json \
 --log ~/log/solana-validator.log \
 --accounts /mnt/ramdrive/solana-accounts \
 --ledger ~/.config/solana/validator-ledger \
 --limit-ledger-size

