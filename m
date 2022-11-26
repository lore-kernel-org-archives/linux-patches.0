Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6127C196
	for <patches@lists.linux.dev>; Sat, 26 Nov 2022 08:55:57 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id w79so6047361pfc.2
        for <patches@lists.linux.dev>; Sat, 26 Nov 2022 00:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mjCyoWb61wdL81qcmSTAoCdIWg/CnPBXU24aGBaxwOM=;
        b=GKxrnlQLxkL9Zl+l/xPdpODXepbcFe04+9KhbZqPCrUdhirdjzECqRG7Bho21ovFaz
         I3YdMsdsZ0fbxpGtE1dKZEo6AjHoQ7zitma0vg5XFFnDExCg46EmBf0bRbi3EL8NMZ0V
         xXCMos5IWLsaEHb0C4fGPnJBSE1smSkBJSFZwclaL6iMbo4nxn+i1Q56kXkPAJ27iH0I
         YJ0uzsFlP+jOpDIbuiYNAhozku4OuzTGBZXerfPyPFesLfuaQecUDwGpyyZ/cuIKPyMd
         sfxV78V5uXlyjsd7gBEwWgODn6zHnUHDZemDrk+QU3FdTE4u6jlE6f2YELumG+BvZJET
         yhaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjCyoWb61wdL81qcmSTAoCdIWg/CnPBXU24aGBaxwOM=;
        b=jb0GrN5HbR1LmZTSX2PC5ZZVqDJBP30hUNpHBobHNCK2w4au2dMmNlCmrhLI7xdmYn
         pyvkzT68ZY9dKxahrQ5ioGfpuT7/DRwqlEX0E8vExCDSEr5DSgBhAiOSrWGg+749NInp
         iTiUCL41FmD3uyGHetALwqlc49EpIn2BJjo+3Qap6ygaDLIZEbnc4cN+4KjWD/hisSuw
         Lk+vEEIe1E3ijOm5RuPJnma6edsm+dlRK2bDbJ0NBDtT2ED1khBRPSjaqBMjZU/MjbbH
         1IVSZZYjT1GDxYEnNBz8kvt64ZOyhPuZ7hKdU+p4nnTMuIxX8d4SZnT+5tgBFH+4B5zY
         56vg==
X-Gm-Message-State: ANoB5pkvIBxEg5QPcDHj8syd+Qw9rfJz2h6TZDvSNhX6hxWtG2CQMaoq
	tEDjJKbuC9yIslEPPG4o4qo=
X-Google-Smtp-Source: AA0mqf46aOZen8tAGbErQ9j6rmqHuNqXcVcwUnho3E5t1ejjZqVcNErb8tzEMFzSlpfLszqPUVgv3A==
X-Received: by 2002:a05:6a00:1d21:b0:574:a486:cb with SMTP id a33-20020a056a001d2100b00574a48600cbmr9339894pfx.11.1669452956727;
        Sat, 26 Nov 2022 00:55:56 -0800 (PST)
Received: from debian.me (subs02-180-214-232-11.three.co.id. [180.214.232.11])
        by smtp.gmail.com with ESMTPSA id l7-20020a170902f68700b0017f756563bcsm4892392plg.47.2022.11.26.00.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 00:55:56 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 7B41210436D; Sat, 26 Nov 2022 15:55:52 +0700 (WIB)
Date: Sat, 26 Nov 2022 15:55:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
Message-ID: <Y4HUl6gMvkDJxgA+@debian.me>
References: <20221125075804.064161337@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1CcNYwqhgGfkxMEO"
Content-Disposition: inline
In-Reply-To: <20221125075804.064161337@linuxfoundation.org>


--1CcNYwqhgGfkxMEO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2022 at 08:58:38AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--1CcNYwqhgGfkxMEO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY4HUiwAKCRD2uYlJVVFO
o6ybAP9NqLaB6L+lF2RF9TI+GtnoTjgX2+5JnN/BjIgquv4TbgD/UsPqydFI5nTo
KP2Rnp0N4UkMCI2XWBSRcazJebcmnwk=
=xTG3
-----END PGP SIGNATURE-----

--1CcNYwqhgGfkxMEO--
