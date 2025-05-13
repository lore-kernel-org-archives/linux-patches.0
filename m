Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9461E9B03;
	Tue, 13 May 2025 09:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747129568; cv=none; b=CzlrsYvyMvXcFokxtwhGCeprbtbo3nx3yEDBNySjAKQe76jXtKA5wBnlos+zqsNiJbxLIgh5huKzxxYHd1J/FRJskmI09GI55VM8SIB/wF56TZZ2b2sNUVJVTQeJXWAyccTmHsKa2sDqEF7cvyXIWnc5OALucLKdb7OpUu57MVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747129568; c=relaxed/simple;
	bh=5D6/Aj2S02dEJERZYTjwA/f8pSFzlgvH//4atC1Ljfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyssdtT7JR5LAjgEpT+n2uE9KYE4ooMwY9Q9qr1IT1LzcL6rBJd2RQFaKg5QR+/KqLlTKCN3ngypH7AfReamsinNkILuf+VhenJC1mUekw2iozhtk8IGfg/yTFLJyGluW1dFDbxBwavUWfPliek4eusthuGut5saSSFhdC07+K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKo4xOCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKo4xOCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6486C4CEE4;
	Tue, 13 May 2025 09:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747129568;
	bh=5D6/Aj2S02dEJERZYTjwA/f8pSFzlgvH//4atC1Ljfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eKo4xOCdduY3Ht4NJ/HXWJVLnkFQ11rs4Lo+/MK3RviiJx/BKpaMn0Gv4lDUbcXLU
	 utFZif+fqGqJIznCf8hKpKphl9BdSa/v13i1u9Ti0nG89LijKoiEJzSTM/NTLfJ59f
	 r8+V93yj79uTUtCc7bjZSL/0BeHDJVNgSEqErJ0WFlJ52TrubiBr4EAnYRx/2wyQRC
	 vz4cVkH5pDBOQoUpr8XAeZAYxEi7bAO0zZbRER8j0j1GxXNbfHSutHg+hV5zSpYsBN
	 G25D6Devg6xiEslqYW4hTflTANXgTB4wE80WA5bCgdu2yawuYv9iYhrtlr3Ri6IDN1
	 l1bb/AD88p+KQ==
Date: Tue, 13 May 2025 11:46:03 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc1 review
Message-ID: <aCMU22lVJvrbY_CV@finisterre.sirena.org.uk>
References: <20250512172027.691520737@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7eYelqz1OuwqC1j1"
Content-Disposition: inline
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
X-Cookie: Well begun is half done.


--7eYelqz1OuwqC1j1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 12, 2025 at 07:44:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--7eYelqz1OuwqC1j1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgjFNoACgkQJNaLcl1U
h9DFHgf/eSVKPO88dbw+PeM+5uR1XbUaqd18KWUCtowEJfaDa5RFuqNH6FaZZ1eG
IGX5r2w8yB7aLS21posvi8J8+0ycqlDlEmKxcH1A/ZFmggAD0/2rywrpagj2ym/7
PAiI/wIFTJm5iPK60I6L+G1V2kbpZRa8Qb+N24bVIaNgqh+kX29Kt4pw0s+nlsVn
yHVGK6UXM5vCXvOUzlEMZ0CGH6LfzU9e6ydR5DhVGWGCl16ljCrw8tsanmi4UULI
7VQ1hIT9kmcXIX2ecHO6x+82OvTLxnfHyBsRMp7r5rFgrrQt3t4HkPn83tcZZ3L+
8hCN+P/B0qqKmp547cxk2XfXe53Www==
=3Kk1
-----END PGP SIGNATURE-----

--7eYelqz1OuwqC1j1--
