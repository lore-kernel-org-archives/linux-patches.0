Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37897B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 04:47:41 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-63d4595d60fso32834319b3a.0
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 21:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682398061; x=1684990061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7mjglO56uGEvHM/CvZvHdpiKNwZ+e2uyMhpZBFkVkE=;
        b=MpjvQVeZ615veQ0dfUI3iJ5IOrl6uKSOlWytx+XxtudP1sK6WMjBXatV8TIGG3I/fm
         yThgFvFnZhY6ZLunhNy3wluje5OfvaOpU+juESYW/Gxy+Knglu3halQWwh3+Q8xWU7K3
         8AfdpgNdKiPYUfRzMXilRf0OEIWFCUqknuNLVhmILeKbJc+nvWY8K3aV9lP5NjNIOdVr
         JFchFa+J/ZAOuyy00QvCr7wilBp+6nMr1DjLnqQpCSmutPwRs29x0BPiFt2HsilRrUnN
         Vl1OxmEj1KOg+oLu4RDl8D+29oBV6PChAL5pQAAIcmpB80svzuQNLGh4vdiKKpBsE5VU
         GIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682398061; x=1684990061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x7mjglO56uGEvHM/CvZvHdpiKNwZ+e2uyMhpZBFkVkE=;
        b=DXS1jcHyaiqYRRatEtlAXLWiMa0uLKxDqcGEemJuitmD0lkZbf9N8uCSjkCThZlPy8
         R9P1pYu4xzfSJNJCK+rXgCGN1uI3Ele9QY3lZgqW9ZTa+xLtBD4753QEYEKjTfY7W6e4
         ro1J7lofibdUx03oJpY7FE80eHb+11TPUwtJSRBNcmqA05gK+jDfFyKvIeFRYucW9XsO
         Pcnkjc7mk1/H2zluKkZ78zNVgWSHsCfYlXn/LPZYqN+rZbdfogV30PRYb/TJOTX/5k5l
         +P8iJ+gdqkaqT1wknCS2CQqJocdNyzCiFIRKGGErxjbI8ux2Lrz1bBUkPLaEuzSi73XP
         02uA==
X-Gm-Message-State: AAQBX9f2BVwCL+362CZDym0fjYPjEej4qdZvgAYg+ZoNbGkhlpVq45Ku
	aKYa1AipCvM9QHXein8Oj7M=
X-Google-Smtp-Source: AKy350bOJYJTKZrlXFCQ2GhNblEqkGfNZrl02hvCz7jUd069I2qflDI/W1W3D87dc8W+v4PbEoucfg==
X-Received: by 2002:a05:6a20:3d01:b0:e4:b52:76c9 with SMTP id y1-20020a056a203d0100b000e40b5276c9mr19136264pzi.23.1682398060985;
        Mon, 24 Apr 2023 21:47:40 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id b6-20020a63d806000000b005143d3fa0e0sm7255731pgh.2.2023.04.24.21.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 21:47:40 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id AF54610692C; Tue, 25 Apr 2023 11:47:37 +0700 (WIB)
Date: Tue, 25 Apr 2023 11:47:37 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <ZEdbaUGIKPHEXvnA@debian.me>
References: <20230424131136.142490414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MH4cRJTFut+TrASo"
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>


--MH4cRJTFut+TrASo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 24, 2023 at 03:16:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--MH4cRJTFut+TrASo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEdbaQAKCRD2uYlJVVFO
o0y0AP9dlyjXe9nttqfxl7kJvhqc3A8CkAbFLQBjY7sF73NGggEAkI1axTBzxJN1
LgTaekGueQ7GHTTcQRRO25m1DT/L4wg=
=HiEO
-----END PGP SIGNATURE-----

--MH4cRJTFut+TrASo--
