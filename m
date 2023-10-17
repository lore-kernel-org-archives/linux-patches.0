Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE48963D1
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 03:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UEcxFeNZ"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-5a7ad24b3aaso64099867b3.2
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 20:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697511800; x=1698116600; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XGJ46Sxqz+oCWAzTdlW20vwJ0Pmh7MhaqNxDWygSSoM=;
        b=UEcxFeNZqiYUc1bBybTo4N+9ZJUrGE+ro0Z8U9i8bZTFkMzyvYOwGbNs+eDFtuNIVa
         1erSHuGO2QTbYv6QtdRcj1rnzlJyYMnPuAOCnXifeyY1BSJvNZ5wubrL7ggu6HaHC1H/
         t+EpDq7ZADyGkRPBcKNnqKyWfxYDor+kyKLoOlmmxFUzPFsCB0thcEZUmt8Zw9aQMriO
         wMV6UQxgUrHzj0T4iFlxsml4YQG0zhR/xvb4ZYbbPuSblLrNQbRekWY86h22f89PJSZx
         HQCIWsZRJlpSYqpfO8pQpP9U9m9hADvS23bus01eWTG9wI8UAheIa3qEqgbMuGwSfxKC
         D7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697511800; x=1698116600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XGJ46Sxqz+oCWAzTdlW20vwJ0Pmh7MhaqNxDWygSSoM=;
        b=EJJ3xeAIkyuL3E8/W4DaNzq34xLTVoyXPlJzXlbyn4lTywqCYYf9TRfLDYC2L6zccR
         oUCD7OgpbV3dOIQpufhU0ieafSG3A2qNj3isRtH69qKo3SJsNuu48ZsNJicumcZIRD5m
         YBulSsuG+glsiNsLRIknq2k+Gxpa9pzGEm9PUPkRNO6O/BJhwHMfhpII0RpRnLP9kh6D
         9EKoonjUqChvsIUgAiEMeTXnEl8Gb+mnQ3jJ31hrC8P1MW72dY5Fy9ehxyY4/2HEyHcm
         eno3ORb0vmV422Lv6GuAmdTpYCA30RiR69DR+uGiE4DKCOPUYYfaq6iTyHobskYhArRr
         oekQ==
X-Gm-Message-State: AOJu0YxvmnKYwK6gGfMLByhHHHVzyT+kNSXPKud/+g3qB8knOd1mF2Tq
	4GuqC6gds3KVOxqtNmtf6Hg=
X-Google-Smtp-Source: AGHT+IE3qls3ucSiKHuebUCCh6NxPHfeCNi0McQFh6VsAcRGGc88VSVdo677q6MCRNigqUeBRHS0kg==
X-Received: by 2002:a05:690c:ed1:b0:59c:678:7a32 with SMTP id cs17-20020a05690c0ed100b0059c06787a32mr1386436ywb.29.1697511800601;
        Mon, 16 Oct 2023 20:03:20 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id jg1-20020a17090326c100b001c62b9a51c0sm322345plb.103.2023.10.16.20.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 20:03:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 7A45F819CFD4; Tue, 17 Oct 2023 10:03:15 +0700 (WIB)
Date: Tue, 17 Oct 2023 10:03:14 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/131] 6.1.59-rc1 review
Message-ID: <ZS35ckiWx0Zqqx4I@debian.me>
References: <20231016084000.050926073@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4LwvL73jkubLOURz"
Content-Disposition: inline
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>


--4LwvL73jkubLOURz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 16, 2023 at 10:39:43AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.59 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--4LwvL73jkubLOURz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZS35ZAAKCRD2uYlJVVFO
o0hEAQD9V0N8nU9zFWIUPJ0WRVYnrDuv86YxXQOveNrq4P0ZyQD/dqu2x1uuIWpA
rQzsT+eEu6JOji+Hdsl+p9SIWDWEMAI=
=q/TI
-----END PGP SIGNATURE-----

--4LwvL73jkubLOURz--
