Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12037E6
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 04:07:18 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id x24-20020a17090ab01800b00229f43b506fso9124576pjq.5
        for <patches@lists.linux.dev>; Sun, 22 Jan 2023 20:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k8xywsS+eg2CC8w8NCTeeilE0iYUibYUDt/SRX3plv8=;
        b=CqZ5PcNsFYfskx+qh+UHmYSxgv+V9rc4FNXeaGDkSbwFEgLHpyk3Oj8dYnQhZSLcmg
         aICPnawfa0rB8DR47WtZdq+1xWlc4EifO1aowr6S+vBQL1WiTCj0P5h/S0zCRWrtn47m
         p/SX13SM6MPKtZdCboX9RwwXLE/LDWJBzDYBhj/2o+dwJBkLSS2Kz/LJiAGn1yFPSAhU
         A+Ycm3HTTWv52kS30z8luf7U/P3xevPcWHCoqHFjVtp+ZXirH4Rl/zVHnVaIAIzKnypM
         470Zd9ZUsx1BPknxNP86CIspLAm/uHCXNAdEBCwNJSNwGp0rhTeVRN7SGjNwLT/nPbnu
         PuOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8xywsS+eg2CC8w8NCTeeilE0iYUibYUDt/SRX3plv8=;
        b=ZiZJYmGKn8k72n5qw/qQ2GsubOKd6ULmhbjyWmIigcFGQgy6WDOQz4xCaT6xS4/hzw
         nYN+ZKo1NujjPMjUqGyydHRPHijsJK/HyUvEQ6cc0/y1lqtVXO3NleAWOe+Rdxb3DorU
         Xgo7EO1HrsANihAQY46oloajXnARupslb443tFC3Z9VmFcdNi+HMocnz5Pfq1QEzRPQq
         iWJFGQaHQoZZbo/ZECbwNN/9BU1pa32Vev4LCi4iPTY8qBJ9Gy9rXPS9XKhz2caRClOi
         8ZtXMMP/eejtP7umyawafsxM+As3xjBQNBXi+f1puABe8vWbigT6uAxz10c8fmpEKba5
         /CEg==
X-Gm-Message-State: AFqh2kpc1J+lqBIc7ZEh+7ZCeqgh9m9jwcfXT+hur6LdqWl4A4nwpZ/j
	l6Rr7N80H/VqOgfiE7DSVEA=
X-Google-Smtp-Source: AMrXdXsMa3OpdkJGGDGBrvwjgpwVsNwtYXcXI9FV343NkCx7shiCd//ZicGYZC293i00jL5mMB7Wzw==
X-Received: by 2002:a05:6a21:170f:b0:af:9dda:b033 with SMTP id nv15-20020a056a21170f00b000af9ddab033mr24229003pzb.37.1674446838266;
        Sun, 22 Jan 2023 20:07:18 -0800 (PST)
Received: from debian.me (subs03-180-214-233-76.three.co.id. [180.214.233.76])
        by smtp.gmail.com with ESMTPSA id s1-20020a63f041000000b004784cdc196dsm26175346pgj.24.2023.01.22.20.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 20:07:17 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id B02AB104299; Mon, 23 Jan 2023 11:07:13 +0700 (WIB)
Date: Mon, 23 Jan 2023 11:07:13 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc1 review
Message-ID: <Y84H8WbMg8gg02U8@debian.me>
References: <20230122150232.736358800@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L4E1Xd5t6VzTwN26"
Content-Disposition: inline
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>


--L4E1Xd5t6VzTwN26
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 22, 2023 at 04:03:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20

--=20
An old man doll... just what I always wanted! - Clara

--L4E1Xd5t6VzTwN26
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY84H7QAKCRD2uYlJVVFO
o75EAQD+9vyYbqVa5gboq5KZOI04RVCWaLprw6Xs6gMhwUFGiAEArLBgQHYJDmn3
WbZX78uhMAhO6NaT/TrvPSWiu17kUQk=
=Wo+s
-----END PGP SIGNATURE-----

--L4E1Xd5t6VzTwN26--
