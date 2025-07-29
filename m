Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com [209.85.221.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73252AD2C;
	Tue, 29 Jul 2025 06:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753769813; cv=none; b=EOqPD/9qvvfk+UgYR0DipBhhPUO4BJNsA4mPQqjUPQ3X9p+9oMD65Y3DHEiCRUnd7myw51lJa+IdGts9GFjcbSFmM+CEqe/KfWerfO1xrhOHvluyuMGnaFLatQCrzz+0T1bBxyD10GCwNtthwXj09QGKRfNo+klrQymOaVxPvZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753769813; c=relaxed/simple;
	bh=wTnoAzg5SgQHuoVQdRdLoINjYsqmiKdXxCqy4IBJh4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f6H3vbWYN7iIWZj5sTJjWCedoHB7qMhVr4XQ1qrhP+7Fbi/xDdKuMYxn0bvw8FQEJilxdGYu05JrKRzeTv3H86aAzf/CCBCZJjQDEoA6oLDWvUs4ATt4B2cLGsdaQwwYUcRHjsFbZVUl6ET6Hhq3D3//3eKCfSlKt7bdVCj/Mps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nhlwcFnA; arc=none smtp.client-ip=209.85.221.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nhlwcFnA"
Received: by mail-wr1-f68.google.com with SMTP id ffacd0b85a97d-3b78d729bb8so677236f8f.0;
        Mon, 28 Jul 2025 23:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753769810; x=1754374610; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EuJHExjp9oNluHLopPDQOcmTjqGBwTBeOtcBmZlA+3w=;
        b=nhlwcFnAJgU37p/2lFq/nSGD25bnPpdQimVxB1Hn/kHYenmb7Y9yulVJnrHW+R71nf
         BAlmNbTQQolYkhowbGymgqWGfhD7uCz5/HTO4eK4CMX6jNgX8LEYKUfkiJ45TdE01oVB
         HbIOo2Ar3zkShcOGC9FiO/wA+S4ZVXBe1/yALlhfpqGhYuzt6vrwq9hhy4YTjQLeIZxi
         YlWK2hBuBbE1TlY0+N7jcOYCD1d2a8Gak/hHnZKDajQ3n2v8jWQ2iVmfS8sNm2e+rfdM
         vi/cdK+P3cqZCp9fjF+OzQsUBdnzmrCvUTALlNpIuF/UStVYBGVIWnJ9qeQYydI60viP
         bexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753769810; x=1754374610;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EuJHExjp9oNluHLopPDQOcmTjqGBwTBeOtcBmZlA+3w=;
        b=rcoiwXnoGY7nLw29hnQnRSmBI8T74IzOTXy86lYSFzIpPdyFrYBCscph7RxvKr9Z/C
         oc6AeWvcVqDKXZsi9Ouiy+mbUXss4gY3g7z189ob6f1qyQKvNer1lXDuQSP2PNmxP0kT
         fOYikKiyGu3P0NkWkFB1BZKTdXOmC59wvnd766j7TAkOngfAtaME0GWQCY7kBqkvnKxE
         BIAutFUQRWwdhwpRyZspInfFRCiswZUhAu9xRgvU4o9OSKf8X+JajsomBUAAAUtwkvm2
         NFoeIVWfFSE+sTmLPimHvsNO3kTU1ZFT4JoIWr+bOfaOwrMmdQHPiRWCkPLkRHiv0Pkw
         q7sg==
X-Forwarded-Encrypted: i=1; AJvYcCVh1788KlnyOduVWGTMlVSrSH9eCZ9Zr9i5Eo6EyyCbKJHzBA2UG6n3MOBqfptNc8iDeZroiHKt4g==@lists.linux.dev, AJvYcCX4AMHtMgF/5+xo/yjT6zRMMEEph2x5gIdI9BVMCBaihJP8PQJOOCQfoYQBVTNvcdrQ3Urq0A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwCOhE+s63XOgoDoCvvlCiP9SY/pno4331RbZLZ7N9lxk9AGCRg
	m1lkzoh197Xq90Vf75nPUYSRUXSVtW10D5JKu9/mDV+zG/O0j4L8pipG
X-Gm-Gg: ASbGncv2zll7QFcpy95Z+Nl8UI4oAc2EPrU7lZrU44vlbKXr6lNtN2b5BRK+tnIFJTR
	KS+vAXY4ZfPr5aUtiWcg1prC5alBnJJed/6HlroLomnDVDoOtArviE4a/HO9qzhoHkubQExOWyV
	ZLzzfFxgepD2N07590cHM4W+LQcVEJhpyRvYtoYZrpG1Ox/nLv4xpkqOM5ysciSiBzaCTNgcuYj
	HL3gbNPlXMr60VjrwcKc7JqMg5npZh2A+r/g4GdLBh1/KGfEYxlXlVbH3CimEOsv7xKHZuq8Iwa
	buBhTs+xZyc/5oHfdCJLxGIpJHYOsPUrOszRcixmN1WwKnEoeH3GWvUatL0je3ZFa6699JXMcUt
	12xKb4QKgGZADdiZDDlXRSvarZj5ak8Jc/dKanjK/SNRJUo0FBZzcEX/udsEZnI+olAKbSFk3Ga
	I0ZP6telBRf+9vIlf5HaYTCyXijp11BJmOUSk=
X-Google-Smtp-Source: AGHT+IFZiUcA4w11LB+vPoG9+WgvjzJn2Lg7goJvqZWvIHe8uQeH2yzKGxTThZpRNn9MQWBJHoc45w==
X-Received: by 2002:a5d:588b:0:b0:3b7:8473:312c with SMTP id ffacd0b85a97d-3b78473319dmr5207539f8f.0.1753769809715;
        Mon, 28 Jul 2025 23:16:49 -0700 (PDT)
Received: from [26.26.26.1] (ec2-63-178-178-86.eu-central-1.compute.amazonaws.com. [63.178.178.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4588d89c50fsm10876755e9.0.2025.07.28.23.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 23:16:49 -0700 (PDT)
Message-ID: <d7543795-b172-4452-8789-e1c810d8075a@gmail.com>
Date: Tue, 29 Jul 2025 14:16:43 +0800
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
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <20250727162041.GC7551@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/28/2025 12:20 AM, Jason Gunthorpe wrote:
> On Sun, Jul 27, 2025 at 08:48:26PM +0800, Ethan Zhao wrote:
> 
>> At least, we can do some attempt in DPC and Hot-plug driver, and then
>> push the hardware specification update to provide pre-reset notification for
>> DPC & hotplug. does it make sense ?
> 
> I think DPC is a different case..
More complex and practical case.
> 
> If we get a DPC we should also push the iommu into blocking, disable
> ATS and abandon any outstanding ATC invalidations as part of
> recovering from the DPC. Once everythings is cleaned up we can set the
Yup, even pure software resets, there might be ATC invalidation pending
  (in software queue or HW queue).
> iommu back up again and allow the driver to recover the device.
> 
> I think the current series is a good step along that path, but we'd
> also need to improve the drivers to handle abandonding/aborting the
> ATC invalidations.
Also aborting ATC invalidation works as per-condition for DPC or 
Hot-plug cases. agree, such improvement seems necessary.
> 
> IMHO DPC and SW initiated reset are separate projects.
Of Course, Rome wasn't built in a day; I endorse the success philosophy 
of restricting project scope. The discussion is purely focused on 
technical methodology.

Thanks,
Ethan

> 
> Jason

