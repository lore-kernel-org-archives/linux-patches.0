Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065521DED59;
	Tue, 28 Jan 2025 08:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738052496; cv=none; b=ocOg8Lfj/nQnhg+pJDSpClQGj+I/lcW36lVtFQqIhdpU0RQTmZoBtCQ7gFQQTFfMp5rc4CuJarmyb+lY3Ceu+F7TkDzOgJp1JpAqhPHcPr+XBou6Q+4DKmNOyzF35z2st7YjDwhXLeGpyuXcrf7GelOhfziuv3CT/R590idjbgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738052496; c=relaxed/simple;
	bh=RSQ/gaKSYUHj2DbU1SSchGtbIQBxw/a/cur2nGw8Xnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KN6HiBUGDLZCaGpw+lk7RQfOkiRq3/DZib2Cn0k7mbSP6ye1XpOPFpUF6i4NeGobI+JV599L1bab2cp3kE64FYQnRYfiOCOjs3Sdx87PTV7r2euHiTx1fXnvm9pBY9y68zmyLk1ojN+FRHSqusy6OoXwJKxUT+sonwXRTpi/KxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKJZdeiM; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKJZdeiM"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2165cb60719so93976735ad.0;
        Tue, 28 Jan 2025 00:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738052494; x=1738657294; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3fMuy/pYgza/riIVTVPhUzUfkiZ2bVUecFPV047zGXs=;
        b=KKJZdeiMLfqTheXuuQ7GbFN+6RlrjIddX60oqgx6TYJoQ/2Ra3WxV+M5unEE3YoZf+
         RGoTEBU4V01qBQP/fmwbvnVqVJARTtvWn7eG3QB2KiozSXryaR7Kb7DCoUbpXx3rRxAU
         AcE2IIfDekUCMX5LCdCCwqEiEelxBL6XU3GITguino4+eSzkBp0GwnCeBpkLor2nC9f/
         UVBtMLhjs6xzpHN8ywiw/wDELL3yQE8LttnKFMLKgbt3XM/dLkPEu/WhMjGoFc6uDobY
         9abMGMFuUaSfUPDcFnWi2/eFDgyJAUkoJXC7PrubNgk5OdWAqJLTv1S7mkBNotwQe9yx
         1Zuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738052494; x=1738657294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3fMuy/pYgza/riIVTVPhUzUfkiZ2bVUecFPV047zGXs=;
        b=AGzbVlkhcLSh8FSZw5Kp5AlkhuRnZgBZ3Q+oE7U8e2KgBzUPiIXP8K/XWTDzGA365D
         JBEoyY2NNeFPz01CSo+AHBysQcNQyRYKHAAKcmnOkK/YIbQgSBwbRAgiRo+dLBBB2Qc7
         D6Gu4kynI4kHnWADvl/LnT/4XipSZMnqO6TFnE+vKHntYslghgHo00f5xjDYKgKk77XW
         eQ6SkOMKmqwLXymHKbXb+1jDEJgVAlmg+b7MmRf2Ny9js/SF+DM0qQkMMeMlWMy0Lk9R
         E2XdzhrbypzS57U8pu9f6AIJdzh/ynXTw0sYwonNnrrl5RiHXv/c8rR0YbZJ7p7rv6S+
         ccCg==
X-Forwarded-Encrypted: i=1; AJvYcCVM/iRBz1aXOxonVDFEJLMyQFiLVNkB7ebRaADpgAsvId9hD6C4CtRwUYhNrTtyoquEit0nvQ==@lists.linux.dev, AJvYcCXKH40rUTfF+1SvVounHV2HdWEWmphBmtPxcyIOYnNC3+JBEMOSqPDWMq+Z+ZTd+nIkQztQkjSlug==@lists.linux.dev
X-Gm-Message-State: AOJu0YxpfqfLLpZ6BCCJ9RwTkmxQHGI1W73za275UzinC/on5HMpxAaF
	/3MougpQB1ZRwUZCecQ4jOX82pqA3SG9FckQ9ViKx1G2dZ4heYs3
X-Gm-Gg: ASbGncsBfJ3dCr6uvsZvpcQatstyd3f7Vf30aKnBExI5BviSfbmrYNGiFmJF0xGT42j
	Gt17aq0QeRgUHmAfNEKwzvYGjp+8+SqD44SNx2i8xWh0DBAQWAhqws/dPpcmNREYKYYBgv/eGt+
	qOy5r+mIuNNz0EyW+TUyOALPy06WBzL59OBWlCkEoDwqNWGmBgo4fmx+OdAMJOCGlunVCmjZgsz
	4TMzhXv2ryD05KYKO33JZFYZeJO0/Xn385PoPxD7pGzgFrDUL/ZebtPmUj21KzbCt00SZqGENib
	QfDTiFIUaOFDPbA=
X-Google-Smtp-Source: AGHT+IGA23Ky/6K1hLSlTaGOzyYMHc1wGHqIfEJ8xAUCi8at04bQFz8GD3I/8Kj7sYnVrWvjXsXjWg==
X-Received: by 2002:a17:902:e80a:b0:216:6769:9ed7 with SMTP id d9443c01a7336-21c355c7dc2mr753720045ad.40.1738052494133;
        Tue, 28 Jan 2025 00:21:34 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3d9e173sm76602675ad.32.2025.01.28.00.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 00:21:33 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 88B8C420A74B; Tue, 28 Jan 2025 15:21:25 +0700 (WIB)
Date: Tue, 28 Jan 2025 15:21:25 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com,
	kevin.tian@intel.com, corbet@lwn.net, will@kernel.org
Cc: joro@8bytes.org, suravee.suthikulpanit@amd.com, robin.murphy@arm.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com, shuah@kernel.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
	smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
	patches@lists.linux.dev
Subject: Re: [PATCH v6 11/14] Documentation: userspace-api: iommufd: Update
 FAULT and VEVENTQ
Message-ID: <Z5iThcDwBmBHZBJd@archie.me>
References: <cover.1737754129.git.nicolinc@nvidia.com>
 <300d03449b9420d756c1589e1c24bb8b4d508293.1737754129.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="m1sZIbxqV2u1bbA+"
Content-Disposition: inline
In-Reply-To: <300d03449b9420d756c1589e1c24bb8b4d508293.1737754129.git.nicolinc@nvidia.com>


--m1sZIbxqV2u1bbA+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2025 at 04:30:40PM -0800, Nicolin Chen wrote:
> diff --git a/Documentation/userspace-api/iommufd.rst b/Documentation/user=
space-api/iommufd.rst
> index 70289d6815d2..b0df15865dec 100644
> --- a/Documentation/userspace-api/iommufd.rst
> +++ b/Documentation/userspace-api/iommufd.rst
> @@ -63,6 +63,13 @@ Following IOMMUFD objects are exposed to userspace:
>    space usually has mappings from guest-level I/O virtual addresses to g=
uest-
>    level physical addresses.
> =20
> +- IOMMUFD_FAULT, representing a software queue for an HWPT reporting IO =
page
> +  faults using the IOMMU HW's PRI (Page Request Interface). This queue o=
bject
> +  provides user space an FD to poll the page fault events and also to re=
spond
> +  to those events. A FAULT object must be created first to get a fault_i=
d that
> +  could be then used to allocate a fault-enabled HWPT via the IOMMU_HWPT=
_ALLOC
> +  command by setting the IOMMU_HWPT_FAULT_ID_VALID bit in its flags fiel=
d.
> +
>  - IOMMUFD_OBJ_VIOMMU, representing a slice of the physical IOMMU instanc=
e,
>    passed to or shared with a VM. It may be some HW-accelerated virtualiz=
ation
>    features and some SW resources used by the VM. For examples:
> @@ -109,6 +116,14 @@ Following IOMMUFD objects are exposed to userspace:
>    vIOMMU, which is a separate ioctl call from attaching the same device =
to an
>    HWPT_PAGING that the vIOMMU holds.
> =20
> +- IOMMUFD_OBJ_VEVENTQ, representing a software queue for a vIOMMU to rep=
ort its
> +  events such as translation faults occurred to a nested stage-1 (exclud=
ing I/O
> +  page faults that should go through IOMMUFD_OBJ_FAULT) and HW-specific =
events.
> +  This queue object provides user space an FD to poll/read the vIOMMU ev=
ents. A
> +  vIOMMU object must be created first to get its viommu_id, which could =
be then
> +  used to allocate a vEVENTQ. Each vIOMMU can support multiple types of =
vEVENTS,
> +  but is confined to one vEVENTQ per vEVENTQ type.
> +
>  All user-visible objects are destroyed via the IOMMU_DESTROY uAPI.
> =20
>  The diagrams below show relationships between user-visible objects and k=
ernel
> @@ -251,8 +266,10 @@ User visible objects are backed by following datastr=
uctures:
>  - iommufd_device for IOMMUFD_OBJ_DEVICE.
>  - iommufd_hwpt_paging for IOMMUFD_OBJ_HWPT_PAGING.
>  - iommufd_hwpt_nested for IOMMUFD_OBJ_HWPT_NESTED.
> +- iommufd_fault for IOMMUFD_OBJ_FAULT.
>  - iommufd_viommu for IOMMUFD_OBJ_VIOMMU.
>  - iommufd_vdevice for IOMMUFD_OBJ_VDEVICE.
> +- iommufd_veventq for IOMMUFD_OBJ_VEVENTQ.
> =20
>  Several terminologies when looking at these datastructures:
> =20

Looks good, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--m1sZIbxqV2u1bbA+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZ5iTgAAKCRD2uYlJVVFO
ozC2AQDPP1Rr/NEdpC96sqjf+s6u1DgXFgQ1dghVRl94136J4AD/UQWE5HkY2pgd
+/5yHWzPSekTkat+mn1D4NZcmc/8IQI=
=M8Cm
-----END PGP SIGNATURE-----

--m1sZIbxqV2u1bbA+--
