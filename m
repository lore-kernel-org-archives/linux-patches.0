Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCA21E8355;
	Thu, 27 Feb 2025 05:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740633285; cv=none; b=SNi9gJCpyRZOOvJlGJkBrv8XgtOdtgkydJ80y8khMBUABtQzux7/nDx1fB3wTNnAQk+sPiRv0Q3PUrTuzXoGGD3/jy8AI5pz+Fq5P7IT9n0oCWsK56juu6Xyc7Lp8tlGPfORVsSDFPHQQz5lN2XLqZtPbmb2bB89YeAkVwqwbk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740633285; c=relaxed/simple;
	bh=I69LPokZTV/4dzSJyY6dG46WwI4tfyw0UdAXPNutbc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cdaIOwnE9o6mOm6q1tawnC/ZCnNWoY5AYyOkefzTdys4dBGSY62/efEkCKHk2olHr1MqXz0S2cePNoGqO8UzESdOxGB3sLjHl4q5DmOR/cX0JOtcunWxpEO4Rz9U3XaykRIzAFjkXLSi8qab77Kcw31fa8GVbzIYoMoenU2CbJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kk3j1WGK; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kk3j1WGK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740633283; x=1772169283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I69LPokZTV/4dzSJyY6dG46WwI4tfyw0UdAXPNutbc0=;
  b=Kk3j1WGK9tQy5eDESm7WszLjzf9ypvuz61nyAF+mEi2ly2f0yqW9KfLc
   O2m+gzPsj0WxEmFEkK8gp3QYXjlDv1DdSPi9L9brRmcFuQh5p2wY6WSez
   z4UTWQQ2TqlEdzAB4puvwXHnax+uocV9FWXIYaZSyHyCjk9G2SAfXrm6Q
   FrsDM6TH/Kdicf7TbQV/qr7XONwwzQBMCMKg2yhcQgyMt31bYUuKN+zjH
   van8bdgliSNLRMaz/KoQ5/7AebI9Xjyo2jNabFm4ab9QBKPtDQlRbuKc4
   0RzRmAJGD4/GKhh64VE+f1p7lBAal5gXoHVCiuAbwwV8Oh3bFdTSvEGo2
   w==;
X-CSE-ConnectionGUID: LbxGgatbQmaT1jvsCO5DTA==
X-CSE-MsgGUID: o27vkOd7Qau/ANDbrzL5lw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="45287689"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="45287689"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 21:14:42 -0800
X-CSE-ConnectionGUID: 0+XEwoVFSSChkZxOVV0yIg==
X-CSE-MsgGUID: V/fupo75Q3OaStVprAAz7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="122030732"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 21:14:35 -0800
Message-ID: <5775de69-9a1b-4b75-829e-60ec958a01bc@linux.intel.com>
Date: Thu, 27 Feb 2025 13:11:19 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/23] iommu/pages: Formalize the freelist API
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Albert Ou <aou@eecs.berkeley.edu>,
 asahi@lists.linux.dev, David Woodhouse <dwmw2@infradead.org>,
 Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
 Jernej Skrabec <jernej.skrabec@gmail.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
 linux-tegra@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
 Hector Martin <marcan@marcan.st>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Robin Murphy
 <robin.murphy@arm.com>, Samuel Holland <samuel@sholland.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Sven Peter <sven@svenpeter.dev>, Thierry Reding <thierry.reding@gmail.com>,
 Tomasz Jeznach <tjeznach@rivosinc.com>, Krishna Reddy <vdumpa@nvidia.com>,
 Chen-Yu Tsai <wens@csie.org>, Will Deacon <will@kernel.org>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Joerg Roedel <jroedel@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 David Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>
References: <9-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <6d9ceeb5-581e-48e8-a5cc-100a9699a9e8@linux.intel.com>
 <20250226173120.GA37280@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250226173120.GA37280@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/25 01:31, Jason Gunthorpe wrote:
> On Wed, Feb 26, 2025 at 02:56:29PM +0800, Baolu Lu wrote:
>> On 2/26/25 03:39, Jason Gunthorpe wrote:
>>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>>> index 38c65e92ecd091..e414951c0af83f 100644
>>> --- a/include/linux/iommu.h
>>> +++ b/include/linux/iommu.h
>>> @@ -326,6 +326,18 @@ typedef unsigned int ioasid_t;
>>>    /* Read but do not clear any dirty bits */
>>>    #define IOMMU_DIRTY_NO_CLEAR (1 << 0)
>>> +/*
>>> + * Pages allocated through iommu_alloc_pages_node() can be placed on this list
>>> + * using iommu_pages_list_add(). Note: ONLY pages from iommu_alloc_pages_node()
>>> + * can be used this way!
>>> + */
>>> +struct iommu_pages_list {
>>> +	struct list_head pages;
>>> +};
>>> +
>>> +#define IOMMU_PAGES_LIST_INIT(name) \
>>> +	((struct iommu_pages_list){ .pages = LIST_HEAD_INIT(name.pages) })
>>> +
>>>    #ifdef CONFIG_IOMMU_API
>> Any reason why the above cannot be placed in the iommu-pages.h header
>> file? My understanding is that iommu-pages is only for the iommu drivers
>> and should not be accessible for external subsystems.
> I wanted to do that, but the issue is the gather:
> 
> struct iommu_iotlb_gather {
> 	unsigned long		start;
> 	unsigned long		end;
> 	size_t			pgsize;
> 	struct iommu_pages_list	freelist;
> 
> The struct is inlined so it must be declared. I do not want to include
> iommu-pages.h in this header.
> 
> Once the struct itself is there it made sense to include the INIT too.
> 
> FWIW I have a longstanding desire to split iommu.h into
> internal-driver-facing and external-user-facing files..

Okay, thanks!
