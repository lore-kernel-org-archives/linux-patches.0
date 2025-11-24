Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888532FFF9F
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 12:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763988187; cv=none; b=MFh2L95UYdYDMbWNXyBHdVnM4bSY0LTfiY0Ld5PbMXI3npCGNbKHWpERHsc0v09b+qXavX3e3lq6DkMPveO0CBuHYbNXj3sKxwX81WhJFTOLEWJGi0syTpF4pBTVXigJMlCgfrPlY4D109MlDrhZXo71RpQj4S9zk8O81wUP5o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763988187; c=relaxed/simple;
	bh=cZyOZOJZSvIf+VhsUz5jNXcpXRYig7R9ZoC+XLlJu9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3SI2rSk4EqjQtdZ6/Daqp9eu8tOw5EJ2h+XmuXN/HWEJ/mlNKYk1qubuO7rrcS/kcfZkUvzH3/0OVdhmRMl7PpcigrAv+CmtrJzRhwQd3rMRhrKDWWLJuNnUeka8bThmRS/Pjks4HckdM7uiJrwdgGrvECYF2UkswrIU6TjM8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=JPkcjyMb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=g/1/rsti; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="JPkcjyMb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="g/1/rsti"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 350CB7A0056;
	Mon, 24 Nov 2025 07:43:03 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 24 Nov 2025 07:43:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1763988183; x=1764074583; bh=mmoBQzwvGE
	b2PH+mGYV/p7dJAQNsJjas2weBraCbKiI=; b=JPkcjyMb3oY2c8ilphTZoVWtC+
	bMDnO0U6H/QqbY8EUl215WYjWPM4SlMx2rXf5Y8+N+R5YyhyM8hybtrNzsGdfMHr
	OVU5mVDnUutttOTjWmdJKYDJjwsMqygPNAoK3iWwj71gretMZMMC2NwWKvvUiq70
	5FhWJMhNFNGpnV5aZy2e05QxFy9xeqZvn+hrw+KwIJxvTaACbtlgEDTZYg27ukug
	oKJL3FXowfDnFL+OncA3S0pK7ZOp10NdiTT7kmM/bxPBVxcxGtaVyQzSTqBxQCon
	DqwDGUNV8FmGOZoTUDck2Wl4KWKbqLU3CcTofv/Uz0XMHd9Y0pn6W+jUV37A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1763988183; x=1764074583; bh=mmoBQzwvGEb2PH+mGYV/p7dJAQNsJjas2we
	BraCbKiI=; b=g/1/rstiKw0s2YXehObKW9pvuIJmCQSw8PjW4kKXGwYUygO28fv
	iUC6Ja/3OdXooXK1Rbcc1RoVPtckxt8S2P1TQklho7vi8h51eOZV+KXOMs5wKcue
	+2Gr7iNj0CgHooQiwcZNgIpZ2o6TMN7zVB1wFlFh1djgUa8cTydNMu9mBCuvoPF1
	cUtREvWV5DYOmxdYMdmcCJg3GSgtcIR2mz1ZFjti+aCS8LuI2Ap/t2G9aKMtiFIs
	UsdGq6JiIldRIkecBEuMNWguDN9OP2AAUFZTPYc1p3rW846QctYbixDmR9xcRhg0
	c8uwRrX5GtLM5vKOUN170F4ue8ZZZ/Mna9Q==
X-ME-Sender: <xms:1VIkaUX8JVxpzXRL5mAt4No8Swxira4dFsCRsMuC_5-KEmxQ_WJc_w>
    <xme:1VIkaUe2cZ5ivmiXNwWKPUBWZN-wVBNkNXDITBSOaH8ZCCqmJz5c8RRYJQ1E3VDly
    Mzfr4h-v5Yy7zqxs9dUL1gEo6AmRm0G7S37-Z2jUn-PEdEsmfyoNg>
X-ME-Received: <xmr:1VIkaT5NtkQsFMKsQfknQAeDasFD6Ibyr-88K6mBmKCjHwSKhqxv4c4QlrFcitkqZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeekieefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesghdtsfertddtvdenucfhrhhomheptehlhihsshgr
    ucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepudfgie
    euhfehfeffhedujeffjeekjedvhefhtedtgeffgefgtdfhueehteeuvedunecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehhihesrghlhihsshgrrdhishdpnhgspghrtghpthhtohepvddt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrtghhihhllhesrggthhhilhhlrd
    horhhgpdhrtghpthhtohepphgrvhgvlhesuggvnhigrdguvgdprhgtphhtthhopehfrdhf
    rghinhgvlhhlihesghhmrghilhdrtghomhdprhgtphhtthhopehsuhguihhpmhdrmhhukh
    hhvghrjhgvvgesghhmrghilhdrtghomhdprhgtphhtthhopehrfigrrhhsohifsehgmhig
    rdguvgdprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopegtohhnohhrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehshhhurghhsehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehprghttghhvghssehkvghrnhgvlhgtihdrohhrgh
X-ME-Proxy: <xmx:1VIkaXSBn1cUb4X9EoQTQ_eS3-wPkjyHVQ179ZI10rcKk8vj8iOGmQ>
    <xmx:1VIkaWcPlAeTLCuXk-yynXUejlG67WEWmESXLYH4FSlnhhLY9jxLDA>
    <xmx:1VIkaXSvMIXq1jIPqGxHHqW5DRYRUoC5QgagJpJaKQ0HStFBQg53Xw>
    <xmx:1VIkafMNF9RN_3PgDn4cU2rV5GXqrVIetSR-dwYM5853goMd-RgKFQ>
    <xmx:11IkaV3mrbw7LUf8VKCOrMf9ZxTwEQjWDWCu_daYoXPd6ajCIpvtOEMB>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Nov 2025 07:43:01 -0500 (EST)
Received: by fw12.qyliss.net (Postfix, from userid 1000)
	id 541C623D0DD7; Mon, 24 Nov 2025 13:42:45 +0100 (CET)
Date: Mon, 24 Nov 2025 13:42:45 +0100
From: Alyssa Ross <hi@alyssa.is>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
Message-ID: <3tcx6726usvheymmskqlukl4te2zf5slctcgeofuvmv7x2sepw@m7mz34o6zqh5>
References: <20251121160640.254872094@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="33tp4lknzr2a4gtk"
Content-Disposition: inline
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>


--33tp4lknzr2a4gtk
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
MIME-Version: 1.0

On Fri, Nov 21, 2025 at 05:07:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Nov 2025 16:05:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Confirmed the virtio-net fix works as intended and the rest of my tests
pass on aarch64.

Tested-by: Alyssa Ross <hi@alyssa.is>

--33tp4lknzr2a4gtk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQGoGac7QfI+H5ZtFCZddwkt31pFQUCaSRSwQAKCRCZddwkt31p
FXHNAQD4cxLMcV3tguG+gHm8k3KrRab7P7ap0TyBzWnyIlDCSQD8D1xe2q6vUPXh
PTBAnUF6khb4v1GJBksIrmacsB4iEQY=
=1iqj
-----END PGP SIGNATURE-----

--33tp4lknzr2a4gtk--
