Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2098911712
	for <patches@lists.linux.dev>; Fri, 18 Jul 2025 21:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752874184; cv=none; b=lCdBJhGUI7EdPRbum2bFQC9PNd4Qh5wL+xp6x8AY750uB2oU1L+cSskHNMWc5F3TzEyuYtEZKFjsep9vHFTUsMFCNoe+Ft3gzbrOOWfUwPM65cqzlvAncwrrfJN5Ht5mBctybRbcyMHLlspgKp/UBsLZoSTZaF5jrrxP/6ROb18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752874184; c=relaxed/simple;
	bh=qqIUQ9QIcZhmGXl17HdzCq7eHSn5RW4buAwRdLV5Ez8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uo93zN5m/UIPrNOJbbDe9+3M8nE1IriK6Myr7yYbsr6gxeqFdiVMovgO3339++8HkDUCmuEa4tjfOnX8GPuf3rjPDl6RUCY4OrX+ZensKpGb8j8G7Q/SiRTMJKbbnzdMk6PUt7cqfSErXs9EjmbgJDo+KquiCDGQy3qLXBxcj60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YstQ7PzF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YstQ7PzF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752874181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MrWlbpRkRAWEEZSZUXR7gkDwQXPo2XGHR6bPglMnBt8=;
	b=YstQ7PzF9Jn9hJwbQ48MUQXyAajxCOTN0xjxNbBIRw2pszpK+4PxREYf9Pe0c7WzBBtQHz
	ZnljVctaoH2hKFv3p+E0pivXdcSvuZ6QFSKNnnighHbzne/03MDKeoX6Ya7jJk9Yq9cTRm
	26XRO0u4NRLD7zhpGQC65rrs+PF5Juc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-eyrc45VEPoaIsaowPBbqQQ-1; Fri, 18 Jul 2025 17:29:39 -0400
X-MC-Unique: eyrc45VEPoaIsaowPBbqQQ-1
X-Mimecast-MFC-AGG-ID: eyrc45VEPoaIsaowPBbqQQ_1752874179
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ddc47aebc2so5615005ab.0
        for <patches@lists.linux.dev>; Fri, 18 Jul 2025 14:29:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752874179; x=1753478979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrWlbpRkRAWEEZSZUXR7gkDwQXPo2XGHR6bPglMnBt8=;
        b=M1G3fpmY+WnwGzcmMHlIEeKPLR30y5zr1zZ2pdnQA9bOBbxHvxAm261prPYC8VKsp6
         ulnD23QKVq9GHSJttF28iTsRPDkvNMBiL3BHYalGHbdfUhzYZ5nd5Sf7P0XJ5ktv9nuO
         zQgxjrzEZE905G9nILawbudw49JfnOqYWEZu4+kZP7QWSIFWfs9Jd/IrCrFxAWraJVut
         e1n7fegUKSv1Qw9QUl1ZFi3JNW+nDiOybq4tOeT/Z56kUWUiyaVzZ4o/5BnVrpThWHBQ
         9F047zAUBKLxiq1UYQc4/OoB31cX7DXbRafPmWQyQosQyrMa26P+8KF5dytysGQ3mJxW
         2FTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcy3ux9e1yqVBt9rWPCL04aogHm27tL9a8/8OPamMoBY/YRbIfORD20Q32+rGCGsDh7vJT5QQC@lists.linux.dev
X-Gm-Message-State: AOJu0YzAyCXAfVX+XXhkvjKm3dLrO0rBK96nZ9u3OzsmWNQ96WwjZVjj
	TSVPoByHBzYkjBH6yYSbyX8ROwdXb01RuuyuRs8eLw2Pv5j3TeA7kxZdPeDGgPs2j9Y/dwKAl7L
	TK30F8zCIpWwnaACdRwsQH1YbDdswr6TYT7CBYXBT0nNvwYnODJg5kl/N8FA=
X-Gm-Gg: ASbGnctxBwNZoW/BvP4MLgEcq107WsSCwdqxozEe/8j6VZlHKgYwSaibo/rC3F2m0AA
	drLI49ePMwtEdU0fvX3sIVf3fvhASnWI5Q45RY6GrLcwgfOROLf6iX6YoVhk0lkvPR/Yu4YCqE6
	T41MWlVfp9sUEkIxJCP4lalfAgdwfPSA5abktuAycvoyCkNa42HyY/gLYTxVdeLxobsQFn8WNBJ
	j7FvHMbJl/bY2Jx4o1tM+90mohqsc063kIy5WpHvaMej4/2LJzm+JIybFeq4bNt6fCw2mHx+unB
	/foPnUpUt4YhnRVbWER4pWtkxdYiSR5vLoiVQNZpUs8=
X-Received: by 2002:a05:6e02:3e03:b0:3dd:c927:3b4f with SMTP id e9e14a558f8ab-3e2822ea512mr31320115ab.2.1752874178377;
        Fri, 18 Jul 2025 14:29:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsXml8xvO+E+R9hAay3c6AEsvzRM4HktRe693pIg5RRbn8ITcNmOIWJ6JbB3lZ/WFgJul1Sw==
X-Received: by 2002:a05:6e02:3e03:b0:3dd:c927:3b4f with SMTP id e9e14a558f8ab-3e2822ea512mr31319925ab.2.1752874177726;
        Fri, 18 Jul 2025 14:29:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5084ca6314csm512735173.125.2025.07.18.14.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 14:29:36 -0700 (PDT)
Date: Fri, 18 Jul 2025 15:29:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev, Joerg Roedel
 <joro@8bytes.org>, linux-pci@vger.kernel.org, Robin Murphy
 <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, galshalom@nvidia.com, Joerg Roedel
 <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu
 <tony.zhu@intel.com>
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
Message-ID: <20250718152934.0cdb768f.alex.williamson@redhat.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3Ouu5jDX06HoFeTDLxVgxPc--8i0dCOwxmzucZYEGlE_1752874179
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  9 Jul 2025 11:52:03 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

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
>                                -- DSP 02:00.0 -> End Point A
>  Root 00:00.0 -> USP 01:00.0 --|
>                                -- DSP 02:03.0 -> End Point B
> 
> Will generate unique single device groups for every device even if ACS is
> not enabled on the two DSP ports. It should at least group A/B together
> because no ACS means A can reach the MMIO of B. This is a serious failure
> for the VFIO security model.
> 
> For multi-function-devices, a PCIe topology like:
> 
>                   -- MFD 00:1f.0 ACS != REQ_ACS_FLAGS
>   Root 00:00.00 --|- MFD 00:1f.2 ACS != REQ_ACS_FLAGS
>                   |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
> 
> Will group [1f.0, 1f.2] and 1f.6 gets a single device group. In many cases
> we suspect that the MFD actually doesn't need ACS, so this is probably not
> as important a security failure, but from a spec perspective the correct
> answer is one group of [1f.0, 1f.2, 1f.6] beacuse 1f.0/2 have no ACS
> preventing them from reaching the MMIO of 1f.6.

This will break various LOM configurations where the NIC is a function
within a MFD RCiEP which has or quirks ACS while the other functions
have no ACS.

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
>  - Various Intel client systems:
>    * Raptor Lake, with VMD enabled and using the real_dev mechanism
>    * 6/7th generation 100 Series/C320
>    * 5/6th generation 100 Series/C320 with a NIC MFD quirk
>    * Tiger Lake
>    * 5/6th generation Sunrise Point
>   No change in grouping on any of these systems

Sorry I haven't had much time to look at this, but it would still cause
a regression on my AlderLake system.  I get the following new
mega-group:

IOMMU Group 12:
	0000:00:1c.0 PCI bridge [0604]: Intel Corporation Raptor Lake PCI Express Root Port #1 [8086:7a38] (rev 11)
		Express Root Port (Slot+)
	0000:00:1c.1 PCI bridge [0604]: Intel Corporation Device [8086:7a39] (rev 11)
		Express Root Port (Slot+)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.2 PCI bridge [0604]: Intel Corporation Raptor Point-S PCH - PCI Express Root Port 3 [8086:7a3a] (rev 11)
		Express Root Port (Slot+)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.3 PCI bridge [0604]: Intel Corporation Raptor Lake PCI Express Root Port #4 [8086:7a3b] (rev 11)
		Express Root Port (Slot+)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.1/06:00.0 USB controller [0c03]: Fresco Logic FL1100 USB 3.0 Host Controller [1b73:1100] (rev 10)
		Express Endpoint
	0000:00:1c.2/07:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller [10ec:8125] (rev 05)
		Express Endpoint
	0000:00:1c.3/08:00.0 PCI bridge [0604]: Pericom Semiconductor PI7C9X2G404 EL/SL PCIe2 4-Port/4-Lane Packet Switch [12d8:2404] (rev 05)
		Express Upstream Port
	0000:00:1c.3/08:00.0/09:01.0 PCI bridge [0604]: Pericom Semiconductor PI7C9X2G404 EL/SL PCIe2 4-Port/4-Lane Packet Switch [12d8:2404] (rev 05)
		Express Downstream Port (Slot-)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.3/08:00.0/09:02.0 PCI bridge [0604]: Pericom Semiconductor PI7C9X2G404 EL/SL PCIe2 4-Port/4-Lane Packet Switch [12d8:2404] (rev 05)
		Express Downstream Port (Slot+)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.3/08:00.0/09:03.0 PCI bridge [0604]: Pericom Semiconductor PI7C9X2G404 EL/SL PCIe2 4-Port/4-Lane Packet Switch [12d8:2404] (rev 05)
		Express Downstream Port (Slot-)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.3/08:00.0/09:01.0/0a:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 07)
		Express Endpoint
	0000:00:1c.3/08:00.0/09:03.0/0c:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 07)
		Express Endpoint

The source of the issue is the root port at 00:1c.0, which does not
have ACS support, claims that it has a slot but there is none, and
therefore has no subordinate DMA capable devices, nor does the root
port itself have an MMIO BAR.  I don't know if there's something we can
key on for the root port to mark it isolated.

00:1c.0 PCI bridge [0604]: Intel Corporation Raptor Lake PCI Express Root Port #1 [8086:7a38] (rev 11) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 125
	IOMMU group: 12
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 6000-6fff [size=4K] [16-bit]
	Memory behind bridge: 40800000-411fffff [size=10M] [32-bit]
	Prefetchable memory behind bridge: 60e0000000-60e09fffff [size=10M] [32-bit]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), IntMsgNum 0
		DevCap:	MaxPayload 256 bytes, PhantFunc 0
			ExtTag- RBE+ TEE-IO-
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 256 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 8GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes, LnkDisable- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt+ AutBWInt+
		LnkSta:	Speed 2.5GT/s, Width x0
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg+
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCap: CRSVisible-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABC, TimeoutDis+ NROPrPrP- LTR+
			 10BitTagComp- 10BitTagReq- OBFF Via WAKE#, ExtFmt+ EETLPPrefix+, MaxEETLPPrefixes 2
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS- LN System CLS Not Supported, TPHComp- ExtTPHComp- ARIFwd+
			 AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
			 AtomicOpsCtl: ReqEn- EgressBlck-
			 IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
			 10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
		LnkCap2: Supported Link Speeds: 2.5-8GT/s, Crosslink- Retimer+ 2Retimers+ DRS-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete- EqualizationPhase1-
			 EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
			 Retimer- 2Retimers- CrosslinkRes: unsupported
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee002b8  Data: 0000
	Capabilities: [90] Null
	Kernel driver in use: pcieport

This is seen on a Gigabyte B760M DS3H DDR4 motherboard.  There's a
version of this board with wifi whereas this one has empty pads where
that m.2 slot might go.  I'd guess wifi might sit downstream of this
port if it were present, but I don't know how it'd change the feature
set of the root port.  The populated root ports show a more reasonable
set of capabilities:

00:1c.1 PCI bridge [0604]: Intel Corporation Device [8086:7a39] (rev 11) (prog-if 00 [Normal decode])
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
	Flags: bus master, fast devsel, latency 0, IRQ 126, IOMMU group 12
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: [disabled] [16-bit]
	Memory behind bridge: 41800000-419fffff [size=2M] [32-bit]
	Prefetchable memory behind bridge: [disabled] [64-bit]
	Capabilities: [40] Express Root Port (Slot+), IntMsgNum 0
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [98] Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
	Capabilities: [a0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [220] Access Control Services
	Capabilities: [200] L1 PM Substates
	Capabilities: [150] Precision Time Measurement
	Capabilities: [a30] Secondary PCI Express
	Capabilities: [a90] Data Link Feature <?>
	Kernel driver in use: pcieport

I can't say that the proposed code here is doing the wrong thing by
propagating the lack of isolation, but it's gratuitous when there is no
DMA initiator on the non-isolated branch and it causes a significant
usage problem for vfio.  Thanks,

Alex

