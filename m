Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040D5264608
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 04:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757391426; cv=none; b=vC/PpCkFdfy3r1M3vj0NFS+v0oo8iGG0pLwWHeKmpUU8rlwDd2q3CdqCztwWqymF9GFpaVo5hrfVgBN5e117kZqa1i4fLQoNPkGARTIlWMPikI6mM0P9RfCxRMVFEmgw9mEm7qxemaGtycMorS93y3bOvqYGPAr5YwF8S3LRMOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757391426; c=relaxed/simple;
	bh=Vrtl+xs7K4zXcPnLFH1TuZOu/V+27YNQSOap/9QG3ug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R3fi6dAGn07AHvF028WO8IOx5zXPlhvvlKUc3sJEV1aeQ2fXHB5B0HAlPoqMDfq9xekyuk7UhewIWDp456keZbJ9JreNaTM0nU8VsdipU4wAIIJe//dTsHgdjA+1BkhwRuwSjLZ8cteNenwwrslw1LHRE0ev/n+2HK7v+sq8ZzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gazw1fRq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gazw1fRq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757391424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PXc4wYDZmZ/L8uZekYzqBJVvEmMbocn1KotryOo59zE=;
	b=gazw1fRq3FlUpr9AAM3srtv70EnitSiZV8xi/tSoQH23d/eFrUHSaO3Fbbk8HdeB763MKJ
	aVXVF9u9e5+XNwWIu7n1FiE5wmL5kOFLLQKqAvhTnBrKp3HOOKkGC9DeaW5RTIf+blb9Xn
	+ajVRMs4H6imOqNeQvjWmRI110LiOmA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-KLFwevOqNEebja-WJblXAw-1; Tue, 09 Sep 2025 00:17:02 -0400
X-MC-Unique: KLFwevOqNEebja-WJblXAw-1
X-Mimecast-MFC-AGG-ID: KLFwevOqNEebja-WJblXAw_1757391422
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b6019b13b2so105378261cf.3
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 21:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757391422; x=1757996222;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXc4wYDZmZ/L8uZekYzqBJVvEmMbocn1KotryOo59zE=;
        b=SJ96no0BC7K20jLxFJwjfsXWV5IxkBvVZ0fL+qAIkVMQcGLM1kbU1HsRY9HtTJkyDz
         76Xn422/1LtI15qSjvb3CrOS3bhSIDIF/elnOx4cTNKuW+oSMygwr8j4TDVPscs31Hej
         OcwbD7ECtpxzkDYYJIjx8eVfhlfyzsCS387OWGW6hhqwDUp/TjMNCOdYXMemZXZVVSxO
         21Ojx6d+8d1I/ebnJJq+XWit/yImlfmZqtM0XNAMrYJ3ixnVJdnWLSE52KbJ+D7Q41kJ
         VtlruLMdlrLq5EnR8urhYOYwGDH8zF6cp+S0hgUh01Qm+eAOUfTzOLcEZd1DSkOe8msK
         WrXg==
X-Forwarded-Encrypted: i=1; AJvYcCV3BpYoUAn6znvshEkry3Cxu8QufDRCRJV6GzVEX+8z6almJSDuPsLJfuf6/zb7iDhlgy2ygPIj@lists.linux.dev
X-Gm-Message-State: AOJu0YxbOaHeLeMS3a9iTXHkjg+v4Bmbvr8m6imto/6VQ7zhZDrmfI4p
	tteGHmifLqZKdrKcxC3ZGN9tpcxKlZHOGjL0w0MRQfkytnka9N4a9jxrVCzDgvT+W0y3BJdOvf2
	S5LlGawRqSe1u7EYAXTG1srppt3AORNXj30tq8MPdJXXYHTjIqspLiXVm5ZE=
X-Gm-Gg: ASbGnctPnBJp/ZDUJFsEBjdAO1igoIpW0avjoZuVk53ncT97xBTQlpl8IiG9KCb3ZeO
	7b5Xw0EVQcj9wvIKx+xOO0SoTQP2v6/SbspLoMobFFgV86H2Zl0sINdeW/XEmmgNhheVR24bhs9
	ktz9HGRpqoeh0mgE18NDReIK8oagXAx8s9H/fT3gEvUI4gpaADIdukNnKpd96gLMs7UlymQDpxT
	OQw/YA5HUPc1s3sQt82tP4L5Qaof/kB7npHYCTwe3QOeFLpNqYzTbsB0kivJVo1h5o/5qPfEfyp
	fHf8QQGwNMKRtjK1q5VyV0M7zyxJbAv/mdvTODiU
X-Received: by 2002:ac8:7f56:0:b0:4b2:fcf4:44c9 with SMTP id d75a77b69052e-4b5f846701amr118252561cf.60.1757391422234;
        Mon, 08 Sep 2025 21:17:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlZTe8MK04WhNv9/TediecLNUlQjS4uZJ6D+gPH8b1KU0M6GQFQ+qYugLVX8lKpMw4F3h/7g==
X-Received: by 2002:ac8:7f56:0:b0:4b2:fcf4:44c9 with SMTP id d75a77b69052e-4b5f846701amr118252291cf.60.1757391421878;
        Mon, 08 Sep 2025 21:17:01 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-728a860bdebsm100439826d6.69.2025.09.08.21.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 21:17:01 -0700 (PDT)
Message-ID: <d89d3606-a464-443a-891c-637f304127d5@redhat.com>
Date: Tue, 9 Sep 2025 00:16:59 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/11] iommu: Organize iommu_group by member size
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <4-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <4-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rKTiiAMq4eLbRbt7QfrTbDUG--U3c0QyPT6gwB8VxxA_1757391422
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> To avoid some internal padding.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 1874bbdc73b75e..543d6347c0e5e3 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -58,13 +58,13 @@ struct iommu_group {
>   	void *iommu_data;
>   	void (*iommu_data_release)(void *iommu_data);
>   	char *name;
> -	int id;
>   	struct iommu_domain *default_domain;
>   	struct iommu_domain *blocking_domain;
>   	struct iommu_domain *domain;
>   	struct list_head entry;
> -	unsigned int owner_cnt;
>   	void *owner;
> +	unsigned int owner_cnt;
> +	int id;
>   
>   	/* Used by the device_group() callbacks */
>   	u32 bus_data;

ok, but still leaves a 32-bit hole at the end, which would occur in the struct if bus_data was put after id or owner_cnt.

Reviewed-by: Donald Dutile <ddutile@redhat.com>

