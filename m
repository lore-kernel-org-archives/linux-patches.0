Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42034539A;
	Thu,  7 Nov 2024 00:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730940999; cv=none; b=HKYl5nkbJ2wsCNcP8ipwXJCujBnVUxF8PzQEjrewdeoRN7u5BXxWIq4zpwh+c++8cLPDeWONEnhLG7Tv/fdZw7pOUWhBYdEQAYajaR+jcqQY8P0lcW1Mgv4ruc3dO130cKheGRhy6BPbNmsiV/bTu8i3jmjgm0rYGswIYilTgSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730940999; c=relaxed/simple;
	bh=PLaojtRXC7+p9v3nWjKHwHm1S8O3lMOgiSI9DIAjLKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtSsnFP8KgTUYiZcxYJDrjmQRiCZyvxa4Z912qgDJc/XJquyg77vtFj5alvjrmR0GuT8KkGf+MbhEGgwdHyIomkB1RCPWdUWSvafP8UHfnmyfSkKxdgDfY6Oekc/NTfryP+XZyGuniwpj+Ijm8tMXwDqnn+nM7ojhP702CQ2Wsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L7ppfESk; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L7ppfESk"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-72041ff06a0so294652b3a.2;
        Wed, 06 Nov 2024 16:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730940997; x=1731545797; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kb6nMRvMwSxA+8+ha5/4tfagx7bwoqrFwcZIkWkVlTI=;
        b=L7ppfESk4c0fIqGRNgsBaOIjXWFiRtsoGKj2J4/5J1CYvVhEA1P3ANfrHDZX7f3F14
         dDaXbdUFtHo8azcDe1h5yngYBmGPje6OHya+oxIoTzzs+I8sga4cfNBod94lyQInP+Pr
         VXDSw3D4i7CRUxUoFJMPsCoHpH6+AjYXmGfNfr6EAjq7E6Rc0kz1mLdTaKDvWYc1nB6C
         J9F5VOtWfQ7DHm8yvQbSV/hI9K1HG+TXcWEC+oiQ2vfsy2TDN6LTb7rm4E9+7vuwc/Ph
         tWvU7NkKKEs7RkkWQIuL/y6Be5rIE5W2Bd/bYH6EGHEZrdALX06Eciis4WlUnaCI1Pwd
         23xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730940997; x=1731545797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kb6nMRvMwSxA+8+ha5/4tfagx7bwoqrFwcZIkWkVlTI=;
        b=mJDa+dxGNmyaFSVdGgfpYwpjJdL7wZ2tOaMJjn2ql7nqaUmoiCg5bvlTU+qSkgicnp
         5k2kMx8Gz0eA/gF9seZd1/+3PHyVdm8ubFRBcXXT6I9Ki4i6ZvXZMWFybYl/eHdchCoT
         npvWuUqwMgwIzC5EFtnywg489puMicKk/XQYq8+LR8ZkuriW4PD5eoCjiYz9LheZDeHm
         EUHP9X7YI21oDfjT7jlRTNDIqipAScgLEVs84eWXhO+KWJDC3KhKeH1dIEY8gkijAFa5
         e7vXrcXneoZCIOkr2qrwf+cO7x3fbaazUsDQJidPz1veRbNY8vkpVkX3mDeI8EwdzZ20
         oh4Q==
X-Forwarded-Encrypted: i=1; AJvYcCULM7zds+LLylPlYuKa4BV/EfdE/9UUjItkBIaK6VW7RydWk6KesarqC5DJkP55AyfQ2Q+OeJeHAA==@lists.linux.dev, AJvYcCXGm8fzUhfUjuFHrOwLnzP3IC/2UYSSM6mwkUWWLMlv+fXMZ0fBJtHm4n8Jl61JHUoYFKLt2Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9/BCKUSzXqVcarW0g0mzyOWzkrqP+N1ypo+fdxZ0ObjO/R8jX
	+SsYw0dwlcMD6O+U1AWiiLsP/LHQCGMjrxpLXCAr4Y/KbUFyN7wd
X-Google-Smtp-Source: AGHT+IEYiPOYXNXocP1QxbgwprQfTHsIgODY98a2lMIztatnt7OohZLGlw/YHFai1ZjQ5Pw50bk/qw==
X-Received: by 2002:a05:6a21:328c:b0:1db:e1ce:8eaf with SMTP id adf61e73a8af0-1dbe1ce9763mr14975018637.6.1730940997311;
        Wed, 06 Nov 2024 16:56:37 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7240799bb8fsm180679b3a.116.2024.11.06.16.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 16:56:36 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id AF82B41F52FB; Thu, 07 Nov 2024 07:56:31 +0700 (WIB)
Date: Thu, 7 Nov 2024 07:56:31 +0700
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
Subject: Re: [PATCH v7 13/13] Documentation: userspace-api: iommufd: Update
 vIOMMU
Message-ID: <ZywQP3_TpdttuCy8@archie.me>
References: <cover.1730836219.git.nicolinc@nvidia.com>
 <7e4302064e0d02137c1b1e139342affc0485ed3f.1730836219.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="R8eh+sitfrxXSbCw"
Content-Disposition: inline
In-Reply-To: <7e4302064e0d02137c1b1e139342affc0485ed3f.1730836219.git.nicolinc@nvidia.com>


--R8eh+sitfrxXSbCw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 05, 2024 at 12:04:29PM -0800, Nicolin Chen wrote:
> With the introduction of the new object and its infrastructure, update the
> doc to reflect that and add a new graph.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  Documentation/userspace-api/iommufd.rst | 69 ++++++++++++++++++++++++-
>  1 file changed, 68 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/userspace-api/iommufd.rst b/Documentation/user=
space-api/iommufd.rst
> index 2deba93bf159..a8b7766c2849 100644
> --- a/Documentation/userspace-api/iommufd.rst
> +++ b/Documentation/userspace-api/iommufd.rst
> @@ -63,6 +63,37 @@ Following IOMMUFD objects are exposed to userspace:
>    space usually has mappings from guest-level I/O virtual addresses to g=
uest-
>    level physical addresses.
> =20
> +- IOMMUFD_OBJ_VIOMMU, representing a slice of the physical IOMMU instanc=
e,
> +  passed to or shared with a VM. It may be some HW-accelerated virtualiz=
ation
> +  features and some SW resources used by the VM. For examples:
> +  * Security namespace for guest owned ID, e.g. guest-controlled cache t=
ags
> +  * Non-device-affiliated event reporting, e.g. invalidation queue errors
> +  * Access to a sharable nesting parent pagetable across physical IOMMUs
> +  * Virtualization of various platforms IDs, e.g. RIDs and others
> +  * Delivery of paravirtualized invalidation
> +  * Direct assigned invalidation queues
> +  * Direct assigned interrupts

The bullet list above is outputted in htmldocs build as long-running paragr=
aph
instead.

> +  Such a vIOMMU object generally has the access to a nesting parent page=
table
> +  to support some HW-accelerated virtualization features. So, a vIOMMU o=
bject
> +  must be created given a nesting parent HWPT_PAGING object, and then it=
 would
> +  encapsulate that HWPT_PAGING object. Therefore, a vIOMMU object can be=
 used
> +  to allocate an HWPT_NESTED object in place of the encapsulated HWPT_PA=
GING.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--R8eh+sitfrxXSbCw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZywQOwAKCRD2uYlJVVFO
o7pRAQC/P/MtxGJEcuBrLt3vgwQrT0pU3bttl3Z7gq5Y4j09ngEA5fvElByqOXWd
ra3GriB9y/vGMX6/gPtQqt/qByO1IwE=
=OgKS
-----END PGP SIGNATURE-----

--R8eh+sitfrxXSbCw--
