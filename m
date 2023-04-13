Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E79361
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 02:03:34 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id m18so13423704plx.5
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 19:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681351414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=txKXh4wrdWgZPXoWJyQNrYSeqmxrC6VLhn9OwDe5xzI=;
        b=c8XnjtGZdkmKrJPY85IPYQxCp/coLXG4/EPy3q8A8w6qGL+W/X5WlkSlxLcxNxFrg5
         XZtyZklnRfovwB1SgtBUiHCpKYdtVbNMMcFHv5ME6PtdwsRRBVaabUKc1f844PcFbMpq
         ncLgCfbkBXN5gdi991MCI6B7AH9GNB23xRCj1QR/+58iKP6fkEjIsBwAN2/9l6PxlKYc
         KDu1Y92ZRuI+/bJmfXFQc07+P6iGqIuC3P/4Lnrzp0raum5QCamKsogZxD2Lld61g43O
         SRV8rqYKx2+J0infozLmC+m0K/Hh2WMsR/oF0CmQqZP27HOD/MD0fLPAZWIr3s7ezClG
         mfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681351414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txKXh4wrdWgZPXoWJyQNrYSeqmxrC6VLhn9OwDe5xzI=;
        b=ZHSa839a8hyWRaFSX12F2/MecBEu338fgH3AqOtwl1wl3ApwW65nEQ099HQETxcnO8
         bW6B7mhgH+a0DYBXfRrssTwL5bUpHdantrxS3Rf1+w7SSxicLUzkH+s0eQAP916YKKhA
         OLEuabIt23tuqX0VAOjESrmoPD6UKvPAE4odJczpBsFOyV1Z9F85teEhBn0GZzzmP8d1
         ccxLbPmu5WDBqDuHfMGlWB1vWxATmomvgVAnpClVH/Nd+XwKYiKWdHx9pLXO8hbdYnVf
         fMYJtbrciErWiPHMQCqgf7RA/ng1V4VzA6rdNlRg69pa1foM4yKKWsPneXpXutQr72Wl
         pKAw==
X-Gm-Message-State: AAQBX9dL5dogjUSfNlIH2Bce0jCm7xQ652IK/cSjHeC/2Km72SoyQor6
	gO7FYuwVwlCTNLV+anMsZgQ=
X-Google-Smtp-Source: AKy350auSXqCVk+faIi1r+2x0Tjq68wARrPpXKccPY6IJ41zfANEUiTGSME/ILJ3z1Zs4abUNQ422w==
X-Received: by 2002:a17:903:2449:b0:1a2:c05b:151c with SMTP id l9-20020a170903244900b001a2c05b151cmr490202pls.34.1681351413734;
        Wed, 12 Apr 2023 19:03:33 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-2.three.co.id. [180.214.232.2])
        by smtp.gmail.com with ESMTPSA id je13-20020a170903264d00b001a1b808c1d8sm222317plb.245.2023.04.12.19.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 19:03:33 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 08E8E106823; Thu, 13 Apr 2023 09:03:24 +0700 (WIB)
Date: Thu, 13 Apr 2023 09:03:24 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
Message-ID: <ZDdi7JVDytc8nOi8@debian.me>
References: <20230412082836.695875037@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7o9GAVR9jzCLmd38"
Content-Disposition: inline
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>


--7o9GAVR9jzCLmd38
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 10:32:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--7o9GAVR9jzCLmd38
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZDdi5wAKCRD2uYlJVVFO
o2iqAP0WnutWnNBVz4DDXjKsMQ2GVRUSAFg8ckAdcmFuJnL/0QD+KOTIZrSE0FvW
B/RmZX8TnNXesrVJRxHdIGVEfpEC3w4=
=Q+aH
-----END PGP SIGNATURE-----

--7o9GAVR9jzCLmd38--
