Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B397B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 02:44:38 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-63b8b19901fso6599968b3a.3
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 19:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682390678; x=1684982678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vnmu49LYpbrcjXvtzyfIeqH8cWymfaiLN9NPTdG0hic=;
        b=hXFCu1qm5eUBNw+kV1as/CBPpR5icy3VPO7FCBskP34oNGCZLr6m4GSv21JQxj2CPW
         nkx2pKOXgGOA8v3C3XqUjBm7Y4DRMiQMST6gATSQCxN8tPzIeWVYwEh2klMF+vGymcWL
         WykoUDxrUgo30igWZln6P09tXt1H+PvSayXvNW+vt+SaUopxjNw0dBPX9xU4fWqNjo1a
         c9zo17VXaBNMBSbCohl4gBIyPLoIMtMBSp8yFG3D5SoHkiJ/W6w3WgJjaGwUG4/1Dmk7
         w6tL6faTlnNv4OPqXmNSW2NYY+4AvlTWhz8IjzT5EkQvnnhzwStU5hvl3YeWPS/NtgVd
         zxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682390678; x=1684982678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vnmu49LYpbrcjXvtzyfIeqH8cWymfaiLN9NPTdG0hic=;
        b=AmckFBCxG8d5OsTr30Kxer4NyFNlCb7KZPSiWDWBgmmeFsG7mZueR1iQxpUzGVu6GW
         yFp+9E6GptSxATUtrs2dnPtWl2Ow0nnAU0mHqIaJMtSyK8vPkWpBiDB1kSKKS9BWm1ZF
         fOmkUodcEJtzP+hv3XktZNYaLd6AJ+yj+gW+wWAg1FQDatM2LroIcVHajwKxeVRE+xUX
         9aCllKkZ5F7xPi501+O+81HpdJ8lYz8CR/HJee2psP3iaCobyVMaIbfJJF6LlHed6V27
         HyFiFhgIuMV/unUlczlrDTEzGpWE99oSrxo6KX3Exb7M+8S2jI5IDg2JPHXP5DiOy1Gb
         OYxA==
X-Gm-Message-State: AAQBX9e6ORPXg84GkKCR1Vn7Qe1rW4220H71qYKpQRmPDM4E6TJKadq5
	0X1EZfxd/Gq6/s1LASwgLKE=
X-Google-Smtp-Source: AKy350ZYvox/gqS5RhVp1ml2RtNBGrrbnuB0Ye+hVopbnqp1yK4BnfRB9So6g/aQRIjf4SjoVAahgw==
X-Received: by 2002:a05:6a00:2181:b0:637:c959:8ea1 with SMTP id h1-20020a056a00218100b00637c9598ea1mr18707657pfi.22.1682390678382;
        Mon, 24 Apr 2023 19:44:38 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-29.three.co.id. [116.206.28.29])
        by smtp.gmail.com with ESMTPSA id p19-20020a056a000b5300b0063b1b84d54csm3205181pfo.213.2023.04.24.19.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 19:44:37 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 41B7410692C; Tue, 25 Apr 2023 09:44:35 +0700 (WIB)
Date: Tue, 25 Apr 2023 09:44:35 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
Message-ID: <ZEc+k264HZV4+YP8@debian.me>
References: <20230424131133.829259077@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="swsSzlQ4uVbn9Pg1"
Content-Disposition: inline
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>


--swsSzlQ4uVbn9Pg1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 24, 2023 at 03:16:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
--=20
An old man doll... just what I always wanted! - Clara

--swsSzlQ4uVbn9Pg1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEc+kwAKCRD2uYlJVVFO
oxMNAQC5KQYcaEYTeE6lpzIPGWDMlyOKOE6N91avpI9h67KXaAD+NzBPxaQb+mKJ
ITz//WU21QZZyoO15fkNojOh4sckRgw=
=JnXx
-----END PGP SIGNATURE-----

--swsSzlQ4uVbn9Pg1--
