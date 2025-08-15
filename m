Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DF723FC54;
	Fri, 15 Aug 2025 05:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755235817; cv=none; b=Xnl2EQTinvXtt1QTteRddu4sWKlzfBlDxh5CXy75m/3mfYNg4JnYHKkmIB2JddGzXNh84t3dotaxWVMVtblsmZLFjOV2p8mdv5qmHVLV42AORod8lA/6YhKOJ3kVzgUwKib/bkLzXrmK+sz9v0eLycWm7e0N0RRgmLqpZ7k41SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755235817; c=relaxed/simple;
	bh=y0xyaJyPtcDPNLHhbPevkPLJ5VRQZj0+f0qVNL2ihWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BQ8dEV1R/t+Plulya+WP7oAabE+WGg1bg+wpF/Fm0pIYP+p8lT+LJh2qwgDI1Tkm64Ln0QJwUC8PQSnPVya2KlF6gqiJPg3srZ9/CJP4ZpEqqVD3CvkmWGTf7idSXPBIMlQXbfvRUYAqQHNn0bKfHMo6s1CXWCPPSyrdICH0DsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lb08oeWv; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lb08oeWv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755235816; x=1786771816;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y0xyaJyPtcDPNLHhbPevkPLJ5VRQZj0+f0qVNL2ihWc=;
  b=lb08oeWvcIV0hhXpzPTT1GehWEksO/reWfvK0Y1xvr9wKUzy7/z1sZFS
   j0AvAc4NZ1giB1MTIJ/5AvrrWcsg9AjzTpgu/yrz4v5vWYE6yU15a6x8P
   c0itAkLQTT+F4IpMHnvf7f5gTpSEb31AoRZXAsV4QEQz8fiGjiB9T7s8E
   v5SDq0z5ZseFFItUppVA/qzCt7IMiB0fTWiJYpyhHSRnWI9NdwUkyf9SU
   hSdRgGyTHFn00YuZGy+XwiGNS7QYXr7S+EAsucSNtrgTsJlEnoeZCYsr8
   ogNJYA7SmkWfhDX7B20NfVHE3wGL3IKQsG7eEc2uzL+nZR80a8Dp36REa
   A==;
X-CSE-ConnectionGUID: eLDMs5bSSDKBCNWZpCnByA==
X-CSE-MsgGUID: Z7mCQ+Y3RxuEI0X4E8li7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="82994985"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="82994985"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 22:30:15 -0700
X-CSE-ConnectionGUID: RseyzJmKT36kWr3vroMtQg==
X-CSE-MsgGUID: a9/KIfTrTBati7fQxiXAIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166914870"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 22:30:08 -0700
Message-ID: <aeb04f91-ffce-4092-8dbc-17d116cd7c7e@linux.intel.com>
Date: Fri, 15 Aug 2025 13:28:02 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] iommu: Add iommu_get_domain_for_dev_locked()
 helper
To: Nicolin Chen <nicolinc@nvidia.com>, robin.murphy@arm.com,
 joro@8bytes.org, bhelgaas@google.com, jgg@nvidia.com
Cc: will@kernel.org, robin.clark@oss.qualcomm.com, yong.wu@mediatek.com,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
 thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
 rafael@kernel.org, lenb@kernel.org, kevin.tian@intel.com,
 yi.l.liu@intel.com, linux-arm-kernel@lists.infradead.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-tegra@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-pci@vger.kernel.org, patches@lists.linux.dev, pjaroszynski@nvidia.com,
 vsethi@nvidia.com, helgaas@kernel.org, etzhao1900@gmail.com
References: <cover.1754952762.git.nicolinc@nvidia.com>
 <a69557026b7e2353bae67104bbe6a88f0682305e.1754952762.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <a69557026b7e2353bae67104bbe6a88f0682305e.1754952762.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/25 06:59, Nicolin Chen wrote:
> There is a need to attach a PCI device that's under a reset to temporally
> the blocked domain (i.e. detach it from its previously attached domain),
> and then to reattach it back to its previous domain (i.e. detach it from
> the blocked domain) after reset.
> 
> During the reset stage, there can be races from other attach/detachment.
> To solve this, a per-gdev reset flag will be introduced so that all the
> attach functions will bypass the driver-level attach_dev callbacks, but
> only update the group->domain pointer. The reset recovery procedure will
> attach directly to the cached pointer so things will be back to normal.
> 
> On the other hand, the iommu_get_domain_for_dev() API always returns the
> group->domain pointer, and several IOMMMU drivers call this API in their
> attach_dev callback functions to get the currently attached domain for a
> device, which will be broken for the recovery case mentioned above:
>   1. core asks the driver to attach dev from blocked to group->domain
>   2. driver attaches dev from group->domain to group->domain
> 
> So, iommu_get_domain_for_dev() should check the gdev flag and return the
> blocked domain if the flag is set. But the caller of this API could hold
> the group->mutex already or not, making it difficult to add the lock.
> 
> Introduce a new iommu_get_domain_for_dev_locked() helper to be used by
> those drivers in a context that is already under the protection of the
> group->mutex, e.g. those attach_dev callback functions. And roll out the
> new helper to all the existing IOMMU drivers.

Given that iommu_group->mutex is transparent to the iommu driver, how
about

/*
  * Called only by iommu drivers in the callback context where
  * group->mutex has already been held by the core.
  */
struct iommu_domain *iommu_get_domain_for_dev_internal(struct device *dev)
{
	...
	lockdep_assert_held(&group->mutex);
	...
}

?

> 
> Add a lockdep_assert_not_held to the existing iommu_get_domain_for_dev()
> to note that it would be only used outside the group->mutex.
> 
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Thanks,
baolu
