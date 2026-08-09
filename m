Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597EC380FCE;
	Sun,  9 Aug 2026 11:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786276462; cv=none; b=Re6mDQQwmd9+Y1zZ0A/jhNIEnQwbKIuTWOARz0gNH2pSASMmnaQuSDZjw68FJgAOEwyG8ojSYSH4SrBq4BQBiP6gOGXQvcExtg+axMw7AWOhXfGYDN74zOAqFvtm+aT3zzXTvse6mX+5Mi9TC4bm/6aXsGPOpwd2A/xF5Efegfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786276462; c=relaxed/simple;
	bh=REkw/JwjzRIVhMpJgTuK9hazwyhJ2OJoXriaNn0zu1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJmvn+Ym/poLEq+0P3Ysvh0h12OkKzlDq05plMPxyPL0HkWcljBcxnIn3IvUy6uy80538TdisA38n3YFj4i6Xa/wkkTYTTdZBsngM2kuZ66W/7uTHHDhjxmlhOIyewFoHXWnjn2Z7wxIyuqVS0t835Jn5bw8Dsih73kb6ra9rvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTc4l05t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTc4l05t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014321F000E9;
	Sun,  9 Aug 2026 11:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786276461;
	bh=yf8dOdHISs0AipXRUDugGljXRfqH6Pf9uKpahO+IicA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VTc4l05tMo8BGMqYfHbfwlv7Hcs9/+v0uukhMp33dUPfPQx2M0Cd0pz1gKxqNZYs7
	 Kvr5xy9dxPUBlb0MCk40J+uRj1/dLle2SgVLM1vOnI9VsEA68CeUeOFOslNNsq/33Q
	 Uxm6ksUTqbyYQKLhBSYl/goZNIaKKsgdlrnWgmzMi4kY9KTozHhaxiSfZinK4IOX2L
	 HTWroMRXvyO42cb+SHiLQAWLzpi5SR3vnG0KbRkc1imJwSt7Im29lSUuLwky8g/oJt
	 mlyzhaLHAxD7cpo6Tg+5ktAzGi/YNIhHLfJs+jMAf5F5c/slaiUTg9Ql3bT533bDLh
	 xr0zfwMB4aIsA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 42C8A1AC56E2; Sun, 09 Aug 2026 12:54:18 +0100 (BST)
Date: Sun, 9 Aug 2026 12:54:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/396] 6.18.44-rc1 review
Message-ID: <anhqaoI5UZJUBP8O@sirena.co.uk>
References: <20260807143424.272339768@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QE5Tfv1r3v7+5THi"
Content-Disposition: inline
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--QE5Tfv1r3v7+5THi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 07, 2026 at 04:32:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.44 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--QE5Tfv1r3v7+5THi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmp4amkACgkQJNaLcl1U
h9DjJQf+KQYqbmjscWn9CJmd9ubswuMkoHTSOFAnNOzmkoF8F7aaXbtY40PCTdWj
zUIkQ3hVXMKt2H2tEiRAQafoia9ZK9Gt08XU84ezzrEyFdBu+Co26epAmY188Kxv
UTEjh9H34d/roWac1urY6crCjQbDoskM4JUSZyXeT52b1uzWSmK1yYUNFHnU3sez
1CgL2HZkGk/vY8DvqW++HKai6h0NZhe1YgpYafT1HjDzNyOs0735d7BUuRu+g0bM
Cx+N2HEPpDrobpDJxAqEcF3psWEOvge0LmUqZq+FpV6Jw2k9JKj+XH7oDJcSCwPc
0aLhvxcVVpdPsIUO391xQk1r3OwA9Q==
=WL7s
-----END PGP SIGNATURE-----

--QE5Tfv1r3v7+5THi--
