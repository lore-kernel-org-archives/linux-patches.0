Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE8C63AB
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 10:04:26 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-686f25d045cso4557118b3a.0
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 03:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690970666; x=1691575466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jzdlr2mIcU2IrFz9o3Jf4YUjcTGYzuN5We6AMeqKFnM=;
        b=e0A+IMR4AQ69oBEH2PJ3vOWNecXFxEcr7qFduFBebgjyFo/sQDQvHu5QC18G567l9P
         wXBGYZ5gSQuuqopSKqJZMyjQqMuAK3sUmf3J5tO3RXgK8bHckDXyiv6bnH8+MGic7xTG
         LiH3GyxzC6EYqefD3tC2GjuB7nALQYZPEaXjkHNUxCrDm8Sh9rarVZijiPaf+aezchZx
         /01US6LpZsPrV6dYm6BZ0y2IsjGRoSUiHMHjW8o3JQFgfoTRFk+wlyGDoGU5LfeDizoO
         SUwz6orr/dfou3oyzIPdEIwpjIjyfw7FhpLk4MwYKzT9ubMn0IdTTLkSLmNkWHaYGDpH
         f2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690970666; x=1691575466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzdlr2mIcU2IrFz9o3Jf4YUjcTGYzuN5We6AMeqKFnM=;
        b=JrM/e0NN8BG6JFkfY6G0wldM12WNntkQ8XT6H3idWHlsiDWVeCnFWjT+J76wIz8RBU
         HjxjB4teTDy1ZvPin/UoZiN89IcQTg8zgsvMgbXOR9xIuqRopNSA4+9AOB9dmIcDbwW2
         ILlNEznYwQLuCh1zZrsCRCwETNwrCaF/tVKXXLgHYH1D4NjJXuP9qnZvYWX0vGdq0g38
         xgG0ydncsp8VkqZboEamFYwNopS0H9E7RC8X+hgkzakRDvBFPCmmyYpURw9/RszNjujh
         8DtPkLFTXSwqMOQIyTTLeD4IIr08la13W63KqPZ5EC0qecPTQ/TQnqzf8i52dtgP2rwb
         wKiQ==
X-Gm-Message-State: ABy/qLb5vlDhscM8Xjihm3Y1DW5uAsr5hrzzZrEQxsxKOgVVB8323o8c
	vRQMsniLQm2bXzcUFO1xxM8=
X-Google-Smtp-Source: APBJJlGonZPiBMK7/fd5/8vi7ZRncqWa4B1zav+8WCXhfN2F1WjwSMGZnigR6KOpwFBPpoHzeQfiUg==
X-Received: by 2002:a05:6a21:338c:b0:13c:b7e9:7a22 with SMTP id yy12-20020a056a21338c00b0013cb7e97a22mr15598546pzb.13.1690970665781;
        Wed, 02 Aug 2023 03:04:25 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id c24-20020aa78c18000000b0067b643b814csm10771972pfd.6.2023.08.02.03.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 03:04:25 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id E10748197C37; Wed,  2 Aug 2023 17:04:21 +0700 (WIB)
Date: Wed, 2 Aug 2023 17:04:21 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/228] 6.1.43-rc1 review
Message-ID: <ZMoqJXlKE/Z3zIEx@debian.me>
References: <20230801091922.799813980@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wKNwIsNqkSXovGwe"
Content-Disposition: inline
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>


--wKNwIsNqkSXovGwe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 01, 2023 at 11:17:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.43 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--wKNwIsNqkSXovGwe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZMoqGwAKCRD2uYlJVVFO
o/7zAQCS7CnZISr6lL2mKcyEz5apiccehhYMQWs8cNZZcWfLZwD/d1fCvAmWTQjk
pKjMathiJyOsJm5lW1eN44F21g4vSQU=
=Hspl
-----END PGP SIGNATURE-----

--wKNwIsNqkSXovGwe--
