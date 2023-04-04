Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B957C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 02:41:20 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id u10so29969503plz.7
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 19:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680576080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v1FsOYpJR8KsBcGVyYzp35XtFBS8mpozVZSwh3hhDpI=;
        b=f6P4jqCgm4Jo+h3qCzymQ2y+Eo74HO7F9erlJGQcGkkuVbklUXvMd5IiyUCBEWOSbp
         zvP3dBl+xp+zoQiq0OAEg95+c/G3rt5h+OgyjpkozxbPNcXFkcOMKA4j2pklJ9l7XEBF
         E0TNbu6jmmJAL53K5YtDfrD/T7b5/bQTWZ64pw/OiI/EVCNShOLrrUDHATy1e0XIs0tq
         iCAvW0MT+a1HGiyQpVsLchaaBE3lvChZ0cqeLNDj9MedGjAyg/eIs4Qzofh/t+QQ1Usf
         SZbWYeVVbRv/rnScPdZ/VsdZSsnKPmwsiez+14n6gDUouaP67jEzzwGhK0X72/9WjckN
         jc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680576080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1FsOYpJR8KsBcGVyYzp35XtFBS8mpozVZSwh3hhDpI=;
        b=mqpf/WaebgE7SWUKSj+WgLgK6XwhtrecVWKS6m0DYPM7e1VijeuOtww5ia48nrYaqP
         DB6W05e6MSfdZiIv1G57ykpmQ3//1ZrKJoS1kouQGfdUoMiuMoUquV90kTbfzAruvxVf
         bjKWDDE8uRG9atmHU2lPMf7VVVRVY4cF64rkoBdRlg2D6HLKBJd6VOgrOeD63DTJRWG4
         NDEP+geT8IOa0ZR8/2JRdwza3a3/kjtCuJiCEbtEIUbofzSs+DkU3FAPYkHldJ4uqLXP
         4r7Gpyrcot0Jw6X4osHP7Jhp4VkQawB97t5LZQjoEAeUvTqJ6dM/7/7hFZlrTrdIlplx
         csiw==
X-Gm-Message-State: AAQBX9e1itsi6cOQJc1rOMwfrjgUe82LZqKrGdD1nziMqeMW1asNN6dD
	X1PBw7nCzWeXXzCJd6vY/dI=
X-Google-Smtp-Source: AKy350ZL+LoEZJ+XVZRbVNoluCojl4f1E5Daj+5eZfjTtV/+2WtzbOBhlVbgOuNeN5SZDBaUeWL2BQ==
X-Received: by 2002:a17:903:2287:b0:1a1:ee8c:eef5 with SMTP id b7-20020a170903228700b001a1ee8ceef5mr1524461plh.7.1680576079912;
        Mon, 03 Apr 2023 19:41:19 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-40.three.co.id. [116.206.12.40])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902ed0b00b001a22d274045sm7290463pld.144.2023.04.03.19.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 19:41:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 5ABF7106790; Tue,  4 Apr 2023 09:41:17 +0700 (WIB)
Date: Tue, 4 Apr 2023 09:41:17 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/99] 5.15.106-rc1 review
Message-ID: <ZCuOTZQuc9XpjD4l@debian.me>
References: <20230403140356.079638751@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TEoeCkE3HNd3pzxJ"
Content-Disposition: inline
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>


--TEoeCkE3HNd3pzxJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 04:08:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.106 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--TEoeCkE3HNd3pzxJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCuOTAAKCRD2uYlJVVFO
o5MVAP9EzGAEKT/G+NcZej/gIIOJ5+Z9bo6cpYS41N0jbz8CyQEA+b2xbBS7C7rX
/9PUFHIFrh7udDBOFSRvRAySGPB5Pgo=
=PnQW
-----END PGP SIGNATURE-----

--TEoeCkE3HNd3pzxJ--
