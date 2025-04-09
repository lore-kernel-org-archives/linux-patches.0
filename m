Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027001D5ADE;
	Wed,  9 Apr 2025 20:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744229665; cv=none; b=G5yXrFklpIwEYpU1hfo3DjtkFhQyk3PLDjjdIHAfq4cEFIDiH/bmgBgcNEUlN6n/v2hOYR8a4cajh7VgTmOFikjyj1B3eO2TuFCo/WLXr0urJjNIW1utA5R3rrPupWCcmmjGphlObMinLL7nLA6bP0XZQG4iicll7Js/z47tsmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744229665; c=relaxed/simple;
	bh=xslxFfMAcFFbtaqQ4odIfwL0rQVB+kqWwiWJmatKv/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b51f6NOxV/8ILYZbZBjpbT1ijaAnUGGMjnHrd9I5mvzFU15BQdOWolJoAO7GAKTdjjFU14PSI111azCVpWRaV48TzDWcSsD4SDSgENwGk+yW0Cp5sTP+eOxWHVGOauHsGUrXikkhWBuVZMBOKdXKodFTKYphmCmR8aPgbhHC1Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPmAWAyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPmAWAyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63861C4CEE2;
	Wed,  9 Apr 2025 20:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744229664;
	bh=xslxFfMAcFFbtaqQ4odIfwL0rQVB+kqWwiWJmatKv/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SPmAWAyl2v9Wex2SpE8o4wSIaLIty+By74b6lcQ0FQl9KIJHLFwfPF3TWnEyjt3d4
	 oaaIJmEnz/du8NMzvE3rJ2PrSS08DIS/ejComBmJGrzLjfLGDBRe0pIFvplsjtF3Xq
	 SLoB2Tnz/CGU3SZ32Nkb3y4kc4XwPOU7cvi1jgr2fTdLP8rwpZZxV1GxbFSfOiDa/d
	 1WGz1gbum7H93KJjCQyKKUoLtT281cw0LN+YYyz7OVNdPsKgQvj7x5F/F/6Q8OKfwH
	 mZ/5LfSyfchkv4jRJ/QpcI2oPKTuvcU0HDlfIPHjIHC0K+OdDohuuN1kj9c1lw1QDc
	 qGr4EjvG/V54A==
Date: Wed, 9 Apr 2025 21:14:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/205] 6.1.134-rc2 review
Message-ID: <e2ecfa6d-ee39-450a-8047-0540757038ee@sirena.org.uk>
References: <20250409115832.610030955@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vcbCiGud3jI/CDof"
Content-Disposition: inline
In-Reply-To: <20250409115832.610030955@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--vcbCiGud3jI/CDof
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 09, 2025 at 02:02:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 205 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--vcbCiGud3jI/CDof
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf21RkACgkQJNaLcl1U
h9Be4wf/bXdjgttJwkn4KnzQu5/MxDucwfRbOnD9yNzw+ZaUoF/o/bLKWIQqPkew
0RC4+iWuLBng1TLAHs6DpPFwzWdr1lMhAn6DHSz0ITbHBHQJrlxA8T71ZsJawc/a
p/vMW7cCce7fmEj7mPUciSSVinnu1DfJJ8Nlwt6pAQoUESrO+QCxQ9BNMu4P7Ybe
VZ/1QdndI5417wAnQpQgKPcuO1H9bGZlxlbvkgOHSkcqxPa7U73x23mPfaSjgH74
ht37BAxO+T0rbEeGJlSSr5Ngn1NudPjW2eHJU3ilc3tOEtv42J4XFSyATg3q/t52
MnNluhqZXATD2SAJMtxbC/RtMurwLg==
=CAlL
-----END PGP SIGNATURE-----

--vcbCiGud3jI/CDof--
