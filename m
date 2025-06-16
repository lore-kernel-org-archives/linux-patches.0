Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D4E2AD00;
	Mon, 16 Jun 2025 03:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044285; cv=none; b=R6pY71L7Z1xBxq5v0nIxYLGiBcSZ6AmpTBD8Tob5dBOMmqkcnW6huWG1uVMO2eriydNN2LLKp+ARg3oRGtOhBZcIVg569YUj3oQpc7HBwqSL/zOM/2LbUR81cZlS2eVmyTziJnurVTiCHFvWcWeyTxucYY20gemNOE5Rz0BviOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044285; c=relaxed/simple;
	bh=nQlTpBtnZoIiH+wLV1PriCQvFOj3vAZit6p9w/vLTNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hxeKavcPk3peVwZLSmquvPZPt5zZj2vH3bZf4FNumO9cz3ZGCWIuUQcvDNymm9zgqnbKZl1H2myEUnkcf0mF1ncPQagdx8W41iQ+uXez0vgoMePaGOf2qnMoBFo5qhGTu7O0ZidbQKeCAxBoj1oGguhqYw2hfhMp9p6xxcPUVJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cC2GupS9; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cC2GupS9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750044283; x=1781580283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nQlTpBtnZoIiH+wLV1PriCQvFOj3vAZit6p9w/vLTNA=;
  b=cC2GupS9IgU/dp1/ZgSpdSFWhOmUazNERDKUskxF+WINUJCd1vECLMdA
   8Cd2oTAta0nOdZE61+qxXrp1qEjfIhJ7CRL1iXwkzuHKQKp7J0Xo0D+Lq
   ZRKgvdlyD0y3Pi0pEFi+VqQyfwVI53lbfGoVFwbpgA//NLbnrAQv8XpmU
   LRrg85ryXbvSnr4I4WHFL7xJ+pp54GYj+n3mZzDxylnkpx3KLMPELLW8I
   cSG4go3RJ+bGO5ccPl6tjrrlyJGzEyxtuuNm5J0gtXs85TVsRflBYTaNl
   UIbDOZRcIYv9K9pWKjmJZxWHZt7EKA4hw3AuDIpXj785n+clxVe7Q2mjM
   w==;
X-CSE-ConnectionGUID: 3C3BsdA7T3qtjm8xGCOS2Q==
X-CSE-MsgGUID: ePSde7pvR1OtuzISskx/DA==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="62449365"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="62449365"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:24:43 -0700
X-CSE-ConnectionGUID: 4+NUI3u4SVK7JFAdYkwgtg==
X-CSE-MsgGUID: VvrxDRXxSZGE38Fhwmm2VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148205460"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:24:40 -0700
Message-ID: <1cd66b51-5d73-4d28-8b63-8df5a5bf7ee8@linux.intel.com>
Date: Mon, 16 Jun 2025 11:23:40 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/14] iommufd: Apply obvious cosmetic fixes
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, praan@google.com,
 yi.l.liu@intel.com, peterz@infradead.org, jsnitsel@redhat.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <9132e1ab45690ab1959c66bbb51ac5536a635388.1749882255.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <9132e1ab45690ab1959c66bbb51ac5536a635388.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 14:35, Nicolin Chen wrote:
> Run clang-format but exclude those not so obvious ones, which leaves us:
>   - Align indentations
>   - Add missing spaces
>   - Remove unnecessary spaces
>   - Remove unnecessary line wrappings
> 
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
