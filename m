Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A8E23AE
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 08:48:06 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id n17so1026560pgh.9
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 00:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qAFlJHtEN7OU9vMklNmbG9vzoWkur+SNbaJzwynOShI=;
        b=iwoEnsc1mZXk5zMDeAQoFIw5p9TG0uHr9uFU2hEI7Oq7DTbuvMuwrIgcVm5USdWwn4
         m66k557ZkbtZI9fB4dEipyKpMSfRq8giTBh+6Dtr4WKV4l5Fh63m7DhR0z7J4tRgC+d1
         tTOxFDzCYd/gV/wQwxJKK+1hqhFSrvImoc2x9yTkE5z7h5nKKylRqnmj6JFXmVHwaMzq
         7b2d772ff5nlitogikUNchDlDDsSf+BEvk8s5P1HNvust/PiwN8VVQqjVVDnhEbZH6ze
         HxysKiwNC0Rkq6uBPY38hC3QAGZxbt81q/XXUdCg/YMpRQYIMg+EArH9ZXkvvnnfgc8v
         LptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAFlJHtEN7OU9vMklNmbG9vzoWkur+SNbaJzwynOShI=;
        b=utsrSya9jh9buknAYZDKyQ7ofscPhm9oFtIE8XgKkxk5j8iBVwNyephyxzNWCgInGR
         1VBFlZsw4SfJtbv7pzfQ2gvfwvdjXVOqCWwx+8lHLYxGjCyobPDmEl35Gz5aBMHSBlrh
         pwJ2lanL18Bfw5P0mihZ+zJfJ4RpCPpE5wWTzTvkN8uCbRmqwaNfphzzEsJ7rFl/cVz0
         vHsh4nRPmPeCZwoDLdHZv/8k22ZvaqFdaG6qby0AkSHs69EukuvZW1JwH7qQH2XzuXbS
         aK8qKzXPJY81FfGBifPm3Pg7RiprxMr6ybyhYjJbDedQDIJJjOoRaVKR6QX6+Mk/yXGZ
         uQ2g==
X-Gm-Message-State: ANoB5pmFL2QyLyDbtE199xQMWdYNgRXiDG0w54Ynf8KET+Lxes3ohqFj
	mHDP3YOCcRFs2yLk7b/HVHs=
X-Google-Smtp-Source: AA0mqf5CHt4qVyr791m8JquWGV264mdeop/I2b1AGtn+WGxpK/dyjgQ6FvaXEPQxMVAUE8p5bxuUMA==
X-Received: by 2002:a63:2001:0:b0:477:b0d0:bbee with SMTP id g1-20020a632001000000b00477b0d0bbeemr8646819pgg.51.1669279686108;
        Thu, 24 Nov 2022 00:48:06 -0800 (PST)
Received: from debian.me (subs32-116-206-28-44.three.co.id. [116.206.28.44])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902ecc900b001886ff82680sm677275plh.127.2022.11.24.00.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 00:48:05 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id DF28E103FAA; Thu, 24 Nov 2022 15:48:00 +0700 (WIB)
Date: Thu, 24 Nov 2022 15:48:00 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <Y38vwA4WrG2Hp/oT@debian.me>
References: <20221123084625.457073469@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="iHe3S5Sc3E10kqvR"
Content-Disposition: inline
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>


--iHe3S5Sc3E10kqvR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>=20

--=20
An old man doll... just what I always wanted! - Clara

--iHe3S5Sc3E10kqvR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY38vtwAKCRD2uYlJVVFO
o9IdAP90sqMnAg6OZ/JBMbwt6qfX9zEht2wTrZ49mQPgxhUwUQEA39Om6crPMAlG
H9dJw+RSAlop+FFPg6u/OA9uSRP0bwg=
=ujca
-----END PGP SIGNATURE-----

--iHe3S5Sc3E10kqvR--
