Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA671365
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 02:04:01 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id q9so4856524pgq.5
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 18:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uePF3eDJemwYV3SuvTrXUS0Nc0Z+OSgE9N4Vx3eaMM8=;
        b=C4RiucKjZPpCAg6YAF4eBUtU6U9GxzZ+KQE285cOOmXecDTMdNZG/Z7dDCwajOZFq5
         6fhggg0AghxpLqm5J6HrpFFeqzc3AIgHFFtTocELrOFpSlWfM16f0lFf3Tio55n/ijbT
         CC2a+so6nwR3dmAh06sZhhTZvojCQ9NMTfNl9bznW1T3TVXH9eWfcxQIhVfiXDJkkvM7
         fCDKnvCzQFcdw5U3BpoM8qpb1o2dUlI8gNAYXpHqH1uL8ao8OS7VX16KnoOfFzBhAm6i
         v2nkRY8PsoD2YqDcCPFqGBDWUfq06PRO6xA2kzd59Hmh7AL1ybcUpE0Vud/fRxbzIwJg
         OQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uePF3eDJemwYV3SuvTrXUS0Nc0Z+OSgE9N4Vx3eaMM8=;
        b=zebesY2dX6m5eZcr58nbd4xohO1AsS+FbHfX832jgKEl8Z9gOaEAsoonqZOXTUSDBe
         97sIabqaCdud3FDuuctXmoacNyKGRKbKrU8U1tgmRhxuI+nNOnU3Ie9Vjar+PWlUpykg
         R6zsYaLyoGYV+D1HAYsZB2a2riGK6WIYmiMb7ladF3haruT2NACAL7fJNMenJw9urIFL
         OswWw3vx+ZJvzRu6tQ36C7MUZ560/jzZh5efqp8r5gNUXaYZ+bM4DyejUjsearq73wu5
         lWrkOj0Rybnyx7fcsGukyVUJEBkkSwdaWQ1ShXs2FEt59lBxDFhSVD/8hvXP72hXaDmP
         qqXg==
X-Gm-Message-State: AO0yUKX/5GKGNaJPzhWKV90xaijvBCYDPM4kgq2TVVzb8H4oO8c9GFmS
	iP0bSey+YLMyzol1MJHRgj8=
X-Google-Smtp-Source: AK7set8cRFAs1HA7CysvGz1jSHh+UPjUA8HI6i+unKtdWIXeai5/n/5suMpr8o/8lEDCDNck9eOImQ==
X-Received: by 2002:aa7:915a:0:b0:593:cfbb:3446 with SMTP id 26-20020aa7915a000000b00593cfbb3446mr10195154pfi.11.1675476240673;
        Fri, 03 Feb 2023 18:04:00 -0800 (PST)
Received: from debian.me (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id y66-20020a626445000000b005821db4fd84sm2507025pfb.131.2023.02.03.18.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 18:04:00 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 02D1B1052EA; Sat,  4 Feb 2023 09:03:56 +0700 (WIB)
Date: Sat, 4 Feb 2023 09:03:56 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/20] 5.15.92-rc1 review
Message-ID: <Y929DJ7bSaFVc+/I@debian.me>
References: <20230203101007.985835823@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="e/62PjlpUEBrbBLG"
Content-Disposition: inline
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>


--e/62PjlpUEBrbBLG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 03, 2023 at 11:13:27AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.92 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--e/62PjlpUEBrbBLG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY929AwAKCRD2uYlJVVFO
o0pSAP4xikCjYlehto1K/7EG/Q607otvnze80g/FIRqCPSAYwAEA804JcdwogPij
qlQ/MNtoUy6DzGoPWMSSabw4cIbkQgA=
=vUuP
-----END PGP SIGNATURE-----

--e/62PjlpUEBrbBLG--
