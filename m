Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268292;
	b=vxqcLit/IDeZ3Uzl3QvlIyJQWWdC+WTAqnS6cmHK6YCkXuZhDsjGsvu8TzoRV4LgLcs3
	 tx8lDf0rvc/S9kfWkSzLVOqgPFi6BfnegLK81l+RNKMNqrASmxksB/wlgdrmGyPW3E5Vg
	 oblvSEziwS2LIz27IEnN/+mD/qpuqSFuDQaQOFp5WhCNlhVZEX8QN98iPsG7QC4aC5DVz
	 HleXR1ABIplKUGBVem0NX9LSTOO5qCR9IswbC/oFnjPK8S45UHgjrnoBFEEMj8XGrkmjB
	 A/c3KojTGqrPo0cL/NuzseyXytskmDcrxrHOrTtVeIvlG5DBMeHuKmbDofnE6WY28Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268292;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=UcZhnuPJtXeYwgg3fwGjrJNdb2UtBfX0hISrVvvqQs4=;
	b=2qE//d8AA/We25sxr3cGdI5RXkaZjRISfNP2LkQW3Sw5lH3gGc9yh/jOiKZWEz6LJW6m
	 Uu/WWDJnf8JjEEVlWwVSBXQ2xDwWqjRRuXtMcOmdTSPJub5+mDw6MaQkBREQ2j3mIvjm9
	 MleiaZiLmS07R8RKV/W1AHkJsozfdMyyUdeEGkpF/q6/f6riPOgnh2oK/Qk2w278Xs/42
	 0vWV3WK9fXBpGdFfp4ngC12R8L6rrGQ7jmnQd8sPASE1W3qxmWmq+cG5Dr2zZ2jC+wYkA
	 YpF6ySR3CyQaZOZCPQtB6/BUwPDc7G4hKOxOcs4WP3s77ulQ0V4pGopxZDz7Rmril3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=A8EEHosi;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE2E606A31A
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 10:04:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FE2E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=A8EEHosi
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0765210A8C7;
	Thu, 29 Oct 2026 11:04:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793268284;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=UcZhnuPJtXeYwgg3fwGjrJNdb2UtBfX0hISrVvvqQs4=;
	b=A8EEHosiNKzMrhpvO6G5nhbMxnLPsahuNA++Zwe2PUrGOSQYXkyJgnldjwWs8Gkk5fimVb
	AXpAKRgZb1HN/3gN00B+sK8lMbWpmK4RIq04I0GC+x7EM++AKEyDdDSsm1DNq+9qu51rHK
	fwrUrcfN/R9cZOTp4ilp0Ay0tSCLCzEjY0XgbbqFzUepAmUnXHeQ1VxJwTHyBA6EgxB2oV
	PVi0b/+r684GOAarI8r1YPtKrhiHr+lXpcCmzeIrYnDPeJdqxzyolCRxXaZkC/KATjxUzp
	8Kx6ZUwNHdk2POkJoGy8cO4+MOkQW7brVuJfwbD50JdJ1YgObwr4H/FIppfzCw==
Date: Thu, 29 Oct 2026 11:04:40 +0100
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
Subject: Re: [PATCH 5.10 000/516] 5.10.273-rc1 review
Message-ID: <auMaOEApb5g7PKgR@duo.ucw.cz>
References: <20261028170003.522232767@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l4SxPlqw4x0U+X/O"
Content-Disposition: inline
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--l4SxPlqw4x0U+X/O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.10.273 release.
> There are 516 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--l4SxPlqw4x0U+X/O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauMaNwAKCRAw5/Bqldv6
8pPFAJ0UG2+W92i2HA9cs0SOgACv8jTdAACfaWuFZ8QsRDoZo5uqpovnaKKe2V4=
=IciF
-----END PGP SIGNATURE-----

--l4SxPlqw4x0U+X/O--
