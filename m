Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F922AD32;
	Wed,  6 Aug 2025 02:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754446988; cv=none; b=BD0lATL8jOp+tVkFfQgYx9rEsgLEQMEWUSI3qYT8wCDQZlD5nxXcOx8E0JxM+zzbAeX3zC5hIZFKJEYHOV6yoBc6vtNZfPT1hyvfsrQgLRqVN+MBWvCmOJANEfa31qI5dg2hUwfbNKPGHmwXDp3XYoCZXnKSBZxc+wOlcoLwiPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754446988; c=relaxed/simple;
	bh=fj4IR7+zswA7sqkD0tTyy/4FI+cv+hYYunOLbsBKvbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bjSZN02EirdvvbOsBlvabHib/iEnmUoE6t8Ldg0DoPL8Bp2AVI6mMwVvj4hmwJOXY+E2xhvjwRGxjp8dSsEJ1Fpu6kU4+oxwokuGqX3Yjx62DL3pvZmoEZPNIphicE1AAbb+1hHDtb41FfooeN5hBmn43GckFsEDw75+A42DgTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mdm2Z/eL; arc=none smtp.client-ip=209.85.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mdm2Z/eL"
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-61571192c3aso6555349a12.2;
        Tue, 05 Aug 2025 19:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754446984; x=1755051784; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WV3i2vsHD5Tto+kS9SXpnp5IN5CWgKxnV0XYONltTEI=;
        b=Mdm2Z/eLHK/yiZcWxgH7B98RErVW7bpYSmV5bIzXPG/3M/yXjnnwBCXg4vzlM7owxX
         NanDFrVW12lF24KZbL12MGvGoTDpm+yq91k+zikMqUxpn6kQfjzuUjKPYvoAxKL59p9T
         0g4DYNxLgBEHFpAhFYAXd1RY5Ugt79SK14QQuHAZ3bcee5TAiWF3zJD25gxviXyEAtew
         w7C2Taw0yAuCYGF5x55b0b5oQYavOZZ4w0ipjARqM5ZMrR7rV71VN+1t2uarsmlOqgWu
         zXvzxADEy12VPEAGi4qHTRclJW8FN9u43N5aUbI89X4TFVcHnKAsJABLcKLpYwi/bjOJ
         HgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754446984; x=1755051784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WV3i2vsHD5Tto+kS9SXpnp5IN5CWgKxnV0XYONltTEI=;
        b=NTO9y31mgirNq3fZugnRhvSBCUJS6V6GIVw+GX5x+e7ZGM9xTQ2kg1mvc6rK/8acca
         CDBkx9adH81NRH2GmyLXB54JEHjquBOuHMId1Vc5WBs3pa+Tz4WW1eaO1fNUghlbFm+F
         DLeSZ0KypIi/YI8nVGysPpcFzf18aobYheMJGCeEiJIvYo98+YC7YoEOab+yw3I6neSe
         rbj5mZVdpYM87g4JIBo38QGVuOKlDAMpw4tmQPNJJTh2i4qJO0WBXf02cmHQYgV0byRq
         rE1fh4tHJ+M3Omj185t3/dJj1VCp0vg1yh7OX/Blt6z0kE5F/E5QweYXuB2f8gFC0P+g
         ycUg==
X-Forwarded-Encrypted: i=1; AJvYcCVZy4aGM1h30iLjRWcgNPa5D28UN4tfzZt9vVoTHGp2vw96AfGk8fRpVX0MQanTmfkWqRtqLg==@lists.linux.dev, AJvYcCXa5ZyABmsEUzx+92O3AUwwY4HY5+uFb/PwUK5rstl8Mx2esYzLVjIFe/Ix52xdNBqpU4RqNdqj6w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzW9Jw5f+Fcg7Ky2FnE3vUJXwoorbwcSuJ7UcN/0o5bUC0Z/s09
	Hd5l+A+ZapYLFlPKBh7WRDNKIFmPWhTiQ9a8BdQRMTXYKyvr7hSlukn9
X-Gm-Gg: ASbGncuaUSqu8MwIr1DvybTgVec7skQdopIU/Q7X1N/l/NSsMJOIkyeqtEosdfeGHeQ
	QMXwL8WzWHFqOTLbcJxdJeTs9aK3b9+j88QyqvlHonJ+6dYUXRDDRQY4YgZvL/dmlwoWJa6HZCi
	uvDGo+bOarjwU2yh5ikwq3c/8htIxLvE5KZI7tO9nfTcCCbo5cHI4R3ph8eI48lDeoptz8/RsX4
	woZz20WAfaPZklmJQZA8np+UmefIW+QLrYZedFlfjpvzjtB5Bbxv+UcMHPURN5D/xqMKRf+b9dC
	E8Ypc+mdu/pKrFhhTykR6y6Q/7zwb4dIwKZTTkp1tIKWNNPN38L6p9U72SJHGC6kYOAQ0vEQslW
	FJ43EWptwDXrEz86XyS/ahj4JY9hF6EA2+NF/PFbDRrYxYU5PrUd8cisazWT0ljYsImA9vpHt8s
	PgPUmMJVWOAFJWtSS/l1wZ6Zy9hys=
X-Google-Smtp-Source: AGHT+IHZJL3Gcs1UE3cxSDIkmf9wQXNttiL49vH8U6oL/UasUEDh5LoNJkxUN1wHF0UudVM2Mn4IhQ==
X-Received: by 2002:a17:907:6096:b0:af4:148:e51f with SMTP id a640c23a62f3a-af992a37d1fmr59140566b.2.1754446984286;
        Tue, 05 Aug 2025 19:23:04 -0700 (PDT)
Received: from [26.26.26.1] (95.112.207.35.bc.googleusercontent.com. [35.207.112.95])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a2437desm1012205966b.127.2025.08.05.19.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 19:23:03 -0700 (PDT)
Message-ID: <6ca56de5-01df-4636-9c6a-666ccc10b7ff@gmail.com>
Date: Wed, 6 Aug 2025 10:22:58 +0800
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
 <964c8225-d3fc-4b60-9ee5-999e08837988@gmail.com>
 <20250805144301.GO184255@nvidia.com>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <20250805144301.GO184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/5/2025 10:43 PM, Jason Gunthorpe wrote:
> On Tue, Aug 05, 2025 at 10:41:03PM +0800, Ethan Zhao wrote:
> 
>>>> My understanding, iommu has no logic yet to handle the egress control
>>>> vector configuration case,
>>>
>>> We don't support it at all. If some FW leaves it configured then it
>>> will work at the PCI level but Linux has no awarness of what it is
>>> doing.
>>>
>>> Arguably Linux should disable it on boot, but we don't..
>> linux tool like setpci could access PCIe configuration raw data, so
>> does to the ACS control bits. that is boring.
> 
> Any change to ACS after boot is "not supported" - iommu groups are one
> time only using boot config only. If someone wants to customize ACS
> they need to use the new config_acs kernel parameter.
That would leave ACS to boot time configuration only. Linux never
limits tools to access(write) hardware directly even it could do that.
Would it be better to have interception/configure-able policy for such
hardware access behavior in kernel like what hypervisor does to MSR etc ?
> 
>>>> The static groups were created according to
>>>> FW DRDB tables,
>>>
>>> ?? iommu_groups have nothing to do with FW tables.
>> Sorry, typo, ACPI drhd table.
> 
> Same answer, AFAIK FW tables have no effect on iommu_groups 
My understanding, FW tables are part of the description about device 
topology and iommu-device relationship. did I really misunderstand
something ?

Thanks,
Ethan >
> Jason

