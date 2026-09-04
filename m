Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA063546C8
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 13:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527734; cv=none; b=b5VZ+sRcBzlns9x6nnXxYQfJmx7hqcZvetfEDQiAp5c2EjiqyP9/DU8SrAuKVW4m2+pRg3TQ/AqVW3ttxGTJiBJ/MjLUrOsL9eMaeBSbkGt5P++/JuyV9Kz7Huiz4Mtwf8NLMZDYwAsX3HjRBf2BO1GnTv8cUCqeOY62zIT+yV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527734; c=relaxed/simple;
	bh=lGUPfaBAG2EBU4HVzU9QnJsK63JNbn9aX+dRzsAPbZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVHNnS1JcoQITbnEeH1qfurf8e/TWJWB9BSrPIJk1r9bFhdaAG5Sg+A35h8f1CtA8drzwQGt2KG4dWELm/n+8ItELdjh+iu81KYwgLHQsVgNTnIBZaZ5GC6Rv3GTCvgo5+gzgpkE5zdyQr3Lxh2w4RRJTZiOqq3g9a7kgvCnQn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=IWAMWgYC; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="IWAMWgYC"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A1DE811D7E6;
	Fri, 04 Sep 2026 15:15:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1788527724;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=0IDCFLJeOdZ0mmr5nHKMfC9XF8CnFtq4oEoo4lkiY6g=;
	b=IWAMWgYCKfkV+JOeutic3Fa53fGyqrav3m6fBvsxhnYBN1rHgwvQSSdW11bX0Dg/s5/ZX+
	sWpazrwdPcTKDjcznKEDOAtPukLOyl3+GpfFT4x9Rb6HUwe96D4U7qRR6ZuMtEvsGIU+oS
	xHmr+kRZZO9VK0YxXscT5wWmMRP7GzOjqb+qT5O1No1JAKGQv2aj1TkqIgTJ0YYDIXoaY1
	Z95D9k4D5qc8GUoCDt9CxZHbmUdXiDuC8nrvJMhg8YeBIrIq7LhhsEiVoV28x2i7YUFHb7
	RAxmuFXzjseH88ht55v1qjAotaCjWBtu/+l53klkF1PpXC6F+fMW0UtGxeKj+w==
Date: Fri, 4 Sep 2026 15:15:20 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/552] 6.18.50-rc1 review
Message-ID: <aprEaHx6T4mfJrbn@duo.ucw.cz>
References: <20260904045747.813364717@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WfFMcxO8gHhRC0Ne"
Content-Disposition: inline
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--WfFMcxO8gHhRC0Ne
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.50 release.
> There are 552 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see similar problems to 6.12:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2819268635

for example

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/16299963277

07:10:16
mm/page_vma_mapped.c: In function 'check_pte':
1479
07:10:16
mm/page_vma_mapped.c:110:25: error: implicit declaration of function 'huge_ptep_get' [-Werror=implicit-function-declaration]
1480
07:10:16
  110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
1481
07:10:16
      |                         ^~~~~~~~~~~~~
1482
07:10:16
  AR      drivers/pinctrl/nomadik/built-in.a
1483
07:10:16
cc1: some warnings being treated as errors

I assume bisection from 6.12 applies here, too.

Best regards,
								Pavel

--WfFMcxO8gHhRC0Ne
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaprEaAAKCRAw5/Bqldv6
8vOFAJ9ssgpxtGedh9WY7bU0LeCn3SldpwCfX6yyUAAFnpTOe5bbqayChLXM5yo=
=D9bt
-----END PGP SIGNATURE-----

--WfFMcxO8gHhRC0Ne--
