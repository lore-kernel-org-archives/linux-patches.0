Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EF1BA45;
	Tue, 10 Sep 2024 22:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005733; cv=none; b=pK89tQC1pgaMemobblpOrrEO2vfG7PROBUls13T80fPelzH2S9DWEHT7DrrJ8WW2I+tLlVuaU1OszmSKaCvKjyBzN/Y7sM9J4UzGzenS+UJTlLa2hWlM+1VTVs+TgyA4Ustn/S850Ah4RRM+VveiSbvPRIsYE75XW+V2N7p1OPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005733; c=relaxed/simple;
	bh=rH7JKM6xlZlJRPrghli2tq76D2vI+Y3vI2C7dbiwE6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rs09ZU1yJad3mDKkWcMQVdPcnjdhGyWQH/TRnrJpKEibPfc40a5SUOks9fEwXYG+Meh52ra5a1U92FTpJ78BYV9JEsRrrviId6eZKZxu3JNoatFrf6XMXQc53eOMuj+5S3ILNPMQM7yZXtlQTYkWD2Ux/Alw2LUHj1YQsxITrAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sidQ5dAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sidQ5dAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE3EC4CEC3;
	Tue, 10 Sep 2024 22:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726005732;
	bh=rH7JKM6xlZlJRPrghli2tq76D2vI+Y3vI2C7dbiwE6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sidQ5dAhTElsycMmjXxbmmxdp74qvR85LTSJhKLiudpFKT91J0uC3Lu2qI08SwZUR
	 89pWDtXEFV4xyLpXIANiwIYPLtwL7nV4+oWD+eYiws27sWtp9jYgio43Py6tNL6sMu
	 7OoM9laAY0I9yv2CDKT1g4SL9oNrwBiPezICb8Fh5LcOhSjkovC8B2ovDeKoAGs514
	 mwpk8ehljDBslqDfoZe0wuz9b/N9D32q6GUHUOvxi8Ex5ayxOTcZOfONtDOB0hTHe4
	 LlC9q4dlo9LFE7wu905HE/Rvo8JdQ8nWE1c4o2i8w6Q/wPEGrkxC1gXQBFrCCHXl4X
	 kkq4czf+JUUpQ==
Date: Tue, 10 Sep 2024 23:02:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 000/375] 6.10.10-rc1 review
Message-ID: <41255668-4247-4fdc-ab06-2a5f93b794ba@sirena.org.uk>
References: <20240910092622.245959861@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MKYOXEFr2kRTGknM"
Content-Disposition: inline
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
X-Cookie: You're not Dave.  Who are you?


--MKYOXEFr2kRTGknM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2024 at 11:26:37AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.10 release.
> There are 375 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--MKYOXEFr2kRTGknM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbgwd0ACgkQJNaLcl1U
h9CUVQf4m0kF83o1shzi0Kvqb6PhkFycVcKmzkbt9fbRaGfalb6meu/bAWsbnbV1
WNwUFIYo9dJW1AqsOBonOz+/7lRsEZTyD2Pw1CTcI5DsKjOb8ARGJbHVz3BIk58Y
7LbheR6whzic6szk3zGZS1pEgarjq4zZ4DC3ixHTdyM3NT8Nb632B0SGld7b7C5L
oRv36ZRcj4BPXOeAqQK6ObER/z5ILG96tAgX/TF58abc++SqpyqsavcvCzeMDFDq
pOMS2DqxbCRJe06g5rileAQ+x0AWu8EUq5npEBwan8VP2paV0zzLX8YSYLvsPWlL
E+bVnAvOcdN+M25JxnqlbTZXZrlI
=QQ3D
-----END PGP SIGNATURE-----

--MKYOXEFr2kRTGknM--
