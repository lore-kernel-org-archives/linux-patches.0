Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67948377015
	for <patches@lists.linux.dev>; Fri,  7 Aug 2026 18:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786127554; cv=none; b=TM0iSBSTvXLOrNKJvzxj6u9okXhE9fPP+l03qkTRIr5+ZG14/4e78XSHYVh1MRSH9sI0Pq7DgctaWrYY9GTqt8XUnCVWtrLYXatetNddmnciL40GJOisnaS8iyDR+zfLnk+hsf5IsmQ64NLnaYhkvBlOqNK6BJADdXq8OFVRi6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786127554; c=relaxed/simple;
	bh=RtX1tNiM37jW9fTVePjXO2ijliKaaPyn8LxmjVLZ+e4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guvDiV7BcTKt9Dd1tz/tbL36U8POX7MdMgYU/YXReqC2xF3zMsU0gFsFF5IQRZgqhxYUPdc3ua/O7p8+96WXV6kYz184z+gOwUe5PLN5BomkH0n8WG3GK2gvix3u1E3lA9Te13hGL8uKMNBE20zsOGpTxQ/1mRCGzo1K3+8w7bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=YrPk3P2O; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="YrPk3P2O"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id F0CA811AF62;
	Fri, 07 Aug 2026 20:32:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786127547;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Pp2Aj52hvKpRfKLld8iCrOE9VQpKyk0/QBIRjDV/Wt0=;
	b=YrPk3P2OIGTtw7D005vZgC6pxM6HviY8DjcY50ByRZqvPguouxKfCXpLczmErwBcpBRKOC
	XfijXBOdd69EAknVTKsPmaqDx7SVKfhgyMjGt0XetVb3CcgPvBDJGRpHfxpuMS7CAe+BQJ
	C5UWSVihCgjA3QJ9cXFnpb5hA3szpmprenxOZJpnpiG993NvGSl0YYJTmiI4QTpXGY5UHv
	Ti2Mcpr4f2ern+xS4uWA6XiTeeQuXZZZcnuQTn/cqoy8h0X/xIi/OCYX4BJaFgWWIUIIf6
	N02RirYMkabDIfwiPxQ9JYKYzOJ7rV7m09xgfUJtaBnIMADPb/jLknoVg6jUHw==
Date: Fri, 7 Aug 2026 20:32:23 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com, Ilya Maximets <i.maximets@ovn.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 000/337] 6.12.103-rc1 review
Message-ID: <anYktzWz_rHZSf2s@duo.ucw.cz>
References: <20260807143418.516897842@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Ci9Bkdp19jfZAzA"
Content-Disposition: inline
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--1Ci9Bkdp19jfZAzA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.103 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y                      =20

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--1Ci9Bkdp19jfZAzA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCanYktwAKCRAw5/Bqldv6
8jofAJ0QFazu+hGLVm6FjKM0w3Lg5yNlaACfVEKZhByA57GVHpXASZ/nRLGL84o=
=bIYd
-----END PGP SIGNATURE-----

--1Ci9Bkdp19jfZAzA--
