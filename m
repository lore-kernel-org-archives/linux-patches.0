Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B300801
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 12:22:08 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id l6so16110401pjj.0
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 05:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JEShaRfMku8DHeXNO4LQW1dHyOinHMJ43eNJ9bIDOWM=;
        b=D3tUFE/xE1CysYqaKvGy8yTFXDrH7jS1GsQC5qLa1rDjVTShnIrjVTqghLIpFEKUxc
         qyViwJIRo2fRRomhC9jo/30MvYwTNqWaRIsW36z56F0T3JBFpVRGYPr0hbB+hy1JJsNt
         rC4i8UEmJRmHzqFurseV5jMuVYOBBx0b4nED6bCoOOkRCF/soBSs8hMQeMQ/7AgPZpZ3
         oqnSUK4jYc7XbI4jA4Q+BS4KzALDs44wj78qcUuQqeLvtu9kIiBQmU9qEv3YbPwBo+on
         5EofhJslp/kC0M7e8KOyy6E5ZJIJfPncpDsta/nhd+2qNBWMzGJDZMQ7NjeskN4uNVTF
         KzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JEShaRfMku8DHeXNO4LQW1dHyOinHMJ43eNJ9bIDOWM=;
        b=GbCoxZwOtiv0q/tECYclJVrVckjj9tu7ShOuLEpxtbk41ZiLOm5LvGHxr0F1feVHJX
         TnoH3bMPxFCjWymN/oifF/SXA2OVjFz+8+TreyogBatg5GOVyPuOslAgJunTHacMeQsC
         4yp+vkUDVDWZdLqzfyKplKJVI1wF09x72gqtBI6wGJaxKMwKqJUKCKqB9sUuJrcFeCZc
         kZ+112JSeSrLAaqtZiTU87kI3lagemcQyZ6X0tIMhV5Ia9udDRVlDfM4lc9sX8gqGYEt
         gZsrPcaaGH2bbUF58CWKb47pq/ula238A6QBwQ1INy9/RdViVFO2hPHyp+zMq7vR70Rs
         O57g==
X-Gm-Message-State: ACrzQf063Cb87F9kVht737A4wTuvny3IPNWICxKlzuAK7I5mR5hRGAc1
	XBeNVF+Dd0IYhyfQMM7c3a8=
X-Google-Smtp-Source: AMsMyM65RYH6ciM+fZDqrbhmSDXAc+gMN5djcopTDmIYRNzJG06FGRyamDO2FAN8R/pvkMj0p/rZxg==
X-Received: by 2002:a17:902:a611:b0:186:9ba2:148b with SMTP id u17-20020a170902a61100b001869ba2148bmr24573732plq.164.1667391728428;
        Wed, 02 Nov 2022 05:22:08 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-50.three.co.id. [116.206.28.50])
        by smtp.gmail.com with ESMTPSA id e10-20020a170902784a00b00172fad607b3sm8113175pln.207.2022.11.02.05.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 05:22:07 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 66F7B103835; Wed,  2 Nov 2022 19:22:03 +0700 (WIB)
Date: Wed, 2 Nov 2022 19:22:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Message-ID: <Y2Jg69Op79H5kXDQ@debian.me>
References: <20221102022111.398283374@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FkJ6buWqUvS+9+zA"
Content-Disposition: inline
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>


--FkJ6buWqUvS+9+zA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2022 at 03:29:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--FkJ6buWqUvS+9+zA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY2Jg5AAKCRD2uYlJVVFO
o98WAP9BxmlTA3xmkOPMlfTdW20dno0sHygfqS/V7sF7Yv0nXgD+IJZ7tWActesP
CUbDDlsJT3v5YwYW8R9wvyvxRfsDVQM=
=+6/u
-----END PGP SIGNATURE-----

--FkJ6buWqUvS+9+zA--
