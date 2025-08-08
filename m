Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0464A78F39;
	Fri,  8 Aug 2025 07:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754639784; cv=none; b=KjYKbmCeemk66LeOj4aIc4rDTtZq6GLSBlGQ5v6p5W/RuW6jTQ5ryIRMl40kHwaG5nsoRPe+luav5R+E8KLLxlKrywv5YSjO2jOdZd0+Rh/Cd2YK/gq+3k2Yd3qyW1HLZttMP4V4r1Vlo08FQ3mpS2D27ZPrfVF1IvoV7aBlk94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754639784; c=relaxed/simple;
	bh=eH0NyDPZql4wCTz3i6PHT+N8D4o8WobMpqdwAmhOD8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rw+dSYtK0OEs71GShE757r3v2yZ44kzMC6+Uj+ErpphlA2BXNwOsxGx2wjpkLIpc2L4mBAsWf+XAOECp0c3JS4EQDJTzvp7vQO3oyXaXwS+Y25dRxe42hV5XeCbWYhK4W/3skSmyKJZBmH9dNgt8Abfr8Ohs9cuBLcMSe/MeVyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XGIHFppd; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XGIHFppd"
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-459e20ec1d9so17561175e9.3;
        Fri, 08 Aug 2025 00:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754639781; x=1755244581; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g47/JQMYnoJFt8X2Gyr00t3GiLF5ts7OyvZLVgHeWbk=;
        b=XGIHFppd0qydbsvIzE0Qtf6TD1xCi5liGFpBUw2tlK5/kZWWNkDUb9sIES2edk5ItP
         ry0uoSrXQCzRIN6A5doKamBRVBJojBbDi8R4gg/Y+SYFkTqkqMGIHUx/lSquDT1W1dIo
         d6AZ9x0kh2zrLEQ+ATLzRBRxVyLActYm6jf4eDUPJHYyWg+CFT+lxO0gZol7e4mdsYic
         TLgdrBUCEmONHdSEhyo/24RZDr0FSxfBbJOjCZ5Dil0C8BNxzHynCyQXO+yh1MZV49K1
         moVO84TLsbuvrIyCDqLFJAP6HYiaqbtDjqMk9fTJrxvnQqG+ioFNv04RXgu+4n+7/WLP
         cYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754639781; x=1755244581;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g47/JQMYnoJFt8X2Gyr00t3GiLF5ts7OyvZLVgHeWbk=;
        b=BfJDBcyjfbTeDbhdGQQm5bGE1SWyJK7Ah+8c+LVRkC1EVsCEdS/max6X5cRVlY+pHA
         S0paFVn47MSgcCDBMCtTgQpeI+BLdULhQn1TDL4tdVYKOzgg1841gbE4gz5IptUqv04J
         Z2FHHjV7dmFLoJ5NdQw9xtJskAyLIoANYIxI4R2bqU78DbBlhV1vL2eCKdubLVwSsrUG
         pe1cs3HbgHG20DDmVCQfiV+FMrcWoViegRxmao+AhcZq/u0gHdk8iGVrWkY/5PayCdV3
         mhk1xkHvm556bfQVgJUftDBBa3xF0l+eXhYLSGEnYLpdmjHqBE1P/5KPlmaY0At/HH39
         58Eg==
X-Forwarded-Encrypted: i=1; AJvYcCVBD0T9cNx4F+rtmx4F2JE2i3U5ivcIbreYAOpjbBfvibNMJ6NSknLYUoogpZ3Hk+bDBf5yeu2nbA==@lists.linux.dev, AJvYcCX//4JB7CYDfufqU5ZKkVCKm98OshDPA6G5DQMcWJlVQOtMl8w62DrwgjKacYItRGKpPV/L2w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwKc6b23An/gFxTZCZtfseZ9sJqdhvL4CmogsW5GBYfLZ36/cw5
	qdPgepsPRIH32sy6+hvZ+Jd04UCJETyPZldId6JRbFLUEIVwX4ahJgWO
X-Gm-Gg: ASbGnct7xsJL5mqINJaNZ8XPcVjnRVNXkFC6syKNYNdX17vwdAloJr3SooSTHAnKwzm
	22OjCVjsbJ1AUVe9Wwhns3ou7Bg9+46453HklQ18IzLhl1IcJNiOBaGPGVCQKtCYL1R8WUfT8B/
	XAeoBBtYIhVrP2Rxh+jl3mZeEBVf5EvOCSYyYj6p6XO1Mdttt6ZiALpYNl9rawPsLVALBvzA6pq
	JUBtvv5ncdqx9X0RCDTeMxBZewxI0bbhFBLHuIku2Pd4TlVciWaid1KIs407L3c7XQRKQ519ftZ
	jVJcej7d7/WF6xFuGOxIRoaSFhnfp90aABxqNj8Qy3QBCdICP3PFFDGBezXSOO+7XJSyMyjBl3j
	/RKNkhn4E8/EaK0JjFHDIFaGvRvNvy0lTwlgOaUlWwhfdp1bnqhI6fCwDr03WFQjZnrvvxmwYsO
	tQ8ZPqierSfIVSlegV1GObqKpq5ZaWauV0lA==
X-Google-Smtp-Source: AGHT+IEBs27Uy9PNJpjOLnJbY5yuC13GxO0mFq67O2Xv2B5Lc++fQpKDmSg1kZHFuBQVQnQHeW4qhw==
X-Received: by 2002:a05:600c:524a:b0:456:1204:e7e6 with SMTP id 5b1f17b1804b1-459f4f517dbmr14242675e9.11.1754639781007;
        Fri, 08 Aug 2025 00:56:21 -0700 (PDT)
Received: from [26.26.26.1] (ec2-3-72-134-22.eu-central-1.compute.amazonaws.com. [3.72.134.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bf956sm30081041f8f.24.2025.08.08.00.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 00:56:20 -0700 (PDT)
Message-ID: <c6b5067e-8ae4-44f6-83de-f098761608ba@gmail.com>
Date: Fri, 8 Aug 2025 15:56:13 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
To: Baolu Lu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
 <20250802151816.GC184255@nvidia.com>
 <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
 <20250805123555.GI184255@nvidia.com>
 <964c8225-d3fc-4b60-9ee5-999e08837988@gmail.com>
 <20250805144301.GO184255@nvidia.com>
 <6ca56de5-01df-4636-9c6a-666ccc10b7ff@gmail.com>
 <3abaf43b-0b81-46e9-a313-0120d30541cc@linux.intel.com>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <3abaf43b-0b81-46e9-a313-0120d30541cc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/6/2025 10:41 AM, Baolu Lu wrote:
> On 8/6/25 10:22, Ethan Zhao wrote:
>> On 8/5/2025 10:43 PM, Jason Gunthorpe wrote:
>>> On Tue, Aug 05, 2025 at 10:41:03PM +0800, Ethan Zhao wrote:
>>>
>>>>>> My understanding, iommu has no logic yet to handle the egress control
>>>>>> vector configuration case,
>>>>>
>>>>> We don't support it at all. If some FW leaves it configured then it
>>>>> will work at the PCI level but Linux has no awarness of what it is
>>>>> doing.
>>>>>
>>>>> Arguably Linux should disable it on boot, but we don't..
>>>> linux tool like setpci could access PCIe configuration raw data, so
>>>> does to the ACS control bits. that is boring.
>>>
>>> Any change to ACS after boot is "not supported" - iommu groups are one
>>> time only using boot config only. If someone wants to customize ACS
>>> they need to use the new config_acs kernel parameter.
>> That would leave ACS to boot time configuration only. Linux never
>> limits tools to access(write) hardware directly even it could do that.
>> Would it be better to have interception/configure-able policy for such
>> hardware access behavior in kernel like what hypervisor does to MSR etc ?
> 
> A root user could even clear the BME or MSE bits of a device's PCIe
> configuration space, even if the device is already bound to a driver and
> operating normally. I don't think there's a mechanism to prevent that
> from happening, besides permission enforcement. I believe that the same
> applies to the ACS control.
> 
>>>
>>>>>> The static groups were created according to
>>>>>> FW DRDB tables,
>>>>>
>>>>> ?? iommu_groups have nothing to do with FW tables.
>>>> Sorry, typo, ACPI drhd table.
>>>
>>> Same answer, AFAIK FW tables have no effect on iommu_groups 
>> My understanding, FW tables are part of the description about device 
>> topology and iommu-device relationship. did I really misunderstand
>> something ?
> 
> The ACPI/DMAR table describes the platform's IOMMU topology, not the
> device topology, which is described by the PCI bus. So, the firmware
> table doesn't impact the iommu_group.
There is kernel lockdown lsm works via kernel parameter lockdown=
{integrity | confidentiality},

"If set to integrity, kernel features that allow userland to modify the 
running kernel are disabled. If set to confidentiality, kernel features 
that allow userland to extract confidential information from the kernel
are also disabled. "

It also works for PCIe configuration space directly access from 
userland, but the levels of configuration granularity is coarse, can't 
configure kernel to only prevent PCI device from accessing from userland.

The design and implementation is structured and the granularity is fine-
grained, it is easy to extended and add new kernel parameter to only
lockdown PCI device configuration space access.

[LOCKDOWN_PCI_ACCESS] = "direct PCI access"

Thanks,
Ethan



> 
> Thanks,
> baolu

