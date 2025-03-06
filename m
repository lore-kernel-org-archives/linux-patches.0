Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2973620C01A;
	Thu,  6 Mar 2025 13:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741266870; cv=none; b=R8zdvXe7QlJ+ZSAsEtMmhZf0aS0beYbzXK+YzUo28DuxVMogZQLjKrhmoGCbn3i21EHaTz2fwWouWQOko72yzg5X17R+GV8YkbPXiDk8KGHEhECyZtXPDOoyFUZ97R0vk0zM9Ywamct3itlMk6qP7l+YaWnEdCobNNZL8cBRXzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741266870; c=relaxed/simple;
	bh=YnYtGtHOeSac7WnZlrU/Uv3i7uXrwHLT5BQUl4aR5KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YX02/LzDk1RaXGiZnYxWq6op33G6ibV6loYAjK99Pq5G8iHQmFmGewfQPYohlk8A3dG4LCXWB2DUr24af5f7Qx+qUBqlgKYM5E73Z7WaFhWEsBlAuauD6fkKSju1LRORh+uPalOFo+6hCzjaLQeTzlmgCQeLIv8GuibgbeUpvsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IejMUfEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IejMUfEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC53C4CEE0;
	Thu,  6 Mar 2025 13:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741266869;
	bh=YnYtGtHOeSac7WnZlrU/Uv3i7uXrwHLT5BQUl4aR5KI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IejMUfEdxIMpfY/Wh1UWZLdyvFmus4Eyfzy7gvh9AzL4KZ0VrWu6VPIFWcg3XjPl1
	 TnYut04N0uX4GzeXqCVQwBCzi5aMtp2X/47OAhDRhz90CX0V6H202ScImYxFDJ+VuJ
	 bdPVntx+Zkdd6r1D9DyV6ux2Yukdn+5KABm9pfabun3ANtsItUIDpCjQmHuctdJ+5q
	 uUV3xbQ7uthkoUlFXs0AedyBN3QOm3ETNfsKvYvNbfUJ3uPFpGwMZ9sLrxRySrGQPe
	 pPRRNadyih7liSCjA1aVtKeTQ4p6h49V3vGrW15uFfjUT3vMTMaVjk4Tcbw27BfbzX
	 qSqi4Rw+AaCUA==
Date: Thu, 6 Mar 2025 13:14:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/142] 6.6.81-rc1 review
Message-ID: <876cf91b-02d2-4b4e-82f1-1a015224f90f@sirena.org.uk>
References: <20250305174500.327985489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gnIszBBXxgt6urHF"
Content-Disposition: inline
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
X-Cookie: What!?  Me worry?


--gnIszBBXxgt6urHF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 05, 2025 at 06:46:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.81 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--gnIszBBXxgt6urHF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfJn64ACgkQJNaLcl1U
h9C52Af+Ot6WXAH+sOqMJS5H4/Ald/I+HSpg2yx8Z5NdgPuvM27dAAnze5UvD1m+
yR16NNpVWa2mQFBJ1Wm7Q3EcNpVvF4TyzhUnvq08V9ZO2FOQfsOJF33yqFi+hPpO
v/Ide1JBXlEWEXhrjGXF5bj/OmNw3bFfqxsf0PTK9PUtMcU+aNXOj4R4NYx2m928
M0UngDPJSXTSDobQ5YpkLv+SEG+d1XexsQHwmh0cERZLHmC4feftjgyE46DCGO8f
jTv8mAKDGVBWDoK3pCq2TzZvnMHyTzQ19n8VCJV2+BdJmOPSpdHn36VfVVYumHsw
Tg2m9PV04aLzgPpjft++xssIqNcyfg==
=g1Up
-----END PGP SIGNATURE-----

--gnIszBBXxgt6urHF--
