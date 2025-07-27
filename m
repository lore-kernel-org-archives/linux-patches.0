Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C511419D09C;
	Sun, 27 Jul 2025 12:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753620522; cv=none; b=rmPWmb3OV7fvOfjVM7P+3w+XYl8XdFlbxVxzUrU28fJGkAdhyI89wPwxeDsAWrqzcQj+NcjLjhu/h+TQcS4559vzxqRRl5mndnWS1XzCX7o9rE4FmbMiTdB1weq2guepGBIkrxPa7PYBv0TdNyYtdwByiVPudBAaIxJlQN2vmyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753620522; c=relaxed/simple;
	bh=5q9r9ISVav2dz5XcKEk9jqfSVetd8J2R7nS/TEyhwJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T2TCVkiPf/IYCpo2FlKw6JyhneGfX952/apf+fr9RMx9ws6P2bloucOHSBhheBwsC1ItUWrfT7N5MUtJfjrna/5JdTLyaOgU2mTeDSB4MOjmeUySCuQEEUg2AEHMCgdcyUL/uBlnOUCLCYtR+4fzp11u2BDT+/5scglJ1xUHvYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WtTU51yK; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtTU51yK"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-3b7886bee77so116680f8f.0;
        Sun, 27 Jul 2025 05:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753620519; x=1754225319; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DRITpsqAlVQuup8a/seimyyXM3Zd5ZY8LDRlKD/FNoE=;
        b=WtTU51yKhrsSk0nKT/QGgxtVgTAOaD3DEqmwbwTIcp6pBkr6qZeysRuLEGyaGgxtc3
         C069fCUVyM5q+srTn3M1iL8TlChzFqYhg43if/Ssd0G72MpYg39+EHUgsmre2l/XzEBt
         avKJloVwuC7qps55uQL3tq3ZpWQku/n25i3UHO5jyYarAOTENZrZQ1Rls/DIBQOdPRsu
         YIkls+w+vh+B5T6yWuCNm/W2pm2pKdNzWDCiLRMSgHV5qzIdAx7kCXqa8mJ8Lc3CaOBX
         9JtPkxgRNrmIron/6sBV4lD+piehhAidDqnBQ2CLJJE1iahNLDbS4WyYOoLbkqSRv0U1
         C84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753620519; x=1754225319;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DRITpsqAlVQuup8a/seimyyXM3Zd5ZY8LDRlKD/FNoE=;
        b=EQO9PmccfIcHExf6JTg/ureII3Cs9+KpZhBaJb3cwt9defW/LbL66Km6J0Vt5JygKt
         2tEjwE8zsQ4uz5h7tirF34nyCQAZb5dJlS9VGghnMxceUW4dCxR8bYGkmr8STDfPpHOE
         nUQ6XSBdqRFfoMVWDMt7gqSUc8N+Keod3k9+DE8uvezx5o9IBZUo/hscv6wfmneR5ygg
         cJPUtEN+pqJvbTMG4Y8P42TxmfDlv3XkkarreEu2Jnuk58rzPdL+hqzaFD/CSKJt0GCN
         0c5034ho6ksVCknqB5jsRrMngdRpd2GJs94slzGP5P3Lh2BWD8UQ9Hxf6ehCJNQ9Z/Mz
         5fnw==
X-Forwarded-Encrypted: i=1; AJvYcCUqGKDi3LqlnIXdufH8iqEllTb44fIAgvwz+hAiNwP09UQ2A8OV0m/IrNmqsEqpX3GcClMlOg==@lists.linux.dev, AJvYcCXSjcvJWq1GuQQJAYUkYq9sNTMVHmUTcC7ihioXPOL+0Pt6zIiinEyPMOT/4xcQt7UQsXRaqRbAEA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzJ2CvRbuGuW744yWLPhrCsJVFfrYTLcm+zstwa4qD8vMgT8CsG
	Msru7YRbuarbVhNbgiyZiE11UcqfXaNB4yotqgJDiY7PC/kcAoLuMs6v
X-Gm-Gg: ASbGncvY8x9jE2gJvKXfhzEwLGaY0UYQGHVZ/HsHslEvOnYiAtqDQAuL4RaPu2gvzNC
	sEKkcy4gAZK/8qK40rSeItVtUf3I6isUuA2VZJY4/FM7m2Z7/kjbfeqjLISuCk26rDDSDlaOPTa
	ZQWXNx7ta/ACnr4aaeYocTFHFZURCRswHK2XzBiiTuS9/CckdoOSyW6/cmPcl4A3s/FwgeXbKYj
	siNBVvP/0uIOKUJyXRrQsisIW720u1+/SiZ8JV0FR8bWepKkLCzIf83i08OfEvx6d3turT7XYN4
	U0AeCgFXUcUIHI82sgYCwMlUpMA3NvdWk7FitmFPbNuG/hZbQzuRQLe78h4VKpUXr5PYrZxIXAW
	1GOt5DCVYyxBWNB5P32wqWBTbTCZtL8BrO/eK46WI27N96U2hlIQuXnzHEGre8wYZ202lOzOVk/
	fDWJNq0OiGiFcpAw==
X-Google-Smtp-Source: AGHT+IFmiWlnd15B310vYferxTJyy/4API26r1cry41N+RH+lI6moXaK617td6bWARvvVi+3eLyhTQ==
X-Received: by 2002:a05:6000:1a88:b0:3b7:664a:8416 with SMTP id ffacd0b85a97d-3b7765f4e98mr5424057f8f.23.1753620518744;
        Sun, 27 Jul 2025 05:48:38 -0700 (PDT)
Received: from [26.26.26.1] (45.98.207.35.bc.googleusercontent.com. [35.207.98.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b7883228dasm642513f8f.50.2025.07.27.05.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jul 2025 05:48:37 -0700 (PDT)
Message-ID: <606f65e1-ccfc-4492-a32f-90343be654e7@gmail.com>
Date: Sun, 27 Jul 2025 20:48:26 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 0/4] Disable ATS via iommu during PCI resets
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 rafael@kernel.org, lenb@kernel.org, bhelgaas@google.com,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
 patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
 helgaas@kernel.org, baolu.lu@linux.intel.com
References: <cover.1751096303.git.nicolinc@nvidia.com>
 <4f7e4bfb-1bc7-4c87-a9f1-8c8b6ee9a336@gmail.com>
 <aIOz1bzgfK9q0n4b@Asurada-Nvidia>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <aIOz1bzgfK9q0n4b@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 7/26/2025 12:41 AM, Nicolin Chen wrote:
> On Thu, Jul 24, 2025 at 02:50:53PM +0800, Ethan Zhao wrote:
>> On 6/28/2025 3:42 PM, Nicolin Chen wrote:
>>> PCIe permits a device to ignore ATS invalidation TLPs, while processing a
>>> reset. This creates a problem visible to the OS where an ATS invalidation
>>> command will time out: e.g. an SVA domain will have no coordination with a
>>> reset event and can racily issue ATS invalidations to a resetting device.
>>>
>>> The OS should do something to mitigate this as we do not want production
>>> systems to be reporting critical ATS failures, especially in a hypervisor
>>> environment. Broadly, OS could arrange to ignore the timeouts, block page
>>> table mutations to prevent invalidations, or disable and block ATS.
>>>
>>> The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and
>>> block ATS before initiating a Function Level Reset. It also mentions that
>>> other reset methods could have the same vulnerability as well.
>>>
>>> Provide a callback from the PCI subsystem that will enclose the reset and
>>> have the iommu core temporarily change all the attached domain to BLOCKED.
>>> After attaching a BLOCKED domain, IOMMU drivers should fence any incoming
>>> ATS queries, synchronously stop issuing new ATS invalidations, and wait
>>> for all ATS invalidations to complete. This can avoid any ATS invaliation
>>> timeouts.
>>
>> This approach seems effective for reset operations initiated through
>> software interface functions, but how would we handle those triggered by
>> hardware mechanisms? For example, resets caused by PCIe DPC mechanisms,
>> device firmware, or manual hot-plug operations?
> 
> That's a good point. But I am not sure what SW can do about those.
> 
> IIUIC, DPC resets PCI at the HW level, SW only gets a notification
> after the HW reset finishes. So, during this HW reset, iommu might
> issue ATC invalidations (resulting in invalidation timeout noises)
> since at the SW level the device is still actively attached to an
> IOMMU instance. Right? 

Yup, the situation is this: When the system receives notification of a 
DPC event, the reset action triggered by the DPC has already occurred. 
At the very least, the software has an opportunity to be notified that a 
reset happened – though this notification inevitably lags behind the 
actual reset behavior, creating a time window between the reset action 
and its notification.​​

​For DPC specifically, there is no notification mechanism before the 
reset behavior takes place. Surprise Hot-plug events likely operate 
under a similar constraint.​​ (while we do have good opportunity to know
a hot-plug action is about to happen after attention button was pressed
for standard hot-plug hardware, adding code there is okay for now).

​This becomes particularly thorny if an Address Translation Cache (ATC) 
Invalidation request occurs within this time window. Asynchronously 
cancelling such requests later would likely be problematic. Is this an 
accurate assessment ?

At least, we can do some attempt in DPC and Hot-plug driver, and then
push the hardware specification update to provide pre-reset notification 
for DPC & hotplug. does it make sense ?

Thanks,
Ethan

> 
> Nicolin

