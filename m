Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDF817FE
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 04:02:25 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso452846pjb.1
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 20:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GxJ6ul68u180AtVN4nQh0WHt0yT7zOpzV9hXJDFZMLo=;
        b=Tp59IgO4ZGd1EihgNcau2gKogXQ+6GvDlxMqYMW6uaCDyCqkgmIOPg04qqA5yDfCeJ
         DC1iS8xYnpFw0K/KI8BFQ7uH1Y0DR0nA1ja7fbxcbxo+ElkH0ZjOpTH9HF+yGUVMc2m3
         /QSNKGtyAmCqlPPAbmAPNY85Kq9k6YpTk5m894ejrUECIJ2KznKqFsrAENx9QGNPyEJj
         dK3wLzq1dr+q+GVLy9SwJZ5PWktISYaOyFxK8tsRnXI8aUu9251YqWttxASqUQfSh3QT
         a198z8ad/vCPDzt52am082DPuLVGIi9lD0/qxXiPuxTgw+bV2yC4WA3jKkf2J+gxMdoN
         zJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxJ6ul68u180AtVN4nQh0WHt0yT7zOpzV9hXJDFZMLo=;
        b=IQKy1hcM9s7isDFwNv91U7g9TBtYNxA2E2rB77WaVctttO3xNb0wGdzEK+w+S1t5Hc
         v2k/Q6oOqHIjXOUueBnyY9rp2eWutiswJVPDDm2U6dAwzAvGyfQ5eBOyUgyaKKsqnj2/
         c42UIqeExW6DmbSeNwBwQg1jewg14ktVrDbwfuQ4f2tXnECS/awO6aBcRva4a14b5uih
         LVR6vYwvV2Sf2UdCZ5KUuwyN9JO/eCxnYfVrcU2Q9Sk0/SeSy9z4LujBhgpul7Nhnm3i
         /K7ZQwSj9tMt1T5iRfuUAnsu1pKkoAfrar0y+1vxDYHboRhDyGjROlW/+OaztIe2ZRz9
         EWeQ==
X-Gm-Message-State: ANoB5plvyl6snJIPgquGT02mIrZZd0oQC7JTbGTH2ICKEj1VRo5mAKT7
	nAez18NuW+/pYwBSRNqdU4o=
X-Google-Smtp-Source: AA0mqf4ehpTHzhprPT5QWnH2VhKKXF2yIO5dSxMYnVq8qYo5Bmv8np+h62HZzf245xRpCtDmLxgTag==
X-Received: by 2002:a17:90a:b390:b0:219:68f8:7aad with SMTP id e16-20020a17090ab39000b0021968f87aadmr13117425pjr.34.1670299345519;
        Mon, 05 Dec 2022 20:02:25 -0800 (PST)
Received: from debian.me (subs02-180-214-232-2.three.co.id. [180.214.232.2])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090322c600b00188f8badbcdsm5825822plg.137.2022.12.05.20.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 20:02:24 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id B4EFB104011; Tue,  6 Dec 2022 11:02:21 +0700 (WIB)
Date: Tue, 6 Dec 2022 11:02:21 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/120] 5.15.82-rc1 review
Message-ID: <Y46+zXhrp3LY0cuA@debian.me>
References: <20221205190806.528972574@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2tKqQ4RZLc+GC7Hr"
Content-Disposition: inline
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>


--2tKqQ4RZLc+GC7Hr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 08:09:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--2tKqQ4RZLc+GC7Hr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY46+xgAKCRD2uYlJVVFO
oxqbAPwMTSRGCfPvqvWwCe1OiuvnlisHnp2D1teuZLaHOvzTBQEA63snzrTGh0pB
gfsZ0xaZh7DyWXXNDjwyNfKX441t8QI=
=NAxP
-----END PGP SIGNATURE-----

--2tKqQ4RZLc+GC7Hr--
