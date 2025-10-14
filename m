Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80742BEFE0
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 08:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760431689; cv=none; b=FecLbBKx37+5PnmQeHbWy1mHCwYsMJng6JBtvnYpvQmH/nokFCfvTJVw/cI6AukPkZWFxzmN+o0ox5VGsA+4TTqKC3zt38Yi6Zgd/sucIjz+1/kKb72haywNXxapR/EGRtVr6T+YiJXfGRUUZsrof6m03p834ZL6rjKY2uuaXcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760431689; c=relaxed/simple;
	bh=nYsXDRdxj0c1WMqKmKH0FNz8fDlx3p7hepYEZ7vtY6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b51kgdfvcqZsPYmhEN3ZSgCMBAQi3v/s+B5ZQJsO87gILtVl64VOV3+E0G5EHEZjCmH442YXubFUIoEZ/dkv6rckAwuwX/9/IvxrWhbGqZiI/HaQilUGlsFWrUOJTbG99DmK+LwzE3hycsXMz8tZEo5fvlthVRDB1KDYmy1KKmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=FHkL6imt; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="FHkL6imt"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4E3C5101DB834;
	Tue, 14 Oct 2025 10:48:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1760431684; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Q4BuPd1yhKAkEiVAkuMZoftvxCi2W8Cy/+W4jG4Cnhw=;
	b=FHkL6imtX1qtmcNDDhfPo+DFrbTs5x3/KhI/b3C9GzItOd30OOxXdQ92jBPWb3htEHMf9c
	I7pt1/JMwWdxlaKyXW3EHoHM2zpjWVweS1N+9ENzXex1EGlFmSzfaqwtmV/Q1+syzNTwrI
	fWhyAN3QJG4GdghrNxfywtU4OaF91NP4js2va+loZ54HcLnhEOdroM00ecXhIj/ltEZ1Qn
	A4m11WHYRjrAsBiduT4LTb8gF82Lc/OB9nM+b4qzQcCcjkXVvi6Q7EH7p+nO5Hr8bO1Tq0
	qP+23m2kiUaPorYa/Fx1KFn8hI334miFbR/IAdqtE0FUeYAxCumO7A6GZoJdDw==
Date: Tue, 14 Oct 2025 10:48:00 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.6 000/196] 6.6.112-rc1 review
Message-ID: <aO4OQKYYFVuhbtdG@duo.ucw.cz>
References: <20251013144315.184275491@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5O6Ajf792dUZmI8L"
Content-Disposition: inline
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--5O6Ajf792dUZmI8L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.6.112 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--5O6Ajf792dUZmI8L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaO4OQAAKCRAw5/Bqldv6
8keMAJ9fG+1kEa3E/gkF0BmxElpVr3zEUgCgpbR98IcCmgyzV2WLZyrz7vZX34c=
=LIoD
-----END PGP SIGNATURE-----

--5O6Ajf792dUZmI8L--
