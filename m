Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560D27E
	for <patches@lists.linux.dev>; Mon, 29 May 2023 05:03:26 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-64d44b198baso1983446b3a.0
        for <patches@lists.linux.dev>; Sun, 28 May 2023 22:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685336606; x=1687928606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZS7IsfdpubWMWbMIpSsxRx+ub93QQK4IFCY1BnBE+eM=;
        b=r/iPY92YyEc5+MDaILsPQQqvI9WFXX+4hU774+EUv6Sqsc2YqL7KPtQ5bQGcEXW8mX
         +wfnF1Wd1JC725MQ65yleNXQGCN5sNqZBGFLeXe9c9JYT1hcJmaF+DLqea1zxM1hOocZ
         GsQ0yos8BRDmLZIbrRjMAwwrxcxpO+V6CvmOUxPVly6aG3IJk1G7ItqJneFF26nhb3ng
         pbh3Zl8V9Gwryk+KAoM2xU7k/h0/igVs6Bgj5ZHU2d67rVjVZgxytvSr18thOCEU/Cut
         o73z8IxRLP6NQJooHynGhT5Q30/6sOrRyridqlWe3bkI9ooWNiUL0yEqZ+YhPAt/OfIA
         mOgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685336606; x=1687928606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZS7IsfdpubWMWbMIpSsxRx+ub93QQK4IFCY1BnBE+eM=;
        b=bzXCUlT+IlC4VIxNL1fyy0C+fAuFkIjFQGvGUsQ9EFH9so1E8YXEu4InVPydndu7cG
         5ffOJVVmrUf/YYCHxWxP+s3OsqJ9y4busnn+HZ9Cf4bUAipNiqlQBpcvDm09eqBcZGx6
         6YdC+FxqeF4QfaJTqeeesUWhAW4y+6TrPnSUDof+kIgJkaVaetGwWAzyQ8ol42ZKd3dN
         UnIdX4ollWESP9qexsVRuzqJ7xWFaZa2WwxZxzgGdIBaitDNWTpsH47EiPpg5dfRWxek
         vDhWiEYQ9mFoy5JwB9XD65y5szuU8bHyms3bejdxv2rU0AjwuEREyE/9w6Xhf5ryY+eq
         yL9g==
X-Gm-Message-State: AC+VfDw+MguDUNnQL63BgQf020z8MwTqtJ6noF17CRWA3ZHZue8Very7
	EczB3Bs9SSdtEdGz7n/18fs=
X-Google-Smtp-Source: ACHHUZ6mtt6tvQ+KHq1AAuJM6+9hmFCBIzLzhkXZXBEj9JRLqflfZsYHasXuQ+bzxBYhWfG4TKy1nA==
X-Received: by 2002:a05:6a00:2315:b0:646:c56c:f0e0 with SMTP id h21-20020a056a00231500b00646c56cf0e0mr7293552pfh.15.1685336605533;
        Sun, 28 May 2023 22:03:25 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-18.three.co.id. [180.214.232.18])
        by smtp.gmail.com with ESMTPSA id u5-20020aa78385000000b0064305676b61sm5921609pfm.203.2023.05.28.22.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 22:03:24 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 4AB191069EE; Mon, 29 May 2023 12:03:21 +0700 (WIB)
Date: Mon, 29 May 2023 12:03:20 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/69] 5.15.114-rc1 review
Message-ID: <ZHQyGGR2TBzuW_3I@debian.me>
References: <20230528190828.358612414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WJgiagu4JoyStVG+"
Content-Disposition: inline
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>


--WJgiagu4JoyStVG+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 28, 2023 at 08:11:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.114 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--WJgiagu4JoyStVG+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHQyFAAKCRD2uYlJVVFO
o29dAQCZe88o+K8RGhFVMiRABqfAHr4p6ODLJ6bGua9Ecn6mlAEA8GVDkv0+b4W1
AIujQRnwo0ml5L4phj70108U21h5mw8=
=Y/iw
-----END PGP SIGNATURE-----

--WJgiagu4JoyStVG+--
