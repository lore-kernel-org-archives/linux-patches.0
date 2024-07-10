Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA49DDB3
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 02:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720578984; cv=none; b=dTyEmkGfUOEAoMbsdBnQjlFQjHXcMXxPqM0zkrF5kz4mNXBWRFriJzGEvMIvGhlv0eH/tDizZ3nev+9ndhgSmHp6tokNkBbgEnuoEtUjKlfgkGiRgf9FjSp6e03NdrsfIntFiV4TXGW+UyfUEcaKpjjShDa3oi3hvDZgTQsmvik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720578984; c=relaxed/simple;
	bh=tGu8rw5vWLBsyolu3kJFWqz4hqJW9K9KWwC9yucMDSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kcziMpLNKIsbUsPHg7DND/hyaCmD5nRWPRae7sPgLQ8CWYH70E2mY5DMhbZkZjhN1+CaOqeqoBfpHB14EXaBocxqKWj8bd22sSEUA0f7Deuyb5/N3ohEEc6thqGmY0niCjwJiKkuKuRt0vv7iV/0a6IooY8rCUfJPzoFSpOFBxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gwfn+0MI; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gwfn+0MI"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f4c7b022f8so41722755ad.1
        for <patches@lists.linux.dev>; Tue, 09 Jul 2024 19:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720578982; x=1721183782; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E3eVF5jv0cXgwhtzNr2pMSO028nrJpif6y5JReYu+lA=;
        b=gwfn+0MIsmZmZVi8E4m4YgfWrXcvS6e0GMw55uNSUfBU5F2NZmXo6T9jqt0pJg3bMv
         +e4s5sOTPs3+WnN5DTzoMNyQhxaXaP6EJs7+Pb/0gbMbYQNKLnfhjIlL6nmPAGcm+Ny9
         ZCZJ3ViJpiJesQrleSKynthJTppqEHjIeLo3wjUOJrlqB57MEjIZxMnx4kLoBnaEBQfK
         6n0vcYK5V/zCcj8E41ObEygAcNIgifbzDbnt2C8e1awCPI+qwNI3IqR3hwpHKxCCRYyU
         Mu06jSwvuPiQPMUbEePcjPZs5VOo6UsHlAdgal3yE+tuZS2Hg5NNAVOAStoTchlF2MGZ
         B9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720578982; x=1721183782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3eVF5jv0cXgwhtzNr2pMSO028nrJpif6y5JReYu+lA=;
        b=AnPP4B193+8rBzpmXWkj78Ez+RxG65xND/gAkj1h+bF6kpXduqy+y7uSF41u1+ZzAE
         xONRBfbnFkfG+1HeToUa/898W+u6SnoSY/brwn22iDA/oyUbiSw5knBfQ0eUuZPBltD+
         6iUil/Mr8Qfs1T49hdKC/XgkY7AzFGR5Vnvgzu9Zc/ZFvJSOIsAhT+dHq2oWaQjMBp5T
         SVWaD6zBdpMuNfnUljf6ofxMBPFrOQiCxs1aYZN/TpUz/4LVa4mfrIm42yywMCPxQtAe
         gpTgKqymG2SotCVQN3eVTRrptv+heRwH5jZ+PUMiW7V7eIZ7acFmjxyYK5NlpRaiOT4r
         C5iQ==
X-Gm-Message-State: AOJu0YyONubFswfls4ezkli2KV4O7CPyhg8CgZul+UH8zuHsAkbBC0x9
	BDLsPgFSL/LAWuuvezVtffzrgP5Rb2y17511YQzApKnIeX1bZWWO
X-Google-Smtp-Source: AGHT+IF+Q+M86l7Qx4r0vqs78vkZcPhB/pCwYEDqZV+cSgfw6KiHKdWBc5piMJp6W/iMDhe00k4bHQ==
X-Received: by 2002:a17:90a:c595:b0:2c9:7611:e15d with SMTP id 98e67ed59e1d1-2ca35c36578mr3641145a91.20.1720578981795;
        Tue, 09 Jul 2024 19:36:21 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c99aa65074sm10744798a91.39.2024.07.09.19.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 19:36:20 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id B791B184796BC; Wed, 10 Jul 2024 09:36:15 +0700 (WIB)
Date: Wed, 10 Jul 2024 09:36:15 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
Message-ID: <Zo3zn6Jnb6YE4lmE@archie.me>
References: <20240709110708.903245467@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zic0MhIYsiJHXIn+"
Content-Disposition: inline
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>


--zic0MhIYsiJHXIn+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2024 at 01:07:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--zic0MhIYsiJHXIn+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZo3zmgAKCRD2uYlJVVFO
o+01AP4mIZ5kKbM9zklvAspFa6bsr7gp7U0T/+qaqHAhrD7v0gEAyp/AoqUHC3dT
9wZ3pJAqsLYzVT61PWU1pEQRTKYwlgI=
=4wD9
-----END PGP SIGNATURE-----

--zic0MhIYsiJHXIn+--
