Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB4F2F4A10;
	Thu, 18 Dec 2025 09:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766050908; cv=none; b=olQqiA1lG+Kcud/Mo4e3krx4qDn2HrAaB7m73LCNJjZ4KiQJI8oBQ7Gk65TPMSsPk3Br3FeHC0JXDkLoujhHC2HFc0MrTyUPoDUN6zUMuvJwEvv4YEK2L9BBBepLTWYpGvK+7CDRuR+ue6mqAYFvtEXL0g8/7TCAnaqva/AuR8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766050908; c=relaxed/simple;
	bh=pIrE9nK2ElNyszES8Y8jOXKozUiO4Ln79OuUmHSgg2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0+9gxaTDQKOc6PVjdo/BNzSdEmNgi9JB/V0HDqJlPSpG6Hi6ErQl2cqThpIpEF7mv2GamjsQOcUWsWgk9ub7jhl4WtWYU4kbo3onPy+yF4TUtfzMdUUkHImKmo6Jw6c2A/DwbRV4riyjFsyxfrZ++sTKcb//Fmw/dRui8YQg2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1JbUqxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1JbUqxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5964BC4CEFB;
	Thu, 18 Dec 2025 09:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766050907;
	bh=pIrE9nK2ElNyszES8Y8jOXKozUiO4Ln79OuUmHSgg2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a1JbUqxdog8GTeEv9pzOwkSWZ7gnepaK9tuvcQhC+6fS1ACDCinzXk9dcEmxxdGlz
	 PYNdOCjdWJMFAowuTvktOq+CMKRUvJ4vuNGrZSSsqY99+0USt7cknxwwwXFDVzTeuG
	 Q6hovC+Gc4hk6sRCAoVAhE/pOImJPzoJ5FLvEWqA1BSP+fXdf/ZHwn5yBE1J4qV/+3
	 /2XiHm+dH5zZn/ElfvKkhqiYsPZSwy9s0CHWPbZHvsjSbctuV+Gb9qi2qZiNptV7Pu
	 9pEGsFBhhhZc4FMHpY+7l6augjniao5le8AOPvQcZ4nHNy7qD6Duft49f9zSrSG/LI
	 Pjb+BDvT5nYpw==
Date: Thu, 18 Dec 2025 09:41:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
Message-ID: <8e4a2741-dcee-4a01-98a4-757c06a4a868@sirena.org.uk>
References: <20251216111320.896758933@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Qdjiyv5D0vq0Hyeb"
Content-Disposition: inline
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
X-Cookie: Close cover before striking.


--Qdjiyv5D0vq0Hyeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 16, 2025 at 12:09:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.63 release.
> There are 354 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Qdjiyv5D0vq0Hyeb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlDzFUACgkQJNaLcl1U
h9Ajhgf+Oz48QfTYVhAiifv3D3sOxPJQU+eatWhQ2KAaXRy5dzHFgSeW7hC20EbS
7NjadcgGVfCEuEAXkyGgaRZ3BWBE4iE1sQQ+VB0xShIWfo93ocb7/gTneQDv97Tw
WQH0QgcgHp7u/oO6n4QpdGA91zYfmEydBM8yzPeKA8Rd0Vl6a0+3PXcEzl43kEFB
+rkKeBXnPOtpUmO2A0jqe9+qr8ovto0hSGV8Gn2dXk8kQpe4W4Gm6hs7u4RAzzF8
QkTv+8UHBr2UKvt5Ciz5jDuXRgPcLW8tx6WLbl652ZSBTrLDz+5HqDtohl53GwTy
iHt5UwqEVurkrqkmsRi4ysnIHscedg==
=xJAq
-----END PGP SIGNATURE-----

--Qdjiyv5D0vq0Hyeb--
