Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD24E540
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 07:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="LkHISe5J";
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="o6M7FxII"
Received: by nautica.notk.org (Postfix, from userid 108)
	id BDEF6C026; Tue, 28 Nov 2023 07:57:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1701154625; bh=YtDBcs5dtkWgUo26OHvbwJYV3lr3fRfrqBl2F/PC0/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LkHISe5Js5hFiVlopu6QMAbH2yjOLJLqvT77fT7RruydoOSbmU/w11pfKj9VV5wys
	 Kqdz+NUqjTtdzf2IAqnSh7KrO24F5hAfMDaRf1dEdu21wK90/l3J9VRoD6FuQWkFva
	 OALRlR8Q90lmLLEro9Ng1eJmosr765PYbQwJJ31SB+NCzyJ6M1Fy+0ib3MbE9a9APe
	 yRZY5HMWzBFGLSO0j5ZEpoE3SnNh0MDflcQW4GAq3Z/O0yJ9SuxMgaDe1p6ocBOI/h
	 2ZiVIqvZiULp83ltmw/kuVMuupMiH2W67FwI2kZY5Onkj17uToWBsX0SbpN/UBYCsZ
	 HfuJ67HYfudXg==
X-Spam-Level: 
Received: from gaia (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id CFDF1C009;
	Tue, 28 Nov 2023 07:56:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1701154624; bh=YtDBcs5dtkWgUo26OHvbwJYV3lr3fRfrqBl2F/PC0/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o6M7FxIIUe/jHiaWMxCnhFBOBhiWkFKS13urGaHJY202myA+AiZfWsA84MzfC3UBU
	 B0ep5VRlXqTamW/NXFg0I7n8AztHaMrJKkD/j7j3fVCz7OzXI+StfcL4mlG7VpF1Jy
	 39mYKBfn3hOQDgQWxApyIO864BuEfyGC4Hj6UXOq7Xk+cqhi4C55IJIQar/5zV0yvQ
	 UmfEteoXpiirASUwimbGRaDQpGvq0yGZW4Pv+n/IcDZj28J3p3gkFd6yrpkU/HvFR2
	 CCYaSJyWVcUog+sRuXl7R4DsHJHR6GsyI7VIJlnJe2TwLEZjlC3Bw/ht25n3tqaOKI
	 D3b0xAxQGxinw==
Received: from localhost (gaia [local])
	by gaia (OpenSMTPD) with ESMTPA id 7fc12b28;
	Tue, 28 Nov 2023 06:56:53 +0000 (UTC)
Date: Tue, 28 Nov 2023 15:56:38 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Pavel Machek <pavel@denx.de>, youwan Wang <wangyouwan@126.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, maz@kernel.org, andy.shevchenko@gmail.com,
	brgl@bgdev.pl, wangyouwan@126.com, jani.nikula@intel.com,
	rf@opensource.cirrus.com, ilpo.jarvinen@linux.intel.com,
	dan.carpenter@linaro.org
Subject: Re: [PATCH 5.10 000/187] 5.10.202-rc3 review
Message-ID: <ZWWPJtXZ12WuTtd1@codewreck.org>
References: <20231126154335.643804657@linuxfoundation.org>
 <ZWUJWhOkbHlwC2YB@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZWUJWhOkbHlwC2YB@duo.ucw.cz>

Pavel Machek wrote on Mon, Nov 27, 2023 at 10:25:46PM +0100:
> > Marc Zyngier <maz@kernel.org>
> >     gpio: Don't fiddle with irqchips marked as immutable
>
> This is attempt to move people to new API, which will cause warning
> for existing users. "chip_warn(gc, "not an immutable chip, please
> consider fixing it!\n");". It is marked as dependency of another
> patch, but I'm not sure we should be doing this in stable.

And this actually did make some tests fail on tegra (other branch on
this thread), it's probably safer to drop the gpio patches unless we're
prepared to backport all the "make immutable" patches as well.

(I don't see why it'd be required for dc3115e6c5d9 either but I didn't
look all that close)


> > youwan Wang <wangyouwan@126.com>
> >     Bluetooth: btusb: Add date->evt_skb is NULL check
> 
> Could someone double check this? If we hit the null check, we'll be
> returning success, but it sounds like an error case.

I agree with your analysis; added Youwan and Luiz in recipients.

btusb_mtk_hci_wmt_sync will return 0 if the skb is null here -- should
this be setting err = -EINVAL or something?

> > Jani Nikula <jani.nikula@intel.com>
> >     drm/msm/dp: skip validity check for DP CTS EDID checksum
> 
> This is preparation for future cleanup, do we need it?

(For cleanup patches I'd say if it makes future backports easier it
doesn't hurt to take them)

-- 
Dominique Martinet | Asmadeus
