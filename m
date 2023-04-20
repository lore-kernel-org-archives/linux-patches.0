Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1581844
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 03:52:07 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-63b50a02bffso529509b3a.2
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 20:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681962727; x=1684554727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w1FVwpm//7EWGjghRNYvD8w7GqajWducsGw/6kvzTVA=;
        b=BzQ1UtsxhBck6ucDpFGCJgIgDed9yrUMGTI9yMsZiIKN7Vy22W/aKPhYjdhXuYs9ZV
         ERDP3B8Spk55sx6apOu3z9zfoFeEoSxZ/K87wGy7amdIRGQy9UMt3gYo6ugOVc7PR87n
         HZx8QSTKCO5phk/nTCvf5ICcffV8es5BhHMA/Ay4Pz5d/ME4LI+CMTdjPPXmNLVmczwl
         rvAobjeoZOXlZKy10tWcXG9XmEdoO6ClEA6o1JWnoVJB8SIU/NGOwydiymVMfrA/3xCb
         9aM1WHabVGQ2Vm7HNbDRSE/Jya7zvJfydwg0865KjrIMIyKP5L/TR/K1kwd7K+tszXvz
         woIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681962727; x=1684554727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1FVwpm//7EWGjghRNYvD8w7GqajWducsGw/6kvzTVA=;
        b=Vswgs9PJi9rCr8c9r0jBIs4fmzrcnqRj1O55BD4RZ4VcQDEsDTonO3jws27kXOywa9
         NOQVrveZ1I7PYddIcC33qG93TaALvsCTzihlok2h3JZqVzfemIdmD3bY8r02DB15k+tN
         RzChnF/7dNKSbDaxyxv468czTAPNyfYQKFzb3a/EZdB1s2YLm/q22JStxVPWelXkJiCG
         8boFGRjXW2t3zoKSJjVT8JxpWEWm/ducYHueno+Qb/r1x2WDUXvOegFtNjO6MAwiPHdu
         Ug9PyFy0ttDX5O79cAl6S9gF1VmxbMsJFeHQsssCzWqE9naZktz2s5LARO755Xv+KCoO
         lYww==
X-Gm-Message-State: AAQBX9dq96yf6H7xl/9Vn6lLKn29VluLDcSdhmq/aAYJEoeeP8IGfDYi
	iN3+jKhwZmpvgu0p+aue2Qs=
X-Google-Smtp-Source: AKy350ZSZhLNPS4nORKG8s7eLG/Lj92AeETj3ZRbNRnBnge97bQWaxx+5yNBqgizAaNq9zC2vlzJ2w==
X-Received: by 2002:a05:6a00:1356:b0:63b:594f:bd1b with SMTP id k22-20020a056a00135600b0063b594fbd1bmr7594108pfu.3.1681962727289;
        Wed, 19 Apr 2023 20:52:07 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-6.three.co.id. [180.214.233.6])
        by smtp.gmail.com with ESMTPSA id x35-20020a056a0018a300b0063b6cccd5dfsm136556pfh.195.2023.04.19.20.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 20:52:06 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 6905C106852; Thu, 20 Apr 2023 10:52:03 +0700 (WIB)
Date: Thu, 20 Apr 2023 10:52:02 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/135] 6.2.12-rc3 review
Message-ID: <ZEC24ukqNNbLaywF@debian.me>
References: <20230419132054.228391649@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wwtHWNsJSpGMTGlt"
Content-Disposition: inline
In-Reply-To: <20230419132054.228391649@linuxfoundation.org>


--wwtHWNsJSpGMTGlt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 03:22:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--wwtHWNsJSpGMTGlt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEC23QAKCRD2uYlJVVFO
o7FNAPsFeZ9Tzof2z+T5F2RsXY77z631QwX1ummWyk4TIGqutwD8DmzwgJHqST1I
MKKVpx1LRKdaDp5bi3nZrfn8YdVdFQo=
=l0Q5
-----END PGP SIGNATURE-----

--wwtHWNsJSpGMTGlt--
