Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D963C73D7;
	Fri, 13 Mar 2026 16:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773420060; cv=none; b=ERs0o4ABsRR3OPHK/NzMB5+gN9bPszvQYoTQWlqvhurI+uVRho3tfbD5Fb0op/eAtlKak4VQXKgHM4BzKBIIV9dIkoy915tcGDV3P//TG8ukGExzsTX+cGm2uVGGdxXlDrLYhARtnX6cr2SZ+sGEFEXqU+7n1VzYuC+rZW5AX2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773420060; c=relaxed/simple;
	bh=uUJT5S/wnOF5iVsrEtl5WrHPGTZVElYrlF9m042sl0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHTS5i3W98X538KjONi12+rQmsUbNjVLAzrx6xxNGSsN1X8vvSg8xeE1jxnfyxd3h5czK4bWMcKAn8ruzhkpuB15zwUrxRUDgP6DoUq3/b14xqQ8Cv1YdFb8GbJHBc5ja5cG+z098cUd26/IAZnUgck6o6uB9DaAnXPSgx4AhXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BaZXyfgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BaZXyfgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44540C19421;
	Fri, 13 Mar 2026 16:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773420059;
	bh=uUJT5S/wnOF5iVsrEtl5WrHPGTZVElYrlF9m042sl0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BaZXyfgKfp5qz6EtnRuJLi3xzzQsWMMT4+kgrL7Izc9jVwj86oqn4W6y7daM0EHOD
	 NgU1TRlfVE/RxK9QTSroKfh7CoiBMUwFkSKp82PcIcwZIKpwWyN/WRoQJSJY6boKhE
	 AYS6AuQhbn3YKjvBsh3e937oledJ07lvRbpxkCDIiSE/0WnHlBeOvsL5rQnLBycKYv
	 4MsRXRIpxGwueww/9Kwpu/wIzmFyPYj0RfQ5U9JkCWTVGT9BtFU2OuVQ+h29vCWtud
	 WRUvp8VF8JgjCUuxEAcFkFRGBL4/d9WEGJpOtV8vMdKQggDE/LVi2kmkmGRHodSe2a
	 unvFGRdZ8qAyA==
Date: Fri, 13 Mar 2026 16:40:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/13] 6.18.18-rc1 review
Message-ID: <ac8b0505-bd16-4d26-9079-ec179f7b8b6b@sirena.org.uk>
References: <20260312200326.246396673@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4kDf5LN62NAtP7FV"
Content-Disposition: inline
In-Reply-To: <20260312200326.246396673@linuxfoundation.org>
X-Cookie: Monitor not included.


--4kDf5LN62NAtP7FV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 12, 2026 at 09:03:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.18 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Reviewed-by: Mark Brown <broonie@kernel.org>

--4kDf5LN62NAtP7FV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmm0PhQACgkQJNaLcl1U
h9D32Qf/cN6WEHCyxgW9OktNbHtXNvhq1RyqT1iz3o/eUmwsbr6xrTZnUjlAXLux
+znrMO1kB1oW4hQ0TwmWSA0hON8/88nGNypd6aQPTUzcrLB2u9qWNPm4xAQ2A9NV
XhI7kFiyIgPWxucf/9xXbPBErMFajncEJbTcB7K51dyi9w8tBnKQbYZNz1rPj4fO
lqOsVkEKNSVhji+IO1nMiQ+/Qa2Lurka3P4/IA/vrRph/c4tHrCUYPl+6nUPotHv
BAt89/jsm31RJ7jj1hJmlitpQ2FpUggu1ZyVCr+EiEljLzdn3ojXDUzmOO/eh2lD
kInJ38mS+TJUR0qPBPBw2hgpqN3I9g==
=39wB
-----END PGP SIGNATURE-----

--4kDf5LN62NAtP7FV--
