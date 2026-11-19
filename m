Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.210.214.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053147;
	b=YaE9JFypwd7aqQN+ZXpyGUe8GT3HmDB9c6BUieEuLutaPO+/OlnDj79nxbqapHAo+ppZ
	 rlycLmuUgVZ72raYZ2IFi9S4A8OhxT0BwI0EA3v0BQOdsKzuwjg2RO7Wq7KRIn/bwXxcs
	 qElVL9LvePY2xzXRhb3npWQhlG2rHQNJXFuyHFwzI0D1azs4iloMG0tNGYq1t7jSfisR1
	 ZMlZpzAVatlfeyZ2INSOXDvrtCWvI9Hcq/+lZPvcUOmyMX8fEnbcDPpoiRHlKtReoqmsz
	 4lCMYjMTscMfPIAK68vLkW0wq0MBx9cpv4SptXlsibE/t1JWuBfV390ldbeyXDdUiFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053147;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=drBI2u3l/Qu8rjPECXBquJdYCnYIjDkd28tJ2CdOoKs=;
	b=zwcdskggRy8S7w4YHcSzVCocuEiYfrjSNTPDicOy3HxLDmevq7mjLb4tDe5bZ2M7itkp
	 dQq/NEC+NJjPNXUcY5LJin3bGS6GVG3e+XwrNPXly93uL5kh2/Vh5bXfuAzl4uLT5MAbY
	 BO3ummCUKHqwHu7OfaZaoaeU9LpouDKj5lCS008sTK3fYOdWYASp+YdfWt0XOuP0xpjly
	 Jp2yklIm2d2/7wj4O8v+PZY+6z40C3copuBz8lAe7hCmY0vh+Ikw974BNQIDfZRTP8LrA
	 j+TZXQ8E8bxjmsE7X7P7R2je6cc40pNCkh+6e2wkv0LpOny2esiDkvrItuLAdHfcGiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codewreck.org;
	spf=pass smtp.mailfrom=codewreck.org;
	dkim=pass header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=RbGZKsMg;
	arc=none smtp.remote-ip=62.210.214.84
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1587A606A325
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 01:52:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1587A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=RbGZKsMg
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 833F014C2D6;
	Thu, 19 Nov 2026 02:52:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1795053135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=drBI2u3l/Qu8rjPECXBquJdYCnYIjDkd28tJ2CdOoKs=;
	b=RbGZKsMg3K0nhkZzfOhmSz6iE2G0Rh+N2AqKr/x4uCwbP8OAc8claHsfHkIBbSq8cuLCq9
	kmHHU1z9ocF2Gg/1QbOfzmRsmoPQvUNOKmRHEtfANO6rlMS7nRDFVlcG9n9kBtoXmLNboB
	1JhvROInVB/XGOosCq2F7TTjugGuGTCFb+vQCXFCqEKnRf3m+ffrtIfL52D91tvfmxKHXH
	KR+ifJuXsGuZoi+r+x3I5jHmYz7wJir2GObUPiyUAloXttvmeNhs3cp8hV6ZfsoFfebv3v
	sdccBULoblMHKny7Q2yzE15+SelLIY0p8WhU4ziHZzoFdxrQFcAs52JItJGAVg==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id c4e01d75;
	Thu, 19 Nov 2026 00:52:07 +0000 (UTC)
Date: Thu, 19 Nov 2026 09:51:52 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1756] 6.12.119-rc1 review
Message-ID: <av5IKItmzhDUp-Zd@codewreck.org>
References: <20261118150007.957976754@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Nov 18, 2026 at 03:35:27PM +0100:
> Adam Ford <aford173@gmail.com>
>     phy: freescale: fsl-samsung-hdmi: Fix 64-by-32 division cocci warnings
>
> Aristo Chen <aristo.chen@canonical.com>
>     phy: freescale: fsl-samsung-hdmi: initialize default rate
> 
> Pei Xiao <xiaopei01@kylinos.cn>
>     phy: freescale: fsl-samsung-hdmi: Use helper function devm_clk_get_enabled()
> 
> Adam Ford <aford173@gmail.com>
>     phy: freescale: fsl-samsung-hdmi: Support dynamic integer
> 
> Adam Ford <aford173@gmail.com>
>     phy: freescale: fsl-samsung-hdmi: Simplify REG21_PMS_S_MASK lookup
> 
> Adam Ford <aford173@gmail.com>
>     phy: freescale: fsl-samsung-hdmi: Replace register defines with macro

I'm getting a boot failure around one of these on i.MX8MP:

2026-11-19 09:01:29.454251 [    0.587255] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
2026-11-19 09:01:29.459125 [    0.596076] Mem abort info:
2026-11-19 09:01:29.460122 [    0.598879]   ESR = 0x0000000096000004
2026-11-19 09:01:29.465853 [    0.602641]   EC = 0x25: DABT (current EL), IL = 32 bits
2026-11-19 09:01:29.470643 [    0.607973]   SET = 0, FnV = 0
2026-11-19 09:01:29.471565 [    0.611036]   EA = 0, S1PTW = 0
2026-11-19 09:01:29.476941 [    0.614190]   FSC = 0x04: level 0 translation fault
2026-11-19 09:01:29.481849 [    0.619077] Data abort info:
2026-11-19 09:01:29.487329 [    0.621961]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
2026-11-19 09:01:29.492669 [    0.627455]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
2026-11-19 09:01:29.498347 [    0.632518]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
2026-11-19 09:01:29.504076 [    0.637842] [0000000000000000] user address but active_mm is swapper
2026-11-19 09:01:29.509800 [    0.644207] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
2026-11-19 09:01:29.510695 [    0.650479] Modules linked in:
2026-11-19 09:01:29.521321 [    0.653542] CPU: 2 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 6.12.119-rc1-at0-g8f03b6a4b095 #43
2026-11-19 09:01:29.527214 [    0.662683] Hardware name: Atmark-Techno Armadillo-IoT Gateway G4 Board (DT)
2026-11-19 09:01:29.533048 [    0.669734] Workqueue: events_unbound deferred_probe_work_func
2026-11-19 09:01:29.542857 [    0.675584] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
2026-11-19 09:01:29.544070 [    0.682548] pc : phy_clk_recalc_rate+0x4/0xc
2026-11-19 09:01:29.549398 [    0.686828] lr : __clk_register+0x4f0/0x8e0
2026-11-19 09:01:29.554271 [    0.691021] sp : ffff8000800bb9e0
2026-11-19 09:01:29.560182 [    0.694336] x29: ffff8000800bb9e0 x28: ffffa1893c634720 x27: ffff6d82c32ac080
2026-11-19 09:01:29.566395 [    0.701486] x26: 0000000000000000 x25: ffff6d82c32ac080 x24: 0000000000000001
2026-11-19 09:01:29.576245 [    0.708635] x23: ffff8000800bba88 x22: ffff6d82c32a16a0 x21: 0000000000000000
2026-11-19 09:01:29.582449 [    0.715784] x20: ffff6d82c20f8100 x19: ffff6d82c32a3800 x18: 0000000000000fdf
2026-11-19 09:01:29.588353 [    0.722932] x17: 0000000000000cf0 x16: 00000000000003fa x15: ffff6d82c214af10
2026-11-19 09:01:29.594281 [    0.730081] x14: 000000000000014d x13: ffff6d82c214af00 x12: 0000000000000000
2026-11-19 09:01:29.604441 [    0.737232] x11: 00000000000000c0 x10: 0000000000000000 x9 : 0000000000000000
2026-11-19 09:01:29.610325 [    0.744381] x8 : 0101010101010101 x7 : 0000000000000000 x6 : 8080808080808080
2026-11-19 09:01:29.616546 [    0.751528] x5 : ffff6d82c32ac080 x4 : 0000000000000000 x3 : ffff6d82c200a700
2026-11-19 09:01:29.622413 [    0.758677] x2 : ffffa1893b813740 x1 : 00000000016e3600 x0 : 0000000000000000
2026-11-19 09:01:29.627125 [    0.765829] Call trace:
2026-11-19 09:01:29.632409 [    0.768277]  phy_clk_recalc_rate+0x4/0xc
2026-11-19 09:01:29.633534 [    0.772208]  devm_clk_register+0x5c/0xbc
2026-11-19 09:01:29.638814 [    0.776137]  fsl_samsung_hdmi_phy_probe+0x1dc/0x310
2026-11-19 09:01:29.643768 [    0.781024]  platform_probe+0x68/0xdc
2026-11-19 09:01:29.644748 [    0.784693]  really_probe+0xbc/0x2bc
2026-11-19 09:01:29.650181 [    0.788278]  __driver_probe_device+0x80/0x14c
2026-11-19 09:01:29.655274 [    0.792643]  driver_probe_device+0x40/0x130
2026-11-19 09:01:29.660501 [    0.796831]  __device_attach_driver+0xb8/0x140
2026-11-19 09:01:29.665772 [    0.801282]  bus_for_each_drv+0x88/0xe8
2026-11-19 09:01:29.666809 [    0.805125]  __device_attach+0x9c/0x19c
2026-11-19 09:01:29.671945 [    0.808966]  device_initial_probe+0x54/0x74
2026-11-19 09:01:29.677003 [    0.813155]  __bus_probe_device+0x34/0xa0
2026-11-19 09:01:29.678308 [    0.817171]  bus_probe_device_deferred+0x2c/0x78
2026-11-19 09:01:29.683731 [    0.821795]  deferred_probe_work_func+0x7c/0xb4
2026-11-19 09:01:29.688826 [    0.826335]  process_one_work+0x164/0x2bc
2026-11-19 09:01:29.693854 [    0.830355]  worker_thread+0x180/0x2f4
2026-11-19 09:01:29.694736 [    0.834109]  kthread+0x110/0x114
2026-11-19 09:01:29.699938 [    0.837345]  ret_from_fork+0x10/0x20
2026-11-19 09:01:29.705576 [    0.840932] Code: d503201f d503201f d503201f f9400c00 (b9400000) 
2026-11-19 09:01:29.709069 [    0.847029] ---[ end trace 0000000000000000 ]---

I need to check further where the problem is exactly, will reply to this
mail again in a couple of hours as I'm not sure I can recover the board
remotely to check right now

-- 
Dominique
