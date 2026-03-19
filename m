Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B233729B781;
	Thu, 19 Mar 2026 11:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773920781; cv=none; b=Ov9rIT/7CABeR9dmbY9Bn5uv0TbcUY5S2TDAYP8J90tjr5IFk8pMJHMemkzbdZFNOvDt1mOvs77Nw6DQJQjq3vIApuu2r2l89/mwP8IKGnO4xEgK9HhMOdmtrGYpzcWAD1JUvnVNPsEGFP2QbQDVhTJLUiZ1iS5GAaOY4eXoHwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773920781; c=relaxed/simple;
	bh=vZ5UBILwN8dBnboImtLXk+RobTLy+VmfD8DSAK+0y5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbLz5N/WIasxQpLTwW0p+G5YXJtQOefWWthAj1DPr48fTYqHLwgyKw639NSj2toMXNw3glF+33mdoQRGLgSqydQ7NLxUnNdrcbQHChCjSuIbxGDQDQdt6+BNcM8398qpUg2k5YcY2mBHpZPwPfVgU1xJhQyKLitsdlqqYNDMpzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRty2Sbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRty2Sbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2A2C19424;
	Thu, 19 Mar 2026 11:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773920781;
	bh=vZ5UBILwN8dBnboImtLXk+RobTLy+VmfD8DSAK+0y5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QRty2SbgZ6fDHBiRyPMNnud+6Jda20oktl0Ul/fqJOKlt4z2SkNm5nX7I9tBClvpW
	 Xyuqo5kFgWEq7/ZeqJi7L1poXTgkS1Q+KMJWBeK1NTYJzalrNfyD2GSEI1gQ1+TjcE
	 qRZIiL+ASg/2Zr8Uyocl83eO4x5+wFlVp1lqMiHj12zH0N1yV0oh1F8x6hikt9rP63
	 fsh44qSQALbrJ4iwLAlDzwpD+wzK1ra7/unqyujLb4JOi+UnwGq2809DWfh1qieLAv
	 1law6lWYdV+XVlWtLTyIfsOPNM8AJibAHBHlG0z0JfAHUrvMPK6D4Iqq6G6r8FJqZq
	 nqd6Ng6wUORcg==
Date: Thu, 19 Mar 2026 11:46:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
Message-ID: <9f7e4bd1-ec3d-4181-a677-156e6f58e537@sirena.org.uk>
References: <20260318122547.233850204@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AcV0a+jQxcwwIzRW"
Content-Disposition: inline
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>
X-Cookie: Given my druthers, I'd druther not.


--AcV0a+jQxcwwIzRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 18, 2026 at 01:28:05PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--AcV0a+jQxcwwIzRW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmm74gYACgkQJNaLcl1U
h9C81Af8DDzXURzj3oKTVXr/egFse/wOAvaM6DORM0VpMYTYLLYf5ovymlEpvPU5
9JzFHf0G+MDiQMLfdFq72Dx11AnHx64/MeMX2SFe6N4r3Kxkmb6V/ad6k/nvSUk0
aj39ointDX9ZE6VwMqnO+Sd1N2OTVs+L5BecW+BKm/tZrXRT74TX/i25AGPD8kWE
JOj6zw+bIqhoTTQaWOY0LjUYQMUrhC1Ixoq9QSu7DShlk+rtbj++sUnhJm7tgCFx
cn/xHEOIsxomdv2ao+b1NdE+uiIpvoBYbHGd6pkBdvFU6ROVr+2kpZixREb3pT0N
cRcVBp+sefOt54hZMoVe0kT+hY0MKA==
=9lnx
-----END PGP SIGNATURE-----

--AcV0a+jQxcwwIzRW--
