Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8970F320E
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 12:08:23 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id o2so27182024pjh.4
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 04:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BQHkYadhZlgGM+Zbgat2QdSFubzEiShLu9c6oAOmKWQ=;
        b=Ovx/SV6IEb+qUTBf1d4gefA1pI3yO7x9d1P2vpqNLit5EPnPrgWevmMR9U78HMd3gG
         w/FueeSuxFoYQbLgNk9XJZqiaBvHiitOSRREPkQzdGSNJyj+0wzcThw6TaNfZhGtAAKK
         G4VF0bql3TrL2fWdeijkkxyAQo7uRkWUCtiQeW6BRSXYr1QvoDjFzGin03FKP3Y6eggg
         uVw+bRaIg8l6xH3kFGEEsJN4Qq/LUaV9G9rvVU1fOGMMmR22+YK6UVgF0YNTXRYZUAaV
         XTHXXl0F4DIsuLLFAmvRdsUB2AvXttzO4o/ea7y8LLpE6xNS1oBoMVaKOu5NAdVvFPz8
         WvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQHkYadhZlgGM+Zbgat2QdSFubzEiShLu9c6oAOmKWQ=;
        b=NkFC9c3+BSeLMauATWqbYMCukYWZfZpi4/mHBFWWYlME/lAs4S3RjBCVo0tSmr+0Mj
         +MSZBmnNj1NCGe9dcY0zcQKxgnVQevtUcUJ5Svzci345tPh6xlL0fDaqRHkG4hSbIof0
         RHAPCF17otNcA8HjPVKeVIOfVZAqVIP7YuGIiOmhpum6uwA3GE/RibU+g5Mr6ng72UYO
         3xg10x7FVL/CWPgkiCKwurab0LJv8kTrQMdCvISXTdhFK+PwhwlNnZKOIubFw7UflR/D
         m5ued++E5VaebHBm83gfA9X+ivon/EO0SZKFayZvgKXlg5TC5SkTVrGzJjfGxfzVk575
         +Luw==
X-Gm-Message-State: AFqh2kqEHSji35jzz1W/m7XUeggYcqDb8zh9YDnf4gpvnoj77Ct49GXj
	AgCeNgVL6JkL8tFuBosMJNc=
X-Google-Smtp-Source: AMrXdXsrkli71JgCcoKUx5P/GVjUrOn6OrtNPJ+Tj8aUIncXPuVtPXD3PPQvcKPztAxRlliQXt9wBw==
X-Received: by 2002:a05:6a21:32a1:b0:aa:6efd:1883 with SMTP id yt33-20020a056a2132a100b000aa6efd1883mr71763197pzb.37.1672747702996;
        Tue, 03 Jan 2023 04:08:22 -0800 (PST)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id b20-20020aa79514000000b00581c4b4c15bsm10014258pfp.142.2023.01.03.04.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 04:08:22 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 7B297104F4F; Tue,  3 Jan 2023 19:08:18 +0700 (WIB)
Date: Tue, 3 Jan 2023 19:08:18 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Message-ID: <Y7QashBMUr8HrQNE@debian.me>
References: <20230102110551.509937186@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="13ETcmKU9UnxuBi+"
Content-Disposition: inline
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>


--13ETcmKU9UnxuBi+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2023 at 12:21:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--13ETcmKU9UnxuBi+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7QasgAKCRD2uYlJVVFO
o6I3AP42ieSvz711PkLm2XKvEzpekcOx7z785Qk1q7+gXYSU5gD/eoGr+p4OJiUe
ZxlhK0CZg0g+997ECbYuRr8bbuJtdQQ=
=VFyj
-----END PGP SIGNATURE-----

--13ETcmKU9UnxuBi+--
