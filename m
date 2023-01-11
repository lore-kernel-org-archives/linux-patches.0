Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5990C28EB
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 13:09:56 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id c6so16740776pls.4
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 05:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f5DOehqdP3l1+LWA8SeET95uNDOWI0vbHwlUXdSlubc=;
        b=A65qp0YBogZFd3pI1JDC1BkSUt/qWsLJxQAVM3OhY+W9MhKg/ETNw8NKUXdpuwwO0a
         lxdB6TfiWoyR1eGlIx6bHeWdILpLZAEKgIxyHCJBgXom1pQQz5Gf11KQrfEwgLBwDnbG
         aLuGSRkB3DW0D9bzNs3/+LAu6YzZoahSe8X7mw1TWO5penar0J/yTWqiIgwnsS6VcXcp
         +UuFMuO6z+pMOeL23AV+ofMyBtSe2YWrq6fv4ZfSKZ4+nCb9CHpQjj89QhmVS/C7eUu9
         kTPYX4qZKfil9/ji2DLopwpnU08eDfE7GQm7xTrVflNT9hiYfGkUZXjJSLxExQVMy9/P
         mpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5DOehqdP3l1+LWA8SeET95uNDOWI0vbHwlUXdSlubc=;
        b=V/mZ1GQNoGsJoaqmHqwFU7rKJMESOXwtIRdsUAgKWv2EPUvrODQKtOIE2tmK3UNUpA
         Mxmzro4wskvFxGKsPCBdSFgyQdHfVnx96QJ24jDoOUd2tpGIzL1NBt/MERgqqdvLp6Mo
         fGENvSYXh/gvXMivetM7RnsGSMbhStI+3Z8z2DjLZhelpVgHCZD15VzlZ7CakUQCl1qv
         VGgNoBfj27f7tb/xFtzsz2ryn2zwYBNcCMNHynpS8rSJ3+j8UP5mFnvvcJey6DFz2P44
         HIBrX4SEpqZRts4yhzq9gV5fxlzMS0GqfNP8oyWtl+Nty+XLFi8KLolXp+RtcDLJUt8B
         lLuA==
X-Gm-Message-State: AFqh2kqMdzDpSS5EY0F2Gk14tTvnN/WJq0b6CDLGhJvFMnOkGUXIemon
	fQzzB+U/t+YFMdKwUUfznY4=
X-Google-Smtp-Source: AMrXdXvEHF2ENqXJEuIA0B8Lipxh1EJK2BFDUMyPeBRamWJnlPAUpni1GZLeu5HBIoE6ZPsu0Ti7yg==
X-Received: by 2002:a17:902:d50a:b0:192:d5cf:ab7e with SMTP id b10-20020a170902d50a00b00192d5cfab7emr43956760plg.32.1673442595745;
        Wed, 11 Jan 2023 05:09:55 -0800 (PST)
Received: from debian.me (subs02-180-214-232-16.three.co.id. [180.214.232.16])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c20600b00192fc9e8552sm10233394pll.0.2023.01.11.05.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:09:55 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 9B9DD100074; Wed, 11 Jan 2023 20:09:51 +0700 (WIB)
Date: Wed, 11 Jan 2023 20:09:50 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Message-ID: <Y761HnGVAuXrWsQ/@debian.me>
References: <20230110180017.145591678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="q1pl3LCTnzLm6bHc"
Content-Disposition: inline
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>


--q1pl3LCTnzLm6bHc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2023 at 07:01:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--q1pl3LCTnzLm6bHc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY761FgAKCRD2uYlJVVFO
o4BaAP9nGSFamz/NklVmNV2uCJIz037RgniS1Q52JiYAF6DeeAD+PfHYwR59aMM4
hbYw50kQxuTrp5rJJFI4HXEs4+pH3w0=
=3ywp
-----END PGP SIGNATURE-----

--q1pl3LCTnzLm6bHc--
