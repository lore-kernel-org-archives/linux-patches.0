Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCDA373
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 04:42:00 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id i5so4082902pla.2
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 21:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679028120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3oQztqU78ZT+tQqAztj2/Sep9u0A1fhNGYG5/eDPvQQ=;
        b=ogeZfnLsVIaIST03i51847uLuChbd4rUYQXHvcP8zkQUNHhXRasziBP8SiQS2aM0OQ
         nO9bP5sigHc3SvMCU/Aa5GEhTptjfZg+3xGn4QHoH92pstpIclP8fXcdBwSEXNQ6yHKU
         WqJBoInir0sFl+SUA/qxxMO9El7KlXMs/M/vNt8xs71xxxSViQIU31pMJezxlkWcrDS8
         9HGYcDlv/Ep3QiyyYobCikR//rPTTrxvY70azXXZOketS4a1NuKgAbIXLd1sVdEeBF26
         mKDVdDS5zkpy6u9Y9ncJ9ZMxw5IGM3DInNrrmuu8cyV0F5S/7oBOlFwPyxRmFnXAfrqo
         SKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679028120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3oQztqU78ZT+tQqAztj2/Sep9u0A1fhNGYG5/eDPvQQ=;
        b=EOIqrzSJnsLNzd883lisIiSFP4hy/ApUQHbXY36ySz4sCDCIJt4yfhiaUz1LomGb0c
         MeylbUc6WUJA13+/0VKjwzgWTHkg+NO+gOaeGfAGCBje0GqWV0Lm2G1mUtq1GmkwqXEc
         obEYt/pXk/bKvfXiEJsXkFA3h7oS3Zk0EpqgRwrkOIud4vwcxX/bTAK8D9gTsU9I74Pn
         LSyK1APcOigFW/c9+pXjef2o1wPWJpvBtoOPCJ7rVAxbuqLJ6DjI0mgFvEtCibvfPSjg
         x/RWHFAzg/VgsHBe1hdOFIcGbBUB11JbNyuZ05GIJW0xe7Hen4HttAaZ94HcIyZqClQK
         wcWg==
X-Gm-Message-State: AO0yUKX+ozVsTbhllsXhZmWSDl5cbrI5u5aLlQKd1uQ754aiSjovOBEu
	uVv0FqjkPTMOVFOMb3TbroI=
X-Google-Smtp-Source: AK7set86Aq4DKVfNN16hZY5NYjUMmeTEfvIfcpE3APKapY81xbPAVdTDh1PpgLqvClfg7SbsvPR3OA==
X-Received: by 2002:a17:902:fa8b:b0:19d:14c:e590 with SMTP id lc11-20020a170902fa8b00b0019d014ce590mr4761933plb.9.1679028119966;
        Thu, 16 Mar 2023 21:41:59 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-91.three.co.id. [180.214.233.91])
        by smtp.gmail.com with ESMTPSA id d1-20020a170902728100b0019a7f427b79sm518231pll.119.2023.03.16.21.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 21:41:59 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 0E7E0105FAD; Fri, 17 Mar 2023 11:41:55 +0700 (WIB)
Date: Fri, 17 Mar 2023 11:41:55 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
Message-ID: <ZBPvk+qsO1SNWRZ6@debian.me>
References: <20230316083443.733397152@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hI0+/BKgqinWJgLM"
Content-Disposition: inline
In-Reply-To: <20230316083443.733397152@linuxfoundation.org>


--hI0+/BKgqinWJgLM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 16, 2023 at 09:50:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--hI0+/BKgqinWJgLM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBPvjgAKCRD2uYlJVVFO
o0CvAQDJcWVbAMlyRpDPQpIY8SCVINyhjyV4HtUqAMlr0rQhDQD9GXqEjZp3Mvvg
YoUbCKs8wCCgHMfjI1D461zvgZh4zAc=
=7HGc
-----END PGP SIGNATURE-----

--hI0+/BKgqinWJgLM--
