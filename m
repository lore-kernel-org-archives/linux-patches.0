Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82D5282F05;
	Fri,  3 Jul 2026 13:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783086709; cv=none; b=daaqTmn3Kl3i5E3G1XpDWbbmGjCV9EWoxFzR9KG772ynga8ntt5YWEC4JkcfigOJH0FqUssvLf3saM9meLdcB/oznwib6bTRE1IHc1YJqNU9lUpEyDuT6MMrtRAI/txcdAa7jaoYSaxk0z6tMRrdAKEZY8pi7kMjdzg+aTeQMBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783086709; c=relaxed/simple;
	bh=19WJ9HODZLJv8Lesukqg37SBrsR/D2pzE8nDAgcn6XE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VBUudPxhWLIa28Vv+DjfYPmdFZe0zNQGyakIOSkOjg4D3Demiz3Th6D3eQpcAGxa52KfXULVQO0Ia8/gMbnUfYSjFE09MQq8wvv4+RkzNaJkMiFXCBHeg1dJHxmLpEQ0GXq3cWCV0Znjq5Ah5MTq8FFOlmDKuppQoPgdlU44ZZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hK8erk0H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hK8erk0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3352D1F000E9;
	Fri,  3 Jul 2026 13:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783086708;
	bh=CiVzOy58l8HEeC0f9um7FAFU29Yvpj89dJm+vd6iccM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hK8erk0Hoc93ueRqlDqgn3E7NUHIPm498sY77vEP+rYQz/OpyXCyXgF8R2xycuiGX
	 6aTndm73x8AQ2hhq1FcV9U1xM/Mb4yE34G8cjcsxOW225oeDqDlRC52sMDnz9jJSJ5
	 /EmYqyYZ2EAceVw7B1pud+CzdXmquJKI6TiBaYpdCJ6Z2mppL6iuXECctGpXJzvqet
	 bBzXqRAKW+edEOh1ibVaIu19hRpZO5eKtM9wD4wC72Ps7uQ5ui/AD9iO99Hs1VOmNI
	 EaWt0thSd0Ke/OPSNtH1F9SOk7axq832E8eVpwt+XaiiDwctvnHdbz6CVsbXypNWr4
	 hrED/+otWAJ9g==
Date: Fri, 3 Jul 2026 14:51:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/129] 6.1.177-rc1 review
Message-ID: <e7874ab9-ed1c-4413-a9e7-72f34bf3351b@sirena.org.uk>
References: <20260702155112.163984240@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="//BaLQY0hVQ7IdcP"
Content-Disposition: inline
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
X-Cookie: Another megabytes the dust.


--//BaLQY0hVQ7IdcP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 02, 2026 at 06:18:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.177 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--//BaLQY0hVQ7IdcP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpHvm0ACgkQJNaLcl1U
h9AtRgf/QJeKNmHj6UzPtnq9laXfFbbTHrfV5g1W1nkManrVgJ+it8YaXj1tImzy
npHfbIbDtRyMpDvvDdAjqQLy0nVEavwbz/TqJAQwu7JiOSPjdluWFzDpAJLA3ie8
zknkuOVfKZhvcpQFMRg/GgCVjZzDoe0AgI1yn15GmgQ919C4ZpGFH+SeifkBKhdp
AUx+tLgLfvv38N62TAzHWycRypF+RggfZCE6NW8kxksyIiC81JW0/zoUKI93F8MU
mPa1C2PABEdQ+yHTS1bycbKuVzlhbnfGnUCQTY1Hr6bHVtTkfWqBApnQl+cK1sln
hBNwmzFBhcH5lJPv//NLTo+LZJdOBA==
=9Pc0
-----END PGP SIGNATURE-----

--//BaLQY0hVQ7IdcP--
