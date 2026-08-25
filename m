Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071E636C5AE
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 19:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787686413; cv=none; b=Q182mkGdZE2c0L4J3lx5Up3kcZH6x6yUc1t95mUuJ4KDVs+2W+vcG+uPBzB/kKsutwvqevL7OzWKXbhnVeqkEfMZVM+jHwCSkImISpnt1ra4iY9YUPR8DQDBDxJmn5aOeoMWiAez9RxTaJbpvIeCZXbHCA3MNRPFYAfOVpbIVHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787686413; c=relaxed/simple;
	bh=H14MQhaaxH8h+XxXzNQ0W3OruEAhuXkJJU5sNMBSVe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YKmpYPx4sJhHQFd/tFRILf/AMIWvLYGbiJlkJds7yMYVVpZM3RvamlpMtkvts6aJvfM7apLdVLYEIqFhPfLPNkiYWMHQFHh6oxj4Q+wvA/CdftY6pNHQ3vBCEh3ZH4hRi55qj5mslFjgzeyIJWL/RUs9qVhUivIF4edrMaW/OsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=gLTPDMPX; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="gLTPDMPX"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 837FA11CCA6;
	Tue, 25 Aug 2026 21:33:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787686406;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=eoKIwFH1OO+mErEH5fqgtgoXSG1r0ZrLBEKb1M8eALc=;
	b=gLTPDMPXiUjQR4tmtWhfPhS34DDXnpOgYQOMlWpJbA37h6ZybvLzbzvw1CApXvbmZVI2oU
	NRlQ2ErD5Je05MmCtwbxVuFqVsEllMaCDiQgpTQoRAhYT1MjzNXueLL9tJTucZKEeAYqat
	JI16c/2bEY3jDaA56/SRrJvGxr1/SaFgfuXKDNnv1lNyTBzm1n1Ig4ClkPqVHsx/Bfxlz1
	JDiiMAnxuMl4KmwbgLcWoMXl2U2YscWaSo0MKDlF1tYj+6KMBoX/yiQVphaozGG1ubLJR2
	IJKDHI0aA5Wnbqu5kRtBJeyVed2tL7rIzdWnLrNv5NsfQyICUYQoOPE+8UMgzw==
Date: Tue, 25 Aug 2026 21:33:24 +0200
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
Subject: Re: [PATCH 6.18 00/94] 6.18.47-rc1 review
Message-ID: <ao3uBEmtkxQ82JGQ@duo.ucw.cz>
References: <20260825132541.887883084@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdTmhRObDYkRTxa1"
Content-Disposition: inline
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--fdTmhRObDYkRTxa1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.47 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--fdTmhRObDYkRTxa1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCao3uBAAKCRAw5/Bqldv6
8mh3AKDD7jGQwHI3d+L9Qklx/3S11SzMzgCgq4VaTY3yaKFgqkW4cMwLDh6YSxA=
=Obxf
-----END PGP SIGNATURE-----

--fdTmhRObDYkRTxa1--
