Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EA91E32A0;
	Wed,  9 Apr 2025 20:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744229639; cv=none; b=GEothU1AslOOzGxFnpbtgLxlJU7Qe5Mv8jQbwK4IfHyXwD3b7rRgWoU3z6JyI2SBZenOj+EjHdRcRs5hjAuDr3I0JFEOSnEAH6/m7d4UIi9NRThhXFEy9lCs19R1WkwF04q2brfSjc+a/HO7rsFawUocPTATlB1ixwVWODA9G4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744229639; c=relaxed/simple;
	bh=HBOQKfc1nqEs3T5tXvwldgYZUUCgExKsGR263YIl+w0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1qQKuZnzs6wGtMOy3L2j3yTg5Ag1HDzf6XyeRGvVIVYlRplK4aqjIB3IM/inuPV6TF40D18soFQdNGPLf9ycNkbxyPoDve4Yh2MwgMApE8YSaV1TrtRrGOFLLA87XL3RU5iSGzo52Y2fPy49MNqstU/XPUjUYmWuhoBqTLZmLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tdVhacb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tdVhacb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DABDC4CEE2;
	Wed,  9 Apr 2025 20:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744229638;
	bh=HBOQKfc1nqEs3T5tXvwldgYZUUCgExKsGR263YIl+w0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tdVhacb/Om0TpYU+kHkov9VuMjDqIiZ0pOoMV5qZfvC2xFJWp51Cz1HMpI+U8ryGv
	 yFfRECAhBfTMdXwtvNSCVD0pTpctfjjgrRMXbJzmWNhH4hlON6HBZEnaRdvZmy4eS3
	 X4Uc/Jyv4d/pzSyDkmU7WvVgOiEO4BADGy+0HI2ziKqw2ow5QbytCNFasai4sUD1Qm
	 rBSiamBsl2Li1OX1ER4JTPjg5L3jM09440MKv8hjQQoNbSXxwfgkEMLwKpnbEU4M9s
	 mMyGc7YFh0e/5vw2sdEocADiO6R2Pc0lb2uc+Pl0/euKedpSwPN1BTD8+EHUVQ6coS
	 wGfUbDtvm5dwA==
Date: Wed, 9 Apr 2025 21:13:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/502] 6.13.11-rc3 review
Message-ID: <162103d8-102d-48ba-8ce5-d4f1438637e9@sirena.org.uk>
References: <20250409115907.324928010@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fBcvvMyxTR7AaQoN"
Content-Disposition: inline
In-Reply-To: <20250409115907.324928010@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--fBcvvMyxTR7AaQoN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 09, 2025 at 02:03:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 502 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--fBcvvMyxTR7AaQoN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf21P4ACgkQJNaLcl1U
h9AUMwf/WIsj5eybstUqKxBotk/+0achAO3x3ivKn3Se4goHlq5086i5d0X3pBOr
SfRdl0swCF4j+5k9qwFMr0eVVYVY8UhYmc5bh1GVnr3zL2XPunMwSLKCVjTe0s6A
lkOlpqLMb3ZKYivJI+miiYhHaRcqrqDQQVP/Ht3EM6r78Mk0oh4NPnub5Q/M43U5
sez9a9wPOSKP91JdGoR1r2CPWYAWFctjDVdz+RABngV4xRs0MxdriWzlMY1xDFb7
HCcsiYkZ691ro+Ky2zYye4cUq1mbK22XockA8rUzvyIUHkikN305A/EkpGVoV4FO
GMjaKK+1WHXOcsOAPuT60BTAdKkf7Q==
=quuI
-----END PGP SIGNATURE-----

--fBcvvMyxTR7AaQoN--
