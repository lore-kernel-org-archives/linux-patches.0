Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFAC192D86
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 16:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740501962; cv=none; b=G7FoxxghzQUFpXsGVQ9aBQq2PYny6Oe3bvKuOlvwWxfpfrrY5M6ak78/kJmT+akWlB08P2Gu03wYG+/viwGGZeRmIP+D9iZEMigecfzI8+fsR4nzGHGvDHcUQTQyrrJTrIFmSnf4jJkmtdsLjLuqOpXOF7sH9v0HDV9CwZYYgLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740501962; c=relaxed/simple;
	bh=3pkC9Zan/5soR9iiYT3dS1raXOelzZooR8jSMhW1DW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDj6pu7Wur09PT9B3V4b5Vuw4BIcgOzZmjYvXAS9M6B7uxlSwgB+4Nyz0uBTmqU+dvLszw0642jAcbVl39PJ0M3HLTakEMjhx6SFuTB4pds6DhSMH+4XLn5uz1uX5KQByRUkvkJneFr1CHoZG58Gai/7nEkxDmPHehn0gwVc1zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wSb0bCg1; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wSb0bCg1"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2212222d4cdso172615ad.0
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 08:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740501960; x=1741106760; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DvJy2eU2NKOX06+H5Vs2S45nqKcJ32b1n8dkLQorqiw=;
        b=wSb0bCg1e93HySdMHiwDl0dVSGfx5fSazmyQmNOELU03fGSoOaCUtb7nLg8VyB3wAh
         p/jI/WB3Eeo3YVNTfzrW3CVdEIjj/SMcWSXmWa7ykbHhYPcfMD6/E8dvJemJ5YMfiMI2
         +69taLUTQU0j/hvOPtuELSZJ1GXTnHkgVUN1GYtnSa66XLa1SIBSHX3jzTZ8POHRLkuJ
         n5bMTj4VHxfDSWUAkSJPi/pTJtE3F7s2emXY41V2yl6KiadSpuUdmKJ3umDyVWz8qqfb
         vZ8qV9fkw2Ic/1h1uJ4Wif4RCW4oCHeznlLyki9FeFxUDHQehaHi6lfLzmaC19sbfURE
         et5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740501960; x=1741106760;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvJy2eU2NKOX06+H5Vs2S45nqKcJ32b1n8dkLQorqiw=;
        b=n8JajOoRpoRG+FmjUG8UJe2mucPzdhvJCx40q+y1dEbHRassTQIsELkhscF8qct9q5
         o6pwIwKQLd2zjZ5XEcChPa71j0HDtAi0c+xsha9sQ5r5soFq6Yht0AJU4QuhlU9UjOmB
         ek4qIEEUtO37LFQb4a3Abo9qx57/cZ1ht/Y4BmgJrgSpGSfI3f6vpW7sBORH8IXkMdOf
         sNw4znfp4DJcsxMD3el07JjMmWKyYoS2fqP9Ktwwo0fjbd3uxNxcD5surOzHexBk0c2C
         UwFdiz8oTMsjksMa9cKGrcyaAFvax6KqYCc/93G6YyHjBED8RY7udWZCsWh+zGMg7M+J
         g3gA==
X-Forwarded-Encrypted: i=1; AJvYcCVzFL/+DKd5Ee6/cGnLoEYoiUCXkR6btEiJooLikzFd4kxKkK/6y6bP86+nfLWY5hqeV0o/11vE@lists.linux.dev
X-Gm-Message-State: AOJu0YxttcR4TsBY1ypoD2BoAmhpUcVyB4OZ4Egjm3/h/6bwtpiDuj31
	TdN1B3BaEwsK0PmkIOmZ/oR8DT3CITtRSqDeuvVXbLsfZaXJ+EZD33iULRLNCQ==
X-Gm-Gg: ASbGncswXcZZU1LR4dKscB7FqTEFwAXvB0HK+kjP1NHv4C8W0WIXKkfRBEMvdv6X5/E
	Qth7PpuJ1vcTIglMHoOMDErzAbycn1VnMAmr/QNYbIJv/nE/zx0KXQlZG1uuUW09J6ONAytO7GS
	09sInT2rDOFudyXSPQ+kKa1SqESqXOZTVyCut/LYmuZQ8qUPoVXwqLuha5CvXVMYCPhh2hYN+Ao
	imggvsWwDgra11DIr81G9cLeRfzMsrYZJlEyj+zzEFYPPj8iL8LyDdlhskp+G0RULtBmqgN3bfh
	k+Gssd6rW3kdCkbms3qUDrlmfyK7XDV89mRMJlz5vI9i/GiDD2bxfGnMg3FHrqw=
X-Google-Smtp-Source: AGHT+IEN5DYqq3Kc3cWdCDht37pR+ox7Pyn1fNUO9eOSCsjsyhHHqegeAVtSYgiTkCHpwG2cFWbA4w==
X-Received: by 2002:a17:903:2445:b0:215:9ab0:402 with SMTP id d9443c01a7336-22307a98a03mr3458305ad.18.1740501959581;
        Tue, 25 Feb 2025 08:45:59 -0800 (PST)
Received: from google.com (169.224.198.35.bc.googleusercontent.com. [35.198.224.169])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a6fa230sm1709220b3a.70.2025.02.25.08.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 08:45:58 -0800 (PST)
Date: Tue, 25 Feb 2025 16:45:48 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, kevin.tian@intel.com,
	corbet@lwn.net, will@kernel.org, joro@8bytes.org,
	suravee.suthikulpanit@amd.com, robin.murphy@arm.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com, shuah@kernel.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
	smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 12/14] iommu/arm-smmu-v3: Introduce struct
 arm_smmu_vmaster
Message-ID: <Z73zvIbsXzJMCaNt@google.com>
References: <cover.1740238876.git.nicolinc@nvidia.com>
 <be799951a817557ac093ac3e18d02a631306aa35.1740238876.git.nicolinc@nvidia.com>
 <Z7zYLBLZGKim-5UL@google.com>
 <Z7zlH74/orq9HF7Q@Asurada-Nvidia>
 <Z7zqdrQn7Q8yXfcn@google.com>
 <Z7zxsbJsOFp41Dzd@Asurada-Nvidia>
 <Z70EnQ5CXacc4ysT@Asurada-Nvidia>
 <20250225160225.GA593877@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225160225.GA593877@nvidia.com>

On Tue, Feb 25, 2025 at 12:02:25PM -0400, Jason Gunthorpe wrote:
> On Mon, Feb 24, 2025 at 03:45:33PM -0800, Nicolin Chen wrote:
> 
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> > @@ -95,8 +95,6 @@ int arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state *state,
> >  
> >  	iommu_group_mutex_assert(state->master->dev);
> >  
> > -	if (domain->type != IOMMU_DOMAIN_NESTED)
> > -		return 0;
> >  	nested_domain = to_smmu_nested_domain(domain);
> >  
> >  	/* Skip invalid vSTE */
> > @@ -122,19 +120,9 @@ void arm_smmu_attach_commit_vmaster(struct arm_smmu_attach_state *state)
> >  {
> >  	struct arm_smmu_master *master = state->master;
> >  
> > -	mutex_lock(&master->smmu->streams_mutex);
> > -	if (state->vmaster != master->vmaster) {
> > -		kfree(master->vmaster);
> > -		master->vmaster = state->vmaster;
> > -	}
> > -	mutex_unlock(&master->smmu->streams_mutex);
> > -}
> > -
> > -void arm_smmu_master_clear_vmaster(struct arm_smmu_master *master)
> > -{
> >  	mutex_lock(&master->smmu->streams_mutex);
> >  	kfree(master->vmaster);
> > -	master->vmaster = NULL;
> > +	master->vmaster = state->vmaster;
> >  	mutex_unlock(&master->smmu->streams_mutex);
> >  }
> 
> I'd leave the clear_vmaster just for clarity. Commit should not be
> unpaired with prepare in the other functions.
> 

Ack. I'd like to pair prepare and commit as well. I'm just confused
about the check if (state->vmaster != master->vmaster). Maybe a helpful
comment about what are we checking for would make things cleaner.

With this nit:

Reviewed-by: Pranjal Shrivastavat <praan@google.com>

Thanks,
Praan

