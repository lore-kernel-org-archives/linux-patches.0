Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75747628
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 04:15:25 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id v23so21222456pju.3
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 20:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=owGrdmD6M5GkWkPONhYAnjTsh6hbHgml7pZ6gSujKuw=;
        b=EE/ouegsY6Ipuhx5f8V5bwezV4hjMFmr2EvwSqRrP79fiFqTnxPYmzKBpPu8s+1Ll8
         lW0pcs833q5DjLgyoWDRuXhfi6ZSRuZKi8kZfIlqUSSoMSqmIft4mW6ygrKCm69iSwXL
         PCUj81A+jXvKlxkOikMbvc8Ynq6EHHEmoy2MTaxMUoX+axArK402EZRKvs49WKPR62Hp
         h7ZHk62lF/U4UZZ77c0BZKfNymRF8tN88H7vqP9hfWCSKwW0GzwIBQLum9C9Weh7hT3X
         EGXe2qg6XZ+b6DFuprWdVKTGXWQgm3sGYSgsrpASKc8EJVYw0hUOumNFVAnrTKX5lpde
         QvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owGrdmD6M5GkWkPONhYAnjTsh6hbHgml7pZ6gSujKuw=;
        b=i5Q6mshF9EBWkSKWaGK7nlGZQuOHdbcPjdyFL+O99rodAWuj6p6LK9uceMGjHCE7V8
         A1NEtZW7YcZiQc+656JdlFxTB9sjQmBO9+4ZyoHNFk/oSjkXEHn5sigOCINDbz0xLj7D
         PRAVHCaeWzK+tajFkv534aJp+zs8EJeGUFl//Vg7UemFCVB0IURc4udTrYH1SyxD3fQz
         Hy4KFoObsEZH2aXXSAOPkzRA235mv88DWu375EFvB2gj7yjJY25zv9cH0qRY57PIkPB8
         4H/4qv9+v6SxMaovGlL0vITHq44nxnN0pIEQ7R5hHQTlH2bf31qQPhEchjTTdFrV4g+v
         hVKQ==
X-Gm-Message-State: AFqh2kqsB6/LgbxoLBji/HgVcUeKXh4VfrAffHlbyaFfma1NFQnV2oxX
	SuBx7dP4hjwuZIqmj6GMjQY=
X-Google-Smtp-Source: AMrXdXs2lDdkOntcs6E+HrRmEt8fujkeEJ2OP1c6TmntKOMz1NsdpbYm/P55TzkysVtlxQE1iAdBRg==
X-Received: by 2002:a17:902:8b88:b0:192:b2d3:4fc8 with SMTP id ay8-20020a1709028b8800b00192b2d34fc8mr9136045plb.1.1673583324917;
        Thu, 12 Jan 2023 20:15:24 -0800 (PST)
Received: from debian.me (subs03-180-214-233-19.three.co.id. [180.214.233.19])
        by smtp.gmail.com with ESMTPSA id cp12-20020a170902e78c00b0019276616eb0sm13024781plb.83.2023.01.12.20.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 20:15:24 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 221E7104A90; Fri, 13 Jan 2023 11:15:21 +0700 (WIB)
Date: Fri, 13 Jan 2023 11:15:20 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
Message-ID: <Y8Da2By1yzk/5rs9@debian.me>
References: <20230112135326.689857506@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="v+IuJdQt9LwIUu9M"
Content-Disposition: inline
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>


--v+IuJdQt9LwIUu9M
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 02:56:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--v+IuJdQt9LwIUu9M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8Da0QAKCRD2uYlJVVFO
o1XqAP9ODDgyzKJbSBYvnY3h+M8uXFioTwKcYYOWrKQJNo1zywD8DzaL64rLDIMS
tYr5sI/wIdokXkcn6F2ci46+02TKbgE=
=5AkB
-----END PGP SIGNATURE-----

--v+IuJdQt9LwIUu9M--
