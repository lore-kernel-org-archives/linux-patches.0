Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1897442B1D
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784742410; cv=none; b=OmZNafqAhhRjSZ2l32xeAec0zWQDfsKeVyShYBaHpJEhuXKu1FZYbWvWlUTKq7dof0MsK8Nks5VLvhXV3vFtAap3qkQZcet+sXQ4S3RPlqKTRih8nI5gk3NQY1nYAAx+GM93l1ky9xhEVdU9/phtpRoFddA2ciKIQlkfO0dtuyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784742410; c=relaxed/simple;
	bh=P7eDxmnfb878Wjsr90/6iUsFNKNNXsEaDtmf0pHtlyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRHp/JmxVW+q/5tdPrH/2aJfkaJUbWsdTuc4xOdOuoA2dh45CRpJHb+pPltCZmglQexXT88MopPc+5PZrcb6OT6wv2iQCYA9pLOQ74MXUqWGn38YoyZfrGJkPLbOEp14BmJBxoZaSUUHlgz1WSN0yWoLR+Q5ggP0xuuUFfbBBqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Ucq1opX9; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Ucq1opX9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 21FA411AEA2;
	Wed, 22 Jul 2026 19:46:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784742402;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=d5Zz9nHvSBYgQFJ5eZq6ghSzBPzRoGa1nFXQHkHo+Io=;
	b=Ucq1opX93vYVUXibDn2flCqITx9k1/s5SKkWu6hjDEvVlHBOffWBTAZmMYQPdkbV5bCJ9l
	906t1yAf/5rot1NE4UXk/gndoF72LAVyEjdNvvoUO+CEJk9yhDfsM9xkN9IZWvJRWxW3bt
	VMxQdW25/9OsKl3X/qMpIbBuYNItiUR6YWRmHP9fuD90ebJNL7xP5aaKKMYHDp9qrjwPn0
	ZSb92iaxYFBtvCJ75NtNPRwBO1b78pnLAS6xvieco4ITycsClG7JXE4ITlb28lzJEG0aLv
	RiYyZRHPlwiCXgj+ww51WIgPU1e+pIbuUUX3KhukRJXbI0U0qqYXqZuFAy3acA==
Date: Wed, 22 Jul 2026 19:46:38 +0200
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
Subject: Re: [PATCH 6.18 0000/1611] 6.18.40-rc1 review
Message-ID: <amEB_rk3JVpkY-d4@duo.ucw.cz>
References: <20260721152514.750365251@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0StbMKygZWQVDiT+"
Content-Disposition: inline
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--0StbMKygZWQVDiT+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.40 release.
> There are 1611 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--0StbMKygZWQVDiT+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamEB/gAKCRAw5/Bqldv6
8oHPAJ0ajg3bQwIWcLMgcnpLmEY+NIGI7wCgwtvk2FAmeY4AbgWCJQrjScPr7CI=
=tse3
-----END PGP SIGNATURE-----

--0StbMKygZWQVDiT+--
