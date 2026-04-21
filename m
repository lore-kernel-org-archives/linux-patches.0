Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709E23233ED
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 19:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776799971; cv=none; b=rDuKFuStn+54Ga47Oy/WY1Tqfx9GwkvRQfCZya2dzguFgFyl54uu8lChas3ulOMoTwJpT7pfo9jMvhcSr4lfocnyTTbLhnhsFY7g59ze3J0rUA81kWcXFGhPLvkUhq25BLs1DUbS1LJ46Ah8n8jHVeRPhbV5RKJTZNvjfo2nBH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776799971; c=relaxed/simple;
	bh=j5KQxKW//7RedThBgyCpv51USOErsi/YjVJU1ufoQm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=csYwtQGmNDywP50y7csZLt61bSzrr51x37vupIeY5owrRf1gtqZpo5SdhyCqZJnwdrQzsAeiLPfkGL6S4dYfklVg9QxEn3bIJKq7RITk85rcI7UZHExX5bEgzTG6509Js/tVbqgqUJKvW/3qwRIq1UTtozaco2cwXXtBFsXUEm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=jxuSwfoo; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="jxuSwfoo"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 98FD8112337;
	Tue, 21 Apr 2026 21:32:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776799966;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=pQoCZsVj5FUYn1T4GNPxV/Nj1cWxrAgoNqVpZdwmB24=;
	b=jxuSwfoo0LD3K1s81baAcjgYwB4KNZLyFjL7WZ6d1oBhieIFp/WMeGFpbtDt8kjilXEAn9
	r8GavVssVzd9IEyIsbYiv9tYYaOTOPd4lUPwxZGQh6QRxlifrIws0MqS50/aP5tbqlqxm9
	nudLZ9VMs9FE1TQClv9qp6kLTSVgksPAGQIa5Msxwgpagcx6rO/98Cp+SsWE20aPfmKe3M
	cesDaM7IX5vOBlHFFv28jQbSXTKJiic31Nzm/FO9LXFIDAuhew5uHsLzvqhnCPluCIMdU8
	g8Yz5xIlupgyEYS91Ngw9JzSkzXSATZI89qaxodK/5R/0JuSS3WJi6BrlxBGrw==
Date: Tue, 21 Apr 2026 21:32:42 +0200
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
Subject: Re: [PATCH 6.19 000/220] 6.19.14-rc1 review
Message-ID: <aefQ2k7CfppQOQ3w@duo.ucw.cz>
References: <20260420153934.013228280@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7n2I5B9ECmoYpYMJ"
Content-Disposition: inline
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--7n2I5B9ECmoYpYMJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.19.14 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.19.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--7n2I5B9ECmoYpYMJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaefQ2gAKCRAw5/Bqldv6
8oj6AJ0fyiS29bPrvsIdFJdoCDlUBJbbOQCgqbTNI4ZJiAdYreF3TRmeoG9j3so=
=M+U6
-----END PGP SIGNATURE-----

--7n2I5B9ECmoYpYMJ--
