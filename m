Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35297AD24
	for <patches@lists.linux.dev>; Tue,  6 Jan 2026 22:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767736857; cv=none; b=rQAEVNQCpuOUB3lhWDc5YjEHX+172cXs1xrUBozoy5bdZEG3iizpDCtS+l1jttCrFbtG5hjwIZUk+gKw+CzrkQBK952Sv5c1aeenyFGE5P2aScb6vNO4QUdsJVPLLM99INb+gAxeO7A+YDRdzv4hbQdx41fd94U7cJP882jykHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767736857; c=relaxed/simple;
	bh=YRKtTek2+inrGzBRv2RV95wS9JtzB0dD1aPupVTzrd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ig2TmBrJhbZbXxvx/2vIKg7JgGD62HPAx5mMvL/I3TN3dHlu2EAFTfVw4EILQcqyfrKmpKib6QeNYjK8MguhsHTqzDg4Folk3G96sJU1nCFbMcdkdkNTxHmlnnbT/TuD/K3rrjeL0aKkULp4qaD908olcgq5Tvc0thMutYMLT9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=JaqIycP9; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="JaqIycP9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0F86710C890;
	Tue,  6 Jan 2026 23:00:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1767736853;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=YWx/4LMzVrCttbjKOQK/HYWV0deS1F5i1v5X7ivA2/o=;
	b=JaqIycP9ppvvmqnKwatG2ZJeW3foDlYuflVW0UVQf/KyQqM8ujaXXTCp6dBLMFb+t4VRvH
	JnVWxeh4MdhbUPPKjr6JJhiecO3ocoO+hbkkxTMr87f2uwhJ4hmLrd3myX6EVMqUtqFACm
	LjbMtnKW8f8LojIOUtH+Ekv5qR2++9c3JghRU4xtVWhkWIsknEWmIH0/mUbR/eBD2AazIJ
	qevLi+9CLdP1Luk8q8ez/wxKxGIoUg2V2v6k853VgJySKTTz2EvVguM0zdbESQAh34+CfH
	XazNWGaeiWwvoG9ZCuNB23vLiWdexOymqu/s6YqMBM8GnTAxGiApT8Hhi9tI1A==
Date: Tue, 6 Jan 2026 23:00:47 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
Message-ID: <aV2GD98DGS7ZGpJI@duo.ucw.cz>
References: <20260106170451.332875001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GTspD5QIRsZOpcuL"
Content-Disposition: inline
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--GTspD5QIRsZOpcuL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi1

> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Could you update my email address? I'd like to keep testing and
@denx.de address is no longer suitable.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Thanks and best regards,
                                                                Pavel
--=20
In cooperation with Nabla.

--GTspD5QIRsZOpcuL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaV2GDwAKCRAw5/Bqldv6
8jm2AKCnRZjF2idCFYTvzU7y/avT0rM58gCeIKa76DS+Xlsg1Ds+HpCe9jjGkzg=
=eLJt
-----END PGP SIGNATURE-----

--GTspD5QIRsZOpcuL--
