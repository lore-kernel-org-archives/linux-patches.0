Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DC914A8E;
	Mon, 14 Jul 2025 05:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752469502; cv=none; b=ULLJSrSZIM20T6E0sjAHIVsFvP52VcmhyZg7ahtS6qxOX26/NlQqB/TAhWWTlajCiHbfLf5DAjK7w3GS2nbd9VKklSumrxHf007zTv3adwLVl4NA9cPi0jPI46U74PvYhm3BHsY5Mz6w9Z43QrMfeV3Vx8b/vKBudzKHLprHIjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752469502; c=relaxed/simple;
	bh=bBs0th1Lt9ao6wjmVxKc0IZG2cp7doHoM50mrOm2RyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I/qM9PZWiL145UTFvk5I5OfdN6SxzxP6we3K7lJngq7xy6HGWvhbXMFnCOG49kQyQY36h+bb6sobBGT1KrLbmeKEPrrohBlmjGt+JmUapKkxEqxH40E8ZJazJq/jB/iHOzRSDPz/xeQFwTeXe3V1goVm2aTuzn5AehKx6qabbjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AGvbZ1ud; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AGvbZ1ud"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752469501; x=1784005501;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bBs0th1Lt9ao6wjmVxKc0IZG2cp7doHoM50mrOm2RyY=;
  b=AGvbZ1udbi/5b/cSCmoJcTfaSOEZk5rBhNCWMWHwOrrcgtw7mOV2+n8V
   B+i85+1DN7yAylNA51UEVOm6EPrrKSqM6Y0aAeqOVs3O/gnq6jtifoVFi
   qiQliMCWt2xGt/8XYPO8+5rxdIKRTxduPyEA9UgHe4VHmbqzPAbTAO7NS
   TyFtGBqdmwQpnOJPWoM4/Snxhn/tk3BoPk7azzQuOsY4xgjZrbVf/LHPe
   19uk5NBkEFxT4ukSOopc6jxR7lmk+B7nnwWLyHUBbYSUeeCiFH7cs0ZJI
   56S5ND+o2z3etcgOojUmMtz3sjk/bCu3J23n8pZtlKs+rbH+muye/XUN7
   A==;
X-CSE-ConnectionGUID: nOdciKpNQyiRlJiRjTiYuQ==
X-CSE-MsgGUID: yJ33UuXAQNu26eMqWyyhLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54782225"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="54782225"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 22:05:00 -0700
X-CSE-ConnectionGUID: ODEWPCAgRNSmYgjj1LKrbQ==
X-CSE-MsgGUID: GwJR787cTWuZsYTZD2u3Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="187838527"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 22:04:57 -0700
Message-ID: <6af5e16d-5cd7-4c18-9f8a-78740f24cc20@linux.intel.com>
Date: Mon, 14 Jul 2025 13:03:10 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] Reorganize Intel VT-D to be ready for iommupt
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
 Wei Wang <wei.w.wang@intel.com>
References: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/30/25 23:03, Jason Gunthorpe wrote:
> This is similar to a series I sent for AMD.
> 
> Lightly reorganize some of the page table related code so there is greater
> isolation between the first and second stage logic. iommupt will introduce
> distinct types and code flows for first and second stages, having them all
> combined together is difficult.
> 
> Splitting actually makes things generally more understandable anyhow as
> they do share only a little code. Most of the registers and logic are in
> fact different. That was being obscured by small helper functions that
> combine the first and second stage information.
> 
> This would replace some of the patches recently sent by Wei.
> 
> The full branch including the iommpt conversion is here:
> 
>      https://github.com/jgunthorpe/linux/commits/iommu_pt_vtd
> 
> v3:
>   - Add intel_domain_is_fs/ss_paging() as wrappers around the ops check
>   - Set force_snooping for the ss as well

Queued for linux-next. Thank you, Jason.

--
baolu
