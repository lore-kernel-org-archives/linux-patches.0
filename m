Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139F4329E50
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 12:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764938096; cv=none; b=q2bpdDArxyBYTbL2wHWFRObens0NYeFUSg99ZBdw8fVZkoUkW2emEprc74gzzuukRcWoySbWHtIBNYBAqpNp29NNPXBBbEaCY7PGHN99ZyuNx2WOVrcbAV7H/rORGxhIgMKWm9CzByxKa/shUe6Bg1Ec/wcjWOOKOH5peq0Lko0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764938096; c=relaxed/simple;
	bh=lHwDdAnp59qeovfeYoif3sxtEtxMl5QrYl2Ym1UwLgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZcpBpdfO0ns9Ij7YHtmIlfTziRHvIC7BGYwqWAa1UMIRLqqdzernE0kcB/Ipj4XeSoP1tBfR7spxtNlyoNFeXvWjz6SDdqO1t4c8iEOlcSqi/fGrkFuMj/LLu5JN+5dMQp+C/ivArC/+MCBXdR3gy+X8CcBgmhDw7lYS2WeQEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=UaJLiS8R; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="UaJLiS8R"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E80AB100625F9;
	Fri,  5 Dec 2025 13:34:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1764938088; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=m/CGtShvIhYyJvsOHiVexJGhbfFnZ0+WkkpfVDGL+Gg=;
	b=UaJLiS8RCaecr4PsHaXAec5G+o0PS8i8MB+mzHzg6h1SYjKbdCh3hdtSKImrqARuT6v88B
	JTknONesqClWh+G0ybJqQSCU7n+WxzHWYSdfvDI8wSa+o1UcjiXhSbrcyucQe8W/fwUraV
	6Ie+YZHSs4nNDEPxaEN81FukJ4r1LTuzNlJiNvyIxO04ggrGm54/A8E5rwVXXmT+4sbCPe
	1RD4PGdc7BVlqpde6XtVDM+dXlgTj8wdJMl+TMORVmSSpV6BCB3llV0/0SRBqa4SGff1hj
	607aMRI9/42rWMYouCM8l8ufcLbQ5R+h52VMVhuB5En6IsYffk+H3+uZ7NnE7Q==
Date: Fri, 5 Dec 2025 13:34:39 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/567] 6.1.159-rc2 review
Message-ID: <aTLRX6luoY2S75R0@duo.ucw.cz>
References: <20251204163841.693429967@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pHfjtRawWgnz9Pe2"
Content-Disposition: inline
In-Reply-To: <20251204163841.693429967@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--pHfjtRawWgnz9Pe2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.159 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pHfjtRawWgnz9Pe2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaTLRXwAKCRAw5/Bqldv6
8v5SAJ9CRdynn7WrB6XtmACKFbjNnuFRbQCfXUi0Grj/b2RmUyy0lFzzMGajqQE=
=QHvc
-----END PGP SIGNATURE-----

--pHfjtRawWgnz9Pe2--
