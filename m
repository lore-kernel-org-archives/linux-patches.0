Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5156F2EEE80;
	Sat, 22 Aug 2026 13:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787405443; cv=none; b=UgKXoHPaWviQJlbmze8v6+YpQRBPG0utxOPGehbjpUutBjoyU4dPB90NbB79Zp2djJsaaWj3Qp2QQ6aeQ6zoOMiVJJ9ZQqsNNsfjcJ3EfuGADpt7cac1C2Htlxhd6ISjZS2hmm3q+ejVhsPwkCuE3HN8QQplKRGWJOpphKca9qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787405443; c=relaxed/simple;
	bh=Cxx2VzvBBfnipA0DmAXQx067lp99v9u1P+yXwV3cuPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jp06SI/ZxrVVQHdK4jqBxNskyR6Q8E+fyLYA97HXSQglZWiAviw79JB9DipKEd9mfYAq2koOcK6IQny1BNfd+hYBgJZvdYzgiHltIKSMDY7JEGJ8izZ6Yu3ehaqB6LBYNdtqEFaOXIiu51mm16qIiUJ4eRBmRW51PQxSWqR0yxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEWybGBk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEWybGBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106401F000E9;
	Sat, 22 Aug 2026 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787405442;
	bh=m0N3Tnk0ZrVZOZuOd4yc3ecMw/kbCadIn9BaU7bfgFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AEWybGBkq6PxLS9oWlj/8IZtFglT7bvxXPMvXKGF+i4YelvT0iR3iXxNvoi8p5U0f
	 3IOqrCeSY+3EY12HO7xqar3P9ADpeQUuwCdnrbr6ptHaqvT0TBwOL2C8QoYD5UldLV
	 aA/dMzc/g4ImGSMBk0ReHDY4Rg3bQAuE4no6TcvtGlgPF5bkvJh6vg4mbcjbtbd7MM
	 X/KqKm9reAEHUxvRlLcD+4UvNz04Q4lBUiSxm4mQ9z+d/Pk7JhP/LugngpvfZYD06k
	 0mEwZ4jC6xVw657WLayKKlWXrk7Jx4y/bvgOwcZy2smaQ5Erl18igye+q4pXvpDr4G
	 bqUTqk/ZLhfJw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id D7A131AC527F; Sat, 22 Aug 2026 14:30:39 +0100 (BST)
Date: Sat, 22 Aug 2026 14:30:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/235] 5.10.266-rc1 review
Message-ID: <aomkf71pGkpHoOOE@sirena.co.uk>
References: <20260820145216.426568665@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="icXLkxAbb/rTBEwG"
Content-Disposition: inline
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--icXLkxAbb/rTBEwG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 20, 2026 at 04:53:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.266 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--icXLkxAbb/rTBEwG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqJpH8ACgkQJNaLcl1U
h9DERQf/YudxIQcW1KecwqcGYOXSdMQbyVHYYP8kqP22R2KraE5xC4bJOe5Jn4ND
U5L+I+ksnelj+AHSCCc3J4SiCt1hjf//APIhrAoQZ91ML1hZljeH8kkbq++YkftE
ua5uUZ093RJYYqfLJqThSMsivq3v6XSlK3rdV8/T2mf3vQak8lXNVScMEW1qtcAM
JxJCOIPh6zVLF5d8HaNI8tcsQ9NNkLI0MkJYZ+T83z1aqCmN80K81KF21HrmFcQU
332GdLBP7bI8GW64KyoSLkFoQ6JUK39CkKNcyZOcrqcJEwQKYC067oTd6T1+q4Vo
SWJghT3uE4XYnRBqNGy8iJJFaCdNKg==
=iy2d
-----END PGP SIGNATURE-----

--icXLkxAbb/rTBEwG--
