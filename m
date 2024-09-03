Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6BD1B9832;
	Tue,  3 Sep 2024 11:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725364192; cv=none; b=da7RXE1Z66FFWxON2gsrAtJEMDCAKkBYfTTfFHYWbhETWT3v2IiUEFJKyvZvWj8pn1SWQcNN/wuM+NV+rFraTw4rXTW6ESxEd66eE0TXtTLMiNB1QreG4ktOxvmwPISXu239q8MT8Q3wqZT/SHdsZoVUA0WA3WHByzsquoDis3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725364192; c=relaxed/simple;
	bh=dD0kotI2d8/Krebj7LjCCTDoXteNEpnpKIkEb8yAX98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSTeFNWKlOF5IAYPwh20541UeYKB17RQ0X6D+iq50EiopByp4i/QniGlz3nqgDN6VOqcg8sasTYablf/O8fDmErUowa4K0bsKDpeyqq9+AOvwk6x6z7Q/QDcITzAVEEHvb5YVnRNpOqsbZwRmTig7bXhVxPNEflSoxcc4Z0qA8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUmFkmJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUmFkmJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E806C4CEC4;
	Tue,  3 Sep 2024 11:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725364192;
	bh=dD0kotI2d8/Krebj7LjCCTDoXteNEpnpKIkEb8yAX98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gUmFkmJUIx+5QgTKDJ0rATdSNlCO7KJEo4hjEpfsQ9DNq/T7zfOQNh+uxOSsB/vqs
	 e8/O5a2SqmzHNwbhoOBpUZq9rWFoF8Psx0uoT4n3ZMaMAhm2fEyxLRFH6tm06qNImB
	 qr8YjrkO0IAdevNULdYJbESAQneSMXXEtIVyI84QllvDRUtJB07QIV4MrWY8M0GXUJ
	 s2M/3BpUMmBIxBWPukHvPZCx8MCZnvdVrZ68czOPVIcbZHWSCTqRQ3bRKGShPDtzoB
	 8CaGKOpXUioscWtXxUzCj4TntiY6B9IgdOwbLgNFZczAcVSGeV7jvYLALwbMmasCSI
	 TyquI/LfNjQHg==
Date: Tue, 3 Sep 2024 12:49:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/151] 5.10.225-rc1 review
Message-ID: <0d6b70c5-0bc2-4953-b808-de775c62e8d2@sirena.org.uk>
References: <20240901160814.090297276@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="v0FWU/VRH2+fRQLZ"
Content-Disposition: inline
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--v0FWU/VRH2+fRQLZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2024 at 06:16:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.225 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--v0FWU/VRH2+fRQLZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbW99kACgkQJNaLcl1U
h9CnFwf8D7OCI4Nqdkrv7WyUvPBB0nr0ngpvEPbBG6F9dCW7CR8oabRVpXBd42qb
5dHIcNfmCG98kw0JnLmsUaKohcg140ik/g8N/+/Jq1ze9+Y7D5wP7QAGy7W+eaoV
eN5Jp62Dv/LcnQNWw6tUI+1H8zYkjPExgP88lccGGeAe6Y3xveEr47JgqricfzuH
Ay3FM0AZGHMhU+VRu5ZP/nR9CHEeSCFKip0AQGWHMAmPlThbRU06tZ0bu8bndkm2
VSaBus812w4oOoPd0NcO0LtQTzLJhqZ477f5mThWXzH/suP/6vycq2K9h/vV8T7O
CZLre6qjFQ8ZFgmuIe5OHGXYYjUwcw==
=VtaM
-----END PGP SIGNATURE-----

--v0FWU/VRH2+fRQLZ--
