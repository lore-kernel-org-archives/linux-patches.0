Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95EF1E1A08;
	Tue,  8 Oct 2024 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728408479; cv=none; b=EERwH3kLu3tgAZ2CJ1WWTqu6qdll1Iq45I00eSuyv0DeqDR27Tau7jqiyXt+NsjY1SDEDNEZo8bRJY/ZI8pyLxRxsE9kLBRFknFV5pqyNlo/fpOV2wDqN+tYxhEYAy85h7dGm/v1mVpBNGzyrPNv802lE6dpfSa6cbtfQR0hIxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728408479; c=relaxed/simple;
	bh=VQQt9PlFIvXV7xftpAkVGQJeLryfTfCp+rZzMVyZnvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4O4bw/d2ZOPL5begW2amQ24K+GxD6WIoOxyVry0LmD6YtTj6+KLgGZrXeZlbcWARf0x6B4yZ9Le6hPkM4sofnaWIjd+uPpqqvX+63Enl69H8c8Uca+5BaVDY577840IBNN5AVPKQPCKGHWp3zbCrIBnRjxa+23zn64pHKZqjrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gizj9KzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gizj9KzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC3DC4CECE;
	Tue,  8 Oct 2024 17:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728408478;
	bh=VQQt9PlFIvXV7xftpAkVGQJeLryfTfCp+rZzMVyZnvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gizj9KzAGcLmkwKYplxTWp7HGX/EOr1Nz9aBL+4z275g6thHTzvj5fN6TDtSebCS4
	 9TW9jKE59A6SwFQfdx7Ze4oWslwjVw1V4cI4o6UMW+As4YBZ+d8mUO53Xp0Qy7750J
	 GscBgW2j+dkKl/x5fbmyGhFMLZAXu+NcuLB7B+isHNs5+XMsIDMWJyShg3q/vM6lCz
	 z5TAZfLyfYtolHJZ9ZkVZ7Vx3aXbK9jxBBhmpaoBt1dIdGU0ZF+IAvx8FDf9oMU482
	 Unf+1Nte87hM0uYnTCqZxq8AQq/LZssbB84M2nDNzyodscyCLyd4r4vl+aFKOVP23o
	 DkqvTlOQnB+Wg==
Date: Tue, 8 Oct 2024 18:27:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
Message-ID: <ZwVrm0JwFHJAQU4O@finisterre.sirena.org.uk>
References: <20241008115702.214071228@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="44d1T88ZMxBk3/Yl"
Content-Disposition: inline
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--44d1T88ZMxBk3/Yl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 08, 2024 at 02:00:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.3 release.
> There are 558 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--44d1T88ZMxBk3/Yl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcFa5sACgkQJNaLcl1U
h9ADDgf+KFyHYv2wximIDejfOGpzMzee7XZnhH9QEd+hgdfuB3yPK3LDdtM6v6pB
UXTc1KV1K6GQJugyJ5wV0tBikj6y+j5ufpG6i8127PlQbZDRCs57DHx4BZbJiIJT
c4CuX3fAdAXEF5aXj4EGbeVJnKEEpoa/V059WrsvyWWWhTrbZtq6NJoBLx6rFvji
mld4gE/SeU5IKRKt2/9Lvcmw0dh5hXpOz6qcgKp9QCSn1WX+Ejx+Gelnmxe7G7U2
nwTa1DZjOwDsQnwgqbeilaWH+dG5S7jqXAPj6CrtaJrVf/fWQ619ERvjXkYfP2MY
xMQhw7McPpsL5vRVcxbC69RUy+1Hfg==
=QhiS
-----END PGP SIGNATURE-----

--44d1T88ZMxBk3/Yl--
