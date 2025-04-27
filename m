Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9422046B3;
	Sun, 27 Apr 2025 06:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745737198; cv=none; b=WyqB3YJH73Td+w9fopi+tjZouL46N9JWNbGMxgSO/CzyelMl6TJSUz8Av6d5JkfwGaFxBTFD0XCqnU9k+qDZhBlq+VLhfPVfzjsyJVvLV22mJphKR7p8hniv7KxQ/7qGpuyp2dlBspHerxDD1xczSYA3GjEb23J4VoP7qrX7IBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745737198; c=relaxed/simple;
	bh=WPVNiPXysA+ZKbcBuVxOUqy7B0r28vdmFSIesJvE8b0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aKiL81tGTni/IFLvb+BweyOrQxjHmMQLgW2V0dmYxZgixWiek6AWWhiebdwJQSTkJo6rRGAk+r0jvu1L+MR0Nn+fAuabWD+L7PTZj09HanXEHY/9gt9zQ7Jgb9FTiquTO/7edcQcELu9lBbmDei6Xi9Jlz0D94GJpOB3EznAPQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fgtGjf8x; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fgtGjf8x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745737196; x=1777273196;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WPVNiPXysA+ZKbcBuVxOUqy7B0r28vdmFSIesJvE8b0=;
  b=fgtGjf8xMz2QWfSSmDEAOu4xWCQp55BFu93xN9eySVZOiLMshQVsCep9
   3yWREmQd/JNwjiJAYBWaam6s/bEqBY4VWSmXnRuj5uVKuIF8lK441AECU
   zJCTx5k52jy3bN6RAR0DXnxxihbCTQRlYPKUDM8yp3EiCNhnOmmZxuduL
   tyPXa+CFSQOXzNb1ZifTxBDt6euDA5mOH3wl96d9Xt3XkAeCOBb8YO5s5
   Bo9Y/p9fQqyuBiZ5wZ8a4jQcdRBLC7ghLIqrfmTXlCAHUtFDIqbLnygBZ
   Hf2Kzk2VhQAsTcpL9KpxPeUsIF/onl06HyMRUWUlXhKH8AzngUsvYigc1
   w==;
X-CSE-ConnectionGUID: 4KxIK6wdTu6O8oy5wJFY9Q==
X-CSE-MsgGUID: 15IpvS1eSDqbJCK6pShs8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="47230525"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="47230525"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 23:59:56 -0700
X-CSE-ConnectionGUID: d1ZTnjH0RQyh27Uc3LKjrw==
X-CSE-MsgGUID: v/r5yexURzibspAZ8Nkryw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="138394240"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 23:59:49 -0700
Message-ID: <9737606f-d3af-4c20-b1ce-7c705a7c8590@linux.intel.com>
Date: Sun, 27 Apr 2025 14:55:40 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/22] iommufd: Add iommufd_struct_destroy to revert
 iommufd_viommu_alloc
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
 <3d8c60fe9f1cdaecd59ce3e395eb6ca029ca8ded.1745646960.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <3d8c60fe9f1cdaecd59ce3e395eb6ca029ca8ded.1745646960.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/26/25 13:58, Nicolin Chen wrote:
> An IOMMU driver that allocated a vIOMMU may want to revert the allocation,
> if it encounters an internal error after the allocation. So, there needs a
> destroy helper for drivers to use.

A brief explanation or a small code snippet illustrating a typical
allocation and potential abort scenario would be helpful.

> Move iommufd_object_abort() to the driver.c file and the public header, to
> introduce common iommufd_struct_destroy() helper that will abort all kinds
> of driver structures, not confined to iommufd_viommu but also the new ones
> being added in the future.
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Thanks,
baolu
