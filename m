Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E6A239E70;
	Tue, 11 Nov 2025 12:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762863645; cv=none; b=l1NPlibXFLo5PVPkeKV/MDtX1r0OiZCLxNeQUhGfck3+fE0Wc/DoewFSGv//QvN83JwdjeLhstjPqryhfZri/IISj1WkM0T5B858C/JIJzeYUb5G5fteLqpOTY9nSrs39CCE8BqfbhmJpmFJWD1rSJx7ejsDvRia7kaHOL61Fgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762863645; c=relaxed/simple;
	bh=LrYuYrmtuJjDh7C5WDbZ2fJNtMQftogqP2oRT0RkTNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=niHcZw1zzsNjJgbGjjcJ1QdYhuh0/6AlGpZ7rMVMw2HqOmfccygv2NSAcoZGNa14Y2cSlsUUpaJ0E3XxDamBqKfTxgqfapCSJ8ysbdnGmDhtQkGi6zm68aab+GjwctltMYdRrIeori3D79i8uULKPUJZj26+c2PNuZzKpkTv2Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XKuD+BGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKuD+BGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB456C4CEF7;
	Tue, 11 Nov 2025 12:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762863645;
	bh=LrYuYrmtuJjDh7C5WDbZ2fJNtMQftogqP2oRT0RkTNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XKuD+BGuYmtN6+1XLmq3VjW050+l6Ss86Msh+/iB8JwtRAWTopjYSXHfWwzgVWMB7
	 hapS4SX8Q+FEfsOTNMXHbMDUr4fm7v88x/Oc7hHCZ622PMX+Oap3u7/+i6VGSScjyA
	 uy2KdaZbDAfjsYcr21qe8rjVWBVavwbGkMZ2XDD9yUzzpjqp2zVsLFarm4H0FC5gIP
	 3gPrxH3fFQiOjD1gztC75oxDOHg3G4PGfXV1AeWDl1ijNc+Z/Mj72i/nyhTQ2AVC+d
	 DOqK5x11YHpFB3/zpdLdNRxQYZoL07A0gLLth9kNaFGq97CiLmLcf9QqDcwoJXeoas
	 F+EXvCkxpzXgQ==
Date: Tue, 11 Nov 2025 12:20:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
Message-ID: <aRMqFBsYy6iqP9-F@finisterre.sirena.org.uk>
References: <20251111004536.460310036@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="C/2JlLrvF+o4nfdT"
Content-Disposition: inline
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
X-Cookie: You dialed 5483.


--C/2JlLrvF+o4nfdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 11, 2025 at 09:32:50AM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--C/2JlLrvF+o4nfdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkTKhMACgkQJNaLcl1U
h9D3gQf/fDCTO/oYUG4Gr9oetKADdpcOAWImmfoO4UOI1odB7LThkweviI42ECT1
PHxvfq7ctX/IT2ZyiLjCwZqG1r/YuwN6fxOcSJVnenPFmC22j+NKoyUCS/REpE08
MYGJq4Y8KNwkNT9kUxMSOqboT3aNS1skpku1p+pCJusZ8W12GHs2ogXSmP+cB1hK
5kR6XtQuFqeUYIG8oXDpq3b/MQzCFx1k8IRn8iB7oUgsK1OPJzsY1pCy5ucFAlNe
rhafYKGl/waA+2CN9RzbziSANST3QvYeNo7ZmtlM9rkxxwwGagpG9SbXcYn442YB
Lp9m1ZpAI19pcSDLz1d3vqIaTQ5oMw==
=MgSz
-----END PGP SIGNATURE-----

--C/2JlLrvF+o4nfdT--
