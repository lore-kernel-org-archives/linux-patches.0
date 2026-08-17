Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06763783CC
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786989422; cv=none; b=X3XXM6j/3kO+rzQhfEzxrC3k1bgKIVePHaEYXzdrBvDosupBpGwqGgBSgMGbaY50LVVBCvwIyVlEDrD8bi007mTXhqmL9HiP7nLlUdmjwfMF8l5DFDcy36C1PIe9DxFj8jsNMeKX9JbvBFj8NHmiZbm5rKGkV39g82ON74AL+Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786989422; c=relaxed/simple;
	bh=nIGFG2jN4ppPfyDWCdOCC3HcypoQVZlXe1G8ovyg5fI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxbEsQumvGhG8esnZmrGvUpL9KPAmzVnM8Au4R1ClXBCvkX4X24xPUSMN9u5isRsclqfr5kuOl3c0TQNN0tnX9e1TJ60gTuKCgPHzCcRAgtTH78IzXTRicKhpHb9hRpdN6KvjSQEvs2N+DVC/fSMTyNbNhwwVfeDebXDzluMvrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Yuw58dLB; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Yuw58dLB"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id BDC2911B608;
	Mon, 17 Aug 2026 19:56:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786989414;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=tOlMhYxFZfya7JE6ijmYexZh0OoxknB9TWe5AAQpMIY=;
	b=Yuw58dLBINdIjK0+4RnJ4SJFVRqU0RJU2LB4mHmgAHc3mmHYWU570stsTlR0d4M/946he9
	aMFpgvN7FYP+fypdp0NcJ/0gc0m9qSN3+cpp/bovLyOd5CTc7hJnaoYvt8IDYWjJ6YeGyB
	khGsOQMLDzIRTQ8Fz626AuzZ6sS/QA0wLHxxD4NTACyemHLESrQyILhdPundb5qGCcIP+t
	TO5ciql1OkRmYemeufXl1RbKcv3mLB53q2SYyhPfpcnYBvM2Bs0B/M4ELYzmHgZnvvPySY
	E1OecjRPhoIwcMN1XxgRaOBf8etDdYMcOAVg3jcG1efA2Tp2RemFh9ziLjYDHg==
Date: Mon, 17 Aug 2026 19:56:52 +0200
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
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review
Message-ID: <aoNLZDhCC7bMyN3I@duo.ucw.cz>
References: <20260817132536.466235697@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wT/eDTRhCCn/czgl"
Content-Disposition: inline
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--wT/eDTRhCCn/czgl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.45 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--wT/eDTRhCCn/czgl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaoNLZAAKCRAw5/Bqldv6
8joTAJ4jgW7MUxkKQqv4owBtmOMqYYX8wwCgjXlD+Kr2PCkkOdj+PdcDdvNtR7c=
=BCm1
-----END PGP SIGNATURE-----

--wT/eDTRhCCn/czgl--
