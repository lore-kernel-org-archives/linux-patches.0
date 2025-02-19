Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8366D2862A1
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 10:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739960706; cv=none; b=Xr2JKtjea2uP0gTvKZAU393+0wKcETe4VlL3hfsRUBK7e2ts8YvT4udGnwBYiXb1l3xfF/1fI5ovLCPT/37oYv3qZtGXUPpWzI5h01A/LCVmTay6zLSyeQvzLKCr0Kx6Q9wLNynLHQD2TeeFQfmq+aTkIyg6EQCCCMhLVEqp0DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739960706; c=relaxed/simple;
	bh=70xw9/zk6se8hKbZVVs7psYYypJwFKVOXlbDMO4NNLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfsEWeCKAax9N4+zDuC56aUQpNwxAR4OXwJHFfFb6kF+F/uDN8dr/Uw0EgnZt00fPjgKhI6HJZZ7Lburr5PQUw2gMQZ22alUwR17/WUlMV9YjqixNCsjhK8IAcAiIxwG25XBN7Lla4fbMslQbgCOBI6R14UyDxHQW72QwUDRb6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=OEfeN0fw; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="OEfeN0fw"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3905D10382D3C;
	Wed, 19 Feb 2025 11:24:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1739960696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R+P3f4KN/Jh3rG/rD8+HRKO0VqzZWriCsR2W/RI9aUE=;
	b=OEfeN0fwBN6LCHPHGEXv00yMdeHpV7M0J7V73vfQiPWg3+ExFnjZ49jJ97m3AVByjqrOeP
	/RShWpr3bh44xiN/rKm9K/M3/VjJStvsf4SJZcl1u6eS8kN5gaUB5nT1zuBcj+CAM+9NL5
	10ECkJH1pJ9I65ztLtFb+Niw/O1UGNOm43KQIUwe6Vmjmc8zxcNLDLLjN0hyszejk1Iynr
	H7uAKcV8R5kse0tu/BhVyf1tiOpHpyLzwOg2vmtLMQ7MmuWTreOU25mCw2RBzg9gbJq/Kz
	ZWNKeCyG+L5CtokpKh2ng+8fb7uyiCwbjgczInBVD4Jpn01is9Akqlf6HdHmVA==
Date: Wed, 19 Feb 2025 11:24:48 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/578] 6.1.129-rc1 review
Message-ID: <Z7WxcPi+JKuyJsds@duo.ucw.cz>
References: <20250219082652.891560343@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JcUuyTE4Uj/fkr9+"
Content-Disposition: inline
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--JcUuyTE4Uj/fkr9+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.129 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--JcUuyTE4Uj/fkr9+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ7WxcAAKCRAw5/Bqldv6
8u5oAJ49aUqdpfP5A+PgynAWh+GzrsTC8gCghu41czmzQTiBd4R1gGZxUW/LtQY=
=upo+
-----END PGP SIGNATURE-----

--JcUuyTE4Uj/fkr9+--
