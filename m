Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C893C0A0B
	for <patches@lists.linux.dev>; Tue, 12 May 2026 21:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778619800; cv=none; b=RX3zvPApLitpKpjucEWgAhFD98Na+hV48fqVGEGx8Ab/S6wP4Z8JMcvE/6St+A7wbTah4vveJ4zuNA3SgOV4lTlJhakc7P+Hzzs8tjRzF4IqBZVPllqlWSY1C+63HWTIRuGdlMZU/XSQ+RQIFplMza9mJ3cbwAc/qcVIQvvavJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778619800; c=relaxed/simple;
	bh=Ln9/QDqnVC1oH3vzxuT+zkAI+vGf8aPcLTtsmJf45z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vv5FsKvFNxP7N9G3XlfI/+LAimyrCDWF0w+m+fqVXeLDsuQjH4L35cq4Cx7Q6v1uUqmcMJdMlO1cZCLfPk8YZPOpBftKRTi2mbsjeNrjxSUzTA8bAA44S1B0WyxQ+CaSNwBgb8x7ueO1AL9BPByFK+U7T0FYQnUG/yTBbp/Q9gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=NhaQn1QJ; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="NhaQn1QJ"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AC42A115555;
	Tue, 12 May 2026 23:03:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1778619795;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=pdndVkyOSJ+QzaTIMxoKsc3ir2qqNVzp2PfRK6v1F6U=;
	b=NhaQn1QJmq7AWxvvIcIB2e2OSnUZlvp46WrlBC51Fg0YCkvgecZ7AUDolGroCG8sPF9Xnq
	Clf9xtk1KUQVYZZklRBDeOL41elHTdGertOvqtWoYE9pjYLjGdYJMHrIgAoDy+SnUFTqtS
	cMFyH/EV7B+CRYLBGkSxnWSIAkDoxnJHFYj3eDQQ5jtZlEqNUT8JwUkyIU5jaYpBFXGuf+
	065tsq3IYkPwlIOXhhLCQOpIGKiNgNBSAZbD/BmatCkCOVfkfcdx24NDkIJElODMOQLjpu
	pFVcOtm0V2zQ9fU3+02goE/97VGiVd3pSZE/o6qG/pZke4xiqxWV4gMzH61alw==
Date: Tue, 12 May 2026 23:03:10 +0200
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
Subject: Re: [PATCH 6.12 000/206] 6.12.88-rc1 review
Message-ID: <agOVjtRJWBoqf35a@duo.ucw.cz>
References: <20260512173932.810559588@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bgX5HV9KDREe/epZ"
Content-Disposition: inline
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--bgX5HV9KDREe/epZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.88 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--bgX5HV9KDREe/epZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCagOVjgAKCRAw5/Bqldv6
8lfLAKCneKDgP24MEGFbsZBLhNfbYA4EwACeORsJMexGhabSFMqnWK9F5KmZ/Fs=
=k1xo
-----END PGP SIGNATURE-----

--bgX5HV9KDREe/epZ--
