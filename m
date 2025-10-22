Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EA43491C3
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 13:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761138453; cv=none; b=pB9aiFddXubx2XQtWIPFr4culOkheFV0izP0N7S6joE55MzdCHvj94nx8fBqCrCIVcSoIZqdnBh91A5kFCYmsc3ZIn92lHg6FPSOqSkAoWgJv8dleoef3fx8nQ02is4ym9eA1DhHTQJBz/BDSjXYfmls6Aqt7gfKYAqHXdqbDWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761138453; c=relaxed/simple;
	bh=5l4YIxzcsZkjlPhKWCLqtRWElD9XS4GZuoGPn/+2o+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3Sg3f3qCI9rkxEtDFStWGhOZR/118cDTIPbs15SEIv4tCmWRRRTYoXtD6YSF7slLMqV9pEYZ3AqJ0CySH5+rjP7HTWjy70b/YFbyIXxwvoe8PzBrkSE+dcVBSHGmttBDNCEa8qKHeJ7aQwDu+N4cp4OqmjlQeZerBtMOY9ldBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=HH17g4vu; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="HH17g4vu"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C9CCB1038C10E;
	Wed, 22 Oct 2025 15:07:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1761138442; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=u7FD/pekiqcAC48IXTFp78ySVwMcroarl0d1MdlzkpI=;
	b=HH17g4vubYuTQhiD2pnGhHiHuNTBNF4p7LxRuMCJT/ROKalH8XOldLHSbCk2dNXuVy4L1O
	mHrPxSAB+MJY5BVS8KADoOiQwCwVzoZA1Kkm0aDSMUYh1sEhI5iMwr6wC8p1VslAAMXmvs
	wB40ib7GV+xxQMsXgbYGXApV1Gf5BJibpNUpIDByndQgKZDP5wIh4YNJhy+BfyEUUmmqbG
	Ydp8WA/kTqa3FXfyZPK9X9PyeUzG/p5zuRrIFwvQxF6WXS+9Op2/O/nPkDoWG1aKTP788L
	agUqTIKEHitzKcT/d6KGAwMQ0tgftd87WihNa4j/W8+w8zpPceDtaMlWee9dAw==
Date: Wed, 22 Oct 2025 15:07:16 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.12 000/135] 6.12.55-rc2 review
Message-ID: <aPjXBPcehgzTNLu5@duo.ucw.cz>
References: <20251022060141.370358070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K+R5SPhWy/4AQ6XK"
Content-Disposition: inline
In-Reply-To: <20251022060141.370358070@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--K+R5SPhWy/4AQ6XK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.55 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--K+R5SPhWy/4AQ6XK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaPjXBAAKCRAw5/Bqldv6
8p0OAJwJx1Byzh8oNOYf5/ljhW8m96v3PwCfSb1kliLtHZodZZrj3uMqdVU6LC8=
=3ir4
-----END PGP SIGNATURE-----

--K+R5SPhWy/4AQ6XK--
