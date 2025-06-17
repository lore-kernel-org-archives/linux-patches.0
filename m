Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D2027EFE9
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 05:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750139002; cv=none; b=NEzRjqQowr9crtk6pP1QxS+/hRJ2sYfRLQ9qLsaqBm7aLS/M597Mld8gaI4lxP3yRwKWWhM/ljniWXBPkZAX9x10SJFmVykTDvz8hm2d26ZKFe5ytNotyDuytZGAZKmNExhMzvMAq/b6PzYd8XwOT284tV+2IsbQZBbInUZS36s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750139002; c=relaxed/simple;
	bh=SghC4et/z2EDycDOFtWYFVm+MtMf9BDEsdZTXx4JMDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ai7wh10DFvA6dFU0tZI+gS1KhDMSIKBxAQmYzmzVyS1LjDRd1iEIxg6LodIQDpxmT3HkJ9yL4erS5pqdMGTeVUVlj+i/I3Trzz3B8Kxzok0nw3J+kbQcZ8SdSIT23Hf+W6/HkLrIzUE2R95acCscQItjGLPffRNDYq/4VSurmms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uFAbR2rS; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uFAbR2rS"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2348ac8e0b4so83755ad.1
        for <patches@lists.linux.dev>; Mon, 16 Jun 2025 22:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750139000; x=1750743800; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vqy+/M9QHJY6wwtqs4c/CeBC/StH/tZ5ncI+kmSkSV8=;
        b=uFAbR2rSZ+SLThRp4sh+Z2aHef+ATUn5y/OQqc4JpsG9eWpi72y1zQQxuxKHo2JhRz
         ch6Lq/bwyb6/s4BrXQE5GbG79zNNsF/N4aKPngARFMMrweIQNhDfvHxVoGtF25nDXJQU
         +BdK8n/VnVIdgaVtvfOIzo1NFmnH//99pyBySuXaq9xYmnOhW5sqY3iBrDDunkuGvFVa
         5Ay3ruZv+RmRaWmh/sHr4cihgDblf3JhOc0Wo7sor74hTqQ4yL8roAVk/bPqjYOAYy4E
         wulMuHpV0AWv3e78UvMbGrIoXMJGuSrBu70DCTmGmSeiN8EE6lfAPclQ7897gr/cNpl4
         CEOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750139000; x=1750743800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqy+/M9QHJY6wwtqs4c/CeBC/StH/tZ5ncI+kmSkSV8=;
        b=wpKAG5Mos1vZq4EyuANvPmhjOJtJS1OkZ+VtopWeTmoRZMHhGqK4i8xmXATthSeVo2
         63nK6+iTGaJeyDpr6yEeCYfan2uRBN5QI9pR1x0YvJhZdfPURkZSZHSPY/rQ+ZxEAVUK
         RafaRy2G9L7JTcT7ZtYPbFVFCOzWqd1t0J157y1g57CcT6AvIU4Ldbw2Elpic5NLU8gM
         nWDa9GAI0Jf6KKSl1oZJDtXSlqP8hTGP22ffXoVsPwqWo9OafczqwH56BVENnAAXi6Mf
         YW226xSegfv4XMLqzvLQ6BI24KjI6tUgq2ZZ/YIJOCpMMD4j8ego4L5jxIXf3OxBaxKV
         8Xqg==
X-Forwarded-Encrypted: i=1; AJvYcCV5yNSlzv/ALYgBUTw0k6HzjhDXhOlrak7gtoXUnGJ3G6nrxpka9vUC8l+WppvcOfL0Fs8iXRo/@lists.linux.dev
X-Gm-Message-State: AOJu0YwcZ3fG0SK+1KMi142Zs4wUz/vZdOFKopVsuJZdBL/W6HVEfgXR
	k0nqe7bVVETbQhO+Ct152zT5szJJhNfHQKcTKAkEEylW8DGW+5wEP3FJdylEYOE58Q==
X-Gm-Gg: ASbGncukUB6riSWwUjM9raUXtzZFd3w60yB+cef3fvY7MZik7SgZJAB95kd55ssBlY1
	2NV9Stjy5hhKDcf39xJ7Er+N0IVOVJtEhBLvh9MTlu1xie8xkXB1H8PyJVeTPfj8CfyRU74vhmo
	D0E2eSgMwDHo2SNHEVdlUR6SFiGfuD9jsU8tBNXfSqLx/yA/Y+6jvcNMBx0zCgbC+Xur3wePdeq
	zNL9y/mtMqLahBN9FQjXs9lKjNHMcua+WtLFEK/HWnGCQqJopDJhMh/+5tctqO7s32383EiolKC
	ybtAtGzZu9QXswLDnFiqrK51TFQO6TNBwjO9YXHoe+NxfVDrLO0ZwtKQEhZ8sWsgv6gviyNGCmv
	+R5HTJDydUrVV88qRCr/3
X-Google-Smtp-Source: AGHT+IFZAGH5Q2HoxTbpqlW9at8Yr/ZmYieszNEdcG0xorIcE8VWLoKmbjyoc4gI81zSv/z5UnBfOQ==
X-Received: by 2002:a17:902:d48f:b0:234:c2e7:a0e7 with SMTP id d9443c01a7336-2366c5bf6d3mr7082695ad.4.1750138999607;
        Mon, 16 Jun 2025 22:43:19 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1bcbb39sm9722410a91.8.2025.06.16.22.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 22:43:19 -0700 (PDT)
Date: Tue, 17 Jun 2025 05:43:09 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, will@kernel.org,
	robin.murphy@arm.com, joro@8bytes.org, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 10/14] iommu/arm-smmu-v3: Replace arm_vsmmu_alloc with
 arm_vsmmu_init
Message-ID: <aFEAbc5URD93out3@google.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <64e4b4c33acd26e1bd676e077be80e00fb63f17c.1749882255.git.nicolinc@nvidia.com>
 <aFCeCvKkm1MvT3xP@google.com>
 <aFDPtzY3EygoOpUx@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFDPtzY3EygoOpUx@nvidia.com>

On Mon, Jun 16, 2025 at 07:15:19PM -0700, Nicolin Chen wrote:
> On Mon, Jun 16, 2025 at 10:43:22PM +0000, Pranjal Shrivastava wrote:
> > On Fri, Jun 13, 2025 at 11:35:22PM -0700, Nicolin Chen wrote:
> > > To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
> > > are introduced.
> > > 
> > > Sanitize the inputs and report the size of struct arm_vsmmu on success, in
> > > arm_smmu_get_viommu_size().
> > > 
> > > Place the type sanity at the last, becase there will be soon an impl level
> > > get_viommu_size op, which will require the same sanity tests prior. It can
> > > simply insert a piece of code in front of the IOMMU_VIOMMU_TYPE_ARM_SMMUV3
> > > sanity.
> > > 
> > 
> > That's what I was wondering, so we plan to replace the impl->vsmmu_alloc
> > op as well?
> 
> There is no such op in v6.16-rc1.
> 
> > > -	return &vsmmu->core;
> > > +	viommu->ops = &arm_vsmmu_ops;
> > > +	return 0;
> > >  }
> > 
> > Seems much better now that the driver doesn't need to callback to the
> > core for allocating viommu. One quick question though I see we've 
> > removed the following too:
> > 
> >         if (master->smmu->impl_ops &&master->smmu->impl_ops->vsmmu_alloc)
> > 	                vsmmu = master->smmu->impl_ops->vsmmu_alloc(
> > 			                        master->smmu, s2_parent,
> > 						ictx, viommu_type,
> > 						user_data);
> > 
> > Not sure why don't I see that in the diffs.. do we plan to split this
> > into an impl-specific size and init too?
> 
> Because there is no vsmmu_alloc in v6.16-rc1. I guess you are
> referring to older versions of HW queue (vCMDQ) series that
> was not merged?

That's right, my bad. I rebased the older series while pulling,
apologies for the confusion!

Reviewed-by: Pranjal Shrivastava <praan@google.com>

> 
> Thanks
> Nicolin

Thanks!
