Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB7115AC
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 03:19:44 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id 17so6767962pll.0
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 19:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p/hZkUjybg3p/GgHdUa/8u76NjJRa/j8RTy9gYjcJN4=;
        b=MKbpjVIGraqYz6MP1vu8a2HEFdT7KeoPN1RyAeSQLhs/5Ympve/5Waw0eiovezy2Zq
         cZv/5w5tS4yG1hoFVsikRaJ9u60ISaSsAx+PjQFxnUH5FaT2v+BtuVVW+hDf4rynU6mi
         tHDtPwKZd7xRU94qxAdLzYzbU5xkXs39SmZhf1JhXjWn9+FECgaNCRf84u0MZJV3mL9F
         uKbUYnrXCyRNpcxJEnv1t0eM7yPnL6kCwdif2CUVEf2BjEP946qi4xX/5+pYgXqYsUHu
         nrts4o1siRV5vPjDm+LeF0fNCfUdd0jDTFyXpeP+/EOqgydyiqgFSbCz40EtXXO3h2VX
         8OBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/hZkUjybg3p/GgHdUa/8u76NjJRa/j8RTy9gYjcJN4=;
        b=ikJQhwgQLd+nuGgOK9t0OHTh530KpAqDmaM5mU2gAs/9bRlbNCcsnKRzpq1lcEpq3V
         gN0+OhSdGbQoWJoTR3ri/aMNziRMfBy+C1tINU/zN+QqjXLLTHGCYPcimXFgJpheOHAA
         715okII4x75MjWIq0x2w+v5AfSK+Gv7bJN9oyIMUe/d+w/QCw7NRaZnVW9lIycGHov0j
         F9fJi9Y/vhZjMarJHWtb3fQ0t9/Dd/W5u9EHeUVHSJYR8pU0qiU5XqIP6OS37iSAJu0w
         LWj9xC/SF/et3hd6sSBV3B7WMcFmFifcmoXjmOH2uqbygp7ARD5KOXHZ/fsXzSXnrutS
         PaMA==
X-Gm-Message-State: ANoB5pnvQHJ3oxvdub/cTswSoAU3gqZdBJfuyMD+OxXgYqL/wsudkmXq
	951K0rxL+LFKOcJP9SGDEp8=
X-Google-Smtp-Source: AA0mqf45zJLm3DeeIXQh2Wukx22/xs3HxcgfcytEXCOqxl3U5ISdo0e3fXZ5oGgwn99e28s6udSjcg==
X-Received: by 2002:a17:903:181:b0:189:9007:ecef with SMTP id z1-20020a170903018100b001899007ecefmr26887039plg.25.1670901583527;
        Mon, 12 Dec 2022 19:19:43 -0800 (PST)
Received: from debian.me (subs03-180-214-233-6.three.co.id. [180.214.233.6])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b00186b8752a78sm7135541pln.80.2022.12.12.19.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 19:19:42 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 6E765100E30; Tue, 13 Dec 2022 10:19:39 +0700 (WIB)
Date: Tue, 13 Dec 2022 10:19:39 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
Message-ID: <Y5fvS8OaGa1V7bcm@debian.me>
References: <20221212130926.811961601@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="TlBFzUeYofK757u8"
Content-Disposition: inline
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>


--TlBFzUeYofK757u8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 12, 2022 at 02:16:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--TlBFzUeYofK757u8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5fvQQAKCRD2uYlJVVFO
o6tWAQDVrZjPPvgmFh8PrcxmUxyyPFusa2f6Xve943zXmBXslAD6Ayrwdib/RKA0
DW69t2Vxffm7q2rBdLWwpAbLnxiSywk=
=wAiO
-----END PGP SIGNATURE-----

--TlBFzUeYofK757u8--
