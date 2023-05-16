Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9DA2C732
	for <patches@lists.linux.dev>; Tue, 16 May 2023 08:54:24 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-64ab2a37812so3849030b3a.1
        for <patches@lists.linux.dev>; Tue, 16 May 2023 01:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684227264; x=1686819264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qs/7Ze1koAlsm5VE1mt/ZaAC7P2mkk2AOe4o4H+TXhY=;
        b=Q1mZzol7NxDDcA+ExVSYU416UvOvHQjarH9Vhi3Hb9071xfeMYxg/aAMScUEnmbfya
         AeriSjcgR6+enOmXIG+yKmwb775aC+bOzI5ZrDjunOL+/p//771T9L91+cFBY3VeoHEw
         C8RlA/bhqFlvWtbvssBEMdv1dXZJoLrl4hKuXfwzxVuQc8vfDc71pRfyx8I298if8oGZ
         3n/QTjbDyZa4ytB2oiXpZM/QBIKLfsTNfPFx19VfTpnzBrS4Vcxzc2x242tPqXXpivZl
         2E92vU+NdAIGEOfHmNzRD7AigDhzYQH0RXLBKPsYQULpC/mVUhsCLr8qARQhfWRyRPI/
         iEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684227264; x=1686819264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qs/7Ze1koAlsm5VE1mt/ZaAC7P2mkk2AOe4o4H+TXhY=;
        b=YGl45BbXuWC//m0D8s3E74W9x/VyDvCAYz6voo9X6IYNnsNK3aUdw0X+fDqWtSaV+9
         5x978UBig8ABBtXGHBTo5NWSylYq2fVkCkdn9U/1RTfUUJJmOHdvJ7AmAR84VqM9W2C+
         Wd5R88CzmeM+9PLzdiTyZirUb87+Am1NuT8Um+7GuTl5aUR796cSDHzp138OO8K7QxFL
         fng0ljpKm9ndYk+bZylxbEglL2/L/meZpbYdstHpprJLHgk5rMBVm0YHYXzFIhgBi6vD
         0Yyy6df3pgZK6WDD/ffKKDaYF3VSkSoIBBZjIr+oJI0i/6r6013t6UuK0ZAEpJginmJ9
         gtEQ==
X-Gm-Message-State: AC+VfDyvH12PU4kxV10njpxOhq0jsCFrwGXPAubplOIjyE6HmYcioUa4
	c+ujAcOVC7rnto1661eoC68=
X-Google-Smtp-Source: ACHHUZ7FAm2N6rYgyI7z56LkGLy2JrcqBECUBs3LbN0MXNUIu2TCC7TajgNt8E0bYKfQcaFCJJa5Yg==
X-Received: by 2002:a17:902:ecd0:b0:1ac:76a6:a1f with SMTP id a16-20020a170902ecd000b001ac76a60a1fmr36362638plh.16.1684227263596;
        Tue, 16 May 2023 01:54:23 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id y5-20020a1709027c8500b001a98f844e60sm14889934pll.263.2023.05.16.01.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 01:54:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id A37D01069A7; Tue, 16 May 2023 15:54:19 +0700 (WIB)
Date: Tue, 16 May 2023 15:54:19 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/242] 6.2.16-rc1 review
Message-ID: <ZGNEu12M/Xa7vAt/@debian.me>
References: <20230515161721.802179972@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4kN2eSG9PT4RUYXb"
Content-Disposition: inline
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>


--4kN2eSG9PT4RUYXb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 15, 2023 at 06:25:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.16 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--4kN2eSG9PT4RUYXb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZGNEsgAKCRD2uYlJVVFO
o7MQAP4roA5DQA/rKJNf1HNYRbcObFNB6vTfm23+KXqkwA8fSgD+I47N+Mvkk1GI
ZUNmn/Sl7NAYnsGlvicbpZTc3OeFvQo=
=eVSk
-----END PGP SIGNATURE-----

--4kN2eSG9PT4RUYXb--
