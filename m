Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315AA3976A0;
	Tue,  3 Mar 2026 19:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566961; cv=none; b=VveayCCMJPqyUKW7zmW6RDgLIJwR7FsMNr9vJ4Yt0+Tqcm4W2kB2Uwg01ParzW/cLIfEYZt5bMmqUPxwVzHWFUGgIfT4jXWc8zIdjwLgb4ig5nMrL1t+OVw8ho2Rm1cklCb7A4P9v7wAriz6/7qq/e1RPFX4BtpML4iv4iAY5YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566961; c=relaxed/simple;
	bh=2aytNbqR6S2JBPy0ILjAaE0sIhBj8XMesOJxnoc1uFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKR9kwKPHFeVhs7rK+NIqKBdfAw3R4EPn1zWxsOcA4O0JTnIxmUiFiUIqt67tit6s0ehCH+pPTR3Mpj/ZyVNzFj5moebxUVI/c2qCzJhgULoxX3Osc+Uy9yh8i7W6lOdc1rdpIwceptiQwMJl34X8XgPxfPRroys1Ghqjm7fK3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qwxK9crx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwxK9crx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2065C116C6;
	Tue,  3 Mar 2026 19:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772566960;
	bh=2aytNbqR6S2JBPy0ILjAaE0sIhBj8XMesOJxnoc1uFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qwxK9crxuB4hWGyqDEKgunk4Jy8SIcwpEikRcOBaunKGnslct9Q53HcRKRxKvIye+
	 il7nD+cymhFKqPv/ksQe9EHsYtP12XUrt+O8YZoU+UA5CEl8LcCOqEc+/0Lf0bfhys
	 qsOYJZhW431+L85JTQQeY9OdL0xhwt/VJjXN1et/wBI0c/9Qv2BBQ7Hy83V0/QSa+5
	 eJbVy6EZyHMYhnR6z2Z1xxHlCfK2lAJ4yU7zShJFWj/ffNhaIF4Ulq0Ak7NtIwlnHJ
	 zNsfoFmClcpqj2sR86fLmiMFXZ/Vsi88tmbaayMCSHOe2B3wbgPgbXcOdRJHO4DgA6
	 PLBoNXT9rsLVg==
Date: Tue, 3 Mar 2026 19:42:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/334] 5.10.252-rc2 review
Message-ID: <040e743c-594f-4383-ace6-74ffa26d2d2b@sirena.org.uk>
References: <20260302161007.2523181-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QtrNzgth5f+mC/vM"
Content-Disposition: inline
In-Reply-To: <20260302161007.2523181-1-sashal@kernel.org>
X-Cookie: Use the Force, Luke.


--QtrNzgth5f+mC/vM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 02, 2026 at 11:10:07AM -0500, Sasha Levin wrote:
>=20
> This is the start of the stable review cycle for the 5.10.252 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--QtrNzgth5f+mC/vM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmnOakACgkQJNaLcl1U
h9By5Af6Ak7bY+b2NDC8z2LysMegJ1Pb/330jr9cgC0y6okiGtoErsPbYtQEBUhy
4cCBOsSRXImuHPfXBA4RNQHjlC5cHQVu31THDmb4lFv2HZb8XtZ0shhGueOwjHWt
rpx3leKiBhNU4Ud8gv8Z5MSnP1Lxrrf/eT6tNblorNHbGGTiDOq0J2niPWw/bf1d
anHTPnAnbINMmRSD2ewKiIgsn3FJllo8fLyHo7gPS1OIgtiXzA4GJT3xtaNoR3x5
2SJYaweC+4aweScujQ9HqKiofE7puGr5lAKKzf5jhlvl0qlWt5EjiJY1U1GAjrz+
P9f2xxn2ZVmUYB9q5ijswdm/W1n2BQ==
=gpb0
-----END PGP SIGNATURE-----

--QtrNzgth5f+mC/vM--
