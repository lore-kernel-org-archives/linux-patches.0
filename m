Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204F98483
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 07:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MJYRMNyH"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6cda22140f2so1765880b3a.1
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 23:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701416727; x=1702021527; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eDJ4cB9b17D60NS3i4W24KM6eOnW8/ANZmRWtkw6NI4=;
        b=MJYRMNyHfzBrX82GZZimxWAlvNfMCx1Q0CsYGZNU9pitEHeJqL3EH9b2amwxg9RqdW
         IAbdmFc7mx5GdlYIavxHfE63y/+LwT5e0c8p8U0/gIv4P6YrSh7wsZgZww0RjjO9wlv5
         GegJZnBlA4cOlyTu5GorgUZGkEVUZrTpljpRNQp2GTTHEUzjdXMNuJ2ZI7YS/JG2Ze75
         Z35Bo+3lMqkwXmEk/ctBFxi+zCKwDzRaoTs+NybsJaI/Q31yDHF+dWDcx8bfGhblRhkr
         QYP2Cpg9PkjHFrOWJ9phOgEfmQvXfDqOxKWs2d5+eSJTn2iwn6s2cqIGXTfYH5Q6GhU2
         Kotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701416727; x=1702021527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eDJ4cB9b17D60NS3i4W24KM6eOnW8/ANZmRWtkw6NI4=;
        b=TIQa8I4zGIPpOUduuz6kjd2KzVtw/EtCPFxz0jOhrw+FsxrRU6ry0Nm4fSdcyhVdeA
         mux0yEtnegYxrVcPaxy1cWvM30hTO7YVvEhU+J2SlpbtZFitm7gWwcLzPUr9KaAjWWTR
         k/koQUNFGXhP84b2faElcFCtWORTXIPnYRldMOEq/sVfvG3D4oAaioYoiJcOzo5bzxv9
         y3H9LyWNpgDqDOHWYnCwnkcpY0qyLr2VLJzcAfw8PBs0ARv4ys1WNAkKkNA8wVqDiJFE
         EpzW9TFQT7ht1mtb4zo8aC4SJwkwB1EO2pS/e13VF+WsVg49C0qEVYCKR3iwCZHFvJ0I
         BrWQ==
X-Gm-Message-State: AOJu0YwiSMpT/tXC58yXLsGnVu1gzI6GVRlf9XUO1lJGUcGLYTgDmJ6X
	kYhbH0K9F3O88TQbccXw/pQ=
X-Google-Smtp-Source: AGHT+IFzYSkI8g/hbiFO96VkccVdtebsdaqn9YOdotDchDlagBAc5iGbhChWPyZ0ScJ/ymgv0CghGA==
X-Received: by 2002:a05:6a00:3922:b0:6cb:4c84:43ce with SMTP id fh34-20020a056a00392200b006cb4c8443cemr29233633pfb.34.1701416727398;
        Thu, 30 Nov 2023 23:45:27 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id gx9-20020a056a001e0900b006cdc6b9f0ecsm2378778pfb.81.2023.11.30.23.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 23:45:27 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 313BE10D3BE13; Fri,  1 Dec 2023 14:45:24 +0700 (WIB)
Date: Fri, 1 Dec 2023 14:45:23 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/112] 6.6.4-rc1 review
Message-ID: <ZWmPE5aEdrJTQrNy@archie.me>
References: <20231130162140.298098091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/neyvsSfP2VfL6Q6"
Content-Disposition: inline
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>


--/neyvsSfP2VfL6Q6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30, 2023 at 04:20:47PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.4 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--/neyvsSfP2VfL6Q6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZWmPEAAKCRD2uYlJVVFO
o+owAQDwWzG48MrAscfg1mDx+CaRxpbqUpZ2sueC8CRF3w/DdwD/S/demZYjR7g2
nXain6YspAMuXtXPHEVdkFfYlCq2nwA=
=MgtW
-----END PGP SIGNATURE-----

--/neyvsSfP2VfL6Q6--
