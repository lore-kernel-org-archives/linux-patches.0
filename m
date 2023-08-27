Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E61D62F
	for <patches@lists.linux.dev>; Sun, 27 Aug 2023 10:49:23 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-34bbe9e916cso8311755ab.0
        for <patches@lists.linux.dev>; Sun, 27 Aug 2023 03:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693133362; x=1693738162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pW7IzFA0mTX34WomjctbyWOYGPZAXEGhbrFXLCtnqaw=;
        b=g7rTEQDet1fKpExTG3EFTT+sTkjp6iso3Fb71bHkDwSLdvG+tEl60fXwUO36YPt1ir
         RkMZJ2HP7sMC37Woi9psbrpESHQ6jzJoKq8XdOon64ARpxGcOvn5i9CUjgW6BRMCZuMW
         xSX5gEuKphIvTRK1KbMx1VTnqj5n7mHMuSwFs1024dYCkrpEbeqCkwNMFDF0Oha9F+5U
         f3BczKeElsrModFN+xniZOnEnE6zlPny6wUazEjYFFpeTS6zyj9+wdfWmvpYOpLPHMmQ
         +hDodKK7ZVXCh//t4BKhYK1ztJrUpW6WEZ7kuH6sLo1L3yCX5G53R+KGHjU/tSoZ2xSp
         njqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693133362; x=1693738162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pW7IzFA0mTX34WomjctbyWOYGPZAXEGhbrFXLCtnqaw=;
        b=EtR+6c4QWn0IsQDFRpcciLJTOGXbf8mZjFUWa3Cc6Ac/PcLrrmhfBsx4UwY5pp6rim
         60QChk+64Qb7nn7cvqtGIEqpEWI7qTG0+RFMEKjoutOb24M/IBo1ZSSLVA8+hAGRmd/g
         INxFw+qR2VFw9c133nwhlJqLR62tUkzW4QXl4Tp/Vy/mozNwUqEWmqN239VfoBWDUa1s
         6Ii7B1//KVv7fl+cU7D6LcnD++WaNJ+0mjcn+Q73qc2/3z7gCUASKn5pEiOEQwNFB/aX
         mD5bThsFw2DP9MK55eZsAYses4Rx5kvQtecLNt7YKetK1/JbTLstLzrhW8SVY3dMJiFK
         Z+wQ==
X-Gm-Message-State: AOJu0Yx52LMdjXkGaVVclYeBBN4mdHPas1KNlnM76z3irj1H6kfA7LEy
	qoYFvuSkyBXJBLN3RSgGXkEBmCJiK80=
X-Google-Smtp-Source: AGHT+IHZK+KETXES93aurwx91PrqJAtM8/WBWNO/krX25zFGiQVPK+XzbIEnEQQkbS5TXtzQVqTg1w==
X-Received: by 2002:a05:6e02:2181:b0:34c:e4c6:c51c with SMTP id j1-20020a056e02218100b0034ce4c6c51cmr6174119ila.9.1693133362040;
        Sun, 27 Aug 2023 03:49:22 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id f5-20020a170902ce8500b001b04c2023e3sm5068240plg.218.2023.08.27.03.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Aug 2023 03:49:21 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 0D8418158460; Sun, 27 Aug 2023 17:49:15 +0700 (WIB)
Date: Sun, 27 Aug 2023 17:49:15 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 0/4] 6.1.49-rc1 review
Message-ID: <ZOsqK0NvgddvFQkD@debian.me>
References: <20230826154625.450325166@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LAOyK7J7JXf1jAJC"
Content-Disposition: inline
In-Reply-To: <20230826154625.450325166@linuxfoundation.org>


--LAOyK7J7JXf1jAJC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 26, 2023 at 05:47:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.49 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--LAOyK7J7JXf1jAJC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZOsqJgAKCRD2uYlJVVFO
o0WeAQDF56rn55bfNoItb91KPLkJZYyGOPOwXraSMp+r2n89bwEAhkQUfswTlIgK
vAU9NK3a5gHRUqX3gUjdWCem3mlqJQI=
=NDqK
-----END PGP SIGNATURE-----

--LAOyK7J7JXf1jAJC--
