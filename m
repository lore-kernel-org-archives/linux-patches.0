Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F6E7E
	for <patches@lists.linux.dev>; Mon, 29 May 2023 05:21:49 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-25632c99eecso1488596a91.2
        for <patches@lists.linux.dev>; Sun, 28 May 2023 22:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685337708; x=1687929708;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dIixmMRMeLR5uv2JYJ32T7Fj3P30g34lZWwcFZSao3Q=;
        b=eE0k29i9Mz+keMgA2mkrajdls6KBK2ON2DPcxaES5/Eo3Ie7tQvoCuE8gE+Bm99N4R
         /3nQJ4D13XgASfYm1TNU6JMpcazrcZ8ybxY6CVYi7Am11UwXTruThoMfcwk05t3uAmsw
         6OiaLDDfyFdJ16Q9lP3jtZ1XpNY3gOihe62lHXwB6xeRY2ELV0OnJODfuD42WHf5xWlN
         Wi88F+SvUr5peKR6b+2bZ/7je5eyyJDqTclj6nSIi8y1bTi1/Nx6YrC016znYO2JNfy4
         xB08zhoyJvdjY7HobmBxFeVARFB4IMyUvR+bYV39WSy1LUjHN7D6EdoktXQa8flXdMGd
         RgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685337708; x=1687929708;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIixmMRMeLR5uv2JYJ32T7Fj3P30g34lZWwcFZSao3Q=;
        b=jMowZMGsvJzORyYYXYqhI6yQ/NZ179ueateNfgqtknY8FoCw0bZLqc0X5Ne4mdM9lb
         OGwJ2BbrE+f00VGdvcpj0qAlCSJEekrDzFKTRoK22Pw28Lx83NmRA7LmpIrN4RernVPv
         y3oez5UVOTuXM6PC5COVGq+gRoTyFd7pQnqsWAIXCI3VVhBrOXfNXtj6EQFblvjgZc+l
         6n4Uk6GmYts0E6ObEKwTmjbyGDmyQEC0AbPq+/IOCvyA9dld/yGfH4baqh8V8RhYstDF
         rjPv/Ig23KxZEVrV06LPEkD3Fju8TGAI4j3ikDitDTrUeZg3/BI7zkm6E4Yt6UsF8Y5v
         j/QQ==
X-Gm-Message-State: AC+VfDxhcMC96ylT04jXV27IeszZDonLX3ViJamflzIOhCKo1hb/sdKg
	O0NNty50wVHv54ktCYaTg+g=
X-Google-Smtp-Source: ACHHUZ6JaDmnovu7hZM8VS6Ax3ZoEEdPpI27XZaautQ+yu8cC4AOkvCDGlBcilh0TvwWs1BpmrWtgA==
X-Received: by 2002:a17:90a:f417:b0:256:2fd4:e239 with SMTP id ch23-20020a17090af41700b002562fd4e239mr10010574pjb.23.1685337708395;
        Sun, 28 May 2023 22:21:48 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-18.three.co.id. [180.214.232.18])
        by smtp.gmail.com with ESMTPSA id h20-20020a17090acf1400b0024749e7321bsm393515pju.6.2023.05.28.22.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 22:21:48 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 75F3A106A11; Mon, 29 May 2023 12:21:44 +0700 (WIB)
Date: Mon, 29 May 2023 12:21:44 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/127] 6.3.5-rc1 review
Message-ID: <ZHQ2aB42tbGLzuvZ@debian.me>
References: <20230528190836.161231414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IMWNbdN/JiIDBaaE"
Content-Disposition: inline
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>


--IMWNbdN/JiIDBaaE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 28, 2023 at 08:09:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.5 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--IMWNbdN/JiIDBaaE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHQ2XwAKCRD2uYlJVVFO
o8YPAQCbHhP6FTgHoILB6AXr0CwCxpUZmnecPwP+dc4owMEKdwEAzht702j9lDJz
9Y8OcnVxWFgikjEn7DzT62e8flHQ+AU=
=nKGs
-----END PGP SIGNATURE-----

--IMWNbdN/JiIDBaaE--
