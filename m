Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28031FC1
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 04:03:26 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id v28so12960432pfi.12
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 20:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GoWm2EdL+TQl8bZ+MoYQChqW5ie4nDjRul4QKUbGfwA=;
        b=dM8I1K+wrRsiJrsPXPY4Qie4yb1A/NRgY+eDJuI2Rj9iESmjGSu0rcCWmk39jLR1cH
         onLUVqyQy1DJHRchqeK3BVqizHDdyfqj0g2E+uV86sjZhZ/O7vV0Uwja7Y/A68V0RCmX
         +MqeC69tiJzRVtidovfVkJjLcl0tPlY2eQ1gJgR05n+V00LeRBCMyh3d6LQgFXoKqEaR
         wup8d/mXrI1b/OZV9VAmhZm7mD0sfyI834qjuzw1cFN7JCtaY423aNVaQGllKJeM5WX4
         zbgeIkH9S8DUFSWJTFqaLzf3LgxSikUNqgUzjRB61Ull5RLW7lkGHEliPU045fhBPrhM
         S+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GoWm2EdL+TQl8bZ+MoYQChqW5ie4nDjRul4QKUbGfwA=;
        b=13/xh6F4zBjaUXnJaqJzwESbj6+8m23O7ZvMEeI57y6hladSNgKfelrQPCOVXFN39a
         kYfQ/uCfm/uarSyaf/7tj+CHZjPmvZwPLudjGanR8/puYx8AqDU7eXNlavVjMp4fSK6k
         564vSxnrL78sIdj8ax6f2Dca6fi+EAYugdgf7f/sEAuUwhlwwZHxR79HzZL1cKi/w73B
         +v4OhVe7RMCP1QTgC9Xy3w7yIlaQr8SiC5/NsSpe1iJWgK4C80hB7nQLZ791SMCOOz75
         mnky/RmDd2NT7rwoDMgQycAmJh3SLlZgx1Pl3ZYMLUlrNJl/+8TxKcjx090nsrGJm9fr
         aZgg==
X-Gm-Message-State: ANoB5pkaEw7Nh4D4q4jp4CqxYBYiz9+QW5qMQRA656n2ShyjndNqtr7d
	CIMc5WCF0bbyp8NKweAlz2U=
X-Google-Smtp-Source: AA0mqf44Glgbhn2WxXWq01Rmje5hs8FjriQ6qANXEQ1/KNd/RuA/XvXdHou43PoMriDGQsAAfF7IxQ==
X-Received: by 2002:aa7:880d:0:b0:56b:676e:1815 with SMTP id c13-20020aa7880d000000b0056b676e1815mr16648342pfo.66.1668485006204;
        Mon, 14 Nov 2022 20:03:26 -0800 (PST)
Received: from debian.me (subs02-180-214-232-1.three.co.id. [180.214.232.1])
        by smtp.gmail.com with ESMTPSA id p129-20020a622987000000b0056bbebbcafbsm7531886pfp.100.2022.11.14.20.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 20:03:25 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 99128103ED3; Tue, 15 Nov 2022 11:03:21 +0700 (WIB)
Date: Tue, 15 Nov 2022 11:03:21 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Message-ID: <Y3MPiUq+LsK+ZKeS@debian.me>
References: <20221114124448.729235104@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4/gGV5htVI8CkM8Q"
Content-Disposition: inline
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>


--4/gGV5htVI8CkM8Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2022 at 01:44:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--4/gGV5htVI8CkM8Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY3MPgQAKCRD2uYlJVVFO
o/86AQCc7Mh4bY/9P9W4Z8Fsjson44fgR6zGH/jHAj6/bBb8AQD+Jh0i5svghviq
NeqxklNBmlOAvOEsdrU1T4I/ABXvhQs=
=5Cfq
-----END PGP SIGNATURE-----

--4/gGV5htVI8CkM8Q--
