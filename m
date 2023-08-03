Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5FD187B
	for <patches@lists.linux.dev>; Thu,  3 Aug 2023 02:49:41 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2680ccc1d52so220506a91.0
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 19:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691030981; x=1691635781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hBogplUAA+nKuf7eUAZsuJx8HLVlmtv2tCxRNycul38=;
        b=ebErbLIg2BJu+QDjNPSbHnNdKfO5DxcBcUX+DExlOhl0PNXJSdTnhrKzGL9U7oC45r
         qnnhTt8kM6icxpZYQIDBDGYuhC7OBof95fR/+3bOPi1p/sUkmq1apMC0okIlh6Jr6xAt
         5TSSKP/mY6yymSPIai39RtUVB8p8kCRorMAVMrSQxXDKz0vWVFtVfFIk0hbGXvYkRJpq
         PuTDjmfe+iSRd1wq0iZrVFN6qTVo+0saEAzOghewOp7/6n5NvkQPw3NAu+PdSbQ+e57e
         4wSZtms7IbzQlEkQ8S1j5ER3IQnEPBapM004pd4NFbfMEgL6dgGbWbXFGHEvet5lSFqi
         sQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691030981; x=1691635781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBogplUAA+nKuf7eUAZsuJx8HLVlmtv2tCxRNycul38=;
        b=Dpjw5X3z9XAFrz9EGCMN1ssjf4z9OLHkOc7uitMliOsL1OJ9I/KPjgeye41eH9pk2E
         yYnhoK1RObL1h6+4mlRU4DF85uLOI25vQRXWOx7tsD4Xr3AFI0dHo7GQveej1PV5Bi5E
         H6d6v8NIqksWm8uqwKgx8jJAxKTA4IlmS4Z4Xcnj2pQq8zjL4dHu0M/z08weNl8jVAQv
         A9MlQWmdRrrq7IQkWtessekR9RKsPZHLYysFHZdm9lZzVszRzZYzhZBKfK4czM5uJqBQ
         TYngFzIE+MNyfSxArAaRZEqqfuU50en1/7ABxmS+ClnYhdMdgtAuki8t3ptLEmHprqyy
         Vm6w==
X-Gm-Message-State: ABy/qLYRUDm0/n0IB96JWxlEcRW7rd+sx1kGiSbgk4Chc5j8tUmuq1bh
	Er3Ehg2PrcjcM/LX2USM4EQ=
X-Google-Smtp-Source: APBJJlHgFldHH9Meu4s8csKDGJ1q8PlwRdyZ0cBqq4ZPFQWsotvHtfWRPQ27hJpZRQEsVlyRVnsGhw==
X-Received: by 2002:a17:90a:6885:b0:262:ecd9:ed09 with SMTP id a5-20020a17090a688500b00262ecd9ed09mr14995562pjd.33.1691030981035;
        Wed, 02 Aug 2023 19:49:41 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id bb3-20020a170902bc8300b001bbf7fd354csm9323535plb.213.2023.08.02.19.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 19:49:40 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id E3E738BF27A2; Thu,  3 Aug 2023 09:49:35 +0700 (WIB)
Date: Thu, 3 Aug 2023 09:49:35 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/225] 6.1.43-rc2 review
Message-ID: <ZMsVv4+DAiJOdm4r@debian.me>
References: <20230802065510.869511253@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RRio+N2QB63cqjUu"
Content-Disposition: inline
In-Reply-To: <20230802065510.869511253@linuxfoundation.org>


--RRio+N2QB63cqjUu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 02, 2023 at 09:41:55AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.43 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--RRio+N2QB63cqjUu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZMsVswAKCRD2uYlJVVFO
o0LrAQCtlROqK56I9iiFxy9mMNxYw89O7krhQ/KGGOthCqHOcgD+LY0YQKXrP5aO
nEC+ETC2er+yNJ226k4p/A/wnoK2mAY=
=mFvq
-----END PGP SIGNATURE-----

--RRio+N2QB63cqjUu--
