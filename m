Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433CC7E
	for <patches@lists.linux.dev>; Sat, 31 Dec 2022 03:48:11 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id gv5-20020a17090b11c500b00223f01c73c3so21546799pjb.0
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 19:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Spjm14Do/Jp5yV7SFep7Vpr7Viq6o6tOkiCvcqVQTjM=;
        b=U9eQxnBx0aalJbgTHWjBiAcAJeeOd7F59KOJa+fCZM8+o0pNgJ48IHR20zw7pZiMQI
         i+/33fFHYFjP4mHb8gc2wMFW76o0qfWpL+HkfWBa2lpx+k7kxTKAeiwtUkGwS/+DebaK
         rTeSp9Q5SCFKgXX2HlCOrSGgYbjQ59NoxFiQlIelHVc3CDk7tK/75jSOTk4mVm2OnpnL
         wazZi/KIIbM+mZDyHAVUQ3A4LoZ9olYO/602LfwqggdHgJEcrogOWbxl3t5WO3JUTibB
         ntEnQJWze10k4KjNxlkJJ44XTcveVVGuHFxob4i+bSMSs6BrvGFiPEEmI+lRoUjPGcgs
         xlWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Spjm14Do/Jp5yV7SFep7Vpr7Viq6o6tOkiCvcqVQTjM=;
        b=Mo0Zj32IAt/aikHCKMHLtEPDk1CN/3nqFqubR0rKac+Lq5wwSLzj8iWebRkihNHofD
         8k215hLafRg0MqkRH9/0lTy+lacWKtYhT08DjVOvWb3pXgqxEcuRRqHkj67tJPP6PxTJ
         xgpizdcEpQs7A0NAS+GNpa6/8VqwwG9kgbkSxJXpvqtpydVAd7fMA9funX89iOabGRqg
         BmiVRMyszcpTLCENSNtp6GyfQ1ZVyyXXi3Mrh3jbdaxSH6inHZ9EpQYzX9dSEmPHXI7l
         eb4x/bfX9vo2V3NWa3RaCyTSk3MpJOtdgszottQG0ZYVGv1TSBGCRdyg8LxS3WnANl3s
         JD0g==
X-Gm-Message-State: AFqh2kq3Ny50UlBzaU+LSsybVGR8VKgrZOKS1J4CCPDAqMt3RL5d6sU+
	jX1b7fD8RY1NJApafs1rxNE=
X-Google-Smtp-Source: AMrXdXtPiEuwumaS5Bvm2Lw0FFyCy7tWSwCvwiSWT9zvvr5FGh+TdVX19EPByy/vFRPx4ylaKUKBPg==
X-Received: by 2002:a05:6a20:c745:b0:9d:efc0:85 with SMTP id hj5-20020a056a20c74500b0009defc00085mr34127819pzb.45.1672458490783;
        Fri, 30 Dec 2022 19:48:10 -0800 (PST)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00000400b005821c109cebsm712143pfk.199.2022.12.30.19.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 19:48:08 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id B7CE5104465; Sat, 31 Dec 2022 10:48:06 +0700 (WIB)
Date: Sat, 31 Dec 2022 10:48:06 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc2 review
Message-ID: <Y6+w9gYWpk/TXYC8@debian.me>
References: <20221230094021.575121238@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xHUjXrYOrP0biQR9"
Content-Disposition: inline
In-Reply-To: <20221230094021.575121238@linuxfoundation.org>


--xHUjXrYOrP0biQR9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 30, 2022 at 10:49:11AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--xHUjXrYOrP0biQR9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6+w9gAKCRD2uYlJVVFO
o2reAQD2kNB/IbQ1m4FsMqibHCMZ3/hbH+ZeMLy4MbDEKtZ1XgEAtovRBnwjLq9o
CjUQ4hvGJHbPtKafn8jS4C2SSL/OwQc=
=H2bP
-----END PGP SIGNATURE-----

--xHUjXrYOrP0biQR9--
