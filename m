Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2799153A4
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 06:31:32 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1b89cfb4571so20226615ad.3
        for <patches@lists.linux.dev>; Fri, 21 Jul 2023 23:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690007492; x=1690612292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u3T1qR5/9IftMNC5B8jJoRjriuTCdAGCj7hIGax2Amw=;
        b=EqFGIhozE9teh9TN5iH6X6TzKJ4oZ0hTf/dDzMtiky+hFXsJgYc1mhfTzt9PKfCaZS
         2zJdxPWXGkGjPUAWZt1kEMO9phcC9fWYoT/Jv4KxGyQWzjxJPc9uS+bZapUjzlYSxMPn
         3orL6f4q1/nLIpvxjGR9ZdbVEeToF0Kfy1prqtKFjjofhOk8A8aZw5XukeWVliWKAZbI
         XVkUr6jzj5Rr2mUr9n7l1Z9PWIF+bRBLytVUtrIsZ8mRu4TPt4PP+c8YnS9CCEHUYcDr
         bjYwXEfIMamYYSO0m5hGw6uvsC2se4vujmHFzvCRCK9RdmV3zUl09ELMR/cs9X4Mf+xD
         BhkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690007492; x=1690612292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3T1qR5/9IftMNC5B8jJoRjriuTCdAGCj7hIGax2Amw=;
        b=L53xpTcOYLRbz83Kod9TPS5bG1dVqH1p1dLkXMhWHwaS1oy472Y3YOoC3ZzqV6rqQJ
         k/MVnvmcnn3jdMVHMSoFGpQsVky+Kncg+NSyjesp1DaqVRjGnPjDT5vRAkoJgBHAczxv
         MiS6Bd0vlpiA9gyP8UMWnKP9JjnRxEV1mEW4i0M4LAng81w2G9aGcBGOOjSjqC8RFR5x
         sKX2S/wLxG/E3WVkrAPRvNNK2uN5OhSE3PMrpPhNHJSJV3GiEdbC2vHceSKdjnRK/wQN
         l5M2xJ9qsHRzVIHSYeUhfBxxcpZaQNFk3AQ4k2Pvt5xXS+HZFCmVvMjjIJCmdyY+DYlD
         6Tvg==
X-Gm-Message-State: ABy/qLbQjnKYq07d89Zk6LCubkjF9EfDxk6e+G+kEsLdoCzAmPHwKaXn
	AB+R64IhIpie9rXsNgrL3Vw=
X-Google-Smtp-Source: APBJJlHr7QE52ewLl91MsnSiJjyMR6u/tupCXO4UdMKEBFzC834T1Wtn0w+p0XH79PrMfmEWaxkrYA==
X-Received: by 2002:a17:902:c103:b0:1b2:1a79:147d with SMTP id 3-20020a170902c10300b001b21a79147dmr3984466pli.2.1690007492331;
        Fri, 21 Jul 2023 23:31:32 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902ea8300b001b9f75c8c4dsm4557175plb.52.2023.07.21.23.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 23:31:31 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 65F8B80DC103; Sat, 22 Jul 2023 13:31:28 +0700 (WIB)
Date: Sat, 22 Jul 2023 13:31:28 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/223] 6.1.40-rc1 review
Message-ID: <ZLt3wBUZ5T1DLpKV@debian.me>
References: <20230721160520.865493356@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LGfxab+G4lQ8Fy9e"
Content-Disposition: inline
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>


--LGfxab+G4lQ8Fy9e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 21, 2023 at 06:04:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.40 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--LGfxab+G4lQ8Fy9e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZLt3uwAKCRD2uYlJVVFO
o7qTAQCDXYf21SGNsQu/vhxjWiGFMyPPt3M3FI/baXA24TXyYgEAvPLBvjIA6uMW
88unznZFdEJzwReRfF8lQ7wwFxqAEgY=
=mMwO
-----END PGP SIGNATURE-----

--LGfxab+G4lQ8Fy9e--
