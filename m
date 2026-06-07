Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407BE23395E
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 17:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780851658; cv=none; b=nMy72gArsr5pYI7f5D7942ZxYiYL2QzkmN7kIEHmN5O7GjJAN7GhdO/u/3cXeO0hjuok9Nm0yArL3WDewCjC0SDVpxy9MtuBEbqzoZ8f2ydeRMj0lV0eUjqpCQ4X1h+C9PYZiT2iHo/PwEtRjZQcWbeGgNUPz3vXaKUJA7krrZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780851658; c=relaxed/simple;
	bh=+QmzV30fdAWDw+dJjqppCit9pv8PJbG6q2xdhoHxB84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhcmMkQTU9gmqwaMK6vYsW3so/yRSy8j3RlzR+yGApuRB1VSmCyD0IGx3T9pbFvUEa6vwXeNzL1vqOVDo9xpsHhyFh8LUun3jlKRytHdpitFA3Fv0h4eak2RhH+4ND3RC+CRqiYvzc5zQEHfP4CWMzMmHC0gQCO4yDbSWm6p8B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=AF2JV4bG; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="AF2JV4bG"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 46ECA1173A8;
	Sun,  7 Jun 2026 19:00:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1780851655;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=rojg0mnAU8DrdgJSfgoi3pvm9XHlu4qIJ8zQ6JSqV58=;
	b=AF2JV4bGYU+dYi0CJGT6KcH1wufbKl7YmdRDMhZo81hcNa3YNe7hk9AgQ1PxwR6qRLaiiC
	GhJTCUSxNWLv+lf+6d13M+juPKHb7RE0qos4mPDVuprWSdEAmZu9nmChDDcFjBedMHjQOa
	26AJ+nLOv6N3jTlj31QWglwOJoJ16znPf1VnrcCbFjgH5SHa3oP0hDlihle0kKKdDpuBSE
	jcOuOoPSkClLPTjYSgQf2IgY8xe6OXW1UCPPSPXF5h3w51+Gmlkxr5OSNC/lfiTXUXW1ne
	AGzER/1V++/lL5HK+H6XXKkbIlDn0iHfwInX/M7bkGB6kErqrz29ngTVhwRvzA==
Date: Sun, 7 Jun 2026 19:00:52 +0200
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
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
Message-ID: <aiWjxBRaVy0Cm1hB@duo.ucw.cz>
References: <20260607095728.031258202@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bY+4N0KUHG/z31FM"
Content-Disposition: inline
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--bY+4N0KUHG/z31FM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.0.12 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.0.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--bY+4N0KUHG/z31FM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaiWjxAAKCRAw5/Bqldv6
8vEiAKCpMjrjruTv/AI8LAyhPGFLhvQODACeJ6tXfDJ18hi8BZZcU57Mr/IF34w=
=wW3U
-----END PGP SIGNATURE-----

--bY+4N0KUHG/z31FM--
