Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2261D39021B
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 08:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154328; cv=none; b=Ff9E4mnhKRiskONegLiM6UpmmTmbjhTJZVzhglOffZXRW3a9d4b/xVoxBMjVR/4DUlN6tSoYeAesrbnLiSQ0J9WZx+HHsuZgvkM1duMP6bHoZ/bNaeh4AMcSSjhxTcnLZoGePgjZ55So4YKa0gS5dC8QxbM1AKsDv0qj6HH/dAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154328; c=relaxed/simple;
	bh=PR52RNJl42WSha26ED3XT84RotR+zfDxRlcRSD5g/kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eobpQNSopXPADBNrQDfrAV4KOBaUGFSRdfddcTX+yZPEKZdeoTKteJQBY2dy4AQ4V7PCM3WD6d4a3Tu/0nWcXRg8hMBRI6jkbBYCthErGVA6wwE16uGcHrc3PsWfyTFDFNCEhv0SAs+MfhlSZbq1MkBzyoQq+7OcmKX5MRH0DP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=RFkYHbue; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="RFkYHbue"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E5581109A14;
	Tue, 14 Apr 2026 10:11:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776154323;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Q8j1exTZKRd3Vx/on0NmMquSMKYdWkiCS77BD30h6hE=;
	b=RFkYHbuew0VBjPh2ZIBcoy8F9vqMQZnIUzZBENBbbUL/VHIDjqnZlPmplXwzvitbxq19mG
	kmTTqprE0fAmEvc67jmJ9cEDb0B2uj2pt0cGCdYYqQyzjCzFDQP6kapBsXi6KdzPgCs+ac
	J6cQyHmQQSbmnDsWREBqNySFK8nXJTwMPYdsH5Sx8jGaopB4YF7Z1nduHS/AGc6dighIeF
	2BtSG+ynOKb36J+ZxV0s2HMczBhcLu6Qs8C0Oz34xqaIUwp+TX2YRKMmk6ppRC7r3lJ01k
	GORMEDcJDW190exbKFY0wSaI+98CjgmwpdW0HOm3XA+HKOSlZ6NDbUX36TWymg==
Date: Tue, 14 Apr 2026 10:11:56 +0200
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
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
Message-ID: <ad32zE9N70L20W9Z@duo.ucw.cz>
References: <20260413155728.181580293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RXxPajHcHu2F13eC"
Content-Disposition: inline
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--RXxPajHcHu2F13eC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--RXxPajHcHu2F13eC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCad32zAAKCRAw5/Bqldv6
8l1XAJ9mrYOG4K7iTGns8g9v2gw2g2WXFwCgksZWN1E3T7xTL5lC0CISuHKBzjI=
=6+Os
-----END PGP SIGNATURE-----

--RXxPajHcHu2F13eC--
