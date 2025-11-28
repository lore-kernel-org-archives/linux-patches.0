Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF3A2080C8;
	Fri, 28 Nov 2025 19:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764358177; cv=none; b=pjg8UWzR6f+Qqp5AfEvBeGlAYjsQrJeXcmDKp07jQqXWyqFSKlrwGTlFrPj/b+Z4LUUq+ZJX4BVmXzL5uzHZpa65fy87MzZzVZOLEZNtgImu2mAVFk78qrEEoS4Uu/xbyG3t5OLBi/vITyd0NZzHZ+44IuIyZIpulCnpu64m1Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764358177; c=relaxed/simple;
	bh=TvUgqyef1EG78HEX2NXFvJNwqFN/Fi+A7Vo0aEsybd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tj85OBNO+SbQJAaBYoBFHC71Ux0d2T4TkuV9U7UoRr6jv/qNGlojC2dD9Octzb0ANqft9TXzy+8DmHzX+l86OWuv7Z9+ULt1XdzvJsHMvAdcTnCf5RPsiGLnqhfqikUbaod6GPecleM1B+8WnrWVcxh8lPMFREuC5GO1TCPqQvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sU584lh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sU584lh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50111C4CEF1;
	Fri, 28 Nov 2025 19:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764358177;
	bh=TvUgqyef1EG78HEX2NXFvJNwqFN/Fi+A7Vo0aEsybd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sU584lh1TuC0DgSLusN9hTTkcOPvlXwOT4h9SWrV0RPrtjHlHZ6TH3N0WV3idaQJi
	 XXnj1EYJCEHZ19lS3nQJHQk/s+oUp7sPHBqwy+vDdMJr9jAPsHoh0eehHiRH/3GuqE
	 6GlbCqJIkTvIPX3NPM1pf0Bg2TibF1kWNTopxrVC24QyY6oOrKcHJZi+g7bLNAFMci
	 4BFe3ZZ37HvohvYQmJivck20EOgRpL0UUVR8mI1t1BiYLR2AYnwjLOzgafzed6e6wG
	 W/ozWoW+j8vsxGU7085ubDa1ivgFW+d3Jssh8eBLmiSLZFzvMVL+RH4/xOyDW44gCS
	 y/Ol+CFrKHGiQ==
Date: Fri, 28 Nov 2025 19:29:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/176] 6.17.10-rc2 review
Message-ID: <c476235f-557a-4757-87c0-b2a46c324110@sirena.org.uk>
References: <20251127150348.216197881@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="At8R1oUeOqR0MP+C"
Content-Disposition: inline
In-Reply-To: <20251127150348.216197881@linuxfoundation.org>
X-Cookie: From concentrate.


--At8R1oUeOqR0MP+C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2025 at 04:04:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.10 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--At8R1oUeOqR0MP+C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkp+BkACgkQJNaLcl1U
h9CVOgf/YF6unIDcCKQ/9dHqr9WF3/QOgY9nk7HpLAkKHe2G3jJIwuf3LOm13XSE
L0U6SU7UYxMXZazID4ioRjwq5BCWLig7b+cOcAeNlisLg3+CfqFmNUZ8gUTEXVUw
VGnbeNmvg9ICoVHXheMe3mLUGRTXV+Lk/LlHWchHuzbBrophKYkCI0TJL98TdHux
HcFfZPQMANU4a4UAM0PgSiTmUoFj9/BjQf3tVlTwfaYqh/ALtZn4DKqueAcZhZUU
ZiXzPwBoWM1bdaCoL9FpwmYi5XF6bxDmEMSQx+XlmwRy/WvobGbRYp5MQCIso2xE
u9SLjpQxKFtoizQi0jZsbkoR9TGHJw==
=CL19
-----END PGP SIGNATURE-----

--At8R1oUeOqR0MP+C--
