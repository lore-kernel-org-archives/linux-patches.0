Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEDD17C77;
	Thu, 23 May 2024 16:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716481367; cv=none; b=hZgO31Iq2FzJIG6qD2VBQsjdAn4MbUS63e5ZLrGE9J4edpMON0AJzwFBh0esoTUGshF9R8eOwrt+iv2pHeSwjAQaWGiSN2F9wqLnY9MrtigTlCk52R+GGh454YwPNrWdtEFV5+QcRoZllhWE2jymravw4+jrmWGx8+MyAoatd68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716481367; c=relaxed/simple;
	bh=bEqsYoTZmKvk/obsauDZCGPuVstpPNMLuVJ46NiUL6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4Ivw3hhyNXYfkmXnnVf+8xLSnCVm5fd4NbqwehNPgCDXyF0WDkLbcW+4P7JB3ZUEZFwA+oSZNMf0wbSo/NSM1BofUm5PfKcuBmF+d7DhH+86B0XVH1f+8W6X8zUW9ObDnohI73JAPmFu62cwL0BaYfPOZToUg393sYaG1mk+l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUA7l/Z4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUA7l/Z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94FEC2BD10;
	Thu, 23 May 2024 16:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716481366;
	bh=bEqsYoTZmKvk/obsauDZCGPuVstpPNMLuVJ46NiUL6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BUA7l/Z42aZHm6bZu6cvdP4cU0o6OQD/j4m4DeMo7LtONrkNKt0CqCBddI1N/Jhfx
	 VO/SWv5hiAbW+UNLL7cWsWKPTyMzdSgZzZWnGpzAWI3xJHv8/TDeP2Yo350ai3iJl9
	 6b5H26UjUPnrOtP6evKC0CXCqc+jDElGfA4wLbHah2pJszcPvItcVIk6K+Vpd9NHhf
	 O8vN5wGRUDiJo3QQo0hSG2SG1LDcqiOaRGWMIQ6CKlxY/evh6xh+bl3g57CgwAeYnt
	 mwlKuiZo8NTkI7KDBEaf6/iq1uCKc2UwB89PlT/6DIMUSsfaBRl2hyOtWLt2PSYOdP
	 CjPhmLEcOJNUw==
Date: Thu, 23 May 2024 17:22:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
Message-ID: <582f22bf-d6ff-4214-8fe7-63b913945b3c@sirena.org.uk>
References: <20240523130330.386580714@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7bDdeMFkXa2K2ZgZ"
Content-Disposition: inline
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
X-Cookie: You auto buy now.


--7bDdeMFkXa2K2ZgZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2024 at 03:12:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--7bDdeMFkXa2K2ZgZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZPbU8ACgkQJNaLcl1U
h9BeYggAg7sTWHL7PXVHI6EK0UVx0Da/s2zKFCrAaNEmWk0DUn7J1aEn4vsmjflT
OTaLoWxR7X6lbfS9GQDkeLdygxHtScTOCXlnTcpx8o+pqDveq7Dm/NSS0OxxWgH0
eOPZyg1o0khRCGSDLVDNoBrJrCwGfxLeIdaWoFRSrI+YVKIt3VjNEzCv1Lz2oJxb
oTNrazSjM+4/YtnG+BdNRy2At42DdAUpVE179dndFHtzg3fCPGwwOCIcoJoUWKZX
pfaJAQuB3opSCVWNhcJJdZ5a4CJFTNXoTaefx71UH2YFTDsbaivapgKe00iw8Tdy
v1lrLFZB4Y88C5SA7/E+wwxY2lM6KA==
=t122
-----END PGP SIGNATURE-----

--7bDdeMFkXa2K2ZgZ--
