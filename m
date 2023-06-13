Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707747F
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 04:14:46 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6537d2a8c20so4118220b3a.2
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 21:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686629685; x=1689221685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q68FLd8Lf8c88U2yU1AjX1ynx75CBETxpHufNs3LkRk=;
        b=C+DDSC4oivLipSV1OSoBz/cmklXs+3ZmdvqSXolMhlXiYAszxWutgU1874ONcQRwSu
         ESP32Hg7dqm1vjH3sj89j606bAyYguVProcvT4M5h8xFLqghJKElHNL7kIZeqDPBsgp0
         vGYl/oQqRL5yzMdJcQjw59k8HeRcAVp5rwWWa91muPXWN3GZwp71p22H4TBvmuX9HQP8
         /R/j3Hp8GcEofeU55m7lwTofmkS/RHKZpvzZEJGIH1+7ttBHidXT/gED2GevHjl7Wjrj
         VRWW2EFmu1LlIAtkiKThGaTjw8ODqs55d3etG0N5EeRY0p57cdiLtE4azM/7eIDdnuOK
         f+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686629685; x=1689221685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q68FLd8Lf8c88U2yU1AjX1ynx75CBETxpHufNs3LkRk=;
        b=Fvgz0bDV5nCXF0URvY+APpybZbIAk/HM2WvL9H9EKqMCRkTMIUP3N51LqXyzpixMNb
         kzUcwtr5cGxA5Hk4od7h/4+NKo+Rb4K28VNF7RmjpzsDJMnyafjQji0Nh5IT0c/W+kET
         gqr4CiwI5Q/5iQeTp36h7FXgXksmAzj7Mx2pv14IHLq37duJg52I4ZVR30A9WxAK5WX+
         EkM4mBITc2pZD9aXTMICVg9k8gU/6OoPaMqlhfCSUwtllZKBrvaP0oTmsySBI8kGX7iS
         t+O8UYdiPubAulQokMWs4DY/nXqgjsupVKV+iIIAPvHVKCoyQ3U9/J8t+uq/qfqd27Ql
         4/pw==
X-Gm-Message-State: AC+VfDy+dJuTvj/QNWC1f/EwGZDJC79M6oVKaA6dqLSks4kRDEkagehq
	3M9uwXxpUm6h5+HY5prDwcE=
X-Google-Smtp-Source: ACHHUZ6gpgq7SxCh3va4CCldJkvqQEi2+kAUOUf9vIlHlTK48C/xvFhyFU6zwXsDOS0NbbuSzelG0w==
X-Received: by 2002:a05:6a20:9384:b0:e9:5b0a:deff with SMTP id x4-20020a056a20938400b000e95b0adeffmr13167699pzh.22.1686629685444;
        Mon, 12 Jun 2023 21:14:45 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-27.three.co.id. [180.214.232.27])
        by smtp.gmail.com with ESMTPSA id u14-20020a170902a60e00b001b05e96d859sm9005098plq.135.2023.06.12.21.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 21:14:44 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 9429B106994; Tue, 13 Jun 2023 11:14:41 +0700 (WIB)
Date: Tue, 13 Jun 2023 11:14:41 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/91] 5.15.117-rc1 review
Message-ID: <ZIftMfwrT4dLp3_L@debian.me>
References: <20230612101702.085813286@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PjzAGnKqwk+LHmb1"
Content-Disposition: inline
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>


--PjzAGnKqwk+LHmb1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 12, 2023 at 12:25:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.117 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--PjzAGnKqwk+LHmb1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZIftKwAKCRD2uYlJVVFO
o1N8AQDCFAbWcn+AHT2ebgUOuWoz0U3nhB4+mh8GczcCJGSBZQD9HfQXOGMEF4nW
baoUGb0Ekt3T56dp2gzvoVGSY3tv8QI=
=U6VQ
-----END PGP SIGNATURE-----

--PjzAGnKqwk+LHmb1--
