Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC41E4334BC
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784742611; cv=none; b=bq3MzmXeQMULs8HQMiFrNjUDS+9jcEqn4isV1czWWxJVhWgTjqKv0T5Cy2N5RRQX+fwXBsr9GEKppJYS7P/Z/VSKdSNlvRdy583uL5USfSHiyf3JjuZqQhYtGNXTuBIqsqgpAntga3wyT9qnssoD7Frm/ijMe3sc5XA06yZhrD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784742611; c=relaxed/simple;
	bh=oS4FyjUQjC1QIdzqQ98rsP6ToP2VEdNACG+sNicu+nQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q8D19AUQjiSWEtCyx8jvDOxkT564a2ySvzf3IF+h+NpKVPuqcXmKP5d2ZLueysuHJUOk9rZJo54tXVQdzgPuta6yIv1PtTgJVBXcz4x5oiymTaTxnK0fFe0g+SutJFXaepyQIVVpJdpzEg6USRv5u9ZAeKo85cmJY+kiRhA363Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=cQ8qAA73; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="cQ8qAA73"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 302E711AAC1;
	Wed, 22 Jul 2026 19:50:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784742607;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=wohdsyzBQC2bXeDKsIapCyk8wAlzPBc9fF/eeLT9fGs=;
	b=cQ8qAA73qdaODLvZSLBUgzoTFz+ShVor+1Zu/d/xC1bAGh8eFmYdo6an2Jbr8izGABWhDL
	VnukzabEwbO1MfgVbHwpS5gxU+l7QRFDgTT/vB47vsCH97oCXJpg1YS/kyprwFH8Laty9u
	YWws+sjLUhVHOeoAZRNZs89FcSnTZEVOFAoEWDMGWmVRueV++AMLBZApJ4IBIaNS16mUpz
	0gp8+laMlif6kFNTi8J9UgFdqeykwk05YNrtSIXsJ6NzekzI6vWJLZLT/lrWpMpltjyStD
	pKNddz/Fs5jXXUMNJPtk4XSWH98f15AkGHsYyx/VlmclHP5yl/9uMB6xUvZ4Mw==
Date: Wed, 22 Jul 2026 19:50:04 +0200
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
Subject: Re: [PATCH 6.1 0000/1029] 6.1.178-rc2 review
Message-ID: <amECzB9IgFktppCJ@duo.ucw.cz>
References: <20260722143218.909123637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ecRI/Gm2f01VbhSZ"
Content-Disposition: inline
In-Reply-To: <20260722143218.909123637@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ecRI/Gm2f01VbhSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1029 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--ecRI/Gm2f01VbhSZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamECzAAKCRAw5/Bqldv6
8sGfAJ42r4bfzDZNY3jh/9dOj+CJ+olyOQCdFICnSbJsR8SNS8MbMalgLKy2sJI=
=6e1u
-----END PGP SIGNATURE-----

--ecRI/Gm2f01VbhSZ--
