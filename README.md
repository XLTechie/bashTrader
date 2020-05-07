# bashTrader

Basic Alpaca trading API access from the bash shell

## What is it?

A console, and related bash tools for trading (on paper or for real) with the [Alpaca](https://alpaca.markets/) brokerage.

## But why?

Why anyone other than me might use this, I have no idea.
Why I made it, however, is easier to explain.

As a blind guy desiring to day trade in 2020, as I used to do with mobile web interfaces several years ago, I looked around for a brokerage with accessible trading software. Unfortunately, I didn't really find any that I liked for various reasons.
I always liked building my own trading interfaces anyway, and I really prefer working at the Linux console (whether on a dedicated machine, or in WSL, or via SSH on a cloud host). So I decided to use [Alpaca](https://alpaca.markets), a company that is designed for people who like making their own interfaces, doing algo trading, etc.

It was my intention to develop a Python based trading interface, leveraging some of the existing code and libraries that are out there. However while I worked on that, i wanted a simple, straight forward, no frills, easy to implement, manual trading interface that would let me do basic account tasks, and place orders (and related things).
I wouldn't need micro-second execution (as if I would get that with Python anyway), or streaming quotes, or any of the, well, frills. Just basic account and order management.
As a long-time system admin, my philosophy has always been: you use the tools you have to hand, and that you can work with most rapidly. For me, that's bash, and the dozens of Linuxish and Unixish tools that are always available on any system I might want to use.

So while this is not, as we say, ideal, there is every probability that it will work, and solve my immediate problem, while I work on the real long term accessible day trading interface that I have always wanted.

## How to use

1.  Copy the files in the "scripts" directory to a location on your path (such as ~/bin), or add the "scripts" directory to your path in .bash_profile or similar.
2.  Copy the file ".bashtraderrc" into your home directory. That location is hardcoded currently.
3.  Edit ~/.bashtraderrc, and change the key values accordingly. **NOTE! this file is just sourced directly. You could put any commands in here. These scripts assume you trust yourself not to do that.**
