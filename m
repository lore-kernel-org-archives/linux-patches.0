Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D31212B2B
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 14:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737555350; cv=none; b=JBEfkRppgoQNn+mWz2cKkDf11Bn16+X4Gn5tR3udLW/S9VN5Mue+kCW52GW+yScaVGtMJtDQf9fdDQoGR+SWvYxVLCeJbwgpGtYmMF3npraqBJ4nC4texQ0WgTyKuVl2Orhe3/huJvi4d2Init03YZBx2Q0VomQhAcRqGciP8Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737555350; c=relaxed/simple;
	bh=ifNohGdpUqWQ47/CXhBXDrJaEzMyrlem/6QM08CYmD8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=EI0bjlrXOfmEr6oYZEvDQm0svNUYJ9uYFUV6Gnx0d5KYNH5ZhH2kd9+Mr+ndbwaNsKgfqjv7KfAOf3wNo//DSksXZ456MVqB1wvooGPc6Is4AWygM47gCh7yEUL3ZzptK+0/1cc2V5PiO8PkLW237wcCY14mA/8rTSK/0NghIY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=UJvJ4GRA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=B4eMGu91; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="UJvJ4GRA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="B4eMGu91"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 304351380142;
	Wed, 22 Jan 2025 09:15:47 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 22 Jan 2025 09:15:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1737555347;
	 x=1737641747; bh=ROq5OThraGrb++mZF0iSUSBCXiZf4G06ZRoPar4RRqA=; b=
	UJvJ4GRAIXmQFjhjzkhc4pDxHgJ2P4xvmSSo79V6XK1dCimvJHnCwWROvGrzJ5wv
	X2fgju4ekNo97thfKZoIsSFnvzhKgkSv3fRa/0hjIvXJo902o3KvjfZU1R8/vO6+
	uO1eTob6u90SFAf+XZ4BXlJaDktYdiYaYID6SiJJa9EZgGYrJ6EIYj+gcdMZR1Ul
	/bSNPm0EjaKfm25pm5sgz6SmAetH4gX+ZUFjFLcZMv4oEYRX3xnnlDj6WyvMNc+9
	EyGh4H9i9y4HMH0hYf0MTAFn6kfWjruD8ANHi7dSx0+eNBdyGUgyXxxAoXA5Vc36
	vXVu/D5uLSXICTl3R6/HMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1737555347; x=
	1737641747; bh=ROq5OThraGrb++mZF0iSUSBCXiZf4G06ZRoPar4RRqA=; b=B
	4eMGu91mFR+n2fuPts9P9IFBDHDyFEFRfO0aThjO+Gjxb5HHqIsj/plMp8HJB/x3
	kXlHKGMc47PLBY8CzKYtiSjq84dQjnyl6DRCtW92n6MlzjP9TkAcigNhaTxeMetb
	I2B50LBIdn2iFvhWBM0snrX/lilvabL9O4EwJ9Ra0A3nSyqhwZX1x9fQBl54ARt0
	bso3nbGvRHG3y7MQWwhZMCqzI/zlBauXCKeVB+ZLzwaSfq8scEIdsy0mxumlZ5Gf
	R5o1Q/qmg/YSr0LGexLtYj7n+yEqje8N6xcPqGYsI24Wp/atlvKeKkLcWm8ATKiX
	5XA0BDK/SJIysS+qJwyMw==
X-ME-Sender: <xms:kv2QZ39AwKnN3XEo10BJCOybgrkjVfIQdOLUY0HGWDSueconMydj4A>
    <xme:kv2QZzus1983hIA-FCRYPx5pP3OVkKNGfMj0j3Sr7zc1u2QXSfhm6geEGzPjA2vKS
    zmW0xxe4yloZZdNd4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejfedgudekjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredt
    tdenucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusg
    druggvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteef
    gffgvedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopedv
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepphgrvhgvlhesuggvnhigrdguvg
    dprhgtphhtthhopehfrdhfrghinhgvlhhlihesghhmrghilhdrtghomhdprhgtphhtthho
    pehsuhguihhpmhdrmhhukhhhvghrjhgvvgesghhmrghilhdrtghomhdprhgtphhtthhope
    hrfigrrhhsohifsehgmhigrdguvgdprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopegtohhnohhrsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehshhhurghhsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehprghttghhvghssehk
    vghrnhgvlhgtihdrohhrghdprhgtphhtthhopegrnhguvghrshdrrhhogigvlhhlsehlih
    hnrghrohdrohhrgh
X-ME-Proxy: <xmx:kv2QZ1CvVfvmS7sVpxBNmBWTRUB7vajCp4Mcj8omensbbRZaQaQBLA>
    <xmx:kv2QZzfxoEFvbdp_CSoiUnaY4dcm9tBmNYbBE23HXEq0AN--c8u-iw>
    <xmx:kv2QZ8PiNdf1UDVLe2K5VxWiC12PUw4q55rCSL2oDEGwL86j_WbpgQ>
    <xmx:kv2QZ1lbV7Jt9eeDJwSr5ZHbzrxHpUVk1dV_NzjpfLGL-WUZyb537A>
    <xmx:k_2QZ62IVKtFn2bqineyDyGkUc7IxwlEcT-Cn6-gZqfPvrortF5LV5zg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A32262220072; Wed, 22 Jan 2025 09:15:46 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 22 Jan 2025 15:15:26 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Guenter Roeck" <linux@roeck-us.net>, shuah <shuah@kernel.org>,
 patches@kernelci.org, lkft-triage@lists.linaro.org,
 "Pavel Machek" <pavel@denx.de>, "Jon Hunter" <jonathanh@nvidia.com>,
 "Florian Fainelli" <f.fainelli@gmail.com>,
 "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net,
 rwarsow@gmx.de, "Conor Dooley" <conor@kernel.org>, hargar@microsoft.com,
 "Mark Brown" <broonie@kernel.org>,
 "Anders Roxell" <anders.roxell@linaro.org>,
 "Dan Carpenter" <dan.carpenter@linaro.org>
Message-Id: <eec53047-6118-4a73-9535-335babf68685@app.fastmail.com>
In-Reply-To: 
 <CA+G9fYvacKD7aFkMCW6nwjZ4t-cpH0deLiPY-cFvGkRn5hgK3w@mail.gmail.com>
References: <20250122073830.779239943@linuxfoundation.org>
 <CA+G9fYvacKD7aFkMCW6nwjZ4t-cpH0deLiPY-cFvGkRn5hgK3w@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc2 review
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Jan 22, 2025, at 15:08, Naresh Kamboju wrote:

> -------
> fs/ext4/readpage.c: In function 'ext4_mpage_readpages':
> fs/ext4/readpage.c:413:1: warning: the frame size of 1132 bytes is
> larger than 1024 bytes [-Wframe-larger-than=]
>   413 | }
>       | ^
> 2025/01/22 08:45:53 socat-internal[1491] W waitpid(-1, {}, WNOHANG):
> no child has exited
> fs/mpage.c: In function 'do_mpage_readpage':
> fs/mpage.c:336:1: warning: the frame size of 1092 bytes is larger than
> 1024 bytes [-Wframe-larger-than=]
>   336 | }
>       | ^
> fs/mpage.c: In function '__mpage_writepage':
> fs/mpage.c:672:1: warning: the frame size of 1156 bytes is larger than
> 1024 bytes [-Wframe-larger-than=]
>   672 | }

I don't see anything touching these recently, probably not
a new regression but still a bit scary.

> drivers/usb/core/port.c: In function 'usb_port_shutdown':
> drivers/usb/core/port.c:299:26: error: 'struct usb_device' has no
> member named 'port_is_suspended'
>   299 |         if (udev && !udev->port_is_suspended) {
>       |                          ^~

Caused by the backport of 59bfeaf5454b ("USB: core: Disable LPM
only for non-suspended ports"), should be fixed by backporting
130eac417085 ("xhci: use pm_ptr() instead of #ifdef for CONFIG_PM
conditionals") as well. That one was originally a fix for a
different bug, but the new 59bfeaf5454b commit builds on that.

      Arnd

