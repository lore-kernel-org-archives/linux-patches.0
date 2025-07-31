Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF8472601;
	Thu, 31 Jul 2025 01:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753924270; cv=none; b=BgdNIDNW+QIoreewuHZ3mkm0+LzoTAiWGOPEEs34ygL4CaHzTVTU1WIWSFqCVjTbWi4ZXh7S+Qcp8iq+m9b3Jo3dQpazHw8DVpJkoOWjFMCoBuueKTMSDv/ZOYVAriWbvTjLkcK10DAvpr7KEdPTF08bJTszoIxGKQiR6/9dAx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753924270; c=relaxed/simple;
	bh=n8iDS1RpoPyRX/SV8PZbQm2pUtZk45w8CetxLYbszh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DZmSsxAogsfLjoZyFCH7V7brhn/KS+xhuwQebQK7BwBUx5RKu0xlHpjab6AjBQ6apOGtjnI3oSLlkqU5H5l+KvdXhqxGT9hqUSayZjiQcNmnGESGvtOeh72/aV+Vri4G9ztFVxaUju0HJfFjzkQ0YuxxXojonLIa9QVLgPkCFbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iF7pQW1d; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iF7pQW1d"
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-45892deb25bso2548205e9.3;
        Wed, 30 Jul 2025 18:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753924267; x=1754529067; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kXpCg7fFUSCjtaBdVRkAIltng+73iOIw95qBFbgU4OY=;
        b=iF7pQW1dEpTlsHSpqhIWHSkl3v3+wE3GMMtrfgUeqMwD7npKSR550N0LcwTDUOuZuA
         KLPbHkOytf/uQdb2KmsHdMgqwiBr1ZQmnlgWOoR0sfjRjBbiZrKZ4+RzfgB0HVjQF9f4
         KZbZuqPhK7zkjQOKJcUR55TEpi4Gc4KTj6L6MzIHwSEpZPwwv+tUCHRddjOecgCwX/rw
         mAzzj825z3Lx2SmfuUKsaIHfPLMFA9gS3r7jFx70ad0Jpz2AF06lpx8w+23tMApazG0f
         n6CyM1qNaeBhF7IpZEp3WyGAxXs/8J11OinLGmHi0au0ZiyDG7B1eZ1oynxL2/r24Zvm
         aENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753924267; x=1754529067;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kXpCg7fFUSCjtaBdVRkAIltng+73iOIw95qBFbgU4OY=;
        b=ZiUazfxiHNHhYVnkw0PFwgo4xmGVoX4vDn/v/t2mi4o9zipTdJhrpOzl7HF7tevJdS
         juiLlUorrnTyE3vlDd54u+ncB4Zm4C54sP2M9tduLM/0u5mh66F0fxaTLmVYCrG80a6P
         ojnVzgcZfdF6g9qZmN8JeNJP8jYVTEoXkv8Aa/R1RtQ9Q/4TjwCzo6ZYP/VkzSHWOo0K
         WlMcQfnY4nTVrqrAvEz6/P/XzN+suReXOWyQKoGIcEKVxLrXpfg/BF3SxZRqWSP2R6jE
         RsFeGNIS62vRZKqPxNSELM5eyG/KDw5mnqNySFc3VgOeDWO8ugfCrY4G6hQEtaWpkJgF
         oOkA==
X-Forwarded-Encrypted: i=1; AJvYcCV4t0ZkPnx9ypAJBT2fJKEb+WlFw48o4sD/Z4WNhaXcTrEUZd/JwAiopb13h/HtoGNdsytATzHSgw==@lists.linux.dev, AJvYcCVzxmp6YZhmfy+qoi7qBgawZaoJ4bqtXMuQAz6d5p1HOC9TJziYQk3KOvM5xoMx+8idHTddDg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyKZgtuwYgnVYy+Q1cE9BNzEEHr4CWH/5dWcwD1oTmv5iZVx2EY
	G/SMm5KNGzFh56+ySgFqYwATIfy7yOXfKgsRpS5JYu7gmwUZYOKbMZtv
X-Gm-Gg: ASbGncuzKvqFy331/q2zUWNQY2GA/4mlEXpWnv8k8skTBh+pvKtNuhlhHZlPyy4c9oo
	1pN/9Agk2kOib8GM2lC9Ka2TQTqqvD5UVJg/IG43qGTop8ahNaMva48j5Wr6JSMoXTL780tqdhn
	GhPLXk0ajNx1Sv/aE44walcPCO/B1DqbWUmNqurm7Z0DNxgq0f1hzan/gGZExYU0PFXYrBmJbdq
	84wqb0FiwSRNmbBBxEwgMwy8UQe7Rt/MBVtWtpnohyTNXn1xvky/ySj2AjvPdFLT3deWP5e1w5u
	5hItSbo79foaC1z+VO1MbkcgjIJFE3C4m2RzRIksnFsf9nUqQo62bFdcJpORCFXEaUBd/B/ANqC
	niUrXRflQGxShJHYmuYg5pqko8lrrv7x4WmAtlZtciUEEzL+6Xj2kt956XY/XIdruBWxpQWwJ4p
	5kEWYhWFfJgFhjRNdjpZs5xpcaVgSzgA==
X-Google-Smtp-Source: AGHT+IGeOhsBMERvvbOw6f+hFFGfN4gChqdxVvN8hhQLKCb/w62XE3iGf0rhBUe+NyG0AtkhK5k1Tw==
X-Received: by 2002:a05:600c:3b16:b0:456:19b2:6aa8 with SMTP id 5b1f17b1804b1-45892bc5940mr47464205e9.19.1753924266281;
        Wed, 30 Jul 2025 18:11:06 -0700 (PDT)
Received: from [26.26.26.1] (ec2-3-75-144-20.eu-central-1.compute.amazonaws.com. [3.75.144.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589edfcdc3sm7151015e9.12.2025.07.30.18.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 18:11:05 -0700 (PDT)
Message-ID: <f6fedc6c-9f3a-4ffe-adb1-38b4f1632647@gmail.com>
Date: Thu, 31 Jul 2025 09:10:59 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 0/4] Disable ATS via iommu during PCI resets
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org, will@kernel.org,
 robin.murphy@arm.com, rafael@kernel.org, lenb@kernel.org,
 bhelgaas@google.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
 patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
 helgaas@kernel.org, baolu.lu@linux.intel.com
References: <cover.1751096303.git.nicolinc@nvidia.com>
 <4f7e4bfb-1bc7-4c87-a9f1-8c8b6ee9a336@gmail.com>
 <aIOz1bzgfK9q0n4b@Asurada-Nvidia>
 <606f65e1-ccfc-4492-a32f-90343be654e7@gmail.com>
 <20250727162041.GC7551@nvidia.com>
 <d7543795-b172-4452-8789-e1c810d8075a@gmail.com>
 <20250729125953.GH36037@nvidia.com>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <20250729125953.GH36037@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/29/2025 8:59 PM, Jason Gunthorpe wrote:
> On Tue, Jul 29, 2025 at 02:16:43PM +0800, Ethan Zhao wrote:
>>
>>
>> On 7/28/2025 12:20 AM, Jason Gunthorpe wrote:
>>> On Sun, Jul 27, 2025 at 08:48:26PM +0800, Ethan Zhao wrote:
>>>
>>>> At least, we can do some attempt in DPC and Hot-plug driver, and then
>>>> push the hardware specification update to provide pre-reset notification for
>>>> DPC & hotplug. does it make sense ?
>>>
>>> I think DPC is a different case..
>> More complex and practical case.
> 
> I'm not sure about that, we do FLRs all the time as a normal part of
> VFIO and VMM operations. DPC is pretty rare, IMHO.
DPC reset could be triggered by simply accessing its control bit, that 
is boring, while data corruption hardware issue is really rare.  >
>>> If we get a DPC we should also push the iommu into blocking, disable
>>> ATS and abandon any outstanding ATC invalidations as part of
>>> recovering from the DPC. Once everythings is cleaned up we can set the
>> Yup, even pure software resets, there might be ATC invalidation pending
>>   (in software queue or HW queue).
> 
> The design of this patch series will require the iommu driver to wait
> for the in-flight ATC invalidations during the blocking domain
I see there is pci_wait_for_pending_transaction() before the blocking
domain attachment.> attach. So for the SW initiated resets there should 
not be pending ATC
> invalidations when the FLR is triggered.
> 
> We have been talking about DPC internally, and I think it will need a
> related, but different flow since DPC can unavoidably trigger ATC
> invalidation timeouts/failures and we must sensibly handle them in the
There is race window for software to handle.
And for DPC containing data corruption as priority, seems not rational 
to issue notification to software and then do resetting. alternative
way might be async modal support in iommu ATC invalidation path ?

Thanks,
Ethan   > driver.
> 
> Jason

