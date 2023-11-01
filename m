Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB08643
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 02:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O7qYy4tB"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6b497c8575aso6398410b3a.1
        for <patches@lists.linux.dev>; Tue, 31 Oct 2023 19:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698806402; x=1699411202; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=smBpOYfhk/pfjcNNkpsnE2kzTUguhXJpDUnYBF4ouWA=;
        b=O7qYy4tB+DmfzzfQPi6SGEyJBPv4+egUfboG5BR2gLc3eeNik5i9MGX3D4i7y/dkDm
         WBk8Rgao87lc43DFXQ66lF+Q9Wz0kbM7glN7mE8Y/KrQic9h6l8mEj2eKW3IhiAYugh2
         UTZdvvhTfyReOdYfrPcMEJshWecTKaiNUhjz50vEAHQXaSCXQrBgudN3wTtFAqgq57Et
         2cx51R2FTyA6b6/fcs5Exg/AoGKiOS+sxAbeiusL/JVv3EE8Iy5fnVK2omOWdvfVbA5V
         3Ohlfq00KPEV93ZxbPlNWmN25DANJwofVqNmSCUCEQ/ReMmNB52h9W40BHIFeeZsZdpz
         igkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698806402; x=1699411202;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smBpOYfhk/pfjcNNkpsnE2kzTUguhXJpDUnYBF4ouWA=;
        b=Jbitx10F8EJrxF+uTiOD1Z4NVcrf4ftIGx8k2dOi9qxfIWE8nJzT7eZhbOndO0ZoPI
         3rH5K6sOJSLFM97SO2/1kg6N6jM2GIozC7W0X/AjVZuUFBuhswA4oQ3M0YUW7E5iaDaG
         yRkqNbHJl/jm8jyP4YX7L0FjAtNgJgrKkzyfheNJ1iV9z9VoohRhqNYrbTqjJ9iFzc6y
         zGKy5AfHGMlrnHPa3HPaY3HEFjHAiRHHwGIenWF5s0Hb64o7h/FCuH2QYAEJOZI5tuvL
         vp0xE+W/BQ2/U38t4iX/DNQ2O02P59e6kQ6hn/bTnpoYG+h2OCvrgJLg1LWihQlTakvX
         CSFw==
X-Gm-Message-State: AOJu0YxzDBVNr0W4/F3FkZS1a5ySttE43CL6EkRORXdEDTFFE5r1NcD8
	fyrgx3EztjL0iSYuhDFjw2o=
X-Google-Smtp-Source: AGHT+IEU1DbHr8uTH1PfA/nWbS6KaF/gSC7AdcTayM0DEzrlfEMfGNN/X2pvFenfh7Zr12AsaZMV2w==
X-Received: by 2002:a05:6a20:3c8d:b0:17b:2e82:d4ba with SMTP id b13-20020a056a203c8d00b0017b2e82d4bamr19606806pzj.3.1698806401623;
        Tue, 31 Oct 2023 19:40:01 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id gq9-20020a17090b104900b002609cadc56esm1691076pjb.11.2023.10.31.19.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 19:40:01 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id E3F9B8ABD28E; Wed,  1 Nov 2023 09:39:56 +0700 (WIB)
Date: Wed, 1 Nov 2023 09:39:56 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/86] 6.1.61-rc1 review
Message-ID: <ZUG6fHcNiIF_vAkX@debian.me>
References: <20231031165918.608547597@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sxvVJTZMXxphBC11"
Content-Disposition: inline
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>


--sxvVJTZMXxphBC11
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 06:00:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.61 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--sxvVJTZMXxphBC11
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZUG6dgAKCRD2uYlJVVFO
o1ydAP9JXEBXa/ufoSY6E0MYe4XOtT56JzoWsdWn+qQ2D0Sx+AEAsZMqP7D7yBPL
+L5H8pMdGsO5VhGXyEjj2Otbu/R84wo=
=Pbts
-----END PGP SIGNATURE-----

--sxvVJTZMXxphBC11--
