Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3CC2B9BC;
	Sat,  3 Aug 2024 16:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722701361; cv=none; b=DKYHbCMqTzttyvieVoUuNWlN1+NMLWtGIYfgg7e9QNi5tyx7yzGys9CcNeOd3L7Eps3dqsn1zNXLWtGvSSjXKmeExYyv01yAyUTwADQSWwK0zcJ+bL9drkDQwl8nqARPXZ34gU9bVEAqLrTenM0MZ90TKYkyIfMWBVyzGobgRmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722701361; c=relaxed/simple;
	bh=9A7iCF6zv/opOx5edCvUiK6k/UcLzk4/WarXeecC1lo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l4UKqquxZpLpDyKxAYSfxgBj4Ds+6s6YfwMxJiqsy9T7UhRo7AoO+LjVfVtGQnIidolGdezyBOtknhO/VpFBFtOnxAu0ycEFTJk76sZPTztkGCvEYhsP8hVF+Aizf75H15crGlBLUWJAVoDz4fOFshfzNcSbzxGJanQzq9dEuRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b=GGFwGmUI; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b="GGFwGmUI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1722701336; x=1723306136; i=s.l-h@gmx.de;
	bh=+cHClZbdGxIMOk8LL9YxgGVTm9K2LsxdELopQfuv6Ts=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=GGFwGmUIuw2NaaIPU1KEMakaSqL+BdMXKscI1jlyppxJxC5GUNgGAWGY7CFagYU9
	 bknydWgT+y3/X5YaypFHcoY0uvRMgDbokCEVewL6D5DTej3+qjXjajWDO1jTHPN3m
	 zeNISrNmw0pymq6D0QMxLzBl2iatfP9L/7vP4aKdFYgLheIYjHHfxhc5PxG0QEmyh
	 NVLzXbag/MacwzUE3pPIrlqFMMabxl1hDF/Cx0c9+bFYltfDsT8GrWkSsJqsxOuTk
	 mG08OZH/d8zNCOArlQiu3xadIb0ALfNX1WpG80n1xOcwAHzwfDuAbkw3zVwhO5Akg
	 MLOwkqtxq8K5xC/KOw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mir ([94.31.83.155]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MQMuR-1swT1d1auv-00LS1Q; Sat, 03
 Aug 2024 18:08:56 +0200
Date: Sat, 3 Aug 2024 18:08:52 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Sean Young <sean@mess.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Zheng Yejian <zhengyejian1@huawei.com>, Hans
 Verkuil <hverkuil-cisco@xs4all.nl>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 288/809] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <20240803180852.6eb5f0cb@mir>
In-Reply-To: <Zq5KcGd8g4t2d11x@gofer.mess.org>
References: <20240730151724.637682316@linuxfoundation.org>
	<20240730151735.968317438@linuxfoundation.org>
	<20240801165146.38991f60@mir>
	<Zq5KcGd8g4t2d11x@gofer.mess.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6QuJDInwptWbzgfuju7pAmx0ICFJ1QMLWnNoejNczATEnatdiRf
 xqNqlbI0KlzO1sR9BbebD9ekUmSLUkNjJO1NMhzdqMhGeFolFAFBac+1mD3bIsp1es8pEW9
 yFDbNnmDs6BdI4RV8pVknW+Gy1PCfwBjOhukdALq32uE4oCCdRvYY4fKh0DPrrkOy9LtmvY
 iu855W44ONBd0frINv6wg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:22aJDk7QQOc=;IyINya9YFLKpYtQITfc3IMw3hhi
 VTyBwaC4jy4o60dwr5klEQoVZha7mwYiU4bfuy1r2kXzSab2Zngjr5SHnWZStIbxk+6kBK0bE
 VGTg3PxNDnNwpnK6LGXhM7LEuZnj1w3H4pQStlC+PQ0Q1f83jArgkEA+3RQMgqYrAuHZQ+Imq
 nP7Ts0LLqYPqjofxfxZyMuofjbpcW007jlTCirjNvBVxkb2adBFyCkBRGRDl0WpVeqbX4V1Y4
 z1IBgvVUXTE3jv6g8LmRwK6cWYmzTJqC75QDp/ic5jOGQo6DeSlcvA0A83g3r0BCRtSc1iRHf
 n0eqnqzoCpNeVX+ApEgVaPG8FwJfgeCPZ/z/9fJda90MpshVIAZe/1kFfIM5OHGTdubged5Bd
 i/wbsMgeEx+rhA7mGaPm5P9redSrQw1ZhsQlrI0upe8iM7wQxxAgOBWditttM1oSrBTJU4gsJ
 9ER8WCPQLcZtTSsJKQFOrJLh5Y1NB/IeNwlzgczIaZWL9J7KElioBFBC4FqD5Wgg4hk2pa7nd
 7rW4UfoK1fVoAeOq+mD1Z+ff4xJBycMXvoCMgphGrGbKlsQW4RZ6j/D94uLyo8I3HxY9ZMqDE
 Q7idZRso4QBVE90xtFtp7tLInkDe7EcYDu7+Nc7/uAO4WCqaWLmrNpXrrf0pKBHyTI7WlySAJ
 L+fuPyNEiliL7safFo/waiWIYVTBQIkxns6kmFaBpflJivCKN90XJReriE3ETg3GcQx45nXSb
 Ynf7J9Nrets4CkCHgbFgphDATwOxe7M/YoCf7lsvE3UQcW4mdOZisxorfZqq4mEavtdfn1PS2
 OfBuCL/j3/ljw2m797EZ1foQ==

Hi

On 2024-08-03, Sean Young wrote:
> On Thu, Aug 01, 2024 at 04:51:46PM +0200, Stefan Lippers-Hollmann wrote:
> > Hi
> >
> > On 2024-07-30, Greg Kroah-Hartman wrote:
> > > 6.10-stable review patch.  If anyone has any objections, please let =
me know.
> > >
> > > ------------------
> > >
> > > From: Zheng Yejian <zhengyejian1@huawei.com>
> > >
> > > [ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]
> > >
> > > Infinite log printing occurs during fuzz test:
> > >
> > >   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
> > >   ...
> > >   dvb-usb: schedule remote query interval to 100 msecs.
> > >   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initiali=
zed ...
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >   ...
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >
> > > Looking into the codes, there is a loop in dvb_usb_read_remote_contr=
ol(),
> > > that is in rc_core_dvb_usb_remote_init() create a work that will cal=
l
> > > dvb_usb_read_remote_control(), and this work will reschedule itself =
at
> > > 'rc_interval' intervals to recursively call dvb_usb_read_remote_cont=
rol(),
> > > see following code snippet:
> > [...]
> >
> > This patch, as part of v6.10.3-rc3 breaks my TeVii s480 dual DVB-S2
> > card, reverting just this patch from v6.10-rc3 fixes the situation
> > again (a co-installed Microsoft Xbox One Digital TV DVB-T2 Tuner
> > keeps working).
>
> Thanks for reporting this ...
>
> So looking at the commit, it must be that one of the usb endpoints is
> neither a send/receiver bulk endpoint. Would you mind sending a lusb -v
> of the device, I think something like:
>
> 	lsusb -v -d 9022:d482
>
> Should do it, or -d 9022::d481

It doesn't show up as 9022:d482 or 9022:d481, but as two 9022:d660.

system 1, raptor-lake:

# lsusb -v -d 9022:d660

Bus 001 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x9022 TeVii Technology Ltd.
  idProduct          0xd660 DVB-S2 S660
  bcdDevice            0.00
  iManufacturer           1 TBS-Tech
  iProduct                2 DVBS2BOX
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0020
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 [unknown]
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Bus 002 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x9022 TeVii Technology Ltd.
  idProduct          0xd660 DVB-S2 S660
  bcdDevice            0.00
  iManufacturer           1 TBS-Tech
  iProduct                2 DVBS2BOX
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0020
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 [unknown]
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

# lspci -vvv -d 9710:9990
07:00.0 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 10 [OHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 178
        IOMMU group: 23
        Region 0: Memory at 85407000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee00998  Data: 0000
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 10W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=3DFixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTr=
ans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR2=
56-
                        Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Df=
f
                        Status: NegoPending- InProgress-
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

07:00.1 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 20 [EHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 174
        IOMMU group: 23
        Region 0: Memory at 85406000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee008d8  Data: 0000
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 10W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

07:00.2 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 10 [OHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 190
        IOMMU group: 23
        Region 0: Memory at 85405000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee009f8  Data: 0000
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 10W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

07:00.3 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 20 [EHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 173
        IOMMU group: 23
        Region 0: Memory at 85404000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee008b8  Data: 0000
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 10W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

07:00.4 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 10 [OHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 191
        IOMMU group: 23
        Region 0: Memory at 85403000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee00b18  Data: 0000
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 10W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

07:00.5 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 20 [EHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 176
        IOMMU group: 23
        Region 0: Memory at 85402000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee00938  Data: 0000
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 10W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

07:00.6 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 10 [OHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin D routed to IRQ 192
        IOMMU group: 23
        Region 0: Memory at 85401000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee00b38  Data: 0000
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 10W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

07:00.7 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 20 [EHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin D routed to IRQ 175
        IOMMU group: 23
        Region 0: Memory at 85400000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee00918  Data: 0000
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 10W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

########

system 2, sandy-bridge:

# lsusb -v -d 9022:d660

Bus 003 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x9022 TeVii Technology Ltd.
  idProduct          0xd660 DVB-S2 S660
  bcdDevice            0.00
  iManufacturer           1 TBS-Tech
  iProduct                2 DVBS2BOX
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0020
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 [unknown]
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Bus 006 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x9022 TeVii Technology Ltd.
  idProduct          0xd660 DVB-S2 S660
  bcdDevice            0.00
  iManufacturer           1 TBS-Tech
  iProduct                2 DVBS2BOX
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0020
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 [unknown]
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

# lspci -vvv -d 9710:9990
01:00.0 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 10 [OHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 29
        Region 0: Memory at f7b07000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee20004  Data: 0021
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 25W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=3DFixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTr=
ans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR2=
56-
                        Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D0=
1
                        Status: NegoPending- InProgress-
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

01:00.1 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 20 [EHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 27
        Region 0: Memory at f7b06000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee04004  Data: 0021
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 25W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

01:00.2 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 10 [OHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 32
        Region 0: Memory at f7b05000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee01004  Data: 0021
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 25W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

01:00.3 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 20 [EHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 24
        Region 0: Memory at f7b04000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee40004  Data: 0020
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 25W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

01:00.4 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 10 [OHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin C routed to IRQ 33
        Region 0: Memory at f7b03000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee02004  Data: 0022
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 25W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

01:00.5 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 20 [EHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 25
        Region 0: Memory at f7b02000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee80004  Data: 0020
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 25W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

01:00.6 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 10 [OHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin D routed to IRQ 34
        Region 0: Memory at f7b01000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee04004  Data: 0022
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 25W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

01:00.7 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe=
 to 4-Port USB 2.0 Host Controller (prog-if 20 [EHCI])
        Subsystem: Asix Electronics Corporation (Wrong ID) Device 4000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin D routed to IRQ 26
        Region 0: Memory at f7b00000 (32-bit, non-prefetchable) [size=3D4K=
]
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee01004  Data: 0020
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+=
,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Express (v1) Endpoint, IntMsgNum 0
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unl=
imited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Sl=
otPowerLimit 25W TEE-IO-
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM not support=
ed
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, LnkDisable- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

I hope this helps a little.

Regards
	Stefan Lippers-Hollmann
