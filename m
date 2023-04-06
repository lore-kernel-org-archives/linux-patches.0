Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B8C7E9
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 02:45:02 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso41526132pjb.3
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 19:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680749102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FP6qMRZnufmIVukqRAxAvxpbHirbfFAZ79709yINii4=;
        b=YYdY5i2MmC05Jqq6gkro5Q2vQdryROCdKKpYi4iuZnFz8lalWYbms90KjtE57Rowbz
         BFlo5WTqQhDaZ3sOTPgWsmnYkidYAEgkQAKiik2jrcE7mZ8h1IrLnm8W1teSemB9FRHn
         q07XZu4Cq1DsR70RJUTBf4Hz3VaaJB1HHPWFOtnGdUU4E/6JAhbepGu72q0C9WUGRNLN
         4Lgex3zeqpoqEF5uyW9prY1qKt8EOJAldqGzdvAgn6aSBlELsuPEUWqqSNhPxHv9e1bF
         CCnrk0U26r/+YJvK7plO5lDBqpI2uNgLw2076O0Lay7bL/9ebO0SmwbIgY97LVIpfKes
         G0Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FP6qMRZnufmIVukqRAxAvxpbHirbfFAZ79709yINii4=;
        b=KKCn0puR13hRKCN5Va3zHVeGWD/yGuluuYyKEuQ00JoDeEUeeWBuuUUhjbrZXO0jBd
         EAbc6gOCHPbwjWl/abQMZJEpMe5gnKfT72u9hcqSKnws6Mg0u5LMKCr1eNwaDqnu5hiC
         eG7Zu1yIv10dcuSo8UvsQ20bB3pQISp+7ycR4x5mjOIPIZmBFbcbNwTdsiY7YGyEWo+Z
         f9JtwpI9yDas+WybzbWVXNewuW8t6no/HDskEzDPr+FTXrVyUFY4GEkuaJPw0CGNxEVD
         duko2KKWH1pwZVmJ2oAD9eJ7IzjXLOztBhWzqJbrgkorzT7pz3EC7vwAKUMVsEVLTY00
         bEVg==
X-Gm-Message-State: AAQBX9c/QRZ/GxnysClv6UmEEC5YFBnhp5TV8TfCpZFA5Qom6QvVNq4K
	/uWocxFy6MvsX3kL5QhjMxQ=
X-Google-Smtp-Source: AKy350b6pegyGsn/DaQIkwBz0qaEliqFkuQOAVOTtdC3LWZNIs+12N0ZtIFdAKcz+SZrub+qT5J4Mg==
X-Received: by 2002:a17:902:f68f:b0:19c:be0c:738 with SMTP id l15-20020a170902f68f00b0019cbe0c0738mr9820147plg.59.1680749101537;
        Wed, 05 Apr 2023 19:45:01 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-14.three.co.id. [180.214.232.14])
        by smtp.gmail.com with ESMTPSA id jh19-20020a170903329300b00199193e5ea1sm229271plb.61.2023.04.05.19.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 19:45:01 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id C1EA91067E5; Thu,  6 Apr 2023 09:44:58 +0700 (WIB)
Date: Thu, 6 Apr 2023 09:44:58 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
Message-ID: <ZC4yKlxhiQusPE6d@debian.me>
References: <20230405100309.298748790@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TEy8fNr0EH5xbQEl"
Content-Disposition: inline
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>


--TEy8fNr0EH5xbQEl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05, 2023 at 12:03:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--TEy8fNr0EH5xbQEl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZC4yKgAKCRD2uYlJVVFO
o4ILAQCkZjtkzLEse2RoKR1YejTtFx5mdZZd7gSXUhDyjXPFDgD+LyfT7K5ZYkLV
s0PZkX+FpBiGO8YayWwMprZTUOGr5AI=
=VwPF
-----END PGP SIGNATURE-----

--TEy8fNr0EH5xbQEl--
