Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EA023B0
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 05:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JWZEwtx+"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2800f7c8125so948899a91.1
        for <patches@lists.linux.dev>; Wed, 15 Nov 2023 21:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700112357; x=1700717157; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zMh/lVBezDPicasXps/0vs6nsdfTuHUrBfcS44Fj6bs=;
        b=JWZEwtx+ebHarBOiOVzcTHWZRrSkwagrFViknF9atVT/h+XfQE8WfGD4GQ8VBaYe6o
         J+1pU5t7jqmHtz76ANWT1Hz+L/S8T/h2JzgIwXluJ2pg0SjEHcwbI4wSd5caoLdcU3LG
         LSqZq4avFPdx5vkIQaU67d70BBYG+JtePR1FFfctY53iWLDaAAAeoBPIzFxA+gZfnoRx
         qDvd/LG5ha4kRnpS3ULasqV/MPa6ptHWZUbfcmp3ccgB4PFVfrt02q0mx2NAB+taApiY
         J91QBqzzghMtKcrET/1xiZnN5cCxF5HVnlAIvLBjOmOo6mUwtwc+SZuzloiv0hObWPR0
         yPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700112357; x=1700717157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMh/lVBezDPicasXps/0vs6nsdfTuHUrBfcS44Fj6bs=;
        b=HiN+HW1Hzg8E6FWx8XKorZKtWzHx6cF05fF4jUYS0BBlrTksgXokemcJBAszwBvTsP
         WcTt1V5tQ2YHBelNphVCR9UA74MhaXPPnKOcP3RN3iT33o92r8sU5Q1ILA/Qlq185+sI
         LGF6l77JpiZ+zqEZClUBmlEAcwquZF2VMmAiEo036jpgONb/yLoXkFcx7nq/W9chCSyj
         3tPmNV6e1tu+AgYqgVN6txV/AI+VL6/LGf8sJFZ5JQKder34cMeI+6oWnMWyaq+0VNCZ
         t7qYng1Sr4Bk9gFriYP/MzoX1vSr4v5e0WsY/1UMjIZMbKCIG7HFeYkPzJod+YCrVLkp
         q7AA==
X-Gm-Message-State: AOJu0Ywnjf+nzS/Nn9pg4F8uWycz0catFynH/FtjYTeSGqnyaE9jYfyN
	ScZPxDLxf65kWdieDlkSkdw=
X-Google-Smtp-Source: AGHT+IHYEk8PwRLlrmkqWfndJ2U9bHNdVP7j32XW5tD89oVwhdwC26pyul13q/4CEm9wgYrhB722xw==
X-Received: by 2002:a17:90b:3ece:b0:283:2805:7c7f with SMTP id rm14-20020a17090b3ece00b0028328057c7fmr1086552pjb.0.1700112357559;
        Wed, 15 Nov 2023 21:25:57 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id n31-20020a17090a2ca200b00263b9e75aecsm821288pjd.41.2023.11.15.21.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 21:25:56 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 6A09510207107; Thu, 16 Nov 2023 12:25:53 +0700 (WIB)
Date: Thu, 16 Nov 2023 12:25:53 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.6 000/603] 6.6.2-rc1 review
Message-ID: <ZVWn4Xl5KMVI9EGa@archie.me>
References: <20231115191613.097702445@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="x03+QSjLz6tnmKJk"
Content-Disposition: inline
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>


--x03+QSjLz6tnmKJk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 15, 2023 at 02:09:05PM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.2 release.
> There are 603 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--x03+QSjLz6tnmKJk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZVWn3QAKCRD2uYlJVVFO
o2ApAP9xp46GWUVFHlQccB6Bg5jHFWQQ5e6c+oF0ef2UbFz3eAD/QkcZFhBOs8zf
ZS91V2xJIHt2/XD2d1BGYeaacJzmcA0=
=hOcO
-----END PGP SIGNATURE-----

--x03+QSjLz6tnmKJk--
