Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A3E1C862D;
	Thu, 15 May 2025 08:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747296292; cv=none; b=nSJ72TY+eaDMuB1ZrSzjghmjKlECwn9ukJzNSMVJtQq7NweYzStYIbKm6k9mZSrBlkoYnPFZ8hTDm+KNCdDsU8XVKmJ0o4BSDSiR4qpuL83Pio9rb/nM4ZbgsAzBfVfEV/zHI+1B0CDn8ii12TLsTIkh6D9lXbLepsfAHkR1VFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747296292; c=relaxed/simple;
	bh=ty0IDKnnmR8p8z94Fij8gOadvYL2Zq0dAMs8I1xCWOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KkmkW7nycUUyLdtebzPRnL6t6LgpX8ac5kKKiOqUp+D/InxapccL0nGdlkNAi7HYuR0DX5HWs2pE4XhjwRc+GLLbfks1IgZXJnG7KYJ6MqWHP05Hn7YcXgs8gEJY8IjPxFKKSa7xbbfMPSZGxzCVtDvtNIWVl42Swy8zqg89Sos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uCpBL1tt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uCpBL1tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FF8C4CEE9;
	Thu, 15 May 2025 08:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747296292;
	bh=ty0IDKnnmR8p8z94Fij8gOadvYL2Zq0dAMs8I1xCWOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uCpBL1tthvB7RQhyphDgK7R5PRZbPQ4JnJnp1G4ZBARD3XYdQi8QdAKD5g62ixqVh
	 KRyzWYwOBg+NuLw9AUjgRAE4Dihh4GIEmtTwlJCeGzqs2MJI7qOqIYIi5aLDMr3TrE
	 LYMwlfnwGEntV2xJj2P+EaG3tjjGHn4Tj2K5H8gi7BYblyOMGgrFABfMD2D8Mw6XZ6
	 J5L6wD3lei/2YyCNDrfPu4p2ctIGYvfeXIqZb3QkufP1Ex8h/5TAnsCdCVv8+oEh1p
	 kuJWgAzqF9rFzJtwshH375DLztzJdttIbKJ85cEdv2ZSGmpUXxH2Jvf21NM7HP5SKb
	 CVKS/ZVc8xogw==
Date: Thu, 15 May 2025 10:04:47 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/96] 6.1.139-rc2 review
Message-ID: <aCWgH6bec0nxse9I@finisterre.sirena.org.uk>
References: <20250514125614.705014741@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TGrf15Nb218DgonB"
Content-Disposition: inline
In-Reply-To: <20250514125614.705014741@linuxfoundation.org>
X-Cookie: Well begun is half done.


--TGrf15Nb218DgonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2025 at 03:03:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.139 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--TGrf15Nb218DgonB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgloB4ACgkQJNaLcl1U
h9BFvQf/TZ/2gGHjYWTXvkypDcyopzNZrahO+NJRSe9vkdvX2EfbZSlOpD9m65nR
jUo2ii/R3z41QlhOsXErM/6DfWKPcQDI+tR6IhmGTterEFCc1iGudbe/v3GLRI/5
Dofua7UUpG+A7DvHjO7IH+wj+DqyHF4aED+Dov7K/g/X3DU7HjdlLhtbN/0PsT+F
/GqUO9M6fDcTTAyYoAFUOrd1rT735JhBQVX+SGFXE0I6nMY6+cWECTkrd9QOsTuw
ZasCDHGAahK1WyZ11H90ywarjuUNK5Ew85iIbv/sfkojkBEWIh79l2z/FCai2EBb
aZnYajYKrBbdCuJyAPHzyV4JcBh2Wg==
=QhUV
-----END PGP SIGNATURE-----

--TGrf15Nb218DgonB--
