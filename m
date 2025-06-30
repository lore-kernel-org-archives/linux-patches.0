Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38EE6BFC0;
	Mon, 30 Jun 2025 06:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751263957; cv=none; b=dmmhLQe7ctVFZ1CTHqJlrnYuaKlIz4ccVU/DqZKKtTvb/NU4KhvOEK16CVlYRdsuKOo/BJslXsapbh0eX45PaPWSihgP2awsklR8hxBXhVE/CuJ+Me32gEB/usruS0FsyZs/DBkZmbIZo6M5xttfX5E+UPGdrgpolG9DXi30LkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751263957; c=relaxed/simple;
	bh=McN2deu/0pGB55PloWO5vfr7rpgpFCsXgzpOPVUQSic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P6puq3TNvr/YHW7XJ2KX6NjrdW57ETF52w4DPJi3MUdw1vW2uOkzsAF58ANevIG9hdvnr8mLwSGQvNkrZxKIpeJs8NIhWdHZaFZv3hWiuwj741eOOqLO7FMlUPtMle3529PCZ7NXh+nWA6QdcN7M0+YRSp3rwy3UHuMNDsCApYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XYwp9Z+c; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XYwp9Z+c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751263956; x=1782799956;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=McN2deu/0pGB55PloWO5vfr7rpgpFCsXgzpOPVUQSic=;
  b=XYwp9Z+cfUHi6NZz4hVFuxCXIMDOF/YQttsK0fUm+g9OXv+Prbg1LXKP
   jqO2ZQTlpHrJt6ZZXnCMtSpmHbnfmnXjXhD4/2ZbzbG1LBBNt7/oETFPK
   JbLKdJRPBHO1DkWC7bGsja/PyG9BmtoM3zDPhvab2xne5b+QzNt7Q3Su1
   UL3bAhp4AJ9KJMTW6Ik4P4H7Z4lRPsb24LqvDtROmwGcWvsgjojOrWCkG
   HSgH0gVBxV7DKn4qunhS6ijCw8toUDT80Re2MHQHHxImg98DDmHVPkq58
   tTnK2EMyWrQM3f/TSj0ISmK31UUW18LvqfrZKiSLtDXCdXGmFLSs05PG5
   g==;
X-CSE-ConnectionGUID: Qhi6W2pTSNK8Cv/ghOXUxg==
X-CSE-MsgGUID: Q6jssHTUT/6lb1dqN5ZtfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11479"; a="70911810"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="70911810"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2025 23:12:35 -0700
X-CSE-ConnectionGUID: oRo7BY5pRD2ivAJyrq3SBg==
X-CSE-MsgGUID: pDCvSic+QquWyYCEOFjRiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="153546707"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2025 23:12:33 -0700
Message-ID: <46253700-8b98-47e1-bde5-1bd2fd9f528b@linux.intel.com>
Date: Mon, 30 Jun 2025 14:11:09 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] iommu/vt-d: Split
 intel_iommu_enforce_cache_coherency()
To: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Wang, Wei W" <wei.w.wang@intel.com>
References: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <6-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <BN9PR11MB52763C1B4AED06073FAF79EE8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250613131253.GA1163305@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250613131253.GA1163305@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/25 21:12, Jason Gunthorpe wrote:
> On Fri, Jun 13, 2025 at 09:56:44AM +0000, Tian, Kevin wrote:
>> pasid_pte_config_nestd():
>> 	if (s2_domain->force_snooping)
>> 		pasid_set_pgsnp(pte);	
>>
>> we either need set it for second level or also check set_pte_snp
>> here.
> Okay, I'm deleting set_pte_snp, so lets set force_snooping

Hi Jason, do you have a new version of this series? I'm planning to
queue this for the next merge cycle.

Thanks,
baolu
