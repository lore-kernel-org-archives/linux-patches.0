Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36C42D0C96;
	Wed, 13 Aug 2025 11:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755086019; cv=none; b=cT5DDusNGQAwd4abnJR98ZHAzgiv3/VFj1/r4UmWDJu/QBdmBDOeqPbF+YmES0W8Yfceu/u0GT+0dj+vyWq8mRn/htE/vaT2zsuijcfXNP0YwtboUXRUa2Jqwn9U0apMlwGM8ue35C4AbEkn2a5tu6ahYQiLTI6QnJyyTvHFI2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755086019; c=relaxed/simple;
	bh=evw2RJ3cEyt+soVXm8eE1TcVcHjaMDXk7/89m7+7DCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MrMCTzSZGRltqs6RlTEhgDExQCSvoVDVy4WUewQBIzQ5V0KuehAvpF1M1dN5mflLT1QUpaY6LeV0n1NPB5xzM4PSPo2ZlXe64ly42oObQUPx4DCwrYD1tIewhbg/fC8bxQgEly3278PxA6QNyUtIXybSBB94yYuwt8NuxAsid4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8yXtjeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8yXtjeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C611EC4CEEB;
	Wed, 13 Aug 2025 11:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755086015;
	bh=evw2RJ3cEyt+soVXm8eE1TcVcHjaMDXk7/89m7+7DCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j8yXtjeBH22ivW2qPdxKBx0E8AZE89hBnCIyegabVdB8zsyZOWqWqcYuIruhws3sj
	 KTTojhrqJt18BTy1o1H9AlTJ59a5XLDKQ2HJT9KqRpSEwhr5zLbY8na6Iw54s5gcKE
	 LtKHL/gbtgPs8OdXD3cb2LULRVtw2GHBZjiF8FCGLHiZ2vgbg3udWB8DbFleUg/Dee
	 ubdhjTe5JFTBf/kjo9KOKP6itzx/c+QcW3xycRIWWaHv8VCtJcr39f+7UYmqBeJVKF
	 3Db2xFFDqHwgiliQheN2+NTItYDbC0safwnoyxgaA2fFX2dba9IZSKxsU2+hw08Pxk
	 O0K8lZRDy8x+g==
Date: Wed, 13 Aug 2025 12:53:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
Message-ID: <55070b66-0994-4064-9afa-de1e53d06631@sirena.org.uk>
References: <20250812173014.736537091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="naKEERq1eg+hPBfh"
Content-Disposition: inline
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
X-Cookie: Turn the other cheek.


--naKEERq1eg+hPBfh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2025 at 07:24:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--naKEERq1eg+hPBfh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmicfLgACgkQJNaLcl1U
h9Dqxgf7BMGFlUnWJpeScLywEetujfk8HGzrSYrJLNEYj91Yrp92lGW/OCWC+rcc
Fc6h82In5dI1FFP92ahZIADcYtW33Sfg0C4eDQFvJr2WYIbJcLJ9pgVUk/JfsvW2
XwrW+AsajQEHQX+X3GgHQjNIZjbVu0QqsFPwSS01RJJgPzqaSLQcN/S08VS6iBsH
In/pVPI2LO+XyR4gDRCDqFvAfPFITNzLwHexn5eFr+QJ9EC2v2tCYVlf2d5GtB7O
KGazLLqgZ7u64FtfL6F9eS/7ul6z3Hqg3WUXtr6eUhrtaZSCGtN5p8XT+YvvDTsc
V02fDxAWMN0gsdAnY0dNI2Bn8cZx/w==
=p2Kl
-----END PGP SIGNATURE-----

--naKEERq1eg+hPBfh--
