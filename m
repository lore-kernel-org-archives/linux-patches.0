Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A598E26AC3
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 19:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776800053; cv=none; b=DWsH5s4xigSYqa/EfCUyCeP9Jt9rY6x1Sf2bzfaNqSxugP310rrOkVU49HC28SB2pZN96cRgdEpw33I/xju6sJ57rBKMs2s0Uz5MUfqD1LXnWDNUcadDlhQ91Vqu4HbtpOtS9zy035swWicX6hIahG7grOXXJU7YkUhCnJNBedc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776800053; c=relaxed/simple;
	bh=1TJbJddqXNfliFde2SNOq34up6/NGogPIBUsuEIBQvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B1/Wn3hm96P8ylcXP7gqDZ+pDBx2fBvvizJ/ZwxvYBaiLNl42YAl122AI1V9v0CqxhjRF30dnZoJ+3VYpFMxfP+vWLuQ9H+p89Jtzpd6EcqRz+S7jtxQW89VcpXwgHEvM8/6xHA7xS5cUsrIdk7bRCZpIFzOERu/x/tWNLVwfps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=RxHNw/O/; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="RxHNw/O/"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B245A112D0B;
	Tue, 21 Apr 2026 21:34:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776800050;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=tXp5/Dsik9poSscKmB9rLckpR5CS+eTljORT3XX01Vo=;
	b=RxHNw/O/IxFvnVRxp+nvHaIx7vVRQFfLdfF9BINhlwcnSCM/NQdJwk2dK4HY/61vzx3WrR
	PNH9cQz6AUZWDUJre3w+STMYuVyFeGcOzGRx8dSlHBTOzUX02SkG+Pw2T5A4zRE+9PKumz
	7LHDB05B0cCwvqzr6zpjM6sOxuYb2UzE3O058ly3EVJNyJ9+VFJ1KalwJOKaDG0q7A5vuw
	SbJ4USe3hyqUXMCRLQmnjeVzK6aAxZYPWI/K/26K2ywvHP9ECaX6aVCYkdgXalX/U+FxMQ
	HZJqMU9JtpWS1OFjf5sgB3UFOLNf9qBrGDYq1cDAgLpIceCfAG52eKYmY/ULjg==
Date: Tue, 21 Apr 2026 21:34:08 +0200
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
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
Message-ID: <aefRMH-8AfX8T-oD@duo.ucw.cz>
References: <20260420153927.006696811@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kvTOkM4VA3kdj8dW"
Content-Disposition: inline
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--kvTOkM4VA3kdj8dW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.83 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--kvTOkM4VA3kdj8dW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaefRMAAKCRAw5/Bqldv6
8jD7AJ40X1GkOIRmII/ARyLmarAxV/NByQCeJYHCFkvVL2BtUrYxpehGnlDD99s=
=E+On
-----END PGP SIGNATURE-----

--kvTOkM4VA3kdj8dW--
