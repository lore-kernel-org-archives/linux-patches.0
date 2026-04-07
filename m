Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D6D3A63F6
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 11:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775563163; cv=none; b=t1ZcCcEjSqquNxXQhvr3fols5HDC8qwLajYJ71Z/IgKUjQHuhTmViyuIQYsmlAzUypWlQfLANCIB2pIZkIizNQXdg1WEQ5LHzAVVp5iTDXXMAJJQ7MuxU+RSJJ1DEjlvxYdGphCuGAJdNLMquM3ZWGm51QThidQ/0VdG+pJ+7yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775563163; c=relaxed/simple;
	bh=ZRG/zyLjNtSoVwAD+bzdb9aXxJxYotxOU+yESyKV/NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lKf4k3NKfHpQC08BL9ZRgzYZZMaFHhy9VzTAdPG+JeVjQBrgLHFV/HqD1Rq1aXZSJqI37YIVsJNOP2OCEdOF/WBuqKgPnMRkoQeOZoyI9KlGyYIPYqvOscBDyItRoLjTmUreeRmy/aYXBRYY2NAQwzqV1cYngU9stKKvEqrnqGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=PsQ1vtc0; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="PsQ1vtc0"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3C24F111191;
	Tue,  7 Apr 2026 13:59:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1775563160;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=fcd+00w4GmcV+k7VYAkmJWRpnBsuESGgFqKmN/MYXYo=;
	b=PsQ1vtc0HPyw7k8d6++yolaXs43d7h86zBwzQqT9h/ETwiOLI6VSCt8kL0hkEsiXCxk5X6
	BTCz2zXxYeY4z//65MZRryLhBw7sF2PFJ7KuFCcs9DCbArBLA90TjvPoMdwKw739CXWua6
	1ZNYZO2UYwzVTGQDZz/pYQ0Cz3UuYXamxFUvNNMNDYl+hlK5S1EHubTxnGrtEkzLaYoJ+O
	GhEbZKCG7pWl1OF6ZsOSVimVZE2Qgwg+3NIK3iN4fh295MQl8CsJO0z+7i3rja3AafjauG
	Vvf7/N92SPQtH79+mvlnPVQ1ODj94d9qhiZ0N6qbjS5QP2aQ4dw1wdmk8MBziQ==
Date: Tue, 7 Apr 2026 13:59:17 +0200
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
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
Message-ID: <adTxleii_brIumnd@duo.ucw.cz>
References: <20260331161758.909578033@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5lgPI1cE6hQOHLXg"
Content-Disposition: inline
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--5lgPI1cE6hQOHLXg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.19.11 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.19.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--5lgPI1cE6hQOHLXg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCadTxlQAKCRAw5/Bqldv6
8voJAJ9Vw/YtpWvUEqh8NqNqu2cwCyOg+wCgwbEimna3vXWkFlDoYUhPd3xBFow=
=wIyR
-----END PGP SIGNATURE-----

--5lgPI1cE6hQOHLXg--
