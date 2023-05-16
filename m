Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE382C722
	for <patches@lists.linux.dev>; Tue, 16 May 2023 08:38:06 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1aaff9c93a5so94071005ad.2
        for <patches@lists.linux.dev>; Tue, 16 May 2023 01:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684226286; x=1686818286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p6qgMTiGfTOjO4Az9M0tBWQM4kE9jUb98Hvvr2Dd14U=;
        b=L0wKrC1sqm1vgpHnX/VSCU0Ht22Dn4rRzmk2cN2RK4B7ESr2i1I/pBFOIuvEiK9JQ8
         nrA+lgV7L3HO0ndIc0HbjjvI5KRMcKbcwS1wReOp2kOJEzzQzFKd+zaFD3gSljPHOCNJ
         kdZWuaJ3n3rSCZd4d+DrSorfVB2WNyDS8dEeIL+B42YdVAIVX6+xYPNW/Vw0/jXm4lCo
         NQT1jB+7bB+v6x6QstQCfhDyJb1lu/3pQxXVn8NhHmx4tjQsKoqnK/kdpBvFWYlIzwFl
         TJ4AWisg0BSnOHiN4vqXGA0qlB4MrM7mKjiKFCF5NLKRLDO0VQYiW8azt8m49pjmYmzL
         WB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684226286; x=1686818286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p6qgMTiGfTOjO4Az9M0tBWQM4kE9jUb98Hvvr2Dd14U=;
        b=BFcxxEMHg4LRe6y8E8aj2t6IInX04pQm76bAOeENX/JdkqvHM4CJorm8mO9WztigYi
         jlfEx1Oogfb8TCqqVpIRa0bu8ZD6n3aIo/Fg9eA3U9jIZoRnh0vdR2ouLYIyrxQRhoQh
         brkr3xtGTjdTJlaMWvDg+fNwkXKgeO0Cn9lDBY+a28PGoOMyyYBMd6kIS9xflEBYHpZK
         wV0jBKJay7vOhFgdZiRMHHyvWi5c4RPyYHg0UmkOExLevE6F94PTjRjPPs/Geq2mSmYM
         M9fmIaaxlqDE2xDvOGjwVT3+1ce9CLxzHI/qYvlcIi1kCRwn0Fcc78QkYLPBYJ3gphsW
         mv5A==
X-Gm-Message-State: AC+VfDy4VJKWukNN3Wo1pC5ASEZ6Pt62cPxyatAf+/nDMIN5yIoPxEgt
	gLS3X+SMxKtPFyvSzp4bPew=
X-Google-Smtp-Source: ACHHUZ4NLCDr3uSPDvh1PDR3J5WLSWBC8JyDzmhzlTw538rMify+xCVMjxZiW45ML81UIYmBz0T0jw==
X-Received: by 2002:a17:902:7d95:b0:1ae:3036:b594 with SMTP id a21-20020a1709027d9500b001ae3036b594mr2351744plm.49.1684226285831;
        Tue, 16 May 2023 01:38:05 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090276c900b001aaeaa27dd5sm14804581plt.252.2023.05.16.01.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 01:38:05 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 11CAB106219; Tue, 16 May 2023 15:38:01 +0700 (WIB)
Date: Tue, 16 May 2023 15:38:01 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/239] 6.1.29-rc1 review
Message-ID: <ZGNA6UuDUDvztdJ5@debian.me>
References: <20230515161721.545370111@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Wnijbk97kKjImdqo"
Content-Disposition: inline
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>


--Wnijbk97kKjImdqo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 15, 2023 at 06:24:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.29 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Wnijbk97kKjImdqo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZGNA4gAKCRD2uYlJVVFO
oxlmAQCYmB4H34ftBhyQeVDd3S6nA2MKGfV0chHYHP+EO1nqXgD/es71Yp1gwdm0
0LlVS2ehKMtbC79esxoNAonNS9n/dAM=
=a4k+
-----END PGP SIGNATURE-----

--Wnijbk97kKjImdqo--
