Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF961392;
	Wed, 15 May 2024 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715791042; cv=none; b=lRFQRR4rHEJFJoKIT3JwIu79gzErJLbDlir65avi5khyYw0pi6FGz8M5z5xI0Kqu3cxMaffhInPe/cIVSHUOo5t6CHGohMP9vA4DtHfz9Qa+mRzLZwiAAWubP/jNwupRmkX+dretaE/LshJ2Mvjl1UF1GQ/oGGN3/Gij+hOa/qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715791042; c=relaxed/simple;
	bh=0tMiEjtIhhrV6qWrxU9Ts0un5z/tlxtQpnB1bCtwcdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ws2IA/pJ41gCz9Gq+MKiU0NqxLWRsm4IwRSsW5HiePuTXakLPyn6dP2lCsgcMC8FlKb9l1i9jSpolEwmw5cvocLuasg19DTWUvs3C0TRfcMNnTlsGS8AERARmizaEostCfmkPEedD2DEvk6gifAUWkLorwk2XUJvV+zH8ApaHhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCkFq80x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCkFq80x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C7BC2BD11;
	Wed, 15 May 2024 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715791042;
	bh=0tMiEjtIhhrV6qWrxU9Ts0un5z/tlxtQpnB1bCtwcdE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QCkFq80xx9jfySlsxc6UB2usPxKfAk143Uv8xl8duDNZ8T8jGcYvihZHn8qgpVnLv
	 VVC13bfxnKzIqUyEtp/a4diDY5Y+gIQwZThB2T3WSRZRv6lIfftjaaCFxscIeAsP2c
	 3zcLqSPTFHl09q5fSjSYHLGrEQBWVyA1aNntwnC9eVo8qlNHp9Yi/GlzDyHCF1szvK
	 07ltFu63sb/od6LcYpuUruNlxTPWvnTsSKc88FOxcQ18TgE4/zTisC1NdvMiamfEOW
	 ILdDrV/lz8fMkD7AVt1zF3Pa99xviIGNZrrLL0fTwpNpEoBlpBu8ri+XaqrQx1L9TE
	 taH+P2u6EPorg==
Date: Wed, 15 May 2024 17:37:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 6.8 000/340] 6.8.10-rc2 review
Message-ID: <8221e12b-4def-4faf-84c6-f2fe208a4bf3@sirena.org.uk>
References: <20240515082517.910544858@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BuVOGyPH4VUwyT8Q"
Content-Disposition: inline
In-Reply-To: <20240515082517.910544858@linuxfoundation.org>
X-Cookie: When in doubt, lead trump.


--BuVOGyPH4VUwyT8Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 15, 2024 at 10:27:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 340 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm seeing issues with the ftrace "Test file and directory owership
changes for eventfs" test on several platforms, including both 32 Arm
and whatever random x86_64 box Linaro have in their lab.  The logs
aren't terribly helpful since they just log a "not ok", example here:

  https://lava.sirena.org.uk/scheduler/job/265221#L3252

Bisects land on "eventfs: Do not differentiate the toplevel events
directory" as having introduced the issue.  Other stables don't seem to
be affected.

Bisect log (this one from a Raspberry Pi 3 in 32 bit mode):

# bad: [cfe824b75b3d9d13a891ad1c4a2d6fe0eceed1e9] Linux 6.8.10-rc2
# good: [f3d61438b613b87afb63118bea6fb18c50ba7a6b] Linux 6.8.9
# good: [428b806127e00d1c39ed72cbae36dbb4598e58dd] usb: dwc3: core: Prevent phy suspend during init
# good: [a336529a6498c3e7208415b1c2710872aebf04aa] drm/vmwgfx: Fix invalid reads in fence signaled events
# good: [dcca5ac4f5de7cca371138049a4a5877a6a3af97] hv_netvsc: Don't free decrypted memory
git bisect start 'cfe824b75b3d9d13a891ad1c4a2d6fe0eceed1e9' 'f3d61438b613b87afb63118bea6fb18c50ba7a6b' '428b806127e00d1c39ed72cbae36dbb4598e58dd' 'a336529a6498c3e7208415b1c2710872aebf04aa' 'dcca5ac4f5de7cca371138049a4a5877a6a3af97'
# bad: [cfe824b75b3d9d13a891ad1c4a2d6fe0eceed1e9] Linux 6.8.10-rc2
git bisect bad cfe824b75b3d9d13a891ad1c4a2d6fe0eceed1e9
# good: [00dfda4fc19df6f2235723e9529efa94cbc122a2] nvme-pci: Add quirk for broken MSIs
git bisect good 00dfda4fc19df6f2235723e9529efa94cbc122a2
# bad: [1239a1c5dc96166a0010de49e4769e08bc6d75b3] Bluetooth: qca: fix wcn3991 device address check
git bisect bad 1239a1c5dc96166a0010de49e4769e08bc6d75b3
# good: [a2ede3c7da39a8ab359cd23ebba04603e119ac59] ksmbd: do not grant v2 lease if parent lease key and epoch are not set
git bisect good a2ede3c7da39a8ab359cd23ebba04603e119ac59
# bad: [21b410a9ae24348d143dbfe3062eae67d52d5a76] eventfs: Do not differentiate the toplevel events directory
git bisect bad 21b410a9ae24348d143dbfe3062eae67d52d5a76
# good: [801cdc1467e661f2b151eeb8a25042593a487c78] tracefs: Still use mount point as default permissions for instances
git bisect good 801cdc1467e661f2b151eeb8a25042593a487c78
# first bad commit: [21b410a9ae24348d143dbfe3062eae67d52d5a76] eventfs: Do not differentiate the toplevel events directory

--BuVOGyPH4VUwyT8Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZE5LoACgkQJNaLcl1U
h9Bz3gf+NZwH9fS8Zly4ugFPSuJdr2X8oB6oOs2En+Q+WMs/sKaPaZw6ID39TXBJ
kACi9y6beMOJdN0Fb7VLvtZGF5P+DNuDM12fjg1dhfx0BmUBH99nPDCVUKRL3YPj
mF4T0chbiJGQoxugDS2ClicbDLYuyWOyLBLeB9xgMy4k1uZbI2k4OASMhHLF7yqc
+BsMb1CVqUoy6076IJxr9d6nBRhUS1uDGBROmE2yKC1wLMOoLTB9i1E+0suBQTJD
rbDu4mKNe3X42NKljvFNchzBI3TRqCAotlOqYDGU90CB4JAlF1StkTh8uCLK/T47
6g4dmECdPHR0uAQK6/3L66UvCIMIGg==
=Zxw0
-----END PGP SIGNATURE-----

--BuVOGyPH4VUwyT8Q--
