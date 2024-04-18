Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A3B41A88
	for <patches@lists.linux.dev>; Thu, 18 Apr 2024 04:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713415208; cv=none; b=CsQHkFOhAY4snDBdopp14euppeCbYIIRxvlXo46BLYrEXkF8CdsazxXWxwXJFqe/AcpPWqKF9hOiALYHHHjgC0rxsmrRNWCqqic9w8kotGOET6t3EEqF572QcvALOQJL3uYMbg1rM7dxO7TEoJRA/eDcq6uj1A57vnNaa/j/HXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713415208; c=relaxed/simple;
	bh=9YLVmgL1ee5/qBRrrq6lDsfxNB4mZEciq4da4R1yCr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fwPe0mexCysvFWOzCpbVx8mO9vA5xFskaOtaskln5C3Bafl411fs3d3J2VAnUiHMmXK0bYbTR7dB20sj3Fm4iavJARn2LWs94DQSMOPn1AEqg/jUPQlcwGxNVIQSiULE+uYcvX9lCOsnVQMmd2/kkJpGZwaUMQTglOmZ22vF8pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o/1pdmnm; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o/1pdmnm"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-434b5abbb0dso125591cf.0
        for <patches@lists.linux.dev>; Wed, 17 Apr 2024 21:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713415206; x=1714020006; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I1MGUXZc8qsVC89T1xrGa2o44KZPsND9LVmo2D3INQQ=;
        b=o/1pdmnmPbjKEU4tHhkAB+L4dE+V6Xupwx1/hpkga0Bk40myuGzHe2BMF4HgCRebUI
         7QcVpX/licBS5COiAzHQW2RqYXsufQEkm6Rr2RQiCtByBLg09OBND+oJxNGE9i2I5tYU
         F88mZCyPQ6nAgfbpqds5Dfm9a2v9dXtmOb9ABU7feOOqoS8rFMlEwImb5w3PfFSmwmqX
         +dTYPgv2klUPghEikBU1dlk71PlCOH4vavsY/Ti+78g3In+qrwkjSJ9ibwJ7FdtS/8/x
         4Zj3F3NC90C1kGdevExjupuqyHwUssVVQg97SKqfZTvd7mQ37LLNZwTkwJgfTmHfbzaa
         PODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713415206; x=1714020006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I1MGUXZc8qsVC89T1xrGa2o44KZPsND9LVmo2D3INQQ=;
        b=byWPQdQI5vNMPINc+9zyRxYAniZYVI0m0hi/ccPJdjB9EdKImGkrKppqUENThWzVho
         XuHVYbIO6HOQnG3+qW6qU5sWSng7fr3+jlO6ASbIL0dxFkjpsxoloBGvHgcWVqIPkzx2
         GcivoY2loH6Mf1cSPOv61Nbv1PQFrVYnvWnP9k5dcAK1cOtwrsvQbknvc4bwunR70eBo
         kJReBtcCKsGx8QSBhXSRx7LSXyl63kU+mMjegQ9vj5FdtYFtrC1h5O9CRF0nomjHyDxb
         WR2Ft2M1IEQHoS3vhd1y0DwPNzgPytPVoBKaQIWsDzz4p/pn1fs3Shr/AkCWkMG2Lgl5
         RhgQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/WwLYipbeeP9hXJROVEIJlK/BExJ3aUNYxehA3x8M48aBZZG6SW94B8V/bhjCYhSxc5uV1mvMNZQYtA13v2b8YwjagOOlLA==
X-Gm-Message-State: AOJu0YyDunhV6APkn0j+8PEruNKdF1Wdf4b5VVjkAvMeqAlD02dH/QiQ
	xeFA+/4uK1qpTLX1ypKsOtinXlNsIn7W5MaoPf86pmk+N7KUTbuswqE5/b91/aNN/Hb4F+TTUXy
	3GPMan1Sfdw/JJ6GR3BmJqD/shnUp/5ORDFAw
X-Google-Smtp-Source: AGHT+IHlfH0vRKLLljgotnYCr6Naa/JudsnTZBi38Jy9eeNxAy6+qgRC0X2XOhuGjXFswwwmvNoVvk1OS5/ktx81X9A=
X-Received: by 2002:a05:622a:199b:b0:434:7926:b8fc with SMTP id
 u27-20020a05622a199b00b004347926b8fcmr137254qtc.5.1713415205971; Wed, 17 Apr
 2024 21:40:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com> <Zh+DxJoAMIXy9O/R@Asurada-Nvidia>
 <20240417141618.GS3637727@nvidia.com>
In-Reply-To: <20240417141618.GS3637727@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Thu, 18 Apr 2024 12:39:29 +0800
Message-ID: <CAKHBV275bzhRK6oSvDrH7h780qde53z_x8TLVtV3sHACL3gMHA@mail.gmail.com>
Subject: Re: [PATCH v7 9/9] iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, linux-arm-kernel@lists.infradead.org, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>, 
	Moritz Fischer <moritzf@google.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 10:16=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Wed, Apr 17, 2024 at 01:09:40AM -0700, Nicolin Chen wrote:
> > On Tue, Apr 16, 2024 at 04:28:20PM -0300, Jason Gunthorpe wrote:
> > > Add tests for some of the more common STE update operations that we e=
xpect
> > > to see, as well as some artificial STE updates to test the edges of
> > > arm_smmu_write_entry. These also serve as a record of which common
> > > operation is expected to be hitless, and how many syncs they require.
> > >
> > > arm_smmu_write_entry implements a generic algorithm that updates an S=
TE/CD
> > > to any other abritrary STE/CD configuration. The update requires a
> > > sequence of write+sync operations with some invariants that must be h=
eld
> > > true after each sync. arm_smmu_write_entry lends itself well to
> > > unit-testing since the function's interaction with the STE/CD is alre=
ady
> > > abstracted by input callbacks that we can hook to introspect into the
> > > sequence of operations. We can use these hooks to guarantee that
> > > invariants are held throughout the entire update operation.
> > >
> > > Link: https://lore.kernel.org/r/20240106083617.1173871-3-mshavit@goog=
le.com
> > > Signed-off-by: Michael Shavit <mshavit@google.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/iommu/Kconfig                         |  12 +-
> > >  drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +
> > >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   6 +-
> > >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 467 ++++++++++++++++=
++
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  36 +-
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  30 ++
> >
> > > +config ARM_SMMU_V3_KUNIT_TEST
> > > +   tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TEST=
S
> > > +   depends on KUNIT
> > > +   default KUNIT_ALL_TESTS
> > > +   help
> > > +     Enable this option to unit-test arm-smmu-v3 driver functions.
> > > +
> > > +     If unsure, say N.
> >
> > Forgot that my SVA sanity doesn't cover this patch. And it looks
> > like some problems here when building it with "=3Dm":
> >
> > ERROR: modpost: missing MODULE_LICENSE() in drivers/iommu/arm/arm-smmu-=
v3/arm-smmu-v3-test.o
> > ERROR: modpost: "arm_smmu_make_cdtable_ste" [drivers/iommu/arm/arm-smmu=
-v3/arm-smmu-v3-test.ko] undefined!
> > ERROR: modpost: "arm_smmu_make_bypass_ste" [drivers/iommu/arm/arm-smmu-=
v3/arm-smmu-v3-test.ko] undefined!
> > ERROR: modpost: "arm_smmu_make_abort_ste" [drivers/iommu/arm/arm-smmu-v=
3/arm-smmu-v3-test.ko] undefined!
> > ERROR: modpost: "arm_smmu_make_s2_domain_ste" [drivers/iommu/arm/arm-sm=
mu-v3/arm-smmu-v3-test.ko] undefined!
> > ERROR: modpost: "arm_smmu_get_ste_used" [drivers/iommu/arm/arm-smmu-v3/=
arm-smmu-v3-test.ko] undefined!
> > ERROR: modpost: "arm_smmu_write_entry" [drivers/iommu/arm/arm-smmu-v3/a=
rm-smmu-v3-test.ko] undefined!
> >
> > Likely needs MODULE_LICENSE and some EXPORT_SYMBOLs.
>
> Oh! The kbuild never tested this kconfig combination...
>
> I think just this? Michael?

Urhh I'm not sure... Should this also depend on ARM_SMMU_V3? Also what
happens if ARM_SMMU_V3=3Dm and ARM_SMMU_V3_KUNIT_TEST=3Dy ?

>
>
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index d03c729c4142dc..7b6a4e244e99cf 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -411,7 +411,7 @@ config ARM_SMMU_V3_SVA
>           and PRI.
>
>  config ARM_SMMU_V3_KUNIT_TEST
> -       tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TEST=
S
> +       bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
>         depends on KUNIT
>         default KUNIT_ALL_TESTS
>         help
> diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/a=
rm-smmu-v3/Makefile
> index 014a997753a8a2..0b97054b3929b7 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/Makefile
> +++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
> @@ -2,6 +2,5 @@
>  obj-$(CONFIG_ARM_SMMU_V3) +=3D arm_smmu_v3.o
>  arm_smmu_v3-objs-y +=3D arm-smmu-v3.o
>  arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) +=3D arm-smmu-v3-sva.o
> +arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) +=3D arm-smmu-v3-test.=
o
>  arm_smmu_v3-objs :=3D $(arm_smmu_v3-objs-y)
> -
> -obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) +=3D arm-smmu-v3-test.o
>
>
> Jason
