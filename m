Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D593921D5
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 21:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785448216; cv=none; b=V4uhXwGhj5ORpx5Qt3j8DE1gbXL0459BwdFHMCYH2lOJnhMDkUgsIeDzzwIIFWtZ/+0U3HbF2p5YClcEgHFX7wWM/QDuu+/bOeevj8F5VXltMNv/lyPJ6e4KhdbN9VGFcK9Pv8GWlGvpAwj6os5mDRogrECwERnvhB0lHCt36sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785448216; c=relaxed/simple;
	bh=7tV852O3vEVCvqtCEjL+lzTr0ibRRdrupz2kor9IheI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nToAQ2zFL0X6FiHhxY7uOFG9vH8j4M2PeLczwd6YpyOyi7x2jiZI9sMK0xhk4BAWqzj1L9iobDxy8Yiii00NoWnw4cLRfxc1OTk62Kr8rLTjGmu1aTToSEpCh5yFAEzxSMbwrlMHwi0RlIxUudPzCGgfJSFzzcysOycPGmlW4A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Rdqshkig; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Rdqshkig"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9CA7111B90C;
	Thu, 30 Jul 2026 23:50:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1785448208;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=iowSJoKEEDbWwBAHfjqy1gz5UjyZaFYqdvmldQH+te8=;
	b=RdqshkigEakrDipN3bam5hfDEYQHf2+p9UHMZlOCcDe3W3IL5UXTJHR5VJLVg8hXTXDYml
	RQyY9rj6f61NguspLPqjNW5ccbihqfKNYl1hjX75YNZaPhL04P409hmY46i4L24UEsjsF6
	9Qk1jJREqTF+g7qfsdMKurHmRRs5aKbCWdG+BBg3wAHQ/uNGYhDe/lLOlrKR8IcU5oB9M6
	6uMrf/stqOz8I9SqBGMrkAcaZoJ2M+dZPZp8xnniblgPi+NgtwOstu3iV86d0N5Uc7a3lY
	6yOoBMQ1KhuvmVZ4jvEB/aU0H1Gk1zMdrgOfmfoUQDyGzWCb/hAxt+yyz8j2aw==
Date: Thu, 30 Jul 2026 23:50:04 +0200
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
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
Message-ID: <amvHDGGNT3FUSjq_@duo.ucw.cz>
References: <20260730141423.392222816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b2PXzWEVG0oF/fsv"
Content-Disposition: inline
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--b2PXzWEVG0oF/fsv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.148 release.
> There are 484 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--b2PXzWEVG0oF/fsv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamvHDAAKCRAw5/Bqldv6
8lQtAJ4stmd1hz48M64NnvI5g/O4TXRVuQCfYvmcGsGrsHRlYNIYjHwkvb9yfgE=
=yqKu
-----END PGP SIGNATURE-----

--b2PXzWEVG0oF/fsv--
