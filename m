Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7F51105
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 03:42:07 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id p4so18032477pjk.2
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 19:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc0DuU1O9eY3YHChsMW27jwVrWlDkDg7wgtC9pCKkng=;
        b=CTW90m8ookmgVbN8JMlAeqhaXEU435OhE/1KEl/BoV4uGNO5P8bjeviexwlm5cVk/X
         OsW9kElZhbSXAvb8vyOJerVRWDXC89AYna8oigszgeyPVJxLS9PXoa6FXqz0MtbAFi6f
         c8FpQlNfCIgMz+Lr/8XOUwyWlEjvzr51j2WVeL1MXNkAk15bRUT5J3c3xW4AwKExYAbm
         ls+LsMHF4J50qm1w0QXJ4qIJg7OJoMj0m6yrekLLrMGnmdRLKpOlp6Xw5gjgA7cLZB/6
         /9WJM980pPoChLsbZj4tCte5jsGEug4hwG+d/2Gqg1GynSCktPO6ubAnmFtrQUFJQz+k
         XyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dc0DuU1O9eY3YHChsMW27jwVrWlDkDg7wgtC9pCKkng=;
        b=rbBXc1tI7XT80+kKQ/lSMMQnXqQ0B4wWtrlAtJcxSAY0dkB+rRc1o4P+PTwGICaFOp
         En12HSk0enc23mkwUabHp0EcIeH3AaW/3SosCz/UHjrtJCdrlb7UFm3XBOS2TIwew0sL
         bYYazFtH8icFjpsVK8vOmet6DqcaVp9ExoyzytnzutnWtmtqqkjW4VE1v4NMqVDyAPa9
         n42J68b5tH79WC++uHWw7ysvAUT6wDaLSXiLdoZWzWIfYN9VHSR98Bb711rrIRHc3uns
         kIgPFjnhWEwmTOLj0UCtJlopMBzIh4NqlpOy2gz09KYjYReRtdg5Sg4WcytnCyw0fsAf
         U/RQ==
X-Gm-Message-State: AFqh2krrqCsk3oCVZlqjCjkf34DL5BKFnWydHhk0xyjbrREm13FqN9Tn
	YBUPpG0TpUVKJ0Yux7HUfpI=
X-Google-Smtp-Source: AMrXdXtiyWJ5Cr7Un3Vovkoxmt4cIPtCGX4RjLXIDFR46yC2jvX6/fFlcEK66r4aCOkui+YEQisq/Q==
X-Received: by 2002:a05:6a20:7b28:b0:ac:184:d297 with SMTP id s40-20020a056a207b2800b000ac0184d297mr29035719pzh.38.1672285326711;
        Wed, 28 Dec 2022 19:42:06 -0800 (PST)
Received: from debian.me (subs02-180-214-232-94.three.co.id. [180.214.232.94])
        by smtp.gmail.com with ESMTPSA id a11-20020a63e40b000000b00478ca052819sm10074960pgi.47.2022.12.28.19.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 19:42:06 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 61442103AA8; Thu, 29 Dec 2022 10:42:02 +0700 (WIB)
Date: Thu, 29 Dec 2022 10:42:01 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
Message-ID: <Y60MiWGDnPIH8Xrf@debian.me>
References: <20221228144256.536395940@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3ddO/rcqvwCyeG/o"
Content-Disposition: inline
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>


--3ddO/rcqvwCyeG/o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 28, 2022 at 03:31:47PM +0100, Greg Kroah-Hartman wrote:
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

--3ddO/rcqvwCyeG/o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY60MgQAKCRD2uYlJVVFO
o2vHAQCIFNWPgIZdRpUl9FNBuKw24/tlOtehnd/RDdmGNs6COgEA/DHKoy2Wd5oI
hn+mogOECjYoSBQcTBZhfMIhMYRU2wM=
=scV8
-----END PGP SIGNATURE-----

--3ddO/rcqvwCyeG/o--
