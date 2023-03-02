Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78D310FA
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 04:27:22 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id y2so15592622pjg.3
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 20:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677731242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A8sq97E4LLj418sQlGio/HhmJSoILHKR0ZewV5pABeQ=;
        b=ZXaj9stBfP59NXhlrT4eSv3OR0T27ii6EnM3aWoGLdyG5LcFXPPTafX3o7hBshR/3M
         0NdpveDViNLFyH5cRB4HLAVomNw7jrbouwryny+rH0ENrWNP4yFXNZElL7WPhwiBKFtK
         HZTcQoIGlcinarKTfbS0BvksI9M8Wf1PeNze1zfdcWoWqcLxybw3DhGq81gPL9J1Gjx2
         vAiFD598tQ6Ls9cvnLaJgagWljnCGlCNMSL6YOz5AB3E/M0d76nPY/JFa9o1exR7+DLI
         jaqbgLloijr33H/Fa6HNwxrh1XCTrke4CiKvnSt/43Z+757RjBoAg83yvNeKva7cBjWV
         kdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677731242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A8sq97E4LLj418sQlGio/HhmJSoILHKR0ZewV5pABeQ=;
        b=XL1L0Pbh0rqj802W3XlyDHtNtwgFK17N0q0XsB8MKFErd8YEgu2uHzjzNe656uIdWp
         RgdZIk53hx8L8vNpEBsaZQsvWimDkXC1iYGDNUVcszwtrnWiq+hg/UicZbRzWYLoGTXy
         0cAKLC51QsIy4gHKKwnU+drD+ZwSoRgO1/mA1OJkZtxV4hj7oRSuYNc0SBy706a+a+pp
         fnucUhck3u4CaUY+yaI1MmMa1UcPIatPG+jF1PmKgWs8CgtHUsKMMTE+4TkF8CIPpAcO
         9a0YJ+AR+p2yO19HqYAYG7SS5+kiWIhTwnwiGUyhbeK3GfdVykQ6EV4LTqDYq2TXKYDQ
         7BhQ==
X-Gm-Message-State: AO0yUKVcMbgAaxTkXKFQEMyPJHp/Lw9baZy34NgYcfTrkry7bBJ1u3OM
	0WqRYxt8MrKd09h3Zfh3s4w=
X-Google-Smtp-Source: AK7set9oCDyq9E0UIU80iSzEKydP+3Vg+K+pewr2hrWawInDgMGoTmjWIbJTaHrAhkWf/vETMtzHfQ==
X-Received: by 2002:a17:902:c407:b0:19c:d0c9:8fdd with SMTP id k7-20020a170902c40700b0019cd0c98fddmr10870118plk.52.1677731242186;
        Wed, 01 Mar 2023 20:27:22 -0800 (PST)
Received: from debian.me (subs32-116-206-28-17.three.co.id. [116.206.28.17])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902eb4600b00196251ca124sm9213881pli.75.2023.03.01.20.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 20:27:21 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 4DF3E100634; Thu,  2 Mar 2023 11:27:17 +0700 (WIB)
Date: Thu, 2 Mar 2023 11:27:16 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <ZAAlpHB87vVbOV3z@debian.me>
References: <20230301180657.003689969@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kNky+vExhl07LyK6"
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>


--kNky+vExhl07LyK6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--kNky+vExhl07LyK6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAAlnwAKCRD2uYlJVVFO
oycIAP9uweOOeMpxQk+Az3hTQIepVpAWbU6zo3sQmBmF6clWWAEArGy3atPJXcvn
QLRaMSGriCUwhsv8TaZK4dMnsk93SAU=
=pCie
-----END PGP SIGNATURE-----

--kNky+vExhl07LyK6--
