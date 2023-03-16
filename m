Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2113220EE
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 07:32:51 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso4464048pjb.0
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 00:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678951970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mcPnUDp2uPpFN6qrWcVm3iA+36dQ0Mwojauq/GYuGW4=;
        b=ZaZ3pYmrfSmhTMW5BBDjL1MqZX7hSqr6gXshR3sAa4llWu6OeqbDC/ByJgP93L7nS1
         uw9j2oJjD6Z4J/DtUEUZEuZ3w2Z8RvAU8qFlhP6ACpNNa/YuSs5B/TMXKhuMY4lnl3HL
         wo+q6GQLL24y6XPzI/qNTHGz17K3C+MSKhmGpRntuSpAygK53xocuOkiqgiP/G/gFg2W
         ObWbAKfWFlgkv9MBHruJ/6z7hWZ4iGbk7rldpk0HgXPiKIkBr0ySD/9IUJtBjwu0+/f9
         vbDbz17GvYhUScSyjyR6kgJp4qfiaw5PIQ6lBldCprmlb7F0q5ofdJbDkMnnuZChYjhx
         O/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678951970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcPnUDp2uPpFN6qrWcVm3iA+36dQ0Mwojauq/GYuGW4=;
        b=0lMzRF82y6T9CYXKwGY9XmfB9gx/bUfkGfSIxp+jtlit35ug5n0Lh2/v0E+tE+EraU
         CyH9KJCYDi3zMC/kHVIq1IEesvL3ciEtuhmk/U91LQ70e2/anlJhpAV6s0e0HEuSZGMm
         w15jyl9fGAcXpDO9mQNKE/az1UlktkVhA4LF5XDcxFfgakVRG3gJPeuRe6wbl605i/UB
         trW9ZnwER8DF6I6MA1kP43tTm9BnwH4IyHw0wzmJUaDK6Pvuw34/2I/CdGYwhNjsZIoi
         74kaB8K/koOCyI/VO3meFW5+CwPVezlm/Wz90vTiSPLT7EnZW/Zf1QzjX9Q3Mky5Eef6
         wy6Q==
X-Gm-Message-State: AO0yUKV2JJA/webfdaBG5Fca+Ler/uiy0/OmYuAAidC+l7a/QQ+uk816
	WYeiZtR27OSxqsE/zqnBD+A=
X-Google-Smtp-Source: AK7set865NCA1infzuQT4Lgx3KiWiQEfKzG0o8erq89WRRWzoiYAbpJp60OseRunjgh6Xp05mWY4jg==
X-Received: by 2002:a05:6a20:144a:b0:d0:15c9:4e68 with SMTP id a10-20020a056a20144a00b000d015c94e68mr3272692pzi.62.1678951970418;
        Thu, 16 Mar 2023 00:32:50 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id x48-20020a056a000bf000b005a8a4665d3bsm4737711pfu.116.2023.03.16.00.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 00:32:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 70D4B106628; Thu, 16 Mar 2023 14:32:45 +0700 (WIB)
Date: Thu, 16 Mar 2023 14:32:45 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Message-ID: <ZBLGHXo4qyKSbwRh@debian.me>
References: <20230315115739.932786806@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4u63Dz9MIHxlaJJw"
Content-Disposition: inline
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>


--4u63Dz9MIHxlaJJw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 01:11:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--4u63Dz9MIHxlaJJw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBLGGQAKCRD2uYlJVVFO
o8IAAPwKodi86HHP/TskrBp/C81NuVFDWI/xo8jE01KzRIsHwQD/TQx7O0h028VJ
oLgvOjKwksu4N03a8yN8IRLMDWZjWQg=
=fgnM
-----END PGP SIGNATURE-----

--4u63Dz9MIHxlaJJw--
