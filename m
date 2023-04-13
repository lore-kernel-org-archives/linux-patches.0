Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62C062F
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 04:07:23 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id h24-20020a17090a9c1800b002404be7920aso13918974pjp.5
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 21:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681358843; x=1683950843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PO+vdvsIJNOaWSleJ6Y04GDPWKMtg3yaaz87ocesbmM=;
        b=FDADdNbB8g5KFVSWjjoPntbHQk+UV8Hhw+3P3aGQbJWLqA3np5d+LEp2SI3ExlJvNC
         MIENsd01RUW3NVrtIHjIfARMjLywWUqTNk2+Yp0bh62eZn9edzUFC4kX9AmX0pyADJ/c
         NMEbV4zEVI0dq/dRJrbeCZIBtfr93VwWDq5vzA5Pu43ylhL+eMbgHEM60EzkGiOppogF
         UomSrOZs2MvJQV7aLdtAfa+V11anglEMn1EbkYKi/Copb5OxSEHId1hcIR1+c8na4Lnq
         8WAIzc/V9nRUhmadNjMlHD646noj7J14ztmC6M5ju1XWKg8rvvYFplhEz3oi7lU3qR7K
         uPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681358843; x=1683950843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PO+vdvsIJNOaWSleJ6Y04GDPWKMtg3yaaz87ocesbmM=;
        b=FLjJmLKYg1PdWnP351HKFDqG4/WoYTAAIE9bhJOhMl8pWI+jIK19KCIfshXTyu7MFR
         WKQAsxfDNLuwqewxU2mddzjupVf7itL5iwaiknkWC/S6L7fo1x+zWKNUn9e5Z0AEMSz5
         mApZIAWwakNNxqWRBkyZhlmlP2AjAS6M6XItD7ClzvNJBtkhk+ZUcRb4cRS1dnAn1QUi
         pLedlja+plmZTGcEC+U2PqGTZYKmqRyksb0Fjg7IBaDt/423iICYQp4bhVI2Kv1aY2oS
         x1ZMNOSFEujtbInFDZnhYB7g6U71Jda7r0bUzfICbxl/0bL4Ex2UEk6B1yhyXIRWsv7o
         1KOQ==
X-Gm-Message-State: AAQBX9fM/2g/suV5sK/aNxjCwpKo+Hb2pGimoiPwyEX6JFyR10RwbwI1
	kNJmdq/88a8tpwyz6dvqI4U=
X-Google-Smtp-Source: AKy350a4BPiDFFLqA6Z2k5yhYxWCmS2S5JDKkXycfKyuzADWf1WaDNcmu/oS6W4w88/4uCRN5UWrOw==
X-Received: by 2002:a05:6a20:e94:b0:c2:b6cf:96db with SMTP id fk20-20020a056a200e9400b000c2b6cf96dbmr752512pzb.39.1681358843069;
        Wed, 12 Apr 2023 21:07:23 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-66.three.co.id. [180.214.233.66])
        by smtp.gmail.com with ESMTPSA id v6-20020aa78506000000b006227c3d5e29sm272859pfn.16.2023.04.12.21.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 21:07:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id D8D6D10681D; Thu, 13 Apr 2023 11:07:18 +0700 (WIB)
Date: Thu, 13 Apr 2023 11:07:18 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Message-ID: <ZDd/9j+H8C1rBo87@debian.me>
References: <20230412082838.125271466@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yRolHaZ1TJc5Bwrm"
Content-Disposition: inline
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>


--yRolHaZ1TJc5Bwrm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 10:32:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--yRolHaZ1TJc5Bwrm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZDd/8gAKCRD2uYlJVVFO
o6GBAQCcDE8+tD7AojGenlulHtVV7sbZE7pU6bf7sNjRuirv5QD/fw6Ma87ZMybJ
tF3p305nGASkudNazE4iPxsdL5cR2QY=
=OkXz
-----END PGP SIGNATURE-----

--yRolHaZ1TJc5Bwrm--
