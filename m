Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A7437E5C0
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790619946; cv=none; b=dkUkU3B2edkFiJOHPRoKeGJpvNNmqCfaKElDq+ozOr+cPCBiN0kNZzmbf9eciF/go4ny/Rxsx03hYjOkxkwWOisU/TCXUI1UVkq3cWMtjyxIUycpcDbMm8uWz/ai1BSuSqycEI2/ANqQaknemuvih0ajPAXemrOtGhbTTVLDJ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790619946; c=relaxed/simple;
	bh=S6eNU2hZhNF7ss9QpaGLOW/V81g2oJ53iDZrrOnsD4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZi1Kyq0WEIOjOR+iBoqvSMo1PMP4gi3fVhWbfEXeng43S+spLxP7d7gNQrXOZ44GZaESErei1NYnXmTSwm73Rwn6xzLg1cl68DCQzd+31eRDOjqf/bZ8VnLT3+PRuEIEbIZ1z3k/ceniyCo8qEYvJfQcw8L0q56dcSZlAl0168=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FWuHJqll; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FWuHJqll"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d3b445a84fso8435ad.1
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 11:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790619944; x=1791224744; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S6xtdmPyxZgVCGy2Ldjj48nQ82FMLqqca6Mq7V23FWM=;
        b=FWuHJqll7s41lHP1KLy8aVdi9j9Ej/cHywVyBNxb2dAvHFaFz0aTdiw04ZZYOIVL5e
         1Nt7X+T8Q6TcT7jXirErqHxuo9wowX7Ux0LbHXeBp/EtqKE7WmpJxr6FRirXXMaVlWyG
         xb28B4T9GBvQpfmn3DkDbk5/x/yP9lYTSWZXSrwxQ0rooFR091m2+GLDoX2CnwdqSaId
         75KdIOteqfWq7OmB7cRlVwToVIdW6IqHxMbMudFNvj06kLEcey0K58a/y9LFvKlmmQV/
         Xyy38yj6Ijb6QMSGZdGxacLUspuuK7N4ECiG5Xinh8imVlWDHv/GqkT4ejB+3PsRsWhE
         2H6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790619944; x=1791224744;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S6xtdmPyxZgVCGy2Ldjj48nQ82FMLqqca6Mq7V23FWM=;
        b=OApZF0COr1eOHVvgVwUSPsnfDNugQrsvExsm+fLW9ykn+6tiRAngSskl10jA1kPdcT
         caMFxC2FrWgcxObI3mklNqoO0XhOqldM09R9RJax86MB2IoPMauKfbIxOFqc9qhqV1xd
         xFq6WBBEampA7K2YZOa4+9NEFtZAiu9080nW1PIdJcZSCIpLDpTqsxcSpyj5vcffzMI5
         5Pj4/YjFxfxYneQo52wkMQia8vy4KI+YLhC3p2Rp3HrDabdUGK+pWf8X/B9ou6ZAdl31
         npEqa6bfUluZNd1r4Upxynwuw5obmb+z+h6fBwdpH5ZWMlmQOuKe9XKmDa1I6LmnL3J6
         0JjA==
X-Forwarded-Encrypted: i=1; AKwUvBxI0SJIqVgvkN1rDBGig7NfVU7YyrG3xbFaDVm/AxZZePbA5zMLEW9iZxZF/3AQrNA+LcgOfR5S@lists.linux.dev
X-Gm-Message-State: AFq9FYIRLvDLxei9Xaqx2tvUWJZMDzo33fTcWX1WD5+cULHPboMjzhZb
	wCEHzhmVwp9VtWJClTNJIy11lSL6WIPyJAbZy9+mZTT6F+MIsHN9IMQmeAOrc82ZZA==
X-Gm-Gg: AYBFou23YzPxuXbNwyMLNW9dj41/RxE1+WguzThLjqBTsjTkUEcjW8CS9Rhk5wwKpQa
	7tcp8cESnstAq8SxZvHQqS54J8M5RrrNhiHhzVlFHXhZN5wmoKlHnoZ1qPHDTKf1F4QF7SezA9O
	k0t0TO/JZa3rthyL8BldMOgjWXVhh9aEsLC8rbYeRI7q483MswHgWbFMcWwiEJ7BOQfMZk2h5Lu
	Ys+NV9LobLOACJHwx28Tqw2EzQ4iGOhTUdV8TdDFcRZpH2+wxqKyB0gVTOK3ZZbJzWPgdoUskc4
	PkCAtp4fMOHBlzGWUeS7srRZXvbtsgwiluZAU3vNFBiqeb0tamP2RCQscIbMPfhNVd09ikUVetv
	h5ohljopfaq8K+iyg9hf/kPbNFbUxSXcVrgfXmIChEfVEQtwbl4dttuvgy9ckeOUhPY3eO4Xrcb
	tKlkQQWrFNaKWPvPZO6X3iPCcxKgEEd01Q6z35zNEDhz7XodPDqw5kAd/cjQByDJGKNzZUPF7BK
	U2/3pftHnJZh9rs4RqVF3MrhUAaUALlKK3n
X-Received: by 2002:a17:903:3a8b:b0:2cf:9ec1:ea6e with SMTP id d9443c01a7336-2e2c600c613mr28065ad.8.1790619943076;
        Mon, 28 Sep 2026 11:25:43 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a49858c123sm831538a91.3.2026.09.28.11.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 11:25:42 -0700 (PDT)
Date: Mon, 28 Sep 2026 18:25:34 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v7 8/9] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
Message-ID: <arqxHgwVXcS5PIJZ@google.com>
References: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
 <8-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 08:55:16PM -0300, Jason Gunthorpe wrote:
> The range-invalidation logic has long had a FIXME that there is not enough
> information to properly compute the range invalidation. There is also
> subtly not enough information to properly compute the single stride
> either.
> 
> Change tlbi to use the information format that iommupt is going to use for
> ARM. This prepares the invalidation code to support iommupt and fixes two
> small limitations with the current code.
> 
> iommupt is designed to accumulate all invalidation into a single gather,
> then the iommu driver should issue a small number of commands to execute
> the gather to control invalidation latency. This is in contrast to
> io-pgtable-arm.c which generates many gather flushes and direct walk cache
> flushes as it progresses.
> 
> To accommodate this the gather will accumulate "damage" in bitmaps, one
> for leaf changes and one for table changes. This is enough information for
> SMMUv3 to compute the proper stride for single invalidation and to
> generate ideal hints for range invalidation.
> 
> Change the inner workings of the tlbi process to directly use this
> new-style gather description with the idea that the iommupt conversion
> will just direct assign the gather fields to the tlbi.
> 
> Rework the three places creating the tlbi to express their needs in
> terms of the new bitmaps.
>
> 1) Simple iotlb invalidation always gets a single range of leaf
>    levels, so it can set a single leaf bit
> 
> 2) Walk invalidation is expected to clear the table and all the leaves it
>    could contain. Set a single table bit and all the leaf bits.
> 
>    There is a weakness in the existing io-pgtable where it double
>    invalidates the leaves, once through the arm_smmu_tlb_inv_walk() then
>    again through the gather. Since these are separate operations they are
>    not capped by the invalidation count limits and a single unmap may end
>    up doing thousands of tlbi commands. Eventually converting to iommupt's
>    gather only approach will correct this.
> 
> 3) SVA invalidation has no idea what the MM did, so it will set all
>    the bits in the bitmaps.
> 
>    This corrects another weakness where the range-invalidation logic
>    was generating hints assuming the #2 rules which isn't correct
>    for SVA.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
