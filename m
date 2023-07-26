Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65011FB9
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 06:14:28 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-668704a5b5bso5884777b3a.0
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 23:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690352068; x=1690956868;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZW4+HexhIfwVoyaBBiTGtJ1DUr7i4tb46nOtZOQFg1E=;
        b=jdUKlfpTXV7c8iklcdjKJ0DfsNTvxBa/dxGm8GBfO7METCGp+w2fo1cHW3seAnfMnt
         8oPEViY2g9MN53oB7T5K4ICNoVuzKLJyu40WoPps2GuDe0xJZQw0ABPXggRXYRURb6bv
         kpxfVOeKJpkl/pK8ikxQCJV0nabo5YW6AE9WQ6ssjWYJlsSGlIuOYxnNrr+vpyfioOYv
         RC7pAaEBI901CDtRAohaVWCACPG6tTbgjTRa8omIkpub0+HQpoqqtfNPe9P5SXcovAUN
         CA/10pQaChkRv2w6WLFMy1V4wP97WVabt5oDklRB/dovYw/B9i3OCbc20yQ3ZWYuSCvi
         W8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690352068; x=1690956868;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZW4+HexhIfwVoyaBBiTGtJ1DUr7i4tb46nOtZOQFg1E=;
        b=YNI4ycbM5NxvtHVsk5ZhN9x9UJuD9GFkL4ay0fTs6KlqV55EljBPLPZfxDzfqRMUR8
         NuA/hsQf8hC23lu2iMjYXISXzOOt/5PM7aE6et/Xb+BLtPy0Yp/NSrOqFXdhlQLi3nsE
         vTUfy3segpyyC+VNkL/2ruReRI8lQ5yHfmlyzIOszW3y7CzyltCRkDyAtTtvKcu659Am
         O0+ehzdFe05HDTp6LDtqNLpm21kPMcisBhSdpj3c1TOwfeRBT+E8UMDNxV2o/Qt4uO+3
         lM0U/ppkZx+/0g9C8lzPPi7apd6BlyNinPJlTy+4jJX8yUb6n2g/qo2J9ar7QgEI5JjT
         MgyA==
X-Gm-Message-State: ABy/qLZNXGYkTk5Aj5hCRne/JI5prtkH/ulRuvEV3/kP3ahYUJ2HEg8F
	WzGMOt9OCbN/+YKnvPlvj1g=
X-Google-Smtp-Source: APBJJlHmPZxSzRTI0GN2CtFEdTQoABS83nnojvZlgAdbH3SinIW07T2W3+fFcBsOSevbw33MR7kQ5g==
X-Received: by 2002:a05:6a00:2da0:b0:680:98c:c593 with SMTP id fb32-20020a056a002da000b00680098cc593mr1835529pfb.7.1690352067802;
        Tue, 25 Jul 2023 23:14:27 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id c20-20020aa78c14000000b0062cf75a9e6bsm10621528pfd.131.2023.07.25.23.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 23:14:27 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id C3CCD8191873; Wed, 26 Jul 2023 13:14:23 +0700 (WIB)
Date: Wed, 26 Jul 2023 13:14:23 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/227] 6.4.7-rc1 review
Message-ID: <ZMC5vzSVvmtdLq8t@debian.me>
References: <20230725104514.821564989@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0as/QakmbVEl65Qx"
Content-Disposition: inline
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>


--0as/QakmbVEl65Qx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 25, 2023 at 12:42:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.7 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--0as/QakmbVEl65Qx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZMC5twAKCRD2uYlJVVFO
owDCAQCWcJfpME3gNaICnS+8PCpwFyZllM2rIz4Gmq+Ls4bR4wEAqI4YeJeeCDUD
MZ+oucSc7otb18P1yqkzFNnDGMy/sgo=
=x+Vd
-----END PGP SIGNATURE-----

--0as/QakmbVEl65Qx--
