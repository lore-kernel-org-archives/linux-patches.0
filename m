Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F43321E
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 08:55:36 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so1432358pjg.4
        for <patches@lists.linux.dev>; Thu, 09 Mar 2023 00:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678352136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IRZaWnJB5vKW3N2Mua12lagbvIC7r/iyFdNI4IaoiuQ=;
        b=BBZzoMQ3w9bQ3vLFHXfRS44zOBrJC/xI2AbmCSVJeOcBgGF5veYAHJRqPsQvRHy9/1
         v2NdRp9sgy0+iBx9v7uy5VOpyvVw5rNldqmm+RRwoQ6XdsE+kPyZViKjTjOBiP3vmA9d
         syQ/fv4OAFYRr3bCaMWoaLJxsjcIq8c8Asjoph3F/7GnFlXTU8OONk44FT3ywCmp0l0I
         dEEDd0pdjLG1PrV70JdlDanlHYqU19Htb8QIY2XKu0C3doXVIc3BKsXeBT3ygSm+rwmu
         JOw0jE84E9iYcjoM/oIaaPfIDilkSw6sEi1Nq92SFtmEhNEwFOQc+b0kBNcOaXlC6MQn
         VGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678352136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRZaWnJB5vKW3N2Mua12lagbvIC7r/iyFdNI4IaoiuQ=;
        b=hdZLUrDOwZnwKmMi8z8RC1bnshlc7T/a3wutHRE71klUouQh7JE/n1A/TfQzxoTY++
         lIsX9RSijhzCN2ban6M1JoOqfMTyDoLqgUo8m7fA/+UJN9P4DnUQZlV8W7cTmZdjnnjN
         L2Jqlh5ca1UbaeqQuUVa874zDjt09/BQjDLTq1MrVFDWxSq53SpP9eHP+Sg7EiGeWA3r
         HJKafsM5c2WFvWu5JOCVvlG9RFeorxiGw76pEuaTKjI42rBvnNRXewV10Vs6oEi51qw5
         ryrTQzokoYqYjdLGI09zxtwVSb0BZfhiibDdnv1mXxfGPq2+eRLU3CqkNpz5Ozgw9WVs
         fcKQ==
X-Gm-Message-State: AO0yUKV/waOl/Pc+b162jpr7dc5uBYL/K6FI0hLHD5exjyd5gccOYeqi
	mPYNnJ54J0pmWtriWY9mT9Q=
X-Google-Smtp-Source: AK7set+tQ4jp7msyrp3ExUaTYg6lGPvNXwRx5LSIfV9xuodx01WnmUsSFo0ttefd3LpfP5SKXdpRDA==
X-Received: by 2002:a17:90b:350f:b0:235:31e9:e793 with SMTP id ls15-20020a17090b350f00b0023531e9e793mr24965090pjb.13.1678352136064;
        Thu, 09 Mar 2023 00:55:36 -0800 (PST)
Received: from debian.me (subs02-180-214-232-4.three.co.id. [180.214.232.4])
        by smtp.gmail.com with ESMTPSA id o2-20020a17090aac0200b00234465cd2a7sm1080812pjq.56.2023.03.09.00.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 00:55:35 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 266FC106581; Thu,  9 Mar 2023 15:55:31 +0700 (WIB)
Date: Thu, 9 Mar 2023 15:55:31 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Message-ID: <ZAmfA5jbm8jLsiOq@debian.me>
References: <20230308091912.362228731@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tHH3FCFqzz59BMt0"
Content-Disposition: inline
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>


--tHH3FCFqzz59BMt0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08, 2023 at 10:29:21AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--tHH3FCFqzz59BMt0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAme/AAKCRD2uYlJVVFO
oyEbAQCkIDTxCCWCEO7I2IiLpOWMjx/peDuICNJ2SDuAQxjBXwEApQH+G5Cet4TB
rcPy0cGeVv9uHG+W+bq0WgCIq/JaUQw=
=uYxE
-----END PGP SIGNATURE-----

--tHH3FCFqzz59BMt0--
