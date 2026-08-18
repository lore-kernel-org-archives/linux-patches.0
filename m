Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C04B47F78E;
	Tue, 18 Aug 2026 16:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787072033; cv=none; b=DeSNAfHC8ACq6DYy/KgASoPBp96DO96gErIZ7WFjLKfJ6qXP0Wy2KwAp1A+FmSIq0xwR6FcAbY5cn0t7YoJNqA3xOOYZcmlQXBFiW9uObin94gMR+DEEQlXpFpShk81GBWIoqaFXimo2K9DNcoNRlUDz45ee64ReQGCythGPmpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787072033; c=relaxed/simple;
	bh=voIFcTekL6Q/1lic6ONVaLd1O4Q+pImQL+95ntz4u4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1IvULRKmyAT75cB1ZPpKJPkHjfjLluC+fX+p1nW/R6+0erZicREXhAJKfAMLFvohpP/S2/nUwqKhsVx4n21Alm79OC+DdvNHhssyrAwgdQ5cKyTpZU9VYuJg3Iki5LBu6YB3YGhVw4YGL08+4V6G+Rixdta6ayMWhHfZkR6BHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kPjdt4az; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kPjdt4az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6877D1F00A3A;
	Tue, 18 Aug 2026 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787072032;
	bh=+jfWw/gRICDjnMg38eVTNLr1gWZS6K69NEk7XN4ZhYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kPjdt4az12c2e4ZoHsA5oDmoJuiCM8trGyHs3zZgpo36nLCEsLoYrmMLU3KmHjULw
	 bKLh22NogPZLcHk7+Ht6bmnyj8rrg4GUGKuYjcB1HZbvSgsOLEdfbuSDGQ+BbXH/qv
	 2TfEZ+EOMTQNzJod2kmqJNI5soyCWL4umtfdaGTRYNvM5hIDnbSUIjc5X6OsLwysGj
	 Pc1y+8X1zFx7PMeCKxdbZz7ElYzTGU6+CfikRW/c6M5kcB4YXx/LeQ5biVkDnlH/Z1
	 Oo+1KRrI8NsN4NdQZJS0TSEDdvNlJJ7d0g6/HsC6n4y4T4r7bKeF6QchYguMC24Ks2
	 5RxOpQLfHSqtg==
Date: Tue, 18 Aug 2026 17:53:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/389] 5.10.265-rc1 review
Message-ID: <13ee7fff-36ee-4395-b0b6-cfb4525a61db@sirena.org.uk>
References: <20260817132538.796021292@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zfO3mZqb+3cvbsku"
Content-Disposition: inline
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
X-Cookie: Smile!  You're on Candid Camera.


--zfO3mZqb+3cvbsku
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 17, 2026 at 03:27:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.265 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--zfO3mZqb+3cvbsku
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqEjhkACgkQJNaLcl1U
h9CXrwf8DNAZB7iupC75vDXekVt8D/aFLigzsKudOWbaoi9TJ4VqH2+m6KKPoC5A
2mtY7ghdf7BocHhsSlvB5q16GnPebt+YUauJjuRny/G99fhvhMCGz6yhEpU4BtVc
z/3X/1kqWnRPAQvBfUMYewzyl5eR09EWcFTFrWzsHqZHcwUHEz9PcbGhVXYotYxm
FJXI7f3VLhqX2ObtBmGK1ehOYxo+FgEihQNJlZ5MvBAOtObNTE5BFzyE5ESC0vv8
Q5whxmtGB2Tgd0yvuV0UuVmNoFm3OIBNA78GqZlWzouHb+Yc7itJNwOAwick7w3K
g2EaR+lBw7BaSneBXUKQB4b10ZNTCA==
=FB4a
-----END PGP SIGNATURE-----

--zfO3mZqb+3cvbsku--
