Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB79423ED6D;
	Fri,  7 Feb 2025 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738939378; cv=none; b=Q4bqhj36BcC1YwkCv8egtrwj8S8NnH6VHnc3gJV/9m3p2HUbRPK/dHrV6e66cpTosfAtbtmBmVVFkOfemUwOHObAUvrqseDjPoKYkjSWYVZyXsviBxcGnP4+KcEzeaJEGxkOU8iOekeUO7tqjTcNmbQru3egGUdJ56+HQiOdHCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738939378; c=relaxed/simple;
	bh=GaRceLLlogc4o9OjwuUlKdf9YKZMOrqTjM3515LS+Rw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qCTXX+Majj5Z3a1G1ifg21t8JY6C/jXTotp/rkkDF5DaRcLfpVRb7o5vcxr1bYtynNwe7xlGlF9K4m7T+1oj6XwNnh0c6nzdwCckC2t12exXTnBN3ShpO2FFs8fvcJta8AI/5hO85me7ehXSEf657/2b3b09k/55EWPuC+EKqnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=uwqW32XE; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=jtOnsBd2; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="uwqW32XE";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jtOnsBd2"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1738939374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CkeDqYa1HLfts95iCxAWRO24Np4zPeA8eWDtJpHaVXY=;
	b=uwqW32XETTfe2u7CGshYrBNeAd+It/c+WnC1sALbfdPFvSaCtEi7ErbTUgR20g6mvbu/M/
	uyvL6Ru9wTI1Y0k9fNu8yDrlaUV2ObuZoPfcTi3xIleR68BXK9QKXuoRiyttaV7PTP0ToX
	CpdmTtj8Gh+78L3eD8joO+se52SZdPVUImCVceOqlT5aSIJjg7ajcZi5g8reOqVnNJNWNN
	y7uOinjdrR/DeMZQnvZ9J7QX7HY7bNnhgHbtN0EbdUw7g+C+tHDuSX7687DWMztvSYlAP6
	l5zNYX6/GNhCbR0TZkryf+LybkBfHCcigSqJQzRD/JXEeIOJP7CRm15wLJa+FQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1738939374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CkeDqYa1HLfts95iCxAWRO24Np4zPeA8eWDtJpHaVXY=;
	b=jtOnsBd24wYOO8DUY4nJeuOxusWoOJiTGUPwTktLczqPvXUzX1fViIYAMoXBFt08EuQf8G
	aOJ7fsBoWZzxXVBg==
To: Jason Gunthorpe <jgg@nvidia.com>, Nicolin Chen <nicolinc@nvidia.com>,
 robin.murphy@arm.com, maz@kernel.org
Cc: will@kernel.org, kevin.tian@intel.com, alex.williamson@redhat.com,
 joro@8bytes.org, shuah@kernel.org, reinette.chatre@intel.com,
 eric.auger@redhat.com, yebin10@huawei.com, apatel@ventanamicro.com,
 shivamurthy.shastri@linutronix.de, bhelgaas@google.com,
 anna-maria@linutronix.de, yury.norov@gmail.com, nipun.gupta@amd.com,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
 jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
 shameerali.kolothum.thodi@huawei.com, smostafa@google.com,
 ddutile@redhat.com
Subject: Re: [PATCH RFCv2 00/13] iommu: Add MSI mapping support with nested
 SMMU
In-Reply-To: <20250207143402.GA3651395@nvidia.com>
References: <cover.1736550979.git.nicolinc@nvidia.com>
 <20250207143402.GA3651395@nvidia.com>
Date: Fri, 07 Feb 2025 15:42:54 +0100
Message-ID: <87lduhlssx.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Feb 07 2025 at 10:34, Jason Gunthorpe wrote:
> On Fri, Jan 10, 2025 at 07:32:16PM -0800, Nicolin Chen wrote:
>> Though these two approaches feel very different on the surface, they can
>> share some underlying common infrastructure. Currently, only one pair of
>> sw_msi functions (prepare/compose) are provided by dma-iommu for irqchip
>> drivers to directly use. There could be different versions of functions
>> from different domain owners: for existing VFIO passthrough cases and in-
>> kernel DMA domain cases, reuse the existing dma-iommu's version of sw_msi
>> functions; for nested translation use cases, there can be another version
>> of sw_msi functions to handle mapping and msi_msg(s) differently.
>> 
>> To support both approaches, in this series
>>  - Get rid of the duplication in the "compose" function
>>  - Introduce a function pointer for the previously "prepare" function
>>  - Allow different domain owners to set their own "sw_msi" implementations
>>  - Implement an iommufd_sw_msi function to additionally support a nested
>>    translation use case using the approach (2), i.e. the RMR solution
>>  - Add a pair of IOMMUFD options for a SW_MSI window for kernel and VMM to
>>    agree on (for approach 1)
>>  - Add a new VFIO ioctl to set the MSI(x) vector(s) for iommufd_sw_msi()
>>    to update the msi_desc structure accordingly (for approach 2)
>
> Thomas/Marc/Robin, are we comfortable with this general approach?
> Nicolin can send something non-RFC for a proper review.
>
> I like it, it solves many of the problems iommufd had here and it
> seems logical from the irq side.

I haven't seen anything horrible. My main concern of having a proper
cached and writeable message is addressed.

Thanks,

        tglx
