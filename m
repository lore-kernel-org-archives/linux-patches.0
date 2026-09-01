Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEBA47209F
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 08:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252325; cv=none; b=p+p67TLoZxub7NB4fGsvR6+LOukCn2ndQlJCMCYNBhDfntVLiCZaUkgPY7k1udXOEdKJuSzoPVjpoXJ4P/tRalKeMYKpl/yOXTYTMuFIlFgG8h79Q7rh87t+UbLMn0kP6o2FeKgDZ6GuS/IUsL/XqrKj1lmJaOzcZnwO51Vg9ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252325; c=relaxed/simple;
	bh=HYRefICZDyU2bXAC1tI4X0i9pcdKd9ZFcXth1lF0ysw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTGRPg5qagthEBkqfnQM4KfCb8Lhn6M4Z6baNxflIlZNP3whgH6l2tRMreDzXc+s33FNFguoRQfOsmB5WkrrZ5mrAPD/tBD0s1gdLZ+7MSWAzxaRE+bWgG/g2bqPBM4Rza5zDg4vhLdIXG15z25iVOlwhbMd9Ryz1/Fsz1dtonk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=EoJibeTG; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="EoJibeTG"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 86CAA11D362;
	Tue, 01 Sep 2026 10:45:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1788252315;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=hGbfr143U2ZkrMfmE/u5PLs7/+u0I/323jZIXWJmqTA=;
	b=EoJibeTG/uYa0KyVmMFDPpMRAxtNl0wO0aNG1y5RZMoeZ3XDI45lpSitAX14DMbuZZlkIj
	7cTESs3MPL9oC87VYq8yaHAy2aSTiaFTDST1jNWuhLWZvgvOySWRvl3WkxaWiH6fCh1rq5
	wV6XjVePtHCAQ4jF5NIYM17MDuz6ppcAsJO4FuWibU7BRBC17klFakL7fd6dmIf9UH1d6m
	5OBA3+zSy9x8lKkKL9wTyREbVK83fMp7xMG1tjniHu/CeNdA1RsM8w2G+4xYaAc2nKXgrO
	ymr6CcXTjH5t/pDRx82XgAtzjuJavJo694kp+E8Y93gNR+LksX1RnvjiBi7sog==
Date: Tue, 1 Sep 2026 10:45:13 +0200
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
Subject: Re: [PATCH 6.1 00/92] 6.1.187-rc1 review
Message-ID: <apaQmY3uqPauyIFQ@duo.ucw.cz>
References: <20260831133359.482388899@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+dMwnNUuTwGuzHC5"
Content-Disposition: inline
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--+dMwnNUuTwGuzHC5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.187 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--+dMwnNUuTwGuzHC5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCapaQmQAKCRAw5/Bqldv6
8nT3AKCwcWEX6kvfGk8a2MTVhHVpku2SmwCgpDxII0DVAMN07covOJAzWio/Yus=
=0KPc
-----END PGP SIGNATURE-----

--+dMwnNUuTwGuzHC5--
