Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4E228E59E;
	Mon, 16 Jun 2025 03:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044335; cv=none; b=aKzVWJa+19lpx3ifSTYZn1cenL251DlHfA1VfbUT8uLyN1dvuQjfOFI3Gc3NwRV1STcZW196CViVgkmK3MboLSG8/vky8AiMoizS+OahWcmJRpUt9ys0xs7fEjVdypv1CtujY1nHnWKB/AgjuYcWovXCy3krvFylvLFSG+f7TL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044335; c=relaxed/simple;
	bh=jZ0hXk7/0POkfoovE7h6rCUu2FvCYd02o4Psw04apZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQ6Fzg26QCmrPK8Fz9Tjor6tt46U0oYh5oahSBjByritczcMEPc5JFTKE0SEKhDgguDCdzCSw4RwMU36px48yjpfc/nEQCbQf3ugZ+7toPp8iWNqpHPDdRaoQ+Ayy4qZtVIlZ2oMPdMJaJFJ6ldDFaWIdK6JDqQij2xV6T5wxd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TSVRnbLc; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TSVRnbLc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750044334; x=1781580334;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jZ0hXk7/0POkfoovE7h6rCUu2FvCYd02o4Psw04apZ4=;
  b=TSVRnbLcNinmg0ot++Ccgvga2Mw6W92I7k94wELVD4l9fMz6pefTtWAH
   x8nxhDTAh0EMDJn3+as2Glltwuw71kh1Lclbyq0rLHtTtygZCuJrftIUD
   UYOsWPYxhJpigQFMhtOC3qtWH0ETHYxogUDRrvD2mNhel47edeIZuLWu3
   34VkxlR2AHe2Cex0naLIWIJGf1KAT+qcF3M3eyF9V28VJN352gCRsaV0r
   jOCO1jmXk3hwZ8v1qd850PfmfFE7pyz7x5NfP6I/tgtid0SQJ8fDEoFrS
   7W+KxvJD5JR3g1lT5bKAvuF/p0oeDUkwQKLD1mObtmaSXyKgllJuExMGz
   w==;
X-CSE-ConnectionGUID: QNqY+cfZRk68rKBc8M9o5g==
X-CSE-MsgGUID: +G4kF2RLSJSbztEg0ElGRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="62449437"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="62449437"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:25:33 -0700
X-CSE-ConnectionGUID: uGKXemABSzCHxhRvxLMldQ==
X-CSE-MsgGUID: 2VqEThBvQeukd4nM1Yqg7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148205608"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:25:30 -0700
Message-ID: <6e7aa7c7-942a-4600-8496-7b5d1bd259c3@linux.intel.com>
Date: Mon, 16 Jun 2025 11:24:31 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/14] iommufd: Use enum iommu_viommu_type for type in
 struct iommufd_viommu
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, praan@google.com,
 yi.l.liu@intel.com, peterz@infradead.org, jsnitsel@redhat.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <6c6ba5c0cd381594f17ae74355872d78d7a022c0.1749882255.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <6c6ba5c0cd381594f17ae74355872d78d7a022c0.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 14:35, Nicolin Chen wrote:
> Replace unsigned init, to make it clear. No functional changes.
> 
> The viommu_alloc iommu op will be deprecated, so don't change that.
> 
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
