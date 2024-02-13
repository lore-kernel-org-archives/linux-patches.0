Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9A25788C
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707843652; cv=none; b=sn0xJlvRMtWli0hEXuzVSBF42kcgPnvYGgIZXRKmHqVI8P+92k5qQzHFZAftYWjSi88QK+Kwk4syGnUVz8ums3AxOzXMAemDBpCcr7aOHtbde24gu/J9KOQ4e60NjZO2Jxi2Bua11gz0bU9PoDp34kqCti5XNSBkI+36xVNrQII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707843652; c=relaxed/simple;
	bh=exe8FC6k6donvhKbc3m8K6cLGboX46nkXKcr93qT6+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=reQjy3H1Jxe7GyqfosSoJ9YCPM/Sx39MSLiibz7osVpzygix9bGGycGqKRyIMqIIT2AFcAkbvTH076LqicDfa/nIKuI6owCp+OKoyoEITt0QfRnR8foeJ6xGoV1zQDyr34RftwaUjDYkSYvEEKc7tYWgxVZMms6tEEH5xZSmt7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HkjsQYjg; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HkjsQYjg"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-410cf70a057so66295e9.0
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 09:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707843649; x=1708448449; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5cWBvmXxi6UMr28DCjOQCiv1KG2CcDRbLU6dcLN76xU=;
        b=HkjsQYjgmmk5W+3X1V6G1Zn1cYlBMZbexLoEYK0CUGpR2t8g5duKC4X+9OY9mIDDAL
         Y/42XFIRKLHuNL5B2jpIHVJixQSQM5KU31mASOP2d7R1cFYUsUnUxlUNU/TzAY5xx4oz
         +k6SYbSKrax2On4DjYM83z6PBQ9Uv17Idd76Y6jCbVPXsOxWMOWIEjt8NpsWuh+XUVCu
         jiNg35wioQSeCQz1oSYAFNnF8t2KUJkTyZExIBFXtaZ4iEZvzoNdl7bU72z9LEYnZpbT
         bvwsrK9eVcbJTwRzWFtTiFU9Sx4AscVJqgEt84Q6wV2CzimkfRcYbo023ZccWtdyLmwo
         18Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707843649; x=1708448449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cWBvmXxi6UMr28DCjOQCiv1KG2CcDRbLU6dcLN76xU=;
        b=G/PkPRokvCrdje9rVZLrrt/NABLFwviyBt3IZa90LSEdO97+gTm2EPqhYwrI3hFWTr
         qBayyeQKjJ9C5Fv/rPT/srClwe7BXoFpPtr3hh0SJd3XuO++DEBMTlhj2JSWOdrwqCLg
         pfwZcos/c3T6vsEL7T9yy0EAvjutATg7odc6ghxKTCqS7eHokI9iqk8BA768Cp0L34Wh
         OywATCiaKE5sI0pwjEs7ll3bWnB+aHNZbkPOnSeV7j8cufWpbPznk8gJys7YHkGiALS3
         LwD+qFMoK/jYV20dJ4rTzkDbXKAnUr9AevHLPc9BJ+PowgJBL6xYrv/s2FIzWKb6cP6t
         tOjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYd/CCo6mmFk3MN9Qs8gzECbC5IFsJoFqMkgDoZCgpnsD+Fz/bCRN7004cWeVlqtK5NDr2GMnyC/c7vhrPLQPoyaSOkoS8pA==
X-Gm-Message-State: AOJu0YydinXeTB1wPt6HaVQYe99XxUHnZqzx1rPVpOXcfUjC7ms5eopW
	VoelkZSIk8YMKB5P6lvKkA04qtV/Ur1gES8tMHy8uz7N8ySCkLAf+T2KgyKWLQ==
X-Google-Smtp-Source: AGHT+IFsllimKT4Ae5wbJyvmEQy4xvKDG1jTB+aQNSR/IivggyXAlwFr7LJHQ/dE4OA58cgEGjlCng==
X-Received: by 2002:a05:600c:a008:b0:410:d18a:290b with SMTP id jg8-20020a05600ca00800b00410d18a290bmr18394wmb.7.1707843649317;
        Tue, 13 Feb 2024 09:00:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUm9zGe7yYjtudtYm2xecBgJCDyzWuo7aNldtekCrdZCF7haqHhbsTc43FrJDj0WVsuns4uctGcMcBrOLYwlIGD9L9p8arT0OtOzePAaFQeJkPdRyIAzR/xgKSGDBNpMMJhd/9LvkGaiB56GgKtAFOM9HZNPKArstCw1HOBGMW9ElSfjRJpYNvMlbj59vQ2cF46fBzz2HNaJ7xTUeeDqdnPEpCIoR3a8Nh8vGGYWK+nj0tRKGbagfXWcsE6J+RAik4aTeYGNeaiZ4QPdOZJRlAbroH36nuISSKvJeahoD4YwWd/tGwxZOx0oPLFS/EADd3QM/HmQ14owgpu5g6OrfyQTjyzkNrAAKN08ql5Ahx/TgRuhZYOPNfer/VYCugwylcMteT0tivNUcVhyAI8xST7DIFzKOOf+7GaRo73lBCfm/LUPUWb5vIf0C2UuiFuThrKZPpWufHVsfBPF8gDDjMhf2x+EIntz3whBMP0mOHPlFsrWvcSqw==
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id n16-20020a5d67d0000000b0033af26545c8sm9977041wrw.50.2024.02.13.09.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 09:00:48 -0800 (PST)
Date: Tue, 13 Feb 2024 17:00:44 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 11/17] iommu/arm-smmu-v3: Remove
 arm_smmu_master->domain
Message-ID: <ZcugPKDPlx6mOgfg@google.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <11-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZcuOnnrWN3ZxJY8x@google.com>
 <20240213163739.GE1088888@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213163739.GE1088888@nvidia.com>

On Tue, Feb 13, 2024 at 12:37:39PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 13, 2024 at 03:45:34PM +0000, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Tue, Feb 06, 2024 at 11:12:48AM -0400, Jason Gunthorpe wrote:
> > > Introducing global statics which are of type struct iommu_domain, not
> > > struct arm_smmu_domain makes it difficult to retain
> > > arm_smmu_master->domain, as it can no longer point to an IDENTITY or
> > > BLOCKED domain.
> > > 
> > > The only place that uses the value is arm_smmu_detach_dev(). Change things
> > > to work like other drivers and call iommu_get_domain_for_dev() to obtain
> > > the current domain.
> > > 
> > > The master->domain is subtly protecting the domain_head against being
> > > unused, change the domain_head to be INIT'd when the master is not
> > > attached to a domain instead of garbage/zero.
> > 
> > I don't this the problem here, neither the reason for initialising the
> > domain_head, can you please clarify the issue?
> 
> I didn't notice it either. Eric found it:
> 
> https://lore.kernel.org/linux-iommu/6fff20dd-46d5-4974-a4a5-fb4e7a59ce44@redhat.com/
> 
> > > @@ -2560,19 +2560,20 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
> > >  
> > >  static void arm_smmu_detach_dev(struct arm_smmu_master *master)
> > >  {
> > > +	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
> > > +	struct arm_smmu_domain *smmu_domain;
> > >  	unsigned long flags;
> > > -	struct arm_smmu_domain *smmu_domain = master->domain;
> 
> master->domain is NULL here which happens in cases where the current
> RID domain is not a PAGING domain.
> 
> > > -	if (!smmu_domain)
> > > +	if (!domain)
> > >  		return;
> 
> Which used to early exit
> 
> > >  
> > > +	smmu_domain = to_smmu_domain(domain);
> > >  	arm_smmu_disable_ats(master, smmu_domain);
> > >  
> > >  	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> > > -	list_del(&master->domain_head);
> > > +	list_del_init(&master->domain_head);
> > >  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> 
> But now would cause the list_del() to hit a non-inited list_head and
> explode.
> 
> Instead we keep the list head init'd and the list_del is a NOP.
> 
> Tricky right??
> 
> I changed the comment like this:
> 
> The master->domain is subtly protecting the master->domain_head against
> being unused as only PAGING domains will set master->domain and only
> paging domains use the master->domain_head. To make it simple keep the
> master->domain_head initialized so that the list_del() logic just does
> nothing for non-PAGING domains.
> 
> OK?

Ahh, I see, as iommu_get_domain_for_dev() now returns a valid domain.
Thanks for the explanation, that makes sense.

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa
