Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D17224B0E
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 11:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112691; cv=none; b=RhErlEMQGaYt/2a/gQTbyZDjfIAqbhedveYY5ivgmYPHJ7E/zvdIELNiwGHr9PgKuPnzGilRM+xapGWSx+P70iWfILKtvMz6OemqE5H5iDmTKRdmPpt3EuwXgnOP3e4w6+HpzkTdF7sAj5bWFuraHSL6XB6Y8Uu7PaKy31h3Zto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112691; c=relaxed/simple;
	bh=sVnWWYifDzNHWDD5ZdDHNMXXvkM1H7Mr10Ssgl0n+6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qDrg7bsh9EeDjKpg2qKBmjSK4IvR9yyOfovWPkDIl4KDpVe7GlU87Z7yr/T3Ll2xsZIbumsUrk+F4wBaGKZL5hAYQUn1BGBiPwCFKAO1Py/FviNxy0PuQdbv1RhklQLKfdAlsi0zCSi5OjhoCoMsM9zB8UwDJ0hsdkkRisDpD10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x2n+WHV6; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x2n+WHV6"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-30bfe0d2b6dso51952581fa.3
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 04:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744112687; x=1744717487; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JrYauhzusPrI0iXB3x51m5sg6uFNXWBUmKbASQyHV2k=;
        b=x2n+WHV6sp7POYuHbHG/Kozy87C0KwRJUwofHKuShbAzkExauBmK+MCJu9PYsEmlis
         TvdcDpWdSn1y2N8TzyNDAIlyEkbgAUPtGvLLixjgQX4hA7WFWfYk1cnqjZbuh6VTtq7T
         1llLHRJnay5a8Eii8F2zRvdoUg1Ci67qGA/B/a9MdoWukHNqlin2OJxI582lRUYYqTkG
         s3aCcSqrG5wMnErUj6e67yQmA6SZdjYS+pwJpwKlJj1MPVjAPD8RGvT67XmCVWNC5zMu
         JXVGX8eq+ltREcX8ozRFkc0U1x4ZMlzsFzngIIZn5Qw+o4l2tIk35Y99jQYf2ElMkK8W
         19Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744112687; x=1744717487;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JrYauhzusPrI0iXB3x51m5sg6uFNXWBUmKbASQyHV2k=;
        b=M19nQirmh3r9j6EGtx98/oSpWxh+EdbBu8LpoJSUbN1QRxYBXZN+8tAbKoGcQpFvkh
         QKuf9MVDByg4nW2hDr5RYrYQGO8NrcFDm3rJro9Nc0g5pP3oDARMQt6hQZPqmEUXY7aG
         A1SsfM5Rm8McyUqsGqiz05ONExzlKgdvJwwV3tePJvmsnqFydQpqp/+KYLL/yMa/Q5wG
         j0Od814M09zBsKNg+ScqTiOOUotYrYhgT1QUV7Dz/xGUWYxQ+/PkymALY3lGXDX7Lgx/
         lUR303fyb9fts64SE9J4n6VGqGBmKUjQMcG9kLKNz1NEOyQg4EVdM8mtfsEBWMdaDjQ9
         N3ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJkzYI29THkhnt+MCHapwq3+vBVrTJSMXm8O3gvtS3+xQi/BC3BvuTRL4Lpj5EXlQ+cHWaPgCY@lists.linux.dev
X-Gm-Message-State: AOJu0YxPY1YKfyUCG33YfcksRpFtrfukkBFtDsRl+9hu4WpTBvWnkoe1
	5w/EOMKHSFwpur4e33urGnCi3W5NbrZ+U8+t44S6fvv4tQjIlOY+hlP+8ZQ8pP/n2KMlZRHlgvo
	lTevIrAMybqNCrWCozZQYxds+qhvGg1MdapVigg==
X-Gm-Gg: ASbGncuyTAfuiDiGjwXTUBVpTF1mMA8gzTFqjPhhrqb2HASonFlI8sF2UPa39i1PY7T
	unf60PXo8amZYm1sCOLBTk4Ngsieg5lVFDXETPdMz/KYWW82lpsRn1fHMH5rH1BMfweBVhrscwK
	AOeoV0gasggvWhFHqrpmzTPsTx4MLbbCQ=
X-Google-Smtp-Source: AGHT+IHjL36c4DD0hqrS7NUmvzOjx/3kG/kPwxU+j7cHEhXKV/Zh3wqhtcKt/lEg9h3aP4E8pKAxMXueT2IArw3DOF0=
X-Received: by 2002:a05:651c:882:b0:307:9555:dc5e with SMTP id
 38308e7fff4ca-30f0be04016mr46411251fa.3.1744112686911; Tue, 08 Apr 2025
 04:44:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1740504232.git.nicolinc@nvidia.com> <f205a4e2f5971cd4b1033d7cac41683e10ebabfb.1740504232.git.nicolinc@nvidia.com>
 <CABQgh9Fuh2HdBH7pyAteawZBpa55ZzfR9dv2K4RF=Ps4yhREbw@mail.gmail.com> <Z/QSuMzJVGOcTx60@nvidia.com>
In-Reply-To: <Z/QSuMzJVGOcTx60@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Tue, 8 Apr 2025 19:44:34 +0800
X-Gm-Features: ATxdqUE5HzSx71KLyQAI3wDnKvY_BQRF_RJmPVNkaKt2N6Ua3aAx7RZCkWtktDg
Message-ID: <CABQgh9FObG8-Qsp-nqoTP-fC7VkPoi1ooHPQ1=s5uW_2BTL9vw@mail.gmail.com>
Subject: Re: [PATCH v8 12/14] iommu/arm-smmu-v3: Introduce struct arm_smmu_vmaster
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org, 
	joro@8bytes.org, suravee.suthikulpanit@amd.com, robin.murphy@arm.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org, 
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com, smostafa@google.com, 
	ddutile@redhat.com, yi.l.liu@intel.com, praan@google.com, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Apr 2025 at 02:00, Nicolin Chen <nicolinc@nvidia.com> wrote:
>
> On Mon, Apr 07, 2025 at 08:08:57PM +0800, Zhangfei Gao wrote:
> > Hi, Nico
> >
> > On Wed, 26 Feb 2025 at 01:35, Nicolin Chen <nicolinc@nvidia.com> wrote:
> > >
> > > Use it to store all vSMMU-related data. The vsid (Virtual Stream ID) will
> > > be the first use case. Since the vsid reader will be the eventq handler
> > > that already holds a streams_mutex, reuse that to fenche the vmaster too.
> > >
> > > Also add a pair of arm_smmu_attach_prepare/commit_vmaster helpers to set
> > > or unset the master->vmaster point. Put these helpers inside the existing
> > > arm_smmu_attach_prepare/commit().
> > >
> > > For identity/blocked ops that don't call arm_smmu_attach_prepare/commit(),
> > > add a simpler arm_smmu_master_clear_vmaster helper to unset the vmaster.
> > >
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Reviewed-by: Pranjal Shrivastavat <praan@google.com>
> > > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > > ---
> >
> > >
> > > +int arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state *state,
> > > +                                   struct arm_smmu_nested_domain *nested_domain)
> > > +{
> > > +       struct arm_smmu_vmaster *vmaster;
> > > +       unsigned long vsid;
> > > +       int ret;
> > > +
> > > +       iommu_group_mutex_assert(state->master->dev);
> > > +
> > > +       /* Skip invalid vSTE */
> > > +       if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V)))
> > > +               return 0;
> >
> > Why this is removed in v9 and 6.15-rc1?
> >
> > I tested 6.15-rc1 the qemu failed to boot with qemu branch:
> > for_iommufd_veventq-v8
> > "failed to attach the bypass pagetable"
>
> Here is the problem: v9 isn't compatible with v8 :)
>
> Would you please try for-v9 version?
> https://github.com/nicolinc/qemu/commits/wip/for_iommufd_veventq-v9

Thanks Nico

I tried this branch, it works with 6.15-rc1

Thanks
