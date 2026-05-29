Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867B73A8723
	for <patches@lists.linux.dev>; Fri, 29 May 2026 08:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780043327; cv=none; b=hy9JuYWNXHlxYHCB/LctIVWSva2uy+3o9xji/dtcgAl71v1fL+X9/VaJJDFGYJPZQaY1dvaVZPopRwH7qmnVCjjKf26paP+m+igwN7wb+IbPH9cpl+yghDK6tfdUtq3CVPOflYkJ3ZefrGzKu88KaOp5EekdjERLVwaxhskFjzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780043327; c=relaxed/simple;
	bh=rfaQTsDARDv2rWRPISYkj21mRcbs3p8S7+4tiqbmeoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOgPnUg/5JEbr26NsWo4sVh8Qp9xJKKXGjJZmQe4qdcdKTSOSdnwg7TVOCnsSlNHOMqora68FpXG2bn15xhbYUAGWB2F0F4PVoLZp3Vh38/l6d2PBlmQC8jWbLGlnaFcN+8aMn2II0mtAbhYma6gh+U7MyW9ttNUfNlWtoBdOEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=S8kTcXnT; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="S8kTcXnT"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7D880115CEB;
	Fri, 29 May 2026 10:28:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1780043323;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=mDKlzVQqhPkP0caENvEL+QLVgJTkgEhTB92Wz0Mn1PQ=;
	b=S8kTcXnTqyp3xUsuzWRNJEL53/cPPyznwaXaVNQY6bFy1heWwJM+UePoNRq82U64OYTLSe
	JVfVzXD009U/R3pGaH690/7XMPjRc3FIUjASoJmbCvXVs0XLiacea196TkNCjpwj3HkGnp
	cBmKXOa5BX02WMfDce6s+QyC6K8f9D3lMxL1yV7467DVryHhQuCBAhpSEJimPifyR6fhDf
	uo38WNlMoggtjmWqJcyjd1uUgnYOhkqR8Sr4iFYfdwmf04G1jtd3NT744QWfswIe+EZGsz
	24vhYUOs2q2g5h8xBhJLg8NPd1/Y9P2MrCJ1ZeEpL+Xv3z8ySm7pwuBgDWs9Yw==
Date: Fri, 29 May 2026 10:28:40 +0200
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
Subject: Re: [PATCH 6.18 000/377] 6.18.34-rc1 review
Message-ID: <ahlOOIkulR5D9MEG@duo.ucw.cz>
References: <20260528194638.371537336@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pEZSPRa8PUxPKhwR"
Content-Disposition: inline
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--pEZSPRa8PUxPKhwR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.34 release.
> There are 377 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--pEZSPRa8PUxPKhwR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCahlOOAAKCRAw5/Bqldv6
8oReAKCEd38ZJjbIJY7QujPeL0OaDqDAPwCdErWq31VNrlsnbly2F3Ru+KLjT/M=
=JgQE
-----END PGP SIGNATURE-----

--pEZSPRa8PUxPKhwR--
