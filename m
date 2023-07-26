Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6D04C9C
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 04:23:35 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-403b07cf5d0so53528231cf.2
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 21:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690345414; x=1690950214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yi38VlQdcgh6JrRFXIjUZ2eky4uj6/eRY5AHeVHhEaw=;
        b=riofDQK966kREfzEc16UMVsmEb77ME6cqjeVOJr3+Yu0VQjHHFbyfabv7vDLoENP8+
         So6XyxLFmw4JN3kDGxNKLHETZjbdyoENJao0XUUfc14mrBCZJdJLrJcon1KkMWhMpebr
         YdOiNL0zajvmOJ8tZ0fo8bjf2X4tRxAkZ+oQ/zqpcPnod0v6fzZjFF97e5iEJaV3HYod
         XFyRvtxIauL5zx/p8/eHz4h9gtaYVDCHixIplSlory33dYrsK3qeHcjq3wkvPiKRIUQT
         5pw+TCNX7A4MtYnL0RvPuXTLOVAOfGj2Hth95lK35dZjUeQV87Lcn/nirOCiVJbh8ZDv
         cfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690345414; x=1690950214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yi38VlQdcgh6JrRFXIjUZ2eky4uj6/eRY5AHeVHhEaw=;
        b=gzrOMKB3JUmCnYwcg8d8LlGk/ZThEWiUxokwEYJTXziAJ0TgUMxVGyNxeXdArerVbz
         hgtPxAt7cYYItQS/2vr14MxCYHFHib/F4d/ULxU/2kF4SQB/RfMhkEWHHxLK0lYD/Xzy
         tYTYBWHJChIdZx57xwvDWJikotZqjLX7tYlaK+0psdWr4umaJvODCM5qHI3RY2whYmCZ
         27Jt2YKosGXySJFBGacgbWIn7SDtafhngY0Qn+wCTr6yTRn3pwMF8K8jTEgtTKtITXf4
         OY9T7M3sl63vaXwN0w2f/wtSfSEovy5Sfhppsbmf5+d7qKh4KqCriYmZ0g/OcJk51BtT
         owng==
X-Gm-Message-State: ABy/qLaTRaQ/5CyBlFUGCUIiElCZ3GrUUcZK7PAHUaH7Tp/2M8CANuSq
	wRL3doaOt59hiU6tLD0XcuI=
X-Google-Smtp-Source: APBJJlFuqgqfnFmRRiWY9ZiIaviqtZKRz9n8fCGStB+wq8/1hm//rVdWsQ2l7NcTivsYV+VWIZaUUg==
X-Received: by 2002:a05:620a:a9c:b0:75b:23a0:dec3 with SMTP id v28-20020a05620a0a9c00b0075b23a0dec3mr1034636qkg.65.1690345414214;
        Tue, 25 Jul 2023 21:23:34 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a018800b0026309d57724sm376568pjc.39.2023.07.25.21.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 21:23:33 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 610AB8192284; Wed, 26 Jul 2023 11:23:30 +0700 (WIB)
Date: Wed, 26 Jul 2023 11:23:29 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/183] 6.1.42-rc1 review
Message-ID: <ZMCfwa5019Eil94D@debian.me>
References: <20230725104507.756981058@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZGq6QzdxF2Ci/i0N"
Content-Disposition: inline
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>


--ZGq6QzdxF2Ci/i0N
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 25, 2023 at 12:43:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.42 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--ZGq6QzdxF2Ci/i0N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZMCfvAAKCRD2uYlJVVFO
o4l2APkBMv7/eQI3HHMsLmzvq6JmCJ3oitxoHdx3Vo7XZ+QVPgD/SAh277WpqUc2
Wi4Ux1JnYyBuN1hOx+5n4Fj7tZyrAQg=
=4pyv
-----END PGP SIGNATURE-----

--ZGq6QzdxF2Ci/i0N--
