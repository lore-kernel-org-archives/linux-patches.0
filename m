Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D4A15C4
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 03:36:14 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id l7so321684pjg.5
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 20:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679456174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dE6cUqLkWexq10WcTc729+dY2UIxjJT8AIzlQ9w+OHY=;
        b=aPPB9nEKTvQGYSm3aRvSCyFHLIP5wCvBZYftrgGaFz46U7e72jodASvVx1Zr5Tkph4
         Asv+m1Myg4jzNZ42PB5UQZ/XCBUPOwkgbNxZRes034U1Kt19dxj7vMu6friN9B+nwawO
         BcsSQ2P4oPx5wg7i41Wez3oEHgSRsEaxV5MZHdh0aW5XXlsUPNV6g4siQHlKDXAOyIrI
         i9l9cOJTfORRo++9zK4jfXIEEpWJQLFtKtj3oCEwl+wCs/cwMt3gDaoWSqjUOpwjZNgL
         k0bGSyyUHHLl0zRspxQNHwKDDFyfmzKdqd7hgRk6av5cy8LecB1NIlxm+AlUQc53GEfk
         ADBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679456174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dE6cUqLkWexq10WcTc729+dY2UIxjJT8AIzlQ9w+OHY=;
        b=IuxjQPklHLsY/GYRhMHiTt5avTTuwQ0HDBZPzAv1Q+rXX1elydamHGQEakbTj3imTG
         IThjN/6UA1E7VYfcbx4bEoSB8I5UIalH6tyX8f6ekOkQxi74BS2p8JB3RBPmxPqY1nW4
         RzmDDqYyhMOXKp4S/zrZVmGgeLFFmgXGFBrtx+TQEaznI3bmzAVBZHT4L0qzcFjXoafS
         yRIvwIQnV5002V5WW5/4bvymwADmmBfni1U4DwWuRrdX6gVYfB4hTGoBuB1PhKJzVEWO
         a3YdQty83al4+MbMGy7wmaRgwqSTPlpIlhRfKdCIhv+a09bcxkPCYSgAn2D1RDp0iUwD
         qOmA==
X-Gm-Message-State: AO0yUKVE13Bwz0LfRNsX86QHG9sJY80Yw/EX16GdWHkWdtdGPliheWre
	X5Cm//HI29KdMk8qpzRY7ZA=
X-Google-Smtp-Source: AK7set/kbWEwOcYxi4SQnjfsHzpzCQ78++mlhj+bdhi3XyBOX4Q47mqN02lmBv79T5Mxlc9U3DlD9Q==
X-Received: by 2002:a17:90b:1b41:b0:23f:7666:c8a5 with SMTP id nv1-20020a17090b1b4100b0023f7666c8a5mr2015596pjb.29.1679456174411;
        Tue, 21 Mar 2023 20:36:14 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-30.three.co.id. [180.214.232.30])
        by smtp.gmail.com with ESMTPSA id kx15-20020a17090b228f00b00231224439c1sm11589001pjb.27.2023.03.21.20.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 20:36:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 8376E10676A; Wed, 22 Mar 2023 10:26:27 +0700 (WIB)
Date: Wed, 22 Mar 2023 10:26:27 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/199] 6.1.21-rc3 review
Message-ID: <ZBp1Y+oq7XhSatq9@debian.me>
References: <20230321180747.474321236@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9GigIbS1uzcWMeqb"
Content-Disposition: inline
In-Reply-To: <20230321180747.474321236@linuxfoundation.org>


--9GigIbS1uzcWMeqb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 21, 2023 at 07:08:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--9GigIbS1uzcWMeqb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBp1WwAKCRD2uYlJVVFO
o1q8AP9Vsj2VJu/ZVALbbhIOwHPd34wj/3bVs1XbEv0lSYC6qQD/Qr5f1hMs3ilS
21KiRZ7u89iq+uLWJZjP2brra4quaQM=
=p3oV
-----END PGP SIGNATURE-----

--9GigIbS1uzcWMeqb--
