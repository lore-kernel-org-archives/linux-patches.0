Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A059A8F48;
	Fri,  2 Aug 2024 00:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722558674; cv=none; b=qFw6g6ZfFQknltk95/aLyUcCnS3lIvWnlYR2KIYYCs/w1HoFR/RVF34uykVbXjRvSFMUNB8nm2wZnx4pLKJ9qXnX0Z8Sw55T3pkWzyPBKP0dym/jDfeaZeOsQnS4fCbcRDE9tkkokYTl2GFPVisOk0X9qDShCwPGJkaw+Tj//n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722558674; c=relaxed/simple;
	bh=09rU4cKV5xSZ6w5W11KW05/CAox2w3nPN/lle6wpPV4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lEGa3TduqZcxOj9iK71QESILvgT/3z4XAICKnNqlC9cC0NHzE9OuIrFtWutIMfegVl3ZZ7SND68gQ/r6X0z/tSl6tnUDZpkH+1r+BIe/Sb1MluWNxKCFkwED2msVKnJg0FfC+jT9clAc1ZQlyQxegC+VEDWczgOattfXPoRM8cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=likUKz32; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="likUKz32"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722558672; x=1754094672;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=09rU4cKV5xSZ6w5W11KW05/CAox2w3nPN/lle6wpPV4=;
  b=likUKz32XyQgmjKCo58xI5N6uPD0P5CgkrWcOEzqjG0S/0/z32tvgskT
   PQe51qN25NO4mepsrTa4/OqgSC079lQwbyzvceeWztuD5bf609oQ4IvIP
   4Mrvn5mwmtEldYWlQNrUxNje09oVGo16daR9urRG4hXNrcqEI8TQIMZEz
   p0Szmzi6yajxl0w70b4A6MBKvDmyc3TRxSLQ4BSxBFLQ2CpUbUuBQkXMl
   ajeAFBm3GKpAImv5CenfDG1yKnc0/EON3BlUBpTTk3BKljITi4cE1czOP
   /L0bcuNPJoZ2ceBIG9q8BXM+i+6L1u4jI8xmCxso6B+AB8lNIAyBCS1A0
   Q==;
X-CSE-ConnectionGUID: eTJkmuHrRcWA/0RVhDPdrA==
X-CSE-MsgGUID: U2vyuw9KTO2NbP6wUZSPBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11151"; a="20712805"
X-IronPort-AV: E=Sophos;i="6.09,256,1716274800"; 
   d="scan'208";a="20712805"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2024 17:31:02 -0700
X-CSE-ConnectionGUID: 0jFRttO2QE6KJnncKTyhWA==
X-CSE-MsgGUID: dic4eW+dTaGTyuCOmzqzBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,256,1716274800"; 
   d="scan'208";a="59552497"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.238.251]) ([10.124.238.251])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2024 17:31:00 -0700
Message-ID: <c31ca390-b29b-4795-a223-a985ef62dc44@linux.intel.com>
Date: Fri, 2 Aug 2024 08:30:57 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Barak Biber <bbiber@nvidia.com>,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu: Restore lost return in
 iommu_report_device_fault()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
References: <0-v1-e7153d9c8cee+1c6-iommu_fault_fix_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v1-e7153d9c8cee+1c6-iommu_fault_fix_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/8/1 20:26, Jason Gunthorpe wrote:
> From: Barak Biber<bbiber@nvidia.com>
> 
> When iommu_report_device_fault gets called with a partial fault it is
> supposed to collect the fault into the group and then return.
> 
> Instead the return was accidently deleted which results in trying to
> process the fault and an eventual crash.
> 
> Deleting the return was a typo, put it back.
> 
> Fixes: 3dfa64aecbaf ("iommu: Make iommu_report_device_fault() return void")
> Signed-off-by: Barak Biber<bbiber@nvidia.com>
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Thanks,
baolu
