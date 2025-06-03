Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B861E493C;
	Tue,  3 Jun 2025 17:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748971412; cv=none; b=lK/Gt2VUO/sTtVHIuWULbvNxtW1KJEfM78nD6ZhO3y8P0ghquuDeT+KkZrfaFOrQ5kZMIuUcNMUq0dPXI5SEnINYmvi/RSEB1Qznhkr/TO9yPDBGoZjYqq96Gp+59yb9n5ygySR+Cw16UIubxdTyxmvGJiRC2sfNB/Ej9QjgZk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748971412; c=relaxed/simple;
	bh=sK4fHRYvUcpKI62QXnxZjZI74jEH7tURhoDljn+WFOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Do5aJfl+Pn9IvWuVDYqyJvuTyk0zTRwVgkLRLeoqPUkFPw8VG8oMa1pOHDmWi/5ft6scee1JE76UrrKswMtwOwCoFJXRc0nXHuS6/KW5EhYc5GEfo7BQhy0VHfLIpAHh7WmBKN9bxjBlA0Lh1wXu3D9VwgMtiRN1pJjX6C3vjxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TB+8vv9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TB+8vv9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C73C4CEEF;
	Tue,  3 Jun 2025 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748971411;
	bh=sK4fHRYvUcpKI62QXnxZjZI74jEH7tURhoDljn+WFOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TB+8vv9zel7BUd0grIyQQOri4B4DJ0iTFN/n5NF/sIOfaYD8Tt5t58BAGFH/KLjZS
	 ECaIYvI6gvKpj8uB6AGQAMSUXUlKgjm7kpxbctkfo5QpOfYkOFQAfy7ww9nyNzg4W+
	 7pktuKPPiZe/SoMKsEb6NEz2r7njCMTwtKQR0vHdMPWJAN2MCR8KPlAc9dEIAn4GCF
	 wYnDHaftiaCkWK0GRU+F6J3ko1ovN8Xrlb1+3xx9CIayLXDBNWkWdwvCug998j5p4B
	 RnFwLAgt0iYSv7RyfQ3SujzleASgYxUERIW/pCe6UjIwP+d2b87ktyBbx21Pkk2sR4
	 2Patv2du1okNg==
Date: Tue, 3 Jun 2025 18:23:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/325] 6.1.141-rc1 review
Message-ID: <d7f10d28-3727-4c40-a9e1-9687af7ce375@sirena.org.uk>
References: <20250602134319.723650984@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pmiZu6fGWjsfr+7l"
Content-Disposition: inline
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
X-Cookie: Avec!


--pmiZu6fGWjsfr+7l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2025 at 03:44:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.141 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--pmiZu6fGWjsfr+7l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmg/L40ACgkQJNaLcl1U
h9Bikwf9HWKh3XfIoeyl9Xfj6CL9OXw/8f5k8el+QqbxRyqKM14l2Ah2uxuSyg97
nOwU4RAbpTMFNYuHETuqiwsZAOHFsEidWUYf4N/q2G01I1qggcK0I3tVXgSS/rjW
kDpKDmUli5tXma+WBYNrPgXJ2gUrlRQWGUnPrQ94/BwYok21kdOwsR07Bc+LL+aD
IRQ0IMwZQQA9GEzRrzGlXBeGo373o6ofSf95FOI6ZRihiwICvZUfq/wTzIrIp48t
MyZID4vQz+8v8JTrMzxjam48MT8VV7EjFx5g5KnScEbmNI5KtL4wZb0kxXf9ybOE
42NZBnsXSAsCoB1aRxejpppb91eNyQ==
=qd3Q
-----END PGP SIGNATURE-----

--pmiZu6fGWjsfr+7l--
