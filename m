Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560FC361
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 02:05:01 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id e10so11802568pgc.9
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 18:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5g2uMGvAQ9S4h07gXUEIs/07hwwQtHkE2RiRVVv/MIU=;
        b=hUwowIH50OyZvlhdjvmD2v5h9jayW2UkKoNo8+AWuMgNr9n0VKk3TAeml/7ofi1ncE
         Ii8lo89oFy9DuHY8KXwXXyBjniKz1/rzzIV6zPVG+1bl5tQn8PBvKHfIzoNQKCvEC3xg
         BSCi0jSVn290Kyzje3V6CAbsL+zLqjPMU1AfWrlO5Kg81V1tHfYc2WGTlGYGmod75C5C
         CuzV2WL02Tv7JEja0RKZz5SAnI43cMkX7DdKvf3CmF+1q1o02to5tAVL/a3XEGy3sBzb
         GYd4/XYwsM3LaDejrlsQe0tp0pHRawLt1ONQsoprKbt8FRS9eXgCP82vCgAR5jXmXWi1
         8S5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5g2uMGvAQ9S4h07gXUEIs/07hwwQtHkE2RiRVVv/MIU=;
        b=jl8re0wAZbSsFoWH/7DvzmUGGbpZVSpPoCpnlmutrcfE85h+9IPFCb8bkyam9vPJrA
         pBZrQBLmk5orrvV5k7T/N0LGvCCIXw9H9DDAZpKqFi1GUhuu/tstYvJY2ovSJP2BIW51
         B7RRwwqo6Rym5aJnvfFnN4S/KSvr7eMY9y6MtCI2boX8gnYMaWx1UZ6pwoS7nXJjm+RX
         GDeNj2SbazqLg59B/DpSom6wy5rB6D0VljpLyhDciDffgFRPl1YgiDVe3XHAjgd3e5TO
         NtAg31w3P+A7LuLyWTl4XX5WGkyThZehZCEpnjhjNw6ZsOVxmBvQ7dbniR7+vTT/oXQJ
         F8fA==
X-Gm-Message-State: AFqh2kpQdZSVb1mrx3GT5sYgkMCqwA+oZqoY3Sv8reddKqQaAaDMJLuP
	xMJefig6TxXyj80Pf492quU=
X-Google-Smtp-Source: AMrXdXujpyNgYfIuvMR1sPABQ4iHiN8Op4JoJf11GjEals2lMk8qhFHs1aqkVY3Tr46Qmj0ONhne+Q==
X-Received: by 2002:aa7:8701:0:b0:583:319a:440b with SMTP id b1-20020aa78701000000b00583319a440bmr24517279pfo.24.1673489100730;
        Wed, 11 Jan 2023 18:05:00 -0800 (PST)
Received: from debian.me (subs03-180-214-233-89.three.co.id. [180.214.233.89])
        by smtp.gmail.com with ESMTPSA id y12-20020aa78f2c000000b00581dd94be3asm10664666pfr.61.2023.01.11.18.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 18:04:59 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id C868F101401; Thu, 12 Jan 2023 09:04:56 +0700 (WIB)
Date: Thu, 12 Jan 2023 09:04:56 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <Y79qyJNeeOp1WFEI@debian.me>
References: <20230110180018.288460217@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ze+BUts3BFtX4u8t"
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>


--Ze+BUts3BFtX4u8t
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Ze+BUts3BFtX4u8t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY79qwgAKCRD2uYlJVVFO
o9gHAP91ceB+gU4YWNrniP4fjm2zh10jwDsaj1smTHxHDDOrIwEA+nz/+TCP3TrD
SkMY/WSoV5tbZlWgLRHj/hjhyzVtSgY=
=ftxh
-----END PGP SIGNATURE-----

--Ze+BUts3BFtX4u8t--
