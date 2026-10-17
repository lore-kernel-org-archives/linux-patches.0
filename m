Received: from email.studentenwerk.mhn.de (email.studentenwerk.mhn.de [141.84.225.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC242D3225
	for <patches@lists.linux.dev>; Sat, 17 Oct 2026 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.84.225.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258374; cv=none; b=Q95OInzIdyRDhuD75rsHsqPcvF3BXNFYTq3DNN+T1h+Dv8XrPMVgyzgx322OsCIzL8l6D8/bAaApFpEbKUuPtFqGkuWSE5vPeIMYMM1bKqgKBAEdFbFvKksicnAu/nA8V9PJmsNjggomjxtfHEZLNIuE7KUH/qW90rdRRV5yJ3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258374; c=relaxed/simple;
	bh=hQahv0hMCndcw6zIO0AYyaRPTZcR+z1uS6lyARz84fg=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type; b=lQ7smFNebi5VvZM+dc8hHL3CwVq4Hn4L1NCzjwR1eod2CRUp67jTgzuWyfDaTC10A2kChUTlEYJmCxl02mJigxFZFRYBs2GeqihjwhRsDp7B1mwrf7eV1q7Tc5uKOXuuB2KG0NwD0MSYvQaw1oklZYDrX1EDGUhXbBWNw/pyX58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stwm.de; spf=pass smtp.mailfrom=stwm.de; dkim=pass (2048-bit key) header.d=stwm.de header.i=@stwm.de header.b=a0dM+Srr; arc=none smtp.client-ip=141.84.225.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stwm.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stwm.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stwm.de header.i=@stwm.de header.b="a0dM+Srr"
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
	by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4j6TJH0j33zRhRH;
	Sat, 17 Oct 2026 19:26:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
	t=1792258015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9hlGfBTH5SRn2sKFvC+kkCjNIomiHxWGIsWXi0zLoJI=;
	b=a0dM+Srr1R9e4TaDDpqBz4VxRD4QjnSMJIrxqFWBi0ndK91O9wjGeiGfG/yQxed5mQeNAK
	Vnzrqtx3ef2T6bzxkpUthOMugSC6KhZScV63gJ7AvLHmkHs2pkek9gBADayYW76XCT6n4m
	FwQCPpOjfL2mQVTcJb9uizhgw/Q+BYQJEVoM4HSZkq2P3ADRLYi3cZvZ5cITbK2e9ZaGOr
	fhRCcqDxCktM6iUfCzuz+qyHSkyGNi8SAth2cRRYbfTq8udt4ug4hHBlSt2jQFI/7bbRrD
	gJ7FC6gzKS+wlpbfzRIx4/PH1GDm1zpqEslPJUmmriAAIYoMUXrh1FkRqequyw==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sat, 17 Oct 2026 19:26:54 +0200
From: Wolfgang Walter <linux@stwm.de>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Sasha Levin <sashal@kernel.org>
Subject: regression 6.18.57: acpi power button vanished in machines running in
 qemu
Message-ID: <5fe757e7aa54c38df3525d313598db99@stwm.de>
X-Sender: linux@stwm.de
Organization: =?UTF-8?Q?Studierendenwerk_M=C3=BCnchen_Oberbayern?=
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

Hello,

since 6.18.57 there is no acpi power button any more in virtual qemu 
based machines (as far as I can see model doesn't matter).

Here the output of dmesg | grep -i acpi with 6.18.57:
[    0.003119] ACPI: Early table checksum verification disabled
[    0.003122] ACPI: RSDP 0x00000000000F5250 000014 (v00 BOCHS )
[    0.003125] ACPI: RSDT 0x000000007FFE2439 000038 (v01 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.003129] ACPI: FACP 0x000000007FFE2229 0000F4 (v03 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.003133] ACPI: DSDT 0x000000007FFE0040 0021E9 (v01 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.003136] ACPI: FACS 0x000000007FFE0000 000040
[    0.003137] ACPI: APIC 0x000000007FFE231D 000080 (v03 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.003139] ACPI: HPET 0x000000007FFE239D 000038 (v01 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.003141] ACPI: MCFG 0x000000007FFE23D5 00003C (v01 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.003143] ACPI: WAET 0x000000007FFE2411 000028 (v01 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.003144] ACPI: Reserving FACP table memory at [mem 
0x7ffe2229-0x7ffe231c]
[    0.003145] ACPI: Reserving DSDT table memory at [mem 
0x7ffe0040-0x7ffe2228]
[    0.003146] ACPI: Reserving FACS table memory at [mem 
0x7ffe0000-0x7ffe003f]
[    0.003147] ACPI: Reserving APIC table memory at [mem 
0x7ffe231d-0x7ffe239c]
[    0.003147] ACPI: Reserving HPET table memory at [mem 
0x7ffe239d-0x7ffe23d4]
[    0.003148] ACPI: Reserving MCFG table memory at [mem 
0x7ffe23d5-0x7ffe2410]
[    0.003148] ACPI: Reserving WAET table memory at [mem 
0x7ffe2411-0x7ffe2438]
[    0.005074] ACPI: PM-Timer IO Port: 0x608
[    0.005087] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.005122] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.005124] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high 
level)
[    0.005125] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high 
level)
[    0.005126] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high 
level)
[    0.005127] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high 
level)
[    0.005129] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.005130] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.037513] ACPI: Core revision 20250807
[    0.056253] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.068690] ACPI: Added _OSI(Module Device)
[    0.068692] ACPI: Added _OSI(Processor Device)
[    0.068693] ACPI: Added _OSI(Processor Aggregator Device)
[    0.069380] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    0.070389] ACPI: Interpreter enabled
[    0.070400] ACPI: PM: (supports S0 S3 S4 S5)
[    0.070402] ACPI: Using IOAPIC for interrupt routing
[    0.070479] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.070564] ACPI: Enabled 2 GPEs in block 00 to 3F
[    0.073006] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.073015] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    0.073053] acpi PNP0A08:00: _OSC: platform does not support 
[PCIeHotplug LTR]
[    0.073089] acpi PNP0A08:00: _OSC: OS now controls [SHPCHotplug PME 
AER PCIeCapability]
[    0.095825] pci 0000:00:1f.0: quirk: [io  0x0600-0x067f] claimed by 
ICH6 ACPI/GPIO/TCO
[    0.099290] ACPI: PCI: Interrupt link LNKA configured for IRQ 10
[    0.099407] ACPI: PCI: Interrupt link LNKB configured for IRQ 10
[    0.099514] ACPI: PCI: Interrupt link LNKC configured for IRQ 11
[    0.099619] ACPI: PCI: Interrupt link LNKD configured for IRQ 11
[    0.099735] ACPI: PCI: Interrupt link LNKE configured for IRQ 10
[    0.099837] ACPI: PCI: Interrupt link LNKF configured for IRQ 10
[    0.099983] ACPI: PCI: Interrupt link LNKG configured for IRQ 11
[    0.100088] ACPI: PCI: Interrupt link LNKH configured for IRQ 11
[    0.100138] ACPI: PCI: Interrupt link GSIA configured for IRQ 16
[    0.100145] ACPI: PCI: Interrupt link GSIB configured for IRQ 17
[    0.100150] ACPI: PCI: Interrupt link GSIC configured for IRQ 18
[    0.100154] ACPI: PCI: Interrupt link GSID configured for IRQ 19
[    0.100159] ACPI: PCI: Interrupt link GSIE configured for IRQ 20
[    0.100163] ACPI: PCI: Interrupt link GSIF configured for IRQ 21
[    0.100168] ACPI: PCI: Interrupt link GSIG configured for IRQ 22
[    0.100172] ACPI: PCI: Interrupt link GSIH configured for IRQ 23
[    0.101366] PCI: Using ACPI for IRQ routing
[    0.173928] pnp: PnP ACPI init
[    0.174037] ACPI: IRQ 4 override to edge(!), high(!)
[    0.174454] pnp: PnP ACPI: found 5 devices
[    0.180876] clocksource: acpi_pm: mask: 0xffffff max_cycles: 
0xffffff, max_idle_ns: 2085701024 ns
[    0.182039] ACPI: \_SB_.GSIA: Enabled at IRQ 16
[    0.182958] ACPI: \_SB_.GSIB: Enabled at IRQ 17
[    0.183807] ACPI: \_SB_.GSIC: Enabled at IRQ 18
[    0.184660] ACPI: \_SB_.GSID: Enabled at IRQ 19
[    0.649897] ACPI: \_SB_.GSIG: Enabled at IRQ 22
[    0.650815] ACPI: \_SB_.GSIH: Enabled at IRQ 23
[    0.652917] ACPI: \_SB_.GSIE: Enabled at IRQ 20
[    0.654260] ACPI: \_SB_.GSIF: Enabled at IRQ 21
[    0.660710] ACPI: bus type USB registered
[    1.520244] ACPI: bus type drm_connector registered
[    1.545037] parport_pc 00:02: reported by Plug and Play ACPI


And here the same with 6.18.56:

[    0.002892] ACPI: Early table checksum verification disabled
[    0.002893] ACPI: RSDP 0x00000000000F5250 000014 (v00 BOCHS )
[    0.002896] ACPI: RSDT 0x000000007FFE2439 000038 (v01 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.002900] ACPI: FACP 0x000000007FFE2229 0000F4 (v03 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.002903] ACPI: DSDT 0x000000007FFE0040 0021E9 (v01 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.002905] ACPI: FACS 0x000000007FFE0000 000040
[    0.002907] ACPI: APIC 0x000000007FFE231D 000080 (v03 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.002909] ACPI: HPET 0x000000007FFE239D 000038 (v01 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.002910] ACPI: MCFG 0x000000007FFE23D5 00003C (v01 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.002912] ACPI: WAET 0x000000007FFE2411 000028 (v01 BOCHS  BXPC     
00000001 BXPC 00000001)
[    0.002913] ACPI: Reserving FACP table memory at [mem 
0x7ffe2229-0x7ffe231c]
[    0.002914] ACPI: Reserving DSDT table memory at [mem 
0x7ffe0040-0x7ffe2228]
[    0.002915] ACPI: Reserving FACS table memory at [mem 
0x7ffe0000-0x7ffe003f]
[    0.002915] ACPI: Reserving APIC table memory at [mem 
0x7ffe231d-0x7ffe239c]
[    0.002916] ACPI: Reserving HPET table memory at [mem 
0x7ffe239d-0x7ffe23d4]
[    0.002916] ACPI: Reserving MCFG table memory at [mem 
0x7ffe23d5-0x7ffe2410]
[    0.002916] ACPI: Reserving WAET table memory at [mem 
0x7ffe2411-0x7ffe2438]
[    0.004075] ACPI: PM-Timer IO Port: 0x608
[    0.004081] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.004110] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.004112] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high 
level)
[    0.004112] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high 
level)
[    0.004113] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high 
level)
[    0.004113] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high 
level)
[    0.004115] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.004116] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.023015] ACPI: Core revision 20250807
[    0.038123] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.049553] ACPI: Added _OSI(Module Device)
[    0.049554] ACPI: Added _OSI(Processor Device)
[    0.049555] ACPI: Added _OSI(Processor Aggregator Device)
[    0.050320] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    0.052728] ACPI: Interpreter enabled
[    0.052728] ACPI: PM: (supports S0 S3 S4 S5)
[    0.052728] ACPI: Using IOAPIC for interrupt routing
[    0.052728] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.052728] ACPI: Enabled 2 GPEs in block 00 to 3F
[    0.053130] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.053134] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI HPX-Type3]
[    0.053150] acpi PNP0A08:00: _OSC: platform does not support 
[PCIeHotplug LTR]
[    0.053173] acpi PNP0A08:00: _OSC: OS now controls [SHPCHotplug PME 
AER PCIeCapability]
[    0.076666] pci 0000:00:1f.0: quirk: [io  0x0600-0x067f] claimed by 
ICH6 ACPI/GPIO/TCO
[    0.080509] ACPI: PCI: Interrupt link LNKA configured for IRQ 10
[    0.080543] ACPI: PCI: Interrupt link LNKB configured for IRQ 10
[    0.080571] ACPI: PCI: Interrupt link LNKC configured for IRQ 11
[    0.080599] ACPI: PCI: Interrupt link LNKD configured for IRQ 11
[    0.080627] ACPI: PCI: Interrupt link LNKE configured for IRQ 10
[    0.080658] ACPI: PCI: Interrupt link LNKF configured for IRQ 10
[    0.080710] ACPI: PCI: Interrupt link LNKG configured for IRQ 11
[    0.080740] ACPI: PCI: Interrupt link LNKH configured for IRQ 11
[    0.080754] ACPI: PCI: Interrupt link GSIA configured for IRQ 16
[    0.080757] ACPI: PCI: Interrupt link GSIB configured for IRQ 17
[    0.080759] ACPI: PCI: Interrupt link GSIC configured for IRQ 18
[    0.080762] ACPI: PCI: Interrupt link GSID configured for IRQ 19
[    0.080765] ACPI: PCI: Interrupt link GSIE configured for IRQ 20
[    0.080768] ACPI: PCI: Interrupt link GSIF configured for IRQ 21
[    0.080770] ACPI: PCI: Interrupt link GSIG configured for IRQ 22
[    0.080773] ACPI: PCI: Interrupt link GSIH configured for IRQ 23
[    0.081218] PCI: Using ACPI for IRQ routing
[    0.118556] pnp: PnP ACPI init
[    0.118688] ACPI: IRQ 4 override to edge(!), high(!)
[    0.119019] pnp: PnP ACPI: found 5 devices
[    0.124970] clocksource: acpi_pm: mask: 0xffffff max_cycles: 
0xffffff, max_idle_ns: 2085701024 ns
[    0.125698] ACPI: \_SB_.GSIA: Enabled at IRQ 16
[    0.126096] ACPI: \_SB_.GSIB: Enabled at IRQ 17
[    0.126535] ACPI: \_SB_.GSIC: Enabled at IRQ 18
[    0.126912] ACPI: \_SB_.GSID: Enabled at IRQ 19
[    0.384736] ACPI: \_SB_.GSIG: Enabled at IRQ 22
[    0.388909] ACPI: \_SB_.GSIH: Enabled at IRQ 23
[    0.395883] ACPI: bus type USB registered
[    0.398672] ACPI: \_SB_.GSIE: Enabled at IRQ 20
[    0.403361] ACPI: \_SB_.GSIF: Enabled at IRQ 21
[    1.099841] ACPI: bus type drm_connector registered
[    1.276439] ACPI: button: Power Button [PWRF]
[    1.278258] parport_pc 00:02: reported by Plug and Play ACPI


As one can see, there is no

ACPI: button: Power Button [PWRF]


This is nasty as now shutdown with virsh stops working (qemu's 
system_powerdown does nothing).

Regards,
-- 
Wolfgang Walter
Studierendenwerk München Oberbayern
Anstalt des öffentlichen Rechts
