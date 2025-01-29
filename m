Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB6F1AAA10
	for <patches@lists.linux.dev>; Wed, 29 Jan 2025 10:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738147459; cv=none; b=O3B5CgMcvEHiPPamwSM4/En5pt3ihWv7XC/FCBSQJ4XTwgv6UA+jR0SkoqE5zE1YaVvYfgSLxfxcIRQHM95xhwrdP7c9TRAxZrx9ybZedVOfsingU+3yMmrMTm27gTv53XGF2hJlQNtg4tbI6afCjL1lTf1aBJy6Iz7EvCOKcxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738147459; c=relaxed/simple;
	bh=nv4VuGjSok28KFpMvnhhes+J9LZ2fUvq+BQK0GUr/X4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cULxzuKpW8YQRnKMVewPzYXzYtXwCX71+qg0w0aYCmoq1IfVWHCEDExbXf3PQNydxurXTPRl8Z2fZuHcJ9zW6qaGfCNfK2//CiVYL2Ztg0NiqDKEqLRm9EQErt4Mf3XXHaoAXdeBDfwynddYV7wfogyIFTT5yYj0lGgFb75uPEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DT1Mli4v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DT1Mli4v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738147457;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWrkOMQp0EgA1n2/2fll/3eIYbXZEI0l3kIseupr1do=;
	b=DT1Mli4vvSphGLWtdulCl2AC1Y2EEPXg1HhiJ3fQ6E0ygcsOwMIGIlJtY5+NWbrR/hv/Yo
	fSBrhiTvGLmKAwFHBSagp3vN1l1Ugpl4bQj2iwhel7ySuNJv4dNH2RknBITZmgG54GrqWi
	er+IjrCLRAEOxHUhyEMAkwxCCPy5IP4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-EDJgvMXrOsWztsPrBgn9hQ-1; Wed, 29 Jan 2025 05:44:16 -0500
X-MC-Unique: EDJgvMXrOsWztsPrBgn9hQ-1
X-Mimecast-MFC-AGG-ID: EDJgvMXrOsWztsPrBgn9hQ
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-436219070b4so31446825e9.1
        for <patches@lists.linux.dev>; Wed, 29 Jan 2025 02:44:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738147455; x=1738752255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yWrkOMQp0EgA1n2/2fll/3eIYbXZEI0l3kIseupr1do=;
        b=G4L9cZvzSPln48PxVV3vtWEpmizUarLUbf8u5toYqC5CQxs6Jt8wh/Q3CYTQNznrQD
         ZF+OqEUNzKX3Qu8DISXrOBOVHl0IMw5bJ2tWr5HvY00zLX9bZ7NATGunScoAWEeukJma
         XJD25yw7ySW1Vo9Vjm7iRK7tf33oc/wd2Js5OjgjeybY85OmQ7tMnhUE4mTVivfT//jh
         u9vyf17l1Uc5c+DoX0wCoshb9gXOtGL450Io/MI++QEzXezJ8Yr9W1HPjiTFk/RuZ5JY
         9YUjBcuf+v3yLRLXK9nHTnS2DVsIYBEuA75q51s3ANmqwu5nstzimyi+r86GEewqZUCy
         0LkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtWDWe71wKRq/uru+xYp0CRwqOBc9L4/SxXD/BB/jf9rw3FgSakzn/Y2YGzmrY36iDDXlhUFfy@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+uzSF/tBRkdSFAu2D5/mayDwRboogX4JVYwzJLikztOnN1Oll
	b5LTWvPqZau3hXvkt+0zDf2W1tsvbmuSj7fO15XAFWz7nDtotQ1OTkO3iclz6hLKGXjYyIPswCL
	BFfR4JzlvLdmHW0LWWuddivTNJvdE8MfqcSWojlfKx3kLgiAqo8LAd3E=
X-Gm-Gg: ASbGncsiylfZW5+HkyfuOaySpO+6+JNpOZt9iTkTLZNh3mifIbZwuKDj22wLuqLqzVq
	My79BqCdEU8PGvtTS52B5dtsqypSQj//fuurCBua+ymKVmSS0BlGtswyFSkCeFgSIJUCimnDZw6
	Y5DLXsI4YLIaaxckHLeo+RulzAOa0BVcPKvozJ5ET95PxNFtLKXeyIrsH6N1ZcHb09UBIvI89Eo
	o+ia9EO8rfeAZXNbLvpzuyp/c7Ggq/Q3sW3aVnNhnuh/x+fbeSKetswhGVktThwNTQRG+ADrtYl
	4KCPywSEvyfCduOGuFCBJy6/sQuJ/GKnDFx8EsZJa2APRA5wnHc8
X-Received: by 2002:a05:600c:3d9b:b0:434:ff08:202b with SMTP id 5b1f17b1804b1-438dc3c360dmr20853805e9.12.1738147454885;
        Wed, 29 Jan 2025 02:44:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzPWEOLliL6813Vkt1ndANuVcfYh0Tyo6krKSjX7AbgdnEUM8NRt3/67xnxrixA9ILfXf4Jg==
X-Received: by 2002:a05:600c:3d9b:b0:434:ff08:202b with SMTP id 5b1f17b1804b1-438dc3c360dmr20853365e9.12.1738147454482;
        Wed, 29 Jan 2025 02:44:14 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc2f73asm18251195e9.24.2025.01.29.02.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 02:44:13 -0800 (PST)
Message-ID: <840e41b8-15c7-4c4f-a503-818fb4729913@redhat.com>
Date: Wed, 29 Jan 2025 11:44:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 02/13] genirq/msi: Rename
 iommu_dma_compose_msi_msg() to msi_msg_set_msi_addr()
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
 <242034456c0bfcd7ecf75cb29d8e5c99db0675d6.1736550979.git.nicolinc@nvidia.com>
 <fa9b443d-e068-41bc-ad03-9f04818c72e0@redhat.com>
 <20250123185002.GV5556@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250123185002.GV5556@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 34F0yjaS0uNe0ilXrFYlKVul88yvWcUPve0zm7G61j0_1738147455
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jason,


On 1/23/25 7:50 PM, Jason Gunthorpe wrote:
> On Thu, Jan 23, 2025 at 06:10:54PM +0100, Eric Auger wrote:
>
>>> -/**
>>> - * iommu_dma_compose_msi_msg() - Apply translation to an MSI message
>>> - * @desc: MSI descriptor prepared by iommu_dma_prepare_msi()
>>> - * @msg: MSI message containing target physical address
>>> - */
>>> -static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc,
>>> -					     struct msi_msg *msg)
>>> +static inline void msi_msg_set_msi_addr(struct msi_desc *desc,
>>> +					struct msi_msg *msg, u64 msi_addr)
>> nit: msi_msg_set_addr(ess) may be enough as the populated fields are
>> address_lo/hi
> Not sure I follow, you suggest to use msi_msg_set_addr() as the
> function name? Seems Ok
Yes my minor point was just about removing the "msi" redundancy

Eric
>
> Jason
>

