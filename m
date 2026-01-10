Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A9327FB0E;
	Sat, 10 Jan 2026 11:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768044210; cv=none; b=s3aAzTdKDV7G1Wj1wohuuGeMkwHSw8SSJAdDPj7y6YS9JEv2z6jY4FsyxolHj2HsAgjW86Kt9ol1LPnhaSFxgeG/1sFRwdsyhjrMH1rHHM0nDXEao/5Gsq6zY/wNFXJyjxNgAwmvKd4UjLbl2iT72JLUL9pEINu6OAnupMSJbns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768044210; c=relaxed/simple;
	bh=0/IeUtzP+xAu2JJQcIiXAOy5a/M4w5bb0IoEt0I2xjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8kp+TOWJFkYiN/it5HseSZi+QJfn2XWxIEmWSy6CgguIAJ2j9tpE0D4ekrAgayalpyrh7tcYb4W1OsOBueIvaHXbl3NFpL3dNW6f6QM3l599tBi33jzB1dwePIn+hhm8RGQhS5pZb+rYSSOUM3zQ1q/rJnZLz5xv8R/1D/7ACc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1fV08aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1fV08aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3B7C4CEF1;
	Sat, 10 Jan 2026 11:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768044209;
	bh=0/IeUtzP+xAu2JJQcIiXAOy5a/M4w5bb0IoEt0I2xjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l1fV08aNxjTMRR98cGSGMlIU6S7WWusJNeynUIjD8vHVFn7MmfeV8O2IiSd1YSXs1
	 uo0oGffoELQTpGfDW/zsGW/UoHPN/61VnDF+ppRXfTacktpOkwD+d+vuApNFlExuNi
	 BLc4EBfbvYX/INMmyoZBCKy4yBeDtOMOxiczJLzfmxVFmqS9I/zPmCohYxXCLjat/D
	 ItcvAL1fubDqSoENO+h+XGZZ323bZNF6Z8J+zaHskObPPTBaa7Prj3fnZkMPkZc3NG
	 aMqP/LWKLbGAOlGC7ft7mr0JCXIe0nykuyMAijQP/UuOxgo6pp45GsUknCJIJMqnlK
	 c7gUzAx9Iokmw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 7BCA51AC5681; Sat, 10 Jan 2026 20:23:20 +0900 (JST)
Date: Sat, 10 Jan 2026 11:23:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Francesco Dolcini <francesco@dolcini.it>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
Message-ID: <aWI2qATUQXAW-Bxx@sirena.co.uk>
References: <20260109112117.407257400@linuxfoundation.org>
 <20260110084142.GA6242@francesco-nb>
 <2026011010-parasitic-delicacy-ef5e@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="p8L7mMMQ7kXlKRsh"
Content-Disposition: inline
In-Reply-To: <2026011010-parasitic-delicacy-ef5e@gregkh>
X-Cookie: Think big.  Pollute the Mississippi.


--p8L7mMMQ7kXlKRsh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 10, 2026 at 09:53:28AM +0100, Greg Kroah-Hartman wrote:
> On Sat, Jan 10, 2026 at 09:41:42AM +0100, Francesco Dolcini wrote:

> > [   10.427811] Call trace:
> > [   10.430266]  dwmac4_dma_interrupt+0x120/0x270 [stmmac]
> > [   10.435460]  stmmac_interrupt+0xb0/0x150 [stmmac]
> > [   10.440218]  __handle_irq_event_percpu+0x5c/0x170

> Can you run git bisect to find the offending commit?

I've got that board as well and am seeing the issue too, the bisect
comes out at:

[c657c6cbac472125a03d7bfb6137e6e23ebb7081] net: stmmac: protect updates of 64-bit statistics counters

I'm also seeing bisects of similar boot failures pointing to the same
commit on at least i.MX8MP-EVK and Libretech Potato.  Bisect log for the
board Francesco originally reported, the others all look the same:

# bad: [b40085af0da566f50bdc006adfb80480c7a967be] Linux 6.1.160-rc1
# good: [50cbba13faa294918f0e1a9cb2b0aba19f4e6fba] Linux 6.1.159
git bisect start 'b40085af0da566f50bdc006adfb80480c7a967be' '50cbba13faa294918f0e1a9cb2b0aba19f4e6fba'
# test job: [b40085af0da566f50bdc006adfb80480c7a967be] https://lava.sirena.org.uk/scheduler/job/2358072
# bad: [b40085af0da566f50bdc006adfb80480c7a967be] Linux 6.1.160-rc1
git bisect bad b40085af0da566f50bdc006adfb80480c7a967be
# test job: [0eef340004c728d5ed9289b8355b85fd0f746adb] https://lava.sirena.org.uk/scheduler/job/2358118
# good: [0eef340004c728d5ed9289b8355b85fd0f746adb] vhost/vsock: improve RCU read sections around vhost_vsock_get()
git bisect good 0eef340004c728d5ed9289b8355b85fd0f746adb
# test job: [1bc9e80077c9c82a192884190b47e256fd5c2e04] https://lava.sirena.org.uk/scheduler/job/2358164
# good: [1bc9e80077c9c82a192884190b47e256fd5c2e04] fbdev: pxafb: Fix multiple clamped values in pxafb_adjust_timing
git bisect good 1bc9e80077c9c82a192884190b47e256fd5c2e04
# test job: [9a848f3440f502df433309c9bf0e8734a76e8cac] https://lava.sirena.org.uk/scheduler/job/2358225
# good: [9a848f3440f502df433309c9bf0e8734a76e8cac] f2fs: fix to avoid updating compression context during writeback
git bisect good 9a848f3440f502df433309c9bf0e8734a76e8cac
# test job: [c153ef089aa70781cb00b747f8eb078a95c7286a] https://lava.sirena.org.uk/scheduler/job/2358441
# good: [c153ef089aa70781cb00b747f8eb078a95c7286a] net: Remove RTNL dance for SIOCBRADDIF and SIOCBRDELIF.
git bisect good c153ef089aa70781cb00b747f8eb078a95c7286a
# test job: [cb3c86df8622d286df0325ac0398a5923afda0b8] https://lava.sirena.org.uk/scheduler/job/2358497
# good: [cb3c86df8622d286df0325ac0398a5923afda0b8] sched/fair: Small cleanup to sched_balance_newidle()
git bisect good cb3c86df8622d286df0325ac0398a5923afda0b8
# test job: [c5f4e3a377a77899380d01338b945a843ba4d3c0] https://lava.sirena.org.uk/scheduler/job/2358521
# good: [c5f4e3a377a77899380d01338b945a843ba4d3c0] Revert "iommu/amd: Skip enabling command/event buffers for kdump"
git bisect good c5f4e3a377a77899380d01338b945a843ba4d3c0
# test job: [320c50b6fcb19466f63a964c11ef4d5ca0c792d3] https://lava.sirena.org.uk/scheduler/job/2358630
# good: [320c50b6fcb19466f63a964c11ef4d5ca0c792d3] net: stmmac: fix incorrect rxq|txq_stats reference
git bisect good 320c50b6fcb19466f63a964c11ef4d5ca0c792d3
# test job: [c657c6cbac472125a03d7bfb6137e6e23ebb7081] https://lava.sirena.org.uk/scheduler/job/2358871
# bad: [c657c6cbac472125a03d7bfb6137e6e23ebb7081] net: stmmac: protect updates of 64-bit statistics counters
git bisect bad c657c6cbac472125a03d7bfb6137e6e23ebb7081
# test job: [0c900ef4d40a90b1f0995ac3fbee15b9a0771a4b] https://lava.sirena.org.uk/scheduler/job/2358897
# good: [0c900ef4d40a90b1f0995ac3fbee15b9a0771a4b] net: stmmac: fix ethtool per-queue statistics
git bisect good 0c900ef4d40a90b1f0995ac3fbee15b9a0771a4b
# first bad commit: [c657c6cbac472125a03d7bfb6137e6e23ebb7081] net: stmmac: protect updates of 64-bit statistics counters

--p8L7mMMQ7kXlKRsh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmliNqUACgkQJNaLcl1U
h9CLXAf8D+MOrwUqiw3GwuxNz49d9cL64ugBQUrIJJWGj89n74J8v3gsd87KELGx
K+RHUaCIehPGbspsvi7qgpNUJ+mVzXbga4wyR0DNgvWzUtNJR66gJoINlsvfRq/x
QLh9Kc05fdL0oSWD+I8kMuRpW7DkU9GnREjW3D2JBEbgO/jL9+mrCHI0TvwEBoSa
q1FTjcZOCS9Vfb/s1uK9iUu86vpoJPwiOW9Vpkh2u5HguCO3jQ4pvLoGjrIvXTx7
KuznPd0eCHJehmJ3GmZguCTsHptaKyMDl7RZ5BJgpCjSTNBj+1U8pXPWTG3BM+WY
KS/0UWiXKqcm4OPTj+HezGxrXGS4Hw==
=FqGH
-----END PGP SIGNATURE-----

--p8L7mMMQ7kXlKRsh--
