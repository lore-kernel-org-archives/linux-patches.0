Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EBB1C8631
	for <patches@lists.linux.dev>; Mon, 15 Sep 2025 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757946736; cv=none; b=M8hrVEC1S0eoUlnFZDxQ8MzDF4/eU+Xyg4NUvpNUU96z/0OqTcpMBx+RsmpecW7PcKaTuyzfD7yPO5L4mrspVzt/75wM7Ng1Vh+LUHHlpYMoo4UHHBFhXVRbjWbm5tuDz1Xy7/eGZw90gCQZey8xJb4bJV7bFC49QM+KaRmql3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757946736; c=relaxed/simple;
	bh=jkhBmwEWgExuz1omsIkqNe0kpbi2sCvXXyGnjOfUSxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2QT4IsmFaqgnKc0y5vRa+XxNkVso/QRQuhsTLeinE1fKTmxt0wf4cch0JyXU3M5XqSxUNX8o1vQRYNWQUXA7FRYIVpd06CgzDgGwgHfo20h8I7T6/NmIaCCJQD0j3VR94XJzcM86/Q0H12avFAu1x07SnMvCZQJMYpjV+KZq30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQE8u7WY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQE8u7WY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757946733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aMcQQL6ctMeg3ZJ3cGBnYeUoh99uDNZTCO2BZOovfjI=;
	b=HQE8u7WYVsJXWwocQGOcT+xGM4+iLjl7Ip77W2pL3c8EEJ6ycw+wDN4zz4YpjfNd+3vYMB
	KYErRKFu33gD54zwvI1+GiqSjdfJJKlx3CnqMy1WpWgj/deYjlbVVWV0CelJCFxb89mymk
	BNHRRD7Olm/p54px5Jj77yISpm1sYB4=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-aUOyBW7tMnOYVP3R93EYgQ-1; Mon, 15 Sep 2025 10:32:12 -0400
X-MC-Unique: aUOyBW7tMnOYVP3R93EYgQ-1
X-Mimecast-MFC-AGG-ID: aUOyBW7tMnOYVP3R93EYgQ_1757946731
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-62cc6f82436so908174d50.3
        for <patches@lists.linux.dev>; Mon, 15 Sep 2025 07:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757946731; x=1758551531;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aMcQQL6ctMeg3ZJ3cGBnYeUoh99uDNZTCO2BZOovfjI=;
        b=uVM31GaFI8YaRDMUSTu2ui5fZI7ndaPeQGw0HXry1irjlLQaG36M+0aB5ezqD1Ystz
         cD5tGkKNEklQXe4kklMKHLqpvpoymDioJlPZ7sW2J4tbwASkkAKf6a8I61rCsZiRqB23
         sWGaegeITSWwlDfWvCeIrW+GTfe7pC8VFqrsNAEgkAiwo9zaS3xu4E/1wZctwbMm8jVi
         HQ5ln9UGj9NMS9HSBqRlnFOf5yAdfwALvs+aqMXl7ymrpJWccNCdt3vWBf537jP11HrZ
         NEnDXKYZDxOm3cg7OgB7J6StXmONTAdoYmajukXLu/buOT9ADCYoxYvFh7evxwx4aTUX
         n9eQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtgJCGKZecbVEFTJ0oMH6uf0Jeh/VF3ouKzQdlFz9Hu6NEBz4BhnEqhvAT0MG6b1vMZA7Lki/j@lists.linux.dev
X-Gm-Message-State: AOJu0YygGMgWldqXwkS5vDhr24De4ngbouE3NIVYaSescjbWJuOkkgTu
	1UxAEZzm+Rc4kzwzgCQlaUvks6gdH00pfgm03umbb5FbgRlk1tmjQeZF39r8g/rK0kcNwxYJcr2
	wf/XZAdDwmMvUvmW1vqFOTW3fV2lxiq2iak15iiZj2H2QwoiAS4mdZWB/SFk=
X-Gm-Gg: ASbGncsK77+LlHbjJf5YQYCfMjEIdAt5Y4iED+kEqKakzT5mwVqaHtkvkj6VZM9Ohd2
	JCmSeDVJuWqcv6HnlLwdXZvJ9ZnxmdiP39cIZcFBGandA3HF3gMo6GJFaHNuYLDg4TeMY9n17Np
	c7/6aEUPu/NkVakxexjLT+1QOYCGSV34Gx5bf9lqDdbbEFehOzoUeQlN1L8U1SbqHkL8kc1kQ5z
	t9lOzMuohv4FnE5EIlCdKBpiI1ckfQTEz08SFqDCJzNLO4ug3T9Q+OEsZp6IMOXPB/LR0tHdXeF
	AxK6kFzMF5+PnZd0OWcl8YY0xFrUjfMY5v8Ly9Af
X-Received: by 2002:a53:aa05:0:b0:615:7d8f:66ed with SMTP id 956f58d0204a3-627243538cdmr8359769d50.17.1757946731306;
        Mon, 15 Sep 2025 07:32:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/V0+bL/bskp22k8XnWmcAyP2OD4HiXiRPvDyo43+eFheTBQzEtJAc9iSkcCrfBIyEROc9CA==
X-Received: by 2002:a53:aa05:0:b0:615:7d8f:66ed with SMTP id 956f58d0204a3-627243538cdmr8359725d50.17.1757946730666;
        Mon, 15 Sep 2025 07:32:10 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-78ab368dce4sm4620586d6.38.2025.09.15.07.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 07:32:09 -0700 (PDT)
Message-ID: <f870603f-490e-46a6-8618-201c9550e5e2@redhat.com>
Date: Mon, 15 Sep 2025 10:32:08 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/11] PCI: Add pci_reachable_set()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <20250909210336.GA1507895@bhelgaas>
 <3d3f7b6c-5068-4bbc-afdb-13c5ceee1927@redhat.com>
 <20250915133832.GE922134@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250915133832.GE922134@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _jSOFWVZK3Ndlhv3ACLrHW_xMKvoMhfp1ilrNEmlF_s_1757946731
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/15/25 9:38 AM, Jason Gunthorpe wrote:
> On Thu, Sep 11, 2025 at 03:56:50PM -0400, Donald Dutile wrote:
> 
>> Yes, and for clarify, I'd prefer the fcn name to be 'pci_reachable_bus_set()' so
>> it's clear it (or its callers) are performing an intra-bus reachable result,
>> and not doing inter-bus reachability checking, although returning a 256-bit
>> devfns without a domain prefix indirectly indicates it.
> 
> Sure:
> 
> /**
>   * pci_reachable_bus_set - Generate a bitmap of devices within a reachability set
>   * @start: First device in the set
>   * @devfns: Output set of devices on the bus reachable from start
>   * @reachable: Callback to tell if two devices can reach each other
>   *
>   * Compute a bitmap @defvfns where every set bit is a device on the bus of
>   * @start that is reachable from the @start device, including the start device.
>   * Reachability between two devices is determined by a callback function.
>   *
>   * This is a non-recursive implementation that invokes the callback once per
>   * pair. The callback must be commutative::
>   *
>   *    reachable(a, b) == reachable(b, a)
>   *
>   * reachable() can form a cyclic graph::
>   *
>   *    reachable(a,b) == reachable(b,c) == reachable(c,a) == true
>   *
>   * Since this function is limited to a single bus the largest set can be 256
>   * devices large.
>   */
> void pci_reachable_bus_set(struct pci_dev *start,
> 			   struct pci_reachable_set *devfns,
> 			   bool (*reachable)(struct pci_dev *deva,
> 					     struct pci_dev *devb))
> 
> Thanks,
> Jason
> 
Thanks... Don

