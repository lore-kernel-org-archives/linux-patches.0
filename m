Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAF82CA8
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 18:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736187772; cv=none; b=pXOmVFKOOaWhcKOSFIuAwT7fuC5ImWPZfE8jQQUx+KyozGEnEDol6lh/K4f3DLlj6/LzgJsMFSWZHaaF53eYwNp4WY0t3o6amx1sfvJtxYVahngBllKf/X5+cZbaZtUA4Z2hOqiJKmV0v6WirJDD6axxk84qnB1AVb4yqWx4rx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736187772; c=relaxed/simple;
	bh=6fVVIJvufW+vKiI8jz3AXRtxvl2dtjC/t4p7tY+CdI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UUmeet/S12uHJrktpSudfBLSisnl11ZcT+6qoqS/PNkh09oEOUdZcpOR9SE5Jvs9/gbCvIDtZf9u4dUJnRCqqi6Amt5yJHyDcg+kXnU3BJBkJWEy9wBQsOI7gZw4EcrShew+19EXgDz8+uC+/fehTwlwpOmiH1l1R+CoCErS+Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=VmNyPYXt; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="VmNyPYXt"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8564F104802B1;
	Mon,  6 Jan 2025 19:22:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1736187767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YkrAsaynoqKprotKM+90ae1/Ujr6ZtnoA7a6bYE1bEk=;
	b=VmNyPYXtShH2rEJgsWGCk4GgH1XwTEteWm2tH+DJW84v2n87aBHy2VkSuyyOMuQ+IkzPZZ
	ZWiQmhODMVdZbLdmxGsKmSvhKHZtEWYEUqR2ie14hGdSPULuiBOEXgmrhGqA+XLnxlOF7E
	uQg+ghD/u5NHQb44wmwKI9q4hODPIau/WxERNdwhSzywvi3QDJVx4xYrxJGCIu3qN0Cjb1
	0KKi/qqu1m9lgXDb4SXMXNyj4s2kvlkHVtB0pGTUO7O8ABud1eDKlajPCRyMRzUWdpZUo0
	2GQwRbDu1wRi9oynws37kFRicNJjNNhtqsJwW4e8j4+iNJzIgSrZa5J157beTw==
Date: Mon, 6 Jan 2025 19:22:42 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/81] 6.1.124-rc1 review
Message-ID: <Z3wfcmgkJhVqVDJJ@duo.ucw.cz>
References: <20250106151129.433047073@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sQLteA+jHv2v4oWw"
Content-Disposition: inline
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--sQLteA+jHv2v4oWw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.124 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here: (obsvx2 target is down)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--sQLteA+jHv2v4oWw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ3wfcgAKCRAw5/Bqldv6
8imzAJ9VHH0ML8e9JIWPxGNuGQrfwbmQ+wCdEqBM7RfDvWoWgHVf5gHNKTWmsp4=
=7+S+
-----END PGP SIGNATURE-----

--sQLteA+jHv2v4oWw--
