Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88A27F460;
	Tue, 22 Oct 2024 02:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729564120; cv=none; b=KkbXDCmFS+u0YP2OIvr13zwLoB3TWIZMf6LAeMJd72UU4rjz+fyQFGlKtClvx7ahjy2PHzXU2OMtNMNjEpYxD28fwvhn3eP6hSE599HuByj+At82s6/COMASviwF1qxPHC1huP8CZ8AY/dBZnyYx6KZoXG0Jt2an2/zJBSFQQvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729564120; c=relaxed/simple;
	bh=iEVflV2wjj9RZWicdMKZ+yzF/35ywBCnw8lgo8VyfoU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MVXr7Bf60J64bqDez0kR1wfx6aBMHA8jYBLlG8Q6gq9yv1CiLM93WzXE+39Fy6BCdUMdGUPXqFqWMG1lyp09xXe4UkpADEQ+9ZZaszv5NKlI7jZs/qlptKoOr01mTlGQFAnMkXNlhCRi9ZjKVM3M8mzsejQrmUVgwVEmSN3CDWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fk4YWK0+; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fk4YWK0+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729564119; x=1761100119;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iEVflV2wjj9RZWicdMKZ+yzF/35ywBCnw8lgo8VyfoU=;
  b=fk4YWK0+JUuL7IiMjjoaoKi8nc79pebTBEJTEEvGzBnBxTnAklfhju/b
   fm9fwTHZCIenlQcyUiKqk2znMQeVIQMljCcTcnBmXJTW+W3dcvxyqs52n
   lCTqq7iVZGyPu6kY4n2gn/PyGXjrw/SsbJdaT7B1EbrTKerynXqmsgs1n
   O8eIHxojipFTtO9XA0sz7TCFeEXzgiKoGWuGijgMdq2piYyjk5IOIfRjZ
   ODIf++mOSQyY7CVcW7yi8Doz836ekfqGQ9a+6jOmDvt4YaVCZPc2h/ycZ
   5updLe+Sdlj1GzzTrSwVNBG9FaoM8hkUq4qT+7VYR6mrKrxFkK7FpiWAD
   A==;
X-CSE-ConnectionGUID: nlSXy9gtRUirI6eDBt5jug==
X-CSE-MsgGUID: 1LUo+N7ESS6nHDZspzAEPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28954291"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28954291"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 19:28:38 -0700
X-CSE-ConnectionGUID: V/GHqH7dS5aJ9QT0c3vq+w==
X-CSE-MsgGUID: 1rV8F+TdROq4Rkx6rM0JtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="79288212"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 19:28:33 -0700
Message-ID: <b2c75705-2998-4e51-90f4-00b8bab785f5@linux.intel.com>
Date: Tue, 22 Oct 2024 10:28:30 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 robin.murphy@arm.com, dwmw2@infradead.org, shuah@kernel.org,
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
 mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
 smostafa@google.com, yi.l.liu@intel.com, aik@amd.com,
 zhangfei.gao@linaro.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 02/11] iommufd: Introduce IOMMUFD_OBJ_VIOMMU and its
 related struct
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com,
 will@kernel.org
References: <cover.1729553811.git.nicolinc@nvidia.com>
 <74fec8c38a7d568bd88beba9082b4a5a4bc2046f.1729553811.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <74fec8c38a7d568bd88beba9082b4a5a4bc2046f.1729553811.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/10/22 8:19, Nicolin Chen wrote:
> + * @viommu_alloc: Allocate an iommufd_viommu on a physical IOMMU instance behind
> + *                the @dev, as the set of virtualization resources shared/passed
> + *                to user space IOMMU instance. And associate it with a nesting
> + *                @parent_domain. The @viommu_type must be defined in the header
> + *                include/uapi/linux/iommufd.h
> + *                It is suggested to call iommufd_viommu_alloc() helper for
> + *                a bundled allocation of the core and the driver structures,
> + *                using the given @ictx pointer.
>    * @pgsize_bitmap: bitmap of all possible supported page sizes
>    * @owner: Driver module providing these ops
>    * @identity_domain: An always available, always attachable identity
> @@ -591,6 +601,10 @@ struct iommu_ops {
>   	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid,
>   				 struct iommu_domain *domain);
>   
> +	struct iommufd_viommu *(*viommu_alloc)(
> +		struct device *dev, struct iommu_domain *parent_domain,
> +		struct iommufd_ctx *ictx, unsigned int viommu_type);

Is the vIOMMU object limited to a parent domain?

Thanks,
baolu
