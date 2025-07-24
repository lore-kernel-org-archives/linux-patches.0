Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DBD273F9;
	Thu, 24 Jul 2025 06:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753339867; cv=none; b=bDchE/NOXdSRHZlm5QR4sT/QBkaQYplbMHiituKqcW6QqTd5gAdO79pQ5chm9MVSZBwLLsg7ParBxMOdh4dR2jEe6nlg07FHc0QnkDeQMZDwVrneRE/BMnx+7BF4mh3/UNKbH2TqfmYoU44jlFmh6Z9hYlDz8pgH7iSlhKeNN/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753339867; c=relaxed/simple;
	bh=w0X0br7o2eWaC/sCuDPbuNtjMrXI9dlkmLAYFCHsKxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k0PgkO+7lqkuB0JLlsyVVqkkQvYdCa3iKvVT7bjrTB0lg2PZc3HpiVv0zv8LyqN177LWkOH70UJhCUPGZiu2xfO2RP458edLQ+zj0VMoINmu1l+y2NLuNZaJ56GGKjTACyhkmCwBHMGDEaF+ZkTU/yc+GvVpQwv1dxVhS6ahZMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xy1Kov0k; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xy1Kov0k"
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-4537edf2c3cso5902585e9.3;
        Wed, 23 Jul 2025 23:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753339864; x=1753944664; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yzVCG5SoHn4Tr6BCxb/1N9GpLGi9jl777U0laKdYkLA=;
        b=Xy1Kov0kwcLFFBRuL+WrmeriUznodUADl43e6hIYCWj2xAoTXjp+Xjc3otkgtO/Oz6
         g66EAcr9zvVkFQd37pKwHAOcm/g5I1FkUAp7Idu0gM2gyGGykGKeLocp1QB6ZhrHx/gU
         ztwvhCdMF6COazyhpI1odNJUrLEVItPapPQzGP2JzQVC8BxkeZPKQDDd2/v8O6EvJ1yv
         lB+cjWdj3sXEHm/ayRjIXn2UJeH811gMouF3aN6214TnaWQQ+SzwAb8JO8xeI4ed9wUM
         WR/L6VSyb+xgCLaP65FiEPYXgLZiBXZonEMVoMYwxmo/JvtoigU3JuBEjn+pC9QSTdPS
         CjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753339864; x=1753944664;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yzVCG5SoHn4Tr6BCxb/1N9GpLGi9jl777U0laKdYkLA=;
        b=fW86RjTr3ogXQ/Hyjy/UN9ucRa69v0gZMv9MTJFUb9kIQUHoW9C83igyDjBvayWw8D
         bTMPjfn37qz06BaeVd7Vi7QTNonSuNqMUJS+V/lifQZzVjatvu/pae3h529VZMbn+Asu
         QGdZX+TjUu+a4bO5yBfyyVZtp3ljEalHJdvAUANuiQfSKUMVgPxzvVcx8EJSt8I1nyh+
         gv1GLdBQ3+hgeIwLRESczjt/yhqqQy8XV9l45WNMPwryjwPiKEmufPZ5z/TRdT9lrG8m
         sFBi/i25m9rZ+8ls6oYElwx9BZU7xyXG3w4WL064vvRxHHCA6lVH8jktiWszi/L4Bvn6
         ShDw==
X-Forwarded-Encrypted: i=1; AJvYcCWOpikr7zRFgo7rq+skPyontN6ZJVClHyhNE2quTT3eSF3fPXy7v+0tu4Nss6guIcwhNkgzyctH@lists.linux.dev
X-Gm-Message-State: AOJu0YxnJ/AImf10imEJWOLsOPxmId5Gn2RmKMF7aoO6tnio260W31vL
	0wpjoy/gJeoJlbWg0kPOR7XUl3TR4iDh37aw+tT32JzdzxIPgkIUi1Rd
X-Gm-Gg: ASbGnctoikhdQtzHzCAFZKYw7iBi/LAUMBvN+gi9GxvRxms0kpymDml5l8o9sp3H3JL
	z+Y8KA8mBYg+pYXXQAX/cqTC1CZAGoilt0Q8vkmgo3ZfZ73yCFmh4ahaMWvMHYRGq0CRDKtHa3I
	cm6osJSvfwv8SMbctpxQbhaWReF+ARABpiltIZvRVrDfst0PynVkFJz4NK08IaIHkHuWMV1Njeb
	CsLBkcMY3ZorAdJtlvFTIRcq7unSKSTeB3hRyL2Cqt/vlm8/Gw3daCy4AR3/w2gOGcgT76iBtv5
	q2RxNyYThd7YQNq308Mhe0N1IgYNqr5XxkyLOPBL4uAm5TiYkyW00ALMEATBdBCvBH8sa9/VqKH
	w8ba4lIAidfek80SkwpbYkdE05vSSU2i5OWdJKCsxoo97gnFj3oYLQW8FxA/mAPjyLVkY4FL+1H
	Lh5xBWM8oManhZaA==
X-Google-Smtp-Source: AGHT+IE9DAuzXlfO0T8BGbEaaDzrFKFbm9v9bayHfXRPMGOtvkB3z1CVZtyVEbYlFxT1eRAuNH/DWg==
X-Received: by 2002:a05:600c:1e26:b0:456:25e7:bed with SMTP id 5b1f17b1804b1-45868c97accmr53096245e9.14.1753339863187;
        Wed, 23 Jul 2025 23:51:03 -0700 (PDT)
Received: from [26.26.26.1] (9.126.207.35.bc.googleusercontent.com. [35.207.126.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcace54sm1166324f8f.45.2025.07.23.23.50.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 23:51:02 -0700 (PDT)
Message-ID: <4f7e4bfb-1bc7-4c87-a9f1-8c8b6ee9a336@gmail.com>
Date: Thu, 24 Jul 2025 14:50:53 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 0/4] Disable ATS via iommu during PCI resets
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, rafael@kernel.org, lenb@kernel.org,
 bhelgaas@google.com
Cc: iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
 patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
 helgaas@kernel.org, baolu.lu@linux.intel.com
References: <cover.1751096303.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <cover.1751096303.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/28/2025 3:42 PM, Nicolin Chen wrote:
> Hi all,
> 
> PCIe permits a device to ignore ATS invalidation TLPs, while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out: e.g. an SVA domain will have no coordination with a
> reset event and can racily issue ATS invalidations to a resetting device.
> 
> The OS should do something to mitigate this as we do not want production
> systems to be reporting critical ATS failures, especially in a hypervisor
> environment. Broadly, OS could arrange to ignore the timeouts, block page
> table mutations to prevent invalidations, or disable and block ATS.
> 
> The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.
> 
> Provide a callback from the PCI subsystem that will enclose the reset and
> have the iommu core temporarily change all the attached domain to BLOCKED.
> After attaching a BLOCKED domain, IOMMU drivers should fence any incoming
> ATS queries, synchronously stop issuing new ATS invalidations, and wait
> for all ATS invalidations to complete. This can avoid any ATS invaliation
> timeouts.

This approach seems effective for reset operations initiated through 
software interface functions, but how would we handle those triggered by 
hardware mechanisms? For example, resets caused by PCIe DPC mechanisms, 
device firmware, or manual hot-plug operations?

Thanks,
Ethan
> 
> When a device is resetting, any new domain attachment should be deferred,
> until the reset is finished. The iommu callback will log the
> 
> However, if there is a domain attachment/replacement happening during an
> ongoing reset, the ATS might be re-enabled between the two function calls.
> Introduce a new pending_reset flag in iommu_group to defer any attachment
> during a reset, allowing iommu core to cache the target domains in the SW
> level but bypassing the driver. The iommu_dev_reset_done() will re-attach
> these soft-attached domains via __iommu_attach_device/set_group_pasid().
> 
> Notes:
> - This only works for IOMMU drivers that implemented ops->blocked_domain
> correctly with pci_disable_ats().
> - This only works for IOMMU drivers that will not issue ATS invalidation
> requests to the device, after it's docked at ops->blocked_domain.
> Driver should fix itself to align with the aforementioned notes.
> 
> This is on Github:
> https://github.com/nicolinc/iommufd/commits/iommu_dev_reset-rfcv2
> 
> Changelog
> v2
>   * [iommu] Update kdocs, inline comments, and commit logs
>   * [iommu] Replace long-holding group->mutex with a pending_reset flag
>   * [pci] Abort reset routines if iommu_dev_reset_prepare() fails
>   * [pci] Apply the same vulnerability fix to other reset functions
> v1
>   https://lore.kernel.org/all/cover.1749494161.git.nicolinc@nvidia.com/
> 
> Thanks
> Nicolin
> 
> Nicolin Chen (4):
>    iommu: Lock group->mutex in iommu_deferred_attach
>    iommu: Pass in gdev to __iommu_device_set_domain
>    iommu: Introduce iommu_dev_reset_prepare() and iommu_dev_reset_done()
>    pci: Suspend iommu function prior to resetting a device
> 
>   include/linux/iommu.h  |  12 +++
>   drivers/iommu/iommu.c  | 180 ++++++++++++++++++++++++++++++++++++++---
>   drivers/pci/pci-acpi.c |  21 ++++-
>   drivers/pci/pci.c      |  84 +++++++++++++++++--
>   drivers/pci/quirks.c   |  27 ++++++-
>   5 files changed, 307 insertions(+), 17 deletions(-)
> 

