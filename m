Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A886E2EACFB;
	Wed, 13 Aug 2025 13:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755093445; cv=none; b=Tnu23Q4vQpi4FAqWLRouyxdSuy1o978mYIaxWEFamtwEzWwas5bXVeLD6QgAAcsQwKa37ALpmj5jb/xSS/rPIij0c1ZFvwGZOqP0fS+kusIgLBIc0jO5o4MYG0knR+1t9WlSHLEMooLpjQsYWp9k3aCJ5x0hz+I+WpJ+wIwhMjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755093445; c=relaxed/simple;
	bh=3lU4HmkA9AN20vd7jHdBY+t7NERFwqnjqzONKOa6eUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYFw+IBlh+z0+RiRYMMyvvawRzhChnVCM6VDeUzQLrH8eXI6eM5RbkDCCybAJ2COvQyt/ln7QZqwXFFqwAGgZDIEdw6QRtDcyxsPEz/OfpYoQV82afPzEXUXe7LqFqlcE/PCISBv631CDUcdglssaz3pXw/YalaNS0LCRBR8wa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rfnGnelc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rfnGnelc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9C9C4CEED;
	Wed, 13 Aug 2025 13:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755093445;
	bh=3lU4HmkA9AN20vd7jHdBY+t7NERFwqnjqzONKOa6eUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rfnGnelcMuXDm+q9v0Djb/jEP5Par6+jJkcxAK6Gb8Kxtr0TImtnHeMxz3/5W8sSw
	 jF4w/uZbu/gptjS37cAJ4qC7FMsyD9LMguzB7K9DMKv8J8GellFRkO1Hab27U8V8I5
	 072l33RYrLtdjmIn0ttP7C1XmhWVFh5Wo7mr8lFLMvyfEqhavQYSoi7oyFp7+L+ZEn
	 vOzRwa0Geh1CVXvRvl4kDK/BDhaJ6TN0nbpwwPE9SqfhvBILx0CISTQmuDXa6m3kpX
	 H4m8pzG+zXQcPHjotcJKcbWgXzKmzVXmNrGIjTTLBpc9Tr+Tjzep1lzAcWM/rzcy++
	 zd2Jee7RobefQ==
Date: Wed, 13 Aug 2025 14:57:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.15 000/480] 6.15.10-rc1 review
Message-ID: <1f17c1d2-8264-48f5-bc90-bd7ecb92c8b1@sirena.org.uk>
References: <20250812174357.281828096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZE9g3Ug+aDKsFM4q"
Content-Disposition: inline
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
X-Cookie: Turn the other cheek.


--ZE9g3Ug+aDKsFM4q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2025 at 07:43:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.10 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ZE9g3Ug+aDKsFM4q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmicmb0ACgkQJNaLcl1U
h9BnOwf9FmBxhR/3RzFkQ7MIfM5NonWYdFT2ZtBdC7RiWpFuRMoDuTSXzQM4Qcmr
D9jRdHend7GO3uZZ1mCwglROzPu0+qainsPRu4W7rfY1Yf9GYQOY8EWvcXtsJdaB
/6GBT7Hce1FGqm3YDtm11y6A/B/eqYNXJuHv9RIT4biD3H14GU3VGMKQbyeu4QZh
DQkSiaRnCocFv+mNhmtJJw7i3M5wA6o1EP91mlHqe5oQbAS7x72TVJtA3zWyOI5B
0Beizn3Bqx1z1y83epDZ0toull9v+vbQY/44Q/qBGJaShfbgxKgj4OzxAwHQToHD
meWHNoRFj4i9UFYmfQbOmzgsgxtznw==
=0DYm
-----END PGP SIGNATURE-----

--ZE9g3Ug+aDKsFM4q--
