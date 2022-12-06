Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A58256E
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 08:26:59 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so17324820pje.5
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 00:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xW0qv9B5+yGxi1H2usCQCP9mQhDaha3ttXysqpYFwiM=;
        b=RWqjk/BXFmfFYxDsYol04Jmm0CeChfX2tO64fKfWjMuGG5AxcA9H8uf4Ksnf//U/qH
         HckTmJT+rsecvvKOSoTVktuED/KpsSE0gr9OAHrVl3WcNNWOrkH9QXBdh4U52YI6X0X4
         YgPMbCfCD0X5WDhBoA/XIsbUs/nyz9SIAx08tfv4gCc9p86CgJTN1toSswKThMRLwLyp
         4/+r64DJgyQU5hknC7ty6rna8kIBffaz0xvYepM7cImKaUFPXpF2ws9Zih9fmTB1RhIP
         GRrnt/L9GLLRQOygyCzplUN8Xq94QyBUYDvS0a/22OV5yxCh06qe8hByy+6RBVcfkBBW
         41bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xW0qv9B5+yGxi1H2usCQCP9mQhDaha3ttXysqpYFwiM=;
        b=jjXI8ImqoWdjebfqTUnvssElOd86Pnb7yZu4WJAUPxUssu7SVIt0D+oOipi+07s8E7
         yQHcbRLWwzaZQJSyCtljt/wqDQR9o3Z1UFcFBYoSnTpJzID/n3RwHmTV/WoCuPWegh7v
         mO2EDZhIG+2UR+w9XbOKscoIUGfDuR3/r7n4UIYVruPkkT7/oX0VMihtlJfNWcp4GTbd
         86Dy46jOWoczyaYY8MicgMRbN2JHCS3ciylrIveFkiitaaaDyrQHOSij8Xwdg6xD2D4/
         vNwpcHAMnCMaVHX/a8yUyLeBfzfWJgrQA/470Kc5oN4I6Cv7eJYn7dLYYu38O3gh35A/
         TrAw==
X-Gm-Message-State: ANoB5pmn7SLYoIiTrwyk3A/vAOKZyujRJRlXb3fk7GGKkrtTfQl/xsjL
	WWxN/wF06qGO7VB8dMPzMjU=
X-Google-Smtp-Source: AA0mqf50xOkxd2Tqua6cu4Vr1W0k+sVXxQvVw2wZ2VyWld8NR8SBV/KcCxbR24+f0y2w8HOrWguVNQ==
X-Received: by 2002:a17:903:2681:b0:189:7e2f:d66b with SMTP id jf1-20020a170903268100b001897e2fd66bmr46941097plb.110.1670315218711;
        Tue, 06 Dec 2022 00:26:58 -0800 (PST)
Received: from debian.me (subs03-180-214-233-3.three.co.id. [180.214.233.3])
        by smtp.gmail.com with ESMTPSA id jf1-20020a170903268100b00186b7443082sm11936428plb.195.2022.12.06.00.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 00:26:58 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 8DF511044D3; Tue,  6 Dec 2022 15:26:54 +0700 (WIB)
Date: Tue, 6 Dec 2022 15:26:54 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/124] 6.0.12-rc1 review
Message-ID: <Y478znRWhzjlTdHN@debian.me>
References: <20221205190808.422385173@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JCUFucPrhAkQEawz"
Content-Disposition: inline
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>


--JCUFucPrhAkQEawz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 08:08:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--JCUFucPrhAkQEawz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY478xwAKCRD2uYlJVVFO
o4hNAP0a2W+sqrN0HF7z0dWZ4Fad9dSGfr3X+ISCc66H50xZiQEAg1sQzBXK7+yL
6bgCKeWFAQrUeNzsjEZzY0NcDORFNgQ=
=ILX0
-----END PGP SIGNATURE-----

--JCUFucPrhAkQEawz--
