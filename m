Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6A77B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 04:42:52 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-63b57c49c4cso4476442b3a.3
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 21:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682397772; x=1684989772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7FfxH82wxvv5V9KhGGoclWmqzeRQCv+GM3JH+/f8Q0=;
        b=clE6zXGNxgKEHJPOTPI5O4LIMVQvCYWIQOA0TtkQEIK3G7ODher4816Viort/IHma2
         WWYd+eZW/AWHJcj+/zw+OMkhpDmIrzV/EzhRb8rnbVY5LN4kwIvSAnu5kJ3ye6pZkQty
         zVy7QmcUt0AG9w+o9jEsLKLEpuNwxQEo8+gxZDsS3Cfnqz8pj/Flhmgg5QchBleO6Rb0
         Z81PSGBVH5cK3g+4NWN7/gFJEOB6Jr7t6/AATN2mHEUPypj/YYg9xDOhCubef11aCDyR
         t+q+jOi/nhSY4sbbhpINMx8Vn0/A5ZS9l2HVdJIexnrhSt0d+6fhN1SrLZL9xvTYZ/Ra
         b13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682397772; x=1684989772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7FfxH82wxvv5V9KhGGoclWmqzeRQCv+GM3JH+/f8Q0=;
        b=igXkYgH2WbA1Y5jIZyNgp7o/kZMZ4hG1DEAYYRiGv7k0gZJ2UoLPfPjPCtSk0q8zPj
         vGDFBrsUmu8oiA3rVDmfrU05L3hOIsJxAv8zi+ZAsHMpoC8On0jqtmOjmqGAJcjzWzEf
         jtaH4tizahWjCw7JYmHcfki9H02v208m4Rxu5vpQeyCyQyKKbv5BmuOqMJdR9SW3/xz8
         dRtTXsKa50pLDFcDAQMlY4WsEoQYYQU+11WnQqETZBGuvIS9VE0LFEHFAczYrTB6oGaw
         n2XJzZW8nfnXJN4L13X+eG3bobn6ZskWC0hCLaroLnXtJk49ZCl2up8UmEzlPgEJ8Abg
         nd3g==
X-Gm-Message-State: AAQBX9d1aeed8EJBMREfeIqePNp6Uk3EWSiFfVbH4l32/ICTpxLP2zel
	vXTt9QbK9HBFNRXldyQE5sw=
X-Google-Smtp-Source: AKy350ab4VRIeXYwtCmfhdNTEuYriqiifMOr3U9PNPGljqYxXAY8fPygi8tR2GHsKXbELi0/DlFoYg==
X-Received: by 2002:a05:6a20:269f:b0:f0:7b8:c77b with SMTP id h31-20020a056a20269f00b000f007b8c77bmr15526885pze.59.1682397771680;
        Mon, 24 Apr 2023 21:42:51 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id f7-20020a056a00228700b0062d7c0ccb3asm8237996pfe.103.2023.04.24.21.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 21:42:51 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 91C4710692E; Tue, 25 Apr 2023 11:42:47 +0700 (WIB)
Date: Tue, 25 Apr 2023 11:42:47 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <ZEdaR5cqTR5TQdyK@debian.me>
References: <20230424131136.142490414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ho/MHdgnWOqCg2wr"
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>


--Ho/MHdgnWOqCg2wr
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

--=20
An old man doll... just what I always wanted! - Clara

--Ho/MHdgnWOqCg2wr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEdaPAAKCRD2uYlJVVFO
o9TgAP41PVwOfew6DBkCTW+29CJaxW6tgRpXMGI+ZxwAPZNpkAD+I2OCkWQg59i9
4IoZ+lxvicBrrbb4rUjPJI0zpEjCFww=
=kvIF
-----END PGP SIGNATURE-----

--Ho/MHdgnWOqCg2wr--
