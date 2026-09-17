Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D214E4C28
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 20:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789676325; cv=none; b=A/fHb2wbPN+qCMTbLlM70PkrcZH/sFiHqLTEgM7k+GUKni62EuT/2yLVXcrjfcA302CQvR1pBSrA/IWj68cb0om4Nfwv3O3lFezlXcnC2uulmguo6q8gckTEY4CBJ2O1u5q8kqZJJ01fmi9FPDVw3UG7vqgnGADtwWxof7QzA5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789676325; c=relaxed/simple;
	bh=le7recSNNOUtIfIdOkAJodeVyoTNSDPkWfIf+JaPIko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tKfu6x78auKfoxXz890uH1EG7NsaeZzwM3EH6BJ/BPAkx9yN6mwDQojwOTZNg8NCOwgkfv2VWil/XPqBgkWRLJWoGfxMhRQRPCUYC8j1YjD0zDccwrqPYGcrGWB/BKzCbzsMBvSubFOMSMAAIQtI6G8FhdJ/5bG3XyOw9SdlIHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=SqPrO35R; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="SqPrO35R"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 788CB104392;
	Thu, 17 Sep 2026 22:18:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1789676316;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=phBozAeUwH1FNfpDymZUJqE7vCYkeFK/L6LdZFqJ8Ng=;
	b=SqPrO35Rf1Kln8KPOdqiHcDFQnJSggYsdkzMXB9La0lEXqaTWfx1eqhMiUyZd77/CqOM4T
	aaXBWWKOPXs3QPZqjf1/yy39VUB7MKl45Eg6NjXLvGSIXh9BNou/YRlpg1cAPG4wROhcUs
	9Z+npkQ7i5mb5yipNJTe+/vnbOCC0g6GjTEVrAOTMKMzYJn62NJbpHg4C0oBs8Rf1mjofp
	NCqJHHnYd7GK+1rAfhfqtC1Lnb5d3LjkvVkVdkBZPgQcLOe1xIAUQY/pXSaH0wIVfyc2Oe
	lusVXrSXhyhUM55MY5CuDgAaWKcsc/boOKYfO7nInuQbkNYpa16d6o3uN1/UnA==
Date: Thu, 17 Sep 2026 22:18:32 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Message-ID: <aqxLGIyiWCdsQoyR@duo.ucw.cz>
References: <20260917151539.408551884@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3nYsBqwAc8ujmC0B"
Content-Disposition: inline
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--3nYsBqwAc8ujmC0B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.111 release.
> There are 1102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We get build errors here and some runtime failures here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/16571866335
drivers/net/ethernet/ti/cpsw.c seems to have compile problem:

In file included from ./include/linux/container_of.h:5,
                 from ./include/linux/kernel.h:22,
                 from drivers/net/ethernet/ti/cpsw.c:9:
drivers/net/ethernet/ti/cpsw.c: In function 'cpsw_ndo_set_rx_mode_work':
./include/linux/container_of.h:20:54: error: 'struct cpsw_priv' has no member named 'rx_mode_work'

I don't have good diagnostic for runtime problem on arm. Example is here:

Working FDT set to baeea000
Starting kernel ...
(hang)

https://lava.ciplatform.org/scheduler/job/1510588

It is better on x86:

ogin-action: kernel 'oops'
L323[login-action] Waiting for messages, (timeout 00:01:59)
L324Waiting using forced prompt support (timeout 00:01:00)
L325[    0.264887] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
L326[    0.264887] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.111-rc1+ #1
L327[    0.264887] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1~bpo13+1 04/01/2014
L328[    0.264887] RIP: 0010:gather_bootmem_prealloc_parallel+0x117/0x250
L329[    0.264887] Code: ec 0f 84 f3 00 00 00 4c 89 ff 41 b8 00 00 00 80 4d 01 e0 0f 82 30 01 00 00 48 c7 c0 00 00 00 80 48 2b 05 84 d2 66 ff 49 01 c0 <4d> 8b 7c 24 10 49 c1 e8 0c 49 c1 e0 06 4c 03 05 5d d2 66 ff 4d 89
L330[    0.264887] RSP: 0018:ffffa93040013d70 EFLAGS: 00010206
L331[    0.264887] RAX: 0000701800000000 RBX: 0000000000000001 RCX: 0000000000000001
L332[    0.264887] RDX: ffffa93040013d80 RSI: 0000000000000001 RDI: 0000000000000000
L333[    0.264887] RBP: 0000000000000000 R08: 0000701880000000 R09: 0000000000000001
L334[    0.264887] R10: ffffa93040013ef8 R11: 0000000000000100 R12: 0000000000000000
L335[    0.264887] R13: ffffffff9354ec20 R14: 0000000000000000 R15: 0000000000000000
L336[    0.264887] FS:  0000000000000000(0000) GS:ffff8fe7bec00000(0000) knlGS:0000000000000000
L337[    0.264887] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
L338[    0.264887] CR2: 0000000000000010 CR3: 0000000016e2e000 CR4: 0000000000750ef0
L339[    0.264887] PKRU: 55555554
L340[    0.264887] Call Trace:
L341[    0.264887]  <TASK>
L342[    0.264887]  padata_do_multithreaded+0x332/0x370
L343[    0.264887]  hugetlb_bootmem_struct_page_init+0x6f/0x90
L344[    0.264887]  ? __pfx_gather_bootmem_prealloc_parallel+0x10/0x10
L345[    0.264887]  page_alloc_init_late+0xf/0x300
L346[    0.264887]  kernel_init_freeable+0xef/0x2d0
L347[    0.264887]  ? __pfx_kernel_init+0x10/0x10
L348[    0.264887]  kernel_init+0x15/0x1b0
L349[    0.264887]  ret_from_fork+0x2f/0x50
L350[    0.264887]  ? __pfx_kernel_init+0x10/0x10
L351[    0.264887]  ret_from_fork_asm+0x1a/0x30
L352[    0.264887]  </TASK>

https://lava.ciplatform.org/scheduler/job/1510595

Best regards,
                                                                Pavel


--3nYsBqwAc8ujmC0B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaqxLGAAKCRAw5/Bqldv6
8qQMAJ48U96U5+xE/UkGaZ4fOhGf3Qfm+ACgoiL25jedF0LlRMo0yCQQZ3YCOO0=
=+HFI
-----END PGP SIGNATURE-----

--3nYsBqwAc8ujmC0B--
