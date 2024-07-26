Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA51A179204;
	Fri, 26 Jul 2024 11:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721993268; cv=none; b=ozpjZ9J2QrFZWf4bKvP0Kn0drMYgbh79kW1zYC2k51JW3GA3FtFV3lu4S2P7VXDNj0eB88G6jofGfSoIVx6PzC5mBbro59ZKw/D+Q9Dvdw9ErPinVlL11tJOLrj24c0JsE/ww/PO30ByIjpY8+ZzfOKRf/I05LHp9ITZ+bP+uyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721993268; c=relaxed/simple;
	bh=LaKJhzdJVy1QDB/x/V/BHmLYQkCw+GgaTAZTBKfgUS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4UhNMSGiH7+Z0E1yYRfmAbsqkIt82cwPE6JwjSxm+aJ8qXDaAraaU7+wlnGkMASmJFK8omrvbOJqg0RcpX4V8Ah6kNDHQsjW42pHDhO+h7o90HlSTTy2iidlGcwe/i+3DtrJzer52Ab8tQ+/kyPbRRrpKVWvq+gdzQ6eEMw5HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/QEkPfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/QEkPfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A315C32782;
	Fri, 26 Jul 2024 11:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721993268;
	bh=LaKJhzdJVy1QDB/x/V/BHmLYQkCw+GgaTAZTBKfgUS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B/QEkPfGsdzkLgudHZBO5rM3Yr3Z4sccgbIz1l7bdF3Cc31akWU0X5TQyU9pMOfMF
	 s6kzH7e2xtkOQ4ubZC/E7IfAM9CO8GA4Lgop1PmIodQnR/Yz+4ltVxmmMc0pO7cR/l
	 UUfBnhe3eJgPTffIMVVTZdJSdM9zbzlH1ZgpYmIqMSI0uwneHnS35UNKzQMChF4Uxs
	 4HhWZiBp1Bgdjox0Xa1yWqtaQZKlsNL0BwuMu+alKoGH6juZalqo+ahvyaq0obOX5P
	 f0iE4cPnmE9duJ2WwAcsTKZJf+flt3o57tPWNMl/zWF+F8U9wAMgPZRIFQ+2gv0JWN
	 iXjLJwLHURQbA==
Date: Fri, 26 Jul 2024 12:27:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 00/29] 6.10.2-rc1 review
Message-ID: <1ad3e57e-6453-47e2-986c-44374035c36f@sirena.org.uk>
References: <20240725142731.814288796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9ry2ZdrrFeOQvtac"
Content-Disposition: inline
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
X-Cookie: It is your destiny.


--9ry2ZdrrFeOQvtac
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2024 at 04:36:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.2 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--9ry2ZdrrFeOQvtac
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmajiC0ACgkQJNaLcl1U
h9CLYQf/TAkXDb7vXomIgycowafQhcF9+lXAyc3pAaj0gNz+Vqm+quKvORb/Lp4p
EArA8Ejl4nhXqmj1b5hOR5L9HxMcrHZgRwt3zhl9hmd6uc7IwmTxdFigtGGdfACH
acJxIgEDvSgUoOaGGemIpyF7Frfv1b4QcVeS+U7BS6rN6XE572vM+21GTyiascV7
K5wGEIdMwpLD3xH/AMRLon4ZZ4Do5V92pgzn3GVaL6uPpElwRhLJ+9Eb3Cr89tOQ
cuU6rgsMgt2japYlr642K7MLsLaapx6qy3lVsP8v/JrXaeMoCto0FX1dtihnO/Rc
CFuLjjSDpUjzSdZp29lynL9dvXX4xQ==
=tFIL
-----END PGP SIGNATURE-----

--9ry2ZdrrFeOQvtac--
