Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFD11A840A;
	Mon, 16 Jun 2025 11:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750073698; cv=none; b=sPzho459OuNNujbvnyqjklXE9OHf+kAeMakX2lxx53yBy0PEpRYkHW4uplFGDZ7+c4JmDuSq6tpzrabSwzIx8eS4LjDpMaSuZ1AYessn1wIkp0ZseBMjkCU1OJfO+6c267yKj9H9EPBXY6CyHZALaKKc/PrNNeL0GKj6b7Uksg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750073698; c=relaxed/simple;
	bh=ojHEuztj0i3yHmHmm9T4QjxP+NTevWKTFSWpUEeibRQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nwmW/GrmcCjxEpzI4O+ar/wfn2iJYYPuWytLvuN6bZtnx1W4T6iYYvZj3SSrm6Z91rpWBWcCyt7jbX1E9Zdq04mAYZiE8BEe/WZCsfzXWn4NsE7zvEzi7+gJUbpXpnfIQkaK6kl23R9Grbsy26OcI6q6smOriNCrF4MfOrmJynY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wo/2qXbm; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wo/2qXbm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750073698; x=1781609698;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ojHEuztj0i3yHmHmm9T4QjxP+NTevWKTFSWpUEeibRQ=;
  b=Wo/2qXbmML3fgsfk040axuB9230CKOuiWmZu/B7DhtzI1b9isKL5R78N
   Fk/LS+JTuTU5AlSS7plyhvBvs+y+A4hFEspov9LSH02QVqT2Neei0MtW8
   IQWk1IJRhbDRLxkELnY8+Ol98GneT2wEMdBcojGuC883p+Pgd0HApUX/X
   bZXw4k2uG3EfjU3q6+pcSlnXkpBO9pF0wJQx9cMIht6j9h+bJyA8RFdX+
   +mb9LmvcD8ornvxTKol4qT5RZKe0ad1BjZENan5b3lhIFl82flwqk5z4M
   2Dn+7S5HSoGrj6WNLOT3CY1kwzhjx6gd9Txw3lcbjqBdGxYO++TMShw1w
   Q==;
X-CSE-ConnectionGUID: SZ4oNYp4ShaUTQbAS/CkNQ==
X-CSE-MsgGUID: dlILrE5fS9+jzVkUXhf8Rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="69657846"
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="69657846"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 04:34:57 -0700
X-CSE-ConnectionGUID: gaIal/9STnGso6QkRJ98mQ==
X-CSE-MsgGUID: u+WnkkfGQnmQxYoDn68uJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="152282524"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.243.252]) ([10.124.243.252])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 04:34:50 -0700
Message-ID: <68fda26e-f6d8-4be3-a411-a0cea13115b9@linux.intel.com>
Date: Mon, 16 Jun 2025 19:34:47 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, bagasdotme@gmail.com, robin.murphy@arm.com,
 joro@8bytes.org, thierry.reding@gmail.com, vdumpa@nvidia.com,
 jonathanh@nvidia.com, shuah@kernel.org, jsnitsel@redhat.com,
 nathan@kernel.org, peterz@infradead.org, yi.l.liu@intel.com,
 mshavit@google.com, praan@google.com, zhangzekun11@huawei.com,
 iommu@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-tegra@vger.kernel.org, linux-kselftest@vger.kernel.org,
 patches@lists.linux.dev, mochs@nvidia.com, alok.a.tiwari@oracle.com,
 vasant.hegde@amd.com, dwmw2@infradead.org
Subject: Re: [PATCH v6 15/25] Documentation: userspace-api: iommufd: Update HW
 QUEUE
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com,
 corbet@lwn.net, will@kernel.org
References: <cover.1749884998.git.nicolinc@nvidia.com>
 <e6931ee1643d717f13bdc30e7dfd9eeb9fd0fafa.1749884998.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <e6931ee1643d717f13bdc30e7dfd9eeb9fd0fafa.1749884998.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/2025 3:14 PM, Nicolin Chen wrote:
> With the introduction of the new object and its infrastructure, update the
> doc to reflect that.
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
