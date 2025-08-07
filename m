Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D86A2AE68;
	Thu,  7 Aug 2025 01:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754530589; cv=none; b=D7GDEnRodKmlNn/FUD7kWZ4M17wCVKI9KSEO5ab+W1JputPmBOUrE2YNNKRh6wsRj4TpTqSsC9MFHYTWyJ9+fXnlvjjdUMDWfqNuK1VZiquenpjVt7GZ7niJlNL78Rv6jF4Tmhp0VYdMIzIVJoc3hk5xEH+nhpX+4wKgPPmmlZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754530589; c=relaxed/simple;
	bh=a3Fwgr9HGewiEAduBxs0Dv6nwj8SDOTnY0RCt9EnMRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nib7bguLVWYdBD62mC/zS0/Zu1gVRTLb7/qbJvmaGbcwmvmr0w41sSLR910cGrM61iJ/USPTI6AdC5FOZ8A9q7ZeB8e2ocMOi4UVE3U12/I2BeXXkkqKVU4Fiw8utmdFSprTZhf1EDgbj6egtZnIKa3gikonaIMCNd60Nm3W3fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ww+wwCgU; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ww+wwCgU"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-af925cbd73aso87179666b.1;
        Wed, 06 Aug 2025 18:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754530586; x=1755135386; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EvZyBa0d9zwF8Krdg127Vc4ZSyy75NCS6IjPrZt0iNc=;
        b=Ww+wwCgUGDYdkNS9DLVRepfnBg0VMRzYjKTbc5BnWCXzKwCP0RQmBayXlq1oDgNLj9
         DAso3/UP+0RA1RA7nzSItpACNnQhJjx21g/m/KoMzCwwVE5zYjtRn3/Zu04M3I3Pw0ek
         FCBqHkpUCmKgOC12u5WapKAVrRuDWxAJO4MNPFUHs9CmWvByaN0W+1Xr8OyeZ0rIvKoH
         cu2ooHb6JrC9TAcI2gVpviEyvmcYrmu4nzdBB0vfFJHjK3FCTGAY1vY/3QdyDMF6itRG
         Z9PT3hn2Ogy2qY167Xr+VXPu45HKi6Y8fNLtO6C5ZmixKl/1XbWp0wFhKs4mqNX9Q0Oh
         Ivdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754530586; x=1755135386;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvZyBa0d9zwF8Krdg127Vc4ZSyy75NCS6IjPrZt0iNc=;
        b=fu1DPHa+u4+zOBwWkUDM/SVhgCmUAYOajbndJ05tV3Rs5caBACNAls29C+2xAQou7B
         alDRQj/ievTQQBz+i2cYjUiSNqnmU/3Iu2XpyV3AHppcTzOMB2GeCOQvYCKkINLTp4g/
         9H3zYU5GNNB8ds3FLOkkKrw41Np91HJk90oaYw9+JuhjyT5my2huuooLJR8UdJC70eSS
         zC1MzkW/MR9gsswkYLC4GnIF+74o+Djir+Zsz1Zn2d1mZNkya7x78WPhJXudTQmF9SiU
         FOxZvQ9qCPKqnB78OHERE5qMNM2mPOOjfeNChVBuj5fXz00QlS/QrZOzx3KYksIi3tWx
         82YA==
X-Forwarded-Encrypted: i=1; AJvYcCVV+pBUSb9eBk2i4O8rOuqh0S1Zne0bXAF8p2nza7xiMaidcXsfnGWxWgvaP21nxBw0CL5RQC8V2Q==@lists.linux.dev, AJvYcCX3AIDQl/wiSYB5MmGaDKXpsVkWbvTPxUOoXB58gVYxYZeP+gTqB6XQrhyi/sVRqV5A6Wx3hQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxF5EjICHDmeHWC24FBEco/4r/Ah00LEYyOB4PnM2JHDb7J3pbr
	ltwa6jfmYLZsZ0qinRMFQGb5VFpEYfs5pXYMAaRkBcijF8Uqzbg0t6Xs
X-Gm-Gg: ASbGncsWVpDi6TNAZnJpj4dWqM+EZc03a1XnZ1vKzJYkRF+enaF+Uo3uceLjH94exW7
	1r7kf2T8osdAxQqbasjOxE8wzpq0sHXBrs41k8tJWMEhV14aiiUH7zEaY98ExoSVL4kat1NePf/
	FgivYYA3PjLNnk/odF6W4LKj0agBmRo+29rkLvQW1xWzlMo3Fwa3q55dutbldaTpfRwQuLhn9Qr
	nPw8ap/tvVP3OZlYsmtTcoOZyoC156uAUzx1NYHutjfSwxugMyADJv97mGwUYakhmHEhlII0sw1
	U+gsedX7UEcRlsTYPtVcLz6KsBW+l160ycGI+4/A/51OPVSzf74K7Pdmg+W5qa/Ik/rmdx7z5qx
	I3DAriaLT0DDeRQIjAcD1IgVsVm8UvMtEP5sWknMOeW/Jc7gx61uJm8veVbY6k7JWMxBRssXPNE
	iw3xQ9K+SPYqlmeO855zOixURLqUE=
X-Google-Smtp-Source: AGHT+IHtu3Fkk1LgLkO8BsEW8NZyBGoH77/DdhJoytkr88G9xzLy08mBwjZkN1IvATcmUxPs/i4fgg==
X-Received: by 2002:a17:906:6a1f:b0:af9:4fa9:b104 with SMTP id a640c23a62f3a-af99045bbcamr492652366b.45.1754530586329;
        Wed, 06 Aug 2025 18:36:26 -0700 (PDT)
Received: from [26.26.26.1] (95.112.207.35.bc.googleusercontent.com. [35.207.112.95])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0a3cecsm1201335566b.53.2025.08.06.18.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 18:36:25 -0700 (PDT)
Message-ID: <3035b903-66c8-4fbe-8921-562e953143b4@gmail.com>
Date: Thu, 7 Aug 2025 09:36:18 +0800
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
pci tools such setpci accesses PCIe device configuration space via sysfs
interface, it has default write/read rights setting to root users, that 
is one point could control the root permission.

PCIe device configuration space was mapped into CPU address space via
ECAM by calling ioremap to setup CPU page table, the PTE has permission
control bits for read/wirte/cache etc. this is another point to control.

Legacy PCI device configuration space was accessed via 0xCF8/0xCFC 
ioport operation, there is point to intercept.

To prevent device from DMA to configuration space, the same IOMMU 
pagetable PTE could be setup to control the access.

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

I remember drhd table list the iommus and the device belong to them.
but kernel still needs to traverse PCIe topology to make up iommu_groups.


Thanks,
Ethan>
> Thanks,
> baolu

