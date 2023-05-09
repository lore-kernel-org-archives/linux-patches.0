Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8FD53B2
	for <patches@lists.linux.dev>; Tue,  9 May 2023 10:04:24 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1a5197f00e9so39913155ad.1
        for <patches@lists.linux.dev>; Tue, 09 May 2023 03:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683626663; x=1686218663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xjh4LrxhhSgX9bI32vEpSBC4Dyg6CYhB8VLx79usfsE=;
        b=p2+Ns6zrGjoBa4qtiGvTjNXJggiKcQ40qT/z3yatZQsqFyqm4pnLxbLX0TPXJ108Yv
         RxmwMhbHKtDxidQAa84karDJySiZUBgbsPM7Vfn5uLb1K1bIAkyr75NSTZiYIyoGe0E1
         Z1KTKOtelb6oTqJmT6ni5VyWbqHLB9bGgni0OVeBjN1uEEL18Go2xhlo7R5fFYIBl0oP
         NkagDSGrPlkgBHxm1R1GCBbY5ZuY/t9LNC7Sdp3X7alcfZdZYb0+BAitZ7I4IKntM6/J
         XHiKWbBUHYsfk9UP5BNGhhAQYneffLMghsH/E3jAsPDLyljl2zAJeGztPW8jniwlj7vd
         4vrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683626663; x=1686218663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xjh4LrxhhSgX9bI32vEpSBC4Dyg6CYhB8VLx79usfsE=;
        b=P1MQ5l1kah7kZHFFEjtRsUNGxhpG4irlWpb9t1KAY4E5Yd/9murYHjO8KoKkh4Sjcc
         eIzl9WJRFoB4ukibXtTbkmzqhDEsiVTFydpVmoDOM6lHijWrJh7QjsPZhJM6moLmTGUg
         WCTa1+dtuPaHWrRpZzXdTQSH1GI7JSuYXLnCX/XkHDtRgHE7OwDcBR8u26HA2OpNhj/p
         u7IbLfvT6AS/oiYrxuzriXW1Hl2i6P5wgyA3xUMMnpemmHAYwlIBDF4xmfgefisY/o1L
         dtlgVF+zVYmotVa2sh4L1V7aslPEjaQ4dT/JJ6X8Expz3ZC+q7bdFQU/P84lrS1lPQp9
         8Prw==
X-Gm-Message-State: AC+VfDznSSob+jRtft83rH0ApMNm7WwfShk6AB+vQNsejbId6phM9+vt
	zFsyPXNK3dEKJs96XimA0KE=
X-Google-Smtp-Source: ACHHUZ7zwgXnXDCe0OM4n84lh/VgQQ9oM9MfTp3sot72W5jF8XDvyAcK+gLoj9jLkDXimo+jgfwv7A==
X-Received: by 2002:a17:902:aa8d:b0:1a6:db0a:8003 with SMTP id d13-20020a170902aa8d00b001a6db0a8003mr13380333plr.23.1683626663323;
        Tue, 09 May 2023 03:04:23 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-80.three.co.id. [180.214.232.80])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902c3c500b001a6ff7bd4d9sm1147214plj.15.2023.05.09.03.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:04:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 4FE691068BA; Tue,  9 May 2023 17:04:19 +0700 (WIB)
Date: Tue, 9 May 2023 17:04:18 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/370] 5.15.111-rc2 review
Message-ID: <ZFoaokPLcvnnP7Ns@debian.me>
References: <20230509030611.521807993@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/8nwasEa1JIA4aew"
Content-Disposition: inline
In-Reply-To: <20230509030611.521807993@linuxfoundation.org>


--/8nwasEa1JIA4aew
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 09, 2023 at 05:26:15AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.111 release.
> There are 370 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled in my computer (Acer Aspire E15, Intel Core i3
Haswell).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--/8nwasEa1JIA4aew
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZFoamwAKCRD2uYlJVVFO
o6WgAQDncT8sJ1nd9eAmkwENwAdOKvkxmdt4P1Lonp5n5+77yQEA/Nlp2sy5kAyW
ixAsQ0Ye6HjyJ6vDiuSGTh+ATPYLZwI=
=c5ju
-----END PGP SIGNATURE-----

--/8nwasEa1JIA4aew--
