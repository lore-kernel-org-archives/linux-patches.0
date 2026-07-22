Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9906B30C15B
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784742289; cv=none; b=Kmyq5DyIIqoUmu4Ft8mSmskyIuA9cziCjqtpURi/oafwZzI75Zo7iEuO8YzXv6v3B1pFAeVmFSD0eNDVTuNWRHH+mKLqMoBlJEyj+WTJrSWgt9ugHYL7g0Bk1qo7vuLxwT6+dflZPzjWNWeCIhwXjJzY7pDsJK3JfS9oazI9qtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784742289; c=relaxed/simple;
	bh=56c7ufbfPpu39giO6TDqzrGndzN7HsQ3yGDO5AAvsKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvwwN4sgYlbf9qzkomn7hgQq5VXVrUMn8IL78UBZMO3mEbbHq3wJ8yzAe4LEhrhU94v4IlwmeBNRMlDpnwp+MtAeG5P4GH5b9yBWBoYxryEorFYTUyg1t4WxtK9aPomzIjCLnzAomVAzRg4dYzEJ3hWUEHNoRSTHeQWk+cRLabU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=d/H0yZQN; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="d/H0yZQN"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1FA1011AEEC;
	Wed, 22 Jul 2026 19:44:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784742285;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=mPfIMyNUErVoO4oE70x1tq98y7Re4vULWa15Ix+m1kY=;
	b=d/H0yZQNf75c1N8w5q8aLhxNTa2FnRl+6VfR+twmbCZDCNEMvuCyKabHdHCv6H9eSjOmOu
	srSrA2zl5YWgA2La2pwA5/8VBgphhO4kfRWLIDFMkAvgMOoQ7Xk1T9dB9/ixKh3hdfgS71
	9zEp44DEzxaKC8GB1SeUkRWl1W+/BIM7U4cf4ViHlU4/Lirfs6gWunjo7Gb4brfJZpFX5o
	6IgiO+42CKsr5tefi0FNicwE3b1gXGHWIEJjRafk7NMPDVxSZbQWPCce5RTQroW/Yncs4z
	jsDsnO/l/bP5y9ptbMSCCa2nG+LpOkFd303rIoc2V06LLpTpFx3xB/I0tmHj+w==
Date: Wed, 22 Jul 2026 19:44:42 +0200
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
Subject: Re: [PATCH 6.1 0000/1067] 6.1.178-rc1 review
Message-ID: <amEBirk5WIIrzAwJ@duo.ucw.cz>
References: <20260721152424.521567757@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/U59fZ+RRj1R7eep"
Content-Disposition: inline
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--/U59fZ+RRj1R7eep
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1067 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--/U59fZ+RRj1R7eep
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamEBigAKCRAw5/Bqldv6
8h89AJ0bdw0f84xcPQd5zKW+ncTGFDQMRgCeKeadowEZIgC4yVPwREMi0hRoG14=
=+NyY
-----END PGP SIGNATURE-----

--/U59fZ+RRj1R7eep--
