Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED5917EF
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 04:09:31 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1c465d59719so4078705ad.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 21:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695269371; x=1695874171; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v41ItM9EXYIC22XbO3MBvIrVnukFuETmf/6WBr3dSG8=;
        b=mm5+BR7WjU+IuaF1iwQJSrW6UonJAPmweBV30k5xZ1brETQwt6hN619VnP8xlwQdbr
         crcOOOKAB/csuh1xVzEwIx1nTuJ5JChzFce3/RvAIZyVwjeyMu4RW93g1SApDcLPEJc9
         DahC+x7ZBRlMG8WaJXgJNVs9s8LrS4foyNp6HmOqOBEJflPcOXl+/5vxuYOEVfKLD4EX
         xdJfwWAzBZcTU0DdfeYLAlltc50WEr7m/t9USvMzm0GLwVFJmN1i2C9zAfZRLJfUaSLJ
         pZE/OMe7PZi+aokfzAzdwowQFATZdNPzpkvDVzO/EYSQPIzPEuV95GMs6i0PS5QVpcBd
         NgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695269371; x=1695874171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v41ItM9EXYIC22XbO3MBvIrVnukFuETmf/6WBr3dSG8=;
        b=ndKgiuTSpr0TixWs7GNc2O5W/nsKBM0cC9sRKf5I8Hdju5FpHGsb/itAWMyQm8dw9c
         GApUuepWpaI4DbQ5bxCJkqNuRaZLx8p2Hc0dPyvID9wLoAx75MDMCkrY2b15N5Yj7hmG
         n9WiP6yIAAjlHHR4Dc87GvsCyOV+FbeWFF8bUHbyxGo5C/w+f9u3OCXt94j8RnP7Ts4M
         upaNJUvoo1bqnhzWir5RITmSKc+qEzw3SCrF0wWlTPBVM1LoXFVQtvyb0aTz3mGK4gox
         SGl3kQBjy6Pak8yXY5CEUwym8Q/sbDstjMQ6KYsrRB66MMl95CPZQTMOEixAvhkxPc/m
         Sazw==
X-Gm-Message-State: AOJu0YwFCgZacQ1fnIZi/rRbENFATjlul06+/jAl6Abeey8KHDXWVDpJ
	F95KlQgwEfHyyigSQzQmW4c=
X-Google-Smtp-Source: AGHT+IGVmo/gftbdfuKH0B4o/qNKwTfwk4yyKQsxA9zdx8SBcpiPCk4TsmV5HrGlycHJiYo39qaa7Q==
X-Received: by 2002:a17:902:c404:b0:1c3:9bce:817 with SMTP id k4-20020a170902c40400b001c39bce0817mr4695608plk.3.1695269370868;
        Wed, 20 Sep 2023 21:09:30 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id x18-20020a170902ec9200b001c1f0b3e900sm289499plg.229.2023.09.20.21.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 21:09:30 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 3B8CD8134683; Thu, 21 Sep 2023 11:09:26 +0700 (WIB)
Date: Thu, 21 Sep 2023 11:09:26 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/211] 6.5.5-rc1 review
Message-ID: <ZQvB9k_JLsHZDAq1@debian.me>
References: <20230920112845.859868994@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="APCRpmKMn0NWwniv"
Content-Disposition: inline
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>


--APCRpmKMn0NWwniv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 20, 2023 at 01:27:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.5 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--APCRpmKMn0NWwniv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZQvB8gAKCRD2uYlJVVFO
o6w2AQCP+cIumMniBqwRP72EIDzFpHxMIAZp64z62tWTCeh7RAEAuxe5UyRxFD7O
OPKv7P6Ms/7jA4JxhI0LsY9hJA2AAAg=
=bQtx
-----END PGP SIGNATURE-----

--APCRpmKMn0NWwniv--
