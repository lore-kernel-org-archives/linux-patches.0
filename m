Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DE715A4
	for <patches@lists.linux.dev>; Sat, 31 Dec 2022 08:31:54 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id n12so11655449pjp.1
        for <patches@lists.linux.dev>; Sat, 31 Dec 2022 00:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qyj2rgBFpnRPFUlJLTEsD7ZQxIggwzsrs3Z/jAozoGs=;
        b=YQP0nrh5V+KeSIJ68OIdNF/0SiC4Jmh4QZmhuUwcXtSfQzl0dXBn142QhkQ9r7tdeQ
         yyFY87dvKVIBDnSXHSyLHug55mxB0yDMiRwS+Ol5q5yoU4st2DuN0O7U9GD8gGfF/p5H
         /78N+v6KGSmdeTDnOYY1plBpToQw+EWYPQwBke43LRzUnrrLoApVH30MPkCbKdXTb4Y5
         sYl3gpcpZp/0smVEeAx99G9RYPTV0vrD3vQYMzleyAOKZDFvHjtYO++Ay03EafCtCBwQ
         qjR+qRa8BXI2SFGYO+RAsipP+zqR0/3dHrlxZ79R6km38zjW98NadPzYGUd7RfAViYgP
         qBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qyj2rgBFpnRPFUlJLTEsD7ZQxIggwzsrs3Z/jAozoGs=;
        b=0PNRN49g7pVumZudXCVhJTdno2t5JfFl0YeU4uKGIlpTD8Bw0zHmcDWGMAxaCAggFC
         uWri9qf6sxSYInSqp5pbmIXoTwIbgNxsp1VvrYS7uW9eChfSbfwAvrh/6PVlpjPy3njg
         ETnjz1MuKPkShSp72rCpg2wpibb9qgiHpVIAL5NvMBERL5szHSHzX5IaeeJAz0fYRbeq
         J6fuMILTx0u5NWoni5Rti62mqgRkG+hqlbf4iOiQ7xW38g/lomp3er5EJERs1v0fk7jq
         XxtKizjKRbhRuTfwNPL41QgUsI9u6jgcFxlTXAPRO4AdinYdd94Bn4R5zqhy6f2DL6Tm
         KKOA==
X-Gm-Message-State: AFqh2kpmGQ+95sIEGGik/wkEN2GN9TUtVSm3GqIy/DYoQ03/F+NA2e2F
	rpG6sOin3XhIXGbyQVaCx44=
X-Google-Smtp-Source: AMrXdXtOHN4azErC+YEw2kfd3lU2BAPDkYn89mJl4iSoprjWXvTA3BwXBhJEJTVclwPiKT5amDnAdQ==
X-Received: by 2002:a17:902:d3cc:b0:192:9141:ace5 with SMTP id w12-20020a170902d3cc00b001929141ace5mr14868542plb.13.1672475514218;
        Sat, 31 Dec 2022 00:31:54 -0800 (PST)
Received: from debian.me (subs28-116-206-12-54.three.co.id. [116.206.12.54])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902784b00b0017d97d13b18sm16272758pln.65.2022.12.31.00.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Dec 2022 00:31:53 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 6C6151017FB; Sat, 31 Dec 2022 15:31:48 +0700 (WIB)
Date: Sat, 31 Dec 2022 15:31:48 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
Message-ID: <Y6/zdJ722IxFptkB@debian.me>
References: <20221230094107.317705320@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="djV721w+vT9VwHqn"
Content-Disposition: inline
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>


--djV721w+vT9VwHqn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 30, 2022 at 10:49:32AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--djV721w+vT9VwHqn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6/zbAAKCRD2uYlJVVFO
o5WaAP4lJgxhIHBXpTKQTc8hbvRoFqWRaniEzbD1cUKdMkwOGAD9FpY4v6iKmJgg
xjrsMCGEigSsg5YF0tDEkBLyEfjhkwQ=
=cKJS
-----END PGP SIGNATURE-----

--djV721w+vT9VwHqn--
