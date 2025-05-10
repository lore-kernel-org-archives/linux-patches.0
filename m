Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693431DA53;
	Sat, 10 May 2025 01:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746841277; cv=none; b=NTBNeHg2Ejckf7Hy3hoHGJ9ECdxPkwWLWL5MerodM1qRH1Seuir94IZkR3Dh/HyRAwofkj9A/VGnE6655BtI4vsL5Cokp2bjlha5cFk2ts+eBDjdpCM4GAedzv8X+4g/Zn3Rxdbv3C/iawgat19eJE/NLCk/D3Rxjq5DcgyqIsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746841277; c=relaxed/simple;
	bh=mDi0TIGJZ63a/quHDmKu4WHXpA8aYV3xArV1tE2GZUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T34wm5MbYkHoDv1tHYnO1z6i20vbBvimwRx07L5iiFDT6htssByb9FpT1jf0wY4h7EPk4OMyxMyskAnwjspO75M7NW1aSlsgNfU1sV1GQLpA1uVO0q0yyca2E/h+faQj248+qeca+xjHqPKc5UBSY1YrqcfUX2tvUmDiQ6AF67w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6ohMaIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6ohMaIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA748C4CEE4;
	Sat, 10 May 2025 01:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746841277;
	bh=mDi0TIGJZ63a/quHDmKu4WHXpA8aYV3xArV1tE2GZUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i6ohMaIHto9aIPdGVKoBmf9YSJTUUJlr0AE8DLQ2nLts87uSUuuEY605B574Sdx+O
	 CgC3NJ2cgtWoXPQpIm24eP8NLrdbsditChljgljeN5s0YKfyv/DqW+xjCAAKZBH7hZ
	 9D3Z5NVRGYQtPZ3ylYeKd4ctPY6tVH86zd0AoJG1iVCJvC4uiT6eieLtKE4Yj4B8RN
	 BnnAmZmYgwOSr2G7Kp7qfekuR+YsgSISXgEEIz55TbI8+tm9MQjEri0U0vCjWjEz2z
	 5rB/mqhD/yfKKTS6FvHVi4LR8236BlUCB1vjXNcZFGXEMx36D7PYAmWQxLfRcjBXpi
	 rmbRM4BqrGRkg==
Date: Sat, 10 May 2025 10:41:14 +0900
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
Message-ID: <aB6uurX99AZWM9I1@finisterre.sirena.org.uk>
References: <20250508112609.711621924@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vLsmwX0+DaTA6DXO"
Content-Disposition: inline
In-Reply-To: <20250508112609.711621924@linuxfoundation.org>
X-Cookie: Well begun is half done.


--vLsmwX0+DaTA6DXO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2025 at 01:30:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.138 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This breaks NFS boot on Rasperry Pi 3B - it's the previously reported
issue with there apparently being no packets coming in that was seen on
some of the more recent stables (not finding the mails immediately).
Bisects didn't kick off automatically but I suspect it's:

   net: phy: microchip: force IRQ polling mode for lan88xx

This also seems to apply to v5.15.

--vLsmwX0+DaTA6DXO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgerrkACgkQJNaLcl1U
h9CSOgf/RNNrifNkTEqtk9Zrv+V1rXeendgZANWf3l61O5jmLzKZfT+IdD7c+Paw
PDNVqYa1o+L1Yt0DJmNOegyu9bpvVn/XFZTLyuCTHCbYP0DLkb7K5Kyoig0qPvNP
gp2oOwpFixEHOyVv25LX9G1kLRagAEPr/2m5S3DxkYB9/8Ur5eiIkfknGQIq8bd7
EUNTJnie2itcB0GessOtHmIPM0/sXNBybYJBsi1+DEtLR0UFfq3SlWcxQldsOC/y
kNJy3vGp/BY5kAXHUs4i93P5eVYoBgdGIKgPSLQtU2L6OMT+BxLwBcILbC8WbYVg
Gp28UPV2G6Rn3JKJjRISQMfTHe2Z0Q==
=+S/v
-----END PGP SIGNATURE-----

--vLsmwX0+DaTA6DXO--
