Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6579232C85;
	Mon, 28 Apr 2025 01:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745802823; cv=none; b=bmPkvs4Gabufjn8MNQJsv6XYehH/uj9BUwz+zJM5g7nny2+fJgFyBcPhAa34rn/NtLUGxJCmaqweTm67h21B8+rHh+DOGpJwECTKwDrL6tgNdiHJ6Bsbw3aV+PvaRhzOzWkr9KeSfKVH2XXydncOwMnrrwGgWrzAwyrDlM1YdrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745802823; c=relaxed/simple;
	bh=SzVEkDhgS3lNLKaxMmkzixB0NkfENpwp720ZSDFOdIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BhwiWbADGqusl6EDzWz9KxcNhJaxfqdd5wkvvOZlIbXjlkDZ3wZAGb4VPog0r5HZ4oIu8SmOPzgTi0OIEfVESp/30Xod2wWMv7hQzYnUzlTIKfLTGVljgK8CUKmVFNnv9CxL8V1oGlDF2WaxyjJKDWqgp6ncCvmCdduKhZZAtYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U+MKCOk3; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U+MKCOk3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745802822; x=1777338822;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SzVEkDhgS3lNLKaxMmkzixB0NkfENpwp720ZSDFOdIQ=;
  b=U+MKCOk3SzX0LUoDYvab9DnhVKHcDVNoJPPg0cNjSF/uZf2U8ygBFLc6
   +zUyNijoCWGwOpOG5TWfg1eK9arRhI/CAwuSQUVbBFu+ILBCHW8nuIcis
   9m9qy6rql/CfiUxsTIbIjqV9jeTloEbvgd5HCH63Lacg90/b1YqQ11v1Z
   4ymeisKhTOPeT+Cjps+iArMRoAc+eDq0poLJZtFkVMlg++fr0l+9EaeSy
   a53YkCp0nnN3NckBADmgQw61hPPbV2g0HjiZYn1DjDzBzz/OoTAXm069m
   ONoBqpCu5jVIiZ5IEJcowuaoZBgVU10R0WFGCKSagUGCdywY4uv1PclLL
   Q==;
X-CSE-ConnectionGUID: 6BCz/cnSSfWEokr4+tslAQ==
X-CSE-MsgGUID: VGv9SIIJRva/PYKcrGexhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11416"; a="47469200"
X-IronPort-AV: E=Sophos;i="6.15,245,1739865600"; 
   d="scan'208";a="47469200"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 18:13:34 -0700
X-CSE-ConnectionGUID: kCEJNONXT+mMJ2UwL1Mdjw==
X-CSE-MsgGUID: 1gUHhF4hT5y9Cgd2z9Awrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,245,1739865600"; 
   d="scan'208";a="133265254"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 18:13:29 -0700
Message-ID: <28e513ec-4d8b-4967-a241-d6f63d533050@linux.intel.com>
Date: Mon, 28 Apr 2025 09:09:19 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/22] iommufd/viommu: Introduce IOMMUFD_OBJ_VCMDQ and
 its related struct
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com,
 corbet@lwn.net, will@kernel.org
Cc: bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
 thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
 shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
 peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
 praan@google.com, zhangzekun11@huawei.com, iommu@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev, mochs@nvidia.com,
 alok.a.tiwari@oracle.com, vasant.hegde@amd.com
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <8bab0069503fa21b48298ed2ffe29a06963f71f5.1745646960.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <8bab0069503fa21b48298ed2ffe29a06963f71f5.1745646960.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/26/25 13:58, Nicolin Chen wrote:
> Add a new IOMMUFD_OBJ_VCMDQ with an iommufd_vcmdq structure, representing
> a command queue type of physical HW passed to a user space VM. This vCMDQ
> object, is a subset of vIOMMU resources of a physical IOMMU's, such as:
>   - NVIDIA's virtual command queue
>   - AMD vIOMMU's command buffer
> 
> Inroduce a struct iommufd_vcmdq and its allocator iommufd_vcmdq_alloc().
> Also add a pair of viommu ops for iommufd to forward user space ioctls to
> IOMMU drivers.
> 
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

with a small nit below ...

> ---
>   include/linux/iommufd.h | 35 +++++++++++++++++++++++++++++++++++
>   1 file changed, 35 insertions(+)
> 
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index ef0d3c4765cf..e91381aaec5a 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -37,6 +37,7 @@ enum iommufd_object_type {
>   	IOMMUFD_OBJ_VIOMMU,
>   	IOMMUFD_OBJ_VDEVICE,
>   	IOMMUFD_OBJ_VEVENTQ,
> +	IOMMUFD_OBJ_VCMDQ,
>   #ifdef CONFIG_IOMMUFD_TEST
>   	IOMMUFD_OBJ_SELFTEST,
>   #endif
> @@ -112,6 +113,14 @@ struct iommufd_vdevice {
>   	u64 id; /* per-vIOMMU virtual ID */
>   };
>   
> +struct iommufd_vcmdq {
> +	struct iommufd_object obj;
> +	struct iommufd_ctx *ictx;
> +	struct iommufd_viommu *viommu;
> +	dma_addr_t addr;

It's better to add a comment to state that @addr is a guest physical
address. Or not?

> +	size_t length;
> +};

Thanks,
baolu
