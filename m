Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1717E
	for <patches@lists.linux.dev>; Sat, 26 Nov 2022 04:04:51 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id b29so5637669pfp.13
        for <patches@lists.linux.dev>; Fri, 25 Nov 2022 20:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=95OizHEzM2jvpWCl45WD9PQzeRhdcr/x5Yld8IlNbDc=;
        b=b01ulhBpJKqNaGt6lYxcNqq42VKIN+GAulpM64tj+oJp4fZZDRcUIclJRMaER/TLJo
         G28+zivhc2C/Wu8dMhiHgI5hn+98vYyvqwwWSwuGs0YCVvnURI5luz298T7DfsE1Ow6/
         xtGutVxWfUvHT+/9FuclMZ7wzUURDA8IiUNYoUOjrA0hHwCmwSGIsuPS1XpGO9hMbbHU
         FuQw8s6fbTZZmaSG8/82oKzekWbsWRv/X28zfI3CnK7//oxwRjDFcpkeioBuH6lejgE7
         dRVdbT2W7lAHW1xt7BA4vtF95LYPMyeD/iHLlqE6Y2TPrIt5TxALuy6ANCwarBewx4gW
         N+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95OizHEzM2jvpWCl45WD9PQzeRhdcr/x5Yld8IlNbDc=;
        b=ZNkou/lcEWCX1GbjOygItcs/WzxiRj9I1etIy6X+gxkcAvedIEIYEMIZTUzIw+3sWh
         xqoQJMwO2zxMMOVA5PQ14SiHHhCLZe1Cv+htDP0jzoa7B40FKzMB3xCJlqjnZzyeoTeC
         3rCIrG7mBrP0PnhAxaLsyP9OOO1878/7n4UGIuA9sZk2TiUZgqPp45QOR5XwPz4n1xsj
         sRHpaKvm0deVPcCYIy4lg8/WQs5ikUEAO+UPKVoj31+YkUiXi4CmB/Y+zLd4YIPEuMke
         /35xxPO7lVu3o4LXNgmSf5r/PKTxSXycdcUKbrbPhcZsldEfLYOxB0AWQiBixDL9lNEX
         uU9A==
X-Gm-Message-State: ANoB5pmfls09sjRIU6dTZuQDS5mDLXQhqxqaoccILce771gj/vy35fIk
	U9cPvaULxdVp9OqbX3IsM9o=
X-Google-Smtp-Source: AA0mqf4h5cDCMT0ybHUhsTP6F4XGrrFUUo7V7iE4n7eZmvE1++RI26c/5Bq83SsGT95uRpxMeCvGjA==
X-Received: by 2002:a63:1e5b:0:b0:477:3c62:49ba with SMTP id p27-20020a631e5b000000b004773c6249bamr18528520pgm.446.1669435491087;
        Fri, 25 Nov 2022 20:04:51 -0800 (PST)
Received: from debian.me (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090ad71000b0020bfd6586c6sm3693326pju.7.2022.11.25.20.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 20:04:50 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id BCCE1104330; Sat, 26 Nov 2022 11:04:46 +0700 (WIB)
Date: Sat, 26 Nov 2022 11:04:46 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/180] 5.15.80-rc2 review
Message-ID: <Y4GQXrB4RGY7IHbE@debian.me>
References: <20221125075750.019489581@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HVPc8jQf3GLmHf8m"
Content-Disposition: inline
In-Reply-To: <20221125075750.019489581@linuxfoundation.org>


--HVPc8jQf3GLmHf8m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2022 at 08:58:52AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--HVPc8jQf3GLmHf8m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY4GQVQAKCRD2uYlJVVFO
o/tiAQDOF8n1CaBFVPf7Rk1vADecFV3tdxh5BxzH6hFW++N3RAD9FoRDBtDki1hG
f3csZW56CzZpnRz5jHdi2a9OcUMt4w4=
=6tJR
-----END PGP SIGNATURE-----

--HVPc8jQf3GLmHf8m--
