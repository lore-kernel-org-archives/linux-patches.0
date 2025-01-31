Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669A8A935;
	Fri, 31 Jan 2025 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738344741; cv=none; b=Bmoi+A6jXMbs4E50+Y57IDhXAL/W6UMVdUgcllIqUd+SYtwVx9Ll5LO7IcC0j/UY0aXHDQHidWnj3SfqUQ1r5DsMBReYhpEPZFzHWjfz2yD9AjHwIzLYCskLi7HBah25/2XFVzYrwH7DWg799z2DWBNlH5zYNl2EQfBY8enisz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738344741; c=relaxed/simple;
	bh=LJfAASzw1F9WZrfzU1gbocaygFc+yPedOgcmle/zr+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtWA3Q0rORXAdTMfH1hQw3tmw+B4JMkEZlVgyOb0b4Hd2fZslvbNLcsRbNGp4sYq30rlOLtahGIy0R30rGEM06i6I2wS7/mJa/xsYQIn069UdnPlC3Zf0/VHvQ9Ia31gyZTqipuL3RrEY8lWRnTMnaNFnmx9CgZuURA3ddOPqh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OYx1C99Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OYx1C99Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5299AC4CED1;
	Fri, 31 Jan 2025 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738344739;
	bh=LJfAASzw1F9WZrfzU1gbocaygFc+yPedOgcmle/zr+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OYx1C99ZK3KRs2KBYBPKMYG11LE8/660x6/qa2qk4+V05YgKMh46syyNL2W+a2GB8
	 rCZsXFERBW5AttinI0VFBsL6EGRDyYnXmxpeesXDo5T73BTM2ifrWTgZ/3lMBKQR3h
	 nD+3auRVhUfbaO/20nFJlVDgLeNh+deVscsj5IH+15sOL//pvtt3PGkqXzdkdFbqA9
	 drdswDeFPgbUGKoNxuzI5/v+EaMJ0fs5ZuEJg2GLG6hg7kROYhJpznZbe/QY+et5Bz
	 BitLjjHAxCaLLFnyPN4QG4cGkQ3MebWxwZM6ynJTzOzzwjzkoyHV6qhwuny7iwSy4g
	 7xdGhEWpCAtqw==
Date: Fri, 31 Jan 2025 17:32:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/136] 5.10.234-rc2 review
Message-ID: <Z50JIMXD3yCWxgGw@finisterre.sirena.org.uk>
References: <20250131112129.273288063@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pk/g7n2SWzfSWykW"
Content-Disposition: inline
In-Reply-To: <20250131112129.273288063@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--pk/g7n2SWzfSWykW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 31, 2025 at 12:21:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.234 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--pk/g7n2SWzfSWykW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmedCR0ACgkQJNaLcl1U
h9BbWAf+KP+nLIF39wKB0t4BKimS5ISizwomyBVRSDltY4vuSx0yANL9fxSS0FXV
4ClYnkX/9Ze8Axnjw6QV28o8bHv6EE2IDNn1IdQcbts4QDg7rcZ2Z1YZDgdei440
Br552e2IYqJu5aavED8h94Oo3vwUwz9JM61/XyZmyvAkygaxUebdtPB2FDB2eg6n
vaAwe5A1Rx9ehMsOgZrUgkISwPFnrhLpToCVfxv0nSLCBCT0c2Qi7fS8f9TxiG2l
ayfk4XzsS6qbjkR4ELd1y2MCwaYZONguA+5ejQvPuZE9/uySb4bTh7hcZib7sla8
YfBevpZLhrkuIgsrJnZdCqdpjMdKng==
=Jij9
-----END PGP SIGNATURE-----

--pk/g7n2SWzfSWykW--
