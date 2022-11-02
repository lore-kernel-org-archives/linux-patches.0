Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E387ED
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 09:30:02 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id k5so8119471pjo.5
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 02:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5nsIzuIYmRPwf1ZuO4FYaaeeY7t1Mz4FhjUozOEED1E=;
        b=liDPQwXxbtN8tnlF928S6zo7C5ZUgOLaTZSYzJ9uugzNzBBd9S3RIcwNRPrZje2WEK
         F+WZ6zrQ74pDDX7CKEp61Eqt0a8kBY+Enfm+/QJZqjgynN3ZR5TN8QbCptzp2ff2v5gb
         Eh+//Yqp1ogIeXLLTrPKfqkUiz02f3S4rRb2fjJotHxm5XybNVWdWUMp2jXiu+aM95yl
         0XACOE8khe1AqTP8YPEPLUJCPiAoeputnKTdByMuWINvdjIFES7OWcXhrJkcpIjwa7xJ
         TTBLxy9t+7m3zaLZKTaHOw65+/pjfGqen5ktXrA/jzqDWyutdCALBVEGt4/SEOWFuMW8
         x5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5nsIzuIYmRPwf1ZuO4FYaaeeY7t1Mz4FhjUozOEED1E=;
        b=dvUU5TtUlkcnqs+FXg51EsbUOmw3hrbfgtZLjZAWBUj2DQzBwVs7yiRSr1gOECfcvw
         21gRKeweCq4NnpiKinID9a3ysOCmszotEwDfd8XD7l1em6mpcK6J1wYbAJbXt0sL3vuc
         IdAYJFM1gxzx41O/csETnfsu9AHMuwvPuwZruXx4SuS/Uy7qX4WuYji0chW7DDa4XndD
         UO5InI/a+AS+63xXp9byvIwa66PoRF6YS3Vr94bBJAiI9m4fkuD+EnPHgfwe502kyv1Z
         XO6PBl9rdH0ODNimE+CodbCl/VAcHGWgNgE2VbBuT7GVE08lesvdAluGnSQlV6oV1oQM
         CF7A==
X-Gm-Message-State: ACrzQf1nwMvzdfDiqdLlEiEN6gr236GDtndWgt64caqFolEaFv4OSKFO
	lMyr8TS0A/MkjQB1DwqXFjk=
X-Google-Smtp-Source: AMsMyM5dVQhGtDNhyEZljMRIGBm1i3pVK/RxrQ5m6KQv13h3Z6dE975UeuFZluCHGrZ66+AO8Dtn6Q==
X-Received: by 2002:a17:902:ecd0:b0:187:791:ae9f with SMTP id a16-20020a170902ecd000b001870791ae9fmr21909964plh.32.1667381402490;
        Wed, 02 Nov 2022 02:30:02 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-74.three.co.id. [180.214.233.74])
        by smtp.gmail.com with ESMTPSA id k76-20020a62844f000000b0056bbba4302dsm7994036pfd.119.2022.11.02.02.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 02:30:01 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 577F910415C; Wed,  2 Nov 2022 16:29:58 +0700 (WIB)
Date: Wed, 2 Nov 2022 16:29:57 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/132] 5.15.77-rc1 review
Message-ID: <Y2I4lc3+R7duLVM6@debian.me>
References: <20221102022059.593236470@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JTBO09mxtFwK9BL0"
Content-Disposition: inline
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>


--JTBO09mxtFwK9BL0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2022 at 03:31:46AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.77 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20

--=20
An old man doll... just what I always wanted! - Clara

--JTBO09mxtFwK9BL0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY2I4jwAKCRD2uYlJVVFO
o8hKAQCG6KVJzVo38x3ygZsO5CnlD+SIg5aqrvVmUylKTXrltgEAt6cI3ZLhA/jN
XZKXmifVD79C2XscJWyMl0pSfbIPkwI=
=0Uva
-----END PGP SIGNATURE-----

--JTBO09mxtFwK9BL0--
