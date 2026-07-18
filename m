Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69AC3890EA;
	Sat, 18 Jul 2026 12:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784379482; cv=none; b=Y59SooeWJtEQcUnhLDzIdzzSvN0MJqCsXyOqrKzRes85e6YfSY5d20NwLZ1fNLBfdSvQEvZzsu7kbDHzQURlCyb+AWxWME5O5su/hemAJ93H4Mdp65ITl0rcKR1lU41jmC6zBCPW3hvOHIRH8JpY8muLDM1BnnF+lBMVlfPR6IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784379482; c=relaxed/simple;
	bh=UB/7McSPCPjh5IUfBhgOmiMVh7eoxJ399uh1mbMPB7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chgW5VfyY5xpXxnsLRrNuhmDe9aj8SJENIzYUCS3jzf9HYwRi+Qapi7cE+nwdUTRorx8M0EWYmjtU5ZJ3/k3UhDoFbld9p66C/YEErqDOHv/OOBL4C+rDYuRdwbSbSWFQrvEieI5hKH4wDrqdgoDcvtEkt2MSOnxpp63aQh/40I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6f/+eom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6f/+eom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53F91F000E9;
	Sat, 18 Jul 2026 12:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784379480;
	bh=CZtr4uTBAEC7DbIIjftgw1Z+2yPZ1qE3AAouNb9PB/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P6f/+eomNr5126ArW+rZC3f3mEHn4fnmMzg6UEA3m6aTWtkNZJ6OgN0Eyhgyhvdoa
	 XaPI05W7/kEDKYGAWm+UP7rQ8RHHl9DYq+iQRZWtUO9NdekZjsVEdpnxvgVgpeFx8Q
	 EXlMUmNhi1Ch7oqHFbOL/28V9mcz8WGBMNib7XqH5Hh1zEYRR5W/O6pQWzS+OD9q7+
	 K7reUuXV77PTzJC/7mN7Kw4oSgy4ZRURlRYaduuD8RQ581umsxlaDmO5LtKtNg7U/8
	 +NXfg7Lsk0z+LqTDrri0MZ/xBHnQKT9O7ce++x39cnETIVJMh33O9oIJ0Eq6fPRKUE
	 iP6FtBjZP9sRQ==
Date: Sat, 18 Jul 2026 13:57:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/495] 6.18.39-rc2 review
Message-ID: <21bbda16-4cce-4339-a640-d70cd159912f@sirena.org.uk>
References: <20260717101904.922623678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ncehjXiRqtBxAu5e"
Content-Disposition: inline
In-Reply-To: <20260717101904.922623678@linuxfoundation.org>
X-Cookie: Do not pick the flowers.


--ncehjXiRqtBxAu5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 17, 2026 at 12:41:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.39 release.
> There are 495 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ncehjXiRqtBxAu5e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpbeFEACgkQJNaLcl1U
h9AV6Af/Tlk3MXl477G17bBReciPu66i6Nw0xV/A7OKB12pj3PCpIcqXGIMe7ler
0odsCSyPZayJ7NGOkndOJ9QgECEpH5HnvT+dtx6Fd08Ha1ixts1UZwzsLy5PT81U
3pMnoqobeDbkXPFSKqmLvMyAKNXQV3QztZdohXNtP5Px2c52sukAqUBCWiDVVzZv
jMLOM/dfe0miGl8+pyF7avB++vserIbBORQI26gIgNnVZk9gOORM95iIg8pJkpea
364qc7EF5M9d3tiIiziUiy93kGV+PNHWhFyaEEWG2OnS+budovhs7oQ/Uj3Z2Tns
5YpWlxeL/NNIUxV0R7KGR6X1fa9ncQ==
=KLzg
-----END PGP SIGNATURE-----

--ncehjXiRqtBxAu5e--
