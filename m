Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F643277CA8;
	Wed,  1 Oct 2025 10:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759313723; cv=none; b=DIDFZzvLpLDw6qcU1ubyx2vEh9IT1KDW8qZxs0Qy6QRrJEsKuSa2TMMSuXdq8SpBXcObPi+Q5dYUfG7ARhY1/tGPrql0ZFc+mTqLill6zwCrXwdv6rfC4fIHh7IBBxhXSmehfOn68WdHF5sw6aP5u64fDwVvNDwWoRzuApkkdsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759313723; c=relaxed/simple;
	bh=XGlB2jsiQkLqULwv18sM38zWx0SqRrtVnI95h79obQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kvFXKoV06NMLsl7YK3i6Rh39xW21fT41uVhpRNA0gD/v+1i8hILsBcX65oXU6aypIg0fNzqK5qiFHPrlSENDdat2I7jfxuCOt4sdnJGwQwh/1iCylC0gf/3VlFDLxoTDXlndbRaZs56DDCj10wh1tl0DZhaml/vzxmQFG/dKx60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSGtexQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSGtexQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC9EC4CEF4;
	Wed,  1 Oct 2025 10:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759313723;
	bh=XGlB2jsiQkLqULwv18sM38zWx0SqRrtVnI95h79obQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TSGtexQuvyGGEsgqWl2v4tulzuDIoGtuZ7+NxsCF/rr+6HLdvycKE1kyybkw/cfAO
	 i64EJx9oFgQ11ssVLSAXRqYTi86WvvtryEw/A93u81PH3ur4jBo7V2XCs6aDncsE+U
	 ZZlccoVuH0sUnkMeQ/aunJsaOLZWGRxrFDjCzuETARuID61yuaVaEhjjpfnR4LZndL
	 0voD0T0z94z7AdT5Ue3ZkAuK94YFW49IL/dTLVOA/bkDzFVWf9Am1LRkimp4HxlGHN
	 yx7obpDu2f74UtfQ6jgFYEyLgbBRYhxGZuAgLQCbQ0/a1trAo1pvUNcT3xyxPDAQID
	 Qrp9369CgsOcQ==
Date: Wed, 1 Oct 2025 11:15:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.6 00/91] 6.6.109-rc1 review
Message-ID: <aNz_OBMDLHvzVaJV@finisterre.sirena.org.uk>
References: <20250930143821.118938523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XaM/ysKMDwy/ekiM"
Content-Disposition: inline
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
X-Cookie: If in doubt, mumble.


--XaM/ysKMDwy/ekiM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 30, 2025 at 04:46:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.109 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--XaM/ysKMDwy/ekiM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjc/zcACgkQJNaLcl1U
h9CuoAf/Y9mQpE2fRRUp+jp350yCRk6EPGF8nP8YR1ePTbFvMGZgNRCELcye6r10
snSKEeQDtxMtjHTKw6SbMn7CR15LC7QJNWUxUX2PDs0wnuDiwNBaOjmo4w4uVaF0
sQ5vMIrsoP4Db1rFvj1bpiSKptcLQLAZSzwODoYPmcX9Pr4hkB1K3Lri0PkFc/0U
mJ9ToYe8RArUOqum/uan12P5idXdLuOU7VJhwmPr/nbytIVDkUK2bKfcg5YmGesU
9al2kIfgCC0UoPmM9eU13Tfm/cZwKF5zcq1vkwpEc2DhbkQXjyvSBS4LPz7+DKzT
CMCAn5CxYq5uxGs+HyXIBB7TY3eqgQ==
=xaFy
-----END PGP SIGNATURE-----

--XaM/ysKMDwy/ekiM--
