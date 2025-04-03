Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1CF1EB191
	for <patches@lists.linux.dev>; Thu,  3 Apr 2025 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743711675; cv=none; b=DhIzNhSpBCU5E/D6EkDcB1ok7qDdzQuPzZJUrgToXgxLawosuvZM14ZlvRgBeOilMlV6gTcHQlbBddA1QaLrHPt3cx2IkjPWU+wBljaex4syq9LH0NXxMmDZsrY6zkk6BoJGGol1KJhO2CQ3CNlt8Tf9yYMmpz4Ub/54WoVUuxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743711675; c=relaxed/simple;
	bh=wOIi+m/LD0UgO4dHqiw64je6Ri6Sd4zMX+GnenRzfW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FpGyI8IX2/+hNGyA2mpBd0zKnrFZpLXp2cExF16i3Lv5vW6V0hvTNkg3rT/6q50oNQJ6ku9YBATmQY29/vmMkS1z9VI/LyUfiFaoy5KOFFTk3aKi9ECk9LEumE8FbuDScwU1VACgxDO+SCWbXfzsBBIACpictb0UYBtyCNVVUgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=FsX3PBvE; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="FsX3PBvE"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3B6E51026A6C0;
	Thu,  3 Apr 2025 22:21:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1743711670; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=7fKACFLV33+9wBENBFagxRYotx1MmCVKpRV8cP3Rha0=;
	b=FsX3PBvEt7XTOVMTXSiZkwuhkfEG6Aq7YuvXD389MJMGe9ZstSDcm687hm80+29RAbX5d1
	e0fa8IHRRE3Nj5I+ghaThVxhW99su8HOmEcBWXZTBM66dVCGeNj3dSnCOHPWWIxwxj3hmb
	lptZEYnDRzLBmY9Dts7CNN7GC43L8U701nQDIXgt6naIOCkuGts4sXrs97xEUrXlIlR+TP
	JyneBPcNd1qT+r2giIuGqK69CCowqHyfxEYfVjULKrx/k+sI8o49H0ee/HN/DgZcNekjRd
	+9Mk5Pzach/ellrUTMEFavwpCpYOZh3mTAT7I2xSoBsqL8LvMvPk6R3YtibaVA==
Date: Thu, 3 Apr 2025 22:21:02 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/22] 6.1.133-rc1 review
Message-ID: <Z+7trngmrDlbdJiB@duo.ucw.cz>
References: <20250403151620.960551909@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H744Il11aZkwmt8V"
Content-Disposition: inline
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--H744Il11aZkwmt8V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.133 release.
> There are 22 patches in this series, all will be posted as a response
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

--H744Il11aZkwmt8V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ+7trgAKCRAw5/Bqldv6
8q05AJ9O0mMqFO2TX13TA5n/zJPQKDiAqgCeL8KDQ6OSqMKw29J/D/6H6aQnN4U=
=8S8w
-----END PGP SIGNATURE-----

--H744Il11aZkwmt8V--
