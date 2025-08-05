Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D251FBEB0;
	Tue,  5 Aug 2025 14:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754404872; cv=none; b=GmB2pbButQO+yNGq5kY5RjzSjM3PrDTmA2vzDkml7SCRg508GSwqE85Ybg7Tddg9niDIuTEeinLmryIyU4o0nYxvXX2LACzwA564SmyaR4LksQqbXxFVCmtkTS9UTD9oN4qfMK7+JwuC9XZ8U1wBgQwUUhKVvq2uOfRpOymdLR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754404872; c=relaxed/simple;
	bh=sgnGJUlVKJPFBRwW0xHy5krBGxDNDIg8z4YcRoTgpZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c0RKeIqBAfcTgyRQMxdOLOfEJ8yW9T2eozOc0tHzpMteeg3EaAehoXJjq0TUGjOm+SuILPJ4l93SzBK37M6M6x50mRKSoX4g2YRtHt3O5QPCp7lpO2i2F7wfOuv1Cv7GPLZxGWm8znD3q6mcaTMEGnfuutd7cCIdNUmYM0L/yR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mwr4KdRK; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mwr4KdRK"
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-455b00339c8so36255735e9.3;
        Tue, 05 Aug 2025 07:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754404869; x=1755009669; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H+xd2a0eqDbR0whEvw2TqimTj8VyebTrqGrWBXALaro=;
        b=mwr4KdRK8ckSLiQOcfFIxgZZMEPuw0lkdRDk15o/itrIxkou9rKbr+M3lPIb1K5xOw
         a4rxXkJkF7qVJeS+r/bAk5AJ9P/z2vLKOyUH7OFvnvG9MJNPibm6m+JGEdAX0FeFc1z2
         0BRb8tMknUT8pOOJG6DT7oVcJhSXMfDS9ZDKxIHihR3RqF5AwauZhxM1iTB3FauCDYZJ
         oStolQLMz/WhEmL+5daallGireZyImBqb286pSEs+diGoCP+r+7G7GdOcmytGyMDOkQJ
         HfJahXAwGRqZ8qxRI8k5sgHAR4WnlqLscoOP92LYKsCx6RDZc7gCgTYBqL+sYM5Wp61r
         OAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404869; x=1755009669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H+xd2a0eqDbR0whEvw2TqimTj8VyebTrqGrWBXALaro=;
        b=IxV/gGpEz2pQAbz9pqaCjx1SrbTpZPOSk5ZL4yB0TEvEZXQXpprXCdXCKPhGrXb4zW
         jbKUXkBa/SoWPwKscbpxCFFwlxiNGIf6atZ4HBIuFYuAEEYILPAMoCGch5grKQDp807U
         THJBHxmnHuEERlG8TUDjxjj1JS6ugzqJ+uMS4ZEGPFvIr8Fq2RWd9nOGDsJDgI8RreVz
         H6/RKRSaQPO/FYOe+lveFXVvfDJupAWdtXDtLiovnLcUnr6yeeXkWqzBvRA2u0Sd3A+J
         nA0A4T3aWamN+mkOxECOJFECQlU3uRJo/ex4GHKUuw4+ZzCfxvDlQsnlcl+hBDrtxmb5
         4zuw==
X-Forwarded-Encrypted: i=1; AJvYcCUYI4als5gccuwy3SGsNtNIQyH0FYk696E2I1njc3hCIt5HlywPCpkRfhjiUazQIlPGd/utiJ9ezA==@lists.linux.dev, AJvYcCW9AtlGiNdpo9OVg1THlCgdOWQ/DbbAH39EYdhlR8hnUQ1B1x8yk8BaVJRkfa+jQtJAh8XCjw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzqWinu1qxSHhOfmPgleBmS4aZWvmR7NyQIxkjdIsxju2uj0Avr
	Vk1K6tOk3Nj0xPUxdUcUEsHFhAtQ86nDpdbGhvIj44npmEvyHK6pNO58
X-Gm-Gg: ASbGncspOCE+s0Nlbmb0eRgVjqPNXBZ+0HMQLjvDC8KQwOiBIWIyRS0Lrod8HCy5Lqs
	4zKn/kaadAkad44n/OWYBk7dRoeRhabgSnIhKmitRN4kis09MtSHHjsltkfM23xqASV1DeuolEQ
	bVWOlH0gcAgwtG5+fowjVg6wdxTnOeBF3uvF9u/mNVm4/M+RSkjz2eP+FFq0YDhk7moKJVhYl+P
	LOvw1O1jOwu/O+vHaMFoz0PhSnzrTAe1ENROHYLabC4Th5STNWRSBGxGKcUU4/RLmf0lzrVc+Nq
	O/7j0wCjFL9kV8mWGB++KCnlG65Kamcj1q7dvPUEWU+Mfa+sZRd55Zkeqs+sfGSBxBvOUUOT4fL
	kWqBevlFpZrFXiBblkdIS7yTuPqXwDLFjDFgK7kLeALat27dUJhUg8c+nCvk5GNXgYhFBq6I6/x
	KsyAYLEkkORTFCoZvCNEpXMgRJzE1LKFsd2BhEgN1c
X-Google-Smtp-Source: AGHT+IHvIjGHMJgZMlvbuLWImAEUDwhazDk3L40EIHxWJUmFdZGc2fOUxfMf8D9qX8KyVo9aYJdwfQ==
X-Received: by 2002:a05:600c:354e:b0:456:fdd:6030 with SMTP id 5b1f17b1804b1-458b6b307f4mr111648985e9.19.1754404869317;
        Tue, 05 Aug 2025 07:41:09 -0700 (PDT)
Received: from [26.26.26.1] (ec2-52-29-20-83.eu-central-1.compute.amazonaws.com. [52.29.20.83])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac574sm19459910f8f.5.2025.08.05.07.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 07:41:08 -0700 (PDT)
Message-ID: <964c8225-d3fc-4b60-9ee5-999e08837988@gmail.com>
Date: Tue, 5 Aug 2025 22:41:03 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
 <20250802151816.GC184255@nvidia.com>
 <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
 <20250805123555.GI184255@nvidia.com>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <20250805123555.GI184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/5/2025 8:35 PM, Jason Gunthorpe wrote:
> On Tue, Aug 05, 2025 at 11:43:29AM +0800, Ethan Zhao wrote:
>>
>>
>> On 8/2/2025 11:18 PM, Jason Gunthorpe wrote:
>>> On Sat, Aug 02, 2025 at 09:45:08AM +0800, Ethan Zhao wrote:
>>>>
>>>>
>>>> On 7/9/2025 10:52 PM, Jason Gunthorpe wrote:
>>>>> The series patches have extensive descriptions as to the problem and
>>>>> solution, but in short the ACS flags are not analyzed according to the
>>>>> spec to form the iommu_groups that VFIO is expecting for security.
>>>>>
>>>>> ACS is an egress control only. For a path the ACS flags on each hop only
>>>>> effect what other devices the TLP is allowed to reach. It does not prevent
>>>>> other devices from reaching into this path.
>>>
>>>> Perhaps I was a little confused here, the egress control vector on the
>>>
>>> Linux does not support egress control vector. Enabling that is a
>>> different project and we would indeed need to introduce different
>>> logic.
>> My understanding, iommu has no logic yet to handle the egress control
>> vector configuration case,
> 
> We don't support it at all. If some FW leaves it configured then it
> will work at the PCI level but Linux has no awarness of what it is
> doing.
> 
> Arguably Linux should disable it on boot, but we don't..
linux tool like setpci could access PCIe configuration raw data, so
does to the ACS control bits. that is boring.>
>> The static groups were created according to
>> FW DRDB tables,
> 
> ?? iommu_groups have nothing to do with FW tables.
Sorry, typo, ACPI drhd table.

Thanks,
Ethan>
>> also not the case handled by notifiers for Hot-plug events
>> (BUS_NOTIFY_ADD_DEVICE etc).
> 
> This is handled.
> 
> Jason

