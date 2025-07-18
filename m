Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22431BD9CE
	for <patches@lists.linux.dev>; Fri, 18 Jul 2025 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865854; cv=none; b=jb0LeniT5E4/6uhjhRpvxTgq+TpGffmq0UOIFJuYoQFVHJkyRn5NMXXw3M+zRKzZ8XNi+YULyAOREOKTmKwvBNO8q9Lg9BT9FJQgqdoeoshRcdhPwwFF4XGLnRSBg1rUbubl8s9/GrTm72oQl7k9yNJMY/jM2jisr4IuIUWhBRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865854; c=relaxed/simple;
	bh=12HnDqMeVgttmuY8covfcXjk4vazl0YNAz1/AvqhAPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OWP9Uysb6GhDWOElnoPEDt+i0eTCA3Uv36D1EH1VcXsl3kiBTFPgFQ2HepNXqh0jp0x5p/R08DWKc7330tmUVvhYTdEZ9RB9FByGdkWKUTV7BsQ7P6JM28lU0hiAfOaQcsofjJ3rwx+rW8H3Kju4CClrKWPRAlJ/6i5U1dvfV8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HLfZ2HeH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HLfZ2HeH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752865851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V8D+e9uBJDRczJqfQeOvVP8ReNAlQCGSx/AVjBJK5K4=;
	b=HLfZ2HeHQQ+r4WIjb6054O1v8x6LrLeIZ2qwJk9A8dErwI23kuVghPIoFrRPXuPfyU2uGX
	ybKenALIV77ARTTAtHtnmYD1ru6qsbuXk5HHnG6aBuEF+mgqMKou9Bd33ekVN7dL1egpgs
	qavQLxicLVUEQa7ndsDE5GKDsnjo0/c=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-Nj91Uj-ROmCBuNOLYOpgtA-1; Fri, 18 Jul 2025 15:10:49 -0400
X-MC-Unique: Nj91Uj-ROmCBuNOLYOpgtA-1
X-Mimecast-MFC-AGG-ID: Nj91Uj-ROmCBuNOLYOpgtA_1752865848
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-311ae2b6647so2319290a91.0
        for <patches@lists.linux.dev>; Fri, 18 Jul 2025 12:10:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752865848; x=1753470648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V8D+e9uBJDRczJqfQeOvVP8ReNAlQCGSx/AVjBJK5K4=;
        b=Ynt+RKYYzqZXiCONFEX2BQ3cwful5G/JMPEdrwXk9UouvSqAElFIEBfLKCkGnrK3+F
         nEqoszRi8jiGUshtsVQzNRgyb1nCR4zY8A/6xBaP4F9XlS0afXu7oZZ61pIS9eQcRotH
         Js8kM9srqvgyGynovgdDjwknTqy96g6deNfUoHSRf+/g3ZiTAW5N5Teq+W6fE2ZkBJj6
         MDt6QTBajsL75Upb0WOXj7y1CU67lBlwfqyB08P+B8gYhvqruybkQ61wiuDxhN+pAEQ1
         kC20dF9JNErYIe8nzUJ3n5jK/f8JToFtUSG9E/OcA3OgZ8EpJVBiSSr16pJkjqJl0wZe
         XCfw==
X-Forwarded-Encrypted: i=1; AJvYcCXEa7C26qNURzKnX2595yFkSOCtV7jz0JWp+1lQkgjjB6V08tRN3Z+1augzqNYEru1hEpJFKnnP@lists.linux.dev
X-Gm-Message-State: AOJu0YwMyRty0/MRRYKbEo1ABH47MuLP6E+6xQAjkfY0kIsfeCWSpF/P
	tTjMOjJ6tvgdFz33F7SMPe7pnQtVFOF3hdB6Mb4TiTYmWqDoTkr/u+5yqyMSguN9iFf1OLhL3dE
	SmJqJnKjOpvnbKg9qJXmlUUVENGqzP2wj8ul98p0BynaD8gDqUECtG8Ew+SE=
X-Gm-Gg: ASbGncsuwrPStEppSZRgAMqfLBY7g94Ox6nrwEkPe60ZSlKDdYSmKsK9t6Bq83WUodb
	A10GqBbJtzqiDpAJN074xZyxnkm0S7YNIUm27TIO9I2P/KJ1e2PTcUN8K/qbz0WKidL5+I3Mxqj
	7ZCbPjRt/E6Hs5svmp4Zf6SSxtQiJn3nKMtD2sVSsW+j7wdHd979noj31uzmv/IQ63t2RKvIPDL
	DtTbb9HY/WyrhYYiuIoninSDprHgdAhyhzLrZw4h2Stb5rtHspq+YHp/1dnQX/WtM9HYzL/VrG4
	eGXK3CiMotsaEFqVErTxECRMupu3HWAYkVBokcJ4
X-Received: by 2002:a17:90b:6ce:b0:311:b5ac:6f6b with SMTP id 98e67ed59e1d1-31cc253d5c7mr6000478a91.9.1752865848248;
        Fri, 18 Jul 2025 12:10:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIqj9LP2vHBGP1tqCvOrWc8j8Q/BDtDPfNNbouKYvr5XMtLMkhhPcn26wkmN3ctBxthZr59g==
X-Received: by 2002:a17:90b:6ce:b0:311:b5ac:6f6b with SMTP id 98e67ed59e1d1-31cc253d5c7mr6000449a91.9.1752865847822;
        Fri, 18 Jul 2025 12:10:47 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c9f1e6a68sm5667046a91.19.2025.07.18.12.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 12:10:47 -0700 (PDT)
Message-ID: <519d8178-4cec-44c2-8b24-cc9ae9dbd221@redhat.com>
Date: Fri, 18 Jul 2025 15:10:42 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/16] PCI: Add pci_reachable_set()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <5-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <3bf0f555-535d-4e47-8ff1-f31b561a188c@redhat.com>
 <20250718174921.GA2393667@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250718174921.GA2393667@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ymoyTVzt_SAzUJwD29TDneLENqMJfvnYKMKX1PB-VpQ_1752865848
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/18/25 1:49 PM, Jason Gunthorpe wrote:
> On Thu, Jul 17, 2025 at 06:04:04PM -0400, Donald Dutile wrote:
>>> Implement pci_reachable_set() to efficiently compute a set of devices on
>>> the same bus that are "reachable" from a starting device. The meaning of
>>> reachability is defined by the caller through a callback function.
>>>
>> This comment made me review get_pci_alias_group(), which states in its description:
>> * Look for aliases to or from the given device for existing groups. DMA
>>   * aliases are only supported on the same bus, therefore the search
>>   * space is quite small
>>
>> So why does it do the for loop:
>>    for_each_pci_dev(tmp) {
>>
>> vs getting the pdev->bus->devices -- list of devices on that bus, and only
>> scan that smaller list, vs all pci devices on the system?
> 
> Because it can't access the required lock pci_bus_sem to use that
> list.
ah, i see; it's only declared in drivers/pci/search.c, and it isn't
a semaphone in a per-bus struct. :-/
... so move the function to search.c ? /me runs...
I know, not worth the churn; already have 'polluted' iommu w/pci, but not vice-versa.
(although iommu-groups is really a bus-op (would be a different op, for say, platform devices going through another iommu).

> 
> The lock is only available within the PCI core itself which is why I
> moved a few functions over there so they can use the lock.
> 
>> Could we move this to just before patch 11 where it is used?
> 
> Yes
> 
>> or could this be used to improve get_pci_alias_group() and get_pci_function_alias_group() ?
> 
> IMHO it is not really worth the churn
> 
Hey, your churning at the moment, so I figured you may want to churn some more! ;-)
just a comment/suggestion; not required.

> Jason
> 

