Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765AA15687B
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 06:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713940159; cv=none; b=Cuu07BRp8EOCbSLTMIZF1zYYguMqkuCSLlENwrcDkxXCuFt0+CI2tCXuZziVx/3N1W+4txMrI6Apcj5GTqPwrQIleC4q9RUpN4UR91NB/J45Cl8BJvuVEuEnK4ozTCY0nfs6xlCD/yXOhf6q4UKHZBr5QSSQEYmDeWfkvJjKAuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713940159; c=relaxed/simple;
	bh=rNzymUhZlR5TWL8Kob2LzdNKa7LLakz5e3PB8aOi6NI=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=SJw4OoU16g836rFO46O1LxAp7zv0pvSh+e7JzWwR4Zw+A0qpwvc5xfgGWBZvpwom1/lzuCUOqaw8VW4ThfE/iDW9babJWZvE5ciDOs2aQAdl69MGiqxcW5MXnPfhI+nfctnbWgwhfZyI6ZtFO+MF2r3dUWeAz01yaA/r/vzugSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PTyfYdAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PTyfYdAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3A2C113CE
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 06:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713940159;
	bh=rNzymUhZlR5TWL8Kob2LzdNKa7LLakz5e3PB8aOi6NI=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
	b=PTyfYdAgDWqHjSU6jb8HBHCCdIr65jCMPBefLEsccf6aJaocLwpdnzn0UUmqv3bg5
	 JmF4xDF9gkQuDNbD6eBD0lzv8OLSK06JGS8WS1/R3N7yFMe+RFILy6cz1RfMIw/mR7
	 XPVHGfTiiYcnRKsZrFTC4DwXG/Nf7DFkrWLND7fqb6ulAEUpih955tSl2SZ56+xi1s
	 Zf5BemFCUB+QAHN54FAvHn1JlGjXZCFKKxbdO0n859Ej0kjMh7VDRrmyHzyr4fdLFc
	 PCMb8kxEBu+yuQ4TJzGffWqduHzCGNVzZuoAwx0kwD0Nf7vqAqPjrgXuPKyOrgTaLN
	 C6RptfCsdq7Mg==
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfauth.nyi.internal (Postfix) with ESMTP id E863D1200032;
	Wed, 24 Apr 2024 02:29:17 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Wed, 24 Apr 2024 02:29:17 -0400
X-ME-Sender: <xms:vaYoZjiJ_CaA4rSuThfw4dSIZlVw9sGC83ef-EsV-ILt-U55q-rTtw>
    <xme:vaYoZgDZZNTJEcqpD1ULQcM4NkuhhoOQT7Cleln04ngH7Z7fiOlMCxpHH20zn3-h9
    TRy1KoEQah1ETd5DDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudelvddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugeskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpeelvefgudeiheefledttedthfffgfekudegkeelffdtiedvgfevieet
    teekheffveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhguodhmvghsmhhtphgruhht
    hhhpvghrshhonhgrlhhithihqdduvdekhedujedtvdegqddvkeejtddtvdeigedqrghrnh
    gupeepkhgvrhhnvghlrdhorhhgsegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:vaYoZjG9Rg2cULoJC9XYy1NTLeh6CFdZ0GT27Czhwp4Fgyx8rUYTwg>
    <xmx:vaYoZgQAKGFWjnOSwhmgPoCuf3eJmsPNFu7bnY886Ti6NUFr4n9ZFg>
    <xmx:vaYoZgxe_wWnzXsnrm7-UjuAPBfkxsNzdC2aFbikd1tigEdz-EhUaw>
    <xmx:vaYoZm5vMJjleR0SBQpA8rW6aFWadlJF2YUMVCm1TFueGM1y6hDTiw>
    <xmx:vaYoZlzXweBBsJ5LtnbeUhmeKZrIRVKE5EmGenKjm4EYHmGvFVHltR9R>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id AD03BB6008D; Wed, 24 Apr 2024 02:29:17 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-386-g4cb8e397f9-fm-20240415.001-g4cb8e397
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <eaffa3e6-9ef7-4352-8da2-8be633f5741c@app.fastmail.com>
In-Reply-To: <20240423213855.550710788@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
 <20240423213855.550710788@linuxfoundation.org>
Date: Wed, 24 Apr 2024 08:28:55 +0200
From: "Arnd Bergmann" <arnd@kernel.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Niklas Schnelle" <schnelle@linux.ibm.com>,
 "Sasha Levin" <sashal@kernel.org>
Subject: Re: [PATCH 6.1 072/141] usb: pci-quirks: group AMD specific quirk code
 together
Content-Type: text/plain

On Tue, Apr 23, 2024, at 23:39, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Niklas Schnelle <schnelle@linux.ibm.com>
>
> [ Upstream commit 7ca9f9ba8aa7380dee5dd8346b57bbaf198b075a ]
>
> A follow on patch will introduce CONFIG_USB_PCI_AMD governing the AMD
> quirk and adding its compile time dependency on HAS_IOPORT. In order to
> minimize the number of #ifdefs in C files and make that patch easier
> to read first group the code together. This is pure code movement
> no functional change is intended.
>
> Co-developed-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Link: https://lore.kernel.org/r/20230911125653.1393895-2-schnelle@linux.ibm.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I see now you had it for 6.6 and 6.1, so it has the same
problem as the other one, with the dependency on fcbfe8121a45
("Kconfig: introduce HAS_IOPORT option and select it as
necessary")

    Arnd
