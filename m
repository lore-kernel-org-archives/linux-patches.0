Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EFD1F949;
	Wed, 12 Mar 2025 12:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741782711; cv=none; b=oKF8DVfoiEtE6KF1Nrl4h102/esShstFc+kZ+1FQqEVO4B9oPNhpg8GcVwl93XvsamdSVQSHdBmmtxNf7eKwwQ7+UhbVxDxtYy8rrphjwIF7zZ9oSIa7YrEd9wTXh3qawbLMj7P434jYWdJnwHAwN+fdAaNkkiFiBqeTyw45OfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741782711; c=relaxed/simple;
	bh=lTnfEWDBOzjItKvRO9R9+2m5pkw77wQmdkJic8WtmOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqsrLGVCEHUpQOr8uJ6X/Q33ohV2F1fKm4UpMEXeQjjur/w6AVSsQCXbihkMNqa+LMXDLZ/4HxnZDyUssplLzhsgu4X3KSHQMyt/2JGuyrlleALQG/wP+wY6IZ36QNZYqxJ3jAYmepbBQgYi8VdtnXK7biUg0qZCQ/ddjiKo188=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jPyjx508; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jPyjx508"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5132BC4CEEC;
	Wed, 12 Mar 2025 12:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741782710;
	bh=lTnfEWDBOzjItKvRO9R9+2m5pkw77wQmdkJic8WtmOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jPyjx5080nfCZmHv3rnXAt8oxNnpcbzh2PkRuJIAfYd3T/pY3V3fplzOGNZqb/2BT
	 G8DTrZ2vigokz9BlFWu3d7sMPr6G4aFYSMk7OyiBFci8Adrg+v5UDVSTye2q0Ch1Gn
	 2O8KcqJoJ9czAaOvCcAB+pLSeZtnkTDUeXiEWikt8FS2RvF4RG4w0DjyWvK+yYflNw
	 FKCF0fGbNFgqbB/8Q74cwkaom9cFuVJk9uqQyEGn8UJVK6m/mqwViYvREe42sXigy2
	 XNMH6IzB3ndUYF7l/DcJlWbzO5UHcVBZGG9+cighgGzajVaXST0wrh2vjlfDrgB9fY
	 4I1EiCmHbY8Kg==
Date: Wed, 12 Mar 2025 12:31:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/144] 6.6.83-rc2 review
Message-ID: <90104f80-e50b-4c86-8a03-5ee9edfb613a@sirena.org.uk>
References: <20250311135648.989667520@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WcgnR0/KBYLKm9Hc"
Content-Disposition: inline
In-Reply-To: <20250311135648.989667520@linuxfoundation.org>
X-Cookie: You will outgrow your usefulness.


--WcgnR0/KBYLKm9Hc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2025 at 03:02:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.83 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--WcgnR0/KBYLKm9Hc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfRfq8ACgkQJNaLcl1U
h9CZJAf/Xcdn/uy4pwECUOe0KPAaxsp4cFoklcv/0FcmHarokWx2Hcip7hakjym7
c3sOOi5+gNbQ1L8Jykkx5cF254KWRdaIt9OOZw0aK3OSsxqAgfn6b5JK0BLzzlQt
lyB2Sh6vW3eP1oqFnfw/a53EHhSdj71JWEVww4uUgeSbEsZfUI8bAkb0C2yosVEL
V/9gwMwIXZ0iGCmKcXyQq0U6MKNraXcsZULRMttzOOZ6OHLDwU9JRWSArb2I3L5/
jUhX2OePg6ToBqzaIDr5wnRJ3JSe56MuXH5gYPMPdlWE4FKCtQyx+59XP+3rC+/F
wYmM+XLy8ej5+quvJcWsyv4PlxZt3A==
=9xaJ
-----END PGP SIGNATURE-----

--WcgnR0/KBYLKm9Hc--
