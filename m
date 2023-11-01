Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6B9643
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 02:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/U0MXmy"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3b2ec5ee2e4so3814220b6e.3
        for <patches@lists.linux.dev>; Tue, 31 Oct 2023 19:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698807354; x=1699412154; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j0NzdQStEiGv9KFgnf7s7Dkfku/GDCcYtb+3dYJ4A6s=;
        b=W/U0MXmyK3AotxCKBvlLLP93Zih2Q7dXPHKkxrCIJhNx1HLNWpUuozZlTv4mO9vtO1
         TzdLbK9/qqNlph8fEzLI79BxNiy6FWl2qMGC68XG1SYaZo48MsG59hPIAA/cSdindExX
         9oKi2iqtuznXKLjcfbMW6eSPcm048Gph0OZjnLZbwDg9vk4SS9g4ALRZ2mTXu4Z0Kurd
         6+YOnzrUwbVYzcDzc9rIstMUS+jEP5t9ITm/IQdryi1O81vcqyUZKtVRU6FO+cAdvR4W
         DVFM2736Gkzxjkou0trixJbOaXHW4Y/GVYXret0YrcPnTd+Q5l3E8nS7k00gGowBtGr9
         cTzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698807354; x=1699412154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j0NzdQStEiGv9KFgnf7s7Dkfku/GDCcYtb+3dYJ4A6s=;
        b=YdTw6YdkWkIVQrN/y89H1RbHwqezjstA1gqMZfun13R5xth5z+lOEG5edmNARIveml
         bEHZWzGABXO0vPdM0ReFMDfh+KUa1ndFS6UlYnbkZBlIVoo5zCf5d7pGmZQtBrXoCkg2
         ZiXGBliabgfhqSvk99G5LlabnJbJIFpvtExLFuem11/H2R88n6BYF6Xps+c5i0odLffA
         2e7L0t5ok2v8YLu9AZap8K3ucILW3BOshOE3QpwjpesxjqgMLkXI6RFu25mpEqDhOdtW
         VziNtxbDJPLF7OfRev8atZIoZbPHcJV1Xb+8wzUT8PhdecAknCsY8PDUGmgrUflc2yja
         JSLQ==
X-Gm-Message-State: AOJu0Yz1R7aByq2tZRB6Q94CIsdz50CCKc5Dd8jsCqTJhppn1fwXXiTz
	ePbG3UfWOLUzZPalAnVM+rs=
X-Google-Smtp-Source: AGHT+IEStQwsggjPSVxZK7H5JCYfLs39GZqsiwnTtQ+CObQ6899CyJph8hU23Brat08VnMaMx09eYw==
X-Received: by 2002:a05:6808:1491:b0:3b2:e9ab:68e6 with SMTP id e17-20020a056808149100b003b2e9ab68e6mr19602702oiw.0.1698807353830;
        Tue, 31 Oct 2023 19:55:53 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id t14-20020a056a00138e00b00692cb1224casm282776pfg.183.2023.10.31.19.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 19:55:53 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id ED3FE80A7352; Wed,  1 Nov 2023 09:55:50 +0700 (WIB)
Date: Wed, 1 Nov 2023 09:55:50 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/112] 6.5.10-rc1 review
Message-ID: <ZUG-NpRAuu4XwwM3@debian.me>
References: <20231031165901.318222981@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Vle9uzRdIeXCXV/5"
Content-Disposition: inline
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>


--Vle9uzRdIeXCXV/5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 06:00:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.10 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Vle9uzRdIeXCXV/5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZUG+MgAKCRD2uYlJVVFO
o6baAQD20q0IJ4WDIRVrIyup95Hfba4bvyoyagAZDcgcE5O89wD/YaDzNu69EkY6
BlW4dXfh2BCC8RntPiHO6JexD+7YHgY=
=ntj6
-----END PGP SIGNATURE-----

--Vle9uzRdIeXCXV/5--
