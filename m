Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512CA7E
	for <patches@lists.linux.dev>; Mon, 29 May 2023 05:11:56 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-64d5b4c400fso3362572b3a.1
        for <patches@lists.linux.dev>; Sun, 28 May 2023 22:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685337116; x=1687929116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7fWsFszs5kxFXpxFnuf42wnvADDMveTm0oNoJ2D/ov4=;
        b=BxdF15YGTOpjAaVjgDpRjdkJbrdFqLP3TK2/U/61DfKn82XUM36NhvPQg0KB5a6uhk
         59/GOELY+NsE67m81mBP6t8WyQJamm4MQoU9rK4iwcBvowKgNYt4Wm1kNQIbNwY+/oNb
         KDmLo2CgxFz6dVQEz8LpC/ddLODUckzLyw6c5lf0vkyxBFxSQkzCWiV03JK5RaMIfbgD
         zDHPEDbPc8fya120tdzVqRrhvd7nIWbdKZoVUyl/JrWJuy5cLOzngk1mhrmGRJwVURAp
         JiXPH19+FCV5iVgKJSs1eZbbLBCU3X6CXsb7N2pkV1JH1kPjTqxsY+SOl/wD28/Lj+Ms
         3RTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685337116; x=1687929116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7fWsFszs5kxFXpxFnuf42wnvADDMveTm0oNoJ2D/ov4=;
        b=iUFRmK5af3Vp3iDEw8V/US9g2V5JH7uWfcwi0Vj6LslytOUAKc0BKgM/je8jbT5Ohx
         xAkXp5FTZP5eiN65nk3sVczzYdz1Esk6YkUZHVBtXGTXinA8Wbh9WuEkmIu25XfxH9Wk
         MSH2JLKR/IR6/C+uBdTpb+yT/bGd323bW+MMlpknGwF7B9pkHxvKRSheias4PapyCpAU
         rNxc8ZFS0a/dgmK4GD1NsrCQDs9BZB5p39lysR0AZR9HX167MiXkPwyIeNzhS1L9kJL5
         BI1F0wshPKwol+TuaJjR5P7bPQiSoNWXtlh4wij+1i0gtsvm3tP4A0QNA6doBu/4oW+T
         kr8w==
X-Gm-Message-State: AC+VfDwGmFaYgVasDHxTMUPAPETWN/zWyTxEO6NILK9UAseNjE8Z6SiT
	xAynxjDYzzG1rzQ3Sc3t0WI=
X-Google-Smtp-Source: ACHHUZ5Lla/hNu5LlJ/h2XcIpuieHaRitgQ4OCLZz8tvU8S0cDgEbUxNTYgZTAgQOGkV8bDHWraS+Q==
X-Received: by 2002:a05:6a00:2484:b0:64c:a554:f577 with SMTP id c4-20020a056a00248400b0064ca554f577mr13982201pfv.11.1685337115665;
        Sun, 28 May 2023 22:11:55 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-18.three.co.id. [180.214.232.18])
        by smtp.gmail.com with ESMTPSA id 23-20020aa79157000000b0064d71d8dddasm5962620pfi.196.2023.05.28.22.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 22:11:55 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id E5CD5106A15; Mon, 29 May 2023 12:11:51 +0700 (WIB)
Date: Mon, 29 May 2023 12:11:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/119] 6.1.31-rc1 review
Message-ID: <ZHQ0FypIRK5rWY2Z@debian.me>
References: <20230528190835.386670951@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="S//Goj1zUX6CRAB2"
Content-Disposition: inline
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>


--S//Goj1zUX6CRAB2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 28, 2023 at 08:10:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.31 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--S//Goj1zUX6CRAB2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHQ0FAAKCRD2uYlJVVFO
o1uxAQDTFAwpmMjunL/H6GMVVczQ4uO9M1qQMA/r3WMrS+fuogEAxhRy3r+Rvars
GObpMDDqMIDC6I9TH85UeKFuPea6dww=
=NCX7
-----END PGP SIGNATURE-----

--S//Goj1zUX6CRAB2--
