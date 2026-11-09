Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794241107;
	b=bW1rqEZmWeo8EMxpGV4s2APUgMV5qUD7hst+PEDHP8ABAnPuUOlRCXk4bdnxSuM/UiZv
	 otKvOlGaSjae6tMvd1qSkLvJSpOPXA4RVosXQ9YupSW+nBVsUrnC1nGD4DugA0sl3hH1r
	 nPhZE2d708QeQyVnVaioJjW8+FEusxrBnO14ljPWzA+d4JiGCHBHY7mZr2uVP3zI88WMd
	 FJnbc0QhO2uPnECOnmTGmpjs+p0R+3XGLbDG3FSTBdq3vwyFXd9MOicczGOxPf9JoJe2z
	 d9tRsGJdEF6pMF3hSM4ujiyMCb75mYwfHFAbvvvhlJB9UU6dKaINf6KXEQBuD9cjknA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794241107;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Cookie;
	bh=TiHVbhYrNPZSDwOZMXflQ1/53Zk1mhQwoppsYfCm+vs=;
	b=aCFsb36IdvyVEZ88fAIP9Fim7ymYP5XkkI+VvjhW80KU4G66gSdZ9MzhClDHa+J3e1aO
	 To244+V43NOLVljx+LaGsIWHvEdpOc5pArj/tIMaYkWxkfPQQeXqFfKXHppO11ez3O9WN
	 VxQnq5Rs5TF0fDmdMgz69qoiIEwItb/45VHF6303zHm8q4ZxA3rUy9txUFcqNkskxTty8
	 iZKtp4rgkGYh8zvDMSYODQxCDRkRu/uufD85wlqKMKq3r92xoeK7/P6PyGdl3fbkEX2j1
	 IvAwVWAbuJjwxmVVF/7ihiHmUTkRCIblMGN4DutwLphwE4Zq8Uu4/GBfO1bcKTxnkbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gx4VLimJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1790606A321;
	Mon,  9 Nov 2026 16:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gx4VLimJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CB51F008A1;
	Mon,  9 Nov 2026 16:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794241106;
	bh=TiHVbhYrNPZSDwOZMXflQ1/53Zk1mhQwoppsYfCm+vs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gx4VLimJCleLALweejOLhZK6fi4ejheJbQkW4KLdQqRJtMCWP6eYuJB3ip2RhUwGw
	 abC0N9to5bQwPlDBP/+eOhDfkKUazBs4pIP+oOaM4c+cLIj7oVRCOkz7dSJJdc4iCJ
	 Xn2wvHMMjCJ7SsjdLce7Dphwk3AS94LHmsmCf1GSIe33+/VhlU7slgMYOhujMfIoZo
	 YWSouj+/MSJH9d+nL2/JLf07lL2kHjPsKD1REuwmkc5mSYq43lPvtBlmVxW1KbgVnU
	 s/jILTB1F+352LUqQnGJb7sahakFiR/+3ribiK7KtlWjcFO+0Bgha+094XUJT+b2Ld
	 rllOv0TCMS1Rw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 9AFF61AC5995; Mon, 09 Nov 2026 16:18:21 +0000 (GMT)
Date: Mon, 9 Nov 2026 16:18:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
Message-ID: <avHyTT6yuERbqbxV@sirena.co.uk>
References: <20261107134939.434104957@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bDcwwiD5thPOoEFS"
Content-Disposition: inline
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
X-Cookie: Victory or defeat!


--bDcwwiD5thPOoEFS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 07, 2026 at 08:38:16AM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.4 release.
> There are 1257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--bDcwwiD5thPOoEFS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCavHySgAKCRAv73Ows9A4
idm5AP9c7KADHfDyYthQH77TkM/L/Mb7kY1J3N+kcYdJtv8vEgEAzu/wb7440UsX
L6aJlWsab8hy5jM5Xcgen01kKUawcAk=
=G8/8
-----END PGP SIGNATURE-----

--bDcwwiD5thPOoEFS--
