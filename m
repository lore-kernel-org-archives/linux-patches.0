Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C13F13DB9B;
	Wed,  7 Aug 2024 17:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723052571; cv=none; b=svT18Plc2gKaA1oJ7PzLiZyI5DVCh1j/3n3FvlcmjrK/zsYBJGPr9Uk8XAwxMxh5hhd2uIfEUPyOvhsAZlQbItfEkxlhMiaswlzimft6oz47fsoREG9jPMFbJmqoy5VS2hDEtgVcVWXTPcF/VmDTTykDOuS3u96152HyUKS9pwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723052571; c=relaxed/simple;
	bh=aQC/ycRBP4LA6jOd4l/ZKmSMmEaADeLl3V1gHA4xY0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dEFExebgic28eY4H0NMFeNXp0U8taR8F51kHfl4xxeBZRK+sEMrmnXqToZ1wASScgB1NPENqqxFRDCGUz50M2JX6BCN2rwedKdjQ1ix3VyBzyLAbZKJqKVBDkVVxoRUpIeo6MLrs18FKdldHlweDvlyxD0o775vC7WYYaQOVzeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxn/TRBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxn/TRBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43900C32781;
	Wed,  7 Aug 2024 17:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723052570;
	bh=aQC/ycRBP4LA6jOd4l/ZKmSMmEaADeLl3V1gHA4xY0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nxn/TRBsteNbqFpMAapwDE5W0jMS2NSKYy/9Sl0ynEVHe1c/w1slTVkTMfD5ei06J
	 0xwKxheWp4SJdr78mTATMdEKRYEAUcael1fcMYA5YDl/VW5eJsAhxkvahYy4d95E09
	 XTEsuTWI2/RNYN1sNhmw26MTNdthehKsyD/Pi6Yrvh6Z21eHNbhxyv1zARmKQ6xbHc
	 8wqABA+3BLSByGaIIm6UEHv5zfUFcEtXB9cvR9UmHE01XwqBUyX1sf3gW9t/W0aSE0
	 SlXgnagIsGZe9LRyu0mJQelVmV6L711yZONcx12+9WDJojXjpDgBh5Bw5EF+lF8xyK
	 1PPEwMXmYy5VA==
Date: Wed, 7 Aug 2024 18:42:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc1 review
Message-ID: <3f2a3f15-5a77-415a-b491-5e33ad3b351c@sirena.org.uk>
References: <20240807150039.247123516@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OPFcUyCl/KO/fYT5"
Content-Disposition: inline
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
X-Cookie: Offer may end without notice.


--OPFcUyCl/KO/fYT5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 07, 2024 at 04:59:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.104 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This breaks boot for an arm multi_v7_defconfig on qemu
virt-2.11,gic-version=3D3 with the oops below.  Full log including the
qemu parameters at:

   https://lava.sirena.org.uk/scheduler/job/617206

Bisect running but I'm not sure when I'll have time to pull the results
out.

<6>[    0.000000] GICv3: 224 SPIs implemented
<6>[    0.000000] GICv3: 0 Extended SPIs implemented
<6>[    0.000000] GICv3: GICv3 features: 16 PPIs
<6>[    0.000000] GICv3: CPU0: found redistributor 0 region 0:0x080a0000
<1>[    0.000000] 8<--- cut here ---
<1>[    0.000000] Unable to handle kernel NULL pointer dereference at virtu=
al address 00000001
<1>[    0.000000] [00000001] *pgd=3D00000000
<0>[    0.000000] Internal error: Oops: 805 [#1] SMP ARM
<4>[    0.000000] Modules linked in:
<4>[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.1.104-rc1-000=
87-gb22fe5fc2a45 #1
<4>[    0.000000] Hardware name: Generic DT based system
<4>[    0.000000] PC is at _set_bit+0x4/0x40
<4>[    0.000000] LR is at enable_percpu_irq+0x64/0xcc
<4>[    0.000000] pc : [<c10c58e4>]    lr : [<c03a6f90>]    psr: 000000d3
<4>[    0.000000] sp : c1b01df8  ip : 00000001  fp : 00000001
<4>[    0.000000] r10: 08000000  r9 : c1da9624  r8 : c1b0adb8
<4>[    0.000000] r7 : 00000000  r6 : 00000010  r5 : c208b800  r4 : 00000000
<4>[    0.000000] r3 : c1b09780  r2 : 00000000  r1 : c200574d  r0 : 00000000
<4>[    0.000000] Flags: nzcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Se=
gment none
<4>[    0.000000] Control: 10c5387d  Table: 4020406a  DAC: 00000051
<1>[    0.000000] Register r0 information: NULL pointer
<1>[    0.000000] Register r1 information: slab kmalloc-64 start c2005740 p=
ointer offset 13 size 64
<1>[    0.000000] Register r2 information: NULL pointer
<1>[    0.000000] Register r3 information: non-slab/vmalloc memory
<1>[    0.000000] Register r4 information: NULL pointer
<1>[    0.000000] Register r5 information: slab kmalloc-256 start c208b800 =
pointer offset 0 size 256
<1>[    0.000000] Register r6 information: zero-size pointer
<1>[    0.000000] Register r7 information: NULL pointer
<1>[    0.000000] Register r8 information: non-slab/vmalloc memory
<1>[    0.000000] Register r9 information: non-slab/vmalloc memory
<1>[    0.000000] Register r10 information: non-paged memory
<1>[    0.000000] Register r11 information: non-paged memory
<1>[    0.000000] Register r12 information: non-paged memory
<0>[    0.000000] Process swapper/0 (pid: 0, stack limit =3D 0x(ptrval))
<0>[    0.000000] Stack: (0xc1b01df8 to 0xc1b02000)
<0>[    0.000000] 1de0:                                                    =
   00000008 c1905bdc
<0>[    0.000000] 1e00: 600000d3 00000000 c1b01e44 00000000 c1b04cdc 000000=
00 c1b09780 c030ee40
<0>[    0.000000] 1e20: c1b05a38 dbbd8514 00000000 c1932778 c1b01e44 000000=
00 00000000 00f60000
<0>[    0.000000] 1e40: 00000000 dbbd8514 00000001 00000000 00000000 000000=
00 00000000 00000000
<0>[    0.000000] 1e60: 00000000 00000000 00000000 00000000 00000000 000000=
00 00000000 00000000
<0>[    0.000000] 1e80: 00000000 00000000 00000000 00000000 dbbd8508 080000=
00 e0810000 c2005680
<0>[    0.000000] 1ea0: 00000001 c2005690 c1675080 c19329fc 00000000 000000=
00 dbbd8514 c177f004
<0>[    0.000000] 1ec0: 00000001 c1a4bc20 00000000 00000000 00000000 080a00=
00 08ffffff dbbd8574
<0>[    0.000000] 1ee0: 00000200 00000000 00000000 00000000 00000000 c0ea29=
44 c1a4f89c 00000000
<0>[    0.000000] 1f00: 00000000 c1a4f960 00000000 00000000 00000000 000000=
00 c1b01f4c c20055c0
<0>[    0.000000] 1f20: 00000000 c1b01f4c c1b01f54 c1b01f4c 00000122 000001=
00 c162c61c c19a3cbc
<0>[    0.000000] 1f40: 00000000 00000000 00000000 c1b01f4c c1b01f4c c1b01f=
54 c1b01f54 00000000
<0>[    0.000000] 1f60: c1b09268 c19cda5c c1a54000 c1b04e48 c1900fe0 dbfff0=
80 00000000 c178fa04
<0>[    0.000000] 1f80: c1b09268 c1903c50 c1900fe0 c1d6a000 c1d998b0 c1d6a0=
00 c1d998b0 c1b04cc0
<0>[    0.000000] 1fa0: dbfff088 c1900fe0 ffffffff ffffffff 00000000 c19006=
ec c1b09780 c178fa04
<0>[    0.000000] 1fc0: 00000000 c19cda6c 00000000 00000000 00000000 c19004=
20 00000051 10c0387d
<0>[    0.000000] 1fe0: ffffffff 48786000 414fc0f0 10c5387d 00000000 000000=
00 00000000 00000000
<0>[    0.000000]  _set_bit from enable_percpu_irq+0x64/0xcc
<0>[    0.000000]  enable_percpu_irq from ipi_setup+0x34/0x80
<0>[    0.000000]  ipi_setup from gic_init_bases+0x5cc/0x68c
<0>[    0.000000]  gic_init_bases from gic_of_init+0x1c4/0x2cc
<0>[    0.000000]  gic_of_init from of_irq_init+0x1d4/0x324
<0>[    0.000000]  of_irq_init from init_IRQ+0xb0/0x110
<0>[    0.000000]  init_IRQ from start_kernel+0x528/0x6e4
<0>[    0.000000]  start_kernel from 0x0
<0>[    0.000000] Code: e12fff1e e3e0000d e12fff1e e211c003 (15cc1000)=20
<4>[    0.000000] ---[ end trace 0000000000000000 ]---
<0>[    0.000000] Kernel panic - not syncing: Attempted to kill the idle ta=
sk!

--OPFcUyCl/KO/fYT5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmazshMACgkQJNaLcl1U
h9AOaQf7Bkl3Xk+AlTUkSwAhQQ8+TCAKu3zvb2dsQfFh7GehxzwkNrhq8NhTtG2i
dszTTX7CzPL7PeWGv4xZz7TWuBvKPB2wAk6NT1WecaOIYn3dXs9RntsgQjB7lqFM
wCMbbTx2xkSednbySqLZhgs83yi72EKFzZAB3+NrXW8kr7j9X/AlY9TkVnyVYYZn
dobvsWLH2p11aSCJe9V1CIOTMb0cHiH07JXmg/8KTri4xAsoZv2n6s8TNA7RHhH3
jxkj51W0OzADwTIWNOv43J/QOCZrVMWSapuu0l+zZ5NCER/QwikKN1WH89lp7nVW
tGpgtyeZ2+mJyPUb2f4gcubXTETOcg==
=n79s
-----END PGP SIGNATURE-----

--OPFcUyCl/KO/fYT5--
