Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9B732BF42
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 07:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775719286; cv=none; b=omvzMTPCAFYl7WfdBbBhyV8OdVLcmGtz30HgBr3/WxwvCN8FVPYW9rXrN29TLVc3oknIUqSAKWXsyX2l9jYp1YbF6Hzr/HIMwj+1QxPSiuY4sARTwBf6FIePC96xtUe3wzcRd1OEa42tNYm858535bsPMbxve6sC3hQ6018v3vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775719286; c=relaxed/simple;
	bh=eP4tTrGgc2rtsfkvczdDmbkm6agGGrSAaJIZ/VgvWtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qufz/QWSYlwpUlXJFeL93MKOm3rF3rK8gpne8gjARG6SMGH0NIBYqi3buyM2EDtHR0guAPW9ZGYA1H7aE21oTZ/ekarl+nEB+xYbS658EBZL928mPxBSVcxidOHHE61TwoppJd19R+9kgT/w0NNkjs5ZkViVttDKhdjYJQVvO4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=aUa3GzDd; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="aUa3GzDd"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0AFED10DE8D;
	Thu,  9 Apr 2026 09:21:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1775719282;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=v81cHRxTMGWyuquBKCqIvvZg2ZHR9Nvzdf+ofWB1144=;
	b=aUa3GzDdSVprba+maBif13Y7ycTjeRlVyzpYfJ4eyXv2u+rq2aCer7jfP4SoSzWY163aH9
	jCqye87XSiaXXKmd6+RjHq1SqYe/yvVCAIb0JE+umD7FpeqH2slyLKSqueTJQglMIqaTJ6
	5bPY1kKqhVoaX+h85b+XluVMikBIknCw5M4InUGTuon8IjWikh1y1TPL/hv/LricVNshBY
	r747ok2PSFPvqCxh7dKTj/dhy6K9+BmmaU7X21LgoKOkRIolEonEXbGoSatNVkH3u/tUul
	SM5XxkmGLly2nekhD2A4lxF8HoLz1TDMuHZYdh8P8koxyFOA3zT9XUdFLBC1tw==
Date: Thu, 9 Apr 2026 09:21:20 +0200
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
Subject: Re: [PATCH 6.12 000/242] 6.12.81-rc1 review
Message-ID: <addTcKIAS0Hmuvf7@duo.ucw.cz>
References: <20260408175927.064985309@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="avfA8KuvNMWCUYr+"
Content-Disposition: inline
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--avfA8KuvNMWCUYr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.81 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--avfA8KuvNMWCUYr+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaddTcAAKCRAw5/Bqldv6
8g5AAJ9ZzqzOTp5jyqsMHfwSPwn6RE6nqACgol6qr/WwFe3QRRYNRpsGh57lWMY=
=SlE6
-----END PGP SIGNATURE-----

--avfA8KuvNMWCUYr+--
