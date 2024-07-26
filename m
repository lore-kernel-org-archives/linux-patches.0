Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D977217A5AF;
	Fri, 26 Jul 2024 11:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721993807; cv=none; b=b780+INFctPScHOwA8U27UMIgwNB7O4yJjht+mUd2WJFVYfSszChX3L/DLw2nYLBb/0KK4SgMA5GE0ucbhDLoybjrPF06FprJ7GYFlZ5/tOfOxjKpzgJFWc2kQZIefOQ+JeRGeBSrksqgZTs8wOLiDveVtoCC+VhtWPLl1TkuLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721993807; c=relaxed/simple;
	bh=FQT7ZDieWdwu7snT6cXtT/QU2JjKN0nQBOPD4g8XfeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfMo+orrZBI93TcvO7jy0axy61YBwVYJtPYIJuxDoFBselDxsKi4WzSYT1ipNTe2rIyLElcsWcCGn/X9qmCJI+XUwkeTlmZ35Ho38fH3Rt9l597yjYoM2V0Lm3bH3usJ1WFqLoQGlHlKXbNYSuTFVSwz1fNYKuSoEG91OeT4nYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=me/WaghA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="me/WaghA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39960C4AF0B;
	Fri, 26 Jul 2024 11:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721993805;
	bh=FQT7ZDieWdwu7snT6cXtT/QU2JjKN0nQBOPD4g8XfeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=me/WaghAEMocbStc6QRXqc0bOccmTLVb76U8iVEVx18goeT9g1dxxB1yCxTXpRnxg
	 xUBmc4p1LPBLAWRJ0XcAjWp8rQFcOviou/pyACr3E9GmtO18QrwjRAw+KDaDiLuBJO
	 5HsuqVrPzqLkc9ZQ9JCCT7VUwAUs//6kqcpxj5in0TII9RS9Y220TZyihx3fjHOWJ0
	 iRAG/3ipOKmNBVGqz+heJ8GL9lf9qMNNVnsCWBfVYE9SM+RyJrP7xdEPrsx3oce9UY
	 6cPfZTkP/lgKkexYgaNbPfgQV5p0VQ0K+82+r0+ldAFMIZpMo7C3VJ4RC77teb9shF
	 /5V6wjCySpInA==
Date: Fri, 26 Jul 2024 12:36:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 00/13] 6.1.102-rc1 review
Message-ID: <bec5a8bc-6d40-452b-b985-5184c8145651@sirena.org.uk>
References: <20240725142728.029052310@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DaC5PyC1/9nkiTKa"
Content-Disposition: inline
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
X-Cookie: It is your destiny.


--DaC5PyC1/9nkiTKa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2024 at 04:37:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.102 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--DaC5PyC1/9nkiTKa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmajikYACgkQJNaLcl1U
h9DueAf7BoUcPcyRDj+EngYY9NTpxf7Lml9BmLFUa1QZO1Mpr6Sx8/FrbFqs1sno
YMFL3aft4oJ+XY5LRf5pUgfwa8KM0hKUH8d4b8+dVK9i6UnzB8dZivUHFEvCboeG
QNYgrvVT1RDEOleDQ3iy4i3s/m5kPJYMiccj3l29v9rlD5C8zj+V40QUQlD0JJq4
2oTVdiqIECbTZNgPUya7jvSyKyPvTUvBSd0/piB11pxLygZT0DJAwUrePws+WZrs
HOPn0OTp8KM7snyudnKz6k9u8QuOCDWfZHE0vOte0DFBEUyZXB8VBzV/On81NYQ+
Vf4kzKUyq+8NUPny/9QNgR7CbClghA==
=oKKi
-----END PGP SIGNATURE-----

--DaC5PyC1/9nkiTKa--
