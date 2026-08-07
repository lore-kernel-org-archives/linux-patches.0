Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAE6296BD2
	for <patches@lists.linux.dev>; Fri,  7 Aug 2026 18:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786127522; cv=none; b=SoDoXravJ4TdAMhqzuhD861PtMFs04UBc15iId9zOBfnUpMR/Fdg+StrjHRWCVEo7/efxO4+VfLRWkDp+qQ1GOgijrfGw0ieEUnXCcmBInbu8uFXsjncCNw/ao6tRIhoiYEgOzJwakvort4limCq9jgK0LPnlz2EZiEH/B6vy0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786127522; c=relaxed/simple;
	bh=e6lE6xOkpypg7C3aHu53jW1UiIOJNe3WhEzW+/FJ1jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HAZE348mi7M8n/wM5LzHMUh7fi1nADCcFSqVzJnTemjTFSD1/vvBvW8gtpzV6RcA8HWppL17ozH6DyYTl4u5rkrjHyKFghx7Ye8tM7jbHTGclj41LV+7nBNHPYzqsuhv3UGwD0EbFPBpqURY2K86m16L7escURyfnCVFFniS9s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=dXs57/fC; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="dXs57/fC"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B6DCD11B179;
	Fri, 07 Aug 2026 20:31:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786127515;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=yz5Rq27V2mz+LQyM7PhU4DLyYR3HxLiMs5RIxlHfTEM=;
	b=dXs57/fCsqpQRuIew7nM8jhGsIeXKRSu0iJF7Ccpa2/W5Vr4wJR+A2eIakqOrGHhRzOYK6
	UCLQRazRuNoyqH0miEf0AEYV4HGui0EZsPjq+2CrPZ/tTfK8Ks1whAszP28rXCKErSbx1V
	6q75Nx+Y+IQPCQdcYQmgxvsVOwPZVbAgGmbtB8VJZCCj0eWlM94EdvX2abaFNsBsqg5Vze
	pzC7l2kQsVTs8cKXM/5BElDphZi2olfKie7/VlTd4cqB5zD/tB5ulU9mNnYRfUIDMVfohG
	blPAsuoCdwcbWJ1c5J5LqNi0mHCKNMApHNG/AtRS6YNAiWWWlRqwB0w36yk7rQ==
Date: Fri, 7 Aug 2026 20:31:53 +0200
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
Subject: Re: [PATCH 6.18 000/396] 6.18.44-rc1 review
Message-ID: <anYkmbizLqsy1xYL@duo.ucw.cz>
References: <20260807143424.272339768@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BVdumeJxyoPtNTNX"
Content-Disposition: inline
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--BVdumeJxyoPtNTNX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.18.44 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.18.y                      =20

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--BVdumeJxyoPtNTNX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCanYkmQAKCRAw5/Bqldv6
8rHPAJ9QcdAg/yezlAmTTvFyFPdG5n/ZUACfdb/5jPBgz4uwJLPVY0iiR7xcVlA=
=c+2W
-----END PGP SIGNATURE-----

--BVdumeJxyoPtNTNX--
