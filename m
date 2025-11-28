Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD9432863A
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 12:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764332472; cv=none; b=GzlqNfYje6d6JddkJOn1vgPULplqjJZtuhoIylxUjEWmaNhxBvQ/mHMsV2NqeNyl5n9axU6u9MLYnHbaLmWvA5OgzSLqthKuFPwDq0VH/5crAvcYyoMmSP0wuxxA2n8f4i+RFf10P+rROE8ODtgQnRd/KH73/+A7opq5UU0POu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764332472; c=relaxed/simple;
	bh=b0oL0GMNEj0eB40IkLvv2MoT0U550GPqJyuWrczXWrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAnzhFbt3fPiRTsakAyZt4g9tGz3sjArwwMkBTsyp7fZcwlvqI6TO1PxLwexUcpSTwmpary6jwcOGLZgAS0Oc9EX7SqE2Kei1qMhASQiPTOuf80lFIONXZBYr5Ul5LxtmfyRxHhHob8LWB+nUc9uIt161Wi7LXBQ+cUzRblsOHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=FBtk2Mja; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="FBtk2Mja"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7C9E71038C12D;
	Fri, 28 Nov 2025 13:21:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1764332468; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=dYqwJK5y7LXB1ByH5KC65HxQFJ+L4GkzHhHA1I4E1xM=;
	b=FBtk2MjaJxseN05cIPqXj4LOXJEKcbGd5UyotCMTP8JGboe3aWsK9xwO8GSZ19K3Rc3h+R
	EUyzddpUOCFS+uKHoLiyCImmEw07Kh2XvEWNPVUam3Vn1LNAR5Bqex1PP8Z7FpMhaCTdUv
	7X7lbklIUE8CsoIvohktCayefqY+Xi/78+1SZktD2LYUdZ9gQAOyJdOxDv9npMl1h95xjj
	qsjzu2j8RV+uiCY1nZ3A73IHM5pikwQAdni96DAU96cIJMvM99weCA6hjznn77IL3OaTGS
	u78NIEh3pd4iIcLCCKES9hPL4eeeIkCFonrmHcd0I/+NvOzDy48pqsl57h87+w==
Date: Fri, 28 Nov 2025 13:20:56 +0100
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
Subject: Re: [PATCH 6.12 000/112] 6.12.60-rc1 review
Message-ID: <aSmTqDGkaY62enXO@duo.ucw.cz>
References: <20251127144032.705323598@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlZRWwjwM4xIJ4gG"
Content-Disposition: inline
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--UlZRWwjwM4xIJ4gG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.60 release.
> There are 112 patches in this series, all will be posted as a response
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

--UlZRWwjwM4xIJ4gG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaSmTqAAKCRAw5/Bqldv6
8s6hAJwKpTSLcpB4IAx/ltWzjC7IJqCf9ACeJfyfXc6e3OplIfJyvjLKLcaP2eU=
=hvqC
-----END PGP SIGNATURE-----

--UlZRWwjwM4xIJ4gG--
