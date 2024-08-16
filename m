Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD27B1BD4E7;
	Fri, 16 Aug 2024 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723819397; cv=none; b=NpYRHoaDkK9VMCUKSqu8HtEHczrvqkPTdn3dRvnHviaZQkgBL/Gcqqzw6nvUnN6ZnNyxsnQp+oB3AcqlMsSx6yFeVKcxbRkSk7IdNI6IE3xl7h2xwRO7IYbFtlLlYaTPrip72WBgLf2ANoZBN+KugC5VRFigJFtN+2WzQGl8rlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723819397; c=relaxed/simple;
	bh=LBHMW870EKWj2wuWF3VXR1uM6eM+cpZKRAmmh5/UWmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IGIRHuNdQiMbGpcHY8hY8FzoWqE1JLtCMwvfNMU1fGMtoyIo5GMfoChctyeG5R7IwEfR+N5Ncu8F5cqepqyBLLv7NFGJ289ZElRD9F10q77UYAGl5XK1lwPPi3I98p9aFCepRyAdrK1Ia4kUesJ03sRIBXwXxWWyLf5NJPQwhL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KyERlVCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KyERlVCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BBAC4AF0B;
	Fri, 16 Aug 2024 14:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723819396;
	bh=LBHMW870EKWj2wuWF3VXR1uM6eM+cpZKRAmmh5/UWmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KyERlVCqyshYik5vOguJeYJ8WV/PwGYNl3YFw4IChFN6hxY0zHQCFSLx4k+lVX8bg
	 mkEiro3w4IBml8bdAaRivU16TFhb/MtRFq+CBEC0/ZO5McqIzDJUGAV1x2DPwPJtd/
	 P1T/uoZHRU6/9uxeaEhl/gPA8vyou6bAm8UlH+WzUjOIlkoR7DB+goQ8d73hf7jmL+
	 GIeqpjw5PVW7dR7+yLxzG7gaRALx+MuxuZx8ALRW4yYsLQXR+xqDpKjX2z389COJcK
	 vBaklIhlbkOqYc7gq1TpHEL3vdHNRXArxVwmAgFEFoz67Ce81XnVujtjcxz1J3ekuC
	 zp9XIGzPl/tYA==
Date: Fri, 16 Aug 2024 15:43:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/350] 5.10.224-rc2 review
Message-ID: <d42d702e-ae74-4666-871d-33ddbfeee2b6@sirena.org.uk>
References: <20240816101509.001640500@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pCviW+v9vNG4+1+l"
Content-Disposition: inline
In-Reply-To: <20240816101509.001640500@linuxfoundation.org>
X-Cookie: A Smith & Wesson beats four aces.


--pCviW+v9vNG4+1+l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 16, 2024 at 12:22:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.224 release.
> There are 350 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--pCviW+v9vNG4+1+l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAma/ZX0ACgkQJNaLcl1U
h9DCTgf9FEvHsv/7F9T8ryeMJxC0gHWvYnRhHnX24THLLcu8Xut/gYdgM9EVR3FM
+REv//xwNN+uIdpEKQwJYnLfp0X+1718jLZQVoJ1U5CfeiF6wYcz+zCuL171nQ1V
X8hNLloWIMKwlHSU5qPq/nqB+KNhiVqLagib/RDpbMgj/whxm2Fiz0hTe5gdJeik
mgJyv3CCaoNMHERJcuqRbSc9RSgyKIAMGrYKBfHAXvswwJu9lIGbirCY3U0YBv/D
2vs7hqmsiyProXyTP30WaeP2LQ1/uyEgIiUpQSUDnQ2xJkfN7wgSa8/f7UIXQkn4
5UQXj7k6qcWkkY7ABVmCZx7V1bJwDw==
=Sl+2
-----END PGP SIGNATURE-----

--pCviW+v9vNG4+1+l--
