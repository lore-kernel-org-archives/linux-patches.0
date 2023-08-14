Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D74246AE
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 05:32:36 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6bca5d6dcedso3445669a34.1
        for <patches@lists.linux.dev>; Sun, 13 Aug 2023 22:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691991156; x=1692595956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HT+wJFz4od+UUfh/YvtmtCts/VmDgx7cr4C4A9Q7jmg=;
        b=EwaQFnf2fcDIRzLEbQGAEVFsxezZDz6nc57hFH7REtP1oB9L0AlxJiYL1+nQM1z+NI
         NifqZjgsRL95cnTnLKIPnAFyMYJRSCHF0csdUBdL2WThR8vx1Hm318GxLvPyAUSstMf8
         Z52JKjGAPrzEPz7X+89kfKvySoweEebA5u/569A74HKI+19C9TKe+ELhYRuDDqwzMLx+
         BmkTdufKzwKkJWBOuiKWdEWuL6ueuXUGMC+hA8FiNJNRkD8/I/CmCyXc5new/ThWKZJc
         H47wSZv11ldPpwc3Ltg5e55kh8JmXXNKkE221Ujtcd43ktSUrpxH5K/0ad6Q9TUQrcfG
         S2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691991156; x=1692595956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HT+wJFz4od+UUfh/YvtmtCts/VmDgx7cr4C4A9Q7jmg=;
        b=YALHDT2L7cwmjZ0bZ7qq12nkjDz07XN1lJcqtdyg2xEVQZ99w9xipPW8keX4UAQlEC
         WtXLsKhePo+bJLhsV4hszhpmRFbo4Hdo0uXm2TmDRsKBWFkLTrqlM+eVqkve/E4VCuY8
         xP9fmqEFyGa0JJ+sTVwmu3daXpS6G0BNHC/e0seBYQHLsYpPTJ9l9mD54eJwe4+4GyZS
         oeaK9DtWRsXIyC+HGtwVA15hzsbGndGoSZfkGnXBvnIoef7VQMNNUZY3LT++oBFw/keE
         /2lwo3vFd1q9rSpm7s/Q21mEnpwW2bwCuLvAWD8okVZgeaxGKqwASoBhZeFct6+dJ/FR
         E8cg==
X-Gm-Message-State: AOJu0Ywc2sb+LwZCuv8JNNsaEkWh5LjF1p/eOh30cXak09qiiNYbBYO8
	YAo8Jxks7Bv7YdrZrtloIO4=
X-Google-Smtp-Source: AGHT+IE0oT92e/iIz5YUsgN+ZDehbjY0Tt9twn9bkhTYZyq7jC+7Z/jGjA/owrcK2AaZQ2Np7Ytv2g==
X-Received: by 2002:a9d:6e87:0:b0:6bd:9fa:34ff with SMTP id a7-20020a9d6e87000000b006bd09fa34ffmr8198558otr.9.1691991155831;
        Sun, 13 Aug 2023 22:32:35 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id p14-20020a17090adf8e00b0026971450601sm7120844pjv.7.2023.08.13.22.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 22:32:35 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id E5C5A81A9BC4; Mon, 14 Aug 2023 12:32:30 +0700 (WIB)
Date: Mon, 14 Aug 2023 12:32:30 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/206] 6.4.11-rc1 review
Message-ID: <ZNm8bm-jNi_nVRfL@debian.me>
References: <20230813211724.969019629@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5wtxyPoyzPwSJrdw"
Content-Disposition: inline
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>


--5wtxyPoyzPwSJrdw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 13, 2023 at 11:16:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.11 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--5wtxyPoyzPwSJrdw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZNm8aQAKCRD2uYlJVVFO
oxe3AP0Tpvt2lDrzyp0f73DoiSP+zPulKQ5fNMfbF2wJF1eiTwD/cw3g//u8xx71
16eyW3q2ydg5pb9rIcdLIIHJwwzZKg0=
=J+65
-----END PGP SIGNATURE-----

--5wtxyPoyzPwSJrdw--
