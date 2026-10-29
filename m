Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268439;
	b=ZMqH///jKHRBDs324caoC4lQjlhG93GYD/6BWWYQwlTpJmv80P20pPjJSvPDRD8+IMXB
	 TJs4QasOl/MmBlZnWN75U9BMXh3IRBoXeLmScLrG4XfHI0rlfaC5jeiywwHFJFm1iErdh
	 zyRljJPmBz34EAFXFfUrGW8bWn0UdBBvsvK39BusxszoxW+Dz8nN5Yy6+lChK4etn+EN3
	 zJnle7qo+mugVfhfj1rd2YHRomKauKrdTkfCWoQAO6gZMVEDSIWJTtic9rDvwprlaA6BC
	 w3QbanbFdmatRSmINKxDhUfUfY7HOf5556dhihJB69UtumLh699FFNyQHnr8iZVgfkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268439;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=SHeOj9EU08pvnKNJv8tinW5eavkMi4cwXF8VGwugYmI=;
	b=wqpD8akd4QgIVkG+cd78YIqsP9cKFggaEHGvbRAnAd6xeeQpuAINeCm8nAfzplPq/SIa
	 ONi06lZZj8d/QVrXZOxRqfs7BpXeDfyU4GhTF0H7NqbdhQ46BEjZaBfZ+CV76WgUuU38q
	 uKZf5fbkDaaxWZs5+zzqiTHlPKlgOQO2A+oNuAqYnE6P5OK7SQRhoRpkdEfPSaKl/Yq1a
	 7sut69mGZlYcCv2LdCDb1ZaroOzvTYhRegqYWQ9aKciYyB4E0+1Xb+ad1gH4onyDDTIT/
	 jYoRXis5/Chtr2EsCqW7MSCDPbpmF4xDHiUc7+UAS/q5NyaPRIRobrDKz7QmIDXCGBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=YfPvdlWJ;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1535606A31C
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 10:07:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1535606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=YfPvdlWJ
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0B52D10A856;
	Thu, 29 Oct 2026 11:07:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793268433;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=SHeOj9EU08pvnKNJv8tinW5eavkMi4cwXF8VGwugYmI=;
	b=YfPvdlWJMA5+0eGCpa8JaoRGxSNZxkoo+VJDR7N+k9f3mI3bIy2XdaRwOiDE59/QExGPqK
	VPLTSZGKezBHppdQb2POe99cujFkaYZmsvv1eG+ujgj+LIUvPt46BX7ZFxfgJDq5isohiF
	Fy4AiP48MK/3YNfGKBnjACRpNVqqmT+8Ngp+BZ0K/l9GBIRJjrRZZXJ+YlMZiVqbtg7GbA
	WtxzW+e433Gv9Sw7weo/6CxdCVT43DKYiaDZZRxVilHLwEj8Tapr+jIFFXfMcn4SX+XT2t
	K6gbOrBn09fC8/Cx/JdeY5JaVO1zwBQBj0CUEHsUMtCrQF7beSwPe9bD2jEQ8w==
Date: Thu, 29 Oct 2026 11:07:10 +0100
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
Subject: Re: [PATCH 6.18 000/109] 6.18.60-rc1 review
Message-ID: <auMazjDO0WvWm8uY@duo.ucw.cz>
References: <20261028165942.357251485@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tfSNFCh5iCtzx+sO"
Content-Disposition: inline
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--tfSNFCh5iCtzx+sO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.60 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--tfSNFCh5iCtzx+sO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauMazgAKCRAw5/Bqldv6
8hzzAJ9h1gaLMQv2zUg7HePRJqTKQJPXuwCgq1YNniIcYg9kQPRcmLISelziBaQ=
=fr94
-----END PGP SIGNATURE-----

--tfSNFCh5iCtzx+sO--
