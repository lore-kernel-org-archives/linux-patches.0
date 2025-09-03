Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A7730F528;
	Wed,  3 Sep 2025 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756908182; cv=none; b=COZ/6ikU2IHLBTvcqzyc8JZwMQ8qywWLr8JLiJub2ysHYM6McLFGIqqiI2mqiQh/MGjK/c85Bp8wm5PFO+nbQrF7ckYXvLo2Vcyy1Jo4Rb2G+FOJ12dsi1MXRvDvzbUE5nJIWpvM5dn4krb6FxUyFg1M7uQfceyJNR7U/h9ESoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756908182; c=relaxed/simple;
	bh=Ov0nrLS0OcqS08nKtyCJQ1I/kTUYHcBS1+Kn1Ozmnm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfHmrWO5IIhZ1X/fgNObyv4o4kQ6ygvDMdo++Zycp2eeJkC8ysGM0H/Etta0CNOHCcLShmVsWv5ZObsiHWYCNl53Z3GOuA1+5wfpWQazH12SUsP7RJDN7wHPEHQasYOWcw1vCSSxX6mkMTVJtQGXlRaFGel7YgkX/H0Ls4KXonU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPnNxN0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPnNxN0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4726C4CEF4;
	Wed,  3 Sep 2025 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756908182;
	bh=Ov0nrLS0OcqS08nKtyCJQ1I/kTUYHcBS1+Kn1Ozmnm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gPnNxN0tvRwtsH54UILMJxtCL2STueLpueR/0TF9tBN2BeGe87K2BJtUJSuPc716t
	 fZcYOsweEHEjjqZ3Ap4QsnJ8zE6OloG2s+zlQwfG150EI/u/PCPeKK5y8XxAxgOpG7
	 zKIRl2KZxWwgp/h2B6+MUjt5Z0IDcqPxnlmKwxE0MsLHvCxkGfGR7cRjm8/Dk1wXws
	 UNkYN5g7sFv7soEHKRr6tAN3vGWA8TK4H4Y1UrZ9hMYkP1cMLz0WN6XEhmsUEB/X6Y
	 6KPALCBb0wLYa2lCXEZ3iLGxwyG4JJJHqBWMVs0NHkRfw3rCMZu0I52BKLY1Ov+jic
	 YzeHb2gHzKg2Q==
Date: Wed, 3 Sep 2025 15:02:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.1 00/50] 6.1.150-rc1 review
Message-ID: <fad77ca3-95b3-45b9-ba05-21e3dfef83c4@sirena.org.uk>
References: <20250902131930.509077918@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mYdIpcyd60mfR52A"
Content-Disposition: inline
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
X-Cookie: You were s'posed to laugh!


--mYdIpcyd60mfR52A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 02, 2025 at 03:20:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.150 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--mYdIpcyd60mfR52A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi4So8ACgkQJNaLcl1U
h9CU3wf+JXw/Vv4VG9kabz/uHsyI6KKsiGmZLxr1VY9XNcwK7+XCgt/H2YPCdfVD
WONLTNYH0Q2L+7c02vJINchmi4Uok/3LZsxNR9qRdi7qYPSPyougSFSm0202oaz9
9D5/ZExLGKtfqfQ8EQZNnMKLU7jwlYZjcRbnGeVySR7Le99OlVC3uVzbkG0NmMR6
8HoiWCe33bIw9fCSJ8Q6mPOLf8nbQ6reJRu1QwZaRXtlEmfXLqVp0Zw4QR3hYbXE
VorGqbaQsG9mxwfQZsx8iwAY97qRtF6hWLcOQDkqNaj4Gb/3f9aBpIZhzJ1ZHSO0
JAMZtqYmlv1dT7m/QYAvVd73KZW0dw==
=bSEG
-----END PGP SIGNATURE-----

--mYdIpcyd60mfR52A--
