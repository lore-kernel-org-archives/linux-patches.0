Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B134128EB
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 13:11:06 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso15349349pjl.2
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 05:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3dLTU612GzzdYO0SBcn0mWHahDid/oJBo4lw/MtY7L4=;
        b=qy/BVm1tf8FZ63SJY/b2pakV6rmGnC461YGXlrlrpLu5lpjxURmUGpLrgCuxTWurZA
         Kj+2wrIsUb4z+hY7xfqK2iHkKFhqeRazwUpJbDaXOXy0cDzrsUXFUQrMfOAVBHhztGDG
         sEezuM5DMKR7ACDuLtmVjFnaT6znD68dXG0W2plmd1YzcbD2oc240APFE2TSTxtXI086
         iJ3uMvKMdnyLT86GxLycjTpePCiInoZBPIT8rIyhtDY40lJlpZiuY53FZYxcppSpkACj
         99acRmgyHgh6vBW5oiblkoQPJSsfznr0cwwIa8KHfQwJRqRUAf73T05mnoCYniedYwBH
         BmmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dLTU612GzzdYO0SBcn0mWHahDid/oJBo4lw/MtY7L4=;
        b=ozb79pfn5wNm8jSyJb84gjcGk8AJQcgvUFOvVZ8WNy3+63v5hTuxurNq4iilmVOqIN
         K0VCr0jx3F+XgdI41AUNKXj/MGUUClMkRcdX+mkf/aD5oc6/Xy+qh/xjtbpH6KRy/U1r
         OF2vhUEApbtt6qZXmCkVy24NSo/ePWxbDk7tpvWF474na3q1MBFGUwdIH01uNdEFC0er
         099cMCS036hfKcEe1X/p0mp3hVrynTg80t3A0cfzRcWwK9JRZTZBUseITMLxrsb1UfRA
         0LMYZ0jOmlSsB3Bm6/N3Wf8HuvIawRkxJKyPWE7k6XW/y087G9Zgeh/4JhyNt7CpB32x
         /nJA==
X-Gm-Message-State: AFqh2kqrvYbcGICCv108ilVifcQ+8Eicw0Vsa5D+jMyRI3d0165wRIRE
	/InaC5wDSUWyTEE4bSK3CB4=
X-Google-Smtp-Source: AMrXdXsGt9UXnWwjfiM8jnODNUc64br6bVcMhKS3CHQj0aqozwPvvV3TwOUN+irM+vUVRCpvTz5kDQ==
X-Received: by 2002:a17:902:a70c:b0:189:dcc3:e4a1 with SMTP id w12-20020a170902a70c00b00189dcc3e4a1mr72046537plq.9.1673442666181;
        Wed, 11 Jan 2023 05:11:06 -0800 (PST)
Received: from debian.me (subs02-180-214-232-16.three.co.id. [180.214.232.16])
        by smtp.gmail.com with ESMTPSA id 3-20020a170902c10300b001930b189b32sm3339407pli.189.2023.01.11.05.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:11:05 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 23AEC105167; Wed, 11 Jan 2023 20:11:03 +0700 (WIB)
Date: Wed, 11 Jan 2023 20:11:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
Message-ID: <Y761ZzJz2J1rsDJ8@debian.me>
References: <20230110180031.620810905@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9GWqeI4YfsIBwabG"
Content-Disposition: inline
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>


--9GWqeI4YfsIBwabG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2023 at 07:01:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--9GWqeI4YfsIBwabG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY761ZgAKCRD2uYlJVVFO
o1ksAQD/CYn3eL/BO0YQtBlBXan/BawrgZjptbsHMBJ1HdXMwQEAsw6CNBKPzld7
yNucgutMlfOpKl+2P4Wdyr8k1SgGEQU=
=1/97
-----END PGP SIGNATURE-----

--9GWqeI4YfsIBwabG--
