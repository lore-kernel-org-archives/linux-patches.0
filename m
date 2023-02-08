Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3FC7F
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 03:02:09 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id be8so17804636plb.7
        for <patches@lists.linux.dev>; Tue, 07 Feb 2023 19:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nlkpngfGvD/yiVPysVUCiWbRJJEon+jqBMZmtnq4MwM=;
        b=ek5FXFElcRs9ejujZlv3HlBxR3Y9EKzX11DkCe1K52VMjYTlN37n2TAtu77PdPnBmt
         6JvygYOx82MhMTJrF34aCl5udCf81cBRGzi6VJN4AwTt6WdusGJhudGxi7O0LD8Mvkrj
         nleA9JZ02gQjfGOD6L3IYxjDaPBgCWmplFBFkV7vxEAzubLVuuYwkMtFKLB72NBT2JkR
         vUQQXaZvtCJESU/sdO7tKDkAq5IhGP3kPnzSgiiVNJy3ywIC9c8z5BFGSFDk4CTdIWT6
         heZxJgXL44VQREYGc67TMOcOOqwTjzu21o4tDyB7m47RXfoMeJjAQB6uYymjWl0Rre0D
         F3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlkpngfGvD/yiVPysVUCiWbRJJEon+jqBMZmtnq4MwM=;
        b=KEVlpoqTv6cpts5Exduc/qz0loVX3a01y6XJBV2P2POGNMTReEXJ0I/Jq7OLiGxB5D
         eKt6KG8qKU24FEUVqZvgBUzc8ZmWtAdArxzAuESu46EHb+D8MKjARIviCuStcXPOPvnr
         8AXdj3lfjBuTd2ACl1rX0/O1fnMgpfU3RmyBR6qx4rMBS/ULpJ9EG6muD0p99fSYmY0Z
         cgG4Q7ApOcBQscA63QF0JgWS5ZT0R6S5PV1b5WQq24m9ENzM4M8PxmF1kVZ1eTj6Lhqh
         x9g24KxZzDwH0hWGXOWCjK7rL/ncaX8UQjpfR1ck4yD3hXig8rCyJG96WoGQLeco+4p5
         nQLQ==
X-Gm-Message-State: AO0yUKU3TmdnFRXfN1zd5GQs2//bzImQsXsbSWMHcjM8KeK7Y0wnqsfN
	6BJ1zyvv+Zg9d0JfhS7Ihls=
X-Google-Smtp-Source: AK7set/Lu7/GmxZwF6rYKdq5yeGObj5e8OHmUfmGFlcldoL0DbWJJALT6tXH2snOJ16bT+/w0fn3Vg==
X-Received: by 2002:a17:902:c40c:b0:199:41a5:1085 with SMTP id k12-20020a170902c40c00b0019941a51085mr1708108plk.33.1675825329410;
        Tue, 07 Feb 2023 19:02:09 -0800 (PST)
Received: from debian.me (subs28-116-206-12-49.three.co.id. [116.206.12.49])
        by smtp.gmail.com with ESMTPSA id ju10-20020a170903428a00b001991594d783sm4982267plb.302.2023.02.07.19.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 19:02:08 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 2CD6A10558B; Wed,  8 Feb 2023 10:02:04 +0700 (WIB)
Date: Wed, 8 Feb 2023 10:02:04 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
Message-ID: <Y+MQrB33TH8NxK+g@debian.me>
References: <20230207125618.699726054@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5GvqER+TUurvWIAH"
Content-Disposition: inline
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>


--5GvqER+TUurvWIAH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 07, 2023 at 01:56:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--5GvqER+TUurvWIAH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY+MQogAKCRD2uYlJVVFO
o6ARAP9n61msPuqELh0EJq1OflA4UmYoG7WzN4E8R2ejNFECRgEAufEoTChhbKqn
IKCAZYTNPeyuLUPJgB8QSD3U/hwIBwI=
=srVn
-----END PGP SIGNATURE-----

--5GvqER+TUurvWIAH--
