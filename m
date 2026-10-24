Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792819974;
	b=XO2nFSYLTsbSo3v8Iai0TJfQjeT5Yq9KSwyBvabaHSBJLhsgqzjbMWnafQAHxt0eAQMO
	 xFzAE6cBspR4HK9birTzfEhn4XurS6LnTWrr7POXikHbV8Tr73JmyvgCSEFmIbzsCRX4Y
	 A4Z9vutp5tj3uP7QaLsTSopmyH5PoL1E/SjsHd1m9KovtENHCZ3dQmCSWmpHQ4ZCCN92W
	 PUBg8I1HoAISs07Qu5XmGDame+dKVroJ2gfX9hI2vxdRp062rHeSnq+1aTye5+DW8vbTZ
	 WBzsBl3pzxPJYy6WorYHud2ybagfhgHu+COznQVhj7GyYNQ/wdfSoz5SCJq2sjLhf+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792819974;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jZHFuBoh3O8SvdWvlL7mEgQWiQcN8okpZlrSpdY258o=;
	b=i9+8+XiHv0mF3CjXHofMkQe1MkydisUGxDS9aUqqN44E2MFuD6aKAxjXtAYruqhkgluv
	 YcPzQ/7D4sji5tVdnuHYTBDXsf68sHCWO2yxV7BgIr9spGWe6ZKxVsApRut+DQH7cXuy2
	 qJphP6cLtzOv2iqOBhXxM+Y3cZ2M7sGLHq6SeBL6BbseLJ39s14zqaVRDZj6vhF+SCo3D
	 EfENyPIwOU6Un+3NzCtmCkelgglP81rCbGOPf6xHjIYxuk0vzBKIovsLsAzN7XKpSElOE
	 +HsykXu7mIWGh10Xgj7gXwHWj8tBCBosoQqPeCpz61Za1S6Mv9JkbryuFgnLnrPvzWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aksZiEgy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D55606A331;
	Sat, 24 Oct 2026 05:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aksZiEgy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925C61F01825;
	Sat, 24 Oct 2026 05:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792819974;
	bh=jZHFuBoh3O8SvdWvlL7mEgQWiQcN8okpZlrSpdY258o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aksZiEgyHKSbd31vCh540tOm5q6v6AsQMCd1mWZIdK7W4rti5Q+P7DzE811VpsP9m
	 SWbrTkhC9jIesYRProuV98r/2BAZfLDX1otBVJrk4r5QVSOcjL9a0YOA9Ge8xEa/fd
	 AhPKd56cddMtHBnFXsFZrma/XMowwRHhVHyJT1RQ=
Date: Sat, 24 Oct 2026 07:32:51 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>,
	Pavel Machek <pavel@nabladev.com>,
	"stable # v4 . 9+" <stable@vger.kernel.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/242] 7.2.13-rc1 review
Message-ID: <2026102452-upstream-plod-9ed4@gregkh>
References: <20261023163713.816071858@linuxfoundation.org>
 <atvHKoRHHjKV4l8A@duo.ucw.cz>
 <atvS68GhCvmAphrQ@eldamar.lan>
 <7540e723-054e-43a2-859d-616010fc7bea@gmail.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7540e723-054e-43a2-859d-616010fc7bea@gmail.com>

On Fri, Oct 23, 2026 at 03:44:07PM -0700, Florian Fainelli wrote:
> On 10/23/26 14:34, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Fri, Oct 23, 2026 at 10:44:26PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > This is the start of the stable review cycle for the 7.2.13 release.
> > > > There are 242 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > Either something went very wrong with our testing, or this fails on
> > > all our targets. 6.18.59-rc1 does not seem to have those widespread
> > > failures.
> > > 
> > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2982452623
> > > 
> > > Example failure is:
> > > 
> > > I'll look some more to try to figure out what is going on there.
> > > 
> > > Best regards,
> > > 
> > > 								Pavel
> > > 
> > > 
> > > [    1.238864] Yama: becoming mindful.
> > > L426[    1.238864] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
> > > L427[    1.238864] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
> > > L428[    1.238864] VFS: Finished mounting rootfs on nullfs
> > > L431[    1.238864] BUG: kernel NULL pointer dereference, address: 000000000000002c
> > > L436[    1.238864] #PF: supervisor write access in kernel mode
> > > L437[    1.238864] #PF: error_code(0x0002) - not-present page
> > > L438[    1.238864] PGD 0 P4D 0
> > > L441[    1.238864] Oops: Oops: 0002 [#1] SMP PTI
> > > L446[    1.238864] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G S                  7.2.13-rc1+ #1 PREEMPT(lazy)
> > > L447[    1.238864] Tainted: [S]=CPU_OUT_OF_SPEC
> > > L448[    1.238864] Hardware name: SIEMENS AG SIMATIC IPC227E/A5E42630598, BIOS V20.01.11 03/15/2018
> > > L449[    1.238864] RIP: 0010:rest_init+0x33/0xd0
> > > L450[    1.238864] Code: 34 ff ba 00 02 00 00 31 f6 48 c7 c7 70 a2 e6 b2 e8 52 d3 28 ff 89 c3 e8 bb 2d 34 ff 89 df 48 c7 c6 80 db 85 b3 e8 9d d7 2b ff <81> 48 2c 00 00 00 04 65 8b 15 63 6e 45 01 48 89 c7 89 d0 c1 ea 06
> > > L451[    1.238864] RSP: 0000:ffffffffb3803ee0 EFLAGS: 00010246
> > > L452[    1.238864] RAX: 0000000000000000 RBX: 00000000ffffffea RCX: 0000000000000000
> > > L453[    1.238864] RDX: 0000000000000000 RSI: ffffffffffffffea RDI: ffffffffffffffea
> > > L454[    1.238864] RBP: ffff8cf23ffed080 R08: ffffffffb385db88 R09: ffffffffb385db80
> > > L455[    1.238864] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8cf23ffed0ab
> > > L456[    1.238864] R13: 0000000000000000 R14: ffffffffb380c040 R15: 00000000b43e8000
> > > L457[    1.238864] FS:  0000000000000000(0000) GS:ffff8cf287953000(0000) knlGS:0000000000000000
> > > L458[    1.238864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > L459[    1.238864] CR2: 000000000000002c CR3: 000000000d630000 CR4: 00000000001006f0
> > > L460[    1.238864] Call Trace:
> > > L461[    1.238864]  <TASK>
> > > L462[    1.238864]  start_kernel+0x7a2/0x7b0
> > > L463[    1.238864]  x86_64_start_reservations+0x24/0x30
> > > L464[    1.238864]  x86_64_start_kernel+0xcd/0xd0
> > > L465[    1.238864]  common_startup_64+0x13e/0x158
> > > L466[    1.238864]  </TASK>
> > > L467[    1.238864] Modules linked in:
> > > L468[    1.238864] CR2: 000000000000002c
> > > L469[    1.238864] ---[ end trace 0000000000000000 ]---
> > > L470[    1.238864] RIP: 0010:rest_init+0x33/0xd0
> > 
> > Same here indepently, but not yet bisected.
> 
> Same here as well, bisected down to: a0c935bd1f76 ("fs: add umh argument to
> struct kernel_clone_args"), it looks like we need to cherry-pick
> 14adbd5341aa ("fs: stop sharing fs_struct between init_task and pid 1"),
> with that I can boot a kernel.

Thanks for the bisection, I'll go queue that up now and push out a -rc2
soon.

greg k-h
