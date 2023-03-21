Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE9310EB
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 04:47:48 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so14725714pjt.5
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 21:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679374068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+dVj1VzSpbPR2RhwHc8ratBECYHH5UrJY+Fvl7aEWQQ=;
        b=q0zV4KNGMHEREJ/mkfh10VTg0eHVBCosCklEK67UqPRjIUzQ96UVxvxzfsXA7zfxb8
         cgcTl1hxOsOWUWz1FcEYpSeFTng4RTf1F6UdrfMOF8ToyBuNAhl4icjOMvDXOCSB3gCT
         XOfvkGdlisekMf3OfwQCuV7nHYR+azUByiz3V12Q6lfNsOmSKVeUVHh8yIWUq3G3Ev9a
         e7ETEOpFzmNco6HpEtOMDUt5RcJMkoq63aQY/WDbEZuJ2eglEw46Cr6B6ahjaugojU36
         O3nf1owlvqKRyRhhb8YmiSkIQC00ArAszcgANbV8W1IzepCLH5NuE8OuIK/kXZho6r32
         xnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679374068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+dVj1VzSpbPR2RhwHc8ratBECYHH5UrJY+Fvl7aEWQQ=;
        b=ZgQT1k3FiTsdbUBPE1EekrdEyghNx0br0aK9RZwBTD2Ba2xEIuMB8GedTFvVPnWO0i
         zLXwND6hEhmox56lxIx3bmc9wfjhnHb0AW/VqMbGkO/hsgEd+Ev+LdSC55lGHuNFjlau
         8q7fBiELQYaf4NEziXjO5L/yAkwrsH8YfOGRz3B2Y3wA7MCThr9CXZ/WWg6YWo6PjtOa
         9s6ObglSjSw7oqephsBbijD+cCJBfVAnGftLpLmcdgr21cUZ7+voxHi48KOBmI4FPznU
         N5NfGErYt62AvjQ2Yf8mPkP0OOF4BKwqoWeD3AgXbVw29Xf4w3JsrZdkgKFNJh0V8MBw
         A3ew==
X-Gm-Message-State: AO0yUKUassbkH9FATTQpX2v307TZ9s2BRBR0wIxqu094rRSI+12mq4Cl
	p/KMTq98mJIuG9FzWFZNqko=
X-Google-Smtp-Source: AK7set/T29DuNDozUngNweIUAsNFbojutISVoEAVh0VL9cR7vuGtLvkeeHlbxFsmH2asPfQfmc/ftg==
X-Received: by 2002:a17:902:e544:b0:1a1:7899:f009 with SMTP id n4-20020a170902e54400b001a17899f009mr14032012plf.17.1679374068164;
        Mon, 20 Mar 2023 21:47:48 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-8.three.co.id. [180.214.233.8])
        by smtp.gmail.com with ESMTPSA id g1-20020a170902868100b0019a593e45f1sm7537103plo.261.2023.03.20.21.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 21:47:47 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 35C4B106610; Tue, 21 Mar 2023 11:47:43 +0700 (WIB)
Date: Tue, 21 Mar 2023 11:47:43 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
Message-ID: <ZBk27y+w0uRWvJKO@debian.me>
References: <20230320145449.336983711@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QXHSibNFs0lIniMs"
Content-Disposition: inline
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>


--QXHSibNFs0lIniMs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 03:53:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--QXHSibNFs0lIniMs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBk26gAKCRD2uYlJVVFO
oxbNAP9CygCQn9fglqg4RAltk3neI5NCbaBTaZjzqi9MHSaTvwD+MSSoQbqErrkx
nEVxfwKnopJwUCsHN6sf3kaYn/ATdAQ=
=zAEm
-----END PGP SIGNATURE-----

--QXHSibNFs0lIniMs--
