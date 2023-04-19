Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092EE17D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 04:12:54 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id sj1-20020a17090b2d8100b00247bd1a66d4so323481pjb.5
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681877574; x=1684469574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fUpoLAyaBnHoLBaSwM9qtf9/wGXRRRACC5BoxLWeyNw=;
        b=EojCyYsat/ZZOwGfDI2eEqUVJUYOnPwystmFz4xB/MPWuI5lkbgjnw/2cIdPK6syN3
         jqat81AgUkOjErKJjeZRTAEou4oYofjhzWajAqx50gojTF9jlY0SDDb92pckxL+3w79E
         tBVRCzDKbuS7z+QOk/T9lpRAx4de6qkkegq54Otf1zw3Cc5aWMKny5QyYhz1ONugjqeW
         BltJ4SlXLPz1G6MYH9FWKkixMHb2pjV1vdxe4FEXX8Avz4XOl28YJgJ33Y5TIb4AVKrR
         TKc3u7kNBbJoeyCehuQ19BroyasUHjt+qtGZLyJj2rpfkZqIBj79jXhmrmOupp4KeCly
         djqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681877574; x=1684469574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fUpoLAyaBnHoLBaSwM9qtf9/wGXRRRACC5BoxLWeyNw=;
        b=cZ23WNs2NClw/mLotT7yaYUXqLURb4J/qGzCBSlrWIMzNhfMFIp0BtWjb0bGGnIYBk
         PJxk6cxtXB2pR8JrdyAA2FvjvPyXcM9+VbZXgUwbvabwk7m/LiTpam9qsmDMranmmUzQ
         cvgJToxOKT9IJPnVEeGBL8ccXb7/IlRAKW0R9SjbzqvGA/psT2PFOw71vi0ph54J7pUo
         32297NVyKL23SeT0faQtEs1ESDgBS9ukyIQCrOhtJE7XCCNBnjLfF4DVVMk6x4/BHrP/
         jt+ZMxxZLLSfr7IS9BgvDsPvV4OjP9VY5GWSudO6qX0by2oJOzxsod3O8lGGWj/WIecf
         uuCw==
X-Gm-Message-State: AAQBX9eeQjzIvY231MCP39pqRNiv1vquenYiBCQhHn4HGDUlgl2d8rus
	YvPG/luoT3PMg1yi1ay2LIU=
X-Google-Smtp-Source: AKy350YeRvMFKD1SJf6/b3CkhkM4LUy3zGF5EMcN1AhXtI2rivOaOGq2H+4LZ7fvvWaW3A4jHjeCvA==
X-Received: by 2002:a05:6a20:8f27:b0:e8:825a:7af5 with SMTP id b39-20020a056a208f2700b000e8825a7af5mr2184734pzk.14.1681877574398;
        Tue, 18 Apr 2023 21:12:54 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-1.three.co.id. [116.206.28.1])
        by smtp.gmail.com with ESMTPSA id t24-20020aa79398000000b0062bada5db75sm8730797pfe.172.2023.04.18.21.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:12:53 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 232A31067CE; Wed, 19 Apr 2023 11:12:51 +0700 (WIB)
Date: Wed, 19 Apr 2023 11:12:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
Message-ID: <ZD9qQ4mPYGSnCmJY@debian.me>
References: <20230418120313.725598495@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6dj4q6pLaDyjfhcg"
Content-Disposition: inline
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>


--6dj4q6pLaDyjfhcg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 02:21:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--6dj4q6pLaDyjfhcg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZD9qQgAKCRD2uYlJVVFO
o5PiAP4mOO92addYIrSq+MlTAsfM9ovT6jn+wdG5XCUVAEKMIgEAq9tN0Oedt9IE
pOOGwqivlz6Q0zFV5zeXy+2Zqj+ZcgQ=
=yFq9
-----END PGP SIGNATURE-----

--6dj4q6pLaDyjfhcg--
