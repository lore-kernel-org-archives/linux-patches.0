Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E86B41C79;
	Thu, 19 Dec 2024 02:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734574059; cv=none; b=U051iFMgvWSyun68ufVaMY3dFqqT/qM3gPKaJuKO903XOB1rHVgyE+jK+lhF0UHuAkcRfU8+0CSDEByoK/bexOCN5f+IgS3fJ54IEhxXFSMZrOU0YbN8BvjTVRlCOiX/iRtsW8lwIE9HxgghS+q21AL5fcUWaEZuXC2MZbOYlGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734574059; c=relaxed/simple;
	bh=u9RKb7yTKqQPGL6ESkRUFOfnECFsgIrUnpYAIzAyl1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k08vjNBSvNktYBmWKOfxbs6l3U3qfizl0vr49TvUDJamF8IFVvGM3ik4PCx/AKgtTvyBqsVktMCCr+h2FDaxEDxicN99H2cpm5XvJoS7i5LbD4gtrPF1TNBuoy0GJriJ0k+Jh6jg0yx05a2gsCIisqYHhYXYNzRqHuDSREaIcR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NVTkSXsf; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NVTkSXsf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734574057; x=1766110057;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u9RKb7yTKqQPGL6ESkRUFOfnECFsgIrUnpYAIzAyl1Y=;
  b=NVTkSXsf7t00dEecaADWF+S+OiFIGTZ8ZiNhrtghH/QQVHqNI3rkJC6e
   egXj3APkAnPuhL3sMlB/q/9nxQ5w0xj4RLL2gtSEY/ALhuds+LB8Ueodh
   ugn0X0wLrQPu9uXZSR99i12uuZsEyNJIhgdcQD7/0YdSXsJg/phddgYYU
   AXFCqbI6gjoapEdJnOtg1RmHYWgP67ztYXyhqwK7Wg7JiHUookRP0tyRy
   xDAkLsZP9rx3ZmUWi8px4IhTDvC1/Y0fwZxRZ1XSLAa1u1wzii96rcKtR
   4Oj5Qoi8HB0gWuGwpFz7Cr+1PhDuYY7nQsRhDE3MmsD2Xcs7UCpu03sAy
   A==;
X-CSE-ConnectionGUID: 2v/SEs5MTpuEKa74pppc9w==
X-CSE-MsgGUID: 7Vi0EL3pRA2WpQa8bUv4Kg==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="35101033"
X-IronPort-AV: E=Sophos;i="6.12,246,1728975600"; 
   d="scan'208";a="35101033"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2024 18:07:37 -0800
X-CSE-ConnectionGUID: BUEwx9zdRY+0awZQGNEcJQ==
X-CSE-MsgGUID: Mwq7DUNKQP+Q7w80W636Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,246,1728975600"; 
   d="scan'208";a="98449984"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2024 18:07:32 -0800
Message-ID: <56c65e50-5890-42af-85b7-85f8a1bf5cf5@linux.intel.com>
Date: Thu, 19 Dec 2024 10:05:53 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/14] iommufd/viommu: Add iommufd_viommu_get_vdev_id
 helper
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com,
 will@kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 robin.murphy@arm.com, dwmw2@infradead.org, shuah@kernel.org,
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, eric.auger@redhat.com, jean-philippe@linaro.org,
 mdf@kernel.org, mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
 smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
 patches@lists.linux.dev
References: <cover.1734477608.git.nicolinc@nvidia.com>
 <21d7e63b97d81d0acf9127418a67efe386787261.1734477608.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <21d7e63b97d81d0acf9127418a67efe386787261.1734477608.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/24 13:00, Nicolin Chen wrote:
> This is a reverse search v.s. iommufd_viommu_find_dev, as drivers may want
> to convert a struct device pointer (physical) to its virtual device ID for
> an event injection to the user space VM.
> 
> Again, this avoids exposing more core structures to the drivers, than the
> iommufd_viommu alone.
> 
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
> ---
>   include/linux/iommufd.h        |  8 ++++++++
>   drivers/iommu/iommufd/driver.c | 20 ++++++++++++++++++++
>   2 files changed, 28 insertions(+)
> 
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index b082676c9e43..ac1f1897d290 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -190,6 +190,8 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
>   					     enum iommufd_object_type type);
>   struct device *iommufd_viommu_find_dev(struct iommufd_viommu *viommu,
>   				       unsigned long vdev_id);
> +unsigned long iommufd_viommu_get_vdev_id(struct iommufd_viommu *viommu,
> +					 struct device *dev);

Hi Nicolin,

This series overall looks good to me. But I have a question that might
be irrelevant to this series itself.

The iommufd provides both IOMMUFD_OBJ_DEVICE and IOMMUFD_OBJ_VDEVICE
objects. What is the essential difference between these two from
userspace's perspective? And, which object ID should the IOMMU device
driver provide when reporting other events in the future?

Currently, the IOMMUFD uAPI reports IOMMUFD_OBJ_DEVICE in the page
fault message, and IOMMUFD_OBJ_VDEVICE (if I understand it correctly) in
the vIRQ message. It will be more future-proof if this could be defined
clearly.

Thanks,
baolu
