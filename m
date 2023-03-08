Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85E27C
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 09:03:39 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so1579762pjg.4
        for <patches@lists.linux.dev>; Wed, 08 Mar 2023 01:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678266219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J7rT0YVbd83CrVSWcRxoFWFor/uPS8qdQdsIn5lctSQ=;
        b=J+n8BcGDjEsRoJ9OUv1LkI2mUe6cYkmz7x/vWhDCbjKHUBvaE7GbKy8l5frTdQxnmp
         7kW0tWbz0UCmB8bDyJXROUa6mnZsNmWjzorLfixDtWwTWeieLKL/r9p1/JnLf1QvHMRn
         AtQr8M+GnBkKSi/KMMdkFTUYpa7XtMQq8Kx8Tskg8gWl4E9Dder5vX51hP8k/O0i+04Q
         wv5aQd7YG61f2sdUuXCja7FHYuNOVB3yKgzSmBAjaSxp8pWY9ue0+S9kvod+Lcx4fR7n
         ckZzh4s/v5sg9v6DITseLQPOryAYFrukiorFpOSqREhoV3Vat/6PV+zrY+G3Ti9C89sy
         T7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678266219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J7rT0YVbd83CrVSWcRxoFWFor/uPS8qdQdsIn5lctSQ=;
        b=kbF+QK1RKsfsqkLO8HQ/mi+YO6R7pbUsHKD5vTh/YowzQsPLjvD38tuWFMF5jeRUAI
         HiyQEc1RFLQ66/9MazjQaiyP3pBfHDb68bS0RPRa2hwx+rxKkVecCrhc+4a8q2XWGA53
         neAP2iJ5HOBvVewxlG8+bJ9gQDku6vt5XnbzdrJa3VUiTqUo/8KY06vAjyC1k0BWyd0H
         7cdVz3BtE4v4o1nBVqHtubhjOS6IAgaR0HjkNKCAW+bre/SnVIGcuB9Y2cFl3pojKXrW
         wj9HQM8gqax1wMpJimjAJGpg5B5JXH1JvikwUk7uNpXUXhjVAo9WsszMKYoIu61Hf7/Y
         0Tjw==
X-Gm-Message-State: AO0yUKW24palCJds9w6E/EGFXImG+228xpQOW4eD9l4tSxq4KFWe+WgC
	Q+Iosxn1LDcO3BZwE4jimcH0uFBDFTE=
X-Google-Smtp-Source: AK7set8/37WQTisw6yJ/SwIohvmHOjGRZqEZqd6Ya3St2U/DvkCTsRPo+J/kl2UHH6UYBxT0IrzxAQ==
X-Received: by 2002:a05:6a20:69a8:b0:c7:7d45:50fb with SMTP id t40-20020a056a2069a800b000c77d4550fbmr16362644pzk.28.1678266219091;
        Wed, 08 Mar 2023 01:03:39 -0800 (PST)
Received: from debian.me (subs03-180-214-233-16.three.co.id. [180.214.233.16])
        by smtp.gmail.com with ESMTPSA id p21-20020aa78615000000b005a8c16fcb78sm9028264pfn.56.2023.03.08.01.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 01:03:38 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 58A1A1064E6; Wed,  8 Mar 2023 16:03:34 +0700 (WIB)
Date: Wed, 8 Mar 2023 16:03:33 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1001] 6.2.3-rc1 review
Message-ID: <ZAhPZYfb/dZEUEfz@debian.me>
References: <20230307170022.094103862@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xTpkWPY/u/T2Ll4a"
Content-Disposition: inline
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>


--xTpkWPY/u/T2Ll4a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 07, 2023 at 05:46:12PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1001 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--xTpkWPY/u/T2Ll4a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAhPXQAKCRD2uYlJVVFO
o5ZuAP9pIJnuY4oRsRFM8QzxdCqqbv7vl0il7VLcPHxx5uLFowEAl3OlparCA1Cy
WmT/I1oZmHq7TpMaRPlVQB7zFDZjqwA=
=+mvj
-----END PGP SIGNATURE-----

--xTpkWPY/u/T2Ll4a--
