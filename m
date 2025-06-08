Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4F11367;
	Sun,  8 Jun 2025 22:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749421878; cv=none; b=ngeskO9dIfaZjE6exEbZpILz52rWVAb+kWWHk/UjoCIJAfte36srE4inUvYFCxatp+fBg3ibkHwXdCOcL8SP4KrarzSYkMOXJqKlfx7fTchfL9DYFDvgbi9QR3lN9Z5XLHizejPTX2Rn8+CkrkJ4AhZvyqdv78MJxqWrrd+1dOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749421878; c=relaxed/simple;
	bh=4dWHCcv/TNvaFvWOoo9HhctpsWZz7rUqDMNQES+E4X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4YBu+DRLi9wlDQ/LTyu7v1t4YJ49tXMzUQxRF8mxg7TgPAab4RSJxNpx0omYmf+sWvXzdgkn2mHRBxJvz715z0G2VoLEvrg2AdYh8Ou6RiQkshCxFSiyeqsscZVf7XWopFi1wWDiY07XYRcIcZ6iXpVL6oMuz9RfNIi9m4Wivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFQkPrNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFQkPrNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C9BC4CEEE;
	Sun,  8 Jun 2025 22:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749421877;
	bh=4dWHCcv/TNvaFvWOoo9HhctpsWZz7rUqDMNQES+E4X0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sFQkPrNf1psLGc9LJL98yoBImNdlVQdktAn6edCY+3aOLjsb/Izi7cCjjurM66rkT
	 K/C7ejasfUsTmOCVwdW7W7GF24GtzzWm2AYCtvmt6S5gcdn5CzVOS7hAEyHWZl1e8I
	 XUaU056yThgs2BRSlKRFAqxZ7eYDwTrR7IgPCuU5cTaLlgcEHcg/U170s+2yTJFIMs
	 9nFzDnCzOnsogaJxfdw09yE1IFS6C27c0AFYzurn11gUmXawu2sSNTtsNdKkskZjFG
	 rlkrML2+5n+rzbErKsrHCBZPRPOSaMg4nrQyOoyiPurpD/6GyE8+8BfNOX9qxs2bXL
	 xb3jRifkrnhEw==
Date: Sun, 8 Jun 2025 23:31:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.15 00/34] 6.15.2-rc1 review
Message-ID: <75e6789d-7243-44d2-9abf-706f2ca4ee84@sirena.org.uk>
References: <20250607100719.711372213@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ca27qktuIHoeEUrs"
Content-Disposition: inline
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
X-Cookie: The eyes of taxes are upon you.


--Ca27qktuIHoeEUrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 07, 2025 at 12:07:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Ca27qktuIHoeEUrs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhGDy4ACgkQJNaLcl1U
h9BMZgf+Pu5EI8c7awK05SpheCCkzPZxnUwIE1FMpUVVzbej1vwRfSb01M1mppBR
FoGdpo6MhA67RWuUS9It99AbXRoyasHT/CJkQ6u2FEunxXtltlT/3jQOT9QXzkcG
FXLYT03HLTEyFtY8VooQFbI3Xp+CNDTnJ5PEVLHvmCs6NPjOGYFKa5l+RqMNwsHS
BBirCqSfH0CrvJ8G/Yq+tWQl878g9ipE9YxicmIjWK2gRTORggcsVU4+fyN0spxD
oKwk29zD1MAHQituEqixDP8jYKHaLNXM7LgexhEUDW8dirVGLj2uAMjhKEPj8Dt0
EUWQ7RVM/hIHEBC0qUkfBKfXL8lxbA==
=GZel
-----END PGP SIGNATURE-----

--Ca27qktuIHoeEUrs--
