Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779A61FAF00;
	Fri, 15 Nov 2024 21:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706063; cv=none; b=pittSrQ8tyZTxoaCvjzyGee9L73OfXqXH+RIoyf4yNbW5hR17FL3EzElUOYGzEY+EUuHSvHFi+ooA+mP84BREMcjoafq2aU7dZNiudgeYpimyCH5UKU0Nu7j6WtTHq2nBx31SFcsIkjUsF4353eGxizqZDnnMV+JF1HvSxDog0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706063; c=relaxed/simple;
	bh=zBajkRM9JbHpDxyGGYx7924Z8qil0sf4kBqZ3lttZrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bvX7+qGdL0LT7s+JHX6ilaKkl3A2knYpn1mBdlwcNxaML4a30qurGJM+J+Byhj8iRjzVpUyVtCM8NGpOFaj8VYEz6fVli2lFtsyP4UZ2pf9NaHzWrSDiMpyKm7TkSMTmP23FC22IYT1EKV1xeTB6t37LJkBBUj3lnGlzzsIhmRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IpXh+lP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpXh+lP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98390C4CECF;
	Fri, 15 Nov 2024 21:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731706063;
	bh=zBajkRM9JbHpDxyGGYx7924Z8qil0sf4kBqZ3lttZrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IpXh+lP9Z3Ke7UE7DhFx6lLU5gW8oguhRh+c9l94/LhzXaTFxKNVa3Fdji64fXKYG
	 c93sPQwY0LN8UrnqRyUMQ07iIJMYP6L8OZhZ3tfzqZZgHuk0SGyxQih1rj7qRzISm8
	 +IUW3McJ54sl0AqDycPboHAfyoXbFXBxVpEndWke9h2GTjULctM6NELXe995zhvm1F
	 xLmfFvQ96pY9qIsZgbjzCCSn0yyVEAbi8cDCY5hu6lepQbxXPtTvMokGjQGqJ0So1M
	 neQTCboDuw9kHeMmQS+yfmu3/xv+n8qWHXZCSuNQa+AmBL8FwHihGZ9KC3T8hl/lhC
	 D14CsElkStLmA==
Date: Fri, 15 Nov 2024 21:27:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 00/82] 5.10.230-rc1 review
Message-ID: <Zze8y08U9r5G0n3W@finisterre.sirena.org.uk>
References: <20241115063725.561151311@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/Lgc3cRAkiiFft5E"
Content-Disposition: inline
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--/Lgc3cRAkiiFft5E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2024 at 07:37:37AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.230 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--/Lgc3cRAkiiFft5E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc3vMsACgkQJNaLcl1U
h9AdvAf/TtI0H+SWxVI7IK5Z5c7fnjl/HImIj0Wjxbha7k7JU8+Gi+g7XTdy8Sgx
DIVl7JBQ8Rccpstn8Z74jGtvXqgGrKtYwkIgHbYs/ZlqPUAVDFB5zfDvvDLfBa3n
UzAzgoTHjDSeXnQFHQTNsW/s8Sg6043Zlp7w9XLLcOmg8iP+tY+HvIKTeYIM78vY
EWuPyCCSWYPujgJmskTEnAyeCurFUJKwgF7Z/5R86+Xps9hvKcrXPTdaCdP4cImp
3jCIQ3F5BwvqJ8+ArKPNMu+RrTtmSS9WvwDgYGYWH2HaSXFNKGqMcT3SVgjLc7dz
zgAEzRXJKdJ/wE3aZT+/nLtsxFtmUA==
=qwQ8
-----END PGP SIGNATURE-----

--/Lgc3cRAkiiFft5E--
