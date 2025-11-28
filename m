Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304EF1C861A;
	Fri, 28 Nov 2025 07:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764313684; cv=none; b=tJUrN2t9SjuGS88e+wJ/+8rTlfG0fP8AAdZGeUzXeKbFmH2mctneBSzjXrcOci3TCU8sqdxXLRlpinbET+cFWT6EEAFV37nbEx1z/csuwqvE39xsSR7payqd7mqwAzNJbMFZeaJf6Nsw7GBXhfTzsfGs35IKFIPACwwsyuLMceA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764313684; c=relaxed/simple;
	bh=T++g3m6cPjDTLLJerjU2fxFPb0a86ksGFOPVw8xZ8X4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGiCIDsnEy1XtoDN80v9mEyOiSrpDWJGSjPUqx21qngwnYvuQcWUwQ8fLpeq5syohQFSZf9ADKSF3KKJoXz2wI0ukd3WdAkbSElRq3uzZyFjIykwOxKEIVpFuz6SdfjODTZ54o2LfFu7EC5gGRXG4HxV6r/NySaUnZPED+zZM2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hO8mmT7N; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hO8mmT7N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764313682; x=1795849682;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T++g3m6cPjDTLLJerjU2fxFPb0a86ksGFOPVw8xZ8X4=;
  b=hO8mmT7N/oqANEd0JEqMYdvLf0nZqDcXPLvZdV6urQxiSPR65MxEc0ny
   +39FzTLixBP/OhnW5b+Qq/sWpPTU/dLE5hIiwgwTu7wMg1g/IkR/2K/rs
   6h7+q9CXhbhgVX71Yq3Zt4nlQ7Cfo/iYwrx/lxiCzLk6PASoaBn1TnC50
   lXiFsIRxREqyUIby3bjDUvhaNlpNfsnwZzygthjVjv0o6xKLlvLcEztjs
   2JpPdi8NuTS4dxG4DoXfqoT7GH4mbK42w+ZirpxCXkJwvVQ1PTk8HhZth
   LUGfa6pPCJ4sjpI+xEreC86ZDJspcy2UZV9Fn9n3mr+CQ/tnU2W6k7aVr
   g==;
X-CSE-ConnectionGUID: edB094FRRpaIJiRB9B4HyA==
X-CSE-MsgGUID: dmDVq5CjTI2VFXTnA6r2nA==
X-IronPort-AV: E=McAfee;i="6800,10657,11626"; a="66244270"
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="66244270"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 23:08:01 -0800
X-CSE-ConnectionGUID: X18cSd4xRdCZENDubEt2Aw==
X-CSE-MsgGUID: mxiQin66QQasQJgfm0lNkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="230676120"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 23:07:57 -0800
Message-ID: <d225d060-c9e5-4e65-a695-b565802dd76f@linux.intel.com>
Date: Fri, 28 Nov 2025 15:03:35 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] iommupt/vtd: Support mgaw's less than a 4 level walk
 for first stage
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Calvin Owens <calvin@wbinvd.org>,
 Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>
References: <2-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <2-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/25 07:54, Jason Gunthorpe wrote:
> If the IOVA is limited to less than 48 the page table will be constructed
> with a 3 level configuration which is unsupported by hardware.
> 
> Like the second stage the caller needs to pass in both the top_level an
> the vasz to specify a table that has more levels than required to hold the
> IOVA range.
> 
> Fixes: 6cbc09b7719e ("iommu/vt-d: Restore previousdomain::aperture_end calculation")
> Reported-by: Calvin Owens<calvin@wbinvd.org>
> Closes:https://lore.kernel.org/ 
> r/8f257d2651eb8a4358fcbd47b0145002e5f1d638.1764237717.git.calvin@wbinvd.org
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
