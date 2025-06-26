Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45A229617A
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 08:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750928380; cv=none; b=kVKnD4wdqXToEG9UTfc0+srABmNqaJwdQzcaLa70Sfg61YZ2tvNekHV1b0PFZgjJG3046rugQCifFj8R+5obwwyAJTSrwM0IOEJx2VHs5yDgl+QNRl3sXRpsRTUDBsU7UmrOeRL5PhHCcy7F1aiWGPspgCWgIlFFB6h7tSFesic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750928380; c=relaxed/simple;
	bh=aBl0QIuDVXqWQ1gVsSGkKN8r3eIUjjET6iE1LlcQ2D8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=i0eBoNXRWfEg67UEdXTnrkFLu9+N02PzkZV/NyBLNsqCmEYb76ADK6yNVmn+QBwgsUSDXqzuKsPSQ84R5xMDV3VMElKgEd6x4p9dg6xw6Dt44Y7Gph5JsTY4tIh1JIQm7OijIrnZ9jjrMstCPSU8a+l5J7a9155AwdGJSGuKuOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=nst+KXhL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZqPnWj3T; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="nst+KXhL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZqPnWj3T"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 96AF87A02BE;
	Thu, 26 Jun 2025 04:59:37 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Thu, 26 Jun 2025 04:59:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1750928377;
	 x=1751014777; bh=drwBUjTKqDmvGvM3SVRsKqApsIIca2T/4d08mRhDSGg=; b=
	nst+KXhLIcDo/slOZ1gKYGZLu3V32TzYeJR0EuiYkIRG/+89BCWE1NJuEyFwCwGo
	aa/l6tgbsa1oHNuQG/85la5YOfetGRgY0YLn0l3VzDgcRWGdGnv37zb37o3C0Ghm
	RA1tF0wuyuZdAO82xZZFE6pvfNwRc18XzHXYGveoHOT8NHLU5n30OhImczw08JcH
	Ze3MxtAaXdM12DEWVsVCR7cRGxNnAtN0fyZ5OZPewsGwU+Dq9fU+KSohx9ToIYvO
	0uHqKV01YiZoJjbiqFjHRtoLb+/PBv9U/kATq4DeFPW0+jvcbTxWCC1wWyAFqupx
	bd0IgC6TJfMB0XVJhnMAVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1750928377; x=
	1751014777; bh=drwBUjTKqDmvGvM3SVRsKqApsIIca2T/4d08mRhDSGg=; b=Z
	qPnWj3T5jTPaxStHDAHOkvgUOUHI0hdIxVu4xlfvoiwwxXNPMJdbij2qUE4/MyVI
	VFbnrr5X6eiYK3621CYVHUVNq4wQ3tbdztD5v4irqAzG/GfA0C2ZgxjEAwJCl7xq
	PhAjfJvifAdG1IYZKiLs1fMhxvvy9zhYxfZqdYNk9PDpEIKvF1NIngCqYLvSHfIs
	nYi2fhfHW2qlPb2yPViyUwiwzUrzm+ZRx2vti4mY/Da/O56U9gIoiBn31fQtBDo2
	bJ2ScAkV2OqeGthl1SU5uQae3z3tTv4HjlHV28Kjz0Px0bvc5WLNp7rcxObx/D6F
	vrdHIrVq9qzgbdFAuoZjg==
X-ME-Sender: <xms:-AtdaMhkshihAAodqPEVDmF9A9yrrw81J2HMUSzDJmm0lEaLib4qQA>
    <xme:-AtdaFC11mrtCTBMuEmF4sk8v9IbzAPGcKpFmhFDrI9nCSdaQPFV0l6Pd7P-Rh5vz
    1jiAGbewLbXTyP-0-Q>
X-ME-Received: <xmr:-AtdaEFrceHXvJhLRG8J2npU5B1RB2TclpAerYrHotPNfON-ltBgxIZ9vI9RTCD-akSQTAk7lEQ8shoBY1e609bpIw5O-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddvgddvhedvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuhffvvehfjggtgfesthekredttddvjeenucfhrhhomhepfdeurghrrhih
    ucfmrdcupfgrthhhrghnfdcuoegsrghrrhihnhesphhosghogidrtghomheqnecuggftrf
    grthhtvghrnhepffejveffjeevvdeuueehfffhueevveejgeeuveeguedvveevieejudeg
    feduueetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsggrrhhrhihnsehpohgsohigrdgtohhmpdhnsggprhgtphhtthhopedvuddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohephhholhhgvghrsegrphhplhhivgguqdgrshihnh
    gthhhrohhnhidrtghomhdprhgtphhtthhopehgrhgvghhkhheslhhinhhugihfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehprghttghhvghssehlihhsthhsrdhlihhnuhigrdguvghv
    pdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdr
    ohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtoheplhhinhhugiesrhhovggtkhdquhhsrdhnvghtpdhrtghpthhtohep
    shhhuhgrhheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:-AtdaNR8dmbI2n-K7oSWtVLoBHB648cMiMgHmYpxyPzONwWDydMh6Q>
    <xmx:-AtdaJxiTTyT89K5_X_ryMgNsvDzDXgtK9YZUMSLGFvU6SEYLvbQNQ>
    <xmx:-AtdaL7AQeRQbsO793UjogxaM5Px109G1KX6FFmvOWQHB_DNb3Ve3g>
    <xmx:-AtdaGxW7yhHDFvr3KnGFWV00aJ_blsJID_kzCr1unHYrBrqB7VG5g>
    <xmx:-QtdaHI1Cv5gM3zyHuVHod4flfasyp4Aooedm-0KLu2gSpZkS6VdGkKL>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Jun 2025 04:59:33 -0400 (EDT)
Message-ID: <7069cc77-a224-4753-8088-0302fc444710@pobox.com>
Date: Thu, 26 Jun 2025 01:59:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
From: "Barry K. Nathan" <barryn@pobox.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org,
 Christian Brauner <brauner@kernel.org>
References: <20250624121449.136416081@linuxfoundation.org>
 <e9249afe-f039-4180-d50d-b199c26dea26@applied-asynchrony.com>
 <2025062511-tutor-judiciary-e3f9@gregkh>
 <b875b110-277d-f427-412c-b2cb6512fccc@applied-asynchrony.com>
 <6d3b0f28-98cb-46dd-b971-8a11e3b69d68@pobox.com>
Content-Language: en-US
In-Reply-To: <6d3b0f28-98cb-46dd-b971-8a11e3b69d68@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/25/25 05:15, Barry K. Nathan wrote:
> On 6/25/25 02:08, Holger Hoffstätte wrote:
>> On 2025-06-25 10:25, Greg Kroah-Hartman wrote:
>>> On Wed, Jun 25, 2025 at 10:00:56AM +0200, Holger Hoffstätte wrote:
>>>> (cc: Christian Brauner>
>>>>
>>>> Since 6.15.4-rc1 I noticed that some KDE apps (kded6, kate (the text 
>>>> editor))
>>>> started going into a tailspin with 100% per-process CPU.
>>>>
>>>> The symptom is 100% reproducible: open a new file with kate, save 
>>>> empty file,
>>>> make changes, save, watch CPU go 100%. perf top shows copy_to_user 
>>>> running wild.
>>>>
>>>> First I tried to reproduce on 6.15.3 - no problem, everything works 
>>>> fine.
>>>>
>>>> After checking the list of patches for 6.15.4 I reverted the 
>>>> anon_inode series
>>>> (all 3 for the first attempt) and the problem is gone.
>>>>
>>>> Will try to reduce further & can gladly try additional fixes, but 
>>>> for now
>>>> I'd say these patches are not yet suitable for stable.
>>>
>>> Does this same issue also happen for you on 6.16-rc3?
>>
>> Curiously it does *not* happen on 6.16-rc3, so that's good.
>> I edited/saved several files and everything works as it should.
>>
>> In 6.15.4-rc the problem occurs (as suspected) with:
>> anon_inode-use-a-proper-mode-internally.patch aka cfd86ef7e8e7 upstream.
>>
>> thanks
>> Holger
> 
> For what it's worth, I can confirm this reproduces easily and 
> consistently on Debian trixie's KDE (6.3.5), with either Wayland or X11. 
> It reproduces with kernel 6.15.4-rc2, and with 6.15.3+anon_inode-use-a- 
> proper-mode-internally.patch, but not with vanilla 6.15.3 or with 6.16-rc3.
> 
> By the way, my test VM has both GNOME and KDE installed. If I boot one 
> of the affected kernels and log into a GNOME session, I don't get any 
> GNOME processes chewing up CPU the way that some of the KDE processes 
> do. However, if I then start kate within the GNOME session and follow 
> the steps to reproduce (create a new file, save it immediately, type a 
> few characters, save again), kate still starts using 100% CPU.

After some testing and bisecting, I found that "anon_inode: use a proper 
mode internally" needs to be followed up with "fs: add S_ANON_INODE" 
(upstream commit 19bbfe7b5fcc) in order to avoid this regression.
-- 
-Barry K. Nathan  <barryn@pobox.com>
