Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65B12597
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 09:21:41 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id c2so12596745plz.11
        for <patches@lists.linux.dev>; Tue, 15 Nov 2022 01:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UvxQFY1j66EF2lwTmE8W9AjKJ4egmazJXV/Ig6P65R8=;
        b=gyivwoA3r0QAw1YgZbz/FtKiVshzUPUCdLjtKS0tf5PRJlLF1CZxRjEktGPQ9AI8tV
         UWkbsMF57nUAh/s+EqvoURlOLIpBFZgOTVW1DggPvS8PhWgpRSrwBwfTuUyP6HuDmQVD
         Ixm+grmKn4hUo+V1eOZnHwZFNN9wdQuC+kz9jH5AKpVeAgtzR++Ok10GqBMOo7FJLYBh
         DKlTG/v2/MHb3MQhm4tJk9/gc+Lxz8NIVHem16kX46lq3vvTSli2554Dx3somThxqBGv
         hD7RS6kZV4oXKgBoR+ACsFOerNN1MCBey2wk0bbCEaB6WFZrpkJXOq7m5gxpYJiUrP/Y
         F/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UvxQFY1j66EF2lwTmE8W9AjKJ4egmazJXV/Ig6P65R8=;
        b=KROjORFQtl6dELekDUZ0qQ2DAAArxrnHrPF/ra2oTMGQaoLEHDEdkpNvSDrlgEWhDy
         lYuLb5uEbkEbyDvNbwvME+UBnTtY8jO5Bd49H7LvaH8agGA/VteQlJiws3wiehXmLC4i
         JICAJMB3bsbDFqJ/TBmA0t6eGF6E/oNHSfUHBbdpCPoeMSDf0fksJ0La2AmHqO70kGo0
         3PxdlawbQ+D22+FNk8QEqcZmaGzNIDU+vUqaRJJF6p3FbkBNFlp1gFbDR9rka1xU7+Ub
         qu8ev7j8pOAn2pt7i6cO4cFp9E7nILrhp2AxNNtETvOy2qwP/U53ALZ2Psb7gMtO1C6g
         Deug==
X-Gm-Message-State: ANoB5plGw/FXwbZsAMliFm3eIDdl/Nxjgkh6S3QO1x3yQMMMByP2l90a
	wHnIgSuLbYeH7ngkxZrgDH0=
X-Google-Smtp-Source: AA0mqf4KfHcPQJ64kBVHTp8/4HGiTdY3E/fDOuBUnpjFtOjbiIQo+ANRlr8yPX6xPqPymKdfRSCkUw==
X-Received: by 2002:a17:902:b694:b0:17f:7d9a:4952 with SMTP id c20-20020a170902b69400b0017f7d9a4952mr3143749pls.117.1668504101145;
        Tue, 15 Nov 2022 01:21:41 -0800 (PST)
Received: from debian.me (subs03-180-214-233-20.three.co.id. [180.214.233.20])
        by smtp.gmail.com with ESMTPSA id x1-20020a170902a38100b0016c9e5f291bsm9276497pla.111.2022.11.15.01.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 01:21:40 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 84F3210434C; Tue, 15 Nov 2022 16:21:36 +0700 (WIB)
Date: Tue, 15 Nov 2022 16:21:36 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Message-ID: <Y3NaIGz8UM12Oxap@debian.me>
References: <20221114124458.806324402@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vJ94NYY22K9rIk9s"
Content-Disposition: inline
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>


--vJ94NYY22K9rIk9s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2022 at 01:43:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--vJ94NYY22K9rIk9s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY3NaFwAKCRD2uYlJVVFO
ozSHAPwKO1XU3tZq+1v47dJdMqRcmyClqE1LqvZxE4Lbf3syowEAsWPdHBuMhoR0
KzDhon3V/3v3q6cRGG1hDBTBU2LQ3wQ=
=2NQU
-----END PGP SIGNATURE-----

--vJ94NYY22K9rIk9s--
