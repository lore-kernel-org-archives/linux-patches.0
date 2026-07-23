Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21A144E651;
	Thu, 23 Jul 2026 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822658; cv=none; b=R+pEULVNu/vhRd3FJ9lnOuCyd8f00QuLVzl4QSocUuMbN4aj17InrkhHY0n202TGXMi4CGGxdwX0h0c4tCCvkU0/na2VVHf+SMs+zFD1nBpW0beCILbtpVdFm023nw9S2T0BNFPbRpcSMDYo2MhGeZxa018y/K78sb/s0WhcqGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822658; c=relaxed/simple;
	bh=gij3j/WlXVrrrLk8BvxoNgaQlFVxpCK/oycHYuh+WTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRTeJl8dVfZGAnPUYJz/jYqpmPmopvoPg+BcS/tNmBp/2r+VjRdd11sKUuZhSp0KouhmMKzzn9WzXo3GWSOkawMFHe+IRHn6M3uJ59WzNCenmytnMdn9hUFlWJ17BabWRYslwElheTRKq+z816beDGR7vesOPH2hnSIrqYprspA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5371F00A3F;
	Thu, 23 Jul 2026 16:04:11 +0000 (UTC)
Date: Thu, 23 Jul 2026 17:03:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/674] 5.10.261-rc2 review
Message-ID: <f918c5d9-1778-42cb-ae5b-2659ba09bf91@sirena.org.uk>
References: <20260722142749.280611149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rCO2RUcn+zf6bWAz"
Content-Disposition: inline
In-Reply-To: <20260722142749.280611149@linuxfoundation.org>
X-Cookie: (null cookie


--rCO2RUcn+zf6bWAz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 22, 2026 at 04:30:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.261 release.
> There are 674 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--rCO2RUcn+zf6bWAz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpiO2EACgkQJNaLcl1U
h9CB+Qf+NAK1FiXC5xEYB8JxDd8molwHTv8aVzqzV5yr7RlDPTDdpF/99fsKK4j2
rKL94/RskwAuchB6ZZ+j5uUVamSAwSQ0M+fL7RqfLXGMdrKtFsLxdpucK2otitsp
OyweZbXOgo1WlIMhFFAbDohkvi4Q2+Yyz/Z9D+skzvNRDcnu4Ak5cGeJoCXiuOaY
smItUFO2Sav86aoUgGsV4oX+hBe6SWhLcaIbEdLAsfl7+fc074QafxyFW7e/DiTf
+xfLDg0SIqFVs/5VjKNz/8EVSjOiomiTxZOma4heUk+vYPxd37Ltxlbn7QQ7GAE7
c6Yi/te6kYc+BuH/vX0S190rIN1uNA==
=cacq
-----END PGP SIGNATURE-----

--rCO2RUcn+zf6bWAz--
