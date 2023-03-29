Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46232EB8
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 04:09:50 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso3164924pjf.0
        for <patches@lists.linux.dev>; Tue, 28 Mar 2023 21:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680062989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1k1VpGQcdU01YaRH8iXtop/VWOjOXl1oxQqYfGF1hdI=;
        b=XWOPXensr6BD6UmAN+8486yLuINJtZTYTEYfiOvO+Gtk3NVUN+0ibF0SywkiBjQ57U
         PPn1qAJYewu1H0iBursV2MuHwr/ZS188z6+4gQ6BTq0EYlY3usxZ1MtISOALdufN65Re
         pN5fqXYlNmrhT+pxWO7UWEHzJlfT7BtZc+Vu2V90QqaleKpX0p8SEG551RztYeGoHk95
         W/KdpPizkFsHZjhHn9EIXzIXLQ4rO7U+tgJb9FwXd0KQwN6NQrPogmu1iPzHn6DVW5sf
         Zdd7F82a4R0T8jbvKtKn0L1fikrWlcBY5OOnQyZe/i0Frg3SwosikpK2p6m1g4955l+g
         D/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680062989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1k1VpGQcdU01YaRH8iXtop/VWOjOXl1oxQqYfGF1hdI=;
        b=mUP2+zNvpPoB/irXHjRHgGZjJm33kD/52csFHpshyg03tD6zInTdkgztuoHkrRDaCG
         yNtCx0RwV8L2R4X7EnYcuuhvcBEYWPSB2OY4++v2/yXicRATu/jhmeJKGmZz2QEOBIJr
         5pnKTygZ8rFbA1F1o9rKoC1H/fgRofSBtPgwVjWyU/VmIgwJO6IFXKn3YQqpWxYeDAyn
         BC9oXCKv4VBsBlSfctYXmKLsK6pipjndGad+trXUrUcVd4tFh3F54T78p+276xNFccwp
         LroENpJBdkWddmcPfe1Oai7UxDtXtySRwPdV22JUURz6wzWwOkmGKX0gFgez8IMuIC/R
         JG+Q==
X-Gm-Message-State: AAQBX9dhRb8l5cxgtj2T4IeqLbc8w7WTvYf630MAYTNjctvIyrOjxNcN
	yQ5R/IwNbYORdiXXzskgJAw=
X-Google-Smtp-Source: AKy350ZzpHzMOSXNdWkrJjZtVmC/YU/MiOn80uzx0niC/Qy/8veIVEn48oe3KeBP0flRzRNlDrZQpA==
X-Received: by 2002:a17:902:cf51:b0:19f:3b86:4715 with SMTP id e17-20020a170902cf5100b0019f3b864715mr15635961plg.8.1680062989642;
        Tue, 28 Mar 2023 21:09:49 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902820600b001a1add0d616sm7014361pln.161.2023.03.28.21.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 21:09:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 40113105187; Wed, 29 Mar 2023 11:09:45 +0700 (WIB)
Date: Wed, 29 Mar 2023 11:09:44 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/146] 5.15.105-rc1 review
Message-ID: <ZCO6CGVdiD58Jz0n@debian.me>
References: <20230328142602.660084725@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="48/u5+Bp6VaoDCJF"
Content-Disposition: inline
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>


--48/u5+Bp6VaoDCJF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 28, 2023 at 04:41:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.105 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--48/u5+Bp6VaoDCJF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCO5/wAKCRD2uYlJVVFO
oyJ3AQCtkjVM1wR2jDxtWm2o8sA/jypxs+hHA0WNuPlK9PjhxwD+K7jBbOgRUzVd
gl3+exhqQjW/u4HUpipXq7bXKSRKeAk=
=xbdG
-----END PGP SIGNATURE-----

--48/u5+Bp6VaoDCJF--
