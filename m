Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E8F3074AC;
	Wed, 25 Jun 2025 18:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750876234; cv=none; b=BlR5PJMNaLXTgBBMXQb2CoxHxbN1Hcp6EDddGq7WL9Jw+Kqb2btaayWlQAuwCUdkHt5cVt8CLILR7t2Nc9NP7+RzTnEXAieyLWnVBgMvUHBfoB803rjq3BuZae6zRX8qUpI5VWAThkFjHq2CBBQa9IB0CV0hY4vOxCxf01qe/6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750876234; c=relaxed/simple;
	bh=Fv+V9U1t+DDhvpDRzP8mnIeCKapu4XAxhCUCYhjC7+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbYp76CmosqV8YtXSOcjPfibj8GtAe0j/+peM/AlIvH8E7dU+R6gDOG0e9+07EWX/JJwkWq8ubRcg1kOCTS/g1bj8ho/x6g7kb3v8PIqZdr5Fd+OdGyw5HfALoQw81Q9n/CnwmCuSAZ5GEyNrgSgzbyVdfbxMpKWfazwMrD9BcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qtofrsaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qtofrsaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1939C4CEEA;
	Wed, 25 Jun 2025 18:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750876233;
	bh=Fv+V9U1t+DDhvpDRzP8mnIeCKapu4XAxhCUCYhjC7+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QtofrsajVYLXnfEIdkZ54DPNiQH87LaQBBIEizwrIqa2ziD2F2O+pQJUpgMU3USBJ
	 4TmAVGtAexmh7/fhH01jgjekY2jSBm0jar6QUAlaGlqHt6mjbEPa/no2o1LeSDmxuU
	 Z1EAsI3cG43WklgBdfj15YP6qDHBZMoaZs9C9T6oE4N30bVIg9DNVpkzdaLm9rjJoY
	 UXhcbwVIbY8dW42UQhd2q6DafbZjUvHUeHqrOcm0wqk7/mZ5NGVWVmSkI77xve8z1M
	 pF6JUNxJO7AWLpeubMYGZFOGhSqwki4Z/tORRmWRn2zZDljxZP2He7/1FBFCmE814d
	 YoVAulWla4GRw==
Date: Wed, 25 Jun 2025 19:30:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/288] 6.6.95-rc2 review
Message-ID: <734337bc-67c9-4a96-b071-6a459312f01a@sirena.org.uk>
References: <20250624121409.093630364@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eEw9C0iHB6wmF6IM"
Content-Disposition: inline
In-Reply-To: <20250624121409.093630364@linuxfoundation.org>
X-Cookie: He who hates vices hates mankind.


--eEw9C0iHB6wmF6IM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2025 at 01:29:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 288 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--eEw9C0iHB6wmF6IM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhcQD8ACgkQJNaLcl1U
h9BnJwf8DIVTUTxJONjUL0h+25lDaBsLjpqRZoaCf/xN/TAWW6JMGmPg+1yhrVer
E3boi3MibUET5HPy0lI5xKy3irv4zs/CxKC+SBAFp8D22Au1oDu8UC1zjS6og0SB
jr9jRqVY0QwDIbAom0QeBpxYiOkZysTBKVIytQrb/u6/KNEYP0z/DNwdCAfSNc7I
pkJ18Q34KI2QZ7RwKCUXb0FYkx2hkLl3PY/rtT9LyRwucHstttChYdIDbvDVvEkp
ID74jWBHVWkn9T1hhumhdS+LCqiTFOz7DeR4RveU5v7+SUNoS7JRlEqCwrDl5l1u
lqayvibhnb9V8m2iL8ckLLLUP/uQ/g==
=dMqp
-----END PGP SIGNATURE-----

--eEw9C0iHB6wmF6IM--
