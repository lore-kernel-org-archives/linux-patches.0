Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.210.214.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056521;
	b=M3E38avYQJtle05wlHHQq0lH59fPRYE5ZRL2Kl/myOTpJ8vc6bycxDK+DSXi4Qcdga78
	 WYKTrC5oP7txkZp9kUKFN/uIL8eV8M1G7BVy5pbdOo+8lsJPOZvz/UkYFjHwkYhhHijGX
	 J9Enk7dH1zSqcOQ3oefyeG8wqmIoQg4Il+Jux+bLRXb1XuI8KSBuRoIjp4M8eov146qlZ
	 KOQNmFOk0FXaoxcqY6N4qHS8NOxfldedcctDEOcoHObC97QqvEMdePkHl0KsXmpSaE9tg
	 r9H5Fsy/zuIwPMUFnnyKN9kYx/XPGo1WUm1T/nFTMkJqtGIbefSr6ojBvUVNO8gTrLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056521;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=iMVUN/yQLgL2A1pfhaZ0CyrA59URNsyTSdFb8MCVqT8=;
	b=WbG3xW1OO+f77+EeDke7HIRzkGFYeB52UfMwvkrEHZCyFHklt6ZeyXjhFO0JTf8FTxeZ
	 brLRd/8/TQcALHGDtEbPmubPvA6OeuWAuPdUSQtngkNFgpzfWLgDtOnUEYeGqmWNTJMKR
	 HbKpq80QtzZ+eaxQhOd7h8eQsFCWP00+BN5rbvjzywvni1BVlv0Vf5UO296QQww0dn2Cp
	 vrdon7Tj8aYPKAL3TpcV00AWoSgkCC409V7FguAIBWenYYHfZiXo33V0rY9wYfn0rmfRe
	 tKIksty5WGdJ8k9e46FWHm4AGIzoP/CrA2zLhh/NJW2q11IWZFWhL8dNiOsY02Te6ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codewreck.org;
	spf=pass smtp.mailfrom=codewreck.org;
	dkim=pass header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=JZlkiOFR;
	arc=none smtp.remote-ip=62.210.214.84
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035F660A2609
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 02:48:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 035F660A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=JZlkiOFR
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id ED0D414C2DE;
	Thu, 19 Nov 2026 03:48:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1795056519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iMVUN/yQLgL2A1pfhaZ0CyrA59URNsyTSdFb8MCVqT8=;
	b=JZlkiOFRfoKm6ZtleCmuKcyBKBlIuzQlq4nVtnz0Ful/tYd8GemzL5sbvcZORDl/gz4Cnd
	TKGXRB/EyiBjbR6z2EMI7d6JfoAzQctyH+W4iBQdg7IotbtLj46co3jxMK4DdOBqYaJYP0
	msAc+98haOJgruut0Z625ilDLrJnyOkXxrBaC9ZLWLsuxwNd7si9CnucHBMIXtJ1bxSIBo
	XjDwTp4Vo62vy7Yi5fUljeQaN4TqegO87NsJnBEcBHJ7tzoMYWEegeSpYZQBd6srchZLwP
	rgmipIVkcwIYu/xY4AWdfCPi+A7Acu7/PpRsUZK0+pxqMmlITx5DwPycu9V2GQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id cd7add29;
	Thu, 19 Nov 2026 02:48:31 +0000 (UTC)
Date: Thu, 19 Nov 2026 11:48:16 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com, Aristo Chen <aristo.chen@canonical.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 6.12 0000/1756] 6.12.119-rc1 review
Message-ID: <av5jcETOfbV20DZS@codewreck.org>
References: <20261118150007.957976754@linuxfoundation.org>
 <av5IKItmzhDUp-Zd@codewreck.org>
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
In-Reply-To: <av5IKItmzhDUp-Zd@codewreck.org>

Dominique Martinet wrote on Thu, Nov 19, 2026 at 09:51:52AM +0900:
> Greg Kroah-Hartman wrote on Wed, Nov 18, 2026 at 03:35:27PM +0100:
> > Adam Ford <aford173@gmail.com>
> >     phy: freescale: fsl-samsung-hdmi: Fix 64-by-32 division cocci warnings
> >
> > Aristo Chen <aristo.chen@canonical.com>
> >     phy: freescale: fsl-samsung-hdmi: initialize default rate
> > 
> > Pei Xiao <xiaopei01@kylinos.cn>
> >     phy: freescale: fsl-samsung-hdmi: Use helper function devm_clk_get_enabled()
> > 
> > Adam Ford <aford173@gmail.com>
> >     phy: freescale: fsl-samsung-hdmi: Support dynamic integer
> > 
> > Adam Ford <aford173@gmail.com>
> >     phy: freescale: fsl-samsung-hdmi: Simplify REG21_PMS_S_MASK lookup
> > 
> > Adam Ford <aford173@gmail.com>
> >     phy: freescale: fsl-samsung-hdmi: Replace register defines with macro
> 
> I'm getting a boot failure around one of these on i.MX8MP:
> 
> 2026-11-19 09:01:29.454251 [    0.587255] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> 2026-11-19 09:01:29.459125 [    0.596076] Mem abort info:
> 2026-11-19 09:01:29.460122 [    0.598879]   ESR = 0x0000000096000004
> 2026-11-19 09:01:29.465853 [    0.602641]   EC = 0x25: DABT (current EL), IL = 32 bits
> 2026-11-19 09:01:29.470643 [    0.607973]   SET = 0, FnV = 0
> 2026-11-19 09:01:29.471565 [    0.611036]   EA = 0, S1PTW = 0
> 2026-11-19 09:01:29.476941 [    0.614190]   FSC = 0x04: level 0 translation fault
> 2026-11-19 09:01:29.481849 [    0.619077] Data abort info:
> 2026-11-19 09:01:29.487329 [    0.621961]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
> 2026-11-19 09:01:29.492669 [    0.627455]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> 2026-11-19 09:01:29.498347 [    0.632518]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> 2026-11-19 09:01:29.504076 [    0.637842] [0000000000000000] user address but active_mm is swapper
> 2026-11-19 09:01:29.509800 [    0.644207] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> 2026-11-19 09:01:29.510695 [    0.650479] Modules linked in:
> 2026-11-19 09:01:29.521321 [    0.653542] CPU: 2 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 6.12.119-rc1-at0-g8f03b6a4b095 #43
> 2026-11-19 09:01:29.527214 [    0.662683] Hardware name: Atmark-Techno Armadillo-IoT Gateway G4 Board (DT)
> 2026-11-19 09:01:29.533048 [    0.669734] Workqueue: events_unbound deferred_probe_work_func
> 2026-11-19 09:01:29.542857 [    0.675584] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> 2026-11-19 09:01:29.544070 [    0.682548] pc : phy_clk_recalc_rate+0x4/0xc
> 2026-11-19 09:01:29.549398 [    0.686828] lr : __clk_register+0x4f0/0x8e0
> 2026-11-19 09:01:29.554271 [    0.691021] sp : ffff8000800bb9e0
> 2026-11-19 09:01:29.560182 [    0.694336] x29: ffff8000800bb9e0 x28: ffffa1893c634720 x27: ffff6d82c32ac080
> 2026-11-19 09:01:29.566395 [    0.701486] x26: 0000000000000000 x25: ffff6d82c32ac080 x24: 0000000000000001
> 2026-11-19 09:01:29.576245 [    0.708635] x23: ffff8000800bba88 x22: ffff6d82c32a16a0 x21: 0000000000000000
> 2026-11-19 09:01:29.582449 [    0.715784] x20: ffff6d82c20f8100 x19: ffff6d82c32a3800 x18: 0000000000000fdf
> 2026-11-19 09:01:29.588353 [    0.722932] x17: 0000000000000cf0 x16: 00000000000003fa x15: ffff6d82c214af10
> 2026-11-19 09:01:29.594281 [    0.730081] x14: 000000000000014d x13: ffff6d82c214af00 x12: 0000000000000000
> 2026-11-19 09:01:29.604441 [    0.737232] x11: 00000000000000c0 x10: 0000000000000000 x9 : 0000000000000000
> 2026-11-19 09:01:29.610325 [    0.744381] x8 : 0101010101010101 x7 : 0000000000000000 x6 : 8080808080808080
> 2026-11-19 09:01:29.616546 [    0.751528] x5 : ffff6d82c32ac080 x4 : 0000000000000000 x3 : ffff6d82c200a700
> 2026-11-19 09:01:29.622413 [    0.758677] x2 : ffffa1893b813740 x1 : 00000000016e3600 x0 : 0000000000000000
> 2026-11-19 09:01:29.627125 [    0.765829] Call trace:
> 2026-11-19 09:01:29.632409 [    0.768277]  phy_clk_recalc_rate+0x4/0xc
> 2026-11-19 09:01:29.633534 [    0.772208]  devm_clk_register+0x5c/0xbc
> 2026-11-19 09:01:29.638814 [    0.776137]  fsl_samsung_hdmi_phy_probe+0x1dc/0x310
> 2026-11-19 09:01:29.643768 [    0.781024]  platform_probe+0x68/0xdc
> 2026-11-19 09:01:29.644748 [    0.784693]  really_probe+0xbc/0x2bc
> 2026-11-19 09:01:29.650181 [    0.788278]  __driver_probe_device+0x80/0x14c
> 2026-11-19 09:01:29.655274 [    0.792643]  driver_probe_device+0x40/0x130
> 2026-11-19 09:01:29.660501 [    0.796831]  __device_attach_driver+0xb8/0x140
> 2026-11-19 09:01:29.665772 [    0.801282]  bus_for_each_drv+0x88/0xe8
> 2026-11-19 09:01:29.666809 [    0.805125]  __device_attach+0x9c/0x19c
> 2026-11-19 09:01:29.671945 [    0.808966]  device_initial_probe+0x54/0x74
> 2026-11-19 09:01:29.677003 [    0.813155]  __bus_probe_device+0x34/0xa0
> 2026-11-19 09:01:29.678308 [    0.817171]  bus_probe_device_deferred+0x2c/0x78
> 2026-11-19 09:01:29.683731 [    0.821795]  deferred_probe_work_func+0x7c/0xb4
> 2026-11-19 09:01:29.688826 [    0.826335]  process_one_work+0x164/0x2bc
> 2026-11-19 09:01:29.693854 [    0.830355]  worker_thread+0x180/0x2f4
> 2026-11-19 09:01:29.694736 [    0.834109]  kthread+0x110/0x114
> 2026-11-19 09:01:29.699938 [    0.837345]  ret_from_fork+0x10/0x20
> 2026-11-19 09:01:29.705576 [    0.840932] Code: d503201f d503201f d503201f f9400c00 (b9400000) 
> 2026-11-19 09:01:29.709069 [    0.847029] ---[ end trace 0000000000000000 ]---
> 
> I need to check further where the problem is exactly, will reply to this
> mail again in a couple of hours as I'm not sure I can recover the board
> remotely to check right now

Ok, I boot after reverting commit a8210490583e ("phy: freescale:
fsl-samsung-hdmi: initialize default rate")

That commit removed the fallback if (!phy->cur_cfg), which probably
works for master (didn't test), but doesn't work on 6.12 likely because
it doesn't have commit 41db46233467 ("phy: freescale: fsl-samsung-hdmi:
Refactor finding PHY settings") - as far as I can see that commit
ensures cur_cfg is always set early on.

Unfortunately it's not trivial to cherry-pick, picking these two in
order results in a relatively minor conflict in the Refactor patch we
want:
058ea4a06704 ("phy: freescale: fsl-samsung-hdmi: Use closest divider")
41db46233467 ("phy: freescale: fsl-samsung-hdmi: Refactor finding PHY settings")

And I've checked the oops no longer reproduce with these two, keeping
a8210490583e ("phy: freescale: fsl-samsung-hdmi: initialize default
rate") as is.

If it helps I can send the patches as I resolved, but it's probably
easier to drop for this time?


Thanks,
-- 
Dominique Martinet | Asmadeus
