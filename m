Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0904C8C;
	Tue, 13 Aug 2024 11:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723548302; cv=none; b=VaFw3U9bi4rtnnx/GuHx5qcPM0e7ZQnXO5Od8XYT5VyeBpsF2MCbHXEB7XU3Jb/lMZ5C4Mj0kf8yquHeVyg4xhNcjpsrhfPYWjbdInKhrSZFkgLMwkI4Qm0o2t38VA4ROCzjUZXq6EpHtLnrg7WF7FtiggFxDJiVCBlSPJUb728=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723548302; c=relaxed/simple;
	bh=N+g7lc8Xa1A6Kj1evZnr2KHyt2B7R02xTzreXYe3rqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZEwDCtftuxRRSYeMXe96JblxYL6V/84Q0x+jWuNy0l+LdgeHS8i4+dNnq+czeBA6dBVxGZB1PxZUfjcG8GdHPgs5tIjIQviTIeDHvTQg7w20d2SmfXXpsxKenHwdWtcn1kcbIIZXQ7pUAz/RJJzAipA6u7Plf0q6Bt+fg5PncU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijN4iZxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijN4iZxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2957C4AF09;
	Tue, 13 Aug 2024 11:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723548302;
	bh=N+g7lc8Xa1A6Kj1evZnr2KHyt2B7R02xTzreXYe3rqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ijN4iZxDMBDy6zIGKP3DZuwvKGfDfwzBcgubmWdK22iiGpAhK00Fcmn2r4lq3sziX
	 J4cYGMHcVonwWKD7EzYuRZ5Buc0YNjE9jF+q8eKk9XLVISDHbwgDOybtOUVbmQxs9j
	 pNUXqc6FtJVgUj12wZc1Uknl6bTe50UFj90ZJexK7gtphJFmbiL37nyE0H+e+HmEDg
	 ThDqd8ak/3/PX3QYYhrgT2d2ZU11iJMhMoNPc4OtfphilB+llHTb0tixT5uYO2G0EA
	 7iELZpmWJlYwJJW4hIei1f5NkOML6i4Y+dk0zcN66LzWz31vBLggvrbOdh1XFQYn9U
	 wUcRnnwULmHbw==
Date: Tue, 13 Aug 2024 12:24:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/189] 6.6.46-rc1 review
Message-ID: <2dd8306d-7edc-491e-9924-ca4f51dd286b@sirena.org.uk>
References: <20240812160132.135168257@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L4/AKvU2S5bv/I6p"
Content-Disposition: inline
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
X-Cookie: Say no, then negotiate.


--L4/AKvU2S5bv/I6p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2024 at 06:00:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.46 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--L4/AKvU2S5bv/I6p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAma7QoYACgkQJNaLcl1U
h9C1tAf8Ch3dW1rtYMMZbu2K+0nb1nktqbVYbeKtqlxa0/vVSJ5NkxrEYxX6pp3w
wLo1YWVmgsVFYeuJQBVM+vxGwTkrEWRncEv6CeaBFgMOsmaLz8DEIlzrTUBicm02
29+vk9K7HLfFCW9ZXosgSEVz29YMPpMXfoCF4KZMkBPkZ9vrGOFyytQU+B2E26vZ
Rgm2QFH0+uFbFBdFyeeN2dEnNZITyn8xR2rZLzSM/e3SXWJZEHFoGz1r2MuLmkSz
+sgQ5BriZ4s0mZXOGOt/Uw0ZsikRSiYnmy3rjn1oDeQI5bX1KLECuX6TQF41HDfB
1rbbb0djt1OI5Jpn/PialabdkyqbnA==
=qE5E
-----END PGP SIGNATURE-----

--L4/AKvU2S5bv/I6p--
