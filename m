Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC855E4EE
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 04:48:19 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so18941538pjv.5
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 21:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679374099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hVbAqw/LdnF4B7q1qptxDYLJgQO8iuceCy5zwfXugR0=;
        b=fXQs3M+Dhb9fFSn7V6bEQ7CiuzcP3a84rff2/mp1FifgDYv//VbAM0zTxKjLtLE2P8
         JBjCEBdbrcZJ17TZ/WW2qqk8nI5t/mCFlnxhjbZy3B08UGABZb7r4Rm7eGNzVM8WjqIm
         676XQiahIdUh9xE7ytUQu9VGzewHJSuE+My3K+FsKHBV6Uoa5QCCH5A1oOjjX+tIjYrr
         +1565Kqk9OWrQLIElKDOf2ejk52s5/ikh+sDVR7/9SXQLJJh+6Atfj4SXCeH8pcIAkLn
         Agr9BEyX2EZgwEb6EVCtXgypD6Fhjcctb83PdN6d7SyO8cEj2cRf4W87+SyJK4dxJXeR
         eYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679374099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hVbAqw/LdnF4B7q1qptxDYLJgQO8iuceCy5zwfXugR0=;
        b=RRbqC5k173pgkU3ocvfOSOH0cQCzxlLfNtXR9EUlKkY6RHvO/6f6+nCzhi7hVVZl1V
         Mvq9he9sI/klJkszn2bvVOhepFkHDnzzHOuviXIJHRTyyKemf2AbwWSJ/Dk4/9O0ocYc
         kP+A79NTNMyrxWP3zsr948N+sCrpw/rBp2whCEVBoRLPYz2en8IqoQGZGe0PCGlndh/9
         P4IzAB4IhSedSsvCZrDF2NXWLqaQA+fBr2ROLRm0H42uW33a7WyhJXi8pjlUdk19oYm9
         YYOcuI0xKkRCzJYdLnraHLG1Qbt2vZACcjqx1/AcR851ODAC2ia5ozzxKPzlMqWWfwd2
         M4LA==
X-Gm-Message-State: AO0yUKVfcBBBLLkb8Kcpy1zN74VBO4E1kZmnyjqNgIfO4Tn3UffC3sfr
	VGLlTDjkGTGgB8VPNHXjiF8=
X-Google-Smtp-Source: AK7set8Vril6rOmAZK4/x/sLA+iWJPepN+L6BDJ8NDL6oiZPoitvnaMqzWh1M1yGAQBKLCA+zxda/w==
X-Received: by 2002:a17:903:41cf:b0:19f:1c79:8b21 with SMTP id u15-20020a17090341cf00b0019f1c798b21mr920351ple.42.1679374099293;
        Mon, 20 Mar 2023 21:48:19 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-8.three.co.id. [180.214.233.8])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902edc200b001a1a18a678csm7604605plk.148.2023.03.20.21.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 21:48:18 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 7C59210661C; Tue, 21 Mar 2023 11:48:16 +0700 (WIB)
Date: Tue, 21 Mar 2023 11:48:16 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Message-ID: <ZBk3EHnYKxJFM605@debian.me>
References: <20230320145507.420176832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CGkXclsmGbFsncfa"
Content-Disposition: inline
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>


--CGkXclsmGbFsncfa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 03:52:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--CGkXclsmGbFsncfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBk3EAAKCRD2uYlJVVFO
o646AP4+w52xcmXksk1CbKJXTJfuMPckGQWnZ06oqbS6Eklj/QEAk8u/NYufPucH
K0prtOmnPPCt+/jrWPLnQ4JKeQ1rCgQ=
=27Oc
-----END PGP SIGNATURE-----

--CGkXclsmGbFsncfa--
