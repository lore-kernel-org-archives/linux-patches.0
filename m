Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FB318FC84
	for <patches@lists.linux.dev>; Wed, 29 Jan 2025 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738172790; cv=none; b=OzDubmUooXdk+r33KKeOQVq8Zv3OsF5YjYbdFnJw/sIsPJUuoLHUlsYOkjA7f3lYmq9bTmJhgNTomoUHHQf4nTc4GBEiVSQmubDE0fqDkqJCmcsl5n1yyQCcjw5ZKvDlLb727cE9lWt2KV5iI4t75O9FN0drf7tMZzDpkq8aheA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738172790; c=relaxed/simple;
	bh=GVBVPQXK+YOVlYYHwZtT5FW5o6eoUI4q99NTvpI44+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k/P0MMF4GjZYbX87S58KI9PMflQuqHx7TLN8l+rsHrnR7ucOOZCo1Kjvh54sYUeKpJy63HaLO8f6mkkKfb20ma4nqXBpEOcQoka/nfJTrug4af1mqo97kxjy9+QIO2w+thH1JYSY1ij6pzIdGof4EWGbYCRuJ64DGL3F4QnW9rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Or+SVVcQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Or+SVVcQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738172787;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7C39AcP479z7PaOLmWGBMx2cDdXkmF+MZl53H1pFh10=;
	b=Or+SVVcQQfxTFuVTQoPW/QiwEnhHnmySHQoeU9rZBRSSBtP8uIFcW4P50TEQZUdHGh2ngt
	pNVsSPzqeO4aNgBwP/CDwu9wCbqquUEM6xq1HrZX39n2fDAN3iUCmliM6IEomqsyFmCdbh
	8ZQhJkx6uakZ3UUM8CudLy/Ulh1RCz0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-0pCxVKz4ONaHSSW_387K7w-1; Wed, 29 Jan 2025 12:46:26 -0500
X-MC-Unique: 0pCxVKz4ONaHSSW_387K7w-1
X-Mimecast-MFC-AGG-ID: 0pCxVKz4ONaHSSW_387K7w
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-436225d4389so4812415e9.1
        for <patches@lists.linux.dev>; Wed, 29 Jan 2025 09:46:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738172785; x=1738777585;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7C39AcP479z7PaOLmWGBMx2cDdXkmF+MZl53H1pFh10=;
        b=us0gXDpQiysz6jia/F8PtlTJ+Y0xe61BlKvcO1Mrhx3v+Z2BZeNijdw/TrTmhyMhuC
         b01cOQFXrrhuFfD6hP123f6I8JMGcuRWCiok82N7jw3RgDAq9RAvPcY5nT3tKgMDdI4q
         nNv6EWacHph0XOD4DlitpKkun/BQyWqNAgFhK8iRDQ/qmjkAi3y7u+wcAgP7L8G/Fvnj
         C3sCR/Je3CxT44/w8y+w1uQrQGCPlr0Jdb/Dek7e/RZ1i5rtF2AGYYwnWhXHCvoI+OaG
         FTw/5LI+kcfPErc+XV/Ebx4vgfTXNZzIXyo4IO+NL0JUKcsoNY+cvTC6MaHvjnhnjUgF
         QgQw==
X-Forwarded-Encrypted: i=1; AJvYcCWPvdPGblzO9c3lw7r2+obli/lNS50+EMWGAgrEzmPzxYxFiJiu5eStkPlGv+V+w/AxQISOugFX@lists.linux.dev
X-Gm-Message-State: AOJu0Yxz4dWHSW2eqPorWOUqihQLORNtHsUQwyaojzHv08LSWvNkZlRr
	zbmbkdHCueGu4ETesjft5KHltd5iLwKUPPzqWawQkyuwXMb0XrM3ZA/3IEHkgzX+/Tp4jlAhsod
	YHRN8gEysytFIO0gFXua5sap7RjLrsDxhlCGTgFIU17DygkpZ0pEUwZg=
X-Gm-Gg: ASbGnctwZo+SvYDM803ASJkNqW9+983YOne8Uz2yxTtVFTHpvb9xiDYaeqkJcZ92ogr
	xNCKi2lfEr6HdFsQs4Gb9KetEvFjxzBbALy041qVTSopJ/rLmDwDWf2SQzNpUHEaVZJoyUGf3Jw
	AYpMDeLURzdo4eA0TNJqNn4gWqE+f30lQxfWXUMIiaBpLvRu4jzh+7a2XG6G3ywOyeOitjT/ma8
	W/GOE0yiryFqSem8Vlmeo4U47Fx63HNnWW+T61Vw9gzpzLunNOPqIJ1uaGyHQ9TOO1OZwuWyuTx
	QpsEE56kPfQbPUThJoqw2+pIuqujgptZvFFmcoUS1wI/5dVOpseg
X-Received: by 2002:a05:600c:6555:b0:436:fdac:26eb with SMTP id 5b1f17b1804b1-438e15e7fdamr1934835e9.7.1738172785113;
        Wed, 29 Jan 2025 09:46:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQmQmuNWdwXKR1WA8YUMR0neWSl2UDPcJoTIpWOkS9ogRoZv55tiuXIIRNpwuKJUpW+TAzXQ==
X-Received: by 2002:a05:600c:6555:b0:436:fdac:26eb with SMTP id 5b1f17b1804b1-438e15e7fdamr1934415e9.7.1738172784724;
        Wed, 29 Jan 2025 09:46:24 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc13151sm30025435e9.1.2025.01.29.09.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 09:46:22 -0800 (PST)
Message-ID: <8e4c21b5-3b79-4f0b-b920-59b825c2fb81@redhat.com>
Date: Wed, 29 Jan 2025 18:46:20 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 00/13] iommu: Add MSI mapping support with nested
 SMMU
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Nicolin Chen <nicolinc@nvidia.com>, "will@kernel.org" <will@kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "maz@kernel.org"
 <maz@kernel.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "shuah@kernel.org" <shuah@kernel.org>,
 "reinette.chatre@intel.com" <reinette.chatre@intel.com>,
 "yebin (H)" <yebin10@huawei.com>,
 "apatel@ventanamicro.com" <apatel@ventanamicro.com>,
 "shivamurthy.shastri@linutronix.de" <shivamurthy.shastri@linutronix.de>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "anna-maria@linutronix.de" <anna-maria@linutronix.de>,
 "yury.norov@gmail.com" <yury.norov@gmail.com>,
 "nipun.gupta@amd.com" <nipun.gupta@amd.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "mdf@kernel.org" <mdf@kernel.org>, "mshavit@google.com"
 <mshavit@google.com>, "smostafa@google.com" <smostafa@google.com>,
 "ddutile@redhat.com" <ddutile@redhat.com>
References: <cover.1736550979.git.nicolinc@nvidia.com>
 <4946ea266bdc4b1e8796dee1b228bd8f@huawei.com>
 <20250123132432.GJ5556@nvidia.com>
 <de6b9dc1-dedd-4a3d-9db7-cb4b8e281697@redhat.com>
 <20250129150454.GH5556@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250129150454.GH5556@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uMcoe7MCnVINSHxbHkv7KzEVMpSl-4sa0vAHFewFquU_1738172785
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




On 1/29/25 4:04 PM, Jason Gunthorpe wrote:
> On Wed, Jan 29, 2025 at 03:54:48PM +0100, Eric Auger wrote:
>>>> or you are just mentioning it here because
>>>> it is still possible to make use of that. I think from previous discussions the
>>>> argument was to adopt a more dedicated MSI pass-through model which I
>>>> think is  approach-2 here.  
>>> The basic flow of the pass through model is shown in the last two
>>> patches, it is not fully complete but is testable. It assumes a single
>>> ITS page. The VM would use IOMMU_OPTION_SW_MSI_START/SIZE to put the
>>> ITS page at the correct S2 location and then describe it in the ACPI
>>> as an ITS page not a RMR.
>> This is a nice to have feature but not mandated in the first place,
>> is it?
> Not mandated. It just sort of happens because of the design. IMHO
> nothing should use it because there is no way for userspace to
> discover how many ITS pages there may be.
>
>>> This missing peice is cleaning up the ITS mapping to allow for
>>> multiple ITS pages. I've imagined that kvm would someone give iommufd
>>> a FD that holds the specific ITS pages instead of the
>>> IOMMU_OPTION_SW_MSI_START/SIZE flow.
>> That's what I don't get: at the moment you only pass the gIOVA. With
>> technique 2, how can you build the nested mapping, ie.
>>
>>          S1           S2
>> gIOVA    ->    gDB    ->    hDB
>>
>> without passing the full gIOVA/gDB S1 mapping to the host?
> The nested S2 mapping is already setup before the VM boots:
>
>  - The VMM puts the ITS page (hDB) into the S2 at a fixed address (gDB)
Ah OK. Your gDB has nothing to do with the actual S1 guest gDB, right?
It is computed in iommufd_sw_msi_get_map() from the sw_msi_start pool.
Is that correct? In
https://lore.kernel.org/all/20210411111228.14386-9-eric.auger@redhat.com/
I was passing both the gIOVA and the "true" gDB Eric
>  - The ACPI tells the VM that the GIC has an ITS page at the S2's
>    address (hDB)
>  - The VM sets up its S1 with a gIOVA that points to the S2's ITS 
>    page (gDB). The S2 already has gDB -> hDB.
>  - The VMM traps the gIOVA write to the MSI-X table. Both the S1 and
>    S2 are populated at this moment.
>
> If you have multiple ITS pages then the ACPI has to tell the guest GIC
> about them, what their gDB address is, and what devices use which ITS.
>
> Jason
>

