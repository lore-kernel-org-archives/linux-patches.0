Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE1014A4CC;
	Mon, 28 Apr 2025 01:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745804182; cv=none; b=M/3jeLqdZyW/GOaJ//1iqTts6d+8Hy8XLRhbTb2EBsupsK1jpp7qxBjUEiQihtlAa2qEP2ucNBuVdZ1GCBj+Yc+y4tyf6HYKD14jLjfOtwcxAigff4Yo5hydG04A4mPEagc8Y0GktcxsadIO3S4/68sDeB7h4GbCRPSJ/r514z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745804182; c=relaxed/simple;
	bh=ka5i6kOXSNGQcxxbduG/8nuC65hLt6QpSbzaVuD2Wr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dOBC0RUB430htxkjZfse/MAfQojY+/G7NOiZ09Ab8zn6RjU99fvgq/P6Qrf6QQ6b4U/e5YZYEA2cw0bhziGY7wxUXQJeCtBiXbYza/rR9FH7o/Nn1NV7QZO2x31l6HaT+P2tnnh7cNOwk/wO+lpr7J1zjhkoUwQD7+z1N6v/vPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DPD/52HT; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DPD/52HT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745804181; x=1777340181;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ka5i6kOXSNGQcxxbduG/8nuC65hLt6QpSbzaVuD2Wr0=;
  b=DPD/52HTQWP9OQqbs4KM5RWahgdbh2LimAJYAnv8nd99TWXHnUgntko1
   XmXmleTxcF3mHzuAwPNPDRRP0d1nUDbKOzu5h6qn2jFQEXo6uNDo2V+AO
   ccOwnQXY5YJOPpDUax3WlQKWpknfas3bB2qQ7b4OMWIAiFXpa2hmdADjB
   v+NOgFcsvHasK4bHfcfX3LIYLk1xzvaM07qyYyOftK5+czrM3MqiAl4kh
   Pg9l1R8Hm6Jmq0hKqkC0hmk2vUj0j3t2/HBNBOH3OZ5+dtHJgs4Ey05qB
   PuCEhPkMtxzj1sh/lhdQilO3h5lpzfbtJWbVIDSyXfW58bgHONFi0Q2sy
   w==;
X-CSE-ConnectionGUID: ZHH1aaAVQwSagMRMCJTFEw==
X-CSE-MsgGUID: azSo5CjBT5u+R3AaGEAeEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11416"; a="47511591"
X-IronPort-AV: E=Sophos;i="6.15,245,1739865600"; 
   d="scan'208";a="47511591"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 18:36:20 -0700
X-CSE-ConnectionGUID: ks4dRZHRQR2z+gA9bUZEsQ==
X-CSE-MsgGUID: 3TSRWkChRnOLfY4dm9t51g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,245,1739865600"; 
   d="scan'208";a="137427362"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 18:36:14 -0700
Message-ID: <dcfd9bfc-44db-4fd8-a49c-0c96c68f6b88@linux.intel.com>
Date: Mon, 28 Apr 2025 09:32:04 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/22] iommufd/viommmu: Add IOMMUFD_CMD_VCMDQ_ALLOC
 ioctl
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
 <094992b874190ffdcf6012104b419c8649b5e4b4.1745646960.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <094992b874190ffdcf6012104b419c8649b5e4b4.1745646960.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/26/25 13:58, Nicolin Chen wrote:
> diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
> index a65153458a26..02a111710ffe 100644
> --- a/drivers/iommu/iommufd/viommu.c
> +++ b/drivers/iommu/iommufd/viommu.c
> @@ -170,3 +170,97 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
>   	iommufd_put_object(ucmd->ictx, &viommu->obj);
>   	return rc;
>   }
> +
> +void iommufd_vcmdq_destroy(struct iommufd_object *obj)
> +{
> +	struct iommufd_vcmdq *vcmdq =
> +		container_of(obj, struct iommufd_vcmdq, obj);
> +	struct iommufd_viommu *viommu = vcmdq->viommu;
> +
> +	if (viommu->ops->vcmdq_destroy)
> +		viommu->ops->vcmdq_destroy(vcmdq);
> +	iopt_unpin_pages(&viommu->hwpt->ioas->iopt, vcmdq->addr, vcmdq->length);
> +	refcount_dec(&viommu->obj.users);
> +}
> +
> +int iommufd_vcmdq_alloc_ioctl(struct iommufd_ucmd *ucmd)
> +{
> +	struct iommu_vcmdq_alloc *cmd = ucmd->cmd;
> +	struct iommufd_viommu *viommu;
> +	struct iommufd_vcmdq *vcmdq;
> +	struct page **pages;
> +	int max_npages, i;
> +	dma_addr_t end;
> +	int rc;
> +
> +	if (cmd->flags || cmd->type == IOMMU_VCMDQ_TYPE_DEFAULT)

I don't follow the check of 'cmd->type == IOMMU_VCMDQ_TYPE_DEFAULT'
here. My understanding is that it states that "other values of type are
not supported". If so, shouldn't it be,

	if (cmd->flags || cmd->type != IOMMU_VCMDQ_TYPE_DEFAULT)

?

> +		return -EOPNOTSUPP;
> +	if (!cmd->addr || !cmd->length)
> +		return -EINVAL;
> +	if (check_add_overflow(cmd->addr, cmd->length - 1, &end))
> +		return -EOVERFLOW;

Thanks,
baolu
