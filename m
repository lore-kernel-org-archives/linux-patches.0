Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5110428F5;
	Sun, 11 May 2025 01:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746927200; cv=none; b=sfD4nmGGBoUCOsSjNg47aSx97bwHerZ8BQtspUl8DMGRowQYxAnETdD6MaJ23Kx1BxInZMxY4m3VHAwWkGl+IH8oQwEeLFk+i5H79rNip+0uauC9fbh8TfmaeI07vuyFaJzFOY5xnm5mZgozX7PBStNj9d/yDO/UOI/vEg/w5zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746927200; c=relaxed/simple;
	bh=Deo/eI9+9XENJGSG6W/1LVzdL6Qtef7+y9Q2k/oAmxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nygN5OYXIjyN/lpOoFL9vKe15g1pWEFpp3LdFSnaQEuUU/+j0H3vPBNm+GwbxwMxJrQWXWIy2Wb41yd9x02+CnukEFo5wRqgNaYFMRFh+XR0sTGczT0CsNFCHfJcWVCx1pqrUUnXajRcxDkmrdyUa4cYNBcK52KKmu3kNN3qg4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYgZgeFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYgZgeFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A730C4CEE2;
	Sun, 11 May 2025 01:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746927196;
	bh=Deo/eI9+9XENJGSG6W/1LVzdL6Qtef7+y9Q2k/oAmxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nYgZgeFrZeii4Z7bEVcS5vpnsMNY1qZFp9NNI6wlbsMQcjf55OM1Z7yANSK223FR2
	 2U4/5K8IGj4W+M/WuZPwXwTfz9um9BhkynvCpeuvlfB94l/ZbzlbXatnRtMU2dNasG
	 OBNJ6eAmrEhgFVZAP8BeUbnI3dtMFI++HeGcXa4V1Ex08xudP3mBXTm0EBxwtFVJIf
	 Ogn0K2lkx4uTpLtvxOBLX1H0vQwfefJm01z4GNj3nLbQYJO4BvE8DgL5lXV35lDN3K
	 5nSBGKYAk0/Mrzb1pJInnw6WJ+80Jd8faVKyHcV/fhntGsQtBeX9ITa/zA3iOw3Raf
	 fKGfa0skxoXlw==
Date: Sun, 11 May 2025 10:33:13 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc2 review
Message-ID: <aB_-WZgMn02vgjrN@finisterre.sirena.org.uk>
References: <20250508112609.711621924@linuxfoundation.org>
 <aB6uurX99AZWM9I1@finisterre.sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2kDnZ+WQa5pDWb7O"
Content-Disposition: inline
In-Reply-To: <aB6uurX99AZWM9I1@finisterre.sirena.org.uk>
X-Cookie: Well begun is half done.


--2kDnZ+WQa5pDWb7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 10, 2025 at 10:41:17AM +0900, Mark Brown wrote:
> On Thu, May 08, 2025 at 01:30:23PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.138 release.
> > There are 97 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> This breaks NFS boot on Rasperry Pi 3B - it's the previously reported
> issue with there apparently being no packets coming in that was seen on
> some of the more recent stables (not finding the mails immediately).
> Bisects didn't kick off automatically but I suspect it's:
>=20
>    net: phy: microchip: force IRQ polling mode for lan88xx
>=20
> This also seems to apply to v5.15.

The bisect completed, confirmed it's the above commit (though apparently
it was already broken so something's screwy with my automation here...):

# bad: [02b72ccb5f9df707a763d9f7163d7918d3aff0b7] Linux 6.1.138
# good: [535ec20c50273d81b2cc7985fed2108dee0e65d7] Linux 6.1.135
# good: [ac7079a42ea58e77123b55f5e15f1b2679f799aa] Linux 6.1.137
# good: [b6736e03756f42186840724eb38cb412dfb547be] Linux 6.1.136
git bisect start '02b72ccb5f9df707a763d9f7163d7918d3aff0b7' '535ec20c50273d=
81b2cc7985fed2108dee0e65d7' 'ac7079a42ea58e77123b55f5e15f1b2679f799aa' 'b67=
36e03756f42186840724eb38cb412dfb547be'
# test job: [ac7079a42ea58e77123b55f5e15f1b2679f799aa] https://lava.sirena.=
org.uk/scheduler/job/1356125
# test job: [b6736e03756f42186840724eb38cb412dfb547be] https://lava.sirena.=
org.uk/scheduler/job/1349213
# test job: [02b72ccb5f9df707a763d9f7163d7918d3aff0b7] https://lava.sirena.=
org.uk/scheduler/job/1375898
# bad: [02b72ccb5f9df707a763d9f7163d7918d3aff0b7] Linux 6.1.138
git bisect bad 02b72ccb5f9df707a763d9f7163d7918d3aff0b7
# test job: [94107259f972d2fd896dbbcaa176b3b2451ff9e5] https://lava.sirena.=
org.uk/scheduler/job/1379135
# good: [94107259f972d2fd896dbbcaa176b3b2451ff9e5] net: ethernet: mtk-star-=
emac: fix spinlock recursion issues on rx/tx poll
git bisect good 94107259f972d2fd896dbbcaa176b3b2451ff9e5
# test job: [8dcd4981166aedda08410a329938b11a497c7d5d] https://lava.sirena.=
org.uk/scheduler/job/1379203
# good: [8dcd4981166aedda08410a329938b11a497c7d5d] md: move initialization =
and destruction of 'io_acct_set' to md.c
git bisect good 8dcd4981166aedda08410a329938b11a497c7d5d
# test job: [36d4ce271b97d7d23a67e690b79e04ea853325b1] https://lava.sirena.=
org.uk/scheduler/job/1379282
# bad: [36d4ce271b97d7d23a67e690b79e04ea853325b1] Revert "drm/meson: vclk: =
fix calculation of 59.94 fractional rates"
git bisect bad 36d4ce271b97d7d23a67e690b79e04ea853325b1
# test job: [be9e23028113446add10a9b66cf8f15c66a6257f] https://lava.sirena.=
org.uk/scheduler/job/1379397
# good: [be9e23028113446add10a9b66cf8f15c66a6257f] sch_ets: make est_qlen_n=
otify() idempotent
git bisect good be9e23028113446add10a9b66cf8f15c66a6257f
# test job: [88d7fd2d4623b2cb13d056e1bde1861e4dec2408] https://lava.sirena.=
org.uk/scheduler/job/1379447
# good: [88d7fd2d4623b2cb13d056e1bde1861e4dec2408] firmware: arm_ffa: Skip =
Rx buffer ownership release if not acquired
git bisect good 88d7fd2d4623b2cb13d056e1bde1861e4dec2408
# test job: [9b89102fbb8fc5393e2a0f981aafdb3cf43591ee] https://lava.sirena.=
org.uk/scheduler/job/1379515
# bad: [9b89102fbb8fc5393e2a0f981aafdb3cf43591ee] net: phy: microchip: forc=
e IRQ polling mode for lan88xx
git bisect bad 9b89102fbb8fc5393e2a0f981aafdb3cf43591ee
# test job: [72a797facb50aeef98a9d56b6b49674dbf53f692] https://lava.sirena.=
org.uk/scheduler/job/1379549
# good: [72a797facb50aeef98a9d56b6b49674dbf53f692] ARM: dts: opos6ul: add k=
sz8081 phy properties
git bisect good 72a797facb50aeef98a9d56b6b49674dbf53f692
# first bad commit: [9b89102fbb8fc5393e2a0f981aafdb3cf43591ee] net: phy: mi=
crochip: force IRQ polling mode for lan88xx


--2kDnZ+WQa5pDWb7O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgf/lgACgkQJNaLcl1U
h9CG/wf9HB4pfEqgyC/RiRPPSfJK6k54J/8oC/Kai8I/RvYhuzUn1n0AI8tA2Eif
1IcYkEhrW3UWvflrLSr1yRlsHRcGoBQC2CChgSKfN59NUHKHKGYcukJ1UzbFcMZS
4WK/cY/D3eGG5W4eafdoOIJUBvcyfJeDFlaTu1x+xJu/SKFZ0DJwCb0HcP+Ki4kF
tzWA53PV0ZWHgagwbCxMspPZP8zDvToX6xhQbHGPF9g2XydpiXmkkM/OvF4TEqOw
PURpfC+XlUG7/5H1lZ863rA2whd28/U6EALGaR5aUrb9YvukwJ1fs91pXDXIgWFB
46+mWL00yM4dgKULSYwFuoh5dNBXCQ==
=iwrk
-----END PGP SIGNATURE-----

--2kDnZ+WQa5pDWb7O--
