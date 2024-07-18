Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C570138490;
	Thu, 18 Jul 2024 11:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721301577; cv=none; b=oMn52+U5tQFztzb5YPqIPVJVWCJJsouwp/tc9SccGrRXzu/9iRitx9v1ek8nOXwu768M/Cr9Up7laum4W5r8LAMXQP/bW11GixcV0cMocGBZ45ZqY8R0EhJQhnhvmNRUD2Y7eDiR9zqY1Wr56DbcCM5QIzSOrN5m1CfAbeoyTKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721301577; c=relaxed/simple;
	bh=5ZS2bRAKZLxoBsfHc6SxW8krc/3kNApEhtyZJg8XVNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=acweDE/1Gn75s+Z2b4KyMNwi6+kEF9tGN/WDYeOdOjoTGORtXi9cSJPsDdoLZ6bhT/AHGT+jtL2zRXCzBAEhDUapiAdY2WlRXjDcvB2Sqdr7sH9OnLjdWJrkxm0cqcZ0l6QCTAG1d/DF2yAtbMfRCyVwADfOpw2Ztz2RxZ+SQBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvpoIjzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvpoIjzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815A2C4AF11;
	Thu, 18 Jul 2024 11:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721301577;
	bh=5ZS2bRAKZLxoBsfHc6SxW8krc/3kNApEhtyZJg8XVNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hvpoIjzw30Dl+QTifO/P8Vo5uF1HOGt0sQI+vryqWAhBIKM0V0GEmtQFfiaFJ+HUh
	 IR68P0EWFFCISJjqRSXM+ySHixpQda5hzw5LbjZqGpQJOvN++mWZp8BRQ44nZKwTK1
	 iQwjsFpfF7TSpzR7cFhQP0AvF/SWAdKELUOomDsWGK5RDmB5il0COUNRZDWNDoEbrk
	 8dfsVITRHQ2jxDVHRmJ8AxwdSefqXM2j2BEQZGRQoNrOzk46QPNd3V48P1jICTCfNH
	 l5T+DBVUQxbpNiKcMWLmaSkDUEYXhHUz98Ly/n9ihFZrEs4wz1AMs0UFLAP8KhvZJ8
	 tRglhFMBjN/FQ==
Date: Thu, 18 Jul 2024 12:19:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/109] 5.10.222-rc2 review
Message-ID: <5bd9ca42-5f56-4e88-bc35-a5a835bbfc70@sirena.org.uk>
References: <20240717063758.061781150@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/UjkfDHKOqeJeWLR"
Content-Disposition: inline
In-Reply-To: <20240717063758.061781150@linuxfoundation.org>
X-Cookie: For off-road use only.


--/UjkfDHKOqeJeWLR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 17, 2024 at 08:39:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.222 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--/UjkfDHKOqeJeWLR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaY+kIACgkQJNaLcl1U
h9CQQQf/dlf5gSaLrYkI52H91RrOJvYSdx3CnDZLKJbkA5VMWK0WQ/hRoo3wvtXg
ezMQmp8RKlXlVHkizcwz06ObZ5NY6Mo/XYXjbbCpDhsgEsLiDtoxvDlp0/FLE7kl
icwei/HY1N17EaxbUW6JPDiXN3UFt37aSxew3vrHVe+vjxLqEqah4hDOTVbFfAqC
4dBSwX9bUlJO4L5VrS98c1RU0r/GDuIs3qIMrmNhFvxM5+91SDyCKMGS6lUbKCXJ
ADTVMWbMoYY3maWIYtqDmJTzA9nYrq0BluFTKkFhAwLuLuEvHsnN5uPcT86MaS1K
m/ePH6+2lvbyXsRv19TSEcokpl+AtA==
=LD2U
-----END PGP SIGNATURE-----

--/UjkfDHKOqeJeWLR--
