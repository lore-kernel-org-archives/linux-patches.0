Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C260629
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 03:22:21 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id e8-20020a17090a9a8800b0022c387f0f93so12595078pjp.3
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 19:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+j6pFZGGgujGy7LvSAngOzCpxRZrhReXbxCPaVYnQ1o=;
        b=n6mP7G80ow0Bpl7VY6gHhRpTwOhA4r5vC4lUmFFSUFTQZgDcQJsxvHRLZQ4yNRQLMo
         LYWDo4ms2sxPQZZFRvLvoUHlI11hAPAl23v5TVUmsNcpwGdd+wGbfE8QK/KEFvu8YVF2
         F1DrP7o3+H3rmVJyFbYNW1nIthK/OOZShtHnC2aS9k832Sp7fFa5JXc9DUkJJdiX2UFR
         5HxPZN5C1IeAjHpgHj/RYFoGEWIaWkITL2uja+h5x8Oa1KsMzChbKs9lbjVkZxSn9MnZ
         XsQvweoLjZSNhm5r1/h/zmtXT79i5KDfFdhF9+5V+9dvexIeOM3FoneKoBWElU7oq86S
         vkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+j6pFZGGgujGy7LvSAngOzCpxRZrhReXbxCPaVYnQ1o=;
        b=FjheeKBPoCQUh/KV4zC5L3f9t07/HBpC2Ur2jjIEFRuor0mJuqxpI3xJckSuRHzmAl
         zRe4A0LZBy6Nh0f3tJBlGy2phm22eN11/GXaVdF+hOL3ITu0qhtzNRlT81sLkYcv7Hj7
         4ej/ikTuUOISTppfOrYkEerZrSTGEIQxnlg+QvtITnPVYg//toC0BsSr20GVUlHxgEt2
         RVnQQoCU8oU1vd6c9JCRJ0IepsFBGvpwCh/GcpdAEPibzm7chsGCKd0th9fo4O8YqW2p
         Ty7H+05SRbftGToYGvRH2rIP3JDysCCovgWQF1u4x6vsj5DM3190Gxb6g2uqcAEda/iD
         xibA==
X-Gm-Message-State: AO0yUKVbeAGFlh66jco7e9mmg4mckYQTc89zzrtbSVpvzXIXUPPtry1/
	TlGlaJzEFfh7L6HFOr8JQGc=
X-Google-Smtp-Source: AK7set/FxqZFK40qZC0h14bLDj5xKY8N6wqL4cMXGwqLemqisO2JV1iOrHWYFQ/dTDr0U26SHBFc+A==
X-Received: by 2002:a17:903:2282:b0:196:704e:2c9a with SMTP id b2-20020a170903228200b00196704e2c9amr8909820plh.22.1675135340802;
        Mon, 30 Jan 2023 19:22:20 -0800 (PST)
Received: from debian.me (subs32-116-206-28-47.three.co.id. [116.206.28.47])
        by smtp.gmail.com with ESMTPSA id i15-20020a17090332cf00b00194799b084esm7692665plr.10.2023.01.30.19.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 19:22:20 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 105EB105433; Tue, 31 Jan 2023 10:21:03 +0700 (WIB)
Date: Tue, 31 Jan 2023 10:21:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Message-ID: <Y9iJH26f3+CzJaqT@debian.me>
References: <20230130181611.883327545@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hjO68foB3B0jiJqv"
Content-Disposition: inline
In-Reply-To: <20230130181611.883327545@linuxfoundation.org>


--hjO68foB3B0jiJqv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2023 at 07:24:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--hjO68foB3B0jiJqv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY9iJGQAKCRD2uYlJVVFO
o78mAQDFrDRP9WMRTYzmzU7J3ZSNI/qe47rjHOvPBFbJ4zZp6gD/RyFHSY8rfzNN
0R6QYU2pc23kLsHGaNXxcTuyQ5SZdwg=
=YDa8
-----END PGP SIGNATURE-----

--hjO68foB3B0jiJqv--
