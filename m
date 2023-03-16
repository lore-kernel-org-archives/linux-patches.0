Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDC337C
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 02:15:08 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id c10so272537pfv.13
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 19:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678932908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B7bwEIX4vuGYFkEKBEddYbRrI/6fE8qsxCOF1TIjz78=;
        b=MZ03RBEKnQleGIRX0tFf/7aAsgCg0aOEi+allnDD0ps5aEj/LL5by9oSiYzg3X5BoS
         7Eh/WxIWa1d03oXwQzKQrUpcJ/x55Cr+RIzzaW4jOBtsaVZrDTzHbEuXrx0DqVmmV+BC
         sf6f1nGnIG2HFe/1683wMFhM8F+FjPNWvGCOiTW4XB4OiekKhz31SJrKy3N5KjFmgZnX
         TrnCO5akLu1r3YaSVEhhu/pXEDzemJZJL28r5PhfA4MujgIOLY1VXcjOrYmNy6LO5BiB
         UGEp50KUbok0U9FHZyqFgdzg/WBIhYDt8yAKmktJP9quFNjOhSnj38cIiFRDQEamR4rx
         /NPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678932908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B7bwEIX4vuGYFkEKBEddYbRrI/6fE8qsxCOF1TIjz78=;
        b=6OPB/ZFIfL7N9Vec9lF4EmFYO/wiuNs1pOdiLwnxY6WBnwrHMof+QPdV5Ku+IvAvay
         HEqVWbr3BKYP8g83moEEk3M3ccKQez/NMrbESa/Q3YMjFByQpAW+cGZMSEN9YIIpd+1S
         rV+w7Q4Rn+XwW6FwE3Ks36bS72AqrEwHqCUiZBpYXbpg9KFqcETfktJrL95b/whHrXqA
         AQj+gBXUAfUOShfRs1RS/fejWJaj2m8B1s/lLf63i7Gi0hKnMfwaec5DkeI4rM1ZuJ1M
         IRtdrTjpnD6ZB1U9hIp/w0O3hpugj3uD0S3q1S0D25mUuy+2pbayPGsk2jdTshU74OP1
         ELLw==
X-Gm-Message-State: AO0yUKV+4EkvPjJ3WK86GeDhQTggWAHEku/ig04wnh/kDNNeE2V7/CVh
	nwGvqSTLtw+Q0ELHQbx5Ulw=
X-Google-Smtp-Source: AK7set9oNZv8zbpLYiKmMBPaOe/q31opMo3qYB0nAKKtSzmYV91xcpAYYxunESUE8BeohVrmbjmZHw==
X-Received: by 2002:a62:3803:0:b0:624:894d:c494 with SMTP id f3-20020a623803000000b00624894dc494mr1440829pfa.19.1678932908244;
        Wed, 15 Mar 2023 19:15:08 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-41.three.co.id. [116.206.12.41])
        by smtp.gmail.com with ESMTPSA id c26-20020aa78e1a000000b005809d382016sm4192302pfr.74.2023.03.15.19.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 19:15:07 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id B407D106570; Thu, 16 Mar 2023 09:15:03 +0700 (WIB)
Date: Thu, 16 Mar 2023 09:15:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/145] 5.15.103-rc1 review
Message-ID: <ZBJ7p7JqL8q8fo92@debian.me>
References: <20230315115738.951067403@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iU1vQcO7kNtDkCfI"
Content-Disposition: inline
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>


--iU1vQcO7kNtDkCfI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 01:11:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--iU1vQcO7kNtDkCfI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBJ7ngAKCRD2uYlJVVFO
o6ISAP0ahzMlGtsVKbIpNmx9d++6FDsnvWf++vafRF30NHWxaAEAn43WKgFXKDS4
NSgPoTG3I7q9IbunBDnucYR/ErVq/gI=
=kfKo
-----END PGP SIGNATURE-----

--iU1vQcO7kNtDkCfI--
