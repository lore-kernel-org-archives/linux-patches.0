Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8A920F08F;
	Wed, 12 Feb 2025 14:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739369821; cv=none; b=Qnl/EILpmd2faWVpZiZ2flGEhs8TakjRRyIe3qsrg2sNwie+NmIjIwUCSwwul5aJyfLfciSbKW9WCJVFTxao08akrlJl/gzug5E+PS0RQPR7MCNOumzEN4sXAFbn2SoVk8DF3yUY0W04QQFhdSmirdWS7bS1OQieqJHrYCU4j4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739369821; c=relaxed/simple;
	bh=nJIt1x77AQg4AAepbl9YgW1/uaqkSdDOIWHzOh9PTgw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qEZfZn5D1cQPt6kGP0/gDLoJSMfGf1efNF+batsmoeBc4qCx4+gkuimQ4/YHrewOXofsXzb+aQKOGIDuhUwbvAI0/4HSI7u9xuU+ULm5PBolpR3GAE0VUTv0N/LW0vyVrS0lpqOobQMErfR892joyYYk5AiGljci/wllg6eCfPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69BA912FC;
	Wed, 12 Feb 2025 06:17:19 -0800 (PST)
Received: from [10.57.36.235] (unknown [10.57.36.235])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 957DB3F6A8;
	Wed, 12 Feb 2025 06:16:56 -0800 (PST)
Message-ID: <021d006e-1fe3-4f58-8e79-b5e316de347f@arm.com>
Date: Wed, 12 Feb 2025 14:16:54 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] iommu: Add domain_alloc_identity()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, virtualization@lists.linux.dev,
 Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
 patches@lists.linux.dev, Alyssa Rosenzweig <alyssa@rosenzweig.io>,
 Sven Peter <sven@svenpeter.dev>, Janne Grunau <j@jannau.net>
References: <2-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <f0164c18-9ded-4c41-a8c5-c225a978973d@arm.com>
 <20250212140316.GA3844591@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20250212140316.GA3844591@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-02-12 2:03 pm, Jason Gunthorpe wrote:
> On Wed, Feb 12, 2025 at 01:56:55PM +0000, Robin Murphy wrote:
>> On 2025-02-07 2:46 pm, Jason Gunthorpe wrote:
>>> virtio-iommu has a mode where the IDENTITY domain is actually a paging
>>> domain with an identity mapping covering some of the system address
>>> space manually created.
>>>
>>> To support this add a new domain_alloc_identity() op that accepts
>>> the struct device so that virtio can allocate and fully finalize a
>>> paging domain to return.
>>
>> Oh, I'd already managed to forget this idea - this could be convenient for
>> DART to implement per-instance identity domain support as well.
> 
> If we are going to broaden this someday then I suggest the core code should
> implement it entirely buy asking the driver for a paging domain and
> then mapping all of system memory into it. There is nothing special
> here that needs to be in driver code.

Sorry, that was just in terms of having a domain_alloc_identity() op 
that's allowed to fail, being potentially neater than otherwise having 
to register distinct per-instance ops with and without the static 
identity_domain. I'm inclined to agree that if anyone really is 
desperate for identity-mapped paging domains in the absence of true 
identity support, then indeed we probably should handle that in core 
code much like we do for improvised blocking domains.

Thanks,
Robin.
