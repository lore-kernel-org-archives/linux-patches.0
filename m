Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBB610EB
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 04:10:27 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id ky4so4834556plb.3
        for <patches@lists.linux.dev>; Mon, 20 Feb 2023 20:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lXyOh2O1dEJnjqw0oc/4l4klbePXdkEgK9fd88+a/14=;
        b=GZVuSZKwNkP6wAXsWXjVlb2muEXBGY9KNOS40zvN1LlFahjUvM+aVuaBRBoLuWbvTl
         Nn1AqEmsqPbsjG1eUpwBWZ0rI1VTfnZjnk78xnMNkxm2n+EQjhIDU575N/6mL+Zb0+8Z
         TTwvp/SXd4fa/LphYvilqnSnSVljNMhTdEZZAif0BYLcmrG55W/eMleJkLXH55J2INP7
         0DFr5ffeSC/Ilvp6iavY6pLoLJUO8+JC/p6oTqGmyhvnW+FSTZCnome5gcIWqZorUufo
         G0fErA/qlrr4khbUQy4FXhSt+NcwBiuJ8KF4HXJqP4nLvFCPhrdVxNdvAFX48ixmoEa/
         iKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXyOh2O1dEJnjqw0oc/4l4klbePXdkEgK9fd88+a/14=;
        b=7/E5tged7iNhR1n/8c4prX5eKI4QfVXA6RZONrTtUOnNY6ZfchDBUwQDcim2zJavaI
         cgyavjh60BWzlEu72Bv/mbQZg+jt/JiTMAyl0UfazwK9BNMrl4LvqBF+VlbUvywYUf+I
         6qHjhYSdVp2lLnBAvozGnyAn0t+5t1tMHstzMEOISINQBjCfDalhA5RmyPtKNz4vMArU
         JcWz13WbIHKgTvK2/KEDf7ILUY5Oo2SvNeXRwDqibPsyXvv7fyX7zjUXa6vo5Gcf4nAA
         oTLKVdL2cUHHRMwBTTtpX1vUbOa/73rsz9z4T0/VLjWd3r2M5a25oow21Yo/45+vF+yp
         pv/g==
X-Gm-Message-State: AO0yUKUsumBtW4wmYiyiH7+fILIRYFu8SI7QQl9wKG2u4iL5SiQ0NDWd
	N/JCCXLMWNYe9ns6hVwSSQU=
X-Google-Smtp-Source: AK7set/7F2MOp2QnZqhMrucReUtUIlX6KUK5DW0wQnKJWjeznQmP3a00u2fH3Uwms5eN+oHRr4T4nQ==
X-Received: by 2002:a17:902:e5d1:b0:19a:b4f1:a847 with SMTP id u17-20020a170902e5d100b0019ab4f1a847mr3143353plf.8.1676952626812;
        Mon, 20 Feb 2023 20:10:26 -0800 (PST)
Received: from debian.me (subs09b-223-255-225-230.three.co.id. [223.255.225.230])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902c1c400b0019a88c1cf63sm108073plc.180.2023.02.20.20.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 20:10:26 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id EB7E5100981; Tue, 21 Feb 2023 11:10:21 +0700 (WIB)
Date: Tue, 21 Feb 2023 11:10:21 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/83] 5.15.95-rc1 review
Message-ID: <Y/RELV4ktxMGtBEn@debian.me>
References: <20230220133553.669025851@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HK7sqjx6A7ub8tOC"
Content-Disposition: inline
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>


--HK7sqjx6A7ub8tOC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20, 2023 at 02:35:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.95 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--HK7sqjx6A7ub8tOC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY/REIQAKCRD2uYlJVVFO
o9e4AQDf2EDmOgDW9C8nNuVq2MwBbyrBWCn/2qhVvJ1axc0I/gEA5IFoszDSs0Ps
SqfrQOgTCChE1yLceiroWVWQ7ONAJQ8=
=/vMq
-----END PGP SIGNATURE-----

--HK7sqjx6A7ub8tOC--
