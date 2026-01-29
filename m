Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6B32C21F6;
	Thu, 29 Jan 2026 11:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769685722; cv=none; b=ObNCoYPay8eD1ldV4MIMYrWt82KiZFm9doYabf5NwVlRsgqYgu9CmfEJcZP4wAk/gCIxtdOFOqIWsMhaKz7lmcmfbduZjXv7EnS/ykIYcqz2ZRUuE9302FSQUPft6MMbZBMU+XF/SeJPOkateSifuhzMwHpDxwWrwcNvQBE60S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769685722; c=relaxed/simple;
	bh=lGCl60z37YqjJ8RMSq8NV/zX+bO4MMfbS6zsaNedjBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FozuajwIwZEoEmdrkCvxGSvrRkxM+qj5dysanltCqCPD+1qKcmRWZOPcvDgCKnAfxVFA1K1XYesmNXx5dN5JX7qOKgUS0oILb08di00sRwp6GuU8mH/LpWayBUGA9BMhqzIjc2VBHl6yLjv4AI3FDF/IH2srMKwdn4mgzK9uSiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DFB41516;
	Thu, 29 Jan 2026 03:21:52 -0800 (PST)
Received: from [10.57.51.104] (unknown [10.57.51.104])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D53883F73F;
	Thu, 29 Jan 2026 03:21:55 -0800 (PST)
Message-ID: <b1b220be-fd5e-4f83-8f5e-7d5282be39f9@arm.com>
Date: Thu, 29 Jan 2026 11:21:53 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
To: Jason Gunthorpe <jgg@nvidia.com>, Vincent Chen <vincent.chen@sifive.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, Tomasz Jeznach <tjeznach@rivosinc.com>,
 Will Deacon <will@kernel.org>, lihangjing@bytedance.com,
 Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev,
 xieyongji@bytedance.com
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <CABvJ_xiUK9BqUJS9-Sk1sS4vhVhyXN8P8NooZ0t_Zp7ycG0bAw@mail.gmail.com>
 <20260122153134.GO1134360@nvidia.com>
 <CABvJ_xgSbK3omxT7XGJ0N7oEva6dQAJwZxRhsBqi44BRNZ3G5Q@mail.gmail.com>
 <CABvJ_xhY_4ADOsVVbjhkBm8U1mKVOSwzKMfBw5mUsJe=kkUiLg@mail.gmail.com>
 <20260123135234.GW1134360@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20260123135234.GW1134360@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-01-23 1:52 pm, Jason Gunthorpe wrote:
> On Fri, Jan 23, 2026 at 08:29:01PM +0800, Vincent Chen wrote:
> 
>> With this codebase, the IOMMU group type is now correctly configured as
>> DMA:
>>
>>    # cat /sys/kernel/iommu_groups/0/type
>>    DMA
>>    # cat /sys/kernel/iommu_groups/1/type
>>    DMA
>>
>> I re-ran the iperf3 test in this environment, and the test passed
>> successfully.
> 
> OK great thanks alot!
> 
> I'm surprised it doesn't say DMA-FQ, someone from RISCV may want to
> investigate that, it is probably reducing performance..

The driver does not advertise IOMMU_CAP_DEFERRED_FLUSH, as the existing 
pagetable code has never implemented the conditional TLB maintenance 
optimisation that makes it meaningful. Mind you, I don't see any 
reference to iommu_iotlb_gather_queued() in generic_pt either, so I have 
no idea how that's trying to do it :/

Thanks,
Robin.
