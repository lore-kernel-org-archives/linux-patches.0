Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CA22B9DB;
	Fri, 26 Jul 2024 12:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721998278; cv=none; b=jgh+1S5KBNaLJieigg2Tl4fhyVIZeLw6pSi/J+YqXznzzdTIX7ncca6XgeEumukaLHF+XS1xmNUXQDMjzbKRdrsFCdBHoHDhNqEXsIqXAbRMVFrOrVuoyXOJxQq/NYyHHJsuqYjzgcVscbN87YZrpYhy/lGU95hjAYns/GvjQWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721998278; c=relaxed/simple;
	bh=hTgcXyeqTFJPeZ8PxggkyF/7EEfJxlXwhH+K7GLI6Qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OH+QsCIc6aUaLctaTPb6AHl6Ya2HeQ9E8yF04hwBetumyRhyW8g6lSUqG93GwjKszILUhMbK94PLTSxP3/+PveeOIBT2dzjE/0aznwO8pSa+1iPdLvOCFTMQ4nmL6Z2GkUi0q0ho6p9aMkp421qGGXCO5PSJZwZ6bVKIBKIZYmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q+wbF9Qo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q+wbF9Qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF1AC32782;
	Fri, 26 Jul 2024 12:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721998277;
	bh=hTgcXyeqTFJPeZ8PxggkyF/7EEfJxlXwhH+K7GLI6Qo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q+wbF9QoabURV4AYpfljn39ZWyKsmYukoyTIcTo1UyXNZKvtFihx/tsXpeGvpb1O3
	 T3fVv0jkbVcrLZd7T/xyPQIYWdaPYjxfRlETgdlIVa6hwS+Wagcn141dkwPZ40IiwC
	 pXXnX8KHZoAanzZy5vj/nKDSYJKT22wNN60kT1cmWlZVMZ6q28jtLj6K4nsvxs+pRg
	 i/B8pYXoc2d6uKZnA4d5vLCb8jqxzScfwwC5prqMNxDVNF8upCOkXAyoUrAvG6ZYr4
	 NsuHS4bDh21xmwHvBG6b1+dHBCowh9KnXlCIXqayZ3xVlaVAEG/3Evq7tgGEVIVnKg
	 Oeij9kKiQb8Fg==
Date: Fri, 26 Jul 2024 13:51:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 00/90] 5.15.164-rc2 review
Message-ID: <e8dd30c9-35d2-44c6-8939-01d98b3092e3@sirena.org.uk>
References: <20240726070557.506802053@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MX+/binVJIyMNRCA"
Content-Disposition: inline
In-Reply-To: <20240726070557.506802053@linuxfoundation.org>
X-Cookie: It is your destiny.


--MX+/binVJIyMNRCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2024 at 09:12:44AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.164 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--MX+/binVJIyMNRCA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmajm70ACgkQJNaLcl1U
h9CwYQf/RKBUsAk/5f9reCqP3zlEBaPgvH6CNYCXMJpEobIoJ7bvhnQkiAMkEcM+
vzbgqAFgAxVuSezLCxXEdjX6FOky0tN1Pu1owH1fwutug1zOXUjpbckblWEd3d2E
179JIiabpCUc1iekHd5D4A8gJJrM9h8it/dajtd+dJq00sT4f7s4YOWgzWLypjoN
0TYPKGlESlAfiaeka8qO4f9okAem6AHHAo/pW1bSeTSNVFqqa5GIjk1yELLytZsi
PDKHMjsZ8oszjnF5P/AA39zhuTAFGDjkmBQWQ0NgtUfreZdjIUcBUyiaLxzAW8mP
hU+EN+M+mP1nLIC9skp+k1gMD6B4qw==
=XPm8
-----END PGP SIGNATURE-----

--MX+/binVJIyMNRCA--
