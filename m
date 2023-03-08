Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199A562B
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 04:20:22 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id y10so9462752pfi.8
        for <patches@lists.linux.dev>; Tue, 07 Mar 2023 20:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678249221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rnkjn4DRhnRW1sqD+uqYuOcNZEzPfc0ZfZT3Ap1tve8=;
        b=JTUKI9GzKGdU2vqgieL04tyhdzhJpItt1SnEO5D0vB476SThNsAX1UfcBtyb1gY3bK
         UaUORef+lozKR6JtHvbLwElN+TGTHIPxvjIW11qTIFoz8Q7JxoAG6gERXKpI8JbStz3C
         volQKrrQyeMK8b5Ehmnx/wuh/wtcNQY/fvzQPt4s/N/ZBHEDafuUGd3e7Bx0n1QsQp03
         8ZipfFcpEDIl29ncU5u3xdC5xV/VO1Z7sBBVls1AH62TM0fljXN9ktzIFr83pPR6bcGI
         UytZ/E2L6JGZ4X/K2mSo/AVVeCQO+VeMrdPLONROPKDpoJ2zIiihEadmu7HU2jX5aMmh
         Q14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678249221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rnkjn4DRhnRW1sqD+uqYuOcNZEzPfc0ZfZT3Ap1tve8=;
        b=roRFVsSp83peficGT4ghTVfd7uMi7MkZEhj1rI3FXSfbvr9vEdHU+SiC0hCvCnp3iP
         +8yrly3znK+52BpI2x7FivqodW67E6SQlSfQVCUfHjTopvTexpLPuayIBvKXGK+qZjkn
         4mgMAsPB+KXICM/XVowwcivKhlCsUzb3OiJgKNE26Ud5hnSWeKX0nyaZKyhPDWP9fATI
         lq3UJ2RYrHmKcOozRGmJmdJSrjii1ADEo3MiCwpPdX0XXf7SSNmtmS65qP05zHnmHRFf
         hZp4QrroPiqmhRbCASZvRWgJtjB/E9fNw6YZCvnLt2I7z88UvXJ9/DMTbsjjpmfgtQU1
         ENlA==
X-Gm-Message-State: AO0yUKXHG87kGbZ9uk023emd5UO6p99071+OdUMXczD21sl+HTsF+nMM
	Fpp/e9ETdhI2jrl3Yq5grlA=
X-Google-Smtp-Source: AK7set/xQnzesADq/Y3cuIKCqmm2rBd9Sol2Rl1vb3XaTJEh+0t3JSzqhoiCfDNX8cbQkZwFt4y3gg==
X-Received: by 2002:a05:6a00:796:b0:5a8:e3d5:d7d4 with SMTP id g22-20020a056a00079600b005a8e3d5d7d4mr18761104pfu.7.1678249221505;
        Tue, 07 Mar 2023 20:20:21 -0800 (PST)
Received: from debian.me (subs02-180-214-232-18.three.co.id. [180.214.232.18])
        by smtp.gmail.com with ESMTPSA id j7-20020a62e907000000b005aa60d8545esm8669245pfh.61.2023.03.07.20.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 20:20:20 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 7482F1065C4; Wed,  8 Mar 2023 11:20:18 +0700 (WIB)
Date: Wed, 8 Mar 2023 11:20:18 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/885] 6.1.16-rc1 review
Message-ID: <ZAgNArfjHFbigSZR@debian.me>
References: <20230307170001.594919529@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PVn/FJYx3o++izsw"
Content-Disposition: inline
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>


--PVn/FJYx3o++izsw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 07, 2023 at 05:48:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 885 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--PVn/FJYx3o++izsw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAgNAgAKCRD2uYlJVVFO
ozJeAQCQ8qnWnsmEVPqgV/Pe4uCnAAGVaiZu/N1T1uM4L43MSwD6Aimb7LLSdFLs
wkF2xJW9XPwPpB9gW7R6nafVWfpskQw=
=fXZE
-----END PGP SIGNATURE-----

--PVn/FJYx3o++izsw--
