Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAD71DED7C
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 19:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740081436; cv=none; b=Hmm9fw3wcA1aafOhs9P9GDlgPBBFvnDF+AJg2VTP/D6QG7MSN5t4TIkZkLwm2coIvJ57cqqHT/VlabIXz4PaIaQKzViC8c/x4oMRn8t3+FIv9uoXUt+H2vWAs4j7l+/jWWndDPtMKGhDURQY854e53ET9y/SG1ecCNfmmoD/aC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740081436; c=relaxed/simple;
	bh=rhNRYvn+DdX8gdlvRnyY/2T8DeMLcSBO0EYXVjLwed8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0XCgWFULe9IgBXnYxtrJDmMME6znU+0kaE3oUxKwKKEpiEZ5CZI6Ovelk6Ul/DFl54xcVdefN2K8kTTeyrPcDXHl9HzdRsjkjJZbJqXIae4V4MNiKkOW+2VrBud7rPEoY7XoaMkfvSOwzKMEavWwSHtCyVUpY2A7/ieVskvbEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=EwvtQ6Wi; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="EwvtQ6Wi"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 309BA10382D3C;
	Thu, 20 Feb 2025 20:57:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1740081431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6BeHgAJNCPXVhMCWWIUaLu/pLImJZmpygLdpID0UTCY=;
	b=EwvtQ6Wi1GVrQRQyhDGiy/BqpN4ZGJQfEnz2bj4al6tXc6+a+d4WWX18jmtm01vnypH1ge
	QfSFkS+Zbdb8dEdmBYN7wNVOcxHyOlcEMtU6XK20YjTFfUCa5SAPGfyk0o/YmK7M3Aswvd
	QgOdBbLmd4HFy1GtKCDT0Wa3R4vcaDf7BRV7g/yOyweVWlDVWO5J41mzvjdMmDxOBCaZWm
	Z5K3cdxXvZ5WZIVM7u9Y2N+lSY7VMdnP7c7sC7AR020Wnsny04SZLzwH+QCZWR5DfTKq+V
	b6NtNFoz0rTme8VKqtIgEpgTpGlWulDGnhMHTZFg7WRe0+8Ur0TBN0y4Tu/unw==
Date: Thu, 20 Feb 2025 20:57:01 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
Message-ID: <Z7eJDTrf/5758e60@duo.ucw.cz>
References: <20250220104545.805660879@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EMOJE/HPlVE/RmOR"
Content-Disposition: inline
In-Reply-To: <20250220104545.805660879@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--EMOJE/HPlVE/RmOR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.129 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--EMOJE/HPlVE/RmOR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ7eJDQAKCRAw5/Bqldv6
8jCKAJ9Ig0/7Lgd3ln5Bb+RcnOfnp8BVnACfdfO7sNMFGuRpj+ym528xqUeFQsU=
=KvCN
-----END PGP SIGNATURE-----

--EMOJE/HPlVE/RmOR--
