Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794818868;
	b=V52BnQeDUZI31bAJ9ccE90vMSTUrSIQ/JhxdZaWbQRP+1gFOEkyPehi/GmLpJG3hsTHG
	 F3+iHo5+B3FWmKCsO+7Zto5AFfCWyJ3k2PC3EV1XGMY7XTBbpjEPE/j6fOdZiTutWYvw7
	 QfqmKhbHrGoU1wtK8Y6eGwyDmvwAKxWgsjgdvqjGc40SEzeFiaQHJCTjWF4VHw9cg6Azh
	 uD/a0maCr2w903QykZFw3qHMG/WwpyVaLQetESXbIN5wOOrZkn/S3XBJBfBX8+qzQ5Q5N
	 mGARf18eJkMMxoTCiUeA62V9ltQ51Ld+SnhbbhA+nAoX2YZyN/3Umf2jiVO7p3xu47w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794818868;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=qs1+XyJIBcRXvNK4eAjtS4NGdjhzHm1jJtJ5wQ/HE4A=;
	b=iKQN7jDeACAQ+fWzYQYMzpNsydxX69e4VI9vzIHZEMb/SzzwJWnhoa1ggV+s3BNx45Fy
	 SHPuYHy+GLI2N/TvCNefqlmwAYPP0Q2ppOA2Tji6fO2yfWh0K0jDmr8gIzoA7AkdQ9rms
	 zmJQGk8d5natBzyAkD9bFvQ5YHXvVzpBr88iBVdtaWe7Th8AkgjLmO1QrHYG9Dxn4xz/T
	 8nxpCirreXy7bvv5/hqjyYa+uWlr/wDunMh41MuVmKqDRI/1n98uy+nv1cjia5Ks+UKP6
	 qnRg+MYGqO5IW8beSKgRxxzSJXr0/dvsSK2wZMON5AM5Q7ZWYbtJvHH5+TL91vmZvvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=Dszj5M7U;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6696A606A323
	for <patches@lists.linux.dev>; Mon, 16 Nov 2026 08:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6696A606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=Dszj5M7U
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9661410EF78;
	Mon, 16 Nov 2026 09:47:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1794818861;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=qs1+XyJIBcRXvNK4eAjtS4NGdjhzHm1jJtJ5wQ/HE4A=;
	b=Dszj5M7U3OEX3vPhggvupYiDIDtgJ1CjrqH5Jt0f645TpAqgjRC9P+8/lrpkHKJ+4JoiTI
	L6UReXGEDu+KJYLwUgrhEDOaOLHm8TXhzjZsjwb1Cvq8TSacvTA4Zi7CQC+V2kbXr6z2Ec
	oJYa65T0uQ1X8vP0Ux1FzzD28Tw5cWSUL3S4IYBT8R50BW7hIMwlI/8f42jVXfRI2av8Qg
	Nr8K2WPco6yYOr8L9d1lNx14IvPMRsO1EjKVZuGoVCeILnDjUDnlM/+rpDR6UfPcoSs0l3
	x6LaUOrQKikwH0C250Caia2m9t8ssLX83VmU+40Km/H10RKzqjVPiq2+uJXVfA==
Date: Mon, 16 Nov 2026 09:47:36 +0100
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
Subject: Re: [PATCH 7.3 000/507] 7.3.5-rc1 review
Message-ID: <avrDKGcdTCqA4RFn@duo.ucw.cz>
References: <20261113153753.358973689@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7nLTaoNpBa1RI6kS"
Content-Disposition: inline
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--7nLTaoNpBa1RI6kS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.3.5 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We get build errors here:


236
19:06:22
  CC      arch/arm/kernel/asm-offsets.s
237
19:06:23
In file included from arch/arm/kernel/asm-offsets.c:12:
238
19:06:23
./include/linux/mmap_lock.h: In function 'vma_end_write_all':
239
19:06:23
./include/linux/mmap_lock.h:604:25: error: 'struct mm_struct' has no member named 'mm_lock_seq'
240
19:06:23
  604 |         if (unlikely(!mm->mm_lock_seq.sequence))
241
19:06:23
      |                         ^~
242
19:06:23
./include/linux/compiler.h:77:45: note: in definition of macro 'unlikely'
243
19:06:23
   77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
244
19:06:23
      |                                             ^
245
19:06:23
make[2]: *** [scripts/Makefile.build:185:
arch/arm/kernel/asm-offsets.s] Error 1

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/3065943408

Best regards,
								Pavel

--7nLTaoNpBa1RI6kS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCavrDKAAKCRAw5/Bqldv6
8ul/AJ9f+PnOukZPzcN2ZHZtw9cnclNmZACeMOiCeO2h+nlj4rHyzyH6uojigtI=
=Qmfa
-----END PGP SIGNATURE-----

--7nLTaoNpBa1RI6kS--
