Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D38015C85
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:28:02 +0000 (UTC)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 6E2AE5C0127;
	Mon,  5 Dec 2022 14:28:01 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 05 Dec 2022 14:28:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1670268481; x=1670354881; bh=mHtNhyPT9C
	5k1Pmkr5H8a4klZ3diL+/oZ5nlHURWZYs=; b=r+97+fp3so+TqnYuanJlm0Vhzp
	L2Fv0ddW8FEYK5HqaQkRZy8fWSDNOkQI5J+wUv65V33ZYg6l2RemBljWz35WNXh8
	8fFlVzJQIFCoP2v4kAdR//1Q2jK1ELkfPpGsC/bp5sBunutgyR3NeKBKXCNgIQkd
	3z9Ly53bnlEEBIH361i6zrla5InkYi9/mDRzz97qqMKtvyAdLpw+YCqWO4AhfPZP
	o65MWYgyuDBCWMPdDl5akxeX/wYKGUVlzrw0ZX2UMEu0MUiYDyRDQes3Oz/u3AGk
	x/c+7JyIRTJ/cp0Z/xWLHMJ0rP9YLMdFw5ycm44D/n4ijnDdna+lpWUk/z+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:sender:subject:subject:to:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1670268481; x=1670354881; bh=mHtNhyPT9C5k1Pmkr5H8a4klZ3di
	L+/oZ5nlHURWZYs=; b=gWhpvOoLRUpLxlF5YEEUdpqPE7nh1AgzZzXnykNNxyeI
	6POz6tdrZhIaeBw0uEzvwktOgOLAu0GrDKTis6H6F5FMqV72YCqOz+M6RaZQmXNC
	pClYQ0Iq3PvD/MadvrR8jdWeM0djADvdEzTnKWgHbtje4MhI4CCEPLvl2dRKiAg2
	Dpgd9CVKiqQV+Qhpt/Ob+fIDCQ7KYaJZpDMtffUTjXhz8sCiUbm5a4Czo1T81CX0
	oPmIa5FirZ212+Su81Al9AH5FDeTawpmBU808Ur9LvfH7lobYR8IxR71gpNEpY3B
	rZd5467A6tJGt22aOV5wuR8gc9HPXnH2gU8DRFLQYw==
X-ME-Sender: <xms:QUaOY84_oN14rvuOByuBLWLl9w6ZMmDvyNx5t8SycOfLsmOOJwJc7A>
    <xme:QUaOY95abBSo1A_AynYI5KLddggFcaHPFhBXoompTyWIuPF0TZGCRUlxeNNJQxXDZ
    Rbh4POqNnzyLy64aHM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeggdduvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:QUaOY7d8zkucmgtTCYKbf5_dbDJ7F25P6XkCgRxzTCxbVJWd4a07jg>
    <xmx:QUaOYxLwjrpQNX26b8Ro4n3YdgSdENte8E62RTofrNEXPvGYbl9NQQ>
    <xmx:QUaOYwIoaAN6_yHD0jdiUn8rVRjNCTNWPII5OjFKN9xxSa-HusyHQg>
    <xmx:QUaOY1H-5G9H1v5_QKiXelJDn8Fki4IxZi0BspD13r1VlIB6fyqLEQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 1B24DB60086; Mon,  5 Dec 2022 14:28:00 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-Id: <dfa8305f-f52f-4322-a22e-9a1e90fcfad4@app.fastmail.com>
In-Reply-To: <20221205190806.296201818@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
 <20221205190806.296201818@linuxfoundation.org>
Date: Mon, 05 Dec 2022 20:27:40 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>,
 "Christoph Hellwig" <hch@infradead.org>, "Helge Deller" <deller@gmx.de>,
 "Sasha Levin" <sashal@kernel.org>
Subject: Re: [PATCH 4.19 094/105] parisc: Increase size of gcc stack frame check
Content-Type: text/plain

On Mon, Dec 5, 2022, at 20:10, Greg Kroah-Hartman wrote:
> From: Helge Deller <deller@gmx.de>
>
> [ Upstream commit 55b70eed81cba1331773d4aaf5cba2bb07475cd8 ]
>
> parisc uses much bigger frames than other architectures, so increase the
> stack frame check value to avoid compiler warnings.

I had not seen this one originally, commenting on it now:

> index 9ded3c1f68eb..556aae95d69b 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -224,7 +224,7 @@ config FRAME_WARN
>  	range 0 8192
>  	default 3072 if KASAN_EXTRA
>  	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
> -	default 1280 if (!64BIT && PARISC)
> +	default 1536 if (!64BIT && PARISC)
>  	default 1024 if (!64BIT && !PARISC)

1536 is a /lot/ when we're dealing with 32-bit platforms.
My understanding of the parisc overhead was that this
was just based on a few bytes per function call, not
something that makes everything bigger. We have a
few functions that get close to the normal 1024
byte limit, everything else should be no more than
a few hundred bytes on any architecture.

Could it be that this only happens when KASAN or some
other feature is enabled?

If this happens for normal parisc builds without any
special compilation options, that would indicate that the
compiler is very broken.

     Arnd
