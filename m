Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2D34334A0
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784742451; cv=none; b=uc5aprkYqrHJsqjUohe5N7GnhQfd0UH8EtvREwO6UY2ilvRKYdhYdJr0YF3D104gwcefPR4A0dPgdw8b2CBoKD6HS4v01179twtgo/HSrTs9HWXRnpZotAt/5VPSuE/V2FptuQGUQbS7O6K4WAcjbxpGYaUiepCcioL5iNuVXHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784742451; c=relaxed/simple;
	bh=Qq7G+mwPQiB5ts1nrbi0mRnhwHj5KgfEGOe3KWqLgIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=At8y/BglTaJhGCg3I/6Fx3Yuxjk/qgE+z1VNvfzR9lLYTTUvAPKlmQ/B8X3qKaTUkLBS/zNXErB/sZuS8iBzMQLqYAy1kSkpM3kgbWiKtFwFB56Q4/rlQl3d788HChZCy16Uw5zua/AArRcBD1XFm3jcngDDVFgdfoZAeOhgmwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=T5nB+wL9; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="T5nB+wL9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9920611A4E7;
	Wed, 22 Jul 2026 19:47:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784742448;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=k/ez8yPfvIhXYMyB9ctt9PLVqHm+NnlBmCams7NdFBk=;
	b=T5nB+wL9uo20HdUohN+rkB0ScT0vF9YpcDKy7s8OSeWAVo0GhMDBD6bahiO9JHBq523w2H
	+3CyDViClOkZM3PKVnetr0zNWZTO0r7YtD/oyeo2ezEOQuhAT2IJQdmMVVAuC4OVDhWW9l
	cTPMbTP4c21yX50QLh5FfsjhXw4pcAUVgIKTZSUo3ep/EooTULQtJIcse6m/OOgyh9pFlo
	auwIiEvfN84LfluM2NRcuQNbn85tGKOQZtXs3/mLfZyFcapxWCux76iILvCiGUD5QhUVHq
	UHoAbuCfnD43QXvPRyIy0xzNmZnOJFjuJjd4+DYhpoBzATSHJBJzAXnppXtSEg==
Date: Wed, 22 Jul 2026 19:47:26 +0200
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
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
Message-ID: <amECLhe383ZNtUna@duo.ucw.cz>
References: <20260721152552.646164743@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llYSLYhursVCJXAg"
Content-Disposition: inline
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--llYSLYhursVCJXAg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2077 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--llYSLYhursVCJXAg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamECLgAKCRAw5/Bqldv6
8k7XAKCK5BfJrSwbL267ZB4v4O/JioSAnQCffTqWKX81APFh1g0ClE/w8FHmHUE=
=lwSw
-----END PGP SIGNATURE-----

--llYSLYhursVCJXAg--
