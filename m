Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F354E824
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 03:46:13 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so3407967pjd.4
        for <patches@lists.linux.dev>; Thu, 27 Oct 2022 20:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ddozMKzLnmiIVXlU/iNB76qbYgY5HX3Ge5pJ0vqMWKg=;
        b=Vkhfu5qcqCC/j6VMNCJYmIb7edUpEbJbC562p9tZp/+QGQxlSME+mdKdWpou3DyYNp
         MNO5MB8NbO1h3LWGQZNc3uH5Qfu8xKYyd4/qZQYiIylQQ2SXfj1VqjK6gE/83ki7hbQt
         EI7b2IP0Oo5/mzQGEZ/MhRUw6RiBdP0btgWD9iVWyTJD/vdJ+EfEmkHdEeU+gCsU08GN
         xdssrUA99pRmjnsVO90mEqN3+LN4LmSUCAfCxwagmNcfs98as0hDa+agARGwJmoVzJhb
         aKYriUpF2kXRLKDopbRDnx8bgcGEp8wzYgeF4ECcT9RlPoRHVWkSFv0wjzT4yCmUFBPq
         mTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddozMKzLnmiIVXlU/iNB76qbYgY5HX3Ge5pJ0vqMWKg=;
        b=wZN4cKriJ6FAFUJk11E9S681ih8PHSdIF2WE6dkor+ipQFuwNEhYxr/RQd7pZw/p+D
         8Xp4GV+locvni0LBJ89KiBjBqmS/7/Gn0vLsIn796T2tdVCy7X1uMAKpnhKb974WpZpE
         CA3EdLDZAtZ2o7y5e/EyNLAfHupnLjzMArR2PxxYy6NaXXHXZ8SBPr3cVc4o+fGf1ZQu
         SUDxvA5d1f5+BnHeuVUvBgd8Ty++vv0J8nsO0MmiXSvxQqyYBE9dLkWkm5Jeb5HKOZX7
         Eqs7dd/+NQQ50S2YrfEVvk7kYpAd0Fxmfb2QBFePK1ycVA/1u+Kzz3lbGMQ+Bm0Tct9N
         CNfQ==
X-Gm-Message-State: ACrzQf1ABla2/Ljh0ZYRpmS23kwxxK5wmn9vAVU3uw9Kp5iFvO6GvULJ
	G42SyC5IPU8iKIqN1bN3rTQ=
X-Google-Smtp-Source: AMsMyM6SdE9CLSayTRSvlmTYrySWUyzc1bJlBA2xHPiEHlLa4xpPBnv0LBYV4SXHfxukdvQrQVoFfw==
X-Received: by 2002:a17:90b:3505:b0:20d:ba2e:994b with SMTP id ls5-20020a17090b350500b0020dba2e994bmr14182652pjb.46.1666928772609;
        Thu, 27 Oct 2022 20:46:12 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-58.three.co.id. [116.206.28.58])
        by smtp.gmail.com with ESMTPSA id z16-20020aa79910000000b0056bd4ec964csm1873560pff.194.2022.10.27.20.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 20:46:12 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 4D6E010030A; Fri, 28 Oct 2022 10:46:08 +0700 (WIB)
Date: Fri, 28 Oct 2022 10:46:07 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/79] 5.15.76-rc1 review
Message-ID: <Y1tQfwsHYPzA7BqZ@debian.me>
References: <20221027165054.917467648@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6AXgGbyqm93EDBa2"
Content-Disposition: inline
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>


--6AXgGbyqm93EDBa2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 27, 2022 at 06:54:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>=20

--=20
An old man doll... just what I always wanted! - Clara

--6AXgGbyqm93EDBa2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY1tQdwAKCRD2uYlJVVFO
o4pRAQCF7hCFp99vkJuPn32klRg2GNFtmRa+dSiPSdHKRFZlxgD+P3wCrPaJtnzs
fpJkbNMQg372l3usBvhDtfGUE/ymLgM=
=c+HE
-----END PGP SIGNATURE-----

--6AXgGbyqm93EDBa2--
