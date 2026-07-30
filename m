Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282A13921D5
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 21:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785448238; cv=none; b=M1ikZfSLcisAc2Tix5tLO5RW16WGLTS3mPnLuq6KEk3iIuT7rBA7iFzYGNmjkJ9a4aVgHqV7357uYBN/+AcIGEGVhEfAkwauJk7/lTkC9u/ib/FbZ19Ezb/RuKTKYvd4OxEWhsUJC/yAfFG5j+oBYZPWOb3IBVddQ4AxfonAD3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785448238; c=relaxed/simple;
	bh=1ZFBIu3DrfM8rKLTQKAjAHV8ojdHYuMSzs72BD37Vsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zx3TbOzG5utV9K8IgC6UjhuSu5DPbAbIcuSN+ua3rudcRfgE8nacK9TWiXpK7TJ2s4AxE9Ls70T9qtEx8fTI/vUG5sppBf0hKPa2imXLv//FLv7LWX57s/HyhL+s95Vqg9uRqklG9nN+uWmpU/NLTz2fdDbiSDdaQTHj+QkFuNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=L5ravysO; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="L5ravysO"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7D8CD11B90C;
	Thu, 30 Jul 2026 23:50:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1785448231;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=QiHp9GVabpz5W5cs6PwvD10WqJC6mxaHlDcQlV0M50c=;
	b=L5ravysOu0l7GYgK7YGpT46pQs4dErmj/EUF7SAqpn+bHpE+ZeF8GjvLKqvm81Mbw+WAbM
	Wk/rFwqBAh/fpPJLNjU/KSb/sP3lbpQ4FfiTLZrQjl4443aF0GmIgrJshqYFghbJxyEIo/
	qkjMb//QYSBD9yqdtCkj9Fvd4DevqyCvVrjNjgBQl/MNAmbGuk4WJNISCF1hUlFLw+eL1x
	sgqd5wX6DDbZHNrjC2xAPhtMO8Yhd6zdqKN5QciycT+SuG72/RzsK2idvFvdeSuDItOZ6G
	+JYwdpq1vQw89xHFEtGoAUkm70rlhuZnMgUUxgVX0VnmJF4/L98jByYJu7+eTQ==
Date: Thu, 30 Jul 2026 23:50:29 +0200
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
Subject: Re: [PATCH 6.18 000/675] 6.18.42-rc1 review
Message-ID: <amvHJQ9hCCrr_DXw@duo.ucw.cz>
References: <20260730141445.110192266@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/kZwxdxaGGxux29N"
Content-Disposition: inline
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--/kZwxdxaGGxux29N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.42 release.
> There are 675 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--/kZwxdxaGGxux29N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamvHJQAKCRAw5/Bqldv6
8jsaAJ0UAVSm8INxif+oMiD9y9n1osbOSACfeOYR1F0NNmGnGtjpIVYrPXauIpM=
=KxPg
-----END PGP SIGNATURE-----

--/kZwxdxaGGxux29N--
