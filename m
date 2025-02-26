Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD467DA73;
	Wed, 26 Feb 2025 05:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740548731; cv=none; b=QdWvhafItBKj0CKBbBl9rikWLF9xtCUNvqWJfbLLrenq1pGPY7zdJLulwluxToW6dGf4HkgQkDrfUa02s9BXXZnrsc8SwNY0/Po7h2n//ke4qGYZUgm0qJQcXmyWyhS2zBAaTATBHSLeiBUjxvxz2d/Q0q03Oaz8SoVlAa1YQO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740548731; c=relaxed/simple;
	bh=++6djOQAEe1B+vd/9KrPcvRzuDgVELNpD0pj9UUy6NY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=swduVat44oSNDXF3X4vwLw7PfVcWsOfKTCNDicLT9HjVTQoKak3qseK3uplc7S8Xysja3R73sBBhuObiOPDv9SMrk5vqHo64oRkOU8sx/GOwyLU7BUqsiktbzuX1KRTsL5R1YyC6BwLLCjkzGFHxebIwAGsUshvWZmfnOHTQs4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SOEz30dZ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SOEz30dZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740548729; x=1772084729;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=++6djOQAEe1B+vd/9KrPcvRzuDgVELNpD0pj9UUy6NY=;
  b=SOEz30dZmSH0lVNFdYhBOtwwcX5vo8SUBxDjv2j4C8q8rObEpslxfb0r
   XJORzeG6bRglL3t4A5NhqhGeThsykHXUlQHANKTCLx9UPsOl65MxF393I
   5rwPIyBmN6jYoE3BddkwxYMAmLA1LnEOllq2mv9l5qsrvPz8pZTltqYoN
   URDOGW3UbHETbec3RyGEJyncvvX5Rm1JN9c6oKjSGk+3quO9nAA1uaiL+
   SAE+4yG/0yPjCHghoyCZFUYIxTEUgIL4GRlxSJqj8CnSxy1vfbTLnadNV
   Vb9WNfsf0hO/7qtQ+cQnD8flHsUYPpzrYeM695U7xiteem+3QhswsBcwC
   A==;
X-CSE-ConnectionGUID: 1F4hFr+iT0yXFyTGCxHlTA==
X-CSE-MsgGUID: 6fjZdDH3SFqf6roElsmlKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="45295779"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="45295779"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 21:45:28 -0800
X-CSE-ConnectionGUID: 8Y9jzLmYR7alrBOq2PtsJQ==
X-CSE-MsgGUID: ZeGz/YAkQ9CzhM7IwOb3uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="147428792"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 21:45:22 -0800
Message-ID: <e6922f47-a804-491f-a3c1-1fd93b7b4edd@linux.intel.com>
Date: Wed, 26 Feb 2025 13:42:07 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 01/14] iommufd/fault: Move two fault functions out of
 the header
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com,
 corbet@lwn.net, will@kernel.org
Cc: joro@8bytes.org, suravee.suthikulpanit@amd.com, robin.murphy@arm.com,
 dwmw2@infradead.org, linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, eric.auger@redhat.com, jean-philippe@linaro.org,
 mdf@kernel.org, mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
 smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
 praan@google.com, patches@lists.linux.dev
References: <cover.1740504232.git.nicolinc@nvidia.com>
 <14a01d676b06dc7c013edba6961a4c1e9503a4e1.1740504232.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <14a01d676b06dc7c013edba6961a4c1e9503a4e1.1740504232.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 01:25, Nicolin Chen wrote:
> There is no need to keep them in the header. The vEVENTQ version of these
> two functions will turn out to be a different implementation and will not
> share with this fault version. Thus, move them out of the header.
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
