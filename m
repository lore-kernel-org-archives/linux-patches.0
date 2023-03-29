Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21254EB8
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 04:11:50 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id le6so13712414plb.12
        for <patches@lists.linux.dev>; Tue, 28 Mar 2023 21:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680063109;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L7ZNbdRmLBVQTUyoFW+BtEddrBJyh3gW/MajDq9ikHM=;
        b=qQlxkV3hMPXscS6z7rJW7Pm0dZHaGpjozG5zVgPQ6OXYjeJ1fVgQiXQGz10BflIwmN
         Gf3X/Qe6MOftjTMZZBj4ybDisdtVRHOV9o9yi1D1mD9ff/ihNPxfNUKD/AOVrjX4akjp
         QtfS+Ud6cbB8HVmS66esPN6sCzuy3wik46GeI8gzKsdTCjwt7lF21zyOcIxl7uZsraHa
         Go2CXa8+ij7GMi427EI45eZiQRgvVDNMqfhOGirGEIHCP/p9yJ3oMsTwI4uq+oVYvPmy
         vu0Aj9w589xovesMwShrpUAa84IebDk8kR7yxlMsDw/3HQKggEoXDjGPKLBYKOLbvY7l
         K5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680063109;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7ZNbdRmLBVQTUyoFW+BtEddrBJyh3gW/MajDq9ikHM=;
        b=Oa9QiZOSGWSPdlnfSKhRTCEexAakxAJRFdU6xYH0nFtpLMbrTPZe+W5aqIhMaVKQhC
         uGzLo55YKWWVEQqj+Mh1YEwl9OnTpEcPkMlcJeNynxX0e/rxAUDZs31mNLXK7B71Xadn
         NclEKOWsFGMZU97c8vUw8gT0+UI1LG0sJGY75LqlacAAXaWktxwgzIM1cJgGCuyM0Rsy
         R7wGTXMbarbIbvqqGSnlWvgezZ5vMZGMjonRrGLlZCc9mxg4gvomMwzDiHEkeAdLZkFw
         jnNMUp0K+wsSmxwRbbonyuh2PV0oL535o1rWIo4WJKe5Ql+FiGS5sPJVGigFIe5dmxLD
         q1iA==
X-Gm-Message-State: AO0yUKV0BhKCnj+mQg7dIRMRX1fUdMFHQTdIReuSdauVA7+8LhmFnnsE
	ZdwiuADV/RirHqwXBEixpnM=
X-Google-Smtp-Source: AK7set9k90dFBO7hBEhIQiDpNaTi3InRtsFJDliavAy940FUyFVjqPo/TNO1TYOrg46Cnk75+A/tKQ==
X-Received: by 2002:a05:6a20:c10f:b0:d9:84d2:7a9f with SMTP id bh15-20020a056a20c10f00b000d984d27a9fmr16315514pzb.24.1680063109559;
        Tue, 28 Mar 2023 21:11:49 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id i22-20020aa78b56000000b005aa60d8545esm21830967pfd.61.2023.03.28.21.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 21:11:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id A376A1066F7; Wed, 29 Mar 2023 11:11:45 +0700 (WIB)
Date: Wed, 29 Mar 2023 11:11:45 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Message-ID: <ZCO6gRM7ozbbXwua@debian.me>
References: <20230328142619.643313678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+g+mtS8KVUMZPKw0"
Content-Disposition: inline
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>


--+g+mtS8KVUMZPKw0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 28, 2023 at 04:39:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--+g+mtS8KVUMZPKw0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCO6gQAKCRD2uYlJVVFO
o5HoAP9FWcqsjccJRMe659wLDmyDQH9bTYwZGRV5k1DHgtG/gwD+OLt2wWXOH329
5wYVCQNC5ky9zqG7xsBu/4C2DVnWqAo=
=5Xix
-----END PGP SIGNATURE-----

--+g+mtS8KVUMZPKw0--
