Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716B5EEB2;
	Sat,  2 Aug 2025 01:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754099121; cv=none; b=c1FP2hs9Q9OVNKc/bJ5lcGKfo4UzslLA8HjAcYml3Y3mcMi9UYWoyTjO/MYOdAZZxi8Lez51HSIysuw0JAlZzSVYkHdRIgD+x/XYarFXLIGkyaD1qZhlJAyHUiZLhfuFaUvaVtipukbISBtZ0UZM/qihWe9hUscRkgbu7BBI+h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754099121; c=relaxed/simple;
	bh=wK6TVc1PZUwsK8d75b8obHYLRBlGYTxS+uhNu9OSt/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rurm8PYUnP9sjzSTJfTgR4600WCSruMF1bZv+ZX3J9gn8OVbTIY6mMczddEZmVXUn1Adjq9LoW83gGHigFtFleGFVjQqho7TsjeLgreClNZX40r4zXl/ofIKVdj4R3OUujrIiIOfpLIZsVQ2r53G68XDs8Me15F0Dz59r9Jjd9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xf9WhE0P; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xf9WhE0P"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3b788feab29so1295938f8f.2;
        Fri, 01 Aug 2025 18:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754099118; x=1754703918; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Oa6VEKGHWu4GOMTzfw3iLmn+dtBbK2I1mPfE7hlNko=;
        b=Xf9WhE0PoUgw30L+mxyVF/xdUin6uwYsW+Kr65naT+sKpCIH6wzk0FnsKontRSwvqz
         0xcJMfub/ev7QaH0V+rxYmtkwbKVCbkb+LELpidfy693UEw3ViUIHM40SMZWyUNPCqze
         eyF+qhzu1NHgKVNdDPrctudgqA5S63G9oLAsWX/QTVfruZFf2xNBU1wv4qzPLbOYp+iR
         aTSvobRRgrszAZW+Mfil72WCR+IHYk1tLWWfwOlOCBXKgcC7W6x26YNybhLBfSrchCV9
         P1pSvjgQR1ZcXwhwHCVI3fN8NUaqfWQpo29KHvR2AO1+6nCFmDrmP7eJ8na3QUWSU9bX
         92Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754099118; x=1754703918;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Oa6VEKGHWu4GOMTzfw3iLmn+dtBbK2I1mPfE7hlNko=;
        b=Hwp/dlU7APNsqsw1EtbTdV8udj7uXyqEOBpgCUjwlQ/7aS2LCIXCOeSMcckc/VDDjf
         neBnHDWHfr8ImAGcMhW6CPETAZP3oGY3pioDqyVpv63tDsDRxZgnvs+q4/AnnI7ZgLGG
         Z3+aSeIrtDgY7YZm86KAjvjp+9I93lGbFk5qRKh0SL/5ssvFhWKVQnRjM5//GS2xN9Pa
         uAMV3JmNf9Srnb1WE8/y50+DOxd7Rl/D383oQA3TTO2GrSspBWZ1BkG/h1e4RlUmaSYg
         BE6nsFv8F+BDw1FyQjc3AcFrlzkgMBI9Kc3Pvby9DtcwDqInxEhsoXD/exbZG2Js3Ulp
         7oEA==
X-Forwarded-Encrypted: i=1; AJvYcCUjFnK7CX+N+UqWg1UY7fjlPgXiB+MalxwctpgLq3Yk3ghzs2t9HnFBTX2XVzSHVHrjjUbh1g==@lists.linux.dev, AJvYcCWFK9HUHkM2vbHE17EWOV/TsR+62XAF3JThM9Q0mZmc+OFWr6ZiUX+HPt7iiaIm27VnNM8J67wEzA==@lists.linux.dev
X-Gm-Message-State: AOJu0YymOyOCtmk9hZKYc4SD8tt2IHetp8MSuF41GlTobmp5PQLliu7T
	fIK94UlnLePQJr1jN7vFWemw6Jz4VyHyuJZ6YEGCLX9stmPuvV8BxPje
X-Gm-Gg: ASbGncth4ATpnwjvEfa3suvX02Xge8ku+pC9+HbwurHjeUJAE2Pd+GJ6OTRFrqCT/H7
	X3MFNae+njnzC9MMkMZaDg9zHqhhwC5qf8D3UXlL4BRgS/aHDBzYeKfWtU7XrGq7ZVnzY5KrN3y
	m+KydN5FXlaCRbBqDfl0OnLKeVxaomweOGTMso2P1yCRJDC2y887nZxFO31v7JOriyD9AgtSybn
	+XtcentxSJyVgwmpcS/0+5eiyNrg3GEDbiDqes8TilWqwplaVXVK/Ssy9A3e3m3IP0yPNTDRkBi
	GVAL/ZZzSc6FcuVH6DBDY0BcD5OglYd1L54Z/RZxkSr8JUjNmlk34PPlcAAZbH+39qPZ2O5IYRg
	TXOatvDeuY8sI6djVAGMhDcSnVX5xZBoNglBU1GopSqa5BpfuoFA/zk4y9a1GW8q5lOUFCTm/11
	51hLPSpF+t0gOiiuub
X-Google-Smtp-Source: AGHT+IFPCqQNOdCzrCkSA1Wy1eLITRomygGgKSejfZxu72vXSW3BoWxO7nJsEbOuxmcCWT/lCWXc4w==
X-Received: by 2002:a05:6000:144f:b0:3b6:c88:7b74 with SMTP id ffacd0b85a97d-3b8d94ca8a4mr1269256f8f.59.1754099117477;
        Fri, 01 Aug 2025 18:45:17 -0700 (PDT)
Received: from [26.26.26.1] (95.112.207.35.bc.googleusercontent.com. [35.207.112.95])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c467994sm7502877f8f.50.2025.08.01.18.45.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 18:45:16 -0700 (PDT)
Message-ID: <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
Date: Sat, 2 Aug 2025 09:45:08 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/9/2025 10:52 PM, Jason Gunthorpe wrote:
> The series patches have extensive descriptions as to the problem and
> solution, but in short the ACS flags are not analyzed according to the
> spec to form the iommu_groups that VFIO is expecting for security.
> 
> ACS is an egress control only. For a path the ACS flags on each hop only
> effect what other devices the TLP is allowed to reach. It does not prevent
> other devices from reaching into this path.
Perhaps I was a little confused here, the egress control vector on the
switch port could prevent the downstream EP device from P2P TLP eaching.
while EP has no knob if is isolated.>
> For VFIO if device A is permitted to access device B's MMIO then A and B
> must be grouped together. This says that even if a path has isolating ACS
> flags on each hop, off-path devices with non-isolating ACS can still reach
> into that path and must be grouped gother.
> 
> For switches, a PCIe topology like:
> 
>                                 -- DSP 02:00.0 -> End Point A
>   Root 00:00.0 -> USP 01:00.0 --|
>                                 -- DSP 02:03.0 -> End Point B
> 
> Will generate unique single device groups for every device even if ACS is
> not enabled on the two DSP ports. It should at least group A/B together
> because no ACS means A can reach the MMIO of B. This is a serious failure
> for the VFIO security model.
Yup, whether EP A /EP B is isolated, depends on the egress ACS setting 
on their DSP.>
> For multi-function-devices, a PCIe topology like:
> 
>                    -- MFD 00:1f.0 ACS != REQ_ACS_FLAGS
>    Root 00:00.00 --|- MFD 00:1f.2 ACS != REQ_ACS_FLAGS
>                    |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
> 
> Will group [1f.0, 1f.2] and 1f.6 gets a single device group. In many cases
> we suspect that the MFD actually doesn't need ACS, so this is probably not
> as important a security failure, but from a spec perspective the correct
> answer is one group of [1f.0, 1f.2, 1f.6] beacuse 1f.0/2 have no ACS
> preventing them from reaching the MMIO of 1f.6.
I wonder if MFD/SRIOV has the egress control like switch port.

Thanks,
Ethan>
> There is also some confusing spec language about how ACS and SRIOV works
> which this series does not address.
> 
> This entire series goes further and makes some additional improvements to
> the ACS validation found while studying this problem. The groups around a
> PCIe to PCI bridge are shrunk to not include the PCIe bridge.
> 
> The last patches implement "ACS Enhanced" on top of it. Due to how ACS
> Enhanced was defined as a non-backward compatible feature it is important
> to get SW support out there.
> 
> Due to the potential of iommu_groups becoming winder and thus non-usable
> for VFIO this should go to a linux-next tree to give it some more
> exposure.
> 
> I have now tested this a few systems I could get:
> 
>   - Various Intel client systems:
>     * Raptor Lake, with VMD enabled and using the real_dev mechanism
>     * 6/7th generation 100 Series/C320
>     * 5/6th generation 100 Series/C320 with a NIC MFD quirk
>     * Tiger Lake
>     * 5/6th generation Sunrise Point
>    No change in grouping on any of these systems
> 
>   - NVIDIA Grace system with 5 different PCI switches from two vendors
>     Bug fix widening the iommu_groups works as expected here
> 
>   - AMD Milan Starship/Matisse
>     * Groups are similar, this series generates narrow groups because the
>       dummy host bridges always get their own groups. Something forcibly
>       disables ACS SV on one bridge which correctly causes one larger
>       group.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/pcie_switch_groups
> 
> v2:
>   - Revise comments and commit messages
>   - Rename struct pci_alias_set to pci_reachable_set
>   - Make more sense of the special bus->self = NULL case for SRIOV
>   - Add pci_group_alloc_non_isolated() for readability
>   - Rename BUS_DATA_PCI_UNISOLATED to BUS_DATA_PCI_NON_ISOLATED
>   - Propogate BUS_DATA_PCI_NON_ISOLATED downstream from a MFD in case a MFD
>     function is a bridge
>   - New patches to add pci_mfd_isolation() to retain more cases of narrow
>     groups on MFDs with missing ACS.
>   - Redescribe the MFD related change as a bug fix. For a MFD to be
>     isolated all functions must have egress control on their P2P.
> v1: https://patch.msgid.link/r/0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com
> 
> Jason Gunthorpe (16):
>    PCI: Move REQ_ACS_FLAGS into pci_regs.h as PCI_ACS_ISOLATED
>    PCI: Add pci_bus_isolation()
>    iommu: Compute iommu_groups properly for PCIe switches
>    iommu: Organize iommu_group by member size
>    PCI: Add pci_reachable_set()
>    PCI: Remove duplication in calling pci_acs_ctrl_enabled()
>    PCI: Use pci_quirk_mf_endpoint_acs() for pci_quirk_amd_sb_acs()
>    PCI: Use pci_acs_ctrl_isolated() for pci_quirk_al_acs()
>    PCI: Widen the acs_flags to u32 within the quirk callback
>    PCI: Add pci_mfd_isolation()
>    iommu: Compute iommu_groups properly for PCIe MFDs
>    iommu: Validate that pci_for_each_dma_alias() matches the groups
>    PCI: Add the ACS Enhanced Capability definitions
>    PCI: Enable ACS Enhanced bits for enable_acs and config_acs
>    PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
>    PCI: Check ACS Extended flags for pci_bus_isolated()
> 
>   drivers/iommu/iommu.c         | 486 +++++++++++++++++++++++-----------
>   drivers/pci/ats.c             |   4 +-
>   drivers/pci/pci.c             |  73 ++++-
>   drivers/pci/pci.h             |   5 +
>   drivers/pci/quirks.c          | 137 ++++++----
>   drivers/pci/search.c          | 294 ++++++++++++++++++++
>   include/linux/pci.h           |  50 ++++
>   include/uapi/linux/pci_regs.h |  18 ++
>   8 files changed, 846 insertions(+), 221 deletions(-)
> 
> 
> base-commit: e04c78d86a9699d136910cfc0bdcf01087e3267e

