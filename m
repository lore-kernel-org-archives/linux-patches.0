Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CBE13C9C8
	for <patches@lists.linux.dev>; Thu,  9 May 2024 02:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715221276; cv=none; b=CtsBIA+PS2XN8gDX0U6/UITXe3fuSIDC3wrUlFagcmztMwBKVJG47hmtkZwIMJjdS0mHGlv8uTJPS7azDM8kyRFATOV20/OarWmq38QM6A+F+uyMFZ1kQ0sUeMboxm5LZ/qAEMSJYLGuGvG9sQvnFnFUstHKa3mW+LbZDcbfzSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715221276; c=relaxed/simple;
	bh=3VUFQA7XVudV4Zaa53BZYJqsCRvS6ySZJTDIgpHafho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=XtUYhYc0FuoxuHYyTILd77w/Y9lTWOXhbcSKpccmMMDuU2UmUQWR6OvicEAS9/c2esZIMd4rvAEN87vUac9tDfOcobajgwU1851aUmzG0zI0Eij3upQdaFsyqD6/9E0bYSzmMQXIfQUE21UlWdw6EAIiAiw3HwK5DYJcXIlP9+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cxnf5VY8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cxnf5VY8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715221274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Rq3cH/XdLltSk0QNEEJsuojDTbtoTyT6Q7zMgSd3fA=;
	b=cxnf5VY80hGmIc1nPbaBnwWUFUbT0fQoxEV2O1Ewhpouvs2b+kXFmqRJnNP+5G3IM5ODrQ
	/XNQgJqLXFom1cnugXO04KHY8hWWL/B5Ct656nKDM4c0D3cXE1J0SEy+/m4LzT2ClrZMZ2
	qp6RBHOHOyxrwPU7VGuEsIaB3FiaFpM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-ZW_QionyM1Oibf39PbVCMg-1; Wed, 08 May 2024 22:21:13 -0400
X-MC-Unique: ZW_QionyM1Oibf39PbVCMg-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5c66a69ec8eso335360a12.3
        for <patches@lists.linux.dev>; Wed, 08 May 2024 19:21:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715221272; x=1715826072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Rq3cH/XdLltSk0QNEEJsuojDTbtoTyT6Q7zMgSd3fA=;
        b=uG2lb7sX8WI2k5u7Wn2Q3JmxCPkwkC1Lpbk8zK+qsN/HSE/PuXmEYkQsAC6WZYo18N
         J75jEf1FralEzKsKfzZLpA6qDxo+9a3mVCzV4cVrtkA6DGl1OSaQlvE/rbTQX5HRoV5c
         ZvsIR0UlNO8Fb6XDhOXOduVmsQzCMHDbFFjQ+7IhHF5fVR8E2oNXsiHx4ow/qzcWT9w5
         v9UGBAFkXbE/KHpzXa6TD/VfTzcSeBtinzqQgCwbk39vifKjl0Tp3T7r5ry4VRfQTsoa
         cRHi/uZl39fTB7Wq2iOimRq+UaYWIpEB2hf5J8JbODl/9ogEWqeeR8hBfB/mfvqptxwq
         UpnA==
X-Forwarded-Encrypted: i=1; AJvYcCW8Q/z2Um0xfLVxdbF0UjEzm5lNtjnDWdEEnnBxNQgXDD5f0h4VV3oyM9b98SmAEkNfrab+/vumxenl5prCNhwpR6VWJqSjgA==
X-Gm-Message-State: AOJu0YwbUU9/td12jVuTDaB1NcTObvAONRlxpagqDncE4r7BR1I1BvP1
	p7Wld1cqbZ3TR1bLwKBEK4Ql5HnITAENXWzN2XTfmoSjXKeTvn1M20D/xOzyk1E8Rsv6VS4gScB
	rHHcJstvlTBFOh+5XPUbPQ5M/kmOT/J6U7oCzdeWNaQfSzEfVq6nkdog=
X-Received: by 2002:a17:903:188:b0:1e4:48e7:3dab with SMTP id d9443c01a7336-1eeb03a616dmr62766345ad.38.1715221271986;
        Wed, 08 May 2024 19:21:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEK/ibwtMYxPe9yJMo/zOE5pMg3oZf/trNaGcXjGqlmZidGTk06l78UnsSty1gQYIZfVsHrcQ==
X-Received: by 2002:a17:903:188:b0:1e4:48e7:3dab with SMTP id d9443c01a7336-1eeb03a616dmr62766095ad.38.1715221271608;
        Wed, 08 May 2024 19:21:11 -0700 (PDT)
Received: from localhost (ip98-179-76-110.ph.ph.cox.net. [98.179.76.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0b9d164dsm2377865ad.52.2024.05.08.19.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 19:21:11 -0700 (PDT)
Date: Wed, 8 May 2024 19:21:10 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Moritz Fischer <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v9 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry
Message-ID: <zgyiqgym6tf6dkxa6bxzfgexjojwhteqjmuxmed3twejpeoy2i@ortfllwylmpp>
References: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
 <smzgwi3nbkt5ws2psvh6hzygaelalfviv425q6igherxp52tga@6x5u45gvorrj>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <smzgwi3nbkt5ws2psvh6hzygaelalfviv425q6igherxp52tga@6x5u45gvorrj>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2024 at 07:17:40PM GMT, Jerry Snitselaar wrote:
> On Tue, Apr 30, 2024 at 02:21:41PM GMT, Jason Gunthorpe wrote:
> > Add tests for some of the more common STE update operations that we expect
> > to see, as well as some artificial STE updates to test the edges of
> > arm_smmu_write_entry. These also serve as a record of which common
> > operation is expected to be hitless, and how many syncs they require.
> > 
> > arm_smmu_write_entry implements a generic algorithm that updates an STE/CD
> > to any other abritrary STE/CD configuration. The update requires a
> > sequence of write+sync operations with some invariants that must be held
> > true after each sync. arm_smmu_write_entry lends itself well to
> > unit-testing since the function's interaction with the STE/CD is already
> > abstracted by input callbacks that we can hook to introspect into the
> > sequence of operations. We can use these hooks to guarantee that
> > invariants are held throughout the entire update operation.
> > 
> > Link: https://lore.kernel.org/r/20240106083617.1173871-3-mshavit@google.com
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Michael Shavit <mshavit@google.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/Kconfig                         |  13 +-
> >  drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
> >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   8 +-
> >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 465 ++++++++++++++++++
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  43 +-
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  30 ++
> >  6 files changed, 533 insertions(+), 27 deletions(-)
> >  create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
> > 
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index 0af39bbbe3a30e..f872aeccd82041 100644
> > --- a/drivers/iommu/Kconfig
> > +++ b/drivers/iommu/Kconfig
> > @@ -397,9 +397,9 @@ config ARM_SMMU_V3
> >  	  Say Y here if your system includes an IOMMU device implementing
> >  	  the ARM SMMUv3 architecture.
> >  
> > +if ARM_SMMU_V3
> >  config ARM_SMMU_V3_SVA
> >  	bool "Shared Virtual Addressing support for the ARM SMMUv3"
> > -	depends on ARM_SMMU_V3
> >  	select IOMMU_SVA
> >  	select IOMMU_IOPF
> >  	select MMU_NOTIFIER
> > @@ -410,6 +410,17 @@ config ARM_SMMU_V3_SVA
> >  	  Say Y here if your system supports SVA extensions such as PCIe PASID
> >  	  and PRI.
> >  
> > +config ARM_SMMU_V3_KUNIT_TEST
> > +	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > +	depends on KUNIT
> 
> Should this be 'depends on KUNIT=y'
> 
> Seeing ld complain when building it on top of the rhel kernel. I'm grabbing a system
> to verify that it happens with joerg's next branch as well.
> 
> Regards,
> Jerry
> 

And I see you and Will are discussing it already. Ignore :)

