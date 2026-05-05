Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793F3359A91;
	Tue,  5 May 2026 12:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777982902; cv=none; b=kw5Z3HTloDzAjjann8IoKOq4V80qwQgcg2OW5vjiNDhEz46/4htytaTiO5yOuoqH6wOIsBM2d4whpNySzZofXyuAktvz4eYxTco1XEOAcEL+tb9TGu+7amvnG3sWFAMEht4D2azHlvgRqQuKR+ArOQvgjYnf8lCeHujlLaC4GDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777982902; c=relaxed/simple;
	bh=hJpbio2BGay5/lozyLXXheiKHnWdisBgdjDFk7WvqT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KivZGeKJ95iGEuZczomSm58a1egPBS8Rt6451gaOR8ldc3XiSmp9WONktaoVeAAg2xnTnxSqH4TTH/mPwGqHBFWyHRHkSg7+Bj6PCIVgAzexZMiLq6teqe75wrR3nzFrC+bsSkZha69wsl3rC25pFly/fHFp7ZQ0iw6s+TFiJb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nT6oL5tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nT6oL5tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE460C2BCB4;
	Tue,  5 May 2026 12:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777982902;
	bh=hJpbio2BGay5/lozyLXXheiKHnWdisBgdjDFk7WvqT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nT6oL5tjEZAUij3NqNxthSVzuf8X45gLm0bLaJ9OY0WJYF+ioBcxvJVNb2AkfYKVV
	 MkvXKga6U/blRI+pRgNBJUNvSaE9pubaRuzo3f2ympZlzcrX51WE5ny+BdOtZV307u
	 QcuPPoFII5VPM0DQUrPIjpeoy7qn5rvQjPceKH8MaFL2AfEOSk3dLm5dzwLVZWK1dV
	 wPachB219/sY/dnpki2JU2GPGPp2KSkMLMalNFP6JsGNKYhvr7D/2bhM5yMUGFfmP7
	 8hi85Rs0Xff2PDeOuawmmTUBB7kP69NKkE0ckVq6Y/qxybXnDCwM55T7e3sl0aKpVH
	 uB49D4cZAqYCg==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id CC6AD1AC5871; Tue, 05 May 2026 13:08:18 +0100 (BST)
Date: Tue, 5 May 2026 21:08:18 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/275] 6.18.27-rc1 review
Message-ID: <afndstwca9pMPhnX@sirena.co.uk>
References: <20260504135142.929052779@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sbFfvD3S7eKZshjt"
Content-Disposition: inline
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
X-Cookie: Alex Haley was adopted!


--sbFfvD3S7eKZshjt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 04, 2026 at 03:49:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.27 release.
> There are 275 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--sbFfvD3S7eKZshjt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmn53bEACgkQJNaLcl1U
h9CjPwgAgnOTfoo0H4+xsuOEF77U14jmnfah+FHnDacv7y1VXbLIgj8HJlgso+xE
t/Qypdn2sWjhQ4dHNq+5h0liimZ200CjAma6JiAjnaZpGuJdOpz4vIXNLE12i4z3
GIIlDwyfGtXx49drmGIO74riUUifNHkmrnhV+nO8AzPGrC+4a8MiET6VZj685Vi1
EGDpnms8//cVp2NrZI61NYniyEuEpyDiuIydJVj7aBYSjWy+Z/zymWd6M88bMfln
Y6aEOytK1p7vstlbR8urkCRiH3Y//+B+zxZM1WT/+WYVOjZ9QApD5Ka7aqZiQk53
3ofUnAmo7s1fvBlXEFxqwY4NULDIHw==
=BMBj
-----END PGP SIGNATURE-----

--sbFfvD3S7eKZshjt--
