Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F00680F
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 07:20:51 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id v23so38975517pju.3
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 23:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7uciCeGRvBIYUUaGmyJ6ozxbZXS75DYR36RY29vGfjg=;
        b=iujW6ddxHafvumcE80G/XnOj8nO3vndEy4A4/DjXJt6Rr/O2McbgvptVI9TCk581Ps
         O1FBoNaDD2j4O0yDjULGVX8LPl7cwWir4/zsdTNlPhLhLbuNtIuqoLrWTk2x5fYPY1RS
         qbzzGIL0OU67jMbcQGrtuPmVWWHoguRlNSbniDEKUL2HUkUraeZwxfh7p3MhsWdLEeh0
         vp2DR0DqFVQLdPUS4n4ErbI3MgwYpTUyisRl1SJE7OFEWbjvupnRFTREaNAoc7mabmR5
         Q6I75aDH7szl5tplBtm51pULNqQIMF4Ik4g16g6COxNOWWUyxFHj561GnF4kxt6LKAcG
         +hAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uciCeGRvBIYUUaGmyJ6ozxbZXS75DYR36RY29vGfjg=;
        b=NCTi7kpSx3dSJN2wEf7QZQsrBkJNdVQ8goy77+QxDQ/aRfiCEWGo9j4pHWn02AYli4
         8v0DqmQ52rRZKM0Bi4kMmX6KwemKX3cEvsDrcGwlZASpZ81W6IBkYjZg8+uT5kwL4IGa
         bf+SqQ9aPci5qQiRX//hPI9NgPzxzcfu0C7bPg3E8JOMchz4YJHSaRh0kXjCeqNhTL53
         4WeEpvCTdUIUBd/XID3a2PCFKn/Uvx0YkR/Uw3+YKpN7ttAK6OaZkeJyvQLv2fUJ9hGt
         O/VDxCvZKsiborjDFiG8TjWxpeXVnRAoaJaHFYrhkUt3AveMwigLuutaK+w+SBqDIMKa
         0o2g==
X-Gm-Message-State: AFqh2koBm/cj888GsDA/puR5umKj2DY9TIPxoHO662mMMIhE1dDqmQ8+
	RrR1hZlrFCz1go6TqPg/I8U=
X-Google-Smtp-Source: AMrXdXuznreNVNCf5FUnRCD5knZscaMY7dzaTt7omnF/gnOIjyq2m0CXzaUJEKtin5kjYqOQ1X9x0g==
X-Received: by 2002:a17:90a:c795:b0:225:bd44:cf0e with SMTP id gn21-20020a17090ac79500b00225bd44cf0emr48734053pjb.32.1672903250685;
        Wed, 04 Jan 2023 23:20:50 -0800 (PST)
Received: from debian.me (subs03-180-214-233-80.three.co.id. [180.214.233.80])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090a6c8200b00212e5fe09d7sm677294pjj.10.2023.01.04.23.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 23:20:50 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id EC296104732; Thu,  5 Jan 2023 14:20:47 +0700 (WIB)
Date: Thu, 5 Jan 2023 14:20:47 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Message-ID: <Y7Z6TwyOaJOMDXMT@debian.me>
References: <20230104160507.635888536@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8P+3z6rJGwSdx8v5"
Content-Disposition: inline
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>


--8P+3z6rJGwSdx8v5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 04, 2023 at 05:04:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--8P+3z6rJGwSdx8v5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7Z6TwAKCRD2uYlJVVFO
o8r9AQCrikKFnFK5sHuO0mFHk5PF6q8ztv2rzepmL1E7fgtrSAD/dnmlbqu31IzQ
d2md9l51jQLLInYTx596smxqgIip6As=
=GNDy
-----END PGP SIGNATURE-----

--8P+3z6rJGwSdx8v5--
