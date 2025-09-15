Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AF8223DF0
	for <patches@lists.linux.dev>; Mon, 15 Sep 2025 09:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757929313; cv=none; b=VQ3tXbR9oQv3uNJeGmTFdFgJMxB4oTXao0ny2/Dx6gTF9LXn4Rv/+vDDY2GamRgGLoBBemoa7ZlcSBujeogrOS/AylFfPJuAq/wNxlfnaT4meJotyzzxpvWBQtHRwfY6i8w1mFRMCVW2XwomoFlZ20+AR2PP8KVuOkTpi1zm/OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757929313; c=relaxed/simple;
	bh=bpFMZabaBpAY2pP5TxRVkzX6A/el9BHedG8sx0ri/pA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oESFthJ4SJd+LsVUvu1odk7sn4SqShsh2+Ip6ki//B1Bzt/U9D6rSR0p8e1HNqOxPoccOhW5Da8NZ70oQtlDAa4lZj5nYm4HPhr+S2DJ8j/vXLIGApwGo2HXTAjP/LEcBUbYj48xM/wUmcnru2OS/UBYxP8jfHOITzLk8Q3gQnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MHRdwX7i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MHRdwX7i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757929309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uyyAmT26WPY63DOQqTvlGR3GzEVA1MQHKPqxpl3/fSQ=;
	b=MHRdwX7iH1mNGB0WToY8QFgNel7eOPQhBKVmSI30KScbIs+jHSU5GPajKjmiXUzJ/beuv9
	fG2peb5R1SKHgkN1xPwVCXnN+LVu7tkf4jN/Em+twg2fdvccnnbXhI5w158UlHXCArhZND
	GvBvZCv/dF/DFI7+XczkiaYWs7ozra4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-XG_93oYtOmKhMAnHUIfstA-1; Mon, 15 Sep 2025 05:41:48 -0400
X-MC-Unique: XG_93oYtOmKhMAnHUIfstA-1
X-Mimecast-MFC-AGG-ID: XG_93oYtOmKhMAnHUIfstA_1757929307
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3eae869cb3fso349533f8f.0
        for <patches@lists.linux.dev>; Mon, 15 Sep 2025 02:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757929307; x=1758534107;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uyyAmT26WPY63DOQqTvlGR3GzEVA1MQHKPqxpl3/fSQ=;
        b=H9dE8TfAtqP3v/BcJU9yNAhKcFQjiLXsB0JmFCmtckFnCnAnV3R7+9WlBZhCW12GTK
         OdYM6fmzhPW+8xvCP94p58PXB5s3+TVz2QAavLlrcHRLvdLwUaFDh9HFw3hjOE+Okn7m
         WIE2fWAj8fWWtH4n/5gMuiTA3lwYOrpXQWGoTUatJNV9D36NGm1w4DHYXh/KBe/EclA2
         Wz2WJInFc42ylunYTmYb5iflfg80Zf+dd0db+RS0BjaQCR9aLDzq1s5e2siKzAo/yx5+
         1pECitH8CCl4KMvLKHk5fmq6I53UdZTsvth6EgrzlncQ+da2Oveb13V0GBjkxoqA1/S+
         DjUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdqudIsANWtKnvWGypd0gshZA6adyMYc+TBKfvZqB/YcrHkN8E91qsRZo3Iu3BoFtm6yfSMKex@lists.linux.dev
X-Gm-Message-State: AOJu0YxZCxNAWWgMeRwDRXQIciD4HIkJ6CXH3K3G+uu0NEYqBSSMjeoj
	LImNiS0O0ch3+VN6dnl2HAeVMN6YXPY423qdTQWDGUf6qGWiA0iofm9ZKEw8Kxd6TzeFJT+0FkG
	AbAFCrnQaUjw+nAIInQTbu/EXLvZbxI/X5Sg2Oz3/96pa27PHNtGVpSlOyAI=
X-Gm-Gg: ASbGnct71TjkKPZtF5X0tdZJp9VaC/Vv/CzumFNAvbvg9WXNEMckV3PVJNBM7y5J7oX
	L2oCbLeT8Mlge8EWvV8qarUHfbHdw224/lvU/kX6FplRdhA67nd+kACWzdwXwa1SdnGnQtvAs0I
	tXn8up2zWppmGcpGWAWPvpvVqnVwLa+K9uqP0MpdfXAX4T9rvUpRod7D1VkFL3qOcQ2nD+BhGOI
	UzU5i8uX4AL4JJIzUOfBXvRTHwvRuxB/PFYptA3a2bgYFybzLXwjoHt2/xXmImrFFiU9skSik61
	/+TUONNQwIwYKslYWBnvG8Rif+SCfrA9nA+Lcl/95RSWsZELr1Rm3k2JVPvOoe3Kt73i29bPPfr
	8pLk=
X-Received: by 2002:a05:6000:22c1:b0:3da:d8a1:9b86 with SMTP id ffacd0b85a97d-3e765a09221mr8615316f8f.50.1757929307078;
        Mon, 15 Sep 2025 02:41:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFg3xxaOKspn1hA6O93v4fHlqqQJyEimS5ZxAfU8EHz2MjAiPIfjWh2uApK5fHPxe09sU8QnA==
X-Received: by 2002:a05:6000:22c1:b0:3da:d8a1:9b86 with SMTP id ffacd0b85a97d-3e765a09221mr8615288f8f.50.1757929306566;
        Mon, 15 Sep 2025 02:41:46 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ebc49f7ebbsm660792f8f.51.2025.09.15.02.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 02:41:46 -0700 (PDT)
Message-ID: <835a9022-aca1-49ec-a704-578a4b3c5bbd@redhat.com>
Date: Mon, 15 Sep 2025 11:41:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/11] Fix incorrect iommu_groups with PCIe ACS
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, Donald Dutile <ddutile@redhat.com>,
 galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, maorg@nvidia.com,
 patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GrFrhKOpmCK6SwyLlXLuU8sMjfgjp_IHRdjsKQ11ICc_1757929307
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/5/25 20:06, Jason Gunthorpe wrote:
> The series patches have extensive descriptions as to the problem and
> solution, but in short the ACS flags are not analyzed according to the
> spec to form the iommu_groups that VFIO is expecting for security.
> 
> ACS is an egress control only. For a path the ACS flags on each hop only
> effect what other devices the TLP is allowed to reach. It does not prevent
> other devices from reaching into this path.
> 
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
> 
> For multi-function-devices, a PCIe topology like:
> 
>                    -- MFD 00:1f.0 ACS not supported
>    Root 00:00.00 --|- MFD 00:1f.2 ACS not supported
>                    |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
> 
> Will group [1f.0, 1f.2] and 1f.6 gets a single device group. However from
> a spec perspective each device should get its own group, because ACS not
> supported can assume no loopback is possible by spec.
> 
> For root-ports a PCIe topology like:
>                                           -- Dev 01:00.0
>    Root  00:00.00 --- Root Port 00:01.0 --|
>                    |                      -- Dev 01:00.1
> 		  |- Dev 00:17.0
> 
> Previously would group [00:01.0, 01:00.0, 01:00.1] together if there is no
> ACS capability in the root port.
> 
> While ACS on root ports is underspecified in the spec, it should still
> function as an egress control and limit access to either the MMIO of the
> root port itself, or perhaps some other devices upstream of the root
> complex - 00:17.0 perhaps in this example.
> 
> Historically the grouping in Linux has assumed the root port routes all
> traffic into the TA/IOMMU and never bypasses the TA to go to other
> functions in the root complex. Following the new understanding that ACS is
> required for internal loopback also treat root ports with no ACS
> capability as lacking internal loopback as well.
> 
> There is also some confusing spec language about how ACS and SRIOV works
> which this series does not address.
> 
> 
> This entire series goes further and makes some additional improvements to
> the ACS validation found while studying this problem. The groups around a
> PCIe to PCI bridge are shrunk to not include the PCIe bridge.
> 
> The last patches implement "ACS Enhanced" on top of it. Due to how ACS
> Enhanced was defined as a non-backward compatible feature it is important
> to get SW support out there.
> 
> Due to the potential of iommu_groups becoming wider and thus non-usable
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


FWIW, I have tested this series on some of the systems I use
for upstream VFIO  :

   Intel(R) Xeon(R) Silver 4310 CPU @ 2.10GHz
   Intel(R) Xeon(R) Silver 4514Y
   Intel(R) 12th Gen Core(TM) i7-12700K
   Neoverse-N1

I didn't see any regressions on IOMMU grouping like on v2.
Please ping me if you need more info on the PCI topology.

I also booted an IBM/S390 z16 LPAR with VFs to complete the
experiment. All good.



>    The 6/7th gen system has a root port without an ACS capability and it
>    becomes ungrouped as described above.
> 
>    All systems have changes, the MFDs in the root complex all become ungrouped.
> 
>   - NVIDIA Grace system with 5 different PCI switches from two vendors
>     Bug fix widening the iommu_groups works as expected here
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/pcie_switch_groups
> 
> v3:
>   - Rebase to v6.17-rc4
>   - Drop the quirks related patches
>   - Change the MFD logic to process no ACS cap as meaning no internal
>     loopback. This avoids creating non-isolated groups for MFD root ports in
>     common AMD and Intel systems
>   - Fix matching MFDs to ignore SRIOV VFs
>   - Fix some kbuild splats
> v2: https://patch.msgid.link/r/0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com
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
> Cc: galshalom@nvidia.com
> Cc: tdave@nvidia.com
> Cc: maorg@nvidia.com
> Cc: kvm@vger.kernel.org
> Cc: Ceric Le Goater" <clg@redhat.com>

Curiously, I didn't get the email. weird.

Cheers,

C.



> Cc: Donald Dutile <ddutile@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (11):
>    PCI: Move REQ_ACS_FLAGS into pci_regs.h as PCI_ACS_ISOLATED
>    PCI: Add pci_bus_isolated()
>    iommu: Compute iommu_groups properly for PCIe switches
>    iommu: Organize iommu_group by member size
>    PCI: Add pci_reachable_set()
>    iommu: Compute iommu_groups properly for PCIe MFDs
>    iommu: Validate that pci_for_each_dma_alias() matches the groups
>    PCI: Add the ACS Enhanced Capability definitions
>    PCI: Enable ACS Enhanced bits for enable_acs and config_acs
>    PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
>    PCI: Check ACS Extended flags for pci_bus_isolated()
> 
>   drivers/iommu/iommu.c         | 510 +++++++++++++++++++++++-----------
>   drivers/pci/ats.c             |   4 +-
>   drivers/pci/pci.c             |  73 ++++-
>   drivers/pci/search.c          | 274 ++++++++++++++++++
>   include/linux/pci.h           |  46 +++
>   include/uapi/linux/pci_regs.h |  18 ++
>   6 files changed, 759 insertions(+), 166 deletions(-)
> 
> 
> base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0

