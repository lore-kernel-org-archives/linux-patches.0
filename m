Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E888BE8
	for <patches@lists.linux.dev>; Tue,  9 May 2023 10:06:15 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-643912bca6fso4478570b3a.0
        for <patches@lists.linux.dev>; Tue, 09 May 2023 03:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683626775; x=1686218775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rSHR0ehtB2U6yMU0nFNA2cGE1gtgPOWWyVaF76Frhk8=;
        b=Vi1G1NAKv9XWgPjE7QbWiX6BlpCxh9Ni3BopbDive+HIIjZbGW7FE7U108+iq6i7S6
         C/a1ej6xB+ulyDR7HiP+yXHg81X/j+Ooxig2TD+AN/NfAuHsEsfQpRLcfW36lZJ+jx2O
         G04xxxnaUToXtkMrgcWhRgvrnx8RbBJZY4+ZHWdczzKZRTI1TXQQf8jtuYEMKoebceZC
         qVygZPznG/eRY8P6ZV6B6uLI38ow4fHNB0Wh7fsYiPlTr2tI/X1Pzr9X6J6TV+F12BHd
         ZNiaTaFNsrLxaHYshT3D8EO35F/wW6dBvU2diBxUJcub1mEUAOqJ+0Pz47xF7NQacau9
         uQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683626775; x=1686218775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSHR0ehtB2U6yMU0nFNA2cGE1gtgPOWWyVaF76Frhk8=;
        b=J7A49IIKTGSjP8SXS7O32xWDnd/5F4lwcve90OfaIl5baGs2A6FOnSOubzUZuOqBW9
         NPK165cXhO3yfdmbxxfp1gQlPVUCWHT+UV1QpQ/Ylzih2gZKiVrsV/LGoyi38vx68jiZ
         8ArWdG/XJQA3F56KsTN4K4iquh0hneC2xt1yXjk6MAe93s6Q8IBxwSUBMBoAqen2XbS4
         1tIAgf++kGzuN5RmgYCbiCzRPaWpYY4d7TSrVCrre25btFCetQPrV0UG9UIfcD1THwEU
         6mTOVxdZcgNI9DDh9XxbWNbOHqPkWN+oIFkmd1oErt/3gOtgpA4F3eO6rEooGYRprnpD
         U97g==
X-Gm-Message-State: AC+VfDw+58u6lFvMiGMW9G/6jq/G4i2tG4Y1DKIWFMEDUcxiy8mr2G4X
	5fwLwRXLWcWVlKvGfB+IEVc=
X-Google-Smtp-Source: ACHHUZ652st2RqBIyIOxPTtzqMCXN3fTicm9MdVndNcyYFPE2GW2Cw6lX0OD7sa2m2xrZX5ffT0ivA==
X-Received: by 2002:a05:6a00:1688:b0:647:5409:5d08 with SMTP id k8-20020a056a00168800b0064754095d08mr854975pfc.17.1683626774849;
        Tue, 09 May 2023 03:06:14 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-80.three.co.id. [180.214.232.80])
        by smtp.gmail.com with ESMTPSA id f17-20020aa78b11000000b00642ea56f06fsm1460696pfd.0.2023.05.09.03.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:06:14 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 0207D1068BA; Tue,  9 May 2023 17:06:11 +0700 (WIB)
Date: Tue, 9 May 2023 17:06:11 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/610] 6.1.28-rc2 review
Message-ID: <ZFobE/Zo8FjJ/o+P@debian.me>
References: <20230509030653.039732630@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k4sHR0uTJkFkorbG"
Content-Disposition: inline
In-Reply-To: <20230509030653.039732630@linuxfoundation.org>


--k4sHR0uTJkFkorbG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 09, 2023 at 05:26:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.28 release.
> There are 610 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled in my computer (Acer Aspire E15, Intel Core i3
Haswell).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--k4sHR0uTJkFkorbG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZFobEwAKCRD2uYlJVVFO
o9MtAQC8eEi7ld6tOVtOypT4uakIZtPXwLzw06E9oaCvDXhg4QEAtn+2Z7MJeDW1
DlNakHo1LaSZvW8sfS0tUZ0EiK4lhgo=
=NfSP
-----END PGP SIGNATURE-----

--k4sHR0uTJkFkorbG--
