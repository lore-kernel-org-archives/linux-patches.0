Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC9C32D7C7
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 19:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241307; cv=none; b=oHEIPTB0dIPeoNGdyvfN/gb6dijK7/W8g+FBwNhBdKindhFeGMv9+43e/jXFKoU2anGX1Wz5J5ynsKHxpvyXDjLqy8NXkm/UPjTk3f+j4is0icstJYnfXWYoHcLIuY/8h5w/t+XwkeiD8kgCbT9Eje18yd/qgSRCKc5TER/Ct1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241307; c=relaxed/simple;
	bh=KJFi4oJU9yUXpnVSIOw0LyTxY9gpp0T7eB6UGdEUWyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvOl3itoBqIjSMORNEfBFOSbgn5ySMJfI3AoQX6ZVBnSyCtNYzuCrj7KSUEcyv7ESeMtweUUx4FoO3xjQI2PNxB9lxGZ7AkEADy3iqquwDB/Ug9AD78BpPVd6nz0rl3uGew+HbQ4DHjGwUdXdJKB6kt4+yoI80GyAxgn8+jGomk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=MHBZ59YC; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="MHBZ59YC"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 81FC41034BF;
	Sat, 12 Sep 2026 21:28:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1789241299;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=y7BOmcPqzwgHNB8tpsuWUR+UQP9k6ozYzdCsqHi/B/w=;
	b=MHBZ59YCyzMkhyIW/16hAXXXmRkRnwsaY87sFH24wKhGqtduMrpei94/uvvXwdO37HolwP
	ecH1OIPwsX6f5B8MUrV76RBFXjNtZhlm0XBMWmdDndFyHrv9Zjg7qxg2QQn7P9WLEpAVQ1
	SsWpup/WFDh3ZOCnNUJufAIiwI+RuLAn8Sa4cNbHDa+g4hgXHlNsZevDlHh7gwfdXN+Plg
	VAXEp/taH7ThSUV5t0bDmC992o3H2asBGVd5PoT01W7aN9v+gdfYe1NAXcXEtQ1GILHwLD
	57qa0aSxqbnsgevkLewkLc2tk0t8jhdDIFpSZ59Lcrms/3dVcdFXCtXa6ll2UQ==
Date: Sat, 12 Sep 2026 21:28:14 +0200
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
Subject: Re: [PATCH 6.12 0000/1376] 6.12.110-rc1 review
Message-ID: <aqWnzsSIMkyM46NV@duo.ucw.cz>
References: <20260912065607.535295758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2nd+0nHZsekXluLM"
Content-Disposition: inline
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--2nd+0nHZsekXluLM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.110 release.
> There are 1376 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We get build errors in -cip testing:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2842911949
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/16461797877

drivers/soc/ti/knav_qmss_queue.c: In function 'knav_queue_probe':
drivers/soc/ti/knav_qmss_queue.c:1874:9: error: 'knav_qdev' undeclared (first use in this function); did you mean 'knav_queue'?

Best regards,
										Pavel

--2nd+0nHZsekXluLM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaqWnzgAKCRAw5/Bqldv6
8nUMAJ4me87pI5wWPjglhm7/+0F1SGbZsACfdUjR+j+Zdy1TMs/BtA31wuXoCBU=
=H7ZQ
-----END PGP SIGNATURE-----

--2nd+0nHZsekXluLM--
