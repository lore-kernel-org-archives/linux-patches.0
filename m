Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7581D1855
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 06:42:59 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1c43166b7e5so24867825ad.3
        for <patches@lists.linux.dev>; Sun, 17 Sep 2023 23:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695019379; x=1695624179; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aNd4SPlO+Rpe4i36RjIqSfIzurzEIvdaKO8DkO9ug6s=;
        b=jnXp8gUmkeanhdA9WoFWkRnhXfbfAWxj/kksCqflJudmoP2BtJwuQN6vAIxjIJNC4f
         4C0YoQDJiVuBIhbcawgwtH1iTJHdn/j/5vyouEC0F76tFMwJ807V/iFP3KUPdBQRglDb
         CoLP51wx+njHLN85r3ZxTVukEmR/O7sI48fnKgXNRG1Gkh7valdBdlfp/tSxiL4uDz4K
         Q7TSCVcXxlmRHU5fZzvTDYzVTdcntVn+hcA3haPUdD8OVHTKZAVTaMi+yyNl7aoYDDDP
         +McMq9s3FGfUjsyi5jv2ocdMWMSkyfHvg6/GXerCioohDA5KSJIiB6kLfbR07tm81amS
         H8BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695019379; x=1695624179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNd4SPlO+Rpe4i36RjIqSfIzurzEIvdaKO8DkO9ug6s=;
        b=IptMcSmV6Pd8778+6Fa8Tsav8XGFuMW80gEQ6Sl0rHZWxXZUQpdJKouLtevXBbgTlP
         BS9BpnQb3ZEbRSbr7bvDV+HbOMdYdVs2KAmNtwmLphJQORZl3SVn6k9mxFt36I6zFJL0
         iWg69NMQbAvQ0zaVY0bOU0oCTkTgG741qeizQl8xVeAGkfPyMBoRc9dTfsLk7JDi+z7w
         7ZyLSBPKysEkKusa/S5pnPIfK5yBu1Iqlp1Nv9WDHAGER9lNhCe1FFJoaVWswP5t6XJl
         VVfPZVJCxJ1tDX/YjBuaAovDj1mdv+uSkWxDyXmPmr9FPrVNagfXwPYlFzXa59x2iHJF
         SsUQ==
X-Gm-Message-State: AOJu0YwyXnvJEk3c/xnQhoeFrn6QG7vfQCJB7JtgW/gpuwy8DPjQddQU
	DyHIOHoII8Eqfyfb1IET1gY=
X-Google-Smtp-Source: AGHT+IEnD5n3FcCcE7688chJ3+/GpYkXt9X70bgW58BVBwzVfAxeJj8nSoWzz0QMlhayEHfHna8QfA==
X-Received: by 2002:a17:902:e884:b0:1bb:2020:be0d with SMTP id w4-20020a170902e88400b001bb2020be0dmr10552787plg.14.1695019378648;
        Sun, 17 Sep 2023 23:42:58 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id d18-20020a170902ced200b001b895336435sm7640391plg.21.2023.09.17.23.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Sep 2023 23:42:57 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 6AC5F8AB1A5C; Mon, 18 Sep 2023 13:42:54 +0700 (WIB)
Date: Mon, 18 Sep 2023 13:42:53 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/219] 6.1.54-rc1 review
Message-ID: <ZQfxbToe2KuURGd9@debian.me>
References: <20230917191040.964416434@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3tVqIVmz1hZafmq2"
Content-Disposition: inline
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>


--3tVqIVmz1hZafmq2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 17, 2023 at 09:12:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.54 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--3tVqIVmz1hZafmq2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZQfxaQAKCRD2uYlJVVFO
o8ypAQC8WmtBiUnzg9BbfeFLVTUbsooSNmHtb4hTqNmivddaOwD+ILCB/IhjJKqn
60oZ7p3L9cMkuyTLsVZxw9NrfYtPYQ4=
=K4KD
-----END PGP SIGNATURE-----

--3tVqIVmz1hZafmq2--
