Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63927E
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 03:04:54 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id z14-20020a17090abd8e00b00233bb9d6bdcso8989632pjr.4
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 19:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BLeZPtMHf3JMYrRnDoKN8Adh6wZfHafqCrlDoQdGyUg=;
        b=AHgdOKQ4VAwC5odmRl1gZwqDYGasucGiufWH935kf9/Q+eBeVwJ4sqVpCipGSo/Fuq
         w5g2YPBJp9KFDF3KsZO/iCXO+QahQU1tVynBHRHtTAvvrNlA88BVNeFpYJ5YORN4EB23
         mKa6f4JXtuiGQfalom9qOJmZBv0hSCu6cX/YtTnur+sHbCFc7TULHFVA7QshDkL+z2dd
         z5byYZdT6Xi69clqlAFSEY9vEMBIURlh4GberERPNVmFmf4L1M59HXluoYtuOUt6cJij
         sC97myVEA5g4LVWZp3t0ZguvavkIzuAe6uci4Yujbq54LFPZnWMI+mxF0Y42vzx6+clZ
         jx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BLeZPtMHf3JMYrRnDoKN8Adh6wZfHafqCrlDoQdGyUg=;
        b=GOqA9UAQooSltx2Mg3HzqwljD2qaRJIY5DyqWr5/pSP0MUE59F492engyecN5K3pos
         te2g5BWK8U6jEMxvbzHjYKfCVJDuQjLXGNihEeh1p2ve1mIul/sYU9tfHRgULVQmuus7
         3xrouYsrmDTyjCnybo3wizdKV4krG0qldR1f4twOBWLrVVkeV7ymnvVOMCLRdyEogXSl
         OnMcAW/D0cHnJ17WphOIDAuq+ixqytJyJl/cqX/EiBrPNZf/yN2xYjUKUlzpIiOuZR44
         Fg7TATT2Q13lCYYdM4+37YzV4CO31KLTopCmYCHODcpRuDSPXLZ7QyX1915LvPr6BqQa
         +cfQ==
X-Gm-Message-State: AO0yUKWeUuwu62OB8g55oOM8+uJyo75/M7zt2AI6i3ZcBF2CVC8LGbO7
	1AECSf9csuLc6f2g+Qdz8lg=
X-Google-Smtp-Source: AK7set+b1nJIxt9rzoS4iHh75uptaPxw7B+uKvt3OMzH38KdM2xcgQGzJYg+CuiCflWEp6QENuoJiw==
X-Received: by 2002:a17:90b:1808:b0:22c:932:2870 with SMTP id lw8-20020a17090b180800b0022c09322870mr753025pjb.33.1676343894358;
        Mon, 13 Feb 2023 19:04:54 -0800 (PST)
Received: from debian.me (subs28-116-206-12-37.three.co.id. [116.206.12.37])
        by smtp.gmail.com with ESMTPSA id l21-20020a17090aec1500b00230a3b016fcsm5658069pjy.10.2023.02.13.19.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 19:04:53 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 8F2FC105423; Tue, 14 Feb 2023 10:04:51 +0700 (WIB)
Date: Tue, 14 Feb 2023 10:04:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/67] 5.15.94-rc1 review
Message-ID: <Y+r6U0WGARzIIwVN@debian.me>
References: <20230213144732.336342050@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YueW8T+Y9YHwfDOD"
Content-Disposition: inline
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>


--YueW8T+Y9YHwfDOD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2023 at 03:48:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.94 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--YueW8T+Y9YHwfDOD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY+r6UwAKCRD2uYlJVVFO
oyUeAQDQpI8CxBKqL+KdTOc/2eQWJ06RdkHSVJWDLUhOCP3W6gEAwZ74cmNdzzIF
7a7RvQe4u5gYQgUebltx9XtTBSA2hAQ=
=i7tR
-----END PGP SIGNATURE-----

--YueW8T+Y9YHwfDOD--
