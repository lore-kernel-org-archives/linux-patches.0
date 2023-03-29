Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0980BEB8
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 04:10:36 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso2887126pjc.1
        for <patches@lists.linux.dev>; Tue, 28 Mar 2023 21:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680063035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gdJ67JL/BYKEZD41B62DqWcZtXZjhSsBusSQCh2eK7U=;
        b=OVfBbYd06oGJNclR2POSs2edkFbDfXaO50bJXon+CXUggrNECCiWRqeyBpcJMbjT1B
         VKajJQlj/U3XjF/z0rQeMLfn6l6/jSOxxa4anSQj+Dz1OeEJqj+Lx50tYV3yg/yRBHhz
         TyJBkVsor2Xf4MXHwYA1QB46E+KFZbiuiqyepQoAQl/gCvm9uKePs+XJCVaW1R5ApEY6
         LUlXjOBRU+CNbAKd8s/V1fUYCW11Sg50K4JIZjPYIaVk3GEv278hm/tNbIHvs3n8Xih2
         YcXionyZhZtBjebiMURtdC4P/GQa0RCWI0EBxMY3zDvM1A1M924MK2eCjFYtp5o5NxUU
         fAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680063035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gdJ67JL/BYKEZD41B62DqWcZtXZjhSsBusSQCh2eK7U=;
        b=bJyJAvg/Mgb+ubB7vRs1Azo9zj28s3vhf/vs/uy0foNsuIuDiGJMu4fPfTg4GAHGhG
         zydWPnm+2fhItDzubfCH3D7zrvMV0FjQb6c1fZDJQYwtukG3rznxWVopd89hiNQRVRLV
         ofjpn75kcsqNPmc7k+gckhpouEpWt2UPMlcW7z4MD2eAjQZx6PW78qhGIureNBF4EsNP
         RTa9DY6G2aIJEuVXx7DnsJypkkMffltW/BU2Cv3tOoEzNcnBRoPeqVe+Ur13FX33cFLd
         iGh7vpnc/XxvvZj0dtfRZsTxAnnlSO8khhmdZafkYOdZ+UKreWJTGU0D6r1kKMaoKkJI
         +qKw==
X-Gm-Message-State: AAQBX9efeaQltQaG++hoR+6cTkPmV8Vjy0qeUXRztLVgnHwCdNq8dx+X
	4S3dookr0Yi6emovhyy/q4w=
X-Google-Smtp-Source: AKy350ZdrRD+us05IF6DLSKbywx29W4cWSq/R/z9UbuG/7zsxP5GY4sTwHnsfB2S+BQCfjW00V6rXw==
X-Received: by 2002:a17:902:fa10:b0:19f:2b42:5d01 with SMTP id la16-20020a170902fa1000b0019f2b425d01mr15486452plb.9.1680063035522;
        Tue, 28 Mar 2023 21:10:35 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902edc200b001a1a18a678csm21925184plk.148.2023.03.28.21.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 21:10:35 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 537AF1066F7; Wed, 29 Mar 2023 11:10:32 +0700 (WIB)
Date: Wed, 29 Mar 2023 11:10:32 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Message-ID: <ZCO6OHxvy1ygyVlg@debian.me>
References: <20230328142617.205414124@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ub9ZE1zAU21X5pnf"
Content-Disposition: inline
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>


--Ub9ZE1zAU21X5pnf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 28, 2023 at 04:39:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Ub9ZE1zAU21X5pnf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCO6OAAKCRD2uYlJVVFO
o2xPAQCMFNnVidWn670etNza5biPUhkU2mliAmg1HVIyOlo8WAD+NsjmxbsNBzHr
8wOTssFX85vjwIf9q5MigaG5LHP98wU=
=gX97
-----END PGP SIGNATURE-----

--Ub9ZE1zAU21X5pnf--
