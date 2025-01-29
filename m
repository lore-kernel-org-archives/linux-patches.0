Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB121E0DFE
	for <patches@lists.linux.dev>; Wed, 29 Jan 2025 17:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738172973; cv=none; b=tysQpY9qbYnUhHmtSIQPlR3z21g8X0lOyFgKsiptyF9x4MZHKn9EpimE2wfjT04mYx1yKwDGXA0Bmp+Z4kXKrG2bzz5BY5AIRrkPEk9WU9s3/+7Yd2ZW0JDbWyRb5qM+DhuOZXecFnlpxh9BZy2CsZmDTaPF9cMjA4mcznEfikc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738172973; c=relaxed/simple;
	bh=SQp3BHkMy88E/WG6aAfa1dNn4Op9EZoCx4scO6iPQm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZdTnIrDa61/2syZERL6dCkzY/aMLKZRhWePrJp47+ohGOtOX1lini/DEzD1Rc7beHtyyvP8TajKLus98rKv626UnMUdCrFyu9mS5Gldn+ha/Zj/4zkmV5LAMnqDYBk99advdWyBvCCgUewzFEk3profUQlWW/s5DfESX5syyNsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F8SxF+T9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F8SxF+T9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738172971;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pxbyXuurc0dvUCpLFnEXoKIL7HoI7M2OYxW0aVnbFr4=;
	b=F8SxF+T9fc4Y7PGBcWLQkMhJRv5Rc3PouONDpmtS6Uw6azTPOEqHkZR5RgiGj2Syb2XkFU
	Z4ptBsVmM5HbYz65TbtM6ikp1oZlTe9SB9wqzFv4KyNMGNYGdISKN2WQtiooJ3J7iihysh
	Ckr00oWQ3LYpx6jJhAtaAHjhoqtobhA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-K1iXwHLqOP2lUx7DqM2K5Q-1; Wed, 29 Jan 2025 12:49:27 -0500
X-MC-Unique: K1iXwHLqOP2lUx7DqM2K5Q-1
X-Mimecast-MFC-AGG-ID: K1iXwHLqOP2lUx7DqM2K5Q
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38bf4913659so5307597f8f.1
        for <patches@lists.linux.dev>; Wed, 29 Jan 2025 09:49:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738172966; x=1738777766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pxbyXuurc0dvUCpLFnEXoKIL7HoI7M2OYxW0aVnbFr4=;
        b=WLgv19LSU5ByRTTxSN0LPRKmcxQaIq48xaQ3wXAwRwZ0DmL9JIXEx2K34eIZixqCn5
         W0s5K2MSzCu+bYLHNhROlO5olUV0LOPwp5cSZZBIDi7bCAlcWDB84tXmfpyo8ciMzjN+
         5DvAifU0HFjYiZB8EYKlny+tHWSzqr3VHfgLg9WspTYnP6brt7HSYkPAhCUwVdR2ugFj
         2rwd3+nMjq4cRUtZQ2n5zRyIgm57lcadT4NvmmjjCBFpUqyO6uFvpy1GQg3Lgt55XtoA
         WeL2sPDzGboDc4Kio927KYs3nDMUYMrBD3AcnE0symEpyfeSWWWA0e7S6YQS+RpSPt9c
         MRcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVDpk1yhIw3VXA7NHfYZt44FnOt7JdAoSdAE8vbQ2tJ1/FvR0uocZcz3/KTuaaG2EF7fDnQGnu@lists.linux.dev
X-Gm-Message-State: AOJu0YzeymEAVPs40pjDAB85Dm5SLkjjOsf7+CTObL6EQMSr11+Ll/S1
	j1hCl+S4uaHBTNEv/gn0L9b+VCMe0iITs0cW90rfujso4qlPgstF6rERdTyQR5bmKB+45btbsaM
	w01er5rqiHAzurDYbT2oS8/0vV+EC+YXkipI1dj3JQE96zN++L4d+mFY=
X-Gm-Gg: ASbGncslubRCd/u9r746NFBhvT6M247aBdXyoDUGkiUreo/DTbt71Osr+7FCeSU+muk
	zD8LEjRCJR45d7lebk01vuAUrKm7rjqB2EI/Nakir5gXi0MoQ6NLo3O5OXDn5Pj2ays0Bunycju
	cRWUJBaPbR0Mh2sdWSIhVIMWn4zmJmygJ9M+ph7kd+X+0+ZaK17iG3VLyMdTRVrhOVYShPVu+j4
	MaYVZOwJpoDg8SdLZvyw2Z580rni/nHTgUnMEgog0O7fB5d2UKFPA5c11A10MJIAfajiu+lxEqk
	YUWnQTM/f596nLO7F9qNAJN8rYQLzoNGiTgUTXejLS8A3voOpq2d
X-Received: by 2002:a05:6000:2a9:b0:385:eb85:f111 with SMTP id ffacd0b85a97d-38c51960449mr4176472f8f.14.1738172965831;
        Wed, 29 Jan 2025 09:49:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHZcuNSD2hPNqWa4PCH0KoHBYwz7G9outfVdx7sBB1yVqyndStjqCH81h7BEeHjltUf96/lwQ==
X-Received: by 2002:a05:6000:2a9:b0:385:eb85:f111 with SMTP id ffacd0b85a97d-38c51960449mr4176452f8f.14.1738172965407;
        Wed, 29 Jan 2025 09:49:25 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438d7aa605asm39995085e9.1.2025.01.29.09.49.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 09:49:24 -0800 (PST)
Message-ID: <6f630a23-e1b5-48de-81a6-43cbb1e6cabd@redhat.com>
Date: Wed, 29 Jan 2025 18:49:22 +0100
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
 <21ac88b0-fe93-4933-893c-7ffb09267e7b@redhat.com>
 <20250129173909.GI5556@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250129173909.GI5556@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Li0inlX3FIjSt-z2HsFKugHw8E7BgEuJ1NCxks_kEGg_1738172966
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 1/29/25 6:39 PM, Jason Gunthorpe wrote:
> On Wed, Jan 29, 2025 at 06:23:33PM +0100, Eric Auger wrote:
>>>> IIUC the MSI window will then be different when using legacy VFIO
>>>> assignment and iommufd backend.
>>> ? They use the same, iommufd can have userspace override it. Then it
>>> will ignore the reserved region.
>> In current arm-smmu-v3.c you have
>>         region = iommu_alloc_resv_region(MSI_IOVA_BASE, MSI_IOVA_LENGTH,
>>                                          prot, IOMMU_RESV_SW_MSI,
>> GFP_KERNEL);
>>
>> in arm_smmu_get_resv_regions()
>> If you overwrite the default region, don't you need to expose the user
>> defined resv region?
> If it was overriden inside iommufd then the user told the kernel what
> range to use to override it. I don't need to go back and report back
> to userspace information that it already gave to the kernel..

Looks strange to me because info exposed in sysfs is wrong then. What if
someone else relies on this info, either at kernel level through the
get_resv_regions callback or from user space.
>
>>> Nothing using iommufd should parse that sysfs file.
>> Right but aren't you still supposed to populate the sysfs files
>> properly. This region must be carved out from the IOVA space, right?
> The sysfs shouldn't be changed here based on how iommufd decides to
> use the iova space. The sysfs reflects the information reported from
> the driver and sw_msi should be understood as the driver's
> recommendation when you view it from sysfs.
>
> The actual reserved regions in effect for an iommufd object are
> queried directly in iommufd and do not have a sysfs representation.
>
>>>>> + * @IOMMU_OPTION_SW_MSI_START:
>>>>> + *    Change the base address of the IOMMU mapping region for MSI doorbell(s).
>>>>> + *    It must be set this before attaching a device to an IOAS/HWPT, otherwise
>>>>> + *    this option will be not effective on that IOAS/HWPT. User can choose to
>>>>> + *    let kernel pick a base address, by simply ignoring this option or setting
>>>>> + *    a value 0 to IOMMU_OPTION_SW_MSI_SIZE. Global option, object_id must be 0
>>>> I think we should document it cannot be put at a random place either.
>>> It can be put at any place a map can be placed.
>> to me It cannot overlap with guest RAM IPA so userspace needs to be
>> cautious about that
> Yes, userspace needs to manage its own VM memory map to avoid
> overlaps, but from an API perspective it can be placed anywhere that a
> map can be placed.
OK

Eric
>
> Jason
>

