Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A56F3126C5
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757447903; cv=none; b=KRx5yimpj+ye+FJnWPt88R87uW1TgHLsWboOlQ7mWSg1CsI2viC8ES+DS5cGiDwvakaeLBJvEpL6dyMiXr4eE9tBT6vklf244nrVd0TAIjiXwuVOiAEuGYmB8BQ4AfIXE20wjjwCvVnNQZtCu9inllG1Mo87o6KYu+blyWK4NoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757447903; c=relaxed/simple;
	bh=9kyPH/7+wdW7kBbHqGG+Ud1ODCMJF98xQA/Qhwi4KzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FNfLyXtuqKnTM3lwS4fOI1AaSjIX1DphGYK92Hy/Bsbb5i/qx5G23l/eI91PQrqFZYWbV9Zwsz5lSVntStJN66PrlQpIF9484QoBdXZBPRUvznU0fSOGLnDQwBgQCQBHEgKycLibUjKCL54s01qIJnzA3IpXJno71+4kd+elrQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RI4cGZ28; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RI4cGZ28"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757447901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LgCo6nYdRNSIrE5RFL1DFAnJKWKeGruM3UAqjFfXFW8=;
	b=RI4cGZ28P7oxUBKT0weaGedZZow52DDtV+eFCdKSQ82LSRGK2zLg02+LdmYw5bU7duqWXZ
	RwP6yfB04fGO81ArG1AdrfrpabH1VuFJzGIFfBKFXcQWtO91E05l3zpoA+d9ABdCaEHBgk
	iPslmoxEaurffDEGO58V545Ij9HunWU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-7W0xvgZXMHivyuYJ-JZXkA-1; Tue, 09 Sep 2025 15:58:18 -0400
X-MC-Unique: 7W0xvgZXMHivyuYJ-JZXkA-1
X-Mimecast-MFC-AGG-ID: 7W0xvgZXMHivyuYJ-JZXkA_1757447898
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-806a4452050so1164114085a.1
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 12:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757447898; x=1758052698;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LgCo6nYdRNSIrE5RFL1DFAnJKWKeGruM3UAqjFfXFW8=;
        b=HSpoAesr0bWoh0tdwX+9bxYeHoiAhh0MMBRs3LVhMwVeB5azWuxk4AoCNvSFsPRpBO
         zKp7VXyDqNot3VY4HpnnAjGR8gGY/MIceq5Mo6/opHkIbiUDU8ySCHFvHisIoZixDZDM
         ZLqIjEuSh/inXez3sUM7f9j5fprJ/APQhVS1M/BHPUlHJnwxFfeGdg+VS2K01UG5jknb
         UOeBRFDP0qgTRT5WIUSZYiR7MdK3oG66mvELSLaJZmidayL94oHU1bBN4wAUbT2eYPYU
         bQ4WpPyJ2ZRKQt4tfVIz0k1mMI30uLoyiEnHOe2odhjdd67zOfjsildggcSStvH2p36s
         5uAw==
X-Forwarded-Encrypted: i=1; AJvYcCWmpwQeaSagnUal+Abx46upJEsuy0bgUmCWNP34+DRSr39yTYnV54woSJOxIT5jrtBAJtbXjC1I@lists.linux.dev
X-Gm-Message-State: AOJu0YzM1/O8DNgZOqpxw9RMJjs/tItqyDz6sS1BoPOHLo16SqkaJuCN
	y1IYBUcFnsiJfXAMJWZwygmb0pAHwYRPn3LqAPObYAdaRFZ6jG3RmizXQbfthwD9cjSDBWjVXqM
	QlXjfITQ0UEE/X7pnsdyZoI3Iy3A+s/nio9n02v4L6nnn6SiLMzjcvXpXRmc=
X-Gm-Gg: ASbGncvmiXIDClpFTBrH9dKdnRzNjRnW2CLrfdQRSvCn3+j2sxCzuWzdVezybIn3eez
	0DH7pcZDAz0lsYVZlR4Wx18uasF9bgwdJ/2RdtuxolM02d3VrRnWIPH5beI+BT2dGQO2wc+9E1H
	T0B7sVeXcIh4fQ2mZN/jD2j1sgweBAeqiEOpyg+mQPMlK3OPlZg9XFzwiiL3qP1kDQTcX61ZDND
	ChxL91RKyfBO/IihYMJRGVGcKEv5WsDhyYK0/3X1uFQCyc4BUGzQJeIDkN+CLmhGxFkBluLKNFU
	kLSUd9Iln9KnTuTMHoLtfNPjGXEofIPoqtF1A2yP
X-Received: by 2002:a05:620a:29d0:b0:813:8842:93c3 with SMTP id af79cd13be357-813c568dadamr1292510685a.81.1757447898337;
        Tue, 09 Sep 2025 12:58:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDoXxrFaCmJ/Gj+lCNKoCToXRUvhVa9mV8loJbiqez27cqgvzNF+qndJRohMfDl/gHnjbl+w==
X-Received: by 2002:a05:620a:29d0:b0:813:8842:93c3 with SMTP id af79cd13be357-813c568dadamr1292508485a.81.1757447897982;
        Tue, 09 Sep 2025 12:58:17 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81b58c54d9asm170295485a.1.2025.09.09.12.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 12:58:17 -0700 (PDT)
Message-ID: <819b6482-eb2c-4e2e-bf74-3396326aef5c@redhat.com>
Date: Tue, 9 Sep 2025 15:58:15 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/11] iommu: Validate that pci_for_each_dma_alias()
 matches the groups
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <7-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <9487fde9-ec40-4383-aafe-7ae0811830f5@redhat.com>
 <20250909153511.GM789684@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250909153511.GM789684@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qIr0SXrU4odl5SZGjEZWg9P0mhMLxq6HQSeS_JlSL-E_1757447898
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/25 11:35 AM, Jason Gunthorpe wrote:
> On Tue, Sep 09, 2025 at 01:00:08AM -0400, Donald Dutile wrote:
>>
>>
>> On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
>>> Directly check that the devices touched by pci_for_each_dma_alias() match
>>> the groups that were built by pci_device_group(). This helps validate that
>> Do they have to match, as in equal, or be included ?
> 
> All aliases have to be in the same group, or have no group discovered yet.
> 
I guess I'm not asking correctly, as I think you agreed, but I'm looking for a clearer statement.
You said 'in' the same group; that's not 'equal', or what I think of as a 'match' of the pci_device_group() & dma-alias.

So, is it in equality/match, or inclusion/inclusive check; if the later, just tweak the verbage.

> Jason
> 

