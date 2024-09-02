Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32401D3196
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 09:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271073; cv=none; b=JBDTo53Msu4jZCXiTdKfLoMjwEIiapo9irsE7b/QEfKxNZtgg2YShUPzdoE1jLVda7uS9kx/4o1I0T74yYMTrk1JBmaL6uB7LVt9pkedLw3EpyIksMmhlhNKamlu7jq6zXjb56br6okE9BApmHB4nxybqZhstlO4GWhxjYmrEOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271073; c=relaxed/simple;
	bh=AebbeBylEZc6YvUUKEOp3IYHZ5WtMcK0qrIBOuhdE/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rEXNKIyYhLClhxm0SvnmOLrH8WA9DE2wwot8MuCp4E86fTll1m89yEdtx+BxUimB41Tfbz/aeOJBhC/X1OM1pEE2SKVl+veBKN4W0Ym6pu4ZxfFmtn3ERrziZOgZIZWwDpkRSQEm4Q1ig7iW3XzOS1aqWxKJ/0Wi1kmUmxzPgVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2P+Ih43D; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2P+Ih43D"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42ba8928f1dso66685e9.1
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 02:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725271070; x=1725875870; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lZQX/cMZETZqukPtivvikiv242o9q96eLnQhbaJJJkM=;
        b=2P+Ih43DTgMZFLFKHXLlYLTyTeRbvfNLrc8HnSaoOzFaCwDZHoxhaK1jVFL/fMl3Cf
         kD8kYpVf/eJC4qksm4WazXuZrNUt+rHaIiBZJDKsilFYX0G8tl4ohD38LTbkydm8GYOM
         tIuhk7SF3F6k0AcMNL4W4NgDL+Dagkm8QHPhbqzg6siYsRgkzrdF0WXSkTkDD08pRZhE
         QS/k6XxoOGltlrb3nHPZ003gmtuUkhofoqJl1rRVSWb9LVf0GfuHpg2ru4Gv0j05Z+kE
         N60fS8XVpjTV7gfJCc1fZKuj8wOi+FMqMwMZ6t6g7j/ULBhRW2mZziVrN5TyOHWuzF/t
         5EUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725271070; x=1725875870;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lZQX/cMZETZqukPtivvikiv242o9q96eLnQhbaJJJkM=;
        b=Y2VQVy2P2gwez3zz6YeTPNmbT4Vc/eO7VThXVHoXrR8hKHfXsf98VwU2yYpDu4B3v6
         ZZkODckP9GNkLgweMbs6bEMxHBkybaHRhDpf87yAsTOb4aZtCineW3oRJj7AZ8n7a18K
         xJ+ox84q9A0vvfad4GwUZXM1H71XC9L1fshkvbu5ahgZlwOqNQ70tkj5lP841SAzczo5
         YBgpkYuvdlMLA1s7K1T0qyjQsuxzU7SnmA2gB/F9tsA1xrgXzBwrjIzU5Q4jvXINJS32
         aXaGHhPRv+BU0Mdeu9U4eDbvGBkbnNqTPFmQKpfm1zkebpetWvjBJ/AKRJJ1Zl+ZjoEd
         Vbiw==
X-Forwarded-Encrypted: i=1; AJvYcCUA0wubcbX87SFCq7X5Vt9b1mCg0e+gdIy5sHS4/v/6AiWMWjZVSxSKfl3GXmplOPDfg/AgifUV@lists.linux.dev
X-Gm-Message-State: AOJu0Yya8YpSymke2W2C4EISviS8RwEQSAePmTDmGn+3OkEWu2Tyfcw6
	8bI4gd5LrHoOnDkvmkA2gFpEbRl3DjZQwidHGY1PGXjMrvaQQkYsxCYnJ/vWLA==
X-Google-Smtp-Source: AGHT+IFSZcv0nult7Zja5pAokUpRh3eCHY8+dggfufZa4QfUGMc7wSMOSbQ5AYJaIDsiCUY7g7vMyA==
X-Received: by 2002:a05:600c:500f:b0:426:5d89:896d with SMTP id 5b1f17b1804b1-42c78767f7amr1965085e9.1.1725271069765;
        Mon, 02 Sep 2024 02:57:49 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee4d391sm11015220f8f.3.2024.09.02.02.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 02:57:49 -0700 (PDT)
Date: Mon, 2 Sep 2024 09:57:45 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <ZtWMGQAdR6sjBmer@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240830170426.GV3773488@nvidia.com>

On Fri, Aug 30, 2024 at 02:04:26PM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 30, 2024 at 04:09:04PM +0000, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Tue, Aug 27, 2024 at 12:51:38PM -0300, Jason Gunthorpe wrote:
> > > For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
> > > as the parent and a user provided STE fragment that defines the CD table
> > > and related data with addresses translated by the S2 iommu_domain.
> > > 
> > > The kernel only permits userspace to control certain allowed bits of the
> > > STE that are safe for user/guest control.
> > > 
> > > IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> > > translation, but there is no way of knowing which S1 entries refer to a
> > > range of S2.
> > > 
> > > For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
> > > flush all ASIDs from the VMID after flushing the S2 on any change to the
> > > S2.
> > > 
> > > Similarly we have to flush the entire ATC if the S2 is changed.
> > > 
> > 
> > I am still reviewing this patch, but just some quick questions.
> > 
> > 1) How does userspace do IOTLB maintenance for S1 in that case?
> 
> See
> 
> https://lore.kernel.org/linux-iommu/cover.1724776335.git.nicolinc@nvidia.com
> 
> Patch 17

Thanks, I had this series on my radar, I will check it by this week.

>
> Really, this series and that series must be together. We have a patch
> planning issue to sort out here as well, all 27 should go together
> into the same merge window.
> 
> > 2) Is there a reason the UAPI is designed this way?
> > The way I imagined this, is that userspace will pass the pointer to the CD
> > (+ format) not the STE (or part of it).
> 
> Yes, we need more information from the STE than just that. EATS and
> STALL for instance. And the cachability below. Who knows what else in
> the future.

But for example if that was extended later, how can user space know
which fields are allowed and which are not?

> 
> We also want to support the V=0, Bypass and Abort STE configurations
> under the nesting domain (V, CFG required) so that the VIOMMU can
> remain affiliated with the STE in all cases. This is necessary to
> allow VIOMMU event reporting to always work.
> 
> Looking at the masks:
> 
> STRTAB_STE_0_NESTING_ALLOWED = 0xf80fffffffffffff
> STRTAB_STE_1_NESTING_ALLOWED = 0x380000ff
> 
> So we do use alot of the bits. Reformatting from the native HW format
> into something else doesn't seem better for VMM or kernel..
> 
> This is similar to the invalidation design where we also just forward
> the invalidation command as is in native HW format, and how IDR is
> done the same.
> 
> Overall this sort of direct transparency is how I prefer to see these
> kinds of iommufd HW specific interfaces designed. From a lot of
> experience here, arbitary marshall/unmarshall is often an
> antipattern :)

Is there any documentation for the (proposed) SMMUv3 UAPI for IOMMUFD?
I can understand reading IDRs from userspace (with some sanitation),
but adding some more logic to map vSTE to STE needs more care of what
kind of semantics are provided.

Also, I am working on similar interface for pKVM where we “paravirtualize”
the SMMU access for guests, it’s different semantics, but I hope we can
align that with IOMMUFD (but it’s nowhere near upstream now)

I see you are talking in LPC about IOMMUFD:
https://lore.kernel.org/linux-iommu/0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com/T/#m2dbb08f3bf8506a492bc7dda2de662e42371e683

Do you have any plans to talk about this also?

Thanks,
Mostafa
> 
> > Making user space messing with shareability and cacheability of S1 CD access
> > feels odd. (Although CD configure page table access which is similar).
> 
> As I understand it, the walk of the CD table will be constrained by
> the S2FWB, just like all the other accesses by the guest.
> 
> So we just take a consistent approach of allowing the guest to provide
> memattrs in the vSTE, CD, and S1 page table and rely on the HW's S2FWB
> to police it.
> 
> As you say there are lots of memattr type bits under direct guest
> control, it doesn't necessarily make alot of sense to permit
> everything in those contexts and then add extra code to do something
> different here.
> 
> Though I agree it looks odd, it is self-consistent.
> 
> Jason
