Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DCD42122D
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784744870; cv=none; b=ewvDnjb/t1UQ1yV1N7HtBiWybHuFYvUHkbTNwoHT822xn75pcnrdqX5Hor/o6uKK8cNbgZdgkNZLrxZW3juhV267yXvpZZwihTLILWQyH12i4RF7GKiBB2ZOeT/hWEuPLJxVrIX7cEu6T3r/eqyjhvUtFSirbytaE3cdxkiReVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784744870; c=relaxed/simple;
	bh=ZUOKLjeV96drZXBDRr2qW6/EiSYiwKW8X3cn30RJL2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YI2IU9TpSZPgpGQ5qvQejZnmnl92P2UlEOLRh5q4YtRTjPR9KwNjcP0qWFbHrSxgRhm4DyyTsJ2NW5oou/z36ujNruxPkFCIJrVTNJwEul3ZEDSzydzVPAeh/kszmtOym+Y4m/FzADzcq7f40HQiXMKD6Vi1UAwVpC1lk3Djxhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=F8Ykwhnb; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="F8Ykwhnb"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1413611AC8C;
	Wed, 22 Jul 2026 20:27:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784744866;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=/vuXWq45yc5TYaM/vtncDJxG/AW9Lhx8Opzd1s/yJv8=;
	b=F8YkwhnbDMks7MW4uvIPFHyuzoIvZrJLcj1zOMmY/ft/cxgV4sqLH2l6hbK3ldudcNH4FP
	712KKEHNnjhyWtCfGGBJ2n/wsiPw8QczwFvkhbIGzrh1+jdaMTIkjHwb1sZ3h65XUIbczv
	7AvJtnv7VyYbX/WGWjUBi1gCd19231JLT85+q9hQs5yFNth5uyIRmnj0hxASN9elggMtuk
	ImwquJSN2voG+RN4COadgSWpoPExi2W86LcG4n78wvr86b+Qyb1GDv2ovDObPQWMfyLnAj
	7PDU9OyyD1xigoI+8cOWpTI8KKzG5pRCcGiNMquT/UuLXzvs2JkMUlPibSErtg==
Date: Wed, 22 Jul 2026 20:27:43 +0200
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
Subject: Re: [PATCH 6.18 0000/1624] 6.18.40-rc2 review
Message-ID: <amELny9No6i4RKR8@duo.ucw.cz>
References: <20260722142910.893804136@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VRXBDUP4kQJno1UX"
Content-Disposition: inline
In-Reply-To: <20260722142910.893804136@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--VRXBDUP4kQJno1UX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.40 release.
> There are 1624 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--VRXBDUP4kQJno1UX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamELnwAKCRAw5/Bqldv6
8pkNAJ9P8f9HMpcRqt/oUtTdIjM6c/MpPgCgreTOSBSYw+o401OlI3jy4k5izBc=
=1+Y6
-----END PGP SIGNATURE-----

--VRXBDUP4kQJno1UX--
