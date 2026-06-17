Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F100425CEE;
	Wed, 17 Jun 2026 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781705813; cv=none; b=aGZvw24/ccQOPEeo7HzxERIK7duL7UIZV4LPgEhodLxE/LxUjJqBv5ErP0qwS9+ki29BTIoSr0Vu9oqCIUOJJJaqcCIeTJzRRII7GuHRw2KSbxpAGvRiNShZvZGHe4vjZcPjtXzwWrhe7SlOM4hkdlY+XZzETiHa7JxTTWUQ9pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781705813; c=relaxed/simple;
	bh=KPG2Y9xOw1zRRbWAtaFCb6Z3YLjyKbt67tKkxtiydVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpr+Ck17pRDyiBrWjcude0jaQbPeB0OUi67/bze2xkSfzD419WlnA8Tnx1UEuIV4r71kzyxAv5AEBgP2VEi6jMQ/gc2zeIPbZRZyGgrmVYJa1ouSc3j7JiH9Jtv13o1O3tFOb7+F0eXONWRYlT23Esr+iKNAEl7QcGuXeSeY40c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YloN0bly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YloN0bly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302851F000E9;
	Wed, 17 Jun 2026 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781705810;
	bh=0zM0ITwaIN02e0GWwNW35aMpNZG3sOdKr0TIDVdxl7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YloN0bly7yOvQ+pJCPkE0hZq7NTkyrHSS5fFahdI2CDF6ukZ3QoWBxU7EQzFb43l3
	 Qf5tEzW0pnTXTb0m5rGJ/VbNn6mICLuLYt5Q2YLtWAmG3KT0dQ8w/EkWTpJE88ScoW
	 O6LANd5yA/RVnA5lZ6I+ix6Gt7AnNACb0MbhgbtnMgGtLnionMaf5gh97Eynrg3Cvv
	 zcwgQDw5KMOCfU+wdvrcsX7c0tiyJbvXcMr2+7g25EDSjhn82TQT1ylDtVAT/YZvfW
	 +ao1bY7VKCIhkAtkj7Sk9X6oJX8+NEueIShEGkBfVfDszhluTrxM5TU7HRh+qEEMsN
	 fEH7JbjQs+F6g==
Date: Wed, 17 Jun 2026 15:16:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
Message-ID: <95d1b936-8615-4b00-8bc3-264a99b46583@sirena.org.uk>
References: <20260616145044.869532709@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mbGFPls/A79Yn9sJ"
Content-Disposition: inline
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
X-Cookie: Absence makes the heart go wander.


--mbGFPls/A79Yn9sJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 16, 2026 at 08:27:18PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--mbGFPls/A79Yn9sJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoyrEsACgkQJNaLcl1U
h9DqwQgAg98nI1Lo8eUk0bRp3VjsELm3z8pE0dIVq53L4Pr8e/bjRoaquTLQFvjS
d6IkF4djEcb0+JRYOPd3CYGcR/9pXE66HdWhtsWLygtHnqT0XTc6CVHWW89Kq24F
tkv7UwVqYogLbhwaJW5zJsI0Dx+bQ7eHLmZhJJ4iJoARLI7HWYBAMXqyK8adnoTA
mLqSdQ7MPJW3fkrNkHlhZoxq3yE+oqVKnfmw85UMFdB03oZBi0r4gRmg5doNx+YE
hvqSb0FzB7Ffv7oAj2aC6M3/KljMS3YRCwleN+KiJP4eD8pl8k11ELdy2iwCQb1N
gdfTpVwcNKzwcQ3cDe0GICFbXFFHlw==
=JtfK
-----END PGP SIGNATURE-----

--mbGFPls/A79Yn9sJ--
