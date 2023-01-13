Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEC07EC
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 08:58:29 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id w3so22832285ply.3
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 00:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOXPJ4ctD/k2tBI58EgwSpUTlf5yt8enn1GdO0RLBD0=;
        b=WepC8TjvkfEvn2+hH+Z9pCWF0UhvJkafe0KSBJ71K2YEizMOPCV7SXZfh/ziw07ThH
         CHRY+4mmFo8uk66L+y7eGGfpTxHamxpsQHfl2SalOt5DWCu8KJE5IrUtSYDyup8GH6SJ
         aHC61XuOoagU+UkBu/mAhD0UeLZqVDeM9ZsmuHebZ5YKsbLBYwlP8qA4Vmf5q63Bi84d
         YCzyyplOSRx+4Mn0JKEiSOwSIeoHD4ZJO8Ynrc0hMjvFC5MAauSB6L1a3U9KwAcQJQrY
         WxV+2gMqFbIcwee5y24U2BJ5XxrpWQQjXuDRT4GfoqtVN1X7jigcUEVivS79VS81Rj3j
         PKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOXPJ4ctD/k2tBI58EgwSpUTlf5yt8enn1GdO0RLBD0=;
        b=q5STTfBm85MPLGfMqdkCl1oTa1GMWN3IOTG+NWcQs3gsKdO088VXrNYFcxNucbMLir
         bzmmFikIjapDjj8SFu1/C3hV3B8enqBPK5SPOl/XcX/j1SPqjYeuDUN/4DjGquoXY1hN
         LPKOdHf9ozLdUOPPUnm4aT/a0C7DtEH3Kit3eUSYH+WiPUhQLT6kpwPzUb0R4wjqMf2l
         LwudZym5M3INajjjVLKUKSduW7DvrrwmflUJTQrGEZmcBQYraIARuEokU8fNSA2cFMfN
         yLridKjPm5Qh52VEZOxYnZIjm1LJwdj1BTQ8uwqp8OqyKNJqhrNC0FxaSElsYr8GLJPE
         Ig1w==
X-Gm-Message-State: AFqh2kr8nH1JYYnnkMPKp+Ddkbe8M+YeTmjFha4eq/NrLNpQQgzbwxlC
	Q2RcE6MbYRlzo5JAl17seGk=
X-Google-Smtp-Source: AMrXdXuQw68i6p+qo+YvoqAdx2+WtXc7vRnMg9DA0n+kdseNoAgF7zhqsYbHAx61beHGy0jivV0+dQ==
X-Received: by 2002:a17:903:2781:b0:194:62d9:9a86 with SMTP id jw1-20020a170903278100b0019462d99a86mr4518331plb.59.1673600309306;
        Fri, 13 Jan 2023 00:58:29 -0800 (PST)
Received: from debian.me (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id l17-20020a170903245100b001890cbd1ff1sm13660500pls.149.2023.01.13.00.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 00:58:28 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 52ADC104D0B; Fri, 13 Jan 2023 15:58:25 +0700 (WIB)
Date: Fri, 13 Jan 2023 15:58:24 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Message-ID: <Y8EdMJ2eLJUS89MS@debian.me>
References: <20230112135326.981869724@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zQWMkMI+vsN3CxJf"
Content-Disposition: inline
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>


--zQWMkMI+vsN3CxJf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 02:56:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--zQWMkMI+vsN3CxJf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8EdKwAKCRD2uYlJVVFO
o8TtAP9eso2fiajGisTlUTcDipiG1cn3y8pnv8zXeHj+GFa6+wD/V9SD7pAdnmgs
WuXlu5MexNtRwUPOvPmfy64uD14rQA4=
=O5XG
-----END PGP SIGNATURE-----

--zQWMkMI+vsN3CxJf--
