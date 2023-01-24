Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB649A31
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 03:00:40 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id 7so10465088pga.1
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 19:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ps8P+XN+oxQi8oHNpfWLccmysd9PKrw80go/ffUgGeA=;
        b=H6jLd68ft6RqwkVwL02BVT1WOF7rU+suIdYL5oYRc1KfctSQ/mitQ4Z6+0GIprcfcD
         l3GoDx6RX//yWvInQWx3VSLROYE04uGFBEWo0GnEUJVYDIntuCVCDniQmzqkV9JFGpiV
         tGGbb/dWI8OZEHdsJ8vbdAsIjFjUkKS0G/xlTU8vjQvIROv+FzJtHQEIcv939oUOphyW
         U1zLZXxOvliDzP/GvY7zZCJFvvgaKMOdbYe8LQEcPgqs4Vhy64bwcFI39T44H7JPQXzK
         ahfTB8OmmnJFqqgvIby848MPAc7GBqic7aGY0852R4EPR+xrum86aKrQ4/F00FneEmF9
         BDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ps8P+XN+oxQi8oHNpfWLccmysd9PKrw80go/ffUgGeA=;
        b=7A/rtyJCQkGnxYCZZfX1F1yvQv2Goyr3yDylnWYdHPozPl1WL7+9L4NtMiW35cQyS9
         GLCs4CWYCEEVOwIuQB4c+iyixqD10PJJe4s2NM6pN0l9WV/aLoL+i5BDMWFzwwpUkA8r
         yVupxYJaaN/Ll6HOAIWFebifKl2Ynx3wt3OuOcUgfK3sWjF4A0rVFsEjWpCdOy2Rp9NX
         g0KA1YMrdia/+lvl5CSHNlBqmnHA0maM6CmeS4A8es1XvK++nkVWaJrZmzJk+zkDC82K
         YQWsKmZSxAcWr7rGf0rl08USAfOhaje+nVfc7CO/U7O829WbLX9VNtasV5N63sRJgaP2
         +j3w==
X-Gm-Message-State: AFqh2krUeRrEIrHHy94DMKcaqfvTut6aDXbLSM2ZQbd6Q4whNSP/vfef
	pixOyOGeyeLUrJ3UyjSUnkGWBptkItNZGw==
X-Google-Smtp-Source: AMrXdXvjW7goOcrvw5zdkHTxXC2mq9cCUz2U47tuIhFiTb7N0lfMp9jpvx4UoBuX6lXDpW1FGhUJHQ==
X-Received: by 2002:a05:6a00:bef:b0:58b:ca6e:af26 with SMTP id x47-20020a056a000bef00b0058bca6eaf26mr25774324pfu.23.1674529240103;
        Mon, 23 Jan 2023 19:00:40 -0800 (PST)
Received: from debian.me (subs02-180-214-232-19.three.co.id. [180.214.232.19])
        by smtp.gmail.com with ESMTPSA id 127-20020a621785000000b0058e12371d96sm308527pfx.164.2023.01.23.19.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 19:00:39 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 4ECEC105170; Tue, 24 Jan 2023 10:00:37 +0700 (WIB)
Date: Tue, 24 Jan 2023 10:00:37 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
Message-ID: <Y89J1Tt6AtEgHSib@debian.me>
References: <20230123094931.568794202@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rRnKlST7qnwbnDsG"
Content-Disposition: inline
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>


--rRnKlST7qnwbnDsG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 23, 2023 at 10:52:24AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--rRnKlST7qnwbnDsG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY89J1QAKCRD2uYlJVVFO
o97UAP9lxcmdiC8bMBcM7Ywem6zppD6fgnLyYoZH7gLaubymEQD/e4i35EBbO3p3
A18+P9AKheIvcWKpF6YImMjqKH95kQI=
=iLIx
-----END PGP SIGNATURE-----

--rRnKlST7qnwbnDsG--
