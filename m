Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59557E
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 03:54:57 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id j10-20020a17090aeb0a00b00218dfce36e5so3030036pjz.1
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 19:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FGDchlzjZ9nDfcUMTxD0UYqCVipAmcffFJDXCznLGbg=;
        b=kMBa7450Mqi4GDqf6C0SoSvIT3YNQSLd0LAj4lPYdHxeLZqvfqyG3Lw1WaBS3PkB+C
         hV8S6Oh4k6Xuc19CbipnWJ77NELKQJ5OSejy1DQXMKKsJkCJ9N/bVG3ypLeA8voJY2CZ
         YOgojVUk1K2/zCXG24Vb4oVlmOYW74Mu1CB4/Y8VgVxZJDn7f+CqrhrHzCA47HnExFSm
         aajmeKVKvEgYzp4lMGFTJv1y+62eQHBP0X83RheSgZPkhKMZmIk9lhrOiqTPcNxF4Vsa
         Su5llDhFTl4zc9ZpgXMyV7GvvyNQNTyV2c/vRkbvHZT580eoxf72S3Nw6u3Sd3hnGXPe
         IRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FGDchlzjZ9nDfcUMTxD0UYqCVipAmcffFJDXCznLGbg=;
        b=tdx16eAAEvkC8AVF7jWELsNkMbfd+8RBWecbY5Hqs2CfjGiaL8s08UxKVAWuGk7n8C
         mZs75mmPHTfTZmhd3H7SqgIpCjttYYFip/NhLcQn5oNDQtXJkZlUHAKvNojj6d6Is8aS
         ZV8mFdvtW/gINKJvOY+H6F6gC7tKv41LoGxf+SF+5bFqPJtlNphpUkOlKIeFyLBNpcmr
         H//DlP+BU6PgwWPDxUiWPotKwScpIJyZf9KxZjuynWQhfmTpIqD0AZ5+234irsh+7nJw
         GmlbTsVgG7FsbHPYHpsLWUWpxs+vPoE/Hl9EBQ80a0l1kx9w4Vjq/2nFvnQRDy+HNOJO
         p51w==
X-Gm-Message-State: ANoB5plqg4f14pKldKGWnZSIpUw4tZ5yzYpy+bJwkipz8L+L3umHwkMx
	WNDLCnh28gtAwa+d0mSgzJc=
X-Google-Smtp-Source: AA0mqf7l1GM+1in+Uo4hp9ulB/JA1vn363dWWJwr6CWQMxFco81Ih0QfK235HeX6iwSbv3baflNMRw==
X-Received: by 2002:a17:902:a616:b0:189:46b1:fe0b with SMTP id u22-20020a170902a61600b0018946b1fe0bmr5265985plq.117.1669262097267;
        Wed, 23 Nov 2022 19:54:57 -0800 (PST)
Received: from debian.me (subs10b-223-255-225-232.three.co.id. [223.255.225.232])
        by smtp.gmail.com with ESMTPSA id mg13-20020a17090b370d00b001faafa42a9esm154817pjb.26.2022.11.23.19.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 19:54:56 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id F20DF103C91; Thu, 24 Nov 2022 10:54:52 +0700 (WIB)
Date: Thu, 24 Nov 2022 10:54:52 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/181] 5.15.80-rc1 review
Message-ID: <Y37rDMB1Q9Gn5g/Y@debian.me>
References: <20221123084602.707860461@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="m8RHb0XePUCKlKuT"
Content-Disposition: inline
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>


--m8RHb0XePUCKlKuT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2022 at 09:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>=20

--=20
An old man doll... just what I always wanted! - Clara

--m8RHb0XePUCKlKuT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY37rCAAKCRD2uYlJVVFO
o2aKAP90gSYvj507poLMjIQxTK2VLml5E3sz31igtyMEUF58dQD9GELsELsAbxkI
N9O89nMeDAeYaLcdUux5yi1mGOWhTwA=
=8VWb
-----END PGP SIGNATURE-----

--m8RHb0XePUCKlKuT--
