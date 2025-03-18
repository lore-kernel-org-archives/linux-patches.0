Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911B2207667;
	Tue, 18 Mar 2025 10:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742295477; cv=none; b=YEu1wp3ht2FF54zRURLyas/w6pkanKZnST/D51RZ9GbI8aN99Aj8lpBrdLzrbQUX0l9NO9VaiiHS+cTQ7WosqyYJ7d4koIR7pAZ8BkrdFQZ6319qdXvOW8Rkn3k0I2CsjIWH08VIcoPG1wRJAp3p+1iwHwbSoAxhKdKPrYPSTjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742295477; c=relaxed/simple;
	bh=ZWxPY0B7EGIVdFzO8GxKTzEp2DolBgnuCP4upl6RN8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TUusz/jKN/9Ky0R53EVv8xba6JAbRisHvnZLk2K+6wlK7xGnCOkGcgxskklDLEjAf0InBDCHC7KRZWtkHemlZVIfguW3YudGYN3CtEWfMrJYlnTT9lKJ17LBRBjBMjQ/pz5ROAkk0sewg2yX+WuLN3p8mMU7cHxc8fGR3MY/9mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4ADA713D5;
	Tue, 18 Mar 2025 03:58:03 -0700 (PDT)
Received: from [10.57.40.187] (unknown [10.57.40.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC01D3F63F;
	Tue, 18 Mar 2025 03:57:48 -0700 (PDT)
Message-ID: <b956d9d0-d169-4deb-9b7e-cbec95363214@arm.com>
Date: Tue, 18 Mar 2025 10:57:47 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/23] iommu: Update various drivers to pass in lg2sz
 instead of order to iommu pages
To: Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Albert Ou <aou@eecs.berkeley.edu>,
 asahi@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 David Woodhouse <dwmw2@infradead.org>, Heiko Stuebner <heiko@sntech.de>,
 iommu@lists.linux.dev, Jernej Skrabec <jernej.skrabec@gmail.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
 linux-tegra@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
 Hector Martin <marcan@marcan.st>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Samuel Holland <samuel@sholland.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Sven Peter <sven@svenpeter.dev>, Thierry Reding <thierry.reding@gmail.com>,
 Tomasz Jeznach <tjeznach@rivosinc.com>, Krishna Reddy <vdumpa@nvidia.com>,
 Chen-Yu Tsai <wens@csie.org>, Will Deacon <will@kernel.org>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Joerg Roedel <jroedel@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 David Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>
References: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <20-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <Z9GFFBvUFg7a9WEg@google.com> <20250317133500.GC9311@nvidia.com>
 <Z9lO-viudk9YGakl@google.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <Z9lO-viudk9YGakl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-03-18 10:46 am, Mostafa Saleh wrote:
> On Mon, Mar 17, 2025 at 10:35:00AM -0300, Jason Gunthorpe wrote:
>> On Wed, Mar 12, 2025 at 12:59:00PM +0000, Mostafa Saleh wrote:
>>>> --- a/drivers/iommu/io-pgtable-arm.c
>>>> +++ b/drivers/iommu/io-pgtable-arm.c
>>>> @@ -263,14 +263,13 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
>>>>   				    void *cookie)
>>>>   {
>>>>   	struct device *dev = cfg->iommu_dev;
>>>> -	int order = get_order(size);
>>>>   	dma_addr_t dma;
>>>>   	void *pages;
>>>>   
>>>>   	if (cfg->alloc)
>>>>   		pages = cfg->alloc(cookie, size, gfp);
>>>>   	else
>>>> -		pages = iommu_alloc_pages_node(dev_to_node(dev), gfp, order);
>>>> +		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp, size);
>>>
>>> Although, the current implementation of iommu_alloc_pages_node_sz() would round
>>> the size to order, but this is not correct according to the API definition
>>> "The returned allocation is round_up_pow_two(size) big, and is physically aligned
>>> to its size."
>>
>> Yes.. The current implementation is limited to full PAGE_SIZE only,
>> the documentation imagines a future where it is not. Drivers should
>> ideally not assume the PAGE_SIZE limit during this conversion.
>>
>>> I'd say we can align the size or use min with 64 bytes before calling the
>>> function would be enough (or change the API to state that allocations
>>> are rounded to order)
>>
>> OK, like this:
>>
>> 	if (cfg->alloc) {
>> 		pages = cfg->alloc(cookie, size, gfp);
>> 	} else {
>> 		/*
>> 		 * For very small starting-level translation tables the HW
>> 		 * requires a minimum alignment of at least 64 to cover all
>> 		 * cases.
>> 		 */
>> 		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp,
>> 						  max(size, 64));
>> 	}
> 
> Yes, that looks good.

Although for completeness it really wants to cover both paths, so an 
unconditional "size = max(size, 64);" further up would be even better.

Thanks,
Robin.
