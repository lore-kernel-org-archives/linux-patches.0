Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9BE396B9A
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 08:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154390; cv=none; b=ahmLM0hY4mRk/aOh2iimwJSwkUpOSvCjwJWnrJGvKzXtyxav0rgjWGSzsVZE2GZ/iKrBh/un6ID6U2/M/kF97CtyPXrWdN2g9RaJ2hh26YVRKpL1+qC7yciQD0t8QLMgDhZsdEDmUHKnO7Ga8liZcPs+5q+HgBsgTvq6xQdfByc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154390; c=relaxed/simple;
	bh=fH6NRpSl7MQRMC5DqmA3L0DGbWYjkBQbgaMcsDdVzUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BEC/8FPRNoBRtDdfKX44ccleOBJvdM+5Tmix6TlaLuTEsIbD4i9y01SDyJErjnsOiADRnBxuSJ+GH6Rz8lxVsfXF+qMpNYg00PF24eHtDRweLgohK0LIXZRcjiOay9mELra75kTWpKxdOj9vtlr4XDT7nrwjoLQgle50HOVxYXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=ZGQltHB3; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="ZGQltHB3"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DEBC01104EE;
	Tue, 14 Apr 2026 10:13:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776154386;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=/tCKr5ZGppW8YX9hvwfGCJBTfHMo2yvpemtCHnJ+vNI=;
	b=ZGQltHB3cqSkLiE/OE6uY91mjzzOYtp0O+awmM9ZbMhZmsorzZmNdBliV09fs8INyebpJI
	9XWG+TcF80gkmjIX/0wDRuiuKHffUuEs/CKaItzmfxvkyHps1FU1PpOGMYlThgTD0w1nQj
	laVqliTeo7vKMQLK6OsiXMZsQmLg64R8a85rS6nUkqibvzbpkLdrGQivTOy2Ip/AodbLVc
	HtsFEvzVU65GGcJ0XrWR8Px94PP30bLFNg+iaxBl6bDB0h5kPZXmYg3SU7ztXCTLUyCJwN
	JRJnz3AUTnxpIZKJzou663L1Fovvu8HFcS2rx4IhwjVYiHTyqI31TdDZp4jfJA==
Date: Tue, 14 Apr 2026 10:13:03 +0200
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
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
Message-ID: <ad33D9eE-O3mBn6j@duo.ucw.cz>
References: <20260413155724.820472494@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j42i1syf2PBbZI7a"
Content-Disposition: inline
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--j42i1syf2PBbZI7a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--j42i1syf2PBbZI7a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCad33DwAKCRAw5/Bqldv6
8vmhAJ926zw4o2+bagg3IEc3A03KtDfA2QCgiM2tby9Su3cntgeP0aUVTMf1Qo4=
=SBGt
-----END PGP SIGNATURE-----

--j42i1syf2PBbZI7a--
