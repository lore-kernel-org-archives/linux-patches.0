Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2957156E4
	for <patches@lists.linux.dev>; Tue, 16 May 2023 09:04:04 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6439bbc93b6so9793190b3a.1
        for <patches@lists.linux.dev>; Tue, 16 May 2023 02:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684227844; x=1686819844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QTk2JB5qtzjtXmG2THpqKvL1Vp4cb43nlo//b+FiHNU=;
        b=WHl/nuvVrGlgDNxCguiV3msHTZ+gcgELdJktTyHIG9RwULWoTU1mUv33rZvuEI5LaT
         EHYeOfGFJw1HBlP2i6nYuw2MCupCMxTKNPc4H3C1rGIf7XPgOdhYIxUvQ+Ga/KY/MRFa
         NvUxlyKOX2PEtBLCPW2ZHXUamaRCp9kM2etEkDABgUGEpdFXeZNLVC55yh7w9bMpk16z
         5IrLttMq1V68PGMsIwRsvC+qxZOuEFXV8ytpKuj/q5D4p+WDVDLO+4RhCIG+oYau3Fsh
         slSBNM3NN/atSVPgxkKFA77tLBmVC8xx0KWp2dXDMzZrfNsdlB9TpHPshlMbyQQT+zGe
         8k4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684227844; x=1686819844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTk2JB5qtzjtXmG2THpqKvL1Vp4cb43nlo//b+FiHNU=;
        b=EksCr1jagoIFW/6xjC99nLE13FX9sYR/IPMAR5c3MVSVvNq3uECfPlN2IMp7L2a5yU
         dFSNxzVcOn74SJR10VWhjR3h/sOeujjLm1fx1FhJhWdOCmGVamZrhgXkPXgtZxaScVgf
         h+34fAYUi33Zb4nyEcm66p08KIoUagb9gHjgsdwuW0TCEqTZhHbxGR69EiJEUnRoJwgc
         7gHHAGlTsUzKUNsoL4B+pQiqs6rEs1GyfEjlak1etZTxlk7PvyHvQE08ljQ/p3WyGEr6
         MoTUOn/bDj379zLJo6wlEIp/bljj615afzx/5yqJWyBjz+qy4QQJwksXy9jSAxIDBGF6
         brsw==
X-Gm-Message-State: AC+VfDw2T4aXNMgWwIvims9hse46Rr5HbTXYOAeYFSnejgR5G8zTJ+eG
	ies1yGzwUHwHi2xCFv317Ks=
X-Google-Smtp-Source: ACHHUZ5Ow2hobAcRBw44vduy5I8IXSjDVZiiBpG3JqSvK6rJj85BKwlk5a/iaDmkrvtbavbRA0JMYg==
X-Received: by 2002:a05:6a00:139b:b0:64c:b8bd:4192 with SMTP id t27-20020a056a00139b00b0064cb8bd4192mr4391563pfg.6.1684227844083;
        Tue, 16 May 2023 02:04:04 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id c7-20020aa78c07000000b00643864d03dfsm13491103pfd.171.2023.05.16.02.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:04:03 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 1E6B910621C; Tue, 16 May 2023 16:03:59 +0700 (WIB)
Date: Tue, 16 May 2023 16:03:59 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/246] 6.3.3-rc1 review
Message-ID: <ZGNG/72qJIgzJU8P@debian.me>
References: <20230515161722.610123835@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FjM7r4gpLPMzwX0D"
Content-Disposition: inline
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>


--FjM7r4gpLPMzwX0D
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 15, 2023 at 06:23:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.3 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--FjM7r4gpLPMzwX0D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZGNG+QAKCRD2uYlJVVFO
o6juAP9xTqCt/zT62kgR73+EU8saRPUDGrw9AYhB9u+KZQE3CQD/YcSeUbymw8oK
rbqjAZUqc6mASFYGqTc689ljFxzg0AI=
=ArBj
-----END PGP SIGNATURE-----

--FjM7r4gpLPMzwX0D--
