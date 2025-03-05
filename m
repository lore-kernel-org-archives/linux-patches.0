Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC2E1547DE
	for <patches@lists.linux.dev>; Wed,  5 Mar 2025 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741211775; cv=none; b=laPqUvglO2X6yFRju/VR+sR91JYxRdtLyseDSIR7gVliJA8YHZDeTQnq27ZGiakA1QLZmZHGoR58dT7O63fIH7wkGaqznhEgYEIixF4kDJxBYXcmETl3SHx7yKBeE3yL3s/lPRiMKu/ry9FUIyq3XkhLj8zQsKnmIAMWqD9I7sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741211775; c=relaxed/simple;
	bh=a24G2GQTmbedCjRrq2xzRNIeT29utGGOPqKuDP07n4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeZbk8deqTHvIr+vfqZvCB5r3XGSR8iiCY6r7sguWdGjS00GllIJdC7EOkTByKsLSdRKsGhde1GqRIqUcCc3YWv1HmzjJIUHqiBaYHoAARuxZI9xKTkunE63YFHTc8trcz3YR0/utD0ggT8IEQH9mXhuJfupTK/eBy4OViPKb1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=TjmNZFGh; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="TjmNZFGh"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5519E10382C18;
	Wed,  5 Mar 2025 22:56:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1741211770; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=fpIpMR1mMV4sUOTWVCWFQ2VcPSUOQ5igCmsV8RlXIA4=;
	b=TjmNZFGhW5phz3eqlfKAHhn3GcNytlwuQ7RRpBf/NMCrJtlNieUVdHqNPMK5z4ys2CjTQT
	AW6X0f5XaF0DawCCxT3xJefpIkgmtrHSGIqTcsPP90y62enq9lKEuNAYCW7uBiC0ye1tHs
	tuXqaC5iKCY1yPPpyRvmZLpbzaooss8kXWrZCXFmwHeWx+pNzLPQsdaCIxV549cD9CTYuK
	XOnYXudPoUPaGI0ladoz3tAKsoHfP/Vepdxufq+pR7Geu8fjesUJjbavBkcb7tjcUHvLv9
	mhJhakG1Dt2++b7fn1F4h/PbY6PQbLbhpIFAW30Cjpw0Gup8/N2/kdOZX0+LJQ==
Date: Wed, 5 Mar 2025 22:56:03 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/142] 6.6.81-rc1 review
Message-ID: <Z8jIc+33EHHcHSw+@duo.ucw.cz>
References: <20250305174500.327985489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8jf0unX4r4KrASvT"
Content-Disposition: inline
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--8jf0unX4r4KrASvT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.6.81 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

6.12 and 6.13 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.13.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--8jf0unX4r4KrASvT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ8jIcwAKCRAw5/Bqldv6
8ltqAJwJQgOM0lXi8sRYkEhvOQxLmbDBwwCgm75XWL3UVdjntvjt/toWFZlMfsM=
=2sob
-----END PGP SIGNATURE-----

--8jf0unX4r4KrASvT--
