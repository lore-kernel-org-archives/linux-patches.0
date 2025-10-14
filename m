Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F122D73BE
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 08:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760431634; cv=none; b=jdJzYPR2VzeU/FZy1UyDX+tJiWqpGcRXtPiDXwCyXqtjn4ScnmlfV1soQq+0N/f2Mi9Pm2tORuoGeysdnmKO69WS9uQn+HBIlmUlkY450cVIEgISLA575rAKW7vvqJk3GI7hKJY/sgVmGVnLpDMApuSEvuW63pJChmPhvJSrFGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760431634; c=relaxed/simple;
	bh=gr4uZey3R2ltJCppxF/6JbD4XV2Wi7Ko9bvWq/fpPHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdoTF24+3gnHSYAWDBZIkWSqRw/3EJhg/vrRa9tGE53LTyQh223U9sulstrpgGZO+grtM8R5x3Np1lnn1/vmhMqsnaOULUjErsBrx7avotbF8XskzNo2tYxWqk3K3KZVKiw1ABxmjh5HO1aVEwxlNilljkl79IicUCqRwL5bmRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=gPV8Myth; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="gPV8Myth"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 934AF101DB828;
	Tue, 14 Oct 2025 10:47:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1760431629; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=HA6KX4Q0WBTmGjyuyRrI5rSVl7mXYgw9jRqJTHqZ78k=;
	b=gPV8MythwoXaT+m+crTREF8Ikda0CdKNWa3M56GnVzJnUz2pkyDEfYjqsn6aFa76PbL+iV
	AFM1QkgH7lIP9D7A1lJNgjYXMi1pDlCIfyINIjZXzcgwyzB1+lAnMa7T5Ii2/1lkcK6LE8
	caaNselnknIogEa8yid15ZV3idcLdMOeDRSm7wKC6mIgEBzIwPPekNCyJFgl7bJ/DOUNLZ
	U5eU9/XyjQDnU+JbiJoCyLpGHdBOgRy2bGEomqB0XnQSghfqvl32FG7U8esJYewdy8rj4W
	XjIsV1JrUL46CdsdIEKrPSQdhsUtNiWIWtElqJIoL3RHLha7SZc/a1gw+/3TOA==
Date: Tue, 14 Oct 2025 10:47:07 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
Message-ID: <aO4OC6JVMt/IkIxq@duo.ucw.cz>
References: <20251013144314.549284796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="spSntud5rFSUE555"
Content-Disposition: inline
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--spSntud5rFSUE555
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.156 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--spSntud5rFSUE555
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaO4OCwAKCRAw5/Bqldv6
8iKUAKDBB5JA4RMx+YkY5ci/UU+MigKBdgCcC1aZuwGEd3iaHG9YodQyfCagAc4=
=Vol5
-----END PGP SIGNATURE-----

--spSntud5rFSUE555--
