Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99691DF251;
	Wed,  6 Nov 2024 12:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895797; cv=none; b=LJ3HK/tKLIV8vDoC/jBUtB3xA6YkVvyVLwU4tMI1wFBhv5AGFJ6e74J0oGJi5rtgv9rI6CmGjz2JL59fh9v5+RlV48a0uj8qCX5J05htfxbqS+y/EqS0egW66t5aOmsKaZ7JHyiLknWxODoc79ne7a/0Ew+zwyJy6Fs/c6lSoZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895797; c=relaxed/simple;
	bh=LOcx39WpVkgfByGcE2LRb/j3Yp/QZsre70eNEo5cn4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZATViSbhxNkdIQFkq4GttlexRha0yrXI7N4H5UrqpfKIEz6FQYTK7tZ1vhIJMLRK3egd1ZLwOlWwE0AA1lYbBqomZf0MgIcotIaLiZAgXWqcQjoRtDzclvjL8IkP6j8iDJeQLHt62qCV6GZeVWvwmEyjPzW29sgwjltat868Vh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ALW6Vj6G; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ALW6Vj6G"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-720be27db74so639851b3a.1;
        Wed, 06 Nov 2024 04:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730895795; x=1731500595; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LOcx39WpVkgfByGcE2LRb/j3Yp/QZsre70eNEo5cn4U=;
        b=ALW6Vj6GGqze9XvVZx9JEzSw7cKMLMzPSSX5nPfFb3PIk9DuyvkKFdA69FqlAUX/tq
         vfNnGEPrwKvtwqDGNj3BpMO2pvLCBu4qjczz2x0U2A/4Wi7MGzcDo3XDzFibnPnJ5xT/
         Z9VjHCnr50lBhOxV069Y9Qh57f7PIFDEwPN0l7ytuhT11BQDWUptdJCD/Qn7TaZdYSkn
         3QQVHHSiOITrQ2P3tk1Atd4HP/9vm3dpBkh1hRjhKjSw7ltsW8uDH8Q3zzElL6+XEFQ6
         zBMhz2+MvOWKPUvvclBJCeR+o/W2wGHkZnDFjnjf86QvYgN+wy1C4YMI6QGVHSRGQrjw
         okWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730895795; x=1731500595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOcx39WpVkgfByGcE2LRb/j3Yp/QZsre70eNEo5cn4U=;
        b=nkvt7vX3YmD6Fd+iUM0alWRQophWETBaMD4hxtBqaU527Az5ooQ0oPCW0bc9TRRt5i
         f/X3bUnvQ63s8bAMdOYGS22UPjF+hRY4TGnmJegnyB8kOQRa6T6pxOJU5qY9VRXhF9gE
         Q/Pm5qTYRkeQZ+B31mVR3wm7yJbtfl8ihBRHNXU9GRh/L5a/TjsbJJCVGWwOAJJmhWQR
         Xk3H36uv1N2oib+Ii9pTufSrcb5B0JDHnftBAk5yApJz1C+4pg3JjvX9CKmJY/vVRR1O
         s5I/Vw2reDXyjhhHhuRGVWzfNA3hkK8LN4AWbE9/jJRVy4hzQATXNtol5RKTDargevS/
         TpDg==
X-Forwarded-Encrypted: i=1; AJvYcCU2mO7ye4MgF5wVAB3zwVCJD6DMUA3nC903IZANzVIezm+i7B3cDnl7tTOr+lebpa6V6v4PtGqzDQ==@lists.linux.dev, AJvYcCWgLeZMN+6me8hcG26MlNCfLbu/rvFLRC95egXlsFim/KhERQ08ifQtHcRmAbHvEV8wNvbzLA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1qcTieh//z/Mjo14P8/UxPkHbgeRUhlJqjNiKRgLxgMn+HTsj
	4cFCcPqWUX7xElbYxjLFjyZZv6V3msE+FNpEINozk16V6HJg0AXd
X-Google-Smtp-Source: AGHT+IHlm62VXnUBPd59sCVU+HT7bAgeu3hCGilmSCgsLu4geYKqabYoClmdsAEnS+JE+O9J3JzzKg==
X-Received: by 2002:a05:6a00:2d9f:b0:71e:60d9:910d with SMTP id d2e1a72fcca58-723f79bb0f7mr4043502b3a.6.1730895794957;
        Wed, 06 Nov 2024 04:23:14 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc2eb3cfsm11545357b3a.151.2024.11.06.04.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 04:23:14 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 6E2A9447D1DB; Wed, 06 Nov 2024 19:23:11 +0700 (WIB)
Date: Wed, 6 Nov 2024 19:23:11 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com,
	kevin.tian@intel.com, corbet@lwn.net
Cc: joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
	robin.murphy@arm.com, dwmw2@infradead.org, shuah@kernel.org,
	iommu@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	baolu.lu@linux.intel.com, eric.auger@redhat.com,
	jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
	shameerali.kolothum.thodi@huawei.com, smostafa@google.com,
	yi.l.liu@intel.com, aik@amd.com, zhangfei.gao@linaro.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 10/10] Documentation: userspace-api: iommufd: Update
 vDEVICE
Message-ID: <Zytfr7p_EpJhJn41@archie.me>
References: <cover.1730836308.git.nicolinc@nvidia.com>
 <e1ff278b7163909b2641ae04ff364bb41d2a2a2e.1730836308.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="syaj6gmswHEiPKJ3"
Content-Disposition: inline
In-Reply-To: <e1ff278b7163909b2641ae04ff364bb41d2a2a2e.1730836308.git.nicolinc@nvidia.com>


--syaj6gmswHEiPKJ3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 05, 2024 at 12:05:18PM -0800, Nicolin Chen wrote:
> With the introduction of the new object and its infrastructure, update the
> doc and the vIOMMU graph to reflect that.
>=20

The docs LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--syaj6gmswHEiPKJ3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZytfqgAKCRD2uYlJVVFO
oxifAQDdYsaaemlGOg+HrwqFiJ4FGcIBJuGbdcKG/6uUBE3M+QD9HxxzagI26xbd
JHDxjJmzYXAcyjOWhV8j58xav3gTZgU=
=8SqO
-----END PGP SIGNATURE-----

--syaj6gmswHEiPKJ3--
