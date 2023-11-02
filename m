Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E854610E7
	for <patches@lists.linux.dev>; Thu,  2 Nov 2023 01:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VhuBtq8U"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6b1e46ca282so487724b3a.2
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 18:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698889574; x=1699494374; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gy/GVknEDM3F376D/bWf0Z1BlGJZY3l5y/EY0cLFHSg=;
        b=VhuBtq8URJ8GBkAey3lUGJToCKlHGG+8qENol55JfsDeh5UhX1RwP2LTWDz0JbXACV
         l+IbG7wiFB4yF7ZbVxZxU/at9/EeZnVAAcZMJM2JlcgtPuWP9KpdW+4G8YOlhln8J4xV
         4Aw94pP5s1ap/2K3qOnTDDKORdUGJI5ioD7ZJWp56bTYXeqpGRINnYMqtsYxAB1Durnw
         dB8keezHKhtFLziC3PknSBxoGWZuP6VcZLmWwQmjd1ZRMJaaI8mfLbdeMz1nwK+AjysF
         vMsr7KYfs7O7UlR+++GUlopArfiWQ4RtkdsW1+K7QxLEvZTIMQeBHgNcW7yr4G+YuEgU
         6heA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698889574; x=1699494374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gy/GVknEDM3F376D/bWf0Z1BlGJZY3l5y/EY0cLFHSg=;
        b=s5Rh8bImUppFGiKYE8MW2dc8H2uosT2AqsTMYWMvdUr5k9am0GuWxxjF1XY+ARfTcE
         GvUqK7mkgYgPURXTqye/o3GHaVYF4PepT8KTO0li86WZTSYOsvLEUpp9ZM7uY2eMcbmK
         uASCuhwh28jpTGyCeh7EZ9NapRHB8sxM7fUr76ckcr5EH9312IfSm1K8IvcXsDOL1zTy
         NGv1FP10mU3qCQ7OJ4It9piJ1kc6oCiGcMg3Ew018M+Ourpij+twa+6Sz91cp+4iAzU6
         U2vo2R8XFbTf5rJ4RWFFIyaF7NU1VWso5f5HG9hwRfR2nGUamZmY3bxapxnCFzBZ5y6r
         W7UQ==
X-Gm-Message-State: AOJu0YzUo1FtB6sj3ZTAT1id8nTDdyrpRPg69ZJaxk5j1dDz+B90UGEU
	OhC1h/sdUbse+2VX7mloRU8=
X-Google-Smtp-Source: AGHT+IE1CaL6tZHiXbUN1S+2Xw9nk5lTFyRUC9NtCsot0YT6JaNtGPJFTNVzNYU2iGIKcYNUusdGSQ==
X-Received: by 2002:a05:6a00:16d5:b0:6bb:def8:b0a7 with SMTP id l21-20020a056a0016d500b006bbdef8b0a7mr21606945pfc.3.1698889574218;
        Wed, 01 Nov 2023 18:46:14 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id a17-20020a637051000000b005b3cc663c8csm436415pgn.21.2023.11.01.18.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 18:46:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 955DA80DFD3B; Thu,  2 Nov 2023 08:46:10 +0700 (WIB)
Date: Thu, 2 Nov 2023 08:46:10 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/111] 6.5.10-rc2 review
Message-ID: <ZUL_YkVgFnWQ9k-7@debian.me>
References: <20231101120147.190909952@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7oM5a5ZDZL/pUZYV"
Content-Disposition: inline
In-Reply-To: <20231101120147.190909952@linuxfoundation.org>


--7oM5a5ZDZL/pUZYV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 01, 2023 at 01:03:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.10 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--7oM5a5ZDZL/pUZYV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZUL/XQAKCRD2uYlJVVFO
o+/CAP43RALYZT77HFB6VE70PhFjGfg1TfgPxT6QuqLkqzEGYQD8CXvInaHtI5wq
WaGUr7YyWPEzjjC5bkWLf993GkrrBg8=
=f0/W
-----END PGP SIGNATURE-----

--7oM5a5ZDZL/pUZYV--
