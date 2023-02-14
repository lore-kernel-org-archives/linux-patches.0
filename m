Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD417E
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 03:04:23 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so14149654pjb.5
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 19:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FDSS6wHw9ey9wN//WaBYBsKB8pK0RtnNk3ZwfF++dV8=;
        b=bjhwSFd+U4KV/bzWiA3ZoQNrADpYg7eEZ/YV9sHK4AmcZDig1/wNYCop7CuTM+jxSZ
         5IiD8iLdluBFtnl7Z8Rto3qK7XUgZG0Zz+TMQBX8N5fZDaLTPgYBVmL0PRKxOWDrvnag
         OVuCyb/Qey90ifvHOfLGcSK85Y1oa6O8aihv1nM27EG+HjqR+J3486MkQcdccXIVXTXM
         8UOJqHxa+jPzC1tspt84IgBBIKTSH5SxgvXqxkoWW0OkP9KSA3Da7F5E59hZOcA5e1hB
         ZQo1ckxfg4Tw2OLhCQQ6FEXxcOlFlBTXxc+NUerMJq2RhmWktZTt1T1kvYp5KBX/V7ja
         QbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FDSS6wHw9ey9wN//WaBYBsKB8pK0RtnNk3ZwfF++dV8=;
        b=fbMGbt98ngjsDb/L1F1IwUcKuMrDJNqRlQu3qlnaZHevB/RdQL4beHLr+KZJ+Poh5K
         tr37/IQE+H7jTVPpBW/2orPnvujf/PgmSpOjunH2QWiy0CR5vgwQPWO7p/zcGRDepuEH
         Vr98ZCEo1Tg+le73C6goE8UEgrayPOPAnqdhVWMAs7PEDEdic7XE68ZS8pPK7tvbfEKg
         +Ns2ozrBw8b74tzfgga+o8v4aXwcthr8Builoq8XgYQfiShXwyb3Ie5Wdmu0WPOb9i6t
         eyVCTNTIHD0mMYoWy9tnn2nbZ90XkbRqtBzFEv+sXU6qIcyFEoAZzRBrWPyyjr9bnVvg
         rVXA==
X-Gm-Message-State: AO0yUKVka32JRS8LFXFZmBfR3M74UtPHPGkjM/oM3zExnZugF9Jx200m
	kUcaORTrQQLjME2qxCTa8H4=
X-Google-Smtp-Source: AK7set8+8A4GdRfomRat52Sxyuo/pYMtcyROWiFqW34b7AF2S/3Nc6zunxbqUArZwbqJL9aC5IdkkQ==
X-Received: by 2002:a17:90b:1c8e:b0:234:2579:e25c with SMTP id oo14-20020a17090b1c8e00b002342579e25cmr615273pjb.44.1676343862976;
        Mon, 13 Feb 2023 19:04:22 -0800 (PST)
Received: from debian.me (subs28-116-206-12-37.three.co.id. [116.206.12.37])
        by smtp.gmail.com with ESMTPSA id cl14-20020a17090af68e00b00230ab56a1f3sm4327816pjb.51.2023.02.13.19.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 19:04:22 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id A5088105423; Tue, 14 Feb 2023 10:04:18 +0700 (WIB)
Date: Tue, 14 Feb 2023 10:04:18 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
Message-ID: <Y+r6Mhv6PS1EPELd@debian.me>
References: <20230213144742.219399167@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JMoLuklacFO66+7l"
Content-Disposition: inline
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>


--JMoLuklacFO66+7l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2023 at 03:47:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--JMoLuklacFO66+7l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY+r6KQAKCRD2uYlJVVFO
o9JqAP9m9IoW25yZ/rhfeSuiyGtKyh3KDcyBoqKWyI5lbtrtWQEAnDI0idIcoNtC
Mod99G5KHML/9xFQPhJsntmDfxCuMQI=
=RYbc
-----END PGP SIGNATURE-----

--JMoLuklacFO66+7l--
