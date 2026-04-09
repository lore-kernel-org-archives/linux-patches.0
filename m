Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793D13101B8
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 07:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775719253; cv=none; b=D2cd+ih8b1s9dJ8zFaW1yHXPok6H/zWQnRxoFI1jfuPz2stSXj0/S5BVy6TsQmknV6SPzgqwmVADtyCXJXOmgfzTv5jaUnbupmGfouzaIRJsBQNqrzrRbyuJkmjJFSSiR3YuXDm0oWA9iKvQHkq2tYUh9LiAc+O+zg5qEQqc3mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775719253; c=relaxed/simple;
	bh=93maRgQT9DxbdiCGqMshlF60adeWEa6P3R1mdefDkik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g76dByNwqu+dnKYzA/L5L0g/VxoEPdGWAi1YEOLEA7MZv87maTa7K9wZiKc8T+8KMoYlreyIoE9rlocrpOyHkWlWSSHpFhFEqQjHpfYd2AFFEraCcC9tDVtTD0gE0TXRGwuQiSUf/kuHAVCJbxV4wUbpnI3YXvKQTZTLTmVreCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=cBxinGPR; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="cBxinGPR"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7D5E71122E0;
	Thu,  9 Apr 2026 09:20:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1775719248;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=bnIA7bAufKBs++XIIbr7Z0RHebcNaXpv58oJOHI5jzw=;
	b=cBxinGPRN9QVrAzYiXCD9+C21I8cRlDSLtTTirfacQb354m3+Da31BM4UgG/cdginSVRdY
	W4766AY9FocUVoJ1+pmwvwxDrTBm/arabA61SwTLTeClQN08CMMtH0gYAgGIpAto5CjEco
	s8Tma4D1gBzOhSz+DMncBntrxazzclqK45Z9lPGcaXbJXrFFDJWazaYhDDfDik7hntIFBi
	AtXMyMCcJ4S3iQdAlZHzL/uqL3htErqdnRrHeIkpJJhFEC21K82OnMqdANqW1wuSsUlCR8
	jxwUayv6eXFCVTYSwZEpqFF8uuu1lfzIrutrv49QQVTXRXYrWZ0uK5Ip1rJsEg==
Date: Thu, 9 Apr 2026 09:20:44 +0200
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
Subject: Re: [PATCH 6.1 000/312] 6.1.168-rc1 review
Message-ID: <addTTBlhhjB4hGeV@duo.ucw.cz>
References: <20260408175933.715315542@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vp2jGwqsSKPm2wX"
Content-Disposition: inline
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--0vp2jGwqsSKPm2wX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.168 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--0vp2jGwqsSKPm2wX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaddTTAAKCRAw5/Bqldv6
8khEAJ9etNKesEVTNrD30nxeIWMtji3JNgCglFlCBTgU5GwL/pQyWme29pdiL4o=
=HT98
-----END PGP SIGNATURE-----

--0vp2jGwqsSKPm2wX--
