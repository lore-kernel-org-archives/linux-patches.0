Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2619F7E9
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 02:44:37 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id n14so20402419plc.8
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 19:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680749076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oZDEZxZL7BBW3xh9tIxL6hZNJCCHQuMtGQKbxKWBlwE=;
        b=gXeD6Y1fAewNZTZqhuvjTPf8M7+annlEk5SyhKG4YzNg6IerDS5oW0dwxx1Vfl6EwD
         LjoMS9paiU6K4Pjh1zdlZ+VN+Cbi8gF9w1ez1S2a7z/HaVvrTJL47B+s5PvXujiXEWz5
         sxA4KUrRfB/ZyXrDBXf/Gt9ARI4D544xNN1gy223K60kIOX0Ej0/RD13ollF8bnnKTay
         B3qaF19uqKiBdIv+m3Yk9uY1G+v/geK1VexXfqieQuAdptOXj3AoU2pRMVW5p7St/rhq
         VwYYHvnUFuAgdLT0igNdnAxaY3HikbRzn7uIwgu2XOJtTmLCqbF3edPOL/QA5Cxwj+f9
         4Rzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZDEZxZL7BBW3xh9tIxL6hZNJCCHQuMtGQKbxKWBlwE=;
        b=pn4mV0V5KIEedhw2XTylM0EdBs1xrAS5aFMT1Wit1XJl7Nwymv97W9AQf8oXfyF6y2
         KjK74NvxcnuHOCev5mg4iYVlJqtIqo/ekd+kv6yGOfIKs6j1qroEQVbF/1+Lyk1iCYFV
         mRp1MPNdUMIG/w2rkg0RRr2OgUSZlVPXbas9JZzXV2XmZp5fkgSRFabq+PUBwok77fku
         LWHKxAjk41G/A2wleWC4HJHDvdiH2n2HPDt8xgyTdE5nYDCO47nHcH/gLfqpy1leKman
         QzfDDcX+4i0OvwJ4NoHdTiXZOEwjcrhzrPXsAP5eM+4LAKAqfvrPhpZBq8qWxajDFHLV
         Zgyw==
X-Gm-Message-State: AAQBX9f7qUP44HyMmIug+zmvrSoivyTtVr6wZfMfClPvF66RPC0W+piH
	WQJFVCJ1Q6Geaz0uGvRaYZE=
X-Google-Smtp-Source: AKy350aaHoTNYvn3xjIDtrcygA6BrWrs2uocaFRjy5+25cEqn3vExzxr1gA8HlF6UBePIz15UaJLYw==
X-Received: by 2002:a17:90a:8281:b0:23e:fa90:ba37 with SMTP id g1-20020a17090a828100b0023efa90ba37mr8394686pjn.49.1680749076239;
        Wed, 05 Apr 2023 19:44:36 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-14.three.co.id. [180.214.232.14])
        by smtp.gmail.com with ESMTPSA id d14-20020a17090a498e00b00234afca2498sm1988964pjh.28.2023.04.05.19.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 19:44:35 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 312F31067E2; Thu,  6 Apr 2023 09:44:31 +0700 (WIB)
Date: Thu, 6 Apr 2023 09:44:31 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
Message-ID: <ZC4yD2ts7JRPjsSJ@debian.me>
References: <20230405100302.540890806@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UjSs2hH9lS8IKAD5"
Content-Disposition: inline
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>


--UjSs2hH9lS8IKAD5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05, 2023 at 12:03:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--UjSs2hH9lS8IKAD5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZC4yCgAKCRD2uYlJVVFO
o98AAP0bADVBrvSx7OjHQkW//t9JqaO/Q/GOFj/F4ZojjtT6ZQD+KWtCVzNpUtnX
wc71snwNTeR2wNMk3DQzt0zw9S46rQ4=
=SAoo
-----END PGP SIGNATURE-----

--UjSs2hH9lS8IKAD5--
