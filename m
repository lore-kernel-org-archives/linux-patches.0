Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968AA80F
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 07:20:00 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id fz16-20020a17090b025000b002269d6c2d83so3017979pjb.0
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 23:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tyXX4AyxJZrvIDihBdy9D1ggQzDWOCcjYGCt8mZqSWA=;
        b=DDyHJVnR3HxxlByRFbSSoJ8B5ebjtQ47R17SzoTbu2gAipqHLH3lfPsjScpXihkUpO
         gETDqZ/rhsHhcM3k4SRkskkzl4ExhXu/lNJS/IaPDUlHt8UCdv72gXCVKbGFuO0rLpwQ
         jX06F4FhngqfR1Laa8n02zVicTR9dF8FbCdeyHEmh45qDme6xrYZ7zOQPQzcYI/JSA1I
         /HNdT8cZZde1vO4aTEyiwczpBDTAB9jHjXpJsQZy6q5U/kn25KiZMsvj3ea5WPanyYZZ
         /Z10MG6x8FtYBsm8sBKx6TmNPeE67g3d6ifwvWZkVT6VMoV8zP6foXFxkodxDUFUggb3
         MSQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tyXX4AyxJZrvIDihBdy9D1ggQzDWOCcjYGCt8mZqSWA=;
        b=dSzj0F0/d62nSZzOWKRMSNNOUOloXusMKSnQj6VW7zAv0xUcE/RA1z426R7gw/moae
         /Uw48qDRO1wopHfHs4K5RQrNjjGboGyuwlVeWXQJzAQJ9ZiFdNVde1umwxCThHWfXIlb
         tEJmEUZgU769VS1ki9HjBAq2SLKz8BBaMTWETSby6akk4IaftVHJ0H9rPHb7jriTmRzb
         vA/VV++vB9oU4LF4CvZkbhqwHuR/J0FNU+BdEPlX4bVb5DWM04RSRBb0XWQFGDPijix1
         Tja1mwZEmU9gKug08T8NbEfQcSuGJ8hHOm/lp8kN/YsMvNqgRbmiirwjZwCY5fHFp8gp
         fAGw==
X-Gm-Message-State: AFqh2kpMSdbmUxeIKZRR5+ZtOM4KGLnIc6TJXm2W2HLP93nZduBiEFZx
	LfHzaif7WPS2EQxF5I8NtA4=
X-Google-Smtp-Source: AMrXdXumSr3epY+JKvm8FYT11rokQY1R1ynYbKzq8lbzaCzja9Pq+fQ1SrPliQt90YA6szOn7fJ63A==
X-Received: by 2002:a17:902:ce82:b0:192:fb92:327 with SMTP id f2-20020a170902ce8200b00192fb920327mr3559951plg.58.1672903200047;
        Wed, 04 Jan 2023 23:20:00 -0800 (PST)
Received: from debian.me (subs03-180-214-233-80.three.co.id. [180.214.233.80])
        by smtp.gmail.com with ESMTPSA id g1-20020a1709026b4100b0018853dd8832sm25223853plt.4.2023.01.04.23.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 23:19:59 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id A95F4100910; Thu,  5 Jan 2023 14:19:56 +0700 (WIB)
Date: Thu, 5 Jan 2023 14:19:56 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <Y7Z6HG7Ev5TdjGQ9@debian.me>
References: <20230104160511.905925875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9eRmogAvGQCRaEtI"
Content-Disposition: inline
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>


--9eRmogAvGQCRaEtI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 04, 2023 at 05:04:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--9eRmogAvGQCRaEtI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7Z6GAAKCRD2uYlJVVFO
o3BFAPsFn14C9cx+c9DC9DFQxGXyxDSZjtgy9Tx70BMTitxcqgD/f3qh7VKE4ek4
KuTw+wZh38hmXjysWUd/xEIm2A/eWg4=
=xoAs
-----END PGP SIGNATURE-----

--9eRmogAvGQCRaEtI--
