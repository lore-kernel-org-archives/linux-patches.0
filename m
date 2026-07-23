Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8781480352;
	Thu, 23 Jul 2026 12:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808226; cv=none; b=JzAliju9ex32vY0SrntdmAVy2ITONLehfgfkKlZrmWPYELmlm0+RkpR1hzzsyYQB2Ltu5BK6ye+rfHqmx9/pSvysuCNri0LuJKGJ48Izq1GxX8C3NN/JOI73+ild7SD3J6V5JLmArQdkLntF2v603gX2RDEGWdYfWIVsgx7ZdnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808226; c=relaxed/simple;
	bh=sid6/SwcAs8d2f5hc68X+6XSQh5vU7grBBcBlQILFhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gV/jUzFehNu7/Me2+AgA8DS60FVBs+10QcZDFRFFAIUBN2GCc2Hoky36mVbikqeZtsEv5+Y2kYmmYNWwIKHE7Ca/eJqHzwL9wdNw24YoqNQJ/edCRAr9Tjmq+Qt8A9F22arvE8LjQCAywSCw0Qk3HT/yu6DMO3E++PT2x3fg2qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3381F000E9;
	Thu, 23 Jul 2026 12:03:30 +0000 (UTC)
Date: Thu, 23 Jul 2026 13:03:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
Message-ID: <87952906-455d-411c-ab6d-3dd836009b57@sirena.org.uk>
References: <20260722142947.085426486@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Lq6ebYIDznp8Bugx"
Content-Disposition: inline
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
X-Cookie: (null cookie


--Lq6ebYIDznp8Bugx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 22, 2026 at 04:32:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2079 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Lq6ebYIDznp8Bugx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpiAv4ACgkQJNaLcl1U
h9A1jgf+MvItRMCKgskW3WfOpYI9YRjwvJ0ehqwK8SpHm2qYNc2PBB9J/vqa0Mp3
WuW6Hwv/gu4VLz7enwaXONk3Re9ut1uF+7NE+W/WDZf0BU2SU3rQVlBD9rO4cgnN
yKIvu2/5M3xng9q3QMxq1w26nAq/GmcrA1+YPCojUbTD+YTbftVdo7qfWmxi6hrL
hQ9XM0EbAdRVgCSsymZXQhrvrw/0A4g1JvD6Bb+5y5UlvgvHzrtDMdXnOC3cLkvE
UyvcK/QF71+cDyQCTn1Z50qhdtVGfMwZl7ZY/seLLOOZRu+i0hSGUnu19f2cm3xs
GTqMfiNfkW5tLTDQKikLS4u415AIwQ==
=fO+t
-----END PGP SIGNATURE-----

--Lq6ebYIDznp8Bugx--
