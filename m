Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAF012E52
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 04:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YaqkUvqa"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6bd0e1b1890so3962246b3a.3
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 20:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699331656; x=1699936456; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5v+xl/QC//ZLXXcIvchI1qCynqxscf2nvU++0XNR+5I=;
        b=YaqkUvqa36CuAuKNnLE5AEKR1aYSUJMOKIvy/bWSAcq+Vl5eKzaCUvjn8/WTCNiWBv
         TY/9wxVSnJW/Go4Pb4PQH7EZmJOcNGwE8op6UGamiQna8iKC2a9eQ8iggwlUuTV7sRMY
         OwBTtSdDuThxV6aBbEPdqw3XUgKGRn1bBsdaqWNwFttN2afMZ0GLETrtIMxhrm+GLEhI
         AZork+FxlaJmCcCYDndEjuvX7vNLhjF4UFAGkyFAvKlp/orAeCD0Yz2kFpLl/9oDv72M
         G1bLPWgKL13vxxuXq6En13PRstdezPq35gCrRNU6FWc2ymdtHFLrfWl95DekOJBiUyVo
         qClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699331656; x=1699936456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5v+xl/QC//ZLXXcIvchI1qCynqxscf2nvU++0XNR+5I=;
        b=QU6b4A1S4XFp8qI4tsHierp+l3Sj2k9WK1FqU4VTZNXrCLjmMpnplzG2CBlpFCYg3w
         kEf6DF4ZvaS1YOT3KO/vM0rOa7YozmtrxjjqhLyjrEtGqv+vakWan1AIStkd7l/1e0J8
         0VhkS5sMHqW9IjRy4MmTkPY4YM84IAiySH4n//7nurjKxdAE8LWq6RDUTnpeK8sFkQBl
         QpPTn11qeXoZb5cMoB50rV99yEtpz4MU4GzgmeZJ++naPCYYD47fLbL5YSYhS/MhY1cQ
         ffggkFl2Zn7JqU68lGspuPkALSiV0U9V5Qq+mtv7q8tWdaM5wbzdWeGEF3L3vQ1RNr54
         P+9g==
X-Gm-Message-State: AOJu0YwFcacrZHSKetUrvS9qiubpx0a331TIzP0g90JkROcRjqoiI49Y
	9olrNOu2gYDX7gjkrmqajLk=
X-Google-Smtp-Source: AGHT+IEwICaZQxiKeFyoKwec6zvfZKlIIRbttwjmkWelZjZ+lCzAKASY3Jn6baxUKlpZ5E4prH4YBw==
X-Received: by 2002:a05:6a21:4881:b0:180:eef7:b3d9 with SMTP id av1-20020a056a21488100b00180eef7b3d9mr18747589pzc.57.1699331655723;
        Mon, 06 Nov 2023 20:34:15 -0800 (PST)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a19cb00b0028089fdce19sm6766313pjj.52.2023.11.06.20.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 20:34:14 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id F033D812C340; Tue,  7 Nov 2023 11:34:10 +0700 (WIB)
Date: Tue, 7 Nov 2023 11:34:10 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 00/88] 6.5.11-rc1 review
Message-ID: <ZUm-QnC4f1UMABXf@debian.me>
References: <20231106130305.772449722@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ibMRfCjAH3gXg/1B"
Content-Disposition: inline
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>


--ibMRfCjAH3gXg/1B
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 06, 2023 at 02:02:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.11 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--ibMRfCjAH3gXg/1B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZUm+PQAKCRD2uYlJVVFO
o+O3AP93TAdIfltAG1Zmn9ePXLdsRoUFdlwuagy9P9xVHJSd+wEA485XLpco1j3F
wo2v/aTJZ51o+wPqdOTmZTTVNb0pwQw=
=cnMU
-----END PGP SIGNATURE-----

--ibMRfCjAH3gXg/1B--
