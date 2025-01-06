Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D36223A0;
	Mon,  6 Jan 2025 02:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736131812; cv=none; b=beHLhIMGQLW9yMYUGUnI+QPqWnsMTOcC4RvNa6c/ozAWyyqTcLQX+Sl7IGGR3InQOGssecBeMmb2OnberCeCPLXKwDjlwajxL84e6ZOkbDHpMk/M6NjiK/ggRbECw56rUvh65fQFULAnk1Pc8mKudJ+1Vk7wc/o0NC+mnArhR7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736131812; c=relaxed/simple;
	bh=pxVIE5U9doYqO1gtr5NtmGoE9CiEo7WfZB90wEQeGPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tcAor3vIVPikmPRUi19ttqb/Z00i3zdzICnmQ3kJv10CXSPwUbPzR+uePQ+2PgZgTo6G/Jy67pljydQq6gr8ZzFTpjJjt7LccV73U/r1BLME4AkhbVijjaLCsCMGyKNQxc7OBgpueiMSIM4+qX3sD/rcAARprObG5yYo6AxioBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EcCB7Yq3; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EcCB7Yq3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736131810; x=1767667810;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pxVIE5U9doYqO1gtr5NtmGoE9CiEo7WfZB90wEQeGPk=;
  b=EcCB7Yq3wMw0QijJp67DiiksyppgftytIqcUWO3E2lJveesI6+PyLi07
   QbC4FUdbvXsrjndnUMtQR5Yx7ytNyspYxMINuv3NqwDvbvV1LLVz5eUBM
   wajcQ6T2rtk0g6s7ImM8BMrn3aJ/xtwERwDCA7TZTeNFNV0FHlhiZdHLQ
   HMxRRlCbqyn2JdNYmkB4hxMAoXyWFKWKREgRjz2fgwU7VSRWZnMBogLhz
   LV15FoMRmftPbG3o3kCQYofgYCvnhd04sgjA395Rmtht6HuYbpjr0hnIm
   CaHrzEuNqfIcR8mLkGvflS6dk5Bw5ZHqud9O4QWbETawKK68Va2ypCbPa
   w==;
X-CSE-ConnectionGUID: aYozoOP5StmfNDkMwxC61Q==
X-CSE-MsgGUID: DC/HFdKkTJeI3gZFBC99Kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11306"; a="53690603"
X-IronPort-AV: E=Sophos;i="6.12,292,1728975600"; 
   d="scan'208";a="53690603"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 18:50:10 -0800
X-CSE-ConnectionGUID: pJzxby5TQBapEJrT6rfaGw==
X-CSE-MsgGUID: oskUF8ejTMuiZEUNj5l2lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="125599941"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 18:49:50 -0800
Message-ID: <821ed0c7-20ef-4695-9da8-a8f206f4318b@linux.intel.com>
Date: Mon, 6 Jan 2025 10:47:44 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/14] iommufd: Keep IOCTL list in an alphabetical
 order
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
 <32abff935ee97fb0be3f675a2a61b535492e242c.1735933254.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <32abff935ee97fb0be3f675a2a61b535492e242c.1735933254.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/25 03:43, Nicolin Chen wrote:
> Move VDEVICE upward to keep the order. Also run clang-format for the same
> coding style at line wrappings. No functional change.
> 
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
> ---
>   drivers/iommu/iommufd/main.c | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
