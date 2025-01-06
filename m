Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CADAD2F;
	Mon,  6 Jan 2025 02:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736132020; cv=none; b=kr32wW0uVfumrvlm10J/6cwyHL0lBy9BumzPGSIT7x44el3W/RoL46CKcGm74bjB5Mn9q3zYWmqKBj7xaRe0GPhz31DEJc94g94d52o6ACXlwezMFj0pRnthr0OLP2P4gMXq3q1c58NvJ2WABj6WY1MJfDdy+JjjQkBY8LkZug8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736132020; c=relaxed/simple;
	bh=ob+FMX6fj9S7JNBy4TjIUMzy4NByQm6piaqnxNepR9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D7XGRTXSyBHW/y/PFcwt71VEcCkJL6OgB8Glec+qihjQK4GX9owQ65mTouDzGYn7R8ybUsp1cq5IF6LeUOp0iNOzpkBX7J3huu8E31/9m/OCtplVdY5IZBPH+uSgr2GAiJz/642YoKzXjYwWAvUnnAxT6+vtCm06fTSxmfWMXrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BK5JMp4Y; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BK5JMp4Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736132019; x=1767668019;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ob+FMX6fj9S7JNBy4TjIUMzy4NByQm6piaqnxNepR9g=;
  b=BK5JMp4YmbtWBRoNUd39YuWc/KUlL9ppQknxAAdrbcQtht/0JRRfTsYc
   kyysrRZBsBOyYLd5Zdxmu0P2sQ5DEAFk/iqWd8mRnrEqWLSZZKQbqhDfN
   /CprFLfr37yCAjGqIn/azL7bhq7w3XpwezkOzL1deIGDZH5eSnHzCLFLi
   ZtgLZIYo2/RAqWZodHP3N3y7zC7p8Av2ZDq1TV2bV2W604f51JtFZJl77
   mjah2alC1aAv0eggTYKU2jCwp8EddkqF0oWTxxXZKj1dIkY1GKRWG69fq
   ERbBQd5k8FJhog7dDClcxWyA6GxTDXj6PUgZHZrFpNg06FVCck9TlprzX
   A==;
X-CSE-ConnectionGUID: LM7lLDlvS3C1zYrQ5niJBQ==
X-CSE-MsgGUID: 6EgLuFQZQnmhGlb9XofpZg==
X-IronPort-AV: E=McAfee;i="6700,10204,11306"; a="40044048"
X-IronPort-AV: E=Sophos;i="6.12,292,1728975600"; 
   d="scan'208";a="40044048"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 18:53:38 -0800
X-CSE-ConnectionGUID: 7LLmMcadQ7OiwX+kEigIPQ==
X-CSE-MsgGUID: PIZuysybS4yL0VfWNamrvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,292,1728975600"; 
   d="scan'208";a="107172768"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 18:53:32 -0800
Message-ID: <d65e1a7f-8b3d-4d3b-bcd0-38ef02791ca7@linux.intel.com>
Date: Mon, 6 Jan 2025 10:51:27 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/14] iommufd/viommu: Add iommufd_viommu_report_event
 helper
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com,
 corbet@lwn.net, will@kernel.org
Cc: joro@8bytes.org, suravee.suthikulpanit@amd.com, robin.murphy@arm.com,
 dwmw2@infradead.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
 mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
 smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
 patches@lists.linux.dev
References: <cover.1735933254.git.nicolinc@nvidia.com>
 <cbf90c55a1b8fb7c9d0619d0c12362e699d2b642.1735933254.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <cbf90c55a1b8fb7c9d0619d0c12362e699d2b642.1735933254.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/25 03:43, Nicolin Chen wrote:
> Similar to iommu_report_device_fault, this allows IOMMU drivers to report
> vIOMMU events from threaded IRQ handlers to user space hypervisors.
> 
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
> ---
>   include/linux/iommufd.h        | 11 ++++++++++
>   drivers/iommu/iommufd/driver.c | 40 ++++++++++++++++++++++++++++++++++
>   2 files changed, 51 insertions(+)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
