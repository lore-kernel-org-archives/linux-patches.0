Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794984757;
	b=aVOmxmMlfAMgYueSDgt2QA9lWNOnrKMAWJjwD+UPvQ6APx3ByPQA4z3riDXoCw9chbUQ
	 we6IrIoyJO+UdTE5rboOlBzeoehYhkqr9nUsocajra4cURfXH4OT85BRRiciAqr/XaS26
	 KOVw+Vp4f1L/xKm/mJLjTGbwNyGuHIrcFShrx9u2TuDZBRzkMPPskqm6cUyuZRbmzCdoq
	 1fBoLA5GuGeOYGuTjy57mb7Rs6h7kxbL7Q5dtlSNqfUAvEC2EDszZYKWv/wwx+GarUjtZ
	 0cdK9fv1AGB2UhMhCe0o99oj7+4Pw0c+7EcsHE8UCv8EFTGVStlsWNxiOFItEaGEpiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794984757;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=FKkYWihfdRNCMKKO6J64hBPhG+NVMAKKX6FQ+i+pK6Q=;
	b=uBnuyAiH/8nFIR/9hdXOUh9eVHV8ruAlyk6/B2pMxIA18GyDSZlxJ9m2XW+KCne4MQZC
	 VrwRPrPi4zpFRvuXMKTA28G6z8PHOODy50cwlkf+7PdiDubyiK2WZufKFScHYipr976Ik
	 6wW4F3E4L/xs84aTxCjUr3SHf0kLHbSiXP4fgT7RSj5HhaliFmI9RXM5wsaVvxG3CzTnn
	 iMTEWbjCpujfKQhXLKl2XFvyVKddB5k4RclO3zBv+wmZ+uXgx3LPkEeuWyJThoIafYz7M
	 HM82pwxIIJRGjkwaD0eRnHj4KPiWxW/UfbVUhmgRcyyv4nrIZPXrDdE02g5PeamWglw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ND+sDlQ1;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A59606A31C;
	Wed, 18 Nov 2026 06:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16A59606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ND+sDlQ1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794984757; x=1826520757;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DrEUIZ3qyU/ux7WrUPR07gul8fRUSWl1kJJN3nWoEdY=;
  b=ND+sDlQ1SgVvOGT1uui8wzCpLkaEnnH1xv1++l+pEDes1pC9gkWEd1NH
   kjWa1QEc5uSCegSWV04Tch0hMS4f6zI4GqUVhfBZie20JyMfn781i45WB
   7I5yKhAFWp29h3GgiHK21aspdHZ262c3Nt0Cx5pLJmTjwnWAK43lm82wk
   w41fRP5/Fx4ax/GvBacWhKbe1ZrMyjqD9GiXWZDZHwHIuIDBw83XHWQwY
   CO4RVgDUp6aF5lENeMG0DKDu/gzkzMQbalNchXahciHetgw5UiD2zxcv2
   Vqhy9Jf/SpGTBdZJXBMRxZe8odGBBLOXBZUbGZqxuE0dDIYFgh6F4rvyU
   g==;
X-CSE-ConnectionGUID: alxuX6LCRJStK5mJQC+OBA==
X-CSE-MsgGUID: fvhl3dy2SbmwlH6Kv8kK3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3772253"
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="3772253"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 22:52:36 -0800
X-CSE-ConnectionGUID: T9CVNhvrRNOyjSE6/SDleg==
X-CSE-MsgGUID: tRAtyKlLR/y4UDhkKRsFDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="9988327"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.47.46])
  by orviesa007.jf.intel.com with ESMTP; 17 Nov 2026 22:52:28 -0800
Date: Wed, 18 Nov 2026 14:43:32 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v9 02/13] virt: coco: tsm: Remove the device from lookup
 before PCI teardown
Message-ID: <av1JFH8W63T37bK6@yilunxu-OptiPlex-7050>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-3-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116081935.85372-3-aneesh.kumar@kernel.org>

On Mon, Nov 16, 2026 at 01:49:24PM +0530, Aneesh Kumar K.V (Arm) wrote:
> PCI connect looks up a TSM by ID under pci_tsm_rwsem. Previously,
> pci_tsm_unregister() released that lock after tearing down PCI state
> while the TSM was still in the class lookup. A racing connect could then
> attach a new PCI context that the teardown would never see.
> 
> Remove the device from the class lookup first, then take the PCI write
> lock to drain in-flight operations and destroy their contexts. Drop the
> device reference only after PCI teardown completes.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: linux-coco@lists.linux.dev
> Fixes: 3225f52cde56 ("PCI/TSM: Establish Secure Sessions and Link Encryption")
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  drivers/virt/coco/tsm-core.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
> index 03894c5663f1..57db3f14cf46 100644
> --- a/drivers/virt/coco/tsm-core.c
> +++ b/drivers/virt/coco/tsm-core.c
> @@ -56,23 +56,22 @@ static struct tsm_dev *alloc_tsm_dev(struct device *parent)
>  	return no_free_ptr(tsm_dev);
>  }
>  
> -static struct tsm_dev *tsm_register_pci_or_reset(struct tsm_dev *tsm_dev,
> -						 struct pci_tsm_ops *pci_ops)
> +static int __tsm_register(struct tsm_dev *tsm_dev, struct pci_tsm_ops *pci_ops)
>  {
>  	int rc;
>  
>  	tsm_dev->pci_ops = pci_ops;
>  	rc = pci_tsm_register(tsm_dev);
>  	if (rc) {
> +		tsm_dev->pci_ops = NULL;

Previous comment shows this can't solve any racing connect problem.
And with your next patch, the racing connect is solved. So I think
remove it.

>  		dev_err(tsm_dev->dev.parent,
>  			"PCI/TSM registration failure: %d\n", rc);
> -		device_unregister(&tsm_dev->dev);
> -		return ERR_PTR(rc);
> +		return rc;
>  	}
>  
>  	/* Notify TSM userspace that PCI/TSM operations are now possible */
>  	kobject_uevent(&tsm_dev->dev.kobj, KOBJ_CHANGE);
> -	return tsm_dev;
> +	return 0;

I really don't think we need this wrapper. In next patch we move uevent
out, so this wrapper is just:

	tsm_dev->pci_ops = pci_ops;
	pci_tsm_register();

Open code it, as Alexey and I suggest before. All kinds of xxx_tsm_register()
are really confusing.

>  }
>  
>  struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
> @@ -96,15 +95,22 @@ struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
>  	if (rc)
>  		return ERR_PTR(rc);
>  
> -	return tsm_register_pci_or_reset(no_free_ptr(tsm_dev), pci_ops);
> +	rc = __tsm_register(tsm_dev, pci_ops);
> +	if (rc) {
> +		device_del(dev);
> +		return ERR_PTR(rc);
> +	}
> +	return no_free_ptr(tsm_dev);

I think none of the above changes belongs to this patch. They don't
solve any problem mentioned in the changelog.

They belong to the next patch.

>  }
>  EXPORT_SYMBOL_GPL(tsm_register);
>  
>  void tsm_unregister(struct tsm_dev *tsm_dev)
>  {
> +	/* Remove the class lookup first. */
> +	device_del(&tsm_dev->dev);
>  	if (tsm_dev->pci_ops)

The patch 1 rejects NULL pci_ops, so is this check still needed? Can we
remove this check in your Patch 1?

>  		pci_tsm_unregister(tsm_dev);
> -	device_unregister(&tsm_dev->dev);
> +	put_device(&tsm_dev->dev);
>  }
>  EXPORT_SYMBOL_GPL(tsm_unregister);
>  
> -- 
> 2.43.0
> 
> 
