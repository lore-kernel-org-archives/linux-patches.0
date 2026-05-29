Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38D9348C61
	for <patches@lists.linux.dev>; Fri, 29 May 2026 08:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780043356; cv=none; b=qAvNpyUvuqG8tJkh7uYK5l0QMWxCRllChQnD3BdcPFir1yXhVqxDZqLiw4rSEzyK9VtQGvhT/PjxGaV2nhsRz/zBwT7yWvUrW3hp4CcN734sT/FsAhAO9UeoRj5aU/S1cevOk5fCVyI8yWkIfTJ9FIgVD4R5HU3PxtFInZkos+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780043356; c=relaxed/simple;
	bh=S52jU5dbMzoEDr1Ks4z1FhHQPDmpE3182g8P6PLOGQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gm7blii7ZSvPTb9OPzufgCfkzVV6C47gSfNphZWmbcF8swNGdgp3Mus8jOmcTF53B5mHyPNrrjl5CueeK3HYNxIWp6X7WzFpabE/8DD/RwDjednbwvlFnP80Bw5zcMTaFdgBf76rzflUBXQMT9QJaowCmNH6+m2Y/OW9ixp3aVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=iAuoTFe3; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="iAuoTFe3"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 18DB41143F1;
	Fri, 29 May 2026 10:29:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1780043353;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=98SNgItw4uMA3pnPyRwjxxmJwMoJlkSxGVv2NItBoZQ=;
	b=iAuoTFe36qDO9U5KBbZ/49S+XMGfGXgAPl/uhDh0nQm2VPU5Swi3/ZZd7YLgjUawCce9zC
	4Kz4GYNqJ0CpVEguVPYkFooTm1gIL1q0KcqsYfn4seyf6ccqXiozFgDelp3ayJArRpejz+
	sdLDEVhNhw/FptoU++SrV97WfpZ7W4/+vElxOq5wbRIOcn5FhYc7XfNPYEFAtStXjV7vaW
	kSS2jpwUDBL8682YBZTYkkIJJQM3QsUXMG+uOZD+OTn1lLTN9Z5kyBMK2eTtb2aAPSrPaA
	OkBIThJ8wC8oZ3qw0YqbeLwDb8/kHjt3HgnMRam8ZmZcL/BuVa6/+BPToQ/JoQ==
Date: Fri, 29 May 2026 10:29:11 +0200
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
Subject: Re: [PATCH 6.6 000/186] 6.6.142-rc1 review
Message-ID: <ahlOV7Eo3UXTCqS8@duo.ucw.cz>
References: <20260528194928.941004471@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FAMopUN2KCf+JaFk"
Content-Disposition: inline
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--FAMopUN2KCf+JaFk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.142 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--FAMopUN2KCf+JaFk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCahlOVwAKCRAw5/Bqldv6
8qByAJ9SF9sWzd1YJFADG5+kMs02i00ZvwCfRoPx8Le7bixi5kWu6dY4/IFIDZc=
=I207
-----END PGP SIGNATURE-----

--FAMopUN2KCf+JaFk--
