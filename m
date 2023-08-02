Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17571872
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 10:44:29 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-686be28e1a8so4523970b3a.0
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 03:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690973069; x=1691577869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PSfohqKv/ZinqsoF8vB1X8kqyFmbZl82QWhQosdrgX8=;
        b=l3hRtcrJ7G2P5VIn+bqZadfdxFpjOLNT0y/0b/jmTb0gb/JG5lH0KlzSjVZVBKUThR
         I4w2fms4o98/3WoMHb1PscyyrwPGutTGmGzhaIsrd+jMUdZW7X5ccskLSiiBnpOBusA4
         /yF8rNWPQon8oy+LpRoPnNJR6r37uzpDEB8Sy0KpGNkqL044ohYaCG+qV9nEFuNKLjf5
         a3bpVYSDDosAaTM3z5/N1UK2vjiY3H8TI+0J7s0haWjCOkCRlxqbG4sgSgbFPXHAwpX/
         vj95OiBWqvZZW9+xkRPRUqrHSN1CNFknGuLSJYzbciByGWDrt6HYUeTdJC4vJPadkS7V
         4lGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690973069; x=1691577869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PSfohqKv/ZinqsoF8vB1X8kqyFmbZl82QWhQosdrgX8=;
        b=BOTfvxOah6C7Q4W0RHWFFtk/E3qbPR38Uh7OmZ9iZLk0ZLw4quO0ZldU/nZUlxbYGW
         Myn/H9UVC+9OAkVi07Cm7Z6bQPKWG6h1XlDcQqK7aNEGsLPf/JJDCzdeBuQOTKMz6yT4
         U8+paA7Us+4DZ4GKXdBUSfU11n/hXRzH5j5QZbZIMmD1uA7cv+PU/7elD8NYp5XzW0/S
         1tjdyZKrnPqYiobqTPHhbFALG+q0zkOGDle0kaijAEXwzvjF5J/35poWaRh2xr9SXwFS
         XTww9BpZIM3ilQrpJwidNkPaWGwNCmvKinqlnLg/PZaVHay1U0u+adpfvaC6Oeovo4rE
         6bpA==
X-Gm-Message-State: ABy/qLb8JLYsN38PkAHRXUiAPYE2jIhYqipmBIziAzwvpb4IuJUBSnZy
	+mELJIz63Osmf8OnGyeJC4c=
X-Google-Smtp-Source: APBJJlETmUOfP5RxhXg51IdrQj3IwWnz+XUBKZfvnwsOowUz5UxjDeZ5ea90MKIQIRBXLFuAGNt/XA==
X-Received: by 2002:a05:6a00:1a56:b0:687:4a3d:8fad with SMTP id h22-20020a056a001a5600b006874a3d8fadmr6285922pfv.16.1690973069147;
        Wed, 02 Aug 2023 03:44:29 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id a15-20020a62e20f000000b006783ee5df8asm10791570pfi.189.2023.08.02.03.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 03:44:28 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id A0EE48197C37; Wed,  2 Aug 2023 17:44:25 +0700 (WIB)
Date: Wed, 2 Aug 2023 17:44:25 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/239] 6.4.8-rc1 review
Message-ID: <ZMoziaxnZljReMvR@debian.me>
References: <20230801091925.659598007@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="v90g9n7xpLHxyWn0"
Content-Disposition: inline
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>


--v90g9n7xpLHxyWn0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 01, 2023 at 11:17:44AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.8 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--v90g9n7xpLHxyWn0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZMozggAKCRD2uYlJVVFO
o9ZoAP4u/SWwFLFLC5yO48Pk+fBL5p3stCXyBKptk/KrengdvQD8Ded+WjyKVAfI
0WJ4nq/YR2ek/hUEgo0q/6Fgzz8Rrgs=
=17DW
-----END PGP SIGNATURE-----

--v90g9n7xpLHxyWn0--
