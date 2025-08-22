Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8777A27F724;
	Fri, 22 Aug 2025 20:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755893062; cv=none; b=GCqRmVR/66hadlaxKSjHxs5sii1kdfJTMb4wYu/s4SsgnReDzGkRLu3B0c1egAWONJFC8wXAqA8gDDA/TYCDKkk2oJBF57czgfPafsJo6SOyaaDUzs4k8Eb1EiB2opEh1WLf/1jRZfy4WtikGVbrmT9b+EqpN0R06Qilgz4iY7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755893062; c=relaxed/simple;
	bh=S+ZbtUWMKAkpRyRiegOe1/MVHDgacB6bJNDByLQ5Vis=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=SGJ5CMaqKxpZZbXakSC07WBZOgO8tqsUgucK+CXCSTbrLbhaSVo4QQWcxkXtvn5ewIkYb4Y97VSHiqwbsDKD0yidr3S/LJXwPVIsD7vH18R/w++uO9Fb75fxuBxG/120g0e5TOkZ8Tep61E6Qw6xHYYxmitZThqaSxEUDgOcpiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=g1HofqZ1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jIbf9X5l; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="g1HofqZ1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jIbf9X5l"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A9F2514000AE;
	Fri, 22 Aug 2025 16:04:19 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Fri, 22 Aug 2025 16:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1755893059;
	 x=1755979459; bh=SaguppChqqh0T3xpb1iPjntc9UQEFriFZKmZ9cwC9rw=; b=
	g1HofqZ1FDkxUX1EN10UhfQGTZutikf2NWBS6Fue54TEvPvQ6nzLwnCc2IRCVzH0
	8t2nKxn8StykNSAkWVdV9eHkM+tHyzzKheVf2a5KIP+tecZfbMZ+v3nstCZ0J5pn
	tsl4myo3vg/lVTcIsJaCMagtILlEXIAdOjtwbIKmmvC4yFe6sKBg7MkKmLdde0Sz
	Yeh/L8gio2HD3li8KzCN+/53zV4/+CcXt3FKpqTTZyUzyAzWDVFXCz2G9lRlzDe7
	k2cAFx5o7vQkc/9MCmK2m3iIbLuc8tMSooAd0S2rAqFKSm7bCQZOjt03xcMwh5Pl
	DEOz6Kcco5JaJymytwLATg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1755893059; x=
	1755979459; bh=SaguppChqqh0T3xpb1iPjntc9UQEFriFZKmZ9cwC9rw=; b=j
	Ibf9X5lh8TR650uFXOODimISurb4xpv088prDwV9ZAS9oGbougdOHqkX5bYoznxk
	qXaOJRWxsI65pLnE0+O5wuFXlQK+8e47SePDLXcJFVy+UCtijV4B4OBdEkFGltK/
	IbNdxDPh/DmXaSSAyc4pAm+ZvojjErnSAtJUGLYBboCG7v1BMvPLJb7sWxyPbBBo
	czjr3abbJxYMSIFjnpZhH8NE1kyAlwoepjeZY1gP8YE3TZ/WqPLEp2aC+VIZHjxE
	SAi49yWhj7UeIfpCLJWXceBx8PG1RhsVdW4jcvlF0JZsf2ZrDx2IFWX07h0rrofv
	xgS1c5c7opPvmJXLyHfOw==
X-ME-Sender: <xms:Qs2oaBBCQ5nGFOoSjO12zz5OYcJaDdGHkSOCvO_JpaqkKggUGZuOlw>
    <xme:Qs2oaPics73hU5YQZEMZ7MrhMPoyzd77FuWf3sgHyZVN8KDX8SWWLSBjeIGhrDaQL
    5_cxYdJtUYqALLhc5o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduieegieejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehlihhnuhigsegrrhhmlhhinhhugidrohhrghdruhhkpdhrtghpth
    htohepnhhitghkrdguvghsrghulhhnihgvrhhsodhlkhhmlhesghhmrghilhdrtghomhdp
    rhgtphhtthhopehjuhhsthhinhhsthhithhtsehgohhoghhlvgdrtghomhdprhgtphhtth
    hopehmohhrsghosehgohhoghhlvgdrtghomhdprhgtphhtthhopegrrhgusgeskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehnrghthhgrnheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghr
    mhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoh
    eplhhlvhhmsehlihhsthhsrdhlihhnuhigrdguvghv
X-ME-Proxy: <xmx:Qs2oaPPD2S6KJfQtNZgDcowAtXw04HSqI8xCnJFShDtl17oTGvZJRg>
    <xmx:Qs2oaEbOYcCUOVWh2VjTu6m10E1cYvef1KVSLGEWxc8HOHjizcINqw>
    <xmx:Qs2oaFw26veJtsO_bqhobENtqgct64Mx-DPN1pMM9436UwSzIT2a7g>
    <xmx:Qs2oaLPuT13pzeb7gpX_2aJSeob9VEvZK3hVJtia2LFFG__TRjSAvA>
    <xmx:Q82oaKKCM-_-8_w54zVC7rl7DcirIJmCco6POS4dq2-9zUlwnpyYopT0>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D430A700069; Fri, 22 Aug 2025 16:04:18 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AlhDZOV2HdTF
Date: Fri, 22 Aug 2025 22:03:58 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nathan Chancellor" <nathan@kernel.org>, linux-kernel@vger.kernel.org
Cc: "Kees Cook" <kees@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 llvm@lists.linux.dev, patches@lists.linux.dev,
 "Russell King" <linux@armlinux.org.uk>, "Ard Biesheuvel" <ardb@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Message-Id: <6b2c0063-1523-4644-a32c-6aa918ad9dd8@app.fastmail.com>
In-Reply-To: <35178205-7cff-4b4b-abdd-b4cfb9e69dc2@app.fastmail.com>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
 <20250821-bump-min-llvm-ver-15-v2-3-635f3294e5f0@kernel.org>
 <35178205-7cff-4b4b-abdd-b4cfb9e69dc2@app.fastmail.com>
Subject: Re: [PATCH v2 03/12] ARM: Clean up definition of ARM_HAS_GROUP_RELOCS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Aug 22, 2025, at 09:05, Arnd Bergmann wrote:
> On Thu, Aug 21, 2025, at 23:15, Nathan Chancellor wrote:
>
> Would it be possible to either change the macro or to move
> the overflow_stack_ptr closer in order to completely eliminate
> the CONFIG_ARM_HAS_GROUP_RELOCS symbol and have VMAP_STACK
> enabled for all CONFIG_MMU builds?
>
> Are there any other build testing issues with ARM_HAS_GROUP_RELOCS
> besides the one I saw here?

With some more randconfig testing, I did come across a few
configurations that each fail with hundreds of errors like

arm-linux-gnueabi-ld: drivers/crypto/hifn_795x.o(.text+0x99c): overflow whilst splitting 0x10a61854 for group relocation R_ARM_LDR_PC_G2

so I guess we'll have to stick with the current dependency,
at least for ARMv6 and below.

    Arnd
