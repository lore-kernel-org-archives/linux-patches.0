Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D7D6ABC
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 08:47:36 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1c1e3a4a06fso12552965ad.3
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 01:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693558056; x=1694162856; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Bz9KhSLDYES3lHxf4Rv9YDVYI9ZYxEiIT0+MdSGQk8=;
        b=Z7TFAEYhJhxw5SRbvVSRYizO6+ukZPPKIVJpTKgwVPcipExCG4IETlG5dbtmM9OXCW
         Mw7/OWpzv/tZ74K/JrOf5e6Do8OhDPM/ojeWp9nAllAmzUN46GQa/zIaCH1ib8bksFzr
         +iTtyEeeiYo0IJa86s0h8IrUWn+asq/feOama61AMhLy82TkuXMfH1MC+MXCQwZwZe8Q
         LLZbq8Bvh/r+2NyI5yk62iK81BNBfde7Ois9/UDSGl3nLlYo5jFTfbibCqmNQ9gCm6LE
         ExSEK7JhBPP5orWzoyFi6kY+X2SszL/hwD/8B92M6FdOqY6jdBQmq7BmDC0goxB5k0uc
         +cgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693558056; x=1694162856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Bz9KhSLDYES3lHxf4Rv9YDVYI9ZYxEiIT0+MdSGQk8=;
        b=TjszspC4nGJHAEHRSOdp6qXIOI9horkSV6JSjtys7ULftqW2GBtfKJe+F/s7uDskB3
         3L6LQZsfLUsiLDtW45dWaKb8NKrWnSuOMY5n30FrP6HQ5XFv55w0z006iv3Iyo/HLbS6
         LMR1d/gfojuT8EG5ozfVQvi2yqbzfVc8UPKX7MKjrwmR9yDnOHwZSHCmWlA7c72mpKCi
         ziHOvSJJSaorJSd4RKuRh6nL1qVfRMKnCllRAGgaBZDiDS4tB3so2K8oaffhXNF8DAXL
         1az0vLobVCqygnxU3XFlGglOtYTpr97OoF84Wr9w70RPrwqNqcr+pYumMEhCbm4Dp2k1
         0E3Q==
X-Gm-Message-State: AOJu0YxFCpm0A1C0njPp3HxC9Cv1AptMEItnYb3tJZMGbG3w9YjUyE05
	svmR5ds/l9wiI3TtI9vBi8c=
X-Google-Smtp-Source: AGHT+IEjqAYBqhW8Mr7ASWnCHFOpu3hTAsiUodZhqfPQeIEG/NEmy75N67CrcQ4donGK1J7bvXKMWQ==
X-Received: by 2002:a17:903:446:b0:1bd:f378:b1a8 with SMTP id iw6-20020a170903044600b001bdf378b1a8mr1806392plb.11.1693558056119;
        Fri, 01 Sep 2023 01:47:36 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902a70500b001bbb22652a4sm2473053plq.226.2023.09.01.01.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 01:47:35 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 7AE7F8088643; Fri,  1 Sep 2023 15:47:30 +0700 (WIB)
Date: Fri, 1 Sep 2023 15:47:30 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/10] 6.1.51-rc1 review
Message-ID: <ZPGlItgI-l2ljpff@debian.me>
References: <20230831110831.079963475@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t06PUDhssnELXJBU"
Content-Disposition: inline
In-Reply-To: <20230831110831.079963475@linuxfoundation.org>


--t06PUDhssnELXJBU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 31, 2023 at 01:10:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--t06PUDhssnELXJBU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZPGlHAAKCRD2uYlJVVFO
o/FyAQCXZJ4Q/8tTXYsUP4MbS7KC0hEaigYtfyLzq2dA0cRXtwEA8YaAYPN3MSF7
bmdjwsBCc8aBjaa5AMY8MNJ2Fq153gY=
=PAcP
-----END PGP SIGNATURE-----

--t06PUDhssnELXJBU--
