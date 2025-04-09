Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102B61E1C3A;
	Wed,  9 Apr 2025 20:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744229614; cv=none; b=NqN2f3InRVl9zmhsPZBTKhHdRlqlcbGAVM5MjB1UoTtot84tMB3uYWtf1H3QtrqnguBCUH+blIF/Bz/P+yW5lwX8Y7mHqZ8rL1mCki5m441XSBL2A0VwlZXsesHeZu6RQIvZltMBvnTuxAr77YMEM5mhahLBvosQ0C/Yn9DxzXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744229614; c=relaxed/simple;
	bh=bJMs0Wc0NroGcIJGNcfu/WN7VPDxoAzSyPh0lKShNfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JFakwgLzS1ySwlqZDrz9Y+/KztQZ7fGSk4qthFYaDLnWZRvyjUzx8KyGcNM2+oVrZ8Lhk0opNhODiFB9so2ecqeSYx/x1TJZzzdL+x9eMX7JDKI65JdUWwNKEfPqlxgoPJNjgz8XtuAqxweBRwQbKxp03r2ShgfGR7W6kAbf3Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQe1LPz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQe1LPz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D02C4CEE2;
	Wed,  9 Apr 2025 20:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744229613;
	bh=bJMs0Wc0NroGcIJGNcfu/WN7VPDxoAzSyPh0lKShNfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IQe1LPz6Pj5NmLpcpV7Fv9rNMVEdp2ynuqlrBDlWJyX9Tte6Sis+1tORaXN7HEMB1
	 dNBGj9TXbsVo2CxwQUmW3+LOyGG9eyYzjq6l48b5jojsK8vO5jmEyDDOrbz/OawjxH
	 q3F3ML9Tuc4hL0IsxujIr0BqsxCZXh7CSnPPBnUqRTvmelCowk8mmp1gdK/BMqzPVh
	 Kn8O9O/yMw7oy85IWL/1APrD4eIfN35b72ilQAM3iv1c7hCzVx7rRthlEMbReNT8f1
	 B4JfQFDBvyidN3WD4fnA4tvc+wN6++WHCxZufuKESDE0ERjPJ1OILR2u5hoGxdsQrh
	 9SzPnMosWeU2A==
Date: Wed, 9 Apr 2025 21:13:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/426] 6.12.23-rc3 review
Message-ID: <8280d6a4-b452-4220-8c6b-3015ad3838d5@sirena.org.uk>
References: <20250409115859.721906906@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ioe7lf6d0Bax8J2/"
Content-Disposition: inline
In-Reply-To: <20250409115859.721906906@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--Ioe7lf6d0Bax8J2/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 09, 2025 at 02:02:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 426 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Ioe7lf6d0Bax8J2/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf21OYACgkQJNaLcl1U
h9CINwf/d2OAxbkdfZczX7YVFY095fnKKaRkkJdfDHF/rJzp9T3W4V58DkWZBQcE
k9Peloabui/YGQcGaiN/eoPBcpGN53fWAJjb6w4R6EI+WXuArE4Xwfhj1hVKsKZu
JoWQWZn6vP+/hcJL2Y2EPzcNHv6MEKC3Jn8B1OXS9zhTglSAdLHUNpMuYyt/METy
Ho+Y8+cHixNMSMf17eiX6HRuUv7mUsbfuVC3OVGA3nWO2ymomVBJc48gAAbIWtbO
KWK3MUmHMHGMBgLlAyA/2B1iUkheGGdVPzStPlUaZP2YXVykzORCArkqy0YGzq5h
G9N6A7wpNnpqUVIglMPAnKnEmRSY4w==
=WoQj
-----END PGP SIGNATURE-----

--Ioe7lf6d0Bax8J2/--
