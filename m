Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2547808
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 09:56:38 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id g9so9845461pfo.5
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 01:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mAG+k+EM9JkIYL1WfEIXL60CRFCPCxMe05v1tWhRHbs=;
        b=gbhcQJICzNy+y0TBEkg+jH1Fbj3OAZISlHgJxr+fsVKZzZjNPa0c5Dwz0BUWFquCYI
         gTXoA1kmd9zHqeA7QITDGGzr7Ev2gnj8T4+FUumu6MMSjRIiKBxKt0UcCRs92QYjSYHO
         Jg/unICC2L+Zw/8Tib7C2sqPa0BkqqZ6J8p3HBXwcosIhMSEtB3gyniBHW96mBuEksL4
         akqbATdiCGqUnO0xbPaPYkVZJjG14Nlf94KczPlPotWiw2afxx9ixQEfbi3SsqPsb7nK
         mFBJuHLoSkdVbMUxsHmy4xNJYxLZtZV6j18cceiroZS/TwEdQU/J7o89x2gSTeFa9Y5h
         qAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mAG+k+EM9JkIYL1WfEIXL60CRFCPCxMe05v1tWhRHbs=;
        b=ea0hVViKjgqe3qL+UUgzrlHVimFYoW4NKCO6ij0TBV2r/EJxsE3Or9JL/maA2WKp4m
         Zsk4CWx9t3Tzu0FEsMy/MWRMSl29GV+twrW+P3AvAPNBtBIIxhafxej0Qyna3uq5yzhC
         bvpUcdYXPeCigONsHWt+twDettbmXr/0qKwzYPY8rGycubkYXJQ3qKJxx60/8oczlbJM
         Pp21kbE1ejqk+teTXvhiVte9kR91FXapLG3irXK4CELERGj9jbfm4Xe7FKafiZMEt/YL
         gJVDxzXjkOd3eQXpAHwy0tTwWnv8IhBZecMVJu+uczlSEZWoF3uImDyJf9tCiR12llNv
         5Zsw==
X-Gm-Message-State: AO0yUKVu3g00WaoPUpItIESc8cCOzTz5DK4FRdZlQvTSvcyb1ooS+r3u
	9xc+e5iiCBFceDFbs7j/L2U=
X-Google-Smtp-Source: AK7set/dCnJLhEg5+mzUII0vPsK8TBoi7aEsdSuHF9fjQPfhos6FdM+QoNJzuLkAsWM0e+h6ibJfsg==
X-Received: by 2002:a62:4ec1:0:b0:593:d2ab:fdfb with SMTP id c184-20020a624ec1000000b00593d2abfdfbmr5166546pfb.13.1675158998053;
        Tue, 31 Jan 2023 01:56:38 -0800 (PST)
Received: from debian.me (subs03-180-214-233-94.three.co.id. [180.214.233.94])
        by smtp.gmail.com with ESMTPSA id c136-20020a624e8e000000b005898fcb7c2bsm9296256pfb.170.2023.01.31.01.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 01:56:37 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id E46B51054FB; Tue, 31 Jan 2023 16:56:33 +0700 (WIB)
Date: Tue, 31 Jan 2023 16:56:33 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/306] 6.1.9-rc3 review
Message-ID: <Y9jl0RzIHYZ0WBxz@debian.me>
References: <20230131072621.746783417@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="100PyLCecqPA7cy9"
Content-Disposition: inline
In-Reply-To: <20230131072621.746783417@linuxfoundation.org>


--100PyLCecqPA7cy9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31, 2023 at 08:34:09AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--100PyLCecqPA7cy9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY9jlyQAKCRD2uYlJVVFO
o2IaAP4mQiCfNTPqiZN5/vGd8YYKYy4o/KiC4jp/u/g0TWlw+AD/Wr5UyqJV/WYL
3LyrjF8NR/ZSC7kDuo0lqcnqRJpP8Qo=
=wp8l
-----END PGP SIGNATURE-----

--100PyLCecqPA7cy9--
