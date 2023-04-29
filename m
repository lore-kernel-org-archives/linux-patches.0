Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C23923A4
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 07:43:59 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-64115e652eeso17299898b3a.0
        for <patches@lists.linux.dev>; Sat, 29 Apr 2023 00:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682754238; x=1685346238;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fNsx+EGWInTOeiZ4tD3MVuDHiRQf5TbDrLEYxwSL/bM=;
        b=jY1gx92+1HxYj0Kd65ZE6f/w+Fk5U03K5aPD3TFgwk519gMgzP64KRJxruJHo31BVK
         8eFJug7Hss3BcoVyElaMxbRPyuArBtzdgcMcSNI2hZmWUwscpi3jN3WItnQDi6IvFX1j
         cYSDCi7dhUzfsBKUOwEekwE+W/kiRNgD3+bLBqvtXbSfIbR+14R2P+FHriRnOCan0Nlb
         9xKfNWOGC9edtaP4WWUNkFHT1ELUkBEv9vDOEMKoWLwNawFSSVleYAKZ79sb1lsfKccn
         bm1pxAR8kHursWMhlJGQATaYRih0UzgWXmnTISqfgn/p3pMF6KzsC8QksClKky3ttxhC
         oF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682754238; x=1685346238;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fNsx+EGWInTOeiZ4tD3MVuDHiRQf5TbDrLEYxwSL/bM=;
        b=a6U0NdGFsIO9JkWqvmyXGs0j7XwwkJ5//GmrYlL5o5Wv/ksPB81IkVnzvtdgMztd4/
         97Rko/fZ7Efbmxt93bmt9JWq0YYYKdgiGjVd6yYMzKc/xtqKGEaWWGZKdew3eRZEKlt6
         xN0EtxdK2KRV+q5hr1vOdwTpHLrX90ZjUmVa078uGeNYk88DJ2+NFCVWD+qDldGoxXG7
         hXBDU3MYLW2D/Gxno4T3Z9EEqypw5V6+4/8OUFFaRoAWnCAx8+/bhKoyN9m5k2hgpUmX
         iMlmz5bliqt+va9QJ2P5ncvKfSicKeddtL54YtLoNCPTXxfaSiog8GGaGZKy9am+rrVy
         4t2g==
X-Gm-Message-State: AC+VfDwq+HJyu2bjXcSwDnJXsgEhuyI5sakpjvPxlMLJ4xnrqmwqAsrj
	UXq0PD5+NLZyAph8K3VPH4g=
X-Google-Smtp-Source: ACHHUZ7GSSty4wq83CAvMYKvcnYfsaFPIsonBYyfBD4mAdRbxUHXh9u9Or+yszzrhdhg5ldaFNBtkQ==
X-Received: by 2002:a05:6a00:21d4:b0:635:d9e1:8e1e with SMTP id t20-20020a056a0021d400b00635d9e18e1emr15399410pfj.11.1682754238381;
        Sat, 29 Apr 2023 00:43:58 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-88.three.co.id. [180.214.233.88])
        by smtp.gmail.com with ESMTPSA id fe5-20020a056a002f0500b0062de9ef6915sm16138803pfb.216.2023.04.29.00.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 00:43:58 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 6B81B106978; Sat, 29 Apr 2023 14:43:55 +0700 (WIB)
Date: Sat, 29 Apr 2023 14:43:55 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/16] 6.1.27-rc1 review
Message-ID: <ZEzKu1gpZZD38rqQ@debian.me>
References: <20230428112040.063291126@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RKt0aBtYhjpidQhr"
Content-Disposition: inline
In-Reply-To: <20230428112040.063291126@linuxfoundation.org>


--RKt0aBtYhjpidQhr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 28, 2023 at 01:27:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.27 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully built and installed bindeb-pkgs for my computer (Acer E15,
Intel Core i3 Haswell).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--RKt0aBtYhjpidQhr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEzKuwAKCRD2uYlJVVFO
o8VFAQDYWVuLFqY9ZedQsA4I1jow6eAFXKNzDkhRWPfRDrSZ+AEAvjRO88mA2cWJ
Cz6HiPN+MzlS/nJDL0x1iF9TORupPw8=
=kTn4
-----END PGP SIGNATURE-----

--RKt0aBtYhjpidQhr--
