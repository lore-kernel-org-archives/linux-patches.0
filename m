Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F2C17838A;
	Tue, 25 Jun 2024 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719338478; cv=none; b=oefJDADQ8y48rUc5zoK7tZhDi37c5I+4B9miO7JsUmRuU5IyMuApHG11tlGu13aywhqDN7k6UebXsyCZWQM7+0WRZjpmIh63BfC1uunG/M0ALungeSGhP5p24jSwrV2NDitJnWOhYwnE6nhqYc7rvliYT7BD4tOKNthys5xfVEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719338478; c=relaxed/simple;
	bh=581TvUY3mJByA5XC+X/X7x4UvWa//Ogr4hW1i+//mBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YTYsvZZ6EZL+tZP/etbhd+UiEjPRJwadUX3sQo9xAfg2SAU6XRWDRpL1PvgAvRwsaQtQFi3xU+jwC69uoc4oBWPQ2xgYdoWyafsZ7gPNpPqsb1eTtUP5A1z6hpfJKxznbCUYP3TFlnKysoXLsfL6IfaZHfP+Vm98+9gOlGuPzK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hycsrXJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hycsrXJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B420BC32782;
	Tue, 25 Jun 2024 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719338477;
	bh=581TvUY3mJByA5XC+X/X7x4UvWa//Ogr4hW1i+//mBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hycsrXJuR3fpC7t6jObMEVdd4cIYTc9mkuvIR5WJI6mBQ+ma975t7ujpFvW/foiUF
	 AoWMLIELn6NKmF04CA3DRkHiB99atFyLf/zFgFbu/mILeWxuAYkOuiCoK3a63pPpHl
	 onn2bGwGw/m0+o+4WD5V38wsZJ9CQ0dG+a5QYxiyB+roYixoTo9/7K1cwaAcVjEDiH
	 wMoLmVYy5HONrjbx37PuZzo6kBVa5Ck/vPTw2JZjyqfFmymEQj5xBz1+ofTedXmR42
	 euwaipYA5QlM6meqjpmzqXpalfJyYq7kwv5Tb33j1E4dPt8Q07SIr1p6LD3QIlsOib
	 u5Be+P4raZnoA==
Date: Tue, 25 Jun 2024 19:01:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
Message-ID: <6b4bbcc9-a32f-417c-b021-3318df96f7c4@sirena.org.uk>
References: <20240625085548.033507125@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DzcjpOFCm2JhpXty"
Content-Disposition: inline
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
X-Cookie: Results vary by individual.


--DzcjpOFCm2JhpXty
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 25, 2024 at 11:29:18AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--DzcjpOFCm2JhpXty
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZ7BeUACgkQJNaLcl1U
h9BLGwf8CnfbF3ybaO81WqCAktqF3oBvuuPznajTkeDJiq6l4Z6Ruz6LBZImk+4x
kpJD/1y2MrmndbvW9+ZazEnL7zsBXaPwjnZkCj3OMk0VjC3VdouU+5+g4umI4RYu
c2CYq823d+G+e9UHoIVPYBf4/I3zBDMvS4pTZdF54A/GQHzJugttSiZvA8EP37VP
R8lu64RqOzc68q0OJB5FPL4LuWG8mNgg41bwXcdKNXwnHZyr2SHM8auCn2czRkAx
KFgwEAHvLSq5bbcb9PQOTED2dyBaG4wMmtfbmM2sElb7P8Nu/xFeoziJcxUDox5V
yIwuXuynq5ehhpA+wrhUhrtEejyfGw==
=Arpb
-----END PGP SIGNATURE-----

--DzcjpOFCm2JhpXty--
