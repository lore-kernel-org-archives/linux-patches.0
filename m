Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AAB33ADB9
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 19:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787686467; cv=none; b=nB49dTzsq5OeR75pz2kowfYGhp7TlLY2NrrodaQp77lXbYUwrhuw4VpPFcGTkJfF+f3Q+1n6pimsBeuiOYejWR9H1dWyMFLcfVryJCdt32E3T4py+XI7GMD3z1T2Sso3wsYS12RrpOSNp2PjndWSoGuB2RIJgZ2uwW+6tPiYnqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787686467; c=relaxed/simple;
	bh=PzXgWonmNyFMLkL3aHm89dCp0rGBOsiHC++nvWRFlNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWhLZU4FsZyZ2nS8Fbw8AtAQif+8lljaAMqixX0DjS0RYoqW7C8GtAcdVt4m6S9uNtgx6Ykccasp1jR9YvKthm1dRN0dF1ygcnWKATnt6xhyPXNbj8MKdWN4mJ8oSHQKPJ2ODq08H4oYS5gOSDGViQ0JSlFOP9BL9sP+tPg+mhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=B+XTXmix; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="B+XTXmix"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 30FAE11CD48;
	Tue, 25 Aug 2026 21:34:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787686460;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=HRl9MB9QXm/fiPgyTNVD6i4Pqj7Z920jGLtXlGbHxLw=;
	b=B+XTXmixOYTbkdM2cv/5jz0a6jBsYZLhd9Er/u3+t0GCB/6NWCpWkrl0kmf3poMS0gGEB7
	uGFn2kY63DJJ+41SXAZnuUQnN+NyQXMPUNRSsHwx6RvRYErDIv5cCYe+OCix1o/UN3KBaa
	09YOxuuIQq35PqQNJzdGrYZ4/4a/lZTsq2UuvgKsMyyMtkS/tgboExM0E3i4iKDmD2Ewnp
	Uts8wIf/RIAhALUF+zyMzF0xX1dPgnM3P7NU6Cw91VRb2pU28mVTeLGcO4T2xbcEpl+2OY
	UylUsV+zNLrl1tKadZmwhHGANVV7clukV+gLn1NvHFxNgc3QoHCFVO4Go8KTzw==
Date: Tue, 25 Aug 2026 21:34:16 +0200
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
Subject: Re: [PATCH 5.15 00/76] 5.15.218-rc1 review
Message-ID: <ao3uOPXs9_3tSs8E@duo.ucw.cz>
References: <20260825132541.568214149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yjJT44z4MF1h7bHN"
Content-Disposition: inline
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--yjJT44z4MF1h7bHN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.218 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build problems here, I assume it is same one as elsewhere:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2789505612

Best regards,
								Pavel

--yjJT44z4MF1h7bHN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCao3uOAAKCRAw5/Bqldv6
8jZOAJ0fkcvhw3NC8QOfhVpRs/a/KybmNwCgkiD3luTgM3JcKxPdEKHi+GkXpLc=
=e2VY
-----END PGP SIGNATURE-----

--yjJT44z4MF1h7bHN--
