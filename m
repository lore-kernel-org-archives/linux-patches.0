Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684F7182C3
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 04:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709613127; cv=none; b=VovoEBf5gLuej+r+8BHbNEywDjc7sROInHiRbo+CxCwnvUmsOE6zcNYyn1ZcepcshgZp744Xw7MO/oq+km79E3zLX2bpl/Rtc8fTomEovToxsNYh5UMa2f5lp4Wwu/QmtK8z3havtyCjPXWYgdNCPaVAlRGqN8UXTCRhGXn95OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709613127; c=relaxed/simple;
	bh=SSauG8f7miAub2NYhDAYyCaW33Q/IdRj5+nLht4jlvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itlf+CzXXXiV6ReBh5rkQ32cjOn1e6PBUM+aNBRa4S2CL+guSwV8VahXHAe2XCGIT85PFx6lonXtWfqXMe/6G0dUzEMT9MXYCKuOo88KIYaeDShZAVYrTZFe/mujpO0VVIpJprTaw0NwV2tfCjT5sOhMooyuFIdihJ8+yylOjRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CWfsbrTE; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CWfsbrTE"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e5d7f1f25fso2033458b3a.0
        for <patches@lists.linux.dev>; Mon, 04 Mar 2024 20:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709613126; x=1710217926; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RUsIcCqc0n65+aOxiM0hSyFnKyfuIyZZToEWRW7EiWM=;
        b=CWfsbrTEHQcH6Ns2Igqc8AWnn4am10617JTLOwsr5SCdbsvPaHbt1VsW1VAwyaSiNP
         OAZbGOS8NfL5PfgjMfiSF+435GJeSlDz0km+A6+reaTuNJ8E6Yj0ldM38/6Rdu8hiNci
         lZlIisJgaF0I2AS0/Om8FEv3InRUY0pcpXwFdjaQibjOuw6pnP4f6Kp3BqbHX05FHEVq
         Bb/uEoJP4OggW9xZ/J8FcYERm+SsoZq8n2egi4/sq9h6si0rLe+PTy7dEC/D2OZXWk3b
         IsixPOA8KO1HOhWczn8N8FHPZwvOH09BfrPEHjrrh9RYZhK/JQc5b+gdYwhmxON7FZv1
         TEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709613126; x=1710217926;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RUsIcCqc0n65+aOxiM0hSyFnKyfuIyZZToEWRW7EiWM=;
        b=Rf4VEwlu/OshrYjZKRSqTuTr0HMQi2FguP1c+9EJRCSuz8uy/qZDy+riWV9sKsl9jX
         iHgDe/Tv/N4w2fmqNxhaQ8UyCipGd7AiOOVYcMkgzAyApVEvDgmzxF7GlYmUTePsn37v
         ABSfA9Vg+zo1e9H3lWtploj8z1H/DpOQF5S9k3Quxu9njuj7j3KJAEGlUm2U8ewuGGKD
         8ffXJg//nHWPq1UDvQ+lIyGYMbwk746yUYOW5pLthr6FS89H/GgpF2Lo0mkMYx6hx3pK
         x49gZhDfRay70pkbQGSdfnhlG3BH5Qp0qO/YmJedQ/s7WxxuuylziJIDcayum4uZm6K7
         7PKQ==
X-Gm-Message-State: AOJu0YzbyrHhv8oc3cMf3RbhMOOympaBmmu7qz0JlIpi36yzQydmLbHU
	KW/bc6jpyCBGBRfG9JRARhwLeCSTFjHXRt+S6m51b0dWd8sz3dAr
X-Google-Smtp-Source: AGHT+IHZ1C96qA12U3lQMwf0gIJuHT1w+JsoMpzvZ2EGHDm0ld2y+Xb2ndKyMn9HP3mN7nicmWTeLg==
X-Received: by 2002:a05:6a00:1ad0:b0:6e5:9a0a:b668 with SMTP id f16-20020a056a001ad000b006e59a0ab668mr9802051pfv.27.1709613125578;
        Mon, 04 Mar 2024 20:32:05 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id c17-20020aa78c11000000b006e5dc1b4866sm5202800pfd.144.2024.03.04.20.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 20:32:04 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 5367918479810; Tue,  5 Mar 2024 11:32:02 +0700 (WIB)
Date: Tue, 5 Mar 2024 11:32:02 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/162] 6.7.9-rc1 review
Message-ID: <ZeagQq5Lo48TUmCJ@archie.me>
References: <20240304211551.833500257@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="o6vkPx93oPOd8dIi"
Content-Disposition: inline
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>


--o6vkPx93oPOd8dIi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2024 at 09:21:05PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.9 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--o6vkPx93oPOd8dIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZeagPQAKCRD2uYlJVVFO
o88YAQCZD4Jm+zkUub5+BFacdBLmgePDQQZ3Hn7LtSUmRmK2CQD/USt81uh+xzuU
TDBTciGePK0Y34BHO9ZlC9dbjitq/wQ=
=lIRS
-----END PGP SIGNATURE-----

--o6vkPx93oPOd8dIi--
