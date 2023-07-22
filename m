Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEBE125A0
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 06:50:09 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6b9b52724ccso2293457a34.1
        for <patches@lists.linux.dev>; Fri, 21 Jul 2023 23:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690008609; x=1690613409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X+Kej4FyV0ucQSrNXd8j+dCrf51e/JXrwmwjYYZs1ZM=;
        b=KdDRcm9TTX3hOcSxBhFlzzBBfEp2Ji6BdoTCMrZe1iyvOpyaShvJO4cXbr+RtTzt9X
         D5L5D2RZFsmbxc+8HFdkXMnxoVMO/xkPozmkvcNpwqQZqpB8rjXSiv6mzRJpTkV512ja
         rdChh7fxNSgrz+lTKp0LkRfKHRbp4S+Fq8vnP5Fb9cz7t03j0iZXgdAqqxXwyrSDJjN6
         IV121ooYqtr9quAHSdCE4eG4LAjTSDVax/3ZjBlgm4nu4+GLEieuZFUUzFPC03wqCwjA
         2EXVDqPqb0+O4lUktzufd2Gk7gkF8BbQyYi77GI/y3Ndros2BtNxiZw4zbSLCVHtMsD4
         2SIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690008609; x=1690613409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+Kej4FyV0ucQSrNXd8j+dCrf51e/JXrwmwjYYZs1ZM=;
        b=FYtqzGQnUeVk5UATYqnpGkMKmhlOLh6tZnVnGjNnr2znTtdjbcSfA4/4m+yqqiq1Zw
         3JY10FSsmjqalWmVmiddsDeAg0nRGAZduyVHT8NEchh1VQIPQZh8tZWTmMmDwDeeuKA9
         s6F97bkt7mXRTJHPBtfFJPqVjAArZeHEHbrLX8os8g+3U7K9y6ZnXtitn5+ALoKP62hS
         akn7jKz6e9htrOtY/MzxzuIzhD7PjgEN7iSEupu6KnbHxsy8PBpbOpltkdAczCp+rd1t
         VRbxzg/gzWE8gJMbvqwJDSzCzMreJKLoucUIRP5zwgRgSwH7Ny89KTQ67ojbKwR601oH
         vbXw==
X-Gm-Message-State: ABy/qLbiYcsBotdH7qxd7tARwQd178OmqK3POSZb32rFxe8cTHT35Jak
	1PXLYuUjpZ4wiKd8K0P+FhE=
X-Google-Smtp-Source: APBJJlFmjkOOHx66vsYbYfEXY8RTnXSQ0UuN4PX9e3GC4vpqh3AxP1/l0Tkguy+4rASp+R5eS/v02w==
X-Received: by 2002:a05:6358:6f1d:b0:134:c37f:4b63 with SMTP id r29-20020a0563586f1d00b00134c37f4b63mr2518810rwn.2.1690008608860;
        Fri, 21 Jul 2023 23:50:08 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id h25-20020a633859000000b0053051d50a48sm4216628pgn.79.2023.07.21.23.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 23:50:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id BA69C838FB64; Sat, 22 Jul 2023 13:50:03 +0700 (WIB)
Date: Sat, 22 Jul 2023 13:50:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/292] 6.4.5-rc1 review
Message-ID: <ZLt8G85Cqc7NcQQr@debian.me>
References: <20230721160528.800311148@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="I9WX4wvPI3bnPVfW"
Content-Disposition: inline
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>


--I9WX4wvPI3bnPVfW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 21, 2023 at 06:01:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.5 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--I9WX4wvPI3bnPVfW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZLt8FQAKCRD2uYlJVVFO
owseAP0fUNb4K1XvER6JIhoMsiqFFW321L68YLtU4GjDwXKX0AD/dauOa16lv88k
WFeJyED+QKru9PDkvpBw8X3dJ0zDGQE=
=DG9/
-----END PGP SIGNATURE-----

--I9WX4wvPI3bnPVfW--
