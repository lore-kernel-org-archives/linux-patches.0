Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D17D255229;
	Wed,  5 Mar 2025 20:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741205586; cv=none; b=uDM7S2v0eZckVTGK4UK75YDzSDC38J8kgVb0ybOoURam1NyhhaOvLtWEPS3VfqvmuD/40eJMbPw21f90yvTJHKjnhD751Gdoz1myBA2A9j011fci5h+jfe209zeWokEOY7waIwGlzGCc1u0DQxHG/Ean6nn0N7tIJk7ivbezLdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741205586; c=relaxed/simple;
	bh=hFo6rL+75WRubYu2f6ja0U/pMo0LSXFLvVGX6KuwvtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLEQnDadcekVK/KPL2IU6s1LnU8/WqNAkz38C7OKQGk4zWWGgHreoczUfNLOV7SJGBmR1E2sduA4f8hZ2xeiuNmfYUbjOMVdma4syxM26c8S6wwlyK7knnkT4sh03V0AY3q0m1+M7Z3vbvosiTmxKHhsPjEr1uAare7lbPwMe2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiqhWiXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiqhWiXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24B2C4CED1;
	Wed,  5 Mar 2025 20:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741205586;
	bh=hFo6rL+75WRubYu2f6ja0U/pMo0LSXFLvVGX6KuwvtM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oiqhWiXST//UvY/UvsYdMfpv5viv2p+Pj0amK1NnxWSR8UV6SsFSHp225SHGSxB9U
	 6R/uz5LEPT8Zwn3q0j+gWy6UgO3MdOcj0wz7mdXSNfkCtYERFGGyeus5Qte6CZCeIY
	 3OWvolhKVlszGy8G/UH15LSe+hGeHSstP57oWoBi/5FtCf4jZdCiE3ETvtecjLcJMk
	 6f67bFzL1hL5V3/r+o8xLedPMs+vxgv9hfrRlBveTB+AXWKiluiJOPiwrG/ceNntHd
	 P1sqnoKD7TmzQgTuT+IvfasOwwJzpdhWz8fakZTuasxuTc+QpeKY0DVbgO76FjfM1N
	 4uHlJpJGzzCgQ==
Date: Wed, 5 Mar 2025 20:12:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/157] 6.13.6-rc1 review
Message-ID: <8433c362-1909-4a2e-b41f-c0f5677286d2@sirena.org.uk>
References: <20250305174505.268725418@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YLIFX1f4k5OCHHnW"
Content-Disposition: inline
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
X-Cookie: Everybody gets free BORSCHT!


--YLIFX1f4k5OCHHnW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 05, 2025 at 06:47:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

The arm64 defconfig build is broken (KernelCI reported this initially):

/build/stage/linux/arch/arm64/mm/hugetlbpage.c: In function =E2=80=98huge_p=
tep_get_and_clear=E2=80=99:
/build/stage/linux/arch/arm64/mm/hugetlbpage.c:397:35: error: =E2=80=98sz=
=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98s8=
=E2=80=99?
  397 |         ncontig =3D num_contig_ptes(sz, &pgsize);
      |                                   ^~
      |                                   s8
/build/stage/linux/arch/arm64/mm/hugetlbpage.c:397:35: note: each undeclare=
d identifier is reported only once for each function it appears in

The same issue affects 6.12.

--YLIFX1f4k5OCHHnW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfIsEsACgkQJNaLcl1U
h9AsLgf8C2dlr7m4HALKYeWi6j0Uq0E81SRFYyXjYFUiZgZDPdWD8Wfda4lmSdoP
S2gflUW8yxBtTSyeZ2bnt6tkAstcoE2VSXk6ty7yzr/JrOjUwist/CQ28df6dPqk
EJ9asij1GKgIoMYGY/pqbIlPWk8dX3fplQvkMeQgJnCx+TK76FMvxHp2Aj8iMD0m
9YU0xlHJbonML5IBfluxY5dXzaD3GZ5TmMGsCgybDvBqxROiAsnF8x7kESkZXViU
2sxmnyyZELY7cyZg++ZdvhoD9/Xh6rad6MhqOu2g7mO3GP8Aa6UOrxzWYsVk9wP4
9dojnF88jighlPsNbS/blhNJwGeb6w==
=PIVl
-----END PGP SIGNATURE-----

--YLIFX1f4k5OCHHnW--
