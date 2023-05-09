Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB83D392
	for <patches@lists.linux.dev>; Tue,  9 May 2023 02:58:24 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-517bdc9e81dso2689501a12.1
        for <patches@lists.linux.dev>; Mon, 08 May 2023 19:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683601104; x=1686193104;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L5sAr5+zJcWIHwF6H6CsxkFRXjnixPWmUJhulR+ch8M=;
        b=QKKZHkI4GQ0MBi8lmTgJ2zeIJvNUY9S95uAFK8IuXTtazWMcrwUUjaN/bZVob9/BpS
         KoK4CD5c09qoKTg9Uo1zjpoqpLrMBNXc3Q9dpm1qyqCkTdgt7HN2oMZ6juRa6kOmZcxH
         KB0lG9njEHEt1M8G7c/I21ucIuEHlq8gW/J/2PfcgrDeMIXgyMC1N7eoJEcduPbvEybn
         nggZw/E823E5KG4G6NiM9VAQvxaZMQCCTmNxjWPHx8+7W+pjpkptAjHSCbIwMcsTlyh5
         L/lhBxguzb7Vqkz+lEjSUPmvh3xI4y80JceKJBmFpoaucz/LVU9ubGC0QXdzJY8vJ2Wg
         F7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683601104; x=1686193104;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L5sAr5+zJcWIHwF6H6CsxkFRXjnixPWmUJhulR+ch8M=;
        b=mF3KCGF+1sHmxS6iQGWZZ8V6zUxxH3RY+DI+pKwotCEIwrE2aBAjfgB9w9intVsbpy
         5M38qi2a7u7Gag3RGLg+vU0Iq2Q94sFbo5RlQXd+WZpL7UZYUMLI8UKIcRit4LFhWKut
         lAGZzPyiwK8KxtIiEFq1qSZ+TftwhYQRfrO/nv2Gjj2YpFuk4/YvILMpacn2E1HUUyQP
         zkZGDjB4V6CvTRJFn6NimWy6tnu17+E+LcUcMCKgrFjlRp7vFfxCrNTvZAFp7kXqr8pB
         S0IzRWWLvw2MhMPZJrd1O2FR2DU9Z4imXe5F1LkSLV/AV99JT5ZLAOU1WgyzC9N+f1um
         L5yg==
X-Gm-Message-State: AC+VfDxblks0rIPaH4yjvRNd4+O7xymtgmgYLRAGviIsmiWBxnKTw/S+
	8WeSBAc5LHZFEO18TPLlNus=
X-Google-Smtp-Source: ACHHUZ6TruIW5hwcZGmvDzLEk1qgazfw804mmMMnknBnIsUSaz/76gZhJftNSZfq1l0WDpkxRCpD0Q==
X-Received: by 2002:a17:902:d488:b0:1aa:e5cd:6478 with SMTP id c8-20020a170902d48800b001aae5cd6478mr15845590plg.58.1683601104208;
        Mon, 08 May 2023 19:58:24 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-91.three.co.id. [180.214.233.91])
        by smtp.gmail.com with ESMTPSA id t17-20020a170902e85100b0019309be03e7sm226355plg.66.2023.05.08.19.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 19:58:23 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 7F5CE1068BB; Tue,  9 May 2023 09:58:20 +0700 (WIB)
Date: Tue, 9 May 2023 09:58:20 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/663] 6.2.15-rc1 review
Message-ID: <ZFm2zMiXQ0Rd9b+g@debian.me>
References: <20230508094428.384831245@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SbuvbuUZKK/KAY99"
Content-Disposition: inline
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>


--SbuvbuUZKK/KAY99
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 08, 2023 at 11:37:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.15 release.
> There are 663 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully built bindeb-pkgs for my computer (Acer Aspire E15, Intel
Core i3 Haswell) and booted. No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--SbuvbuUZKK/KAY99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZFm2xQAKCRD2uYlJVVFO
o/GEAP9ZH1cGBUX2fOiVLEmXW7PWYXy9VGlvI8Efzo2jQSMSCwD/ZDK/o+hHevAH
Wt1MMWpM7PCThVqO2CCsVKNOy3bVQQM=
=YXmm
-----END PGP SIGNATURE-----

--SbuvbuUZKK/KAY99--
