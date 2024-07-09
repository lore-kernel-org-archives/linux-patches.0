Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7C1187846;
	Tue,  9 Jul 2024 21:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561075; cv=none; b=WuumjtxFdAvgE88/WPp1xovnRLCjvG51gazFANgDJXawKkIb15fTuI3LsVly1V6ooNBErhsaVcdExg3cIW7X2Q/RrfhgS6BGoDX89/whtFCTfgvNAcjqJgGc5OA66LaAUfGCxOI6z7sLa801ymQKArEqNuf1HusdAWpn+VUEKBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561075; c=relaxed/simple;
	bh=yll4p92pWnXFg8uTkbrS6QqisXcIuNQqSWjDINPmlbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bL6/665rjK1mhXnyT+zC1Lne9ktiVSTiwRVA5bES15gnvhxtVoowQQIesR12V0cXiC7ATwTr2xzDngxwgpWWAVHqW43xez8wDYiZchqI3OCVh+ouI5QWEg0nQ59NrXbXBjyOzl/fJPWA1Nqtbq7AGr2fndIL92wIev70g8Ec878=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8wYnrEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8wYnrEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750C7C3277B;
	Tue,  9 Jul 2024 21:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720561074;
	bh=yll4p92pWnXFg8uTkbrS6QqisXcIuNQqSWjDINPmlbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H8wYnrEWHWwKdmO4cfK2NrpD70XNs++M9M5MyMGvIJHOjJrSNmR+Ft8nYkwo8Fs98
	 LBd9wTfa7q5T48Vfv3QB9UqyFyFFRyO5pvTQFOV46MVCEyokMqZQPbMfdJNyKm49cW
	 mqJyg0GdYxcQotK6Dq5EraPFHoKT7TRxFU2jyHPlF0Je0gEzbVbBsPK3AW6iHyCWa1
	 OT5Uc6VMO3NiGRqAOgk+22X0I9YBYltnCwsTOdh/Z7LcbpDANyEzr9dSFwG3BV4MZg
	 aJ0YSpUTWnotrisYMbvlEjn6IqThsgvm01H7AiTk2dvEKmy0PSCkUV+7ZMJDdJbY1B
	 9gVi6lnThoVYA==
Date: Tue, 9 Jul 2024 22:37:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/139] 6.6.39-rc1 review
Message-ID: <e7319894-d714-4e73-81c1-bd0db9ada998@sirena.org.uk>
References: <20240709110658.146853929@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cgAC78/IOTxDqwCl"
Content-Disposition: inline
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
X-Cookie: Most of your faults are not your fault.


--cgAC78/IOTxDqwCl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 01:08:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.39 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--cgAC78/IOTxDqwCl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaNrasACgkQJNaLcl1U
h9CHFwf+NYZChjFG3/qpacc2PrJAMc0FfRUnx0nFbbRgwpMAtwsXf1Qo6+mg7CYd
C1XTY3FvO2coc8pi9DfLAi2VOF+ADKjn1hKqhuNA6zqtBzoSi8nuoUjg0a52DZJD
ErJcwsp5OuxO007MO03u36Tl6bmGz+LW3U2v0haskZIbGzJhHYd5/Xayhik9nxKl
dbcJ7KMEv78TwZ2xZ94YGuGtnKuxIhi4jwKmn6ReR0ESaxzmvMwkxxHo7F005RWH
EvMVIe7l6OUUCVJSrUS4rRojACADPWF3YywQVoCvS1C9sO5NwJB33zbri/O2yxow
pFQ26twJY0C7PTijKvygOyzG6OJ8rg==
=dBi8
-----END PGP SIGNATURE-----

--cgAC78/IOTxDqwCl--
