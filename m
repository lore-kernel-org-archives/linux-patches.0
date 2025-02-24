Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D9A1F3D45;
	Mon, 24 Feb 2025 19:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426745; cv=none; b=l08Ms3LpVTYzRs/yIbSxOVVw/QkF+Sx3QfULVeQHeOHSOvj4hPkcKIp8GwhzVbGcXbUvfKVsgsJKCX4meGMAFlcAjoWvKFDtUEGu95ns4xuJq3GYj5wTwv+JWCDTJvgO4dfOpVEDfGn1M4hQv0zfYZSGOKzTk/XbmR5N1oh27Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426745; c=relaxed/simple;
	bh=zPiNL+J4aOqjK2M8LumAT6SIBhvyQPOWTgyjg/wHeqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RsJhQNzQAvDOry6IFUmHWSgX6acio+yQOXYFDcJpaaxY76gJvL/MD+SVfzkPaUW6okgEU1bUhOUEcPCb1+ZLERGP1XdAQamJ9ny93hSDQiYp9eAEtcq/PjbxaH8mue0Nf2AWENZK7J3vBjmfRhnAIq/5syTCs3TeKx7vfMzMXz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmPDtwOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmPDtwOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90E3C4CED6;
	Mon, 24 Feb 2025 19:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740426744;
	bh=zPiNL+J4aOqjK2M8LumAT6SIBhvyQPOWTgyjg/wHeqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JmPDtwOyXV24Okghs0+wW83q0acw0abfPQG7YdW22lc8dZpHvpMuKfQF6YWgDK5bm
	 bLdpLPwAOCNTHxGinL94WxW4ATDquFL7Pc2rULqRzoWU77AXzIob41naZJnRhNylpF
	 uJ5wJfpYAdUff+/4jlFJiE8C+G5jQdJYBe6aAuTpKO66AndaMvL6a0dJBs9ExWswYU
	 0rxtqjTIQKSjnA+xywGf9lgTmdmloiEFK5lakreSJZP6HRTORrZK6Z/VtB7D2m50UE
	 xAeUWrmLWdYc8d83iFitCsPSUkEQhLa6oRbk/iun+07I4fbRZFaXvmXDlBS6te/WL6
	 dEnahMyCzkkEQ==
Date: Mon, 24 Feb 2025 19:52:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 6.13 000/138] 6.13.5-rc1 review
Message-ID: <9a18b229-f8b7-4ce2-8fe0-4fabd7aa6bd2@sirena.org.uk>
References: <20250224142604.442289573@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1vfstmOaE5UUgQpY"
Content-Disposition: inline
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
X-Cookie: Phone call for chucky-pooh.


--1vfstmOaE5UUgQpY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2025 at 03:33:50PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This and 6.12 are broken on several platforms by "gpiolib: check the
return value of gpio_chip::get_direction()", as reported upstream
several drivers break the expectations that this commit has.
96fa9ec477ff60bed87e1441fd43e003179f3253 "gpiolib: don't bail out if
get_direction() fails in gpiochip_add_data()" was merged upstream which
makes this non-fatal, but it's probably as well to just not backport
this to stable at all.

--1vfstmOaE5UUgQpY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme8zfEACgkQJNaLcl1U
h9B6Uwf7BBlWeZTtILYLqkzIiULTXPb+X1dW7Q8Los8drpln7uKLDlfZHuyP1/RB
A8X0KBwDGM+z0tHDNrNBdwwg46XDVQs6jdI/b3b6yfW74wjAwuK9/Vl+h3TzZhzu
yd3s28eUA6SGFjYzWYhtMzMkDhrWPt1yyxGJSWiYahSh6Wev/u0uixFV+7f+mh8y
oPPDi5ec2lAM2fEyovqKkiSFLQodaAgPOf3WPGoNn6fRHqMrkjOKm+sYEy7SNCQR
ucmdy8Yhmn6pC7A16fokVnC3Lf13ixiknerE+aP2Mw/0klUkaZzQUMtwi+VxyCKi
KkBwrL2Dy2Zlolv+ipaEwFW2+Shr9g==
=JCvV
-----END PGP SIGNATURE-----

--1vfstmOaE5UUgQpY--
