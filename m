Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4634276026
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 08:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745915295; cv=none; b=Zq14HBM6MM9+D2fI7lOHXB1qoUDgQ4vX/NewV7NqVtQHX3qGc3OVqdUGUVNhACS96hKQT6jVkWqsGzMXa000KmyLUkH9cSe7JevSywro3Zwpm1zGQRgdKUgnqgkThrTe/B9tRBmyQt5aawe31QLnYgYDIl5MHE7F8B1OzYUw7AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745915295; c=relaxed/simple;
	bh=1FsywMQHT6aCTH/4QijjV+e4uu/3MJPm0YGRHU38ci8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0GrN0abyCfKL1krBJBMK1L+AeCfNNAN1fuCeEw4F8Lwe3jZFugj7BqOeg7W7uFC17SeqbiEwHeou13mYH0Pe8e+nZ4lOT9JedR3waYa6uod7G2jKSJypcRkFOHAPxEXeg7iie9zZCN6YsiTetLoHhU1u5rlvkzjZ+1gGjJFvQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HBzsWTSp; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HBzsWTSp"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2240aad70f2so89135ad.0
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 01:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745915293; x=1746520093; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D5QKxnLZKN15CjETYE0cz5F8y62z+3Lyd2c2OfhrGOQ=;
        b=HBzsWTSp5L0i6yuCZa7+pDiXIRMkNwXaOlAT7Aipa7rWlcuyBDbyAf04EitHZo+TCb
         zeTeFp06mS5BxgquYYeOa2faDYtOU4On5dOMG4G0aM09wrb+5la/bdqTJ7Wiej14h9qI
         b4ZY2R6Ec02RIgi6aS4mpXO39lTguppjzcGBAAFXf+o1MwIDNrU9PzMe8/m1CQ+FR9bm
         +xhMIrB3GCP9Mu4muf9rK46TfDiGrk36l8IL3p1jvOs5XeeU7OjmCk75Y3weh91uAy7x
         U8Mf3tSIxBCBqLXK8lth/smSRxJIOm1ruO6Se9S0VabJczX3Anjohmfuyguh1jzh2jnU
         0coA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745915293; x=1746520093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5QKxnLZKN15CjETYE0cz5F8y62z+3Lyd2c2OfhrGOQ=;
        b=cynBnsLLw+9TLy0u0/FF2i3BIYjZfggSZ6XTt5fX8/nqhm/RF7lPR1h9PqHNaUH9Vj
         JoXbyeDBK3Dufhhry+S/Ex7dM12CkPAjjJjDDWA6qPeWuQGtKIJntsYX3RpZRZ7ziUYd
         UfaGddaBP+aUw52EfaRQ67oGsEiaDuHGpkssWlJud6Bn97fvvE+g1ox9R2KDyzB2kGRB
         P4cwhQV+NAADJc7LXcB2ip3GgAjmu1agkGeaRFJKWU+ep9usriQUX9HpraQQOHONIK/V
         JCCe868W0spyfUP74/XRFIquFa+zx9KAP9pQNM7zKJpFtd6oAR6ClR1LJwNNdEYsGDRI
         3jdw==
X-Forwarded-Encrypted: i=1; AJvYcCXT3wxco99VKBWc/wagVG0AgtCCbzriKutsZBV/hbuUfvHjPqtQGkxfIdRS8lc6HzAbd4EGBMQX@lists.linux.dev
X-Gm-Message-State: AOJu0YwAKcWCg+t6DCahdx/BxjbGv+iuqsUBakr90ocYzfamaD7h8RIU
	fqzcB75VI9mh6+Ml/brQj1uS/k/Ef1ioIFU0xptfrbayvPzIaSUH9TqMWCBOYA==
X-Gm-Gg: ASbGncsa0kycwQiuB3PImcel2+74bHZGlM+LYlMmRMtf0wn5m0ebWofFbxWI0GprKnc
	7yctW6zSDIfKXTHfpMiDDMfyr8jVCReVSbSnbwcw0LiuePdgCgargIN1GBudR3a4gQTzXzJhtDh
	Z6xr0OhzpEmb9Cdr8vVXIYiwg79iCgkS8TrfHGKTlOXtl6eFH5lpyCkUIh0ZEE1fF0UvD6BQN08
	Kk9cpfTZ/FfQmXuBUh2LdKHrPlwGphSaur66Sog6is6Qk+yfduC9EUPyKLFXCb05EEV+PuyMoHI
	2sM9uyqmFKF3CNNeG0T6vI7P7qcG7O0rg+U3YwkFoQcMwcsPIN3mpS/GYv6Co0YraxSQByz7
X-Google-Smtp-Source: AGHT+IEBLTjQEPi6T2MilTT/Y6yv+CY2P+m49PsmJxyrcH4D1FATZ6uG7LkMVqt9dbTXi33w3gHvEg==
X-Received: by 2002:a17:902:f643:b0:223:f479:3860 with SMTP id d9443c01a7336-22de6de05c5mr2640355ad.18.1745915292715;
        Tue, 29 Apr 2025 01:28:12 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a995edsm9628409b3a.130.2025.04.29.01.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 01:28:12 -0700 (PDT)
Date: Tue, 29 Apr 2025 08:28:01 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 10/22] iommufd/viommmu: Add IOMMUFD_CMD_VCMDQ_ALLOC
 ioctl
Message-ID: <aBCNkcLp6XZpjYYT@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <094992b874190ffdcf6012104b419c8649b5e4b4.1745646960.git.nicolinc@nvidia.com>
 <aA_0TV0RkVOHk7Qj@google.com>
 <aBAEuP9962XweHPc@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBAEuP9962XweHPc@Asurada-Nvidia>

On Mon, Apr 28, 2025 at 03:44:08PM -0700, Nicolin Chen wrote:
> On Mon, Apr 28, 2025 at 09:34:05PM +0000, Pranjal Shrivastava wrote:
> > On Fri, Apr 25, 2025 at 10:58:05PM -0700, Nicolin Chen wrote:
> > > @@ -501,6 +504,9 @@ static const struct iommufd_object_ops iommufd_object_ops[] = {
> > >  	[IOMMUFD_OBJ_IOAS] = {
> > >  		.destroy = iommufd_ioas_destroy,
> > >  	},
> > > +	[IOMMUFD_OBJ_VCMDQ] = {
> > > +		.destroy = iommufd_vcmdq_destroy,
> > > +	},
> > >  	[IOMMUFD_OBJ_VDEVICE] = {
> > >  		.destroy = iommufd_vdevice_destroy,
> > >  	},
> > 
> > When do we expect the VMM to use this ioctl? While it's spawning a new
> > VM?
> 
> When guest OS clears the VCMDQ's base address register, or when
> guest OS reboots or shuts down.
> 

Ack. So, basically any write to VCMDQ_BASE is trapped?

> > IIUC, one vintf can have multiple lvcmdqs and looking at the series
> > it looks like the vcmdq_alloc allocates a single lvcmdq. Is the plan to
> > dedicate one lvcmdq to per VM? Which means VMs can share a vintf?
> 
> VINTF is a vSMMU instance per SMMU. Each VINTF can have multiple
> LVCMDQs. Each vCMDQ is allocated per IOMMUFD_CMD_VCMDQ_ALLOC. In
> other word, VM can issue multiple IOMMUFD_CMD_VCMDQ_ALLOC calls
> for each VTINF/vSMMU.
> 

Ack. I'm just wondering why would a single VM want more than one vCMDQ
per vSMMU?

> > Or do we plan to trap access to trap the access everytime the VM
> > accesses an lvcmdq base register?
> 
> Yes. That's the only place the VMM can trap. All other register
> accesses are going to the HW directly without trappings.
> 

Got it.

> > > diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
> > > index a65153458a26..02a111710ffe 100644
> > > --- a/drivers/iommu/iommufd/viommu.c
> > > +++ b/drivers/iommu/iommufd/viommu.c
> > > @@ -170,3 +170,97 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
> > >  	iommufd_put_object(ucmd->ictx, &viommu->obj);
> > >  	return rc;
> > >  }
> > > +
> > > +void iommufd_vcmdq_destroy(struct iommufd_object *obj)
> > > +{
> > > +	struct iommufd_vcmdq *vcmdq =
> > > +		container_of(obj, struct iommufd_vcmdq, obj);
> > > +	struct iommufd_viommu *viommu = vcmdq->viommu;
> > > +
> > > +	if (viommu->ops->vcmdq_destroy)
> > > +		viommu->ops->vcmdq_destroy(vcmdq);
> > > +	iopt_unpin_pages(&viommu->hwpt->ioas->iopt, vcmdq->addr, vcmdq->length);
> > > +	refcount_dec(&viommu->obj.users);
> > > +}
> > > +
> > > +int iommufd_vcmdq_alloc_ioctl(struct iommufd_ucmd *ucmd)
> > > +{
> > > +	struct iommu_vcmdq_alloc *cmd = ucmd->cmd;
> > > +	struct iommufd_viommu *viommu;
> > > +	struct iommufd_vcmdq *vcmdq;
> > > +	struct page **pages;
> > > +	int max_npages, i;
> > > +	dma_addr_t end;
> > > +	int rc;
> > > +
> > > +	if (cmd->flags || cmd->type == IOMMU_VCMDQ_TYPE_DEFAULT)
> > > +		return -EOPNOTSUPP;
> > 
> > The cmd->type check is a little confusing here, I think we could
> > re-order the series and add this check when we have the CMDQV type.
> 
> This is the patch that introduces the IOMMU_VCMDQ_TYPE_DEFAULT.
> So, it's natural we check it here. The thing is that we have to
> introduce something to fill the enum iommu_vcmdq_type, so that
> it wouldn't be empty.
> 
> An unsupported DEFAULT type is what we have for vIOMMU/vEVENTQ
> also.
> 
> A driver patch should define its own type along with the driver
> patch. And it's what this series does. I think it's pretty clear?
> 

Alright. Agreed.

> > Alternatively, we could keep this in place and
> [..]
> > add the driver-specific
> > vcmdq_alloc op calls when it's added/available for Tegra CMDQV while
> > stubbing out the rest of this function accordingly.
> 
> Why?
> 
> The vcmdq_alloc op is already introduced in the prior patch. It
> is cleaner to keep all core code in one patch. And then another
> tegra patch to add driver type and its support.
> 

Alright.

> Thanks
> Nicolin

Thanks,
Praan
