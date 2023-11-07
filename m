Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75C239C
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 05:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ENpyPomC"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6b89ab5ddb7so5602028b3a.0
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 21:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699333449; x=1699938249; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bz7iGOYk5qgRTgthykPiSTMHBpTMoBlt+4h9e44JHnA=;
        b=ENpyPomCTvviQqijEtDCt6zXp9WeG8UG39icyi7kPN8N8l/U9JJRUF/CEsrU+UXImV
         mmwD1YMuUhdo/Ld26rxYY6G1pQrEQg6TkETMwKdqW2S6AeFPeWox2sfQiEhBYErhJzez
         eGAM+kHmgjYg6eExEU/q9hj7p+rmVVeAS+X7ecGLtu2FBYUHP5gMb/w86YkUD+1BQdhr
         uvNLUpABB/J19SnKavuU7z+ydTt28vvAn3BproStWazrD1h9u6Btk3jXsFFphP5Y/W88
         l0DN8s/i8y+MesnbgqWuumMgixT1Dran4laJvI102KwQnXqiGHfBCBz3HTFebKiH+sXm
         LZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699333449; x=1699938249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bz7iGOYk5qgRTgthykPiSTMHBpTMoBlt+4h9e44JHnA=;
        b=rH3zA5Zl+1W0CWKrrRPtctFmoCewDpXVhJey+ZTpBDJUHKn4IJT11W+pC0xA/DxZXg
         LECY0qTee9zOaqPlPHiYFN6+8RHEgBrAPiEvPPxbsw8CTjvDt/LZx5DciYxlzZBZcOq3
         6uuPrweSPfTN5BOU5yzfTPbVeviCXF+aEV4DbWsxGRmfemOCfY53JdPur3xdwd799mK5
         Z+SAdYULYQ4q8KMXoC0nb7zvh/pQJTxw9dnCLGcN7HuKJ9NBJoGmnXld3UPvYv1+N3Ok
         6MTI3Q3XinmakL9lnmYU0Jy0r8n+OlXZKeohYkdCL0L9pB4W+upcHBMeMEk1kMXdfpHo
         8xkA==
X-Gm-Message-State: AOJu0YzdfzhDmDyPIHFDgY5YMFWr/TtvmQmLAorY2dSSXfg0dmsk3A7R
	AwQ1idvT3aknHpmop17+tGE=
X-Google-Smtp-Source: AGHT+IHq5rnCKDl+KFwkF0Y9L+OEede5/mV+cWlrWqRhXEUDPuut3SHzrOT6r7PkwP3AoPsQ5+LNaQ==
X-Received: by 2002:a05:6a00:98b:b0:6be:265:1bf7 with SMTP id u11-20020a056a00098b00b006be02651bf7mr39794442pfg.34.1699333448912;
        Mon, 06 Nov 2023 21:04:08 -0800 (PST)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id t20-20020aa79394000000b006c0fdc98c89sm6335346pfe.85.2023.11.06.21.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 21:04:08 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 213E9812C341; Tue,  7 Nov 2023 12:04:03 +0700 (WIB)
Date: Tue, 7 Nov 2023 12:04:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.6 00/30] 6.6.1-rc1 review
Message-ID: <ZUnFQ2New-VTnkmp@debian.me>
References: <20231106130257.903265688@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LszhaNktL2TxPxAr"
Content-Disposition: inline
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>


--LszhaNktL2TxPxAr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 06, 2023 at 02:03:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--LszhaNktL2TxPxAr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZUnFPgAKCRD2uYlJVVFO
oyO8AQDXwlHwd9TsiXYqEZdXDU8pzWkIZgYug/FxILaxm0EZmwEAkMMTMf8Ql8nY
9ov4qPCQhVdErQMM0gL67N9kug203QA=
=AfLt
-----END PGP SIGNATURE-----

--LszhaNktL2TxPxAr--
