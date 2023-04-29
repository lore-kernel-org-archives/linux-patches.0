Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC3023A4
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 07:42:45 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-63b5465fb99so676127b3a.1
        for <patches@lists.linux.dev>; Sat, 29 Apr 2023 00:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682754165; x=1685346165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OeNcPQTPZBgnBI2IkCYPJMsqtzHgVNgFNOuqYXxOVAQ=;
        b=F6+++vSXR9TxroEWJ/qt93G/k1aFq12YhlwKNSxCSvm6mojLy4KgRWun77aDK7G9ek
         gndD1uJz0l/cYyLDEEP9j7h3OCyzBuh/1TRpDa8OQzLON8AUGBCFoUnab95RF2ka8If0
         lXyPyYwWk8yKXXmNhcgog8hBjpJD/Wk8hWDrdWUZBW2kxVjhyuURoqrsFoM9X4xDc5ds
         Jgwo1sO0Q7YEEfdnsKH0quMnXaqscq5LWXmlMotTRu/rZK9+5o/gv6WvHztyJBCsnKxh
         s/DePv5jaNBmdV6zgRLPrAecpGHGr2jtoNqche/NlPJxtjzPCZvz1Eh+x2Hym8auSf5q
         jInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682754165; x=1685346165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OeNcPQTPZBgnBI2IkCYPJMsqtzHgVNgFNOuqYXxOVAQ=;
        b=dwWlvAM4d1gkcYUpp2I4W2JnJqgfqDTpF8CRkaNUrJJQ9Lu4oehmXLf3EHTW8hqxRO
         mwV0v1dwKXsY+suzmLotSDUi0W194YGYbzYzYOr8mp/mJNltuuXqF94KYqvcMeWtguFZ
         of8hctTdTwjJK4R1m02NMEXhBtDDwYtyYbn6MbAP+Q0v+3fPinvChREge5FGwJnBvRU/
         7W44WwfKMh/XGPQ1S/C7R8Na2umVBr0Q7zGm/ddWo91Q6kxzk1D88p4Dte8UQGgbnVIl
         MIUEApGtqUce2B7yUZYTAibj2cn7bo2XFdG2qMbtmR37Gxr30y6zpyA9vgD1GRCVQHjI
         v/Zw==
X-Gm-Message-State: AC+VfDw7tYiHQHLODXP5WtfrttoCHXvcgzQ3rbLBMiMENuLLC/43Rrlc
	zSCSLuRYO01eWHYRw8MipLg=
X-Google-Smtp-Source: ACHHUZ6rDpYRi/riL+A0zo2zK8Ea/uILnmI0S4Sh7FBlN5AgTKX43YwsfZ2B1dMsOV13U3bDF/EgWQ==
X-Received: by 2002:a05:6a21:1690:b0:f6:8d47:17f5 with SMTP id np16-20020a056a21169000b000f68d4717f5mr8866288pzb.11.1682754165157;
        Sat, 29 Apr 2023 00:42:45 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-88.three.co.id. [180.214.233.88])
        by smtp.gmail.com with ESMTPSA id h2-20020a63c002000000b004fc1d91e695sm14121674pgg.79.2023.04.29.00.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 00:42:44 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 15EFF106971; Sat, 29 Apr 2023 14:42:42 +0700 (WIB)
Date: Sat, 29 Apr 2023 14:42:41 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/13] 5.15.110-rc1 review
Message-ID: <ZEzKcQ7enbwpbDCP@debian.me>
References: <20230428112039.133978540@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="APjJtR1Yu04Jbzl2"
Content-Disposition: inline
In-Reply-To: <20230428112039.133978540@linuxfoundation.org>


--APjJtR1Yu04Jbzl2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 28, 2023 at 01:28:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.110 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully built and installed bindeb-pkgs for my computer (Acer E15,
Intel Core i3 Haswell).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--APjJtR1Yu04Jbzl2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEzKTQAKCRD2uYlJVVFO
oz0dAP9qqBqAmc52bNn3EsMT9oSv5OgadEtDmYxVzbnKu6uhegD/fORrZMZroG5Q
H8/RkC3s0OHzvSAOQIml9OKrDHQQ2Ak=
=R6s6
-----END PGP SIGNATURE-----

--APjJtR1Yu04Jbzl2--
