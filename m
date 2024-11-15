Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EB5174EE4;
	Fri, 15 Nov 2024 21:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731705609; cv=none; b=s6ZnpWvv0Ix3BKfL2KghTjhJf/IxmHiK3H2ghxHaHVPvbOE0TzvauUJ6Ubz4blkMvMIXHT5yQrpiJpkUWbYwlTmttvpjpZF1V++8gbFmyefvRKbw3/SwjPm0GML3AcQYh949K8lqMLX2oWXyCglygKQROE57nVS6D8BZgwj+5ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731705609; c=relaxed/simple;
	bh=H1l4FI5tHow5XTrDeqhbsWTQPiefe49vcpKU4feyZAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YudaXOR7S816rMrriHzjkC0mvQozpe8jfhTzBLQNv3SqJ7aMyNf2VODvoH1c8Bj7nCCHnh3pe+aH+4fh9WC6FDaxUj1c+z8OulkVP9jfl7yJtK5JSJ5tgN4stxzvXZs9GDHueGQScF+iXywo53+8Ohd4v9C6Pck970zGxVkePY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFODeT+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFODeT+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EEAC4CED4;
	Fri, 15 Nov 2024 21:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731705608;
	bh=H1l4FI5tHow5XTrDeqhbsWTQPiefe49vcpKU4feyZAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iFODeT+QN7IV/dUfs+gH7FCfIClT2r/NqAzkw3rQPftUUvniWNolJfIw0y4KM5Qb4
	 /oJvOYLpQ7SaeDxUwPriTkeUlX8pRy+Ep3Nlyg4S7K3lwyWJVdxqUPno5/h8y0EqZG
	 jWb925CAQpFTYCqsNKDJaJdRK3uZobxu9iTaKcew8ivLFkrisr+J7nOKjgT2dkAhZd
	 uIKzWumrn+gQ1iLTsOIRweXlUjpP0JtewjXHjTgIXlxPBzSlMZZZRn6zsWWSfVYgG+
	 ETeijFXGZEwCJdSbWU1jCj0w0fdcN7KiUtWQACw4fckKQUbseYvAGC8cC9hUdB8hxA
	 W45/rVFzSVU7w==
Date: Fri, 15 Nov 2024 21:20:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 00/48] 6.6.62-rc1 review
Message-ID: <Zze7Buqiz6tlkyyM@finisterre.sirena.org.uk>
References: <20241115063722.962047137@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tjSTJ+9+4kXjjhOO"
Content-Disposition: inline
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--tjSTJ+9+4kXjjhOO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2024 at 07:37:49AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.62 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--tjSTJ+9+4kXjjhOO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc3uwUACgkQJNaLcl1U
h9A9iwf/eFOA6UvvLTn9RHVhTlkMHVB4FNMrvf5KwuSTLX/Yf3exo1XI+W5ayBMT
cyMZffWEMmmT6S1YD0tVBr6MugX/6GQux1mtoji2BrEYA1BX6Ufi58LaRu5aWPC9
vDGUl37aALUucQJQ28G/Bk+WSrHhzOYtDlzTIFkkgF2KwdaBhtRKYV9GJ39/eAN3
tJc7Rz+J2A5Y818PA9TAZ1x858hMtAQkD65PT0fyYqBj9O2OMAOvuGimRz0Y2tT9
0bwccaIMPavMZhoFDYREmbH9cUK0OCzKXeRmjfNc7nsW31LgANyBiygtEiMdiw+V
qFlnHoqFQFpCDsAVuNukQn74qjt/Qw==
=YPpk
-----END PGP SIGNATURE-----

--tjSTJ+9+4kXjjhOO--
