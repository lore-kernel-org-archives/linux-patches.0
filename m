Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CAB2DCF61;
	Thu,  4 Dec 2025 11:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764847996; cv=none; b=sYCAkDXK8HXh2Uv6E3Tuy6mISbf2L9wIcb1+aucrCAwBWEYtBK0R/qhYu8d65TjpE8Pu6BV4u8d7WzGpU+ypLMViy/scY5+vJcXHadAWu/35LQrKMWTobEg8pbWJAs3V5bQPBAv15Lh1iPxDWAZQD9OUtFaBlF27vL5Y34xwyJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764847996; c=relaxed/simple;
	bh=ii4gz3F5U1EuqSJuk7pJKqCMrIY0NS4JF0digmAF7J4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZOWWbJsWw5rWqyeiF5JtOq/+rhABDe0gRrQHDFQzVM2t9A7/pbrNYAi32pXP3lCdccv1zEvRbv01ZoGM5lahTnDa0dMUsAZ1lu3bSoyPg8gUEessOOU2fIR+axBpZWT/aM1LreCkdsziyA/0544h3kJcszxu2kY2z3YRcvmYo/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vPOcqIGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vPOcqIGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76895C4CEFB;
	Thu,  4 Dec 2025 11:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764847995;
	bh=ii4gz3F5U1EuqSJuk7pJKqCMrIY0NS4JF0digmAF7J4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vPOcqIGV5E8i4WuodG00HOs1JzLYDSL5ftkiIi/IWkHwnxeNIUt71xsll/PfCjl9V
	 BJz7pot5XMK6pECXSvHQd89MV5WyZ9lQx4Zir5eLW40knnRUT+oI7NSSWnykUx0SJk
	 45XI0FRXpR7GeVgNWMkgwiFc7n8iCZdD/GSlE6O4oard5i3/dhFp2yYmM/qNT7CTNo
	 VK8Oknc+I/MOwhP8Akbgq+1wE5HPG8FehT/AyuxCDPA3Ya105IF4T1Ge16dFfhhhPN
	 GAvzz2OSlvw4YToGsywW3IeUqIHEK4g7xT3RMBukObPf8S4qwQyQcnf8MIxIG8SbZa
	 hr2B0X2a3f3tA==
Date: Thu, 4 Dec 2025 11:33:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
Message-ID: <6d9bde6e-4c37-4946-8554-afa259b59dd6@sirena.org.uk>
References: <20251203152343.285859633@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mqFkTYrizb3FVz66"
Content-Disposition: inline
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
X-Cookie: volcano, n.:


--mqFkTYrizb3FVz66
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2025 at 04:27:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--mqFkTYrizb3FVz66
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkxcXQACgkQJNaLcl1U
h9CAWwf/ScByOgZ9cEE+esVFWiL4oArYrtMZ5fgakDQEQmxvTYLUFe5QvzVbvNW3
1Tq+ODe2/gVMb06+Lk48zj1maEFilfiNcL7MG8nQm6oDZBfIKbecnyOVlJ5EdcSY
o6s5zgfslZSCYUKyurez7XDORLTbZwOC6H154p6yJR6fMA2MJYN03ixnhtodFSno
4Gop1yicP2D+qWJgiqj4juvUha+H0v/V5InGOjLAEVCTdgDpls4zR6Ue9XnaXvgD
w0SxhkuxIOXJXayAjiDziPrtJ3k9OSMBcO6C5QI1qZ6DbN1aFMTLOtzzJihv77+9
O+9jiOyi+jR22d/7zZOkom5ZD0LdMw==
=jNyh
-----END PGP SIGNATURE-----

--mqFkTYrizb3FVz66--
