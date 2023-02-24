Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D432902
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 09:50:38 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id i10so7228556plr.9
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 01:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NVCCdXBa6nz88M87KyoQqKDz5FQKWkEXCvBtVbehT4E=;
        b=cjEL4yZ7en6kaastuCZfsMHDzYmv/Vd2SJJtJwOadFmDpRbtvMYKVqu6jrOHMl3iKR
         NQybfLjw1kRjVerGVTjHXSCJ+mlMYGOer574w02tCSee3YyvRiVxIjx/UQ8TiJ9V4Fk5
         TgeWA8jIGq5io6C9TZvb55cY4FN8RdQZD7YNj5dZGhq9S+KGYpWvcj8X5/XWHyLqLZUQ
         fTbi/1SXF7cjcT6JweDyF0Jjdf3r/+sEXzgp+Xo2Jhf2SBxuAnsRhZ7JEgLKBVGrIGDo
         NpRyS+3FBzh01i5aAon5IhM77QCUCKmyyV38DUj8DoBwffBdOCzcVYdUikzzIDjeJiv3
         oosA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NVCCdXBa6nz88M87KyoQqKDz5FQKWkEXCvBtVbehT4E=;
        b=3J8ajd8fVih5h/N6Ei64BqGDnJ4h9XEQu6z1YPADAUYx0nn8C+LunNe5n//GVNRpCf
         etsuRSO6H81yKSScTa9ymiYDzqNx7kqkGi2KbrqawB97c6AFwm5edndb3y2QPgLvlD3/
         ze97KhSwgLoeuJbpSt42f53fu+RDzekGHDQ4dy1w3+ybIqYK/HeSx/ZQBlNsM+QubiqS
         AembKnhCZRcIREOeba3bqQV6dl5+J2wE2ePw+e7lbMMIpcYttkjXuuVlGEIAy4kLqMip
         G58Au1zxrfDnZkfWRv8lmIlKgqrE5alXUew2o1BIQSf0aYrHGY2Liwfi6kClujCNwM/T
         1vIA==
X-Gm-Message-State: AO0yUKVSy4Hi+MlF7lEMvmLU6I3oBQd6WE+lc0F3O2lFQ5W3R0ABciA6
	UXaPCp4cIFqVOVJX6q12u4o=
X-Google-Smtp-Source: AK7set/rtHLudRm85CWQuBieXpRW8tFRNkR2cAEct9hcL+0lMVkTZgqzZ4hSwV0FiYCejSf9wSz3Sw==
X-Received: by 2002:a17:90b:1b50:b0:234:1676:84f2 with SMTP id nv16-20020a17090b1b5000b00234167684f2mr17823007pjb.11.1677232238175;
        Fri, 24 Feb 2023 01:50:38 -0800 (PST)
Received: from debian.me (subs03-180-214-233-4.three.co.id. [180.214.233.4])
        by smtp.gmail.com with ESMTPSA id a15-20020a17090a70cf00b00233df90227fsm1134486pjm.18.2023.02.24.01.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 01:50:37 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 9098D106350; Fri, 24 Feb 2023 16:50:34 +0700 (WIB)
Date: Fri, 24 Feb 2023 16:50:34 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Message-ID: <Y/iIat7/gqFdI2xy@debian.me>
References: <20230223141542.672463796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mGA0/6pHTKADJV3O"
Content-Disposition: inline
In-Reply-To: <20230223141542.672463796@linuxfoundation.org>


--mGA0/6pHTKADJV3O
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 03:16:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

As others has pointed out, I have to apply scripts/pahole-version.sh file m=
ode
fix myself. Regardless, successfully cross-compiled for arm64
(bcm2711_defconfig, GCC 10.2.0) and powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--mGA0/6pHTKADJV3O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY/iIYgAKCRD2uYlJVVFO
o4VMAQCgBe37PX/IS4NUBzfnKEDLL1b6iL9oOJzFRRzx+refkwEAs+g1MXQtIg97
Rgq1eNefOupru+O909loeM9xQH9erwo=
=VHKN
-----END PGP SIGNATURE-----

--mGA0/6pHTKADJV3O--
