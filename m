Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0680B8BF9
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 03:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrzFimGQ"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6b709048d8eso2214133b3a.2
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 20:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697513096; x=1698117896; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y6/kOuKag6maEqKqguiwwkDZZk+DdVjPal1eBex6cNI=;
        b=nrzFimGQhYIkqF/1kkfdvsbaBqlsYihQNYfIB1Wu7aEzfKaWPmZB7nbhRJ5uLryFMN
         Yt0djiWtowRmdhSjdgoAAMwKBJEU1LCReciRAXK7krzhHPij4uZbQyQl9Glpp08CGeC/
         zcilb8Fjg+GhabNeNloP7gslAJErDfcHc3u29+OnufdU5cb2rorFk3BWOmyB6rh8rPCP
         sE/ZdWiuFWmkBEbRf/rqdln5+M4VovanmOxcAez0bhR5MZWq298wKz7eDZk34wpa7pjK
         Z4iDEyZDtEqZVBzy5qwFdb5H6TxdbQzr9FU7wUoP8IyDidj4y4KfAtHD2mOv8ckq5Utp
         3VlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697513096; x=1698117896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6/kOuKag6maEqKqguiwwkDZZk+DdVjPal1eBex6cNI=;
        b=loBVr8dDs6MB+VZSoTacjUOyrVWjLS2G3Y2qsPbPqpc1bvGMMEertoideZB15UsqTk
         B+7sDo5l3M6TvXKmsa1qJiLEmYufkswrAIjcEoSBnGxswgBaoCME1fR9UWbWUvmYLKCs
         E/dwohXnQsx6wZtohk2qMAIULUgHravpxiBphJAjd6UCqF4HjzhELGkrcMxbIBjh58Ib
         znorkm5R4fXy7C3ejRIjz7Cagu1ztlGgjiUzvpZZBuKsGhwUAuGFbJkcazTJehuTAm6S
         20BZwKF8QaKvOVu6cDyqH3jjOFdmnxZzD7TyRNZioD8NPmsAfssyqo+4IBV0bcXqmnZt
         4INA==
X-Gm-Message-State: AOJu0Ywn3wH7oDATtj77kbgoxu1C5hbO/iZlPVfQtYe+TpBrK6Mcig1/
	5yvDHFWTRC0cI2Qvglx2p3I=
X-Google-Smtp-Source: AGHT+IH/k/r0RAjJkMceTPBqzDYnJbE1R647TfI+lJGjjuF4cLnYArt5BWTtw6p2Ciqk/goWvMraKw==
X-Received: by 2002:a05:6a21:3394:b0:171:a3e8:8c05 with SMTP id yy20-20020a056a21339400b00171a3e88c05mr985447pzb.53.1697513096214;
        Mon, 16 Oct 2023 20:24:56 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id a2-20020a170902ecc200b001c9d968563csm346086plh.79.2023.10.16.20.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 20:24:55 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id BA6288026B2E; Tue, 17 Oct 2023 10:24:50 +0700 (WIB)
Date: Tue, 17 Oct 2023 10:24:50 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/190] 6.5.8-rc2 review
Message-ID: <ZS3-guNZf9p14Ys0@debian.me>
References: <20231016185002.371937173@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L7zFWBF9Sh9LBLK+"
Content-Disposition: inline
In-Reply-To: <20231016185002.371937173@linuxfoundation.org>


--L7zFWBF9Sh9LBLK+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 16, 2023 at 09:48:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.8 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--L7zFWBF9Sh9LBLK+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZS3+eQAKCRD2uYlJVVFO
o7l8AQCI03RMOn2epFw7zrBnWWf6GythfmHBsFeEO0kYnZWZ7gEAhzwMfleTxmYK
0bXnnxOImsInevciKiCTXBVdcH5vfg8=
=XPKQ
-----END PGP SIGNATURE-----

--L7zFWBF9Sh9LBLK+--
