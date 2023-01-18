Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0A91C04
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 03:56:14 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so964234pjl.0
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 19:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TLRE2TXuEi0Oi6Py0U1FjTjvdMX6n7zTvdehmRccvQA=;
        b=p+9eUJUJfVS8n33t98G13ynpg+3YLMTqLbo8XZ3+W5aAq0J7WETPVlEbn41TzJcKYn
         kniSfXDzU8fj1Liw9pei1Ql4kWXqPx3BTNENPHUFKwpQ3jymgSqPRG7DaMVu1Cu80FAI
         rVi+ICZpl8NBtsUfoJYIgJI+ulrLmSobPBeF9kDLkkukzqhakrRHmCQhJilpvLDSXuTj
         FAEpKoFREtobxnFQ2uS52hp1HVFlF2CwnggdK3r5ptQNGBz2PiDqeWzbIYE6jh179mlv
         jD38/RK0naUD6lAvAtFNznD1k3Vk648Wi4Si1yirSmUizPOyEKot+GZ8dM6LjLJ8r4qJ
         xeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLRE2TXuEi0Oi6Py0U1FjTjvdMX6n7zTvdehmRccvQA=;
        b=v1mhdOJJuVo5STnQjtS0x+JfKQjI4Xs9IeIPuDcu4bfXB3ybP3wBZvh8l1U2PW6ZRt
         ser0NlpFIJ9x6lwtZqcRYxxpMnkMK4kltcftlfdoWwsFSM9LiT9LgsyyUiiFsPSu3IEj
         8Cg3duJDQCTX74gsT2lIEGEByKGtJ2LrwEKxWQ5KGfkYe1LdORmG3vTxmDBdz4Bu0xwT
         c8YSVTB09rhVeaxWX3OorwblaYWlG53yQCS9lb233OKyQ8gyPIqE0TUqZr32GYHE0Lpu
         +KdYnK/qiiux6sQ0KRDIajwC2L1TpguIACXyYPUQfedskLeS2wpm7b5+/0HxmtICo5e5
         2CSg==
X-Gm-Message-State: AFqh2kppcov9v5SJu0XKEVA0ZqZrxfWVjK2E6l4MVP7Lj2iWPm8Den4k
	wsHp7ZR4zJjzJCaedx4GTS8=
X-Google-Smtp-Source: AMrXdXvBacoD8XHw7bIj3fRtq94ID9PrZm6RO3ZxWkoHc0UM+D1Lv3h0fEeeOeks7HpvCHDMnbHePQ==
X-Received: by 2002:a17:903:557:b0:194:55df:4fe with SMTP id jo23-20020a170903055700b0019455df04femr5883472plb.35.1674014174002;
        Tue, 17 Jan 2023 19:56:14 -0800 (PST)
Received: from debian.me (subs02-180-214-232-66.three.co.id. [180.214.232.66])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm17288666plw.296.2023.01.17.19.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 19:56:13 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 1B48C1016F2; Wed, 18 Jan 2023 10:56:09 +0700 (WIB)
Date: Wed, 18 Jan 2023 10:56:09 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
Message-ID: <Y8dt2efGEPS/JRaP@debian.me>
References: <20230117124546.116438951@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VVLD0i51IZ9bwB+F"
Content-Disposition: inline
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>


--VVLD0i51IZ9bwB+F
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 17, 2023 at 01:48:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--VVLD0i51IZ9bwB+F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8dt1QAKCRD2uYlJVVFO
o/pYAQCe/RTsz0cS/7QTCzrQqZGbAyAyUSM9I6LaRF19nnvA7AEAmN4tnT/8CkEW
EONq41/MFhUNCcOI3diqIIPDvzHkwwQ=
=7Yo2
-----END PGP SIGNATURE-----

--VVLD0i51IZ9bwB+F--
