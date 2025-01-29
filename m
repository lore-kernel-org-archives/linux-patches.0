Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708CF1DFD9F
	for <patches@lists.linux.dev>; Wed, 29 Jan 2025 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171426; cv=none; b=XiFlv6fLJXpGfY2PF35o/+/ti117dIWHvQypfBHMv8OXRO95GDz51oOGTTG75ipg7mKlrEBjkiOeA2Dd7tHo9HEk2SWPVpyZjTFjtbPRVXquEwoKF/cP06F43w99kXJnwc8A2WTo2VsXlf3hQsCzCOmrha/NpRej9LQqDSVLowo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171426; c=relaxed/simple;
	bh=lTP2WZGK7rl5hpI7hR7S+twULR2cKHG1SjFFxN33iF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Co2+1kzvFs4TNWJLX6Ruv0fPsA/qsAFtkNNULGI7cIBor/E+UU0Bnw1dm9p/bL85NkZWyW9tlEAIwnwxeV+w+dSKinqBwrDeVVFNsF+kB6f9QgF8nJ8oTryshqxYpjz2d6f+iO0HP5ZQeBHIES3yENj/l+e5ZGVdXkuid1MehcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A6iOpeA8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A6iOpeA8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738171423;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUinW45xP5e5WNhMH3KfMBEndfX+Wq9Gq0wkIWuPQkM=;
	b=A6iOpeA81xBbiH1IhLpCf53vt9LIGWGDR8bZLoo6WSNY02IWYN5YD9IMqP+wEa7QGnol0q
	ylt/9vIJQH6PVnb6K5gblHlr1M1jOQWYugt4VGwLew7rEtf5GLgjlxyU3aNhFgN9vBSWy+
	GNLP8q87Ro1nzW4Ej8WbPuFnKYpYWy4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-mFrwLJb3N6mURQ9KIamM1A-1; Wed, 29 Jan 2025 12:23:39 -0500
X-MC-Unique: mFrwLJb3N6mURQ9KIamM1A-1
X-Mimecast-MFC-AGG-ID: mFrwLJb3N6mURQ9KIamM1A
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4361ecebc5bso36425625e9.1
        for <patches@lists.linux.dev>; Wed, 29 Jan 2025 09:23:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171418; x=1738776218;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cUinW45xP5e5WNhMH3KfMBEndfX+Wq9Gq0wkIWuPQkM=;
        b=s9NRtgVkpU0qKzL8oDKHDVaeBAUmAvfMlPkBJxAOd/xd1p8em55IR4QU9dHN9rurfN
         tuFPeEOENyXf8puo+4yy7sau1EriDeIhngp28gXsGpMZ95CefhZz8kdm5Qxs9Gv1FhRY
         w/GRRTy0uW7/OOOrqTO4YKiSha9C7FV7w9LqwHuA5MqgkNW9deUEY7F4FI6suppSMbb6
         h+zIbSAOx7fvzHzaB/DZpkshhN6fd3HdaCYhoVrt1UV/z8o6UNfndfIJfylfGlufMo/8
         mMxLqwCjy1/Sd+1GPzfbua2tRS11x7uoOOWjc/253EFVam0EKMEOALPB/ArLlBd43a/t
         9/0g==
X-Forwarded-Encrypted: i=1; AJvYcCXZnvB2E6hDd2oaCS6RcHVBZ8+BJe9zZMgPvyEiDBkiB1MugSxnwGNsQS/k5BJFTpKHhVJzt4go@lists.linux.dev
X-Gm-Message-State: AOJu0YxQf+IVt5I7NGfUDZKjKtNmfP3T5ioycCM2EG2OscgNm5wY2FcR
	n087IU3jtFWxs/iDSg9tyvIUUFSQOBLR7SDZ44LswM7wVHP4NRBHFRBjbAIYzCgbuqxZib1ZZ0L
	yMyl+qYOhVP/wwymkGJnJtS36JmAZNTP7ca1YPW4vLzPAJRNghWEnphM=
X-Gm-Gg: ASbGncukcN4CFmRoVfyeXgIq6PDNDD+LT4FQaqk46zg1+tPLQ+SEdOqXsyDC1aAK/fU
	a8QfpQwS+4EKQVOONY1cMqUfPzDTDnh7HWSiZr9nqqWqCxHuqb5Q+vImJzxRvHMEFjcEagIymaf
	Sw7uhCcN77ju70w8zrckT8PyujsGDBO+00rmx5NCdo+B1P+rpTNTxI07ZhV6kCQ4L6ymmenWtpA
	dXclUDURC9sAarJoCipEB/M5X8eB03TSuivrd06El8u69KcijcsqA5LY6rnktbAYt/oCukV0Py+
	+Z8KgAVDh8aa6Mhw6vwC/8bLvgQ9YbA9QpVF8SIF3ZO0JcaSv40z
X-Received: by 2002:a05:600c:468d:b0:434:f270:a513 with SMTP id 5b1f17b1804b1-438dc429eb0mr37292805e9.29.1738171418193;
        Wed, 29 Jan 2025 09:23:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpj2GyirYUousb08KORRhwwxL2nA/aWckunw7W2c2Pu3YOW2k9PIs9cw16oemlKH4tI9rx+g==
X-Received: by 2002:a05:600c:468d:b0:434:f270:a513 with SMTP id 5b1f17b1804b1-438dc429eb0mr37292495e9.29.1738171417820;
        Wed, 29 Jan 2025 09:23:37 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc24cefsm29536565e9.15.2025.01.29.09.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 09:23:36 -0800 (PST)
Message-ID: <21ac88b0-fe93-4933-893c-7ffb09267e7b@redhat.com>
Date: Wed, 29 Jan 2025 18:23:33 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 09/13] iommufd: Add IOMMU_OPTION_SW_MSI_START/SIZE
 ioctls
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
 robin.murphy@arm.com, kevin.tian@intel.com, tglx@linutronix.de,
 maz@kernel.org, alex.williamson@redhat.com, joro@8bytes.org,
 shuah@kernel.org, reinette.chatre@intel.com, yebin10@huawei.com,
 apatel@ventanamicro.com, shivamurthy.shastri@linutronix.de,
 bhelgaas@google.com, anna-maria@linutronix.de, yury.norov@gmail.com,
 nipun.gupta@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
 jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
 shameerali.kolothum.thodi@huawei.com, smostafa@google.com, ddutile@redhat.com
References: <cover.1736550979.git.nicolinc@nvidia.com>
 <d3cb1694e07be0e214dc44dcb2cb74f014606560.1736550979.git.nicolinc@nvidia.com>
 <0521187e-c511-4ab1-9ffa-be2be8eacd04@redhat.com>
 <20250129145800.GG5556@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250129145800.GG5556@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9hYvDOeyrkHxBW4sPw6U_wooemKvgHdxW6UvgDcR-yw_1738171418
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 1/29/25 3:58 PM, Jason Gunthorpe wrote:
> On Wed, Jan 29, 2025 at 02:44:12PM +0100, Eric Auger wrote:
>> Hi,
>>
>>
>> On 1/11/25 4:32 AM, Nicolin Chen wrote:
>>> For systems that require MSI pages to be mapped into the IOMMU translation
>>> the IOMMU driver provides an IOMMU_RESV_SW_MSI range, which is the default
>>> recommended IOVA window to place these mappings. However, there is nothing
>>> special about this address. And to support the RMR trick in VMM for nested
>> well at least it shall not overlap VMM's RAM. So it was not random either.
>>> translation, the VMM needs to know what sw_msi window the kernel is using.
>>> As there is no particular reason to force VMM to adopt the kernel default,
>>> provide a simple IOMMU_OPTION_SW_MSI_START/SIZE ioctl that the VMM can use
>>> to directly specify the sw_msi window that it wants to use, which replaces
>>> and disables the default IOMMU_RESV_SW_MSI from the driver to avoid having
>>> to build an API to discover the default IOMMU_RESV_SW_MSI.
>> IIUC the MSI window will then be different when using legacy VFIO
>> assignment and iommufd backend.
> ? They use the same, iommufd can have userspace override it. Then it
> will ignore the reserved region.
In current arm-smmu-v3.c you have
        region = iommu_alloc_resv_region(MSI_IOVA_BASE, MSI_IOVA_LENGTH,
                                         prot, IOMMU_RESV_SW_MSI,
GFP_KERNEL);

in arm_smmu_get_resv_regions()
If you overwrite the default region, don't you need to expose the user
defined resv region?

>
>> MSI reserved regions are exposed in
>> /sys/kernel/iommu_groups/<n>/reserved_regions
>> 0x0000000008000000 0x00000000080fffff msi
>  
>> Is that configurability reflected accordingly?
> ?
>
> Nothing using iommufd should parse that sysfs file.
Right but aren't you still supposed to populate the sysfs files
properly. This region must be carved out from the IOVA space, right?
>  
>> How do you make sure it does not collide with other resv regions? I
>> don't see any check here.
> Yes this does need to be checked, it does look missing. It still needs
> to create a reserved region in the ioas when attaching to keep the
> areas safe and it has to intersect with the incoming reserved
> regions from the driver.
>
>>> + * @IOMMU_OPTION_SW_MSI_START:
>>> + *    Change the base address of the IOMMU mapping region for MSI doorbell(s).
>>> + *    It must be set this before attaching a device to an IOAS/HWPT, otherwise
>>> + *    this option will be not effective on that IOAS/HWPT. User can choose to
>>> + *    let kernel pick a base address, by simply ignoring this option or setting
>>> + *    a value 0 to IOMMU_OPTION_SW_MSI_SIZE. Global option, object_id must be 0
>> I think we should document it cannot be put at a random place either.
> It can be put at any place a map can be placed.
to me It cannot overlap with guest RAM IPA so userspace needs to be
cautious about that

Eric
>
> That also needs to be checked when creating a domain, it can't be
> outside the geometry.
>
> Jason
>

