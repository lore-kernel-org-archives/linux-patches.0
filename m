Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ABA331222
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 08:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780304198; cv=none; b=mFojDdg/xo3sUtbDc0xHlyjMjV4DNGdwT+fpXUlHMbg1C5+Qj9kglnc2jyD4yPvPEnujn605RSJNxznVM54SC3i6tME41xinryrRuLcCjkiBsOwrnEv39dpUktf6DWaq1IqpqU9amqCMgue8+Whd0pd1/bKL3N6+iOnCg4enSrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780304198; c=relaxed/simple;
	bh=kdjmhyKz//fjIMOuk1DoUiELRlSQILJHokm+KiwW8Q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHQ8lu0xbsQYg7V0t6Ybx/0vOeZY28geWFCprWyGRYdrbBjCpLTO6E3O+WBnbWT4proL5/c3mqZEu5LSAI2caV8GMV+Q/MH39PNspB0XJr5drrOHjyuu12fVZ+v7J87NgVSYeVUj7XDFPDDNDAmjsr8Lw0HuJnj4xHrLw6nYJnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=KvdZvbf9; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="KvdZvbf9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E25B0116BF5;
	Mon,  1 Jun 2026 10:56:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1780304193;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=yNB8pokyYVxKzFS/Vh+8vPeb0b4cK/EFAVmU3A9AKyE=;
	b=KvdZvbf9o12dTIcXcRuOkXKXqrwNHkvQ4JL9ZJ0sjnCmJ4DDhMZ1eQ+kTrjHSBK++ZU4Em
	urhbv3VtcXH6z1NsL+Js8/VZITElTGk5CMRxuOqfoVNUVtwi+GKaS7139JCzkJpsmeCYjX
	m1fl+i0jej6QM55oBRJ2n7G7L7d06SlGoR211p+Z5H9hR9cpeAJQ3jNZL4izoc0JLmpZjP
	sV+f7zPQoEqW9Fv36P4mWNAmLLpiVUkuo8krDl0Q/aJWSioMcKwp4UfIPhJVr1QvjtgVXn
	6WTJ0ousAXSiwoMKoahks9lhAUJBRDkepPRjLH3nE9HGWmoLfLX2wWVDLbrW5w==
Date: Mon, 1 Jun 2026 10:56:30 +0200
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
Subject: Re: [PATCH 6.1 000/969] 6.1.175-rc1 review
Message-ID: <ah1JPrjMumdcPlvG@duo.ucw.cz>
References: <20260530160300.485627683@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cgG21IZHn9Yqy1T7"
Content-Disposition: inline
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--cgG21IZHn9Yqy1T7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.175 release.
> There are 969 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--cgG21IZHn9Yqy1T7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCah1JPgAKCRAw5/Bqldv6
8ptHAJ9Jx3zozxGqV4kdfoA4T4PXcxqegQCfaF9ugW29UZR+5W2gH1unrERpnJc=
=z6CZ
-----END PGP SIGNATURE-----

--cgG21IZHn9Yqy1T7--
