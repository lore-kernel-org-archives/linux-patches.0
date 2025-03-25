Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE23E18DB03;
	Tue, 25 Mar 2025 18:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742927500; cv=none; b=YrM9LxqpunLlRcXWaY1ZVTPL8ukKdcEasHzqyKP0ecYgOgzeXzSpVQgmuIuetcKc8Lpn0KAJoT2BVKlZviTEJw27RQ4TKZATiG/n2Hr6xqhyB2GvgDYUfj8WsvtvY7k5uLYbuHDhvdc3rK1UqoRlq3iy22ml40Ov/wk3S7zhUko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742927500; c=relaxed/simple;
	bh=hg1fdxYDMaiT6j6hasmowcLVVYiz6dtb8ZI3gifIq8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwWOGKZf+XsRcGDd+r7XGN+VgQ13nYKAWsWLij8CmrkomJ9MfYxqSbNr2n4JUbD50ExxT9bRgHWGTA6Hb4ttX+FWm4wepB51QUQvnhML2YCxHu35t+E7E3ZuQsa8GaMqpm2HtUQPPBTBGBkuN+5a807Six0KCBcKTJU3FB0M2KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCgWJPNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCgWJPNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D15C4CEEE;
	Tue, 25 Mar 2025 18:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742927500;
	bh=hg1fdxYDMaiT6j6hasmowcLVVYiz6dtb8ZI3gifIq8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UCgWJPNYLk9mJvwr1KoLcDJaK+y/dBWWasHDkjikrqjS4AO+MgXeDfY8T4aBnf9sJ
	 sMFVAIij5WW8mbqltDZG5OkchY6JSCvVvUBMBxdAjbsonzj1T8KxWm+4pNnWKtglkP
	 oF41MGslmmO+1ZFGf0qAMTAtGMSZb33RibhnY/fpn5aj/0MuS2PpKsoQsxZmzBV+dO
	 kvjVAAa+OcvjNcKcRf6fsj/g8DghslQqIG/+xJEIZrE8gzc/cGhrsDjshM7Slrz8Mw
	 UwIkqw4xwf6CtmMwlVM0T9NukQ6MSgpA9melPWq3lwjJLM6BXAdWCm4IafzGt6OlPY
	 GgnO8IIzphi9A==
Date: Tue, 25 Mar 2025 18:31:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/119] 6.13.9-rc1 review
Message-ID: <a426fdc0-db9f-4e74-8a9d-eeb0e72ca612@sirena.org.uk>
References: <20250325122149.058346343@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2sESF1WCZubYJ8PA"
Content-Disposition: inline
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
X-Cookie: Visit beautiful Vergas, Minnesota.


--2sESF1WCZubYJ8PA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 25, 2025 at 08:20:58AM -0400, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.9 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--2sESF1WCZubYJ8PA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfi9oUACgkQJNaLcl1U
h9AbXAf/TcSVwDmFAW95rr4Z3RzLlnWNTE1QS/9z49eF8vmL9HUdr9Sqrew23sLE
Vs1klc4GRKQm4V35Njrdz1FjAmbiHJjMIgWmpdys10i7DTwUhhTO/L7svnJMLfeV
L0PydC5K61DaeWT2IHO1dq2jHqFjx4utrdHn17f6VGZv1AsDe16N7JQJoWdix22x
FGx4kDb3ubk3hLd/gy32y6a6ptLIdLBU06YbpeHUxXjJfCL/lPCtyAoT7Zme7EpK
k+frlLs0rvTSmsQmSOCXSgE67oUcufI7tPhOgXjw+sYzy46HbD2DqO7gzT1BrhhB
+HDlakzeMA9mL/xXehaGiLN/Qs28Ag==
=Bhsb
-----END PGP SIGNATURE-----

--2sESF1WCZubYJ8PA--
