Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4696DA31
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 02:58:11 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id k18so13427904pll.5
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 18:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B4YXx3GIWFGT1/D+Depzji9t9vqaSeQNHwZmz3y3RyY=;
        b=dVZDpG7d/DXo38EW3uvmydy8fqHaieawOFMU8s1gOvkLTbQHdyTkEXBPcGeCrig6R1
         G7SKQ3ljxUDN7goiCLSKpoqf2pH1xSYui1Xl2RXq/adSJItEfYOVviWO3D6ZhOboAJ97
         JQGyNF7gQ/8MHo+FlOnoXaWGJgXGJGAaJTMpfEUfP1A8VYRQ3BaKlvNvp7nEOWaxCLrq
         SREv4dLWvZkMIBFnmJJmlUYNDbtaurRiQn3lYe0KnFRi8j3d8Lahh9G7agZMeuidufMx
         w5N5QSSPjSNs/X/RKrRm9AkniDxiuZl+N5KDyBFhjkXuTRRmwE4jXc+a1/1SHMXJ8sXc
         QUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B4YXx3GIWFGT1/D+Depzji9t9vqaSeQNHwZmz3y3RyY=;
        b=a7uTS+bvjdQn8L6A21EZYTOHHQEYyts6iU5cmZkj0tu0fgSypa6DSbi+xYjHYWbzw5
         capNzNXqKuw5280+yupcneKifvtUIrc1jbKjRRD1y0fp2hzwIkl9F2nstB0ot8fMm61m
         v/hB35SkELCvGltD5N/3HSRL4ERJV+FU2Tv8Jx1OM48xGjCMCVt7gvgVDa66ii/MctnJ
         wGZH9S3vTtnKHENhXUrq6ObdTkXH9qKA0RcOIOOq0/aRWFXA5UKjxbo2kJtpp7WZexu9
         NSfmBRqEQr5h3ng6HQQ+juqaHvKEPypSrEYFrWZvf+6TKb4DbDwhJMX9jse4PnYaRq5R
         hHug==
X-Gm-Message-State: AFqh2krDXmrCO5DIqh2WlV8ifrP9cWHrK61xAMykgBMXxm+KxOJ4HElU
	XDADriCI+WA6Qv8R83rtrx0=
X-Google-Smtp-Source: AMrXdXuksllhpgpMo5HDdSP8BAWq7WYDScRIpYKpgyHE5LMkhaqmZqbEqq7pc5jbIzd3h1dN0/N45g==
X-Received: by 2002:a17:902:9b97:b0:193:12fd:a2e3 with SMTP id y23-20020a1709029b9700b0019312fda2e3mr24817049plp.55.1674529090698;
        Mon, 23 Jan 2023 18:58:10 -0800 (PST)
Received: from debian.me (subs02-180-214-232-19.three.co.id. [180.214.232.19])
        by smtp.gmail.com with ESMTPSA id jl16-20020a170903135000b001869ba04c83sm402338plb.245.2023.01.23.18.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:58:10 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 9FA73105170; Tue, 24 Jan 2023 09:58:06 +0700 (WIB)
Date: Tue, 24 Jan 2023 09:58:05 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
Message-ID: <Y89JPe7Q3zJsKKV+@debian.me>
References: <20230123094918.977276664@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iDVC1M9WRDgULcUY"
Content-Disposition: inline
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>


--iDVC1M9WRDgULcUY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 23, 2023 at 10:52:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--iDVC1M9WRDgULcUY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY89JPQAKCRD2uYlJVVFO
oz9gAP95uAgUemwNkB4dCOOxG7potsDPZDjkyMfB8rTyfp48HgEAvMame/xm8Fqo
m9NW0jT0BHqFmmFqFUT2iepTT/Pp/Qs=
=ni80
-----END PGP SIGNATURE-----

--iDVC1M9WRDgULcUY--
