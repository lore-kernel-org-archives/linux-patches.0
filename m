Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E515E2BF017;
	Wed, 16 Jul 2025 10:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752662442; cv=none; b=HJo/alGZQtIZf7QDvxr6E+AtAQGTDxQEUuPdHqV99dDY3h6th1mIwwCB+YceGRQFbCWRML4rWgAeHjxv4LurLJVS5L+pBN3/1OE08Yqtkhvbt5Uojx76mVD5YV/WLSE6/fMACVc+SMkZbRS17XkRkyKKVnK3tBWcxU6x4gcYfy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752662442; c=relaxed/simple;
	bh=xCdt81aUKI8YyBuZv9UakAigjVuigu7AxbizcOBUdCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HeyJxekaYu/iOPxCMT2qMydajnlqQUA/nZ0fhXhYVKkE43PvzPkDLvSAX4Z2WSqAvL2w3hidlIC2Vmq4n9JfidOkHeQ0F0iZ7tUO+yhh/MVC6l/LCjHpwsjU6eJP5FnU3jxFn6TXucFKJpHMvTawxZX+nJYfy8fvEimtcfFshOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mury89Oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mury89Oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52065C4CEF0;
	Wed, 16 Jul 2025 10:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752662441;
	bh=xCdt81aUKI8YyBuZv9UakAigjVuigu7AxbizcOBUdCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mury89OzPV//rsFTOM3DOr6hLILlVJQfVl7rVuK3lNVsvmm6d7FbkJSxI9sVkTgr5
	 bZ/kDKM8N9yef+phtwmTVcUEdTTKOA/2Dt5ro1xE2bnOlt6TpMvwlYE8jfUPwkLZjp
	 Q2LVNvKmUjxuwtSzvN+aBNKfQIj6lSEd3Co6Ikpn+ycwvuLtOBVOGmxUWEa429ogz/
	 w9WvB01TleRJYzr4MgXDzwEA9N3NB7ObfT1lba0MuBDMvaYniovLH4ut7qiqoVGvFh
	 IT52mBZMl8GzPrlahGRDoaeJwS5zJfZ5I/2H32OVSbJ3cYKaHgfRGcxzwqX/5Bn9F0
	 fHWRmYXalZerA==
Date: Wed, 16 Jul 2025 11:40:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6.6 000/111] 6.6.99-rc2 review
Message-ID: <adfba2d7-5d79-4e79-ac12-04222597fad9@sirena.org.uk>
References: <20250715163542.059429276@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oZtJ2YSO0FLvUQ9J"
Content-Disposition: inline
In-Reply-To: <20250715163542.059429276@linuxfoundation.org>
X-Cookie: osteopornosis:


--oZtJ2YSO0FLvUQ9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2025 at 06:37:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.99 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--oZtJ2YSO0FLvUQ9J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmh3gaEACgkQJNaLcl1U
h9B+UAf8D4y6Gfn+IDqqFm3KN8gyM8OV9MrL4C675w3k9IryoaT+2Dr6XVYTZesc
ahPXW441oa9gsOA4+bqttlK9v9K7WZPCMp5Y5CLEaLWnkOFzuCFAAk0I0beyQ97l
k1rkrjQV7iQkeeBYgQ+zMX8wo9TQA1VxReXL42sDBv9KMAAM25I4/TbFNQgQV2UL
58e/sk5gLFhOHemZv8r07WjlkbelG4f4V/smCWXOMChJmXwiaPYvzANLSpdnuUZP
MPDEECHgIrpndSCQ7ZPJrXWdwH6Oy6C1ljkxd3mlNiAd0/hcS6sz0BZJzFSQIyfz
bqzawZR9GFU2IB6GFWk4pQBuRZ8CTA==
=8lLW
-----END PGP SIGNATURE-----

--oZtJ2YSO0FLvUQ9J--
