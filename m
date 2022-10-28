Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833FB1C37
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 08:20:11 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id h2so4242447pgp.4
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 01:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qDqXXlM8JSPy+MW2RUdLHl67DqOhl3jl9XXumPBsjyY=;
        b=cyHDm7lB2yibuA6Jw84j9k8KTKkMl2Tc4ng6aTdXYZwqaNo4HpxcSQvW2eFg33bD0+
         WPWAi9Wc+j6HhEWmbL2jpyWm9nt5LkZHYNtY7e4wmtp/CjvgGxje4PKueNruquonLxf+
         cCj5QHa7eu5YVIxMUV1lPXpUlu98PN4KcUpH2OEPrX2WEyAnplwrgmTUqJ0JFLHmr7YO
         iQWIRorEykIBAwJlR31kGqnNWbqiA7cyyJJbtz8EtkhFxAjvh465YqJNECbE/vhFxEZy
         Va5RUNEf29ioHAoWEi3Fln6NA2iPzxMtQSw78itfLtJyciko7ztjMAZJFNzJaVUq5xuD
         a2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qDqXXlM8JSPy+MW2RUdLHl67DqOhl3jl9XXumPBsjyY=;
        b=YkUxp8jkYZa/Jz2Jl8HHtnf4sc3PUNP4zdpOk6l8FDdVzos7pTz7edX6FiWAjdQ38A
         pxVirQtzBri9AndHKAySeTi1YxnUJO5plfPpLqWLSaBoXr2kh+xz4F1auc3cwhGfFK99
         oB1XMpxMxE3Y0ANbHeWPkSE5HKW7DAiQvdLpDU3xdheNrQjGB7ePrSmAa/K9cqZis93F
         xZ3tTpHJeQXmVGTscDFflFc5M3DAlK5JBbp+dUV0WLxVU11vTv7DxK8gd74INkeVSX2h
         J3N6GWvoSp746TlYPbo9m49rLXJyBccwjCVj+g/o/aKvbO8lgGTLL4D7Xx/SIXagvx5W
         q30g==
X-Gm-Message-State: ACrzQf1s1IEKEe3lCy7LpH+nZ8MApbHWQ/R+8HGYSt0bedDx2r1zi/k1
	RlbtvjUU1oX97eYCp7ptPWY=
X-Google-Smtp-Source: AMsMyM6ZaqDkTf8iBTNf3qaVXJ6TFmuCX4dUAryYI3CYRJHjegEBT0DYHnvup4uTwB/O10fpTHFqHw==
X-Received: by 2002:a63:de0e:0:b0:46f:23c6:e7d9 with SMTP id f14-20020a63de0e000000b0046f23c6e7d9mr18457054pgg.68.1666945211025;
        Fri, 28 Oct 2022 01:20:11 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-85.three.co.id. [180.214.233.85])
        by smtp.gmail.com with ESMTPSA id co5-20020a17090afe8500b002108cabbe31sm2100035pjb.9.2022.10.28.01.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 01:20:10 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 2507710401E; Fri, 28 Oct 2022 15:20:06 +0700 (WIB)
Date: Fri, 28 Oct 2022 15:20:06 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Message-ID: <Y1uQtrfsl2NOOsv3@debian.me>
References: <20221027165057.208202132@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LMUDTIQu9SXGJGs4"
Content-Disposition: inline
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>


--LMUDTIQu9SXGJGs4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 27, 2022 at 06:54:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>=20

--=20
An old man doll... just what I always wanted! - Clara

--LMUDTIQu9SXGJGs4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY1uQrgAKCRD2uYlJVVFO
oxrzAP4xhYYns/d5Za25ApkxGeI6aYFJWZl4U2nTougs6Y8/KAD9GX4aZ7AaFLfn
s1VY+QVsFEvFktZa/JUCAKSvgssLnA8=
=j+Lr
-----END PGP SIGNATURE-----

--LMUDTIQu9SXGJGs4--
