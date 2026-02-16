Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD22311956;
	Mon, 16 Feb 2026 14:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771252081; cv=none; b=R1gzjRVukxAfZEjcVmMa9x6dxRPTKGrQrFl5ncNS/lT/bma2NugTkSbNc6Fi7fOFaoqDw4D+RuEntcMdMgugcRj12nBWCmZxXL1AiEuRoTj/664TBy5VoRMV4NtKg4riOzqthlvkkDNFT9VBkoSkLKwjCfxqpeJMfbY/03saepE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771252081; c=relaxed/simple;
	bh=5nz2OJpV61GKofyMFvAjG4uF6VnT6LnAQ0wLv8/Wj3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4gFHdH617oky6StrlFUodVm+P4c0p8iuFn+9ZkYsV2EFXN9FvXXaK4Dd1VstW3RBXoiTFjzog0txQv5dD65l9KvlX5ok+nGxylCZZP8+yWijRVtKC+wvKI9dDcGAKB0HfJr2uc5Zdt8sAOvojo2VvnBte1fR9agzllzBZ21KQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKKTqoXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKKTqoXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392D3C19423;
	Mon, 16 Feb 2026 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771252081;
	bh=5nz2OJpV61GKofyMFvAjG4uF6VnT6LnAQ0wLv8/Wj3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fKKTqoXW4W+TtIDjfnenI14+xSIZHOzBLxVZMuyalJ8eVfM0tTFQ6A+ZvCbBxSw7O
	 4ExZGAgKccORaLELk1yTq+1214fQksQBIUjQu39P1CrjMqLJqPN3GK/60PfERMu5PK
	 o6hCEMXENrQEZNWTZQ/as0+Ab8SEaTeO6dUlqqzibcnlePu7guiKgN/Se1f4NSw141
	 2boL7ISrf9XiHoR+jVV+ma24ykEPCE23zYJmZItCj3KG0uHae0Tekk6zHdj0qjszzp
	 Dd6h7+b7rYI5olZQMLz9EtlEP5URerUPeAFRci/jhtbXgoaGT7gDLPA5MfQ7GfKdyu
	 etm/c67Z7/3Kw==
Date: Mon, 16 Feb 2026 14:27:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
Message-ID: <bde6d2f9-f554-49f1-9af8-084c4cdea035@sirena.org.uk>
References: <20260213134704.728003077@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3IOga9Aj2sP226xt"
Content-Disposition: inline
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
X-Cookie: Beware the one behind you.


--3IOga9Aj2sP226xt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 13, 2026 at 02:48:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.72 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

As I've mentioned before putting -rcs out on a Friday afternoon isn't
ideal for getting results...

> Gui-Dong Han <hanguidong02@gmail.com>
>     driver core: enforce device_lock for driver_match_device()

This breaks boot on at least the Arm Juno platform, upstream it
introduced regressions on quite a few systems due to drivers registering
in the probe of other devices.  That's obviously not a great pattern but
a regreession is a regression.

bisect:

# bad: [4b487d46d595999554fb81524f66ed3d1a73b615] Linux 6.12.72-rc1
# good: [ae591174b1f2e6b81ffe182fb621bba910bfb44e] Linux 6.12.71
git bisect start '4b487d46d595999554fb81524f66ed3d1a73b615' 'ae591174b1f2e6b81ffe182fb621bba910bfb44e'
# test job: [4b487d46d595999554fb81524f66ed3d1a73b615] https://lava.sirena.org.uk/scheduler/job/2455882
# bad: [4b487d46d595999554fb81524f66ed3d1a73b615] Linux 6.12.72-rc1
git bisect bad 4b487d46d595999554fb81524f66ed3d1a73b615
# test job: [b3b78ed0290627689bb76932b290f649d7a55ea7] https://lava.sirena.org.uk/scheduler/job/2456102
# bad: [b3b78ed0290627689bb76932b290f649d7a55ea7] wifi: rtw88: Fix alignment fault in rtw_core_enable_beacon()
git bisect bad b3b78ed0290627689bb76932b290f649d7a55ea7
# test job: [5be98c74259c3e953c4eb9989166b5b5225196a6] https://lava.sirena.org.uk/scheduler/job/2456393
# bad: [5be98c74259c3e953c4eb9989166b5b5225196a6] crypto: iaa - Fix out-of-bounds index in find_empty_iaa_compression_mode
git bisect bad 5be98c74259c3e953c4eb9989166b5b5225196a6
# test job: [c9e18834e4b2f69c0b1798440b9d531109cc16f2] https://lava.sirena.org.uk/scheduler/job/2456585
# good: [c9e18834e4b2f69c0b1798440b9d531109cc16f2] smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()
git bisect good c9e18834e4b2f69c0b1798440b9d531109cc16f2
# test job: [c34376e5a52a35ade9960d259ca1e8910db72013] https://lava.sirena.org.uk/scheduler/job/2456855
# bad: [c34376e5a52a35ade9960d259ca1e8910db72013] Bluetooth: btusb: Add USB ID 7392:e611 for Edimax EW-7611UXB
git bisect bad c34376e5a52a35ade9960d259ca1e8910db72013
# test job: [3454ada4952bf8ac7c9a7b6aec0e18aa87226170] https://lava.sirena.org.uk/scheduler/job/2457085
# bad: [3454ada4952bf8ac7c9a7b6aec0e18aa87226170] driver core: enforce device_lock for driver_match_device()
git bisect bad 3454ada4952bf8ac7c9a7b6aec0e18aa87226170
# first bad commit: [3454ada4952bf8ac7c9a7b6aec0e18aa87226170] driver core: enforce device_lock for driver_match_device()

--3IOga9Aj2sP226xt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmTKWkACgkQJNaLcl1U
h9BKQQf9FqauNyb5+361+eFHS8cjLhCHpyAUjSwmNCA+oGXA7LTSo6r7QZC8souA
XKUhVKWsZienkjQlPGaBwob+v3LSVBAKRpyGiaVtrWjcOFCkzFphVOmuj2sE1a2O
HR6xPPITk6dpN8J2C6Q1vnvuvsiyjAnAFnnpM3py++RU/Qf45xy/675PUdGIfkh+
EVr+EqBRxtBVOE/qbyRhG5gJMV+fwWDTbsXGn2WzSOLQMUUl4xT+dUu/gBx92bXz
ltyAY8AOcreZABz3UbHQHtbd2mojo5Bet7epAPXDu6LJopVFA9rKozZ0dChy/cRH
6S34p0X8KNhicVZ0Jxfmk7GxA3xwNw==
=hfwa
-----END PGP SIGNATURE-----

--3IOga9Aj2sP226xt--
