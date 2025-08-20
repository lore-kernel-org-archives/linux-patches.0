Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C425C804;
	Wed, 20 Aug 2025 03:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755659945; cv=none; b=LnZmPp8iXRMBRPxqaBSpi31WFafW6m+roRRAnwDF0iZ10pyN60ltqOhQDmsYtShZxzomV29bcJQ28MA7bL3ivr+0r5V7WUwGqMs2T4e3padI+Uj7WUTakHwMMnieoqIm/nieaiJ1I1daM6O9Of4VEaOcRpj+mReKAooHPiKY1dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755659945; c=relaxed/simple;
	bh=VxNrcNs0+HcvFMuKWSGBXGXSfd8y+whfhfnRdUacxr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UB+38Bj8pvPAsUsS6i3UMOkPdz15syJV0Ixn9abCZKGZbdOp+56DYgA0gn7+6eSTGneNV6U16hqSQi0xZifEuUtrwWrvm8ktv+XxD3NfJPpupbN8FdAF5NM1F+TODQL6kkLahzWrYzu6E7M9dyrkLCczlb3DuyUErsDeSfuvo7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AJNyJDdv; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AJNyJDdv"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-afcb7ae31caso1081678166b.3;
        Tue, 19 Aug 2025 20:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755659942; x=1756264742; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/vdg4dKKl5Y5qxmdvIci/v8EsYo7STve3t3ZtY/n9Z0=;
        b=AJNyJDdvVH1yqA2IMK+urcZFyy6EdpDsw0IqtitgscWpJINViXMHNZu8gs/usDKj0O
         FI+FJymZfeBUZrpg1ZYUN9cG9INYTlzD/yh98justpDMnvGyYgaTz3JIbSMf63Ze6vCL
         1cfZjSze4Fu93FcLpYBRIZqrM/RtYR9XcQb9F3Jf73HtOz+Qo9e/1A15TcVHey9qDbVb
         5KWv1blRs7yIj5efm0rLPsySUYHceQ7W6hNpgiduXl6z4td396FXvDyl3sjqOy5IU2so
         2X4WvMtxQlV1GaTDHPELn1d3nKmOJHTw35/E83VsWT8NQIDUi0XOkUi4rl+NlFOYgft1
         X00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755659942; x=1756264742;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/vdg4dKKl5Y5qxmdvIci/v8EsYo7STve3t3ZtY/n9Z0=;
        b=D8qpqXuFAgH7qg+6itatOBk6t+IYgQHOf/r3ikmWNp07QBKvz2N5YNE9FMV9YycFfV
         twsss3wQuvK64LnS5+hqzdi856BekY7dyXafe4AE5h3MdpgYh6sao/ftE4aOWYuEaG0J
         2xHzh0AYdi9wFhf0Gbhl8L6RiV4QkIYAIm+kgPLQ9iS7BC0EY2tRYvtjqrXCAdBHbZjj
         urIixp00OvrTzkd21N0QyVLasreLOgaq4hU6Zi0Swhey2WazJgxA5mcKkvgKi6Ea9xvM
         +/8nTNAPyfEY5AFDeYtkRH4pX3VG/jRY0Poi9Hl7Go6jMRUk0tRKQ8EmcUeogbJEQ+rJ
         vRZw==
X-Forwarded-Encrypted: i=1; AJvYcCWICrb6k/vuArzMOTUZgfVgXoCATwLb/HIaVaXUGSEqMrCRt47WKgsnDlmWRK5KRHKnNggBTQ==@lists.linux.dev, AJvYcCWvm+HCLXzxhOCzjSfrRMkqXDl2UImFTEeOi1jtPsO+skHQSDEewccZW3kujwioyYTHBYRTLMz+jg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyHhI/PeUIxSx0l2aPUQV2Em7IUXxPeWOdiDRLSgH4XKxjUM8wT
	/H0T1efKHHa1tw3K3Q+Kbd9rD1EEdpr4eiuD1G9okvOyMNz1eCLfOX94
X-Gm-Gg: ASbGncsr4LlQE1di1n5nsQ35UxB71lQczYcAL40gpkegwto9/SG3Zsh1qlvkrGh8pps
	IAiJTTj2Dh6J269+uDNvGoWiZPT9rQxj5hb2ccipe3nf+SwCz4F0BNsEJM1b4+VwYvdzVqoTajE
	bdGDmN4PwOfIyrFMBpbcOQqkIzzEHmP7fE5MUa7RULZ3bqtb77S8nr+9UPlTO8dbcSI1S+CNE4X
	JBR8DEuzUIpyPTiJiC+XmF2qRmlOLHeMDWTUmgHn4Laip18JNDVBetWCb7CcNFyIWRQVXH5e+Oj
	5rtBkMIA9/dzuKt+vUn++ctZ5KE8oI18vhfWi/ieb1Dh8bc9KZ2LMb0I+vkTDlrFt2N+C4wP+W4
	jjthXycJwwf1xYUYYPfu/nj2LulbiOpOkRS7O6GUBNUDHQIASGGRqHHAfv2FTvcP2mpHmn2hPEB
	8s+bGq0OTIIFK9MJn0i/uGT0X2Z1BL8UDnRA==
X-Google-Smtp-Source: AGHT+IEIwwlIwoTIiNuhUQ07/bBrVkoWwe0s7LnQYSy2POy+c888AvHzKbMqqWN1VrmqgpQIHAF1pA==
X-Received: by 2002:a17:906:6a1d:b0:af9:237c:bb35 with SMTP id a640c23a62f3a-afdf00e2e81mr95410766b.22.1755659941758;
        Tue, 19 Aug 2025 20:19:01 -0700 (PDT)
Received: from [26.26.26.1] (ec2-3-75-144-20.eu-central-1.compute.amazonaws.com. [3.75.144.20])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded52ea4asm96482666b.101.2025.08.19.20.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 20:19:01 -0700 (PDT)
Message-ID: <d6b852bc-328a-41af-b125-e250c72c0d22@gmail.com>
Date: Wed, 20 Aug 2025 11:18:52 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] pci: Suspend iommu function prior to resetting a
 device
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: robin.murphy@arm.com, joro@8bytes.org, bhelgaas@google.com,
 jgg@nvidia.com, will@kernel.org, robin.clark@oss.qualcomm.com,
 yong.wu@mediatek.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, thierry.reding@gmail.com,
 vdumpa@nvidia.com, jonathanh@nvidia.com, rafael@kernel.org, lenb@kernel.org,
 kevin.tian@intel.com, yi.l.liu@intel.com, baolu.lu@linux.intel.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-tegra@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
 patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
 helgaas@kernel.org
References: <cover.1754952762.git.nicolinc@nvidia.com>
 <3749cd6a1430ac36d1af1fadaa4d90ceffef9c62.1754952762.git.nicolinc@nvidia.com>
 <550635db-00ce-410e-add0-77c1a75adb11@gmail.com>
 <aKTzq6SLGB22Xq5b@Asurada-Nvidia>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <aKTzq6SLGB22Xq5b@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/20/2025 5:59 AM, Nicolin Chen wrote:
> On Tue, Aug 19, 2025 at 10:12:41PM +0800, Ethan Zhao wrote:
>> On 8/12/2025 6:59 AM, Nicolin Chen wrote:
>>> @@ -4529,13 +4530,26 @@ EXPORT_SYMBOL(pci_wait_for_pending_transaction);
>>>     */
>>>    int pcie_flr(struct pci_dev *dev)
>>>    {
>>> +	int ret = 0;
>>> +
>>>    	if (!pci_wait_for_pending_transaction(dev))
>>>    		pci_err(dev, "timed out waiting for pending transaction; performing function level reset anyway\n");
>>> +	/*
>>> +	 * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software disables ATS
>>> +	 * before initiating a reset. Notify the iommu driver that enabled ATS.
>>> +	 * Have to call it after waiting for pending DMA transaction.
>>> +	 */
>>> +	ret = iommu_dev_reset_prepare(&dev->dev);
> 
>> If we dont' consider the association between IOMMU and devices in FLR(),
>> it can be understood that more complex processing logic resides outside
>> this function. However, if the FLR() function already synchironizes and
>> handles the association with IOMMU like this (disabling ATS by attaching
>> device to blocking domain), then how would the following scenarios
>> behave ?
> 
> That's a good point. The iommu-level reset is per struct device.
> So, basically it'll match with the FLR per pci_dev. Yet, the RID
> isolation between siblings might be a concern:
> 
>> 1. Reset one of PCIe alias devices.
> 
> IIRC, an alias device might have:
> 
>   a) one pci_dev; multiple RIDs
> 
>      In this case, neither FLR nor IOMMU isolates between RIDs.
>      So, both FLR and IOMMU blocking will reset all RIDs. There
>      should be no issue resulted from the IOMMU blocking.
> 
>   b) multiple pci_devs; single RID
> 
>      In this case, FLR only resets one device, while the IOMMU-
>      level reset will block the entire RID (i.e. all devices),
>      since they share the single translation tunnel. This could
>      break the siblings, if they aren't also being reset along.
Yup, such alias devices might not have ATS cap. because of they
are PCI devices or they share the RID(BDF), so checking ATS cap
condition might be useful here to skip the prepare()/done() .>
>> 2. Reset PF when its VFs are actvie.
> 
>   c) multiple pci_devs with their own RIDs
> 
>      In this case, either FLR or IOMMU only resets the PF. That
>      being said, VFs might be affected since PF is resetting?
>      If there is an issue, I don't see it coming from the IOMMU-
>      level reset..
Each of the PF and its VFs has it owns RID(BDF), but the VFs' life
depends on the living of PF, resetting PF, means all its VFs are
lost.

There is no processing logic about PF and its VFs in FLR() yet.
my understanding the upper layer callers should consider the
complexity of such case.

While we introducing the connection of IOMMU & device in FLR(),
seems we brought some of the logic from the outside to the inside
part.

One method might we don't handle PF either by explicit checking its
VF configuration existing to skip prepare()/done() ? till we have
much clearer handling logic about it.

Thanks,
Ethan
   > d
> Thus, case b might be breaking. So, perhaps we should add a few
> conditions when calling iommu_dev_reset_prepare/done():
>   + Make sure that the pci_dev has ATS capability
>   + Make sure no sibling pci_dev(s) sharing the same RID
>   + Any others?
> 
> Thanks
> Nicolin

