Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FA853B8
	for <patches@lists.linux.dev>; Fri, 13 Oct 2023 05:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cN0Pkino"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-690bccb0d8aso1451266b3a.0
        for <patches@lists.linux.dev>; Thu, 12 Oct 2023 22:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697175127; x=1697779927; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nIvaPS82lenFE9njzHfPB1IlZ8+QONjjy7qyu3wWos4=;
        b=cN0Pkino0ZerXjt7Rv184mNed4fjIItlG7/gS1CqtkhnksY5YkS3936ma1/F97ElGf
         AD8Im5O9BCfgbNdCq610EVlmYfMzAOGAAyHo3Ruaxw+tZB+NqNUNs3RDj9MuD1kL3zDA
         hzFQvgbjBFVBQENkEscZMxc9vRrxScsbrKsyg1jUrwSUA3AHxvFrYTX9EUs0V1iyGpBl
         hl+BennjSxhr9QhaP2Q1mduViz2u0NKYDO7a7zYTd7F2Iji8vSBKGFGDTandV5iOHBbL
         RBilEBhOrhi1yY/3rcW6HKi+5TvnITdNTB1RdCrfnyN02mEcnozDhoxo2pGykzYMKda6
         eK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697175127; x=1697779927;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIvaPS82lenFE9njzHfPB1IlZ8+QONjjy7qyu3wWos4=;
        b=u6dT2o3wQW5y0jL9NKzPE0AkkF6dva+iiPQQr23OIIyQ2QuZlY2GZA6uTEvcX+vVEp
         SSuwu5oMLJ3O2s8kp8jJUfSmIDUbL3a3FglghdW0hEfSYCTkY9jRv7cAB4FmHN1w5tDm
         Fl+djhBt3akW3JxyMUTrO0myxTCFUSeA5nFSmvyBSJTktgD07oDoCRznqIiRlGrtI36S
         mn1EsW/Q4oaYU5qXQuSU1jCXXmJCnrCWTODiAN/Ozsl1s2r3mOrImUnk3nHlmXk2oINC
         DjSCHoG/81yENiVuSQcVvw6kj5pCT+hZmq4zlPqfHL3OfRavN5wmGe/o4uo0YtRVhTjc
         46bg==
X-Gm-Message-State: AOJu0YwQTUmJ0JTJ5RqIZhUtXndoKJ1yBqA1dBX/be7A9veOGcDMwKWS
	IRzIvwer0NpPkKjzRDn2ZWs=
X-Google-Smtp-Source: AGHT+IHF4II3VixwJFDR98pc7JU2m3Z7Qk8+kTLeK1ZUPjdx43t6VBQzk24AdOEBlcQKpZG63FOqsQ==
X-Received: by 2002:a05:6a20:d417:b0:15d:4a4d:ecf7 with SMTP id il23-20020a056a20d41700b0015d4a4decf7mr20773277pzb.36.1697175127387;
        Thu, 12 Oct 2023 22:32:07 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id s4-20020a170902ea0400b001bbab888ba0sm2903283plg.138.2023.10.12.22.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 22:32:06 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 35C2C83B4ED5; Fri, 13 Oct 2023 12:32:00 +0700 (WIB)
Date: Fri, 13 Oct 2023 12:31:59 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 0/6] 6.1.58-rc1 review
Message-ID: <ZSjWT2w3uzRkRca_@debian.me>
References: <20231012180030.112560642@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DtwhJ4fBDgUKVjIt"
Content-Disposition: inline
In-Reply-To: <20231012180030.112560642@linuxfoundation.org>


--DtwhJ4fBDgUKVjIt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 12, 2023 at 08:00:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.58 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--DtwhJ4fBDgUKVjIt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZSjWSQAKCRD2uYlJVVFO
owi7AP44/kvOHOX2rSJOHx3Y9NngBuPUkm+nr1XUfNc1uF+2AAD/Ybe4YrYRc0Ox
2KFxSLfx8e8LFkJB0//IMkRdyjvqlw0=
=VyG7
-----END PGP SIGNATURE-----

--DtwhJ4fBDgUKVjIt--
