Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4757F5
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 05:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ryr4D+Tq"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ce939ecfc2so4571852b3a.2
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 21:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702358913; x=1702963713; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8eo6yjctVN7EWUi9qs5MkkJLw4hgrBMLP7fU3YS53r8=;
        b=Ryr4D+TqJ8XaZsrRXac3NxaobSoPEo7W1UB/IQlLG7oNl4xiS5WnlrxqFCkbU0C71Z
         /4uOsAqhaJ60ljBuV9q2wZI9CBIsOFkB0VHX80aIdEWSva01kZjh5haDK8VI+040QzSf
         pjoadj2cBIZWyKVyU07nhjYMeceddZFpSQ0Q5vxvZgT1MiyFS5CpDzJwYRGxsbmvuNmK
         b4CcsTs9E3YAOvu3GXrXU4A/JQQT0XRmqIUHimajRI7TOQMewevxvMlgD87rQ+RTDwDM
         8xA5vnsucGTyTKusW2oDB9OEYJW+HiqHiR1lDsi/nQo735wKeEnKsaU0ww3nedgKXNCq
         f5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702358913; x=1702963713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8eo6yjctVN7EWUi9qs5MkkJLw4hgrBMLP7fU3YS53r8=;
        b=gkV/HWcM5cpwkcRGYt3fRLQpWP8NyMDKJu5UpI+DXhbLaSFwIg2kOleUBXWqM1cf1t
         BG81wQXm8kNRzlkDajqD3RwuGIsTLTk15IMnnU1fkoV+oVpMX/fnlg4ERyWrqZN2DlgY
         Z36UcGWJqKzoATC6gxgObu9Dp/oKejfsomi7rDWoG6GJpch4JnADJF8RZcgwFSryK82X
         0HtllXQOOsR4SV2uILTbyDhjQtKC/HRxaSJqQljM+eipESHWlyu5ZT77Mojs9xTDTekA
         U2H1q8xnXAsQFNPP6Q3YV/PxYqy2OAbmT0eAjvb3XRM+rO768DxMUoSQkEMkCTToj4rQ
         kjlA==
X-Gm-Message-State: AOJu0YwpVQzK2MvDEeIiM1BXP1FR2+oxSMFNr8KhGAHv3NGxp4Ex51vQ
	qC0y2S05XPy3KhWA4S48MO0=
X-Google-Smtp-Source: AGHT+IF7UbX2/pPTwMPl1Hye6GIFCjFuSTaIWMIzOsQRGy1DF9a/LPHIs7w9Y1xC6zmxPm4U50S8cA==
X-Received: by 2002:a05:6a00:1701:b0:6cd:e063:3646 with SMTP id h1-20020a056a00170100b006cde0633646mr6629467pfc.28.1702358913261;
        Mon, 11 Dec 2023 21:28:33 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id fa24-20020a056a002d1800b006be0fb89ac2sm7200701pfb.197.2023.12.11.21.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 21:28:32 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 4A6751020709A; Tue, 12 Dec 2023 12:28:26 +0700 (WIB)
Date: Tue, 12 Dec 2023 12:28:25 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/244] 6.6.7-rc1 review
Message-ID: <ZXfveTxvjE19BSvQ@archie.me>
References: <20231211182045.784881756@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6RcIu9UoqRupJR7s"
Content-Disposition: inline
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>


--6RcIu9UoqRupJR7s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 11, 2023 at 07:18:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.7 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--6RcIu9UoqRupJR7s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZXfvcgAKCRD2uYlJVVFO
o8NWAQDQ/rgFgLfFaAGHXyuEHNQLATd6HctOY09VHyjBt/C+ZgEAvFtShxLlS4/y
yxuoWeo0NkWQPpcIff8iYhAeYZftUQ4=
=M5xy
-----END PGP SIGNATURE-----

--6RcIu9UoqRupJR7s--
