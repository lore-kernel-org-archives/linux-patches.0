Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7470440BF5;
	Thu, 20 Feb 2025 03:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740020474; cv=none; b=Nl9wgEF0GxwggjV7dsBTL/GP41vU1YDMlFFsMX4gZNKUlnSawTpdZ/8DKSLJOXoB7njNNBo7KmNAwwGO4I424o7vUsgKmV8LK67nwv74bi6JT6FzTPLrX8nPS6/sDagXt5Mx/EJeeSFQyFB6HbAbzMsVBzJJgXHMTAdzdoSSmAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740020474; c=relaxed/simple;
	bh=GgoJlz2jPr/qwlsY8e1IkYJ77lWBUWVpOkblF7afKIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hj8VIgXgqYOd1a1MIhcsHp1wRLw4r+dNF3rNDdJ8v54bR2NjZq9Vq4LXBlp8y+9O7zjorWuV/OvCv0o+r0VGnqe12oHNscU06hym8F5bfp+7UYWgALWUSSqrMiny848xVJvwHIqvEXnYQ49KvYQdjPPJBI9iQ/SKMWNlU6fpnKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dfPMHLBh; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dfPMHLBh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740020474; x=1771556474;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GgoJlz2jPr/qwlsY8e1IkYJ77lWBUWVpOkblF7afKIo=;
  b=dfPMHLBh7hGo0E2U/gofXnabjHQJmI/dscGD/AfC8M+18nqo2wxQlVYJ
   P8iDXIdbq/z2y2PnyH7UTN4SokMcq/yCG4Y08wtAkZkPy5lWqQZYjJ6qJ
   y1p/OoXs8YVIYzcCWEfcZdyYawE1UJvgIri98jiJlNSlNBhkeq+Kv8EfD
   EOu6QI4v1Li4HmFk35sVmSjh1az/gE708fIWyEGpRaFLDhzX9d9VjYQiC
   Sr5Zj2JUOQp7KPF7oqL5wlikY01oxUU+ol5tcYhhuzBTlhJiTvbQfJXZX
   KUYAFeofKxtYbTEsOunyJji1GJ/jA/AtZ7NoquLPFr6EjslNjndmMVdKl
   w==;
X-CSE-ConnectionGUID: C+BUZDKMRdSImMqkOA6hGA==
X-CSE-MsgGUID: +f/2U595TYq2B2oNe/LtAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="63262814"
X-IronPort-AV: E=Sophos;i="6.13,300,1732608000"; 
   d="scan'208";a="63262814"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 19:01:13 -0800
X-CSE-ConnectionGUID: ASLd7yOuRZCkrnaM+52Yig==
X-CSE-MsgGUID: Z10pUH/FR6uYu8OYbSdHnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="115388409"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 19:01:11 -0800
Message-ID: <98298574-66b6-4b14-be3b-28291f1551a8@linux.intel.com>
Date: Thu, 20 Feb 2025 10:58:05 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
To: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Yu Zhang <zhangyu1@linux.microsoft.com>
Cc: jacob.pan@linux.microsoft.com,
 Easwar Hariharan <eahariha@linux.microsoft.com>,
 "zhangyu1@microsoft.com" <zhangyu1@microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
 Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250212112235.714b0a14@DESKTOP-0403QTC.>
 <20250212233053.GV3754072@nvidia.com>
 <67ad876d.170a0220.3c21dc.85ceSMTPIN_ADDED_BROKEN@mx.google.com>
 <20250213094601.GA243081@myrica>
 <5irmuy6xwrjsrdjy7tmfzlnotxqdoqagjdsdtqjrrit673zaka@r43nyvc5gcyf>
 <20250213180919.GC243081@myrica>
 <cu7lznx5bxnqoavt3ri4dtzwt7lu3loitn7a344rbnmahpnc6h@2e2dknchxjmd>
 <20250219103518.GA513544@myrica>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250219103518.GA513544@myrica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/25 18:35, Jean-Philippe Brucker wrote:
> On Wed, Feb 19, 2025 at 05:39:19PM +0800, Yu Zhang wrote:
>> On Thu, Feb 13, 2025 at 06:09:19PM +0000, Jean-Philippe Brucker wrote:
>>> On Fri, Feb 14, 2025 at 01:03:43AM +0800, Yu Zhang wrote:
>>>> On Thu, Feb 13, 2025 at 09:46:01AM +0000, Jean-Philippe Brucker wrote:
>>>>> Hi Jacob,
>>>>>
>>>>> On Wed, Feb 12, 2025 at 09:47:23PM -0800, Jacob Pan wrote:
>>>>>> Our code and backend support are still in the early stages, that is why
>>>>>> I am attempting to convert virtio-iommu driver to iommu_pt. Not sure if
>>>>>> anyone has done the QEMU part to support VIRTIO_IOMMU_F_ATTACH_TABLE?
>>>>>> @Jean @Eric Do you know?
>>>>> As far as I know Tina worked on this most recently:
>>>>> https://github.com/TinaZhangZW/qemu/commits/virtio-iommu/vt-d-pgtable/
>>>>> https://lore.kernel.org/all/20231106071226.9656-1-tina.zhang@intel.com/
>>>> Thanks a lot for this information, Jean.
>>>> IIUC, these patches were trying to add VT-d IO page table support in
>>>> virtio-iommu, but it is not based on Jason's generic PT [1]. Just wondering,
>>>> does anyone have plan to do the incorporation?
>>> I'm not aware of anyone working on this at the moment. Something you will
>>> need for a portable pviommu is a library that manages PASID tables rather
>>> than page tables [1], because the Arm SMMUv3 arch only support assigning
>>> PASID tables to the guest. Alternatively you could implement opaque PASID
>>> table allocation via host calls, letting the guest allocate GPA space and
>>> the host manage the PASID table, but that idea didn't seem very popular at
>>> the time.
>> Thank you, Jean. Just had a study of the spec. For ARM SMMUv3, letting
>> the guest manage the PASID table, and then assigning it directly to the
>> backend in ATTACH_TABLE request looks quite resonable. But for VT-d,
>> my understanding is the PASID table shall be managed by host. By "that
>> idea didn't seem very popular", do you mean that people also want the
>> ATTCH_TABLE request for VT-d also assign the PASID table(an virtual one
>> managed by the guest). If yes, why?
> No, the proposal for managing the PASID table in the host was done before
> the VT-d architecture added Scalable mode, so at the time they also had to
> assign whole PASID tables to the guest and weren't keen on managing it in
> the host. I believe in revision 3 (2018) the architecture added support
> for Scalable mode and the ability to manage PASID tables in the host.
> 
> Nowadays it wouldn't make sense for a pvIOMMU to manage the VT-d PASID
> tables in the guest, because as I understand it there is no demand for
> supporting the legacy mode address translation of VT-d.

Are you talking about ECS mode? There is no hardware or software
implementation for this mode, so we don't need to consider it.

Thanks,
baolu
