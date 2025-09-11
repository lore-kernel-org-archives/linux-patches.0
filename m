Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D80262D14
	for <patches@lists.linux.dev>; Thu, 11 Sep 2025 19:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757620620; cv=none; b=U6zRHM7dc8vAFNr+xKrOLaf20EYdpcGaMRQ+lqtq1SPqdCZYPL2/2zj97ZsufT81D+iMHdRO083S79mLjEdu3zDOy2cjhcE4A6k0K17s5ciMI1g3zGsKzEU0pOlUtoMPEVyLYrgymAS21owc5otIwXqI+OjLXDJZfqthbYTNIzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757620620; c=relaxed/simple;
	bh=fB06S4ZFtUWVGCTKe4l5MMYJGNwa+fb+1UiPDtQGVvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iI1Oey777FxrDA4h3Bp3SR1DOU7WQEY2dqN/ze/XQyLzK5HosSRA5kuZqfBTKgyzCPmVnq9/vAl/a3i+6Wk1Gavw8wn2fxfA3atzhDKAKeXtSslJjZvM8uLkSxyZt1/uaqFA9oQymtoG7OuJyjM67uVclBes9M5G7vXvBfkKOuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J6E0Wa3c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J6E0Wa3c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757620618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N3cNveyFhKelD03yvN9UhwY3+sLQeLXbF7GotBNmB6Y=;
	b=J6E0Wa3cs2dB5DhJnxWxbBbEZDExx60+cKiaByaTKXp43VC9MYRdXyQIMo5GVkY790P25f
	5M6Qc2zWyQ87YxwEtrTE/Rl6xLnPFsp4NP7igCjBw/qJfP68QY1gGlopRNKc60U+5a1icj
	kPf3k1ZG40Cv3YwwWy95NtfltYHd+8s=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-ViTqUjf6MqO6W0cxuUkbRA-1; Thu, 11 Sep 2025 15:56:54 -0400
X-MC-Unique: ViTqUjf6MqO6W0cxuUkbRA-1
X-Mimecast-MFC-AGG-ID: ViTqUjf6MqO6W0cxuUkbRA_1757620614
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-726a649957dso26269956d6.1
        for <patches@lists.linux.dev>; Thu, 11 Sep 2025 12:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757620614; x=1758225414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3cNveyFhKelD03yvN9UhwY3+sLQeLXbF7GotBNmB6Y=;
        b=V9DOiC8Z0SOS3KeKFJV3ygcAPuCBCrBndTz2vne7qPO75Cyj/APA6bSZVy7VDbVlR1
         YdO9lHRssv+KnzKxznp4SvJPtS5oaMLjVCOlOsW7T+lpFrngBxKt/GcvyAr6v9gVIM7A
         /ApmCSN++B4DQYBFg6h3MZ3CvXt/79vTuDwAEdo30ASE2ovqYEJiZ+O2qoNzvnfN7ISb
         Qd7pjYA028K3cFGDJPR9EapZnGOcL828qQDd1oToc7tWIWB4SLMM7bKCW+Oq4764ontB
         ImZv49VnwoOLZDPNuDjyKCfUKHgYHMkC/8w2Gd8bj1XA2swx0UtEu2BJhlVkQD27a2AK
         2PAg==
X-Forwarded-Encrypted: i=1; AJvYcCV0OT1Ovls0ELfpPYxhuryw3G/vqreGFRPFp/oAHHaqXzTtOvKqM97djIcuaEq+4FOvfQ2+0Bzr@lists.linux.dev
X-Gm-Message-State: AOJu0YyXCZOfqi6/rqvz4Wk834ww9qB24U6vbVNkaCzwrKfWDzNuqN05
	Jm5+qI7pfMuBRC+geq0uFkZMwIaquPkgir25i1rlOnO/+1d+3yshSITgkjHqTLRdT1IhP0vIh3d
	X8BelVa5lSabG8PhtmAyhYl4EO850PLj44/FdLnmxKRm92oZ8/GaMVg3MXOI=
X-Gm-Gg: ASbGncspphEy5Hal6AMoZjn//gmmA0fRSYJzE3XPyvLkWqFf7URtO6a9RdN0WLadW43
	OZt2sAZOjDTPTOq54llpCm+7G9dHjYBXv/URLCcSS//JqY7bcgn4wNGSZfYCWcXVLgpP6r9D8p1
	WiVKc9ME+SuKZL/MT7JIc7vJ3vzFlnX7KQU21pnIuk3O0yCVNJW98yo40CrLFXegCleCk5jguKi
	I/Fmd9H5d6OOxmzHZJbsOH4b1Bb2HVmJ4P060/XU7IlIv7k4aisHyD1HtW7+LAA4RH1jZm8Dmj7
	KhALaso3Kr8w9nLkbw7ZRjiSrABeMGOztVW9DOPQ
X-Received: by 2002:a05:6214:246d:b0:725:c2b4:3335 with SMTP id 6a1803df08f44-767bac0e426mr8332726d6.4.1757620614064;
        Thu, 11 Sep 2025 12:56:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLemFR3JpHScXx4h7q7Tkg6Nhj/3uhlgp5omv8uUp+kJSUBV2Eg/agifUMN18nW/Yywqtw1g==
X-Received: by 2002:a05:6214:246d:b0:725:c2b4:3335 with SMTP id 6a1803df08f44-767bac0e426mr8332416d6.4.1757620613594;
        Thu, 11 Sep 2025 12:56:53 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-763b642285dsm15725296d6.26.2025.09.11.12.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 12:56:53 -0700 (PDT)
Message-ID: <3d3f7b6c-5068-4bbc-afdb-13c5ceee1927@redhat.com>
Date: Thu, 11 Sep 2025 15:56:50 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/11] PCI: Add pci_reachable_set()
To: Bjorn Helgaas <helgaas@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <20250909210336.GA1507895@bhelgaas>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250909210336.GA1507895@bhelgaas>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nLAZFoKGue9NtmAhQKc3JNR_VsXTK7Z5Nk1CGlVlpng_1757620614
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/25 5:03 PM, Bjorn Helgaas wrote:
> On Fri, Sep 05, 2025 at 03:06:20PM -0300, Jason Gunthorpe wrote:
>> Implement pci_reachable_set() to efficiently compute a set of devices on
>> the same bus that are "reachable" from a starting device. The meaning of
>> reachability is defined by the caller through a callback function.
>>
>> This is a faster implementation of the same logic in
>> pci_device_group(). Being inside the PCI core allows use of pci_bus_sem so
>> it can use list_for_each_entry() on a small list of devices instead of the
>> expensive for_each_pci_dev(). Server systems can now have hundreds of PCI
>> devices, but typically only a very small number of devices per bus.
>>
>> An example of a reachability function would be pci_devs_are_dma_aliases()
>> which would compute a set of devices on the same bus that are
>> aliases. This would also be useful in future support for the ACS P2P
>> Egress Vector which has a similar reachability problem.
>>
>> This is effectively a graph algorithm where the set of devices on the bus
>> are vertexes and the reachable() function defines the edges. It returns a
>> set of vertexes that form a connected graph.
>>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> ---
>>   drivers/pci/search.c | 90 ++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/pci.h  | 12 ++++++
>>   2 files changed, 102 insertions(+)
>>
>> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
>> index fe6c07e67cb8ce..dac6b042fd5f5d 100644
>> --- a/drivers/pci/search.c
>> +++ b/drivers/pci/search.c
>> @@ -595,3 +595,93 @@ int pci_dev_present(const struct pci_device_id *ids)
>>   	return 0;
>>   }
>>   EXPORT_SYMBOL(pci_dev_present);
>> +
>> +/**
>> + * pci_reachable_set - Generate a bitmap of devices within a reachability set
>> + * @start: First device in the set
>> + * @devfns: The set of devices on the bus
> 
> @devfns is a return parameter, right?  Maybe mention that somewhere?
> And the fact that the set only includes the *reachable* devices on the
> bus.
> 
Yes, and for clarify, I'd prefer the fcn name to be 'pci_reachable_bus_set()' so
it's clear it (or its callers) are performing an intra-bus reachable result,
and not doing inter-bus reachability checking, although returning a 256-bit
devfns without a domain prefix indirectly indicates it.

>> + * @reachable: Callback to tell if two devices can reach each other
>> + *
>> + * Compute a bitmap where every set bit is a device on the bus that is reachable
>> + * from the start device, including the start device. Reachability between two
>> + * devices is determined by a callback function.
>> + *
>> + * This is a non-recursive implementation that invokes the callback once per
>> + * pair. The callback must be commutative:
>> + *    reachable(a, b) == reachable(b, a)
>> + * reachable() can form a cyclic graph:
>> + *    reachable(a,b) == reachable(b,c) == reachable(c,a) == true
>> + *
>> + * Since this function is limited to a single bus the largest set can be 256
>> + * devices large.
>> + */
>> +void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
>> +		       bool (*reachable)(struct pci_dev *deva,
>> +					 struct pci_dev *devb))
>> +{
>> +	struct pci_reachable_set todo_devfns = {};
>> +	struct pci_reachable_set next_devfns = {};
>> +	struct pci_bus *bus = start->bus;
>> +	bool again;
>> +
>> +	/* Assume devfn of all PCI devices is bounded by MAX_NR_DEVFNS */
>> +	static_assert(sizeof(next_devfns.devfns) * BITS_PER_BYTE >=
>> +		      MAX_NR_DEVFNS);
>> +
>> +	memset(devfns, 0, sizeof(devfns->devfns));
>> +	__set_bit(start->devfn, devfns->devfns);
>> +	__set_bit(start->devfn, next_devfns.devfns);
>> +
>> +	down_read(&pci_bus_sem);
>> +	while (true) {
>> +		unsigned int devfna;
>> +		unsigned int i;
>> +
>> +		/*
>> +		 * For each device that hasn't been checked compare every
>> +		 * device on the bus against it.
>> +		 */
>> +		again = false;
>> +		for_each_set_bit(devfna, next_devfns.devfns, MAX_NR_DEVFNS) {
>> +			struct pci_dev *deva = NULL;
>> +			struct pci_dev *devb;
>> +
>> +			list_for_each_entry(devb, &bus->devices, bus_list) {
>> +				if (devb->devfn == devfna)
>> +					deva = devb;
>> +
>> +				if (test_bit(devb->devfn, devfns->devfns))
>> +					continue;
>> +
>> +				if (!deva) {
>> +					deva = devb;
>> +					list_for_each_entry_continue(
>> +						deva, &bus->devices, bus_list)
>> +						if (deva->devfn == devfna)
>> +							break;
>> +				}
>> +
>> +				if (!reachable(deva, devb))
>> +					continue;
>> +
>> +				__set_bit(devb->devfn, todo_devfns.devfns);
>> +				again = true;
>> +			}
>> +		}
>> +
>> +		if (!again)
>> +			break;
>> +
>> +		/*
>> +		 * Every new bit adds a new deva to check, reloop the whole
>> +		 * thing. Expect this to be rare.
>> +		 */
>> +		for (i = 0; i != ARRAY_SIZE(devfns->devfns); i++) {
>> +			devfns->devfns[i] |= todo_devfns.devfns[i];
>> +			next_devfns.devfns[i] = todo_devfns.devfns[i];
>> +			todo_devfns.devfns[i] = 0;
>> +		}
>> +	}
>> +	up_read(&pci_bus_sem);
>> +}
>> +EXPORT_SYMBOL_GPL(pci_reachable_set);
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index fb9adf0562f8ef..21f6b20b487f8d 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -855,6 +855,10 @@ struct pci_dynids {
>>   	struct list_head	list;	/* For IDs added at runtime */
>>   };
>>   
>> +struct pci_reachable_set {
>> +	DECLARE_BITMAP(devfns, 256);
>> +};
>> +
>>   enum pci_bus_isolation {
>>   	/*
>>   	 * The bus is off a root port and the root port has isolated ACS flags
>> @@ -1269,6 +1273,9 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
>>   struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
>>   struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
>>   
>> +void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
>> +		       bool (*reachable)(struct pci_dev *deva,
>> +					 struct pci_dev *devb));
>>   enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
>>   
>>   int pci_dev_present(const struct pci_device_id *ids);
>> @@ -2084,6 +2091,11 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
>>   						 struct pci_dev *from)
>>   { return NULL; }
>>   
>> +static inline void
>> +pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
>> +		  bool (*reachable)(struct pci_dev *deva, struct pci_dev *devb))
>> +{ }
>> +
>>   static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
>>   { return PCIE_NON_ISOLATED; }
>>   
>> -- 
>> 2.43.0
>>
> 
For the rest...
Reviewed-by: Donald Dutile <ddutile@redhat.com>

