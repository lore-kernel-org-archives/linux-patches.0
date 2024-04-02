Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D9B13DBB2;
	Tue,  2 Apr 2024 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712068838; cv=none; b=H2OfUc05IzcWVY6CfPWV9VhN9dkbBDn1aUuwHJ1Vszdhjjg1tSh3/35WkqH1RjKT1dw9xSpZD9+z9ZZ25tAUnf80OOKCXNnPBCvzG1CKKa6sH5QrLv4lxfwl1TbDBN66L10cHCbwbyXXfEh6tHOsDvcXs6pSXtOkJc6j8KZqqXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712068838; c=relaxed/simple;
	bh=YtrHFHBCMpkMJiE9zTNTlDMoH/UpuvxXwnaO4nD32sA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZWWdNtQ/VYYqLGQch2T/obBwUVBbbr3Q3P29AUGCNXcbh9hGZkdLg0XufIP3qUh+B/FXxdkse1LJUBSwdteRNqosfUKx1dO802aq/3cD46NXw7NQJPF2AzKUZ8Vcn3cpQ8jGybnuHAUucWWHYcHR3i/KzEXMp0tFgwq1lXPY2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcwY6Hrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcwY6Hrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1088C433F1;
	Tue,  2 Apr 2024 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712068837;
	bh=YtrHFHBCMpkMJiE9zTNTlDMoH/UpuvxXwnaO4nD32sA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XcwY6Hrn/hbEOV/WG/MhCY0ILJ1rfdAVPIocdFyxmR/ONhNAoePQDfPlJuAAoITgu
	 NommHYaDI6+ybGvwe+WM7lR9MdsZIpHG3Md6UhXnH/e0QZ2/KsOQ/RDudvDMQMHFex
	 dWEvihF2s4Al3EOKR1myIk+RkR3v3EFuB7E1mW5ccQThRVkopDoHJUJPGbpolTJPIq
	 YJV62YhIrhLlyLzcsw7rANxIAIVDSGyg2MZtoG6lwTtyA0VNQV2DwspQ2ws9/VVQOw
	 4DOuTQ6PtF5hkQN7pabhYpv7bb0jYSKW1I3eTCTmT21RsFk+LFDAKa95LxAvFB5a5+
	 y+bSXLAFrE85Q==
Date: Tue, 2 Apr 2024 15:40:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/432] 6.7.12-rc1 review
Message-ID: <d65eca7e-0515-4f76-8aed-d13673b0a8b0@sirena.org.uk>
References: <20240401152553.125349965@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dkbYuHOhZ+/2LGxQ"
Content-Disposition: inline
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
X-Cookie: Knowledge is power.


--dkbYuHOhZ+/2LGxQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 01, 2024 at 05:39:47PM +0200, Greg Kroah-Hartman wrote:
> Note, this will be the LAST 6.7.y kernel release.  After this one it
> will be end-of-life.  Please move to 6.8.y now.
>=20
> ------------------------------------------
>=20
> This is the start of the stable review cycle for the 6.7.12 release.
> There are 432 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--dkbYuHOhZ+/2LGxQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYMGN0ACgkQJNaLcl1U
h9CzbAf/b3yP2z648e736YOfNwiHWJ0ieY/1QCFBfi90lRsT2q/OR0PdzVsjQoxj
B9XmB5J6wuKNG8G/niMMcmp6yRLKziluuQhElRHZzTzzj4aqeO14FQiAHwJm/WpV
3nFoSEjgEc2o9rYqszBfN4S+ZW3tyzFc3qQG+RMdT8V8ieB0VW1m4rpwzeIa9M0m
+n4eVkuAh20gkB2izvoH85Z/P15lvBTnZEMJhQN0aP9BI7g+XbXaLouPiRdZ16nA
yVQG4eSuLjZHNtOHgcm9YKWAoS4Kt1XuFb2VAvkJ843khWuE1wMrKjOmhy94Sr24
Qs43Jg7tH1gXpKmhSltpcjFNkx3rkQ==
=KUnr
-----END PGP SIGNATURE-----

--dkbYuHOhZ+/2LGxQ--
