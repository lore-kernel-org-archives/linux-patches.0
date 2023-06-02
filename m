Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CE714286
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 09:01:13 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5346d150972so1716371a12.3
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 02:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685696473; x=1688288473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FQmDZuz51pdsQD5VZZckL893ovxLX5KE41c163666Jw=;
        b=T3F9QcAU4PSgra2G3adC2lpzm+QLxPR6QpY2g0TFL3FHwkfkx1jLZOfGgZXmc/c22V
         +K7WM1qWvQt7pB/fm55ZcpJPO9J5CeZSSLKQLRXTSQEYRYamH93s/4Vs19rEeCRm9hW5
         aRlHic/N2nH86nQJ4WU1xAecrrScaipUOfsuDzBXlMGmooccQjmjNmMQsDCljvuupQZD
         RN4lKuqVg5aJSgDOOAulKacth4vhcOz7/sKdwCzQFWVzZbAN7zpUCIjVDpUutLyxaVgD
         Th5ui7JbAAQ2Bz/9PpTsdoamWSR4arZ3rHhtCdSRZ371bgOCyobcSqwFxuF/FGIxjY76
         DWlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685696473; x=1688288473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQmDZuz51pdsQD5VZZckL893ovxLX5KE41c163666Jw=;
        b=GxE3UQGxBrN9rsZOBR9/mvQruMPPe/0lv6HbmNt+F1ETVajzeFrMTxYjh6f5Tx31Am
         dHVAJ9Xd5h5JXDwc3Yd3QlOniPYzRyjKDhSUNrpvm6t9QrT7jhfm2y/kSKSnm7pbrlZH
         nwFZVdlDbxNEuwRaiNII2CkaraUblQkLDSSTyOEpbLNTofKA0EG6TcE0nGtvctHRCJSj
         IvThB30W12ZjF6VfQn4e77/A4PJTvBydTFuLOiH/tg6G0RtZ7suoxAujoQxPGb0JrvK3
         XhJXEPyfpvy0nxqT2ceVbtS3GJjyK6fkGgvi/0/Jc/QDbAsNPmW6ysiPGYjNAPFAUnwf
         5mwg==
X-Gm-Message-State: AC+VfDwM7SQLHRRW2fD5+hy9JPOWx1AE+S/tbWnvuE0qvDsFRXK/fPMJ
	mR3GrmNpWmMS6gtbEuSY0Ao=
X-Google-Smtp-Source: ACHHUZ7i3d8OCsl6CoFU9gNyQDFsEKsuLTVb8kPJkRzYiPumurV044GTpK9HAooU1TXCrmZ213GVRw==
X-Received: by 2002:a05:6a20:7486:b0:109:c161:a679 with SMTP id p6-20020a056a20748600b00109c161a679mr12965246pzd.19.1685696472878;
        Fri, 02 Jun 2023 02:01:12 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-3.three.co.id. [180.214.232.3])
        by smtp.gmail.com with ESMTPSA id b7-20020aa78107000000b0063f0ef3b421sm632776pfi.14.2023.06.02.02.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 02:01:12 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 468B2106A05; Fri,  2 Jun 2023 16:01:07 +0700 (WIB)
Date: Fri, 2 Jun 2023 16:01:07 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.115-rc2 review
Message-ID: <ZHmv0xaN146efJL7@debian.me>
References: <20230601143331.405588582@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3DdP6FizpbllIged"
Content-Disposition: inline
In-Reply-To: <20230601143331.405588582@linuxfoundation.org>


--3DdP6FizpbllIged
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 01, 2023 at 03:36:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--3DdP6FizpbllIged
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHmvzgAKCRD2uYlJVVFO
o5QXAP4tyPXNMNtVXvnAjJVWKrA9cX5E45kp4F85WS0q8/9CxAD/dxHd0kptAQwE
42/8HS6VDHOr3uMKn7ykccIfT+/8rQg=
=C1tp
-----END PGP SIGNATURE-----

--3DdP6FizpbllIged--
