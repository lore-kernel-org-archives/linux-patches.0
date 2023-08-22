Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC7C7F
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 03:00:40 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-68a42d06d02so1186079b3a.0
        for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692673240; x=1693278040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V9rfUX1u4J49X94MB9ALqEh64ViMp1rzQu7h3fdjufc=;
        b=WbUmxXtLHsBzeFfjTvBbxz+tAqRHcV3W+q1fGCn04MOP2oOH7gu8NXS9fm5m0rctFH
         55MwZP2fB3apWah2GE0IhbmmaqdhoU3s9CGH4bgN7XSp1tGMG8wiwZ6E6xmGjDSDaJNB
         ovmsCyAvbQpCwrkeR+sMZvXnfmsuqsawvc/h4lLpYTNnmgF/KtN8ualZfvZMj3U6SSgn
         7wY1CckLUMd1cngGqfvBmP1c6HRv3ybLZlFNfnt/bASraLPB1kde5/0+0t25R5uLTxZT
         8Bm9jidqTEEMiVNO07Ka1/rFQnSsCI8L6XwoOtCeSJaJ+uPkcUJdWwNn3YdpssvbQKSA
         efpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692673240; x=1693278040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9rfUX1u4J49X94MB9ALqEh64ViMp1rzQu7h3fdjufc=;
        b=VMTT4x82OeoIt4zEzpHmWDbY0kp7Bf4P7s2hp8fg3cFTSRGk4ZGhKMVP27gzYNaMXq
         30v3VwoTM92FuASBMsbd596I3Z0UgF9WN+VEl3RUelN58UgFlt4JQx/3D3NeruU5Z+wx
         s8NbBXwuV9MIi/IcrLHhfNEW64uF4cckMC9oxRkODHCkKW+NOdEM+Opf93kdbTdwTz3P
         OLlvoZgSpFl242/e9hDNTOLf2RwG1DjdNUZ+DcxTIXHQcyTX1R4EKXDW9tsUigshbDTm
         iobtb6UilMmAyeD9Nv9h76Ho6uQhQZRePvk1Pnn3NcZ8ObhmT3MKdtYO8kK6I2R7Prsi
         NsXA==
X-Gm-Message-State: AOJu0YwTFv8+m9SGEBr3b2Klvcw9sDdcYCD4kl6Sf1YMVFb2uhbPdldy
	WfuPzhsSZOnqAk+l/S3ey58=
X-Google-Smtp-Source: AGHT+IEPUEaprDP/xtAgTBz3MFCvIwylRxhHji6XmYEcLC6SQBDdoIrJaM7ZgaMiruQBpHNqzWlcgA==
X-Received: by 2002:a05:6a20:7488:b0:133:7ad8:712b with SMTP id p8-20020a056a20748800b001337ad8712bmr7912837pzd.52.1692673239808;
        Mon, 21 Aug 2023 20:00:39 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id c15-20020a170903234f00b001b9be3b94d3sm7744501plh.140.2023.08.21.20.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 20:00:39 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 5CFF080696E1; Tue, 22 Aug 2023 10:00:37 +0700 (WIB)
Date: Tue, 22 Aug 2023 10:00:37 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <ZOQk1ethQ8mDedes@debian.me>
References: <20230821194122.695845670@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7uBiktEJ0pmNpR/L"
Content-Disposition: inline
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>


--7uBiktEJ0pmNpR/L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 21, 2023 at 09:39:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.47 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--7uBiktEJ0pmNpR/L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZOQk0AAKCRD2uYlJVVFO
ozXzAQCZI/bgzdBJ0CLOqilgxE+g8kjNqp1WL/59lwKhjPBzsQD/Xz4v+bTAUVZs
Tbg8aSt0obkISjlRGk5Oiupi++u5aA4=
=C27w
-----END PGP SIGNATURE-----

--7uBiktEJ0pmNpR/L--
