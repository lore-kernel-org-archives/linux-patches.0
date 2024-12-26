Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548E718E1F
	for <patches@lists.linux.dev>; Thu, 26 Dec 2024 20:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735244426; cv=none; b=ZA8EGnC4bJLUtWrI3AKRGYM/NgDigDe86WZ86jtFM0+iWg88YtZE85AXT/yxF59UoYj+fhN7IPExZhl6i0Oq66Q5fD9ROyIBqKpB+iN3TTC1oCIPyztSb5h/+yMMZw714DafIndMqKTVmub/VrHHA/vmcA2Wupb05BUlctHtPrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735244426; c=relaxed/simple;
	bh=fPQR0ez4gvXCiTIyZEtghCpvICtX1OjBflhM3PRGBoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i43UV1kK+zhau/NdfSl+4tpcW1DU4QYog9zMHIdH3rLBEPTmASiLbiszIRdj40QCTVqWvypabgegIgD78u7Tgma5TnK2O2kQ4BT8ouIuEAfKPNDazv6wcx5C4keenCtXsLi/m24aYKkwOd9zzouce52H9AvadlejEPAPZg9lOp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Is6gBKAF; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Is6gBKAF"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2619C10408FAF;
	Thu, 26 Dec 2024 21:20:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1735244421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W7IB39Ejk1PJt0LCyB/Isb4O+k8HeK9yQqrmO4cwvPA=;
	b=Is6gBKAFsPtZosCMNvQ3DEUrj7l3wKdj7PegvZqprUU6FB9LQ8Bzhzu+TlaLve4vaKug0I
	hkBvAoEPfzyT3643xwPAcyjglRflh1xroeAMcAjgbOGm5WjAeSZY7kXqNoIkMKos3X5cjV
	3j8FoT0PBrTYKi6IIFIpIuiHttLoacxXX6E8TtPjMSrl6gYvdzvBJGz8UxNjAKIjAFgh5W
	jXmRqPcRhn3olLGnDl/3ini0FmShIfYdoHqsyIxHeAVgpSGsF8b2+Ph4WSx1q+B6pQayiQ
	XBvaEBmAkH7rppAS2Tcz+uSrafO0lHqug4rMx0sRxiF1ArH33wC8rKLpH2GFaQ==
Date: Thu, 26 Dec 2024 21:20:15 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/83] 6.1.122-rc1 review
Message-ID: <Z226f7aroV3hbTEA@duo.ucw.cz>
References: <20241223155353.641267612@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s85/vU0qclDxRNaT"
Content-Disposition: inline
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--s85/vU0qclDxRNaT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.122 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here (obsvx2 is test problem,
not kernel problem):

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--s85/vU0qclDxRNaT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ226fwAKCRAw5/Bqldv6
8tXDAJwOjE6jDxyfLxa5SXo+AbCLstqYrwCgtmsCOYRmyzA04bRBxyFHxIqhsM4=
=7oNc
-----END PGP SIGNATURE-----

--s85/vU0qclDxRNaT--
