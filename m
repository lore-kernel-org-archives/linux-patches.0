Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F721F3B90
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 20:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742932978; cv=none; b=PNheV/pdbDhr1aWbFgHypz7R9MPM6qMmo4j/39UV+2aI+3S2ZL5lsWTZsqiaDEt+fLMq6XOE7fwpLquMnUc29MxIVNHEsMSvKDbmEdOUTi6pjFISJENU6trbz1JS9aQRmjgr/F+UHyLowZyrWuZOV7gptpk10UXunxls6fxMuek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742932978; c=relaxed/simple;
	bh=cbmLoEWlZon0vzHEOJFV0hxaxKAZ97oF9421UQ8WQ/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJEryTDFi7pqOnnfLF5sElg+vQi06us3dZP2W8wuyxn5ss+3ZgSza/qfe3QTbM0SnNYLgwbnk5yOuzpYxOqERnpW5Fb+BAL0idvd0MR9noQ2OPHxQMnfpS8dCIAhHRCQG7J8woHZjc2lHT3xyd2nIqhBe7QH5Az4dcC4LeNIHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=QzZpH2fj; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="QzZpH2fj"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1E2AD102F66E4;
	Tue, 25 Mar 2025 21:02:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1742932968; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=z0p1QvEp0YYkteZsnU0p3bMImz2zA6MjGTdNDg5orFY=;
	b=QzZpH2fjDPVo2JMxtNJzov6a9K/NxgG0oLz/AkRQJRA21WfBXvywL2kRXKpROqcoIIjbrP
	u2KozEFY+TsmM+0yldrabV0l4/EKinn+UvV29/X8tzpJmNIVL8KJRGv/BScUsnEkMXlBJd
	7PTGzkMud2Vw1OctGoqeraP3GuV3ZdL8Qjy2XJCvP16v77tyUXAVqIS8mwBcDx0cAVINMh
	SYAyOfUs67J/jd/RwhvDZxVKJhyR5vUJ2lxlyIkWFMUNy46y8CkkNds1l/hjVjcjTlN1zx
	dNFVFVKRT5viC51pEUF13ywrWXk5meKkdCNVJPm5PXFrOdlKC1yN+FeIBdBPEA==
Date: Tue, 25 Mar 2025 21:02:40 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/198] 6.1.132-rc1 review
Message-ID: <Z+ML4M4d1m4vALAE@duo.ucw.cz>
References: <20250325122156.633329074@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xSy771ToJk+xYngw"
Content-Disposition: inline
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--xSy771ToJk+xYngw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.132 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see failures on arm64:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
734533150

for example:

arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
(phandle_references): /pcie@f8000000: Reference to non-existent node
or label "vcca_0v9"

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--xSy771ToJk+xYngw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ+ML4AAKCRAw5/Bqldv6
8p1lAJ9V2783203ZILWiVhPl3zpsOj+l6wCeM6euQ30+Yw9LZ6PcMuJbyyhdtjg=
=gU2w
-----END PGP SIGNATURE-----

--xSy771ToJk+xYngw--
