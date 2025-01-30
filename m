Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440B71F03E8;
	Thu, 30 Jan 2025 18:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738262896; cv=none; b=ShSAW6oTU7dbnaB3QlkKNpdf+KGpYO0k6Z38E/IFA02gPF4esfvdgq2ItXg1Pqe1x1UHIJ+nZSEiVayvAZGupbVDB4YboXda8ObC0if2GFvissLvdbF2eCmHniGk6wTAiPffuofQ+VAnt8NCaEaqha2EdyrmVMCvJBtgxgSWUW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738262896; c=relaxed/simple;
	bh=F3oDO0zGg9WaxeKpNxyuoUnxWP5uFAlvZGjOwcLextE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WawT72CgiVFgrhcPvukLZ9lZYHZjVnO79Fq8IHgrhLbsQXbKkl78R4RYrzUP3xDULnaBsiICa1gpcsYuZI4FrKAFA3GEAWLIsYM56jY3JtxsIIgnFqrCPoxpc2+OUsZilsBBwlSXdusGf2qUvQaunL4URajD9wiWgJIN4LjJ048=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=be3cPjGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="be3cPjGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30165C4CED2;
	Thu, 30 Jan 2025 18:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738262894;
	bh=F3oDO0zGg9WaxeKpNxyuoUnxWP5uFAlvZGjOwcLextE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=be3cPjGdHNzNVmm/2OVwHKkcHqFAS6nYSmSh7jsMmmAbjhUHCNkixp/gY6CmGJpYc
	 UKIDe6lbwYIVgU1wwUFA4fbTc6ABcupq11YBepEnkO4p0J2olDo2o//5+8aJ8yDlJg
	 q4jtSBM0dfmPyu5lMx5YeuU2SpV+CBhkrQyouE13nEPWUlYnpFTTf6o+vSq7Why9zl
	 OkHtm7Z+ms+7oetVSsQLWaa1Y6bKr15O2eIMFzUjfW94SwIPDRZsOSg1jwikYttTft
	 5FRO+I98Y4IE4LRz1fmxNZ41LQWGvrNhmTWW/8HBN0ov6WT/GanNWzSxSuIYyqF6iM
	 9MF9keFSOt2Mw==
Date: Thu, 30 Jan 2025 18:48:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/133] 5.10.234-rc1 review
Message-ID: <fba617d6-4ad8-42a0-9843-651074731de9@sirena.org.uk>
References: <20250130140142.491490528@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ufd37B9Xb16cEoAj"
Content-Disposition: inline
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
X-Cookie: Password:


--ufd37B9Xb16cEoAj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2025 at 02:59:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.234 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ufd37B9Xb16cEoAj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmebyWcACgkQJNaLcl1U
h9DZEQf+IjkD2cM39u9CmgoHKcbmGe54pPluMMnpaLOkx3Fqjz6wVBiRVWmTen5+
kgRwlDkUZgB9k/jPZEwrkPHoGKcv4YZLpZs9FVNm3KrikDEzFHpUSsWnBphVrLEx
oqohCFq8Mc1/tS8rc/y6jkWEJV+fpBZm7lES9PEOd26qi21l+/kk65SQ1+d7PJJv
IHkhCPANFuGrsH05Jp1UBNOk6JRfTlAFR7nI8rQrtoGfduTlYfSzvCBj9GPa2U65
noJ+Uqeq6FERSjUdWx9a0y2zdaXSKUVxbIUN1b3kr1sWy3QMLt21LvnyKA9CvJqB
vvli0B/yH4Cj950AHEBuHTYOkZS86A==
=fhn/
-----END PGP SIGNATURE-----

--ufd37B9Xb16cEoAj--
