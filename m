Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0A9625
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 02:34:24 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1bf5c314a57so3577955ad.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 19:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695263663; x=1695868463; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YyjiBsVBYHl7tXi/d8DrdE74sHAHItbdpqTvGKn8leQ=;
        b=Rh3UsdDrrOkd0+diviEJFDr3RSjTVay/ajZCcuY0W7LgnP8KXIDlBq3qSYx+mRVPjD
         x8RoVdzMvYPNoxRS7h94pNL6dTRihWKZiD9ICfkISDEM5Z7ok8gEPNQcEsfNCXvd3DhA
         okSEEKMVkMz/JWebfSJBJzZkIJUVJ+LeRWNohWnN0v1UV3B1SOKaa+Jhb37oQF3HS9vE
         7Q6rGxA7mVE74ud61p87KViVlapXYcf8KwWXw5OblIFkEQMTt/9S6XHQbhHxWYXSjdW+
         vhO/FHWBu/zEI7FBwK7UTzOJTGkk/yqZJe2BrDS17+CnKm348SbqtMoKbSemb1Qxhh+Y
         5o3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695263664; x=1695868464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YyjiBsVBYHl7tXi/d8DrdE74sHAHItbdpqTvGKn8leQ=;
        b=E8PAj/BtAetI+hoTqGv1B1qUUohoZNXzT/V60BRCq9hbTcoKIZ06MfMGVGo/CYIEEQ
         H1xWFUwLcjwVh/URdYQh9LLVbE6KGD3vFy3g2+udU5ZDQB8YC/bXn/d9MP8s4CT7FZV1
         xqKoxl2Ko9nNMT/Yk/+MT227+RsnznK0ATGK2fsO2Zh+mCouvqPGH2aZRlL+j7jjvucy
         Aok4USfZ5He9P7RU/C4p7NRF8oBHu+PbdzfZfA5Kn281BACgECD4TMxpGOGHHW7uzM3r
         eLGaDQx+7fzU26eggBODO2BvbADV0MpgEjT7/r047hihY76cRS2AtTyQw8zCq7B/jY7V
         z5ww==
X-Gm-Message-State: AOJu0Yzv+nJSpZxwAbE+rm5y3ZWHs/3rLLHqAt/GN/BI4zSTpRmRsI61
	INl5r4cqAMTRTZmrf+BRfxE=
X-Google-Smtp-Source: AGHT+IFWnXge3YgYaXFugjt4aiKInwf6x/gri9XVD1qdAJQgrpt84UgD+Akn+6/VeQ63B7uqZyoZtA==
X-Received: by 2002:a17:903:1109:b0:1bb:d59d:8c57 with SMTP id n9-20020a170903110900b001bbd59d8c57mr5541324plh.18.1695263663614;
        Wed, 20 Sep 2023 19:34:23 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id e15-20020a17090301cf00b001bde6fa0a39sm187922plh.167.2023.09.20.19.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 19:34:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 46DFC80B8F69; Thu, 21 Sep 2023 09:34:19 +0700 (WIB)
Date: Thu, 21 Sep 2023 09:34:18 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/139] 6.1.55-rc1 review
Message-ID: <ZQurqopWz1634-lg@debian.me>
References: <20230920112835.549467415@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HWzh9Wt8MK8C9IfR"
Content-Disposition: inline
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>


--HWzh9Wt8MK8C9IfR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 20, 2023 at 01:28:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.55 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--HWzh9Wt8MK8C9IfR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZQurowAKCRD2uYlJVVFO
o6ajAP9HLQbD5uS+7yuaxIhQ11td0NZOwywX25L8xil3ZNW2GgEAhuiU0lRxYcvP
IVpOtULpEcizvVpUDJogonNEpl/uuws=
=+p3Z
-----END PGP SIGNATURE-----

--HWzh9Wt8MK8C9IfR--
