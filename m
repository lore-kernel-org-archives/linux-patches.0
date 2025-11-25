Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D941E28E00
	for <patches@lists.linux.dev>; Tue, 25 Nov 2025 12:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764074892; cv=none; b=p3kMvLoZlIytonVY6fnnJ2KD/ERnDCqG2zbH7ay0hd9jFZlmWdhHXJaScsoLedJ/OQlLAl+tutQWuvdZPDjZF0HRUutugNhdjbkWSWYx7QB/jD4XEHUmTToxvMOhr9oh1gHgCQvK7N9g9fqiAp6jC1UuqhPIfH4Fa1IC5cEiiQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764074892; c=relaxed/simple;
	bh=2RsY7vVq2G2NMPy/HR/Ewc2WhkD+Bc2nwDxo+dwZwdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NoLyx5p4tlsYgvSsSScV+1+imkm7/q8zz6VRCC55gQW5HhL1wJro6BqYkBXaKBMT29s/YocpdvlCgL7W6Grttwf2kKygCMnLBJ/6seupCktmPGcql1tkT7FVaCG88atvtNbZCVdJeuQcblmm2BC40lZv4demSe+Md+x/KfZBSQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=cxcWW9BX; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="cxcWW9BX"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 15171103D145C;
	Tue, 25 Nov 2025 13:47:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1764074887; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=VGvsHfU0vj7rPXxGYHWhD8WQnfL5kAsMcodD82YRuN8=;
	b=cxcWW9BXizsl9WPMppUAKsHJFBI6NnfXXFUsIoOW5wI7vspVS1MMMV5U5Hey0ZmKAdfYin
	MoZYo94mkQctcG+dlP+U+qHPeO9WY1bwfC+HMQAeaS0HkAGlec4GWqsvdlLQAErEIUrz7l
	zBF7UTZs56FJFGzzIGvnT5IG2EqO8tlAX0QGhqFIPfopHfoQbK5MXePD6vAOcLyPZOyLiT
	ggkxoPLJdTJ1m/XI8S/WcFbrhkbkSTT+LurshbjprDntpX2ufsBZ4sQKczUqAzes9UDa72
	J+CkxU6+k4KkUkAQ2KungWTYB9h/w79ZtetFmGT0O04FCB0hf9PWLq6jZfTxyw==
Date: Tue, 25 Nov 2025 13:47:53 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	wozizhi@huaweicloud.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/565] 6.12.58-rc1 review
Message-ID: <aSWleVyr9fUiu8Gu@duo.ucw.cz>
References: <20251111004526.816196597@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TwSYYC5ngAn7+Glc"
Content-Disposition: inline
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--TwSYYC5ngAn7+Glc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Zizhi Wo <wozizhi@huaweicloud.com>
>     tty/vt: Add missing return value for VT_RESIZE in vt_ioctl()

This one was backported wrongly to 6.12:

+++ b/drivers/tty/vt/vt_ioctl.c
@@ -923,7 +923,9 @@ int vt_ioctl(struct tty_struct *tty,
=20
                        if (vc) {
                                /* FIXME: review v tty lock */
-                               __vc_resize(vc_cons[i].d, cc, ll, true);
+                               ret =3D __vc_resize(vc_cons[i].d, cc, ll, t=
rue);
+                               if (ret)
+                                       return ret;
                        }
                }
                console_unlock();

It needs to do console_unlock() before returning.

Best regards,
								Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--TwSYYC5ngAn7+Glc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaSWleQAKCRAw5/Bqldv6
8tzDAJ0YPptJiGfbSmsCdpHsHCrJ5dOWFwCeMI0ng21J8m39AxLZBLVnTU91nMw=
=lcj1
-----END PGP SIGNATURE-----

--TwSYYC5ngAn7+Glc--
