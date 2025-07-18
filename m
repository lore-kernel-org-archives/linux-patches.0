Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48A721C9F4
	for <patches@lists.linux.dev>; Fri, 18 Jul 2025 21:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752874920; cv=none; b=M5vuNIvTFJxDF+DLzSB0YSkCFJF4Tud+l1xs348wauI7BRSjRY9buNhd4FkzPAe7wh0egwHzX1ZzMp7nTXqGpebYTkA2AFttP8lgsVfEyRC5w8tuqtTCB27t23NrS8+SBoYuBmCzzMQfsNyGzOzS1dZWuZ+hUZ5X+xWncxyk02k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752874920; c=relaxed/simple;
	bh=uxXpdkcHdOrQaJc+eu4/GeOXinhx7hO5tirp5wkNhw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l/YCNEKww0qkCUqW9BGO8DjhPxTh25cT22xbG30tmO2i0mHOaY7BUv9zHqYo2M+OKwbA6fGmr7IhopHWnhCkW4Dhnf20VyYQYU3tSAPTOK53CipvRY37XrkaQCvRLdfuFnb6Qb92/NJCNG+gZxRx0kj6aZ7C0j3AWYC5fYY9gek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NrpmS24x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NrpmS24x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752874918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pl8HYJY2kuf3xc5dYY1A2bTJiaSaxCFVikVVLsHu9SQ=;
	b=NrpmS24xcQhFf7z3zT/77jdGQCvMJ90RGt8bYYURVEc4M0ttWaTWzXebb0nxLJsjVVyIuo
	l09bxWed3YPytbDbPy2Ua0KrRazop3j6LAyeSJMxqQjuwcObJ2eO8f7MZwzyGNenAht3gX
	h3EBiAANRHuIEdJPi0tWcPo0jHckT8c=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-0xVQ0i-COyOAw4BTZ86DLw-1; Fri, 18 Jul 2025 17:41:57 -0400
X-MC-Unique: 0xVQ0i-COyOAw4BTZ86DLw-1
X-Mimecast-MFC-AGG-ID: 0xVQ0i-COyOAw4BTZ86DLw_1752874914
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-234a102faa3so21941385ad.0
        for <patches@lists.linux.dev>; Fri, 18 Jul 2025 14:41:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752874914; x=1753479714;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pl8HYJY2kuf3xc5dYY1A2bTJiaSaxCFVikVVLsHu9SQ=;
        b=hAi1o3nRIICb78v0Vn7KdekjE2B5p7F+OVfHqdT0R/Kdt3slk4XvkwqPSbW1xiJqOW
         XZLRF3QUgReIS/LPSSLnhDT9PgWiFM4OPSUhEqOgzK33dqRerrwl9B4MdZOGFlXxGGCF
         oWSLSmDgy5kuXPb18HSPArp8SYx6ygsIbwZBitcSOqeuUz0WFCS5/BO7hiQWu9NDvQHD
         +zXLM2abG0dF9Wt5SYfZEizJ9bs9ONEIFKW0sBwFqQN0sxH7f021Z3Ao7Ff6JwZtgwUE
         dKtFGcuqtlUlS6qbb1hjbvAfTtNQ07ygf+Ekj9pR52RPSgphHp2G8cVabPimQ5VDOtmM
         fYQw==
X-Forwarded-Encrypted: i=1; AJvYcCUaxQbHrgibxfyZrua2VHyqqNYTajJLxuMwNbxWjPCXk138yl3S9PScx/QYsijEKrGAQHojQFwd@lists.linux.dev
X-Gm-Message-State: AOJu0YznIS6z0LaF6esIQXMtLD6V8HE8zMQet3gAejKg9AgXejcpDG7K
	j/+ncISMtGN1TKdBcK16HwPz1pCyLav3Nfw0rgo9FzIN8gLC/u1XII2rd2VterUIjN0Fqv8xocu
	5ksBTPtoOjGOhPSVfousNIt5P90gwEgj+xsf+gSw5aKrCq5jBbTk10Md5NV8=
X-Gm-Gg: ASbGncv6QXoW0Lam9MpXEkLGCrbdHnr5OJlIWlk0IRw3LhZtlorLX9lyCdqZXiYLATz
	5DE/m6wPfEgC6MAtL0pqKxiI/cxkdRSxLO2DoYLZ4/qRkdP9EgFuvTFlBSXARURQj3Vj4GhwQgm
	WTueXPzdrveUK6lEefj4gB/H4SL3aTHyGhLHh/e/NKQVAGgpX3SzvVuwxQeaTCK8mLju0KjHynv
	i1hERAXZKVrXh6GkSEdQCkBn3qTnAyBN4pIToW3+wxYPc87UwnOjy1eJMJIixMlBOJpdQ3dkH5f
	AU6tNzKv676hB9op+kRaXAmbMKbg74Xs6vT0A8LP
X-Received: by 2002:a17:902:ef02:b0:234:9656:7db9 with SMTP id d9443c01a7336-23e24f4ae0emr193121245ad.32.1752874914361;
        Fri, 18 Jul 2025 14:41:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElJIwNy/gAl1oOb5k7nEBq38Uon8tJbJo/3EEmGz51w51P0ZBbNDEpVhWKCJJ33lSWOle8bg==
X-Received: by 2002:a17:902:ef02:b0:234:9656:7db9 with SMTP id d9443c01a7336-23e24f4ae0emr193120855ad.32.1752874913939;
        Fri, 18 Jul 2025 14:41:53 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6b4b20sm18055975ad.121.2025.07.18.14.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 14:41:53 -0700 (PDT)
Message-ID: <1cda6f16-fb56-450e-8d33-b775f57ae949@redhat.com>
Date: Fri, 18 Jul 2025 17:41:47 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/16] iommu: Compute iommu_groups properly for PCIe
 switches
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <3-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <5b1f12e0-9113-41c4-accb-d8ab755cc7d7@redhat.com>
 <20250718180947.GB2394663@nvidia.com>
 <1b47ede0-bd64-46b4-a24f-4b01bbdd9710@redhat.com>
 <20250718201953.GI2250220@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250718201953.GI2250220@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZGtjoej2YxxjFHE11B--Am-YD2doDjeLAyYg6dk8NCw_1752874914
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/18/25 4:19 PM, Jason Gunthorpe wrote:
> On Fri, Jul 18, 2025 at 03:00:28PM -0400, Donald Dutile wrote:
>>>>> +	/*
>>>>> +	 * !self is only for SRIOV virtual busses which should have been
>>>>> +	 * excluded above.
>>>> by pci_is_root_bus() ?? -- that checks if bus->parent exists...
>>>> not sure how that excludes the case of !bus->self ...
>>>
>>> Should be this:
>>>
>>> 	/*
>>> 	 * !self is only for SRIOV virtual busses which should have been
>>> 	 * excluded by pci_physfn()
>>> 	 */
>>> 	if (WARN_ON(!bus->self))
>>>
>> my Linux tree says its this:
>> static inline bool pci_is_root_bus(struct pci_bus *pbus)
>> {
>>          return !(pbus->parent);
>> }
>>
>> is there a change to pci_is_root_bus() in a -next branch?
> 
> Not that, at the start of the function there is a pci_physfn(), the
> entire function never works on a VF, so bus is never a VF's bus.
> 
Well, i guess it depends on what you call 'a VF's bus' -- it returns the VF's->PF(pdev)->bus if virt-fn,
which I would call the VF's bus.
thanks for pointing further up... now I get your added edit above (which I didn't read carefully, /my bad).

>>>>> +	 */
>>>>> +	if (WARN_ON(!bus->self))
>>>>> +		return ERR_PTR(-EINVAL);
>>>>> +
>>>>> +	group = iommu_group_get(&bus->self->dev);
>>>>> +	if (!group) {
>>>>> +		/*
>>>>> +		 * If the upstream bridge needs the same group as pdev then
>>>>> +		 * there is no way for it's pci_device_group() to discover it.
>>>>> +		 */
>>>>> +		dev_err(&pdev->dev,
>>>>> +			"PCI device is probing out of order, upstream bridge device of %s is not probed yet\n",
>>>>> +			pci_name(bus->self));
>>>>> +		return ERR_PTR(-EPROBE_DEFER);
>>>>> +	}
>>>>> +	if (group->bus_data & BUS_DATA_PCI_NON_ISOLATED)
>>>>> +		return group;
>>>>> +	iommu_group_put(group);
>>>>> +	return NULL;
>>>> ... and w/o the function description, I don't follow:
>>>> -- rtn an iommu-group if it has NON_ISOLATED property ... but rtn null if all devices below it are isolated?
>>>
>>> Yes. For all these internal functions non null means we found a group
>>> to join, NULL means to keep checking isolation rules.
>>>
>> ah, so !group == keep looking for for non-isolated conditions.. got it.
>> Could that lead to two iommu-groups being created that could/should be one larger one?
> 
> The insistence on doing things in order should prevent that from
> happening. So long as the larger group is present in the upstream
> direction, or within the current bus, then it can be joined up.
> 
> This doesn't work if it randomly applies to PCI devices, it is why the
> above has added the "PCI device is probing out of order" detection.
> 
ok, will keep that concept in mind when reviewing.

> Jason
> 

