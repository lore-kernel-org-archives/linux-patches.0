Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC4635AC0D
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 19:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774293576; cv=none; b=rxboQ/RScOb2bqy35tz+NngE8w7vDKeAIveXIGbbT4zNXNpdnMUb6l1ahwsUaCYv4dQQqJ1kFBmll7oO54mHMbT03ZVhx7fl3hHi30ALKrJpVprkN2VPzu41CT6WE4FWkq6MR5sKmWE8QJUz4oCj7upYoGmsPcIfRcxqs/sXqrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774293576; c=relaxed/simple;
	bh=eCt8GAL1Xgby/lPohtIrWF27irt3W1S4PMGZxkmiF1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJNOkBn8+WdB/BFF4P6/s86n1x1Au1bWOcYdu/SNGUer5uKiiwZHfxHO4PavNPDxBomP2JRt6cZ60esZ/fdNYVtCr2lmjCKSMADKMPqPUzf0qDGhfDL+Rs+SE4OGolGSnD8XdiyFuXXQGacb2YU5PWxJdJ92ac/bUWlQ79WP2F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=a98gjz9A; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="a98gjz9A"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AFB1C108B42;
	Mon, 23 Mar 2026 20:19:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1774293574;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=TFBbyBz7BIpcfBZoBmjRCtrvFR4WOSUFh7RusRHlo50=;
	b=a98gjz9Ak/47pJRAeHpNW8FSqvPExfrLPQNPULeE03azchXqRgiy1rSyOh0NGiYPyvLoLU
	SLtRN1R1bQyBwNO1v8haKlCGm9dj03V0/PrfnNafigpmHsmqb7Y+FxQbwADNz1oK5Suyjs
	7Sf296jeSKxTtrkech7WxcxFVCgGZB4U2QJ2mS7/Hp1Lybu1wqlKlxeadQKWBdKvgkp8gw
	xGaBqTAuS1TmNF6D/yj2jXajaqCjLa+3Kcn7L8YAIauoOWSQTVdC0PsvH+/ZGc25KdPCyP
	ijgurLrHSvJVHz/jHuzeacN6j5t+EtzM8SZYsA9ucS8yfAqgMy/LycFynsSRDg==
Date: Mon, 23 Mar 2026 20:19:31 +0100
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
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
Message-ID: <acGSQ3fiv_TsjjKE@duo.ucw.cz>
References: <20260323134504.575022936@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v8maf0VAtSXIKhFB"
Content-Disposition: inline
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--v8maf0VAtSXIKhFB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.19.y

6.18 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--v8maf0VAtSXIKhFB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCacGSQwAKCRAw5/Bqldv6
8vPzAJ94Bz0rS4aHwm3UD1EZVWmNj09RkgCfRMS59xEtPwFZxXGUnBU6pgs+Dk0=
=XCXA
-----END PGP SIGNATURE-----

--v8maf0VAtSXIKhFB--
