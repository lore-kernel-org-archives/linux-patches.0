Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA2617D0
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 05:50:19 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-26b41112708so4078609a91.3
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 22:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694497819; x=1695102619; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lazraD+tS7ehDHAyJoob9HogFn5ADIMObxGHBTJXXNI=;
        b=gvN5qO2FAjryDoMa93z45Kun8XAQcsOeebxntnSEdML1iCstQxlWUBZfrPjFvdJhor
         DXZ98mdvq2cimQkJQM4jSTnXNvWuGvV/yC4TnLjmViAUCnxIzpN4GoLJiE96Uc6768lI
         3LUv4rVtJsgYdr7ZGLb7YIg/g1fkQHPYX007zymRtBZNXVKEw12UR8qc78HMIfKwPabF
         202NfnNSXWI8/0xOPbMUrhTyEisoq123eFd2cT0FVo8yI4hMmFnJuwzacvCMNPL+ZQyi
         yffqnWkweJyWDTZIuzJl/7M3zVGxmQN2trvh2/9bXzVq0ETIV/emTnvq3S31DQk8lMF6
         4pSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694497819; x=1695102619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lazraD+tS7ehDHAyJoob9HogFn5ADIMObxGHBTJXXNI=;
        b=GVqxsfwYnkg6xy0ajPmhF7muTyYcPpxhLPVw1bRi74sefcwPJzgNNHfWbJZmMZ7ytC
         fxvxKDt1xzrXoTaIk1EznsQ3cOR1XtesdJvf5VnSONEe3vqn9XRkZRFbOsTya6nUOcA8
         21kj9i1yq5hh4yRKoaYneMQTwGwPSa2NOMOLttIpQ5+VtaTpnXhr67qIZ1ZbnvSpmQLt
         6433GrWIwRgnAPy+wpvCzJ2EWQkjd0ab/0XxcFnsahmZtc9M60z64ycGhFsBFHN03my3
         jorx0pfcFz9jioP5a9PheGgmfPVrgsEi2SE/F6eiLyRgrhk4upUYGMJRm5OVZOR1n/G/
         eqmw==
X-Gm-Message-State: AOJu0Yw4mU916rM5oTI/tSITdmdiEuWgrTSL7flqeHOR4IagQHn0yJB9
	smTEKCqvch8n88u8tTPfqmE=
X-Google-Smtp-Source: AGHT+IGNyfu3X+on74pMWLtm5ccnS7n0Z/2Dj0UAtyK0cisVt9CeCJ52wwVu7J8/evI8AxeX9DqqCA==
X-Received: by 2002:a17:90a:d157:b0:263:72fe:3ef7 with SMTP id t23-20020a17090ad15700b0026372fe3ef7mr9979941pjw.42.1694497818911;
        Mon, 11 Sep 2023 22:50:18 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id j4-20020a17090a588400b0026b3773043dsm6572037pji.22.2023.09.11.22.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 22:50:18 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id C5B0D8A839D9; Tue, 12 Sep 2023 12:50:14 +0700 (WIB)
Date: Tue, 12 Sep 2023 12:50:14 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
Message-ID: <ZP_8FkCGeAhFt97O@debian.me>
References: <20230911134633.619970489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bjTnUSYMRdXEbQd8"
Content-Disposition: inline
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>


--bjTnUSYMRdXEbQd8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2023 at 03:40:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.53 release.
> There are 600 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--bjTnUSYMRdXEbQd8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZP/8EQAKCRD2uYlJVVFO
o6+CAP9aTBAEIAs4k8JD9uCAyW7E2bhHWIRRajW/ejoPanvNxAEA0F4HkWdP/Z3V
sQDsFyQkqNUW7vkxogbt72ELQpmoAQg=
=OEsR
-----END PGP SIGNATURE-----

--bjTnUSYMRdXEbQd8--
