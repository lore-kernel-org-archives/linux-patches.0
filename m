Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AB7361DA6
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 16:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228869; cv=none; b=sC4c3a8AQMcmBufwKAKiKv3syqiP2dtr+MpyD0lrfrI+EZMsGBLVk0ojSlF0CQqLX3FYtk2RJFPVCtc55brZ56UqKfufu4lA/Aj72pkvPn/FncpwQfNBBgIiZEuZEEt78OpxSOXboSAeXkZiL6HRjQac4jS4HnMY73eudNGmdQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228869; c=relaxed/simple;
	bh=RTengPUlvLmRdUP5NzyYlvRKen0d6MV6AWR7D9r0gZA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=X177cEBI5UJUbDF1qHxoy2WrWt2kvDW0n2LkCv4C9vVCaCymr0KH2v+xMURJbrDWzT5/2V1+gKfAJNFkRDB43oaEgkMqSxaIKpquolYi2syxgUkdTnKtoRlZneQneFP9yRXGsCqbSXTNhJ8m3GYzZj/NOFc/tDPvUI7JW/6XmdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=MJf5d7OF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZFXFB8kd; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="MJf5d7OF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZFXFB8kd"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 702A37A00B7;
	Sat, 12 Sep 2026 12:01:06 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 12 Sep 2026 12:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789228865;
	 x=1789315265; bh=V5xJd8B3IpWlfEW6J8MbgoLw1q6mG3i9WCDPi5DnGJo=; b=
	MJf5d7OFPExaoYYQI0gedrwsIHLgYmLMVSv5amJ+B9LMZAmeI6I2jeK/3KWetqoY
	g+3u+hp7GuM9i3x2M8OebsvE6HbUwIuvFn+dMVIv74e/X+Mlx0r3QbEAYWLhXl+y
	yEtm4dnuNQ350pEhjWBYb0L1XKR61XGq8CRLYpH/s36BC+FEN5EhgNHuhAptW1X2
	qnNeiCUW8PvSvXhQUEs3ryAjlu9D1QrHWpyNW4KzAc2jkElOAgi6msDsJMb0fht7
	jeqEhXO4MLNVrNzc4Op/OnwaSnNIVr8SShpKD8E9BlNOqW+DUUWogESL9D+h2Inn
	qQgQ0P6BzrI8coteeELIWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789228865; x=
	1789315265; bh=V5xJd8B3IpWlfEW6J8MbgoLw1q6mG3i9WCDPi5DnGJo=; b=Z
	FXFB8kdoLiPq+tBNCzQ0Z+6a1KM+0tr2H4YNoyykFgarjjzdL7H1on5Fuz5B+1W1
	/KkGVn1jmM4EIADna7/IsIHuXHiP4U2dm3KilRMPKHooWinrmfBk4fNuZygf1Nlt
	Wi/zRNWplV/Yb5952GIcs+1HV7gt8WkRm0vfSiUfneG85GbDLyWihgEaBrDt6J6J
	11TlWaOHsr7CE3yZ2ydk+6NnjAHm/ecHaREENQaR6IbbOWTIsyXjnppaOh3dOSPO
	QdaXaYBZlzkOfPDxXYH3FHkb93AGX7snEbnjQe9fh5fQfuhUPPk8XhTYcLd3f+Vc
	AaTCmruLZy2G0VVN7QPqw==
X-ME-Sender: <xms:Pnelau3QxMmo8HSTfYQ1X4KoY9TLrob0A8g401q2njZtSxSsoA5fWA>
    <xme:Pnelar62jLhi45TlLDefMCvq68H6WvmRZ-B3pLxKylsmTA1vf0O6i1rT-qYQ3iXD1
    e5XcMSxB7O8N5GQr6yRjowxoov7PWRc5KwSQP6FhwupkIo1-L4QDfE>
X-ME-Proxy-Cause: dmFkZTGkZKLRewHh9BlyX16WgToCb5Hj3KlZ8eHIoc4OSVSGm274BHOuNU49Qkr8mP7aZe
    TapTbJZVByJBk9SOfOyTvxFWi2ZzvtDCyYgPodYCvYuN45sirsdxRXHVrAw4U0EueovT37
    +MA6ovmbu6GnAYAK5vCfuEf6T1fvEfUAz2Ju1GlJJrWjMyMPSOR2KSdh2a6EtjaQZLPaSt
    w6/odcnx9ky9BZQmRVyjnjbqPL0lSYgmVSz2Tm1ze17Rp8852P2HfPD9NlNV+pHw6nR4To
    fkfEfoueGFuaVtjAIku1akITvHkcxtKT0+IxAHrJWyIgRwm189IvAwO+Ek5jsICy6XnCGH
    3hwAy4EB41GV1J0/6vl4+tJVcP2bIhke/yyq1uE7guF6MfBKpvW3DynJRENk3dnLDzNqkd
    JzDwJxQH6cEQdGowH77EQoeKGqB00FRZVpUFTh4AIR3k9VmWu1WHcFxKBBV9ha2uLY3YEl
    3nw4V8YpLswk9Men+9wNBbXX2gEwhLLqVim66L/25sS5ogxNzE8NKvGa1NV7NLffibdOpu
    ch1DLqNrtUIeZ2YCSq4Ah/TwmVjlydiy4pf8+qtxFD6i/WrJOuDnPwg8SUusA8gZ1IY5ph
    J0DKhPn/Wf3o1l3lkjXXW8i9IIp5c7NFPnoyLFsRJIJpIT9G1yn7GLC78Zpg
X-ME-Proxy: <xmx:P3elaiJTf3d1K9Zb7qlXCCiGmsHANkl7gr9G8nYrpX2oBBaFbaCzBw>
    <xmx:P3elat0ysFzqCkejTvMtXb9-Unh97R0JB72SuBWtp0pS3yITL-oH6A>
    <xmx:P3elasiQN5dSvj-6Oaca7Z1MYYbaQVlVqmq_YufzchW1it7jkNYepg>
    <xmx:P3elauXECRta1GBTE6jvZPpcVo4l_28oFQ_PC4mDODsub06dmBUv1g>
    <xmx:QXelaulCBL7xttA_5701d7pKlMW3k6cEKzQx3gmZBzixo9w0FmxqBdOH>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5C4EC32A0081; Sat, 12 Sep 2026 12:01:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: Aay7kYN5x6W7
Date: Sat, 12 Sep 2026 17:59:39 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Sasha Levin" <sashal@kernel.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Heiko Carstens" <hca@linux.ibm.com>
Message-Id: <eeda754b-8da6-4071-86fc-257db902bbd3@app.fastmail.com>
In-Reply-To: <daily-reply-0009-re-s390-compat-removal-6-18@kernel.org>
References: <30fec0a7-619b-44d9-9ca6-e5de551a8c0b@app.fastmail.com>
 <daily-reply-0009-re-s390-compat-removal-6-18@kernel.org>
Subject: Re: [PATCH 6.18 0641/1518] s390: Remove compat support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Sep 12, 2026, at 17:26, Sasha Levin wrote:
>> What is the reason for backporting this? Generally speaking I don't
>> like the idea of backporting feature removals to stable kernels,
>> the entire point the timing was to allow users to stay on LTS
>> kernels if they still need it.
>
> The way I see it, either we have users for this, and thus can't remove this
> feature neither upstream or in LTS trees.
>
> Or, we don't have any users, and so it's safe to remove this from both trees.
>
> If we have LTS users, then we can't drop it from upstream as they'll break when
> they upgrade, which we don't want to happen.

It is common enough that we know exactly who the users are, and we ask them
about removing a feature based on their support contracts. On embedded devices,
the people providing the kernel usually have obligations to ship security
updates for a fixed amount of time and they know which kernel version is
going to be their last one.

s390 is pretty much only ever used with distro kernels, but the same thing
applies here: we know which distros have enabled the CONFIG_COMPAT support,
and it was removed knowing that they no longer use it on new distro releases,
but an old distro release should certainly not break existing userspace
when installing a bugfix kernel.

Even when we think that there are no users, I ask that features are
kept until the next LTS release so that when users do show up afterwards,
they still have a way forward for at least some time.

       Arnd
