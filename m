Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E53A4F
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 09:03:52 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id p24so10723698plw.11
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 01:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WESsZuzJV1dAx7+aN9jSf7iCBxgIoRzQOZDBKmCzdtw=;
        b=RR3ViW5YU1+SQdjA4chAIWv7hcdqlUCrzpD9Xt9VqPnJoqMF9sECkRg45umfIKVfoA
         ufED1owxsRzO0IXg+qGSedaqwcWHZqCwHzzrXvEOswlaox/DTwQbz3hm+tpti/DtXKkh
         w8+WxmWFWiaNY+CT9+y/tEB0lpBrOyuJCLkF3wudp+2ZaVcf3IdVjDVAAku7QFWU6uUK
         5wpsED6tsAtBksz5hYSAqKXrMmU2nUloDxu+CfMXdxLn2NsEJdF3tyZGqHKXrjlhJFJt
         ipuPuI71hafA8F6a10RTUQdqKs7WcsKm9NI6YpDnRrinSr+QaOtpKxIfetv3XJ0wOeFz
         HeJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WESsZuzJV1dAx7+aN9jSf7iCBxgIoRzQOZDBKmCzdtw=;
        b=g7npbUXWQcjhGnU7MnA24CXge3PrO7HqcZJKpYs2gtBxWhyj5raDMXcKSMqm71iPCs
         +MyBxZtH6CwxKDdv7Py3qOMXQVQsTTWubkuQ+lr07+n/wV6sGy+4pT1hGioWJw3dpqTK
         S65GpH/XHJvmDLnIQrlVyaUjGgWXbipY64Ow/T9wBLbBkIVsHpfAXvX7q1g+gfFAiqd7
         66DbF761/++XH/eMuvH8+AGzFku7AlkADOpc6JY2Zudawuw9pJ5j50CGak//2mj0b13K
         bv/xhsLrjfiaC0MSR/nKAR/6FcM3gQLNstbK6CFbzXkuVgU1xAgMGCXEMNYi8dR13wAx
         dwyQ==
X-Gm-Message-State: AFqh2kpc9cInrWD7cds3ncRvapuT9sok5ryfch+yATPCSW+BHduJZBYc
	ILRD8jlcSqBdIVZQ3FxRUww=
X-Google-Smtp-Source: AMrXdXuqFbGb1Mh2D0G/HFfZD7JQY2VbSVrp7/K5OHmhOpCnnOL6+m5uED29yN2dpwJ6c+aiZyWG6Q==
X-Received: by 2002:a05:6a20:6913:b0:b8:8027:13bc with SMTP id q19-20020a056a20691300b000b8802713bcmr25021230pzj.8.1674464631967;
        Mon, 23 Jan 2023 01:03:51 -0800 (PST)
Received: from debian.me (subs32-116-206-28-53.three.co.id. [116.206.28.53])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902db0700b001947b3ec2d7sm17309364plx.307.2023.01.23.01.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 01:03:51 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id E61E710504D; Mon, 23 Jan 2023 16:03:47 +0700 (WIB)
Date: Mon, 23 Jan 2023 16:03:47 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <Y85Nc09Soi4VIj5Y@debian.me>
References: <20230122150246.321043584@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zGnh1QnuMJs+SKK2"
Content-Disposition: inline
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>


--zGnh1QnuMJs+SKK2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 22, 2023 at 04:02:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20
--=20
An old man doll... just what I always wanted! - Clara

--zGnh1QnuMJs+SKK2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY85NbwAKCRD2uYlJVVFO
ow8AAP9JsIEYbc2FDcGb7BU9sSq7AxlqBDwy1eB0vaFt2MjpzgEAq3HCLRURsCbG
4IJLuJ7bXZgwRGT+AZ8aWvfy+WFqOAQ=
=yCuM
-----END PGP SIGNATURE-----

--zGnh1QnuMJs+SKK2--
