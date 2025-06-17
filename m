Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002C1217F40
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 18:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750184867; cv=none; b=Vom1SjALM4e+ckEmUyLLpJhcv4/HNCmHQN4q5comLr1DyGYH1hSoqbPsJaizzf3phc+80jgFLMf6W4JiP2g7iUy+MYSBO6NkkJRj5JIJWS0QCKhBbbw6TZAN4HwveZMFIjxPHVhO0fxi3yDf8+Ap273ThCKC3cxEVIiSC6k3r6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750184867; c=relaxed/simple;
	bh=YzB74ULqW8z7cL8uQWmbf33+Cu/WZzjgF4Rj2Lehhl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D2LEapkYxE6/g1C9DnzHjqXWsUvd3Bjn2jHT3kzTiXlwPI3Znhwu3jWTCMQW+mLyBNL9Ui+r8QR1vFeBbRpdviXlo7mSr9Kjd3wIt8tpZdCNk1cj5x8KA64BVUr1TKF7j1xlV6yEPWUKv0IRXPh7flLjMuGvoADfVGKuKdZUHT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=nSiOkTV0; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="nSiOkTV0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1750184825; x=1750789625; i=rwarsow@gmx.de;
	bh=PgmPqOMCBtyD/WSjgVDlewfKy+Zwo0+1siCFu96BmlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=nSiOkTV0x1EhMNyOqjsDgxzpCE9Y27/Avnc0N3Eg2IRV+ipdtlROJP4AdVpb4xqa
	 WNjk344n4pipf6bVcmETYgzNJiGKtwgwayE5fpQet/uBWc5bFO+Ox077l0QJB5h/y
	 PnKJzNoGr/ZdKwoWUP6f6uAY9dWmb7BCKBcXdM4RwHbBJvE4Rk32EU8LEkfmO1ZRP
	 loehYYduobTmcYITypgR01W/vEPtxlW5wGmfI3PFjlW72SmFUxHMivMuK/HDwTAqe
	 YfYvYnrvPYMTlsgB2C9W8Bb5yDxJ+Z4xays0SuS8MEtjNkgB0rJZlugftX+JFkIiS
	 j7wY1Fyg4htYZJR0Og==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.35.195]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MHoN2-1uXb1a3AoA-00GqKo; Tue, 17
 Jun 2025 20:27:04 +0200
Message-ID: <f2b87714-0ef6-4210-9b30-86b4c79d1ed8@gmx.de>
Date: Tue, 17 Jun 2025 20:27:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250617152451.485330293@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4G9rtgxEGZTFJu7d9EA5HYK0abHENaypkaPtLIDyMNn4GsvsAol
 8jgbb8KkGJRqezZLzMeYvYbf2s67vtiSYlibUILTJBOvz6d7j6TTqmB0Fyk2yzP6n521ApN
 LkjOcpomM0YaHG4yszgoy0axFfYXn+4IGNAEWrpvc7mqB5eIqGxriblFZfceX6zSpu20Ipx
 +KkrcWbRjq+sly/NnWKLg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dfXGHetvt9E=;fCMR53Kx7cr7in3+akDUCCMhFpL
 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

Hi Greg

Kernel panic here on x86_64 (RKL, Intel 11th Gen. CPU)

all others kernels were okay. nothing was changed in my compile config.

Tested-by: Ronald Warsow <rwarsow@gmx.de>

=3D=3D=3D

what I fetched via serial console:

[    0.000000] Linux version 6.15.3-rc1_MY (ron@obelix.fritz.box) (gcc=20
(GCC) 15.1.1 20250521 (Red Hat 15.1.1-2), GNU ld version 2.44-3.fc42) #1=
=20
SMP PREEMPT_DYNAMIC Tue Jun 17 20:15:03 CEST 2025
[    0.000000] Command line: BOOT_IMAGE=3D(hd1,gpt1)/vmlinuz-6.15.3-rc1_MY=
=20
root=3DUUID=3D704d7d4e-6ca3-4647-b027-44dc162e2b3c ro rootflags=3Dsubvol=
=3DROOT=20
console=3Dtty0 console=3Dtty1 console=3DttyS0,115200 systemd.log_level=3Dd=
ebug=20
no_console_suspend
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usab=
le
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009efff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] usab=
le
[    0.000000] BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007b883fff] usab=
le
[    0.000000] BIOS-e820: [mem 0x000000007b884000-0x000000007b884fff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x000000007b885000-0x000000008bceefff] usab=
le
[    0.000000] BIOS-e820: [mem 0x000000008bcef000-0x000000008e1eefff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x000000008e1ef000-0x000000008e46efff]=20
ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008e46f000-0x000000008e5fefff]=20
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008e5ff000-0x000000008fefefff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x000000008feff000-0x000000008fefffff] usab=
le
[    0.000000] BIOS-e820: [mem 0x000000008ff00000-0x0000000095ffffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x0000000096600000-0x00000000967fffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x0000000097000000-0x00000000a07fffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed20000-0x00000000fed7ffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000045f7fffff] usab=
le
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] APIC: Static calls initialized
[    0.000000] efi: EFI v2.7 by American Megatrends
[    0.000000] efi: ACPI=3D0x8e46e000 ACPI 2.0=3D0x8e46e014=20
TPMFinalLog=3D0x8e56c000 SMBIOS=3D0x8fc61000 SMBIOS 3.0=3D0x8fc60000=20
MEMATTR=3D0x89784018 ESRT=3D0x897a3f98 MOKvar=3D0x8fca3000 RNG=3D0x8e3ffc1=
8=20
TPMEventLog=3D0x8e3e9018
[    0.000000] random: crng init done
[    0.000000] efi: Remove mem75: MMIO range=3D[0xe0000000-0xefffffff]=20
(256MB) from e820 map
[    0.000000] efi: Not removing mem76: MMIO=20
range=3D[0xfe000000-0xfe010fff] (68KB) from e820 map
[    0.000000] efi: Not removing mem77: MMIO=20
range=3D[0xfec00000-0xfec00fff] (4KB) from e820 map
[    0.000000] efi: Not removing mem78: MMIO=20
range=3D[0xfed00000-0xfed00fff] (4KB) from e820 map
[    0.000000] efi: Not removing mem80: MMIO=20
range=3D[0xfee00000-0xfee00fff] (4KB) from e820 map
[    0.000000] efi: Remove mem81: MMIO range=3D[0xff000000-0xffffffff]=20
(16MB) from e820 map
[    0.000000] SMBIOS 3.3.0 present.
[    0.000000] DMI: ASUS System Product Name/ROG STRIX B560-G GAMING=20
WIFI, BIOS 2302 11/13/2024
[    0.000000] DMI: Memory slots populated: 2/4
[    0.000000] tsc: Detected 2600.000 MHz processor
[    0.000000] tsc: Detected 2592.000 MHz TSC
[    0.000646] last_pfn =3D 0x45f800 max_arch_pfn =3D 0x400000000
[    0.000648] MTRR map: 5 entries (3 fixed + 2 variable; max 23), built=
=20
from 10 variable MTRRs
[    0.000649] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC-=
=20
WT
[    0.000914] last_pfn =3D 0x8ff00 max_arch_pfn =3D 0x400000000
[    0.007714] esrt: Reserving ESRT space from 0x00000000897a3f98 to=20
0x00000000897a3fd0.
[    0.007732] Using GB pages for direct mapping
[    0.007980] Secure boot disabled
[    0.007980] RAMDISK: [mem 0x7527e000-0x7b883fff]
[    0.007983] ACPI: Early table checksum verification disabled
[    0.007985] ACPI: RSDP 0x000000008E46E014 000024 (v02 ALASKA)
[    0.007987] ACPI: XSDT 0x000000008E46D728 0000DC (v01 ALASKA A M I=20
01072009 AMI  01000013)
[    0.007991] ACPI: FACP 0x000000008E46B000 000114 (v06 ALASKA A M I=20
01072009 AMI  01000013)
[    0.007994] ACPI: DSDT 0x000000008E414000 0567A3 (v02 ALASKA A M I=20
01072009 INTL 20180209)
[    0.007996] ACPI: FACS 0x000000008E5FE000 000040
[    0.007997] ACPI: MCFG 0x000000008E46C000 00003C (v01 ALASKA A M I=20
01072009 MSFT 00000097)
[    0.007999] ACPI: FIDT 0x000000008E413000 00009C (v01 ALASKA A M I=20
01072009 AMI  00010013)
[    0.008001] ACPI: SSDT 0x000000008E40F000 0025EB (v02 CpuRef CpuSsdt=20
00003000 INTL 20180209)
[    0.008002] ACPI: SSDT 0x000000008E40A000 004476 (v02 SaSsdt SaSsdt=20
00003000 INTL 20180209)
[    0.008004] ACPI: SSDT 0x000000008E406000 0032CD (v02 INTEL  IgfxSsdt=
=20
00003000 INTL 20180209)
[    0.008006] ACPI: HPET 0x000000008E405000 000038 (v01 ALASKA A M I=20
01072009 AMI  01000013)
[    0.008007] ACPI: APIC 0x000000008E404000 000164 (v04 ALASKA A M I=20
01072009 AMI  01000013)
[    0.008009] ACPI: SSDT 0x000000008E403000 000E66 (v02 ALASKA Ther_Rvp=
=20
00001000 INTL 20180209)
[    0.008011] ACPI: SSDT 0x000000008E401000 0017E5 (v02 INTEL  xh_rksu4=
=20
00000000 INTL 20180209)
[    0.008012] ACPI: NHLT 0x000000008E400000 00002D (v00 ALASKA A M I=20
01072009 AMI  01000013)
[    0.008014] ACPI: LPIT 0x000000008E3FE000 0000CC (v01 ALASKA A M I=20
01072009 AMI  01000013)
[    0.008016] ACPI: SSDT 0x000000008E3FC000 000DC6 (v02 ALASKA TbtTypeC=
=20
00000000 INTL 20180209)
[    0.008017] ACPI: SSDT 0x000000008E3F9000 002720 (v02 ALASKA PtidDevc=
=20
00001000 INTL 20180209)
[    0.008019] ACPI: DBGP 0x000000008E3F8000 000034 (v01 ALASKA A M I=20
01072009 AMI  01000013)
[    0.008021] ACPI: DBG2 0x000000008E3F7000 000054 (v00 ALASKA A M I=20
01072009 AMI  01000013)
[    0.008022] ACPI: SSDT 0x000000008E3F6000 0006E3 (v02 ALASKA UsbCTabl=
=20
00001000 INTL 20180209)
[    0.008024] ACPI: DMAR 0x000000008E3F5000 000088 (v02 INTEL  EDK2=20
00000002      01000013)
[    0.008026] ACPI: SSDT 0x000000008E3F4000 000144 (v02 Intel  ADebTabl=
=20
00001000 INTL 20180209)
[    0.008027] ACPI: TPM2 0x000000008E3F3000 00004C (v04 ALASKA A M I=20
00000001 AMI  00000000)
[    0.008029] ACPI: PTDT 0x000000008E3F2000 000CF0 (v00 ALASKA A M I=20
00000005 MSFT 0100000D)
[    0.008031] ACPI: WSMT 0x000000008E3FD000 000028 (v01 ALASKA A M I=20
01072009 AMI  00010013)
[    0.008033] ACPI: FPDT 0x000000008E3F1000 000044 (v01 ALASKA RKL=20
01072009 AMI  01000013)
[    0.008034] ACPI: Reserving FACP table memory at [mem=20
0x8e46b000-0x8e46b113]
[    0.008035] ACPI: Reserving DSDT table memory at [mem=20
0x8e414000-0x8e46a7a2]
[    0.008035] ACPI: Reserving FACS table memory at [mem=20
0x8e5fe000-0x8e5fe03f]
[    0.008036] ACPI: Reserving MCFG table memory at [mem=20
0x8e46c000-0x8e46c03b]
[    0.008036] ACPI: Reserving FIDT table memory at [mem=20
0x8e413000-0x8e41309b]
[    0.008037] ACPI: Reserving SSDT table memory at [mem=20
0x8e40f000-0x8e4115ea]
[    0.008037] ACPI: Reserving SSDT table memory at [mem=20
0x8e40a000-0x8e40e475]
[    0.008037] ACPI: Reserving SSDT table memory at [mem=20
0x8e406000-0x8e4092cc]
[    0.008038] ACPI: Reserving HPET table memory at [mem=20
0x8e405000-0x8e405037]
[    0.008038] ACPI: Reserving APIC table memory at [mem=20
0x8e404000-0x8e404163]
[    0.008039] ACPI: Reserving SSDT table memory at [mem=20
0x8e403000-0x8e403e65]
[    0.008039] ACPI: Reserving SSDT table memory at [mem=20
0x8e401000-0x8e4027e4]
[    0.008039] ACPI: Reserving NHLT table memory at [mem=20
0x8e400000-0x8e40002c]
[    0.008040] ACPI: Reserving LPIT table memory at [mem=20
0x8e3fe000-0x8e3fe0cb]
[    0.008040] ACPI: Reserving SSDT table memory at [mem=20
0x8e3fc000-0x8e3fcdc5]
[    0.008041] ACPI: Reserving SSDT table memory at [mem=20
0x8e3f9000-0x8e3fb71f]
[    0.008041] ACPI: Reserving DBGP table memory at [mem=20
0x8e3f8000-0x8e3f8033]
[    0.008042] ACPI: Reserving DBG2 table memory at [mem=20
0x8e3f7000-0x8e3f7053]
[    0.008042] ACPI: Reserving SSDT table memory at [mem=20
0x8e3f6000-0x8e3f66e2]
[    0.008042] ACPI: Reserving DMAR table memory at [mem=20
0x8e3f5000-0x8e3f5087]
[    0.008043] ACPI: Reserving SSDT table memory at [mem=20
0x8e3f4000-0x8e3f4143]
[    0.008043] ACPI: Reserving TPM2 table memory at [mem=20
0x8e3f3000-0x8e3f304b]
[    0.008044] ACPI: Reserving PTDT table memory at [mem=20
0x8e3f2000-0x8e3f2cef]
[    0.008044] ACPI: Reserving WSMT table memory at [mem=20
0x8e3fd000-0x8e3fd027]
[    0.008044] ACPI: Reserving FPDT table memory at [mem=20
0x8e3f1000-0x8e3f1043]
[    0.008104] No NUMA configuration found
[    0.008105] Faking a node at [mem 0x0000000000000000-0x000000045f7fffff=
]
[    0.008110] NODE_DATA(0) allocated [mem 0x45f7dda00-0x45f7fffff]
[    0.008228] Zone ranges:
[    0.008228]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.008229]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.008230]   Normal   [mem 0x0000000100000000-0x000000045f7fffff]
[    0.008231] Movable zone start for each node
[    0.008232] Early memory node ranges
[    0.008232]   node   0: [mem 0x0000000000001000-0x000000000009dfff]
[    0.008233]   node   0: [mem 0x000000000009f000-0x000000000009ffff]
[    0.008233]   node   0: [mem 0x0000000000100000-0x000000007b883fff]
[    0.008234]   node   0: [mem 0x000000007b885000-0x000000008bceefff]
[    0.008234]   node   0: [mem 0x000000008feff000-0x000000008fefffff]
[    0.008235]   node   0: [mem 0x0000000100000000-0x000000045f7fffff]
[    0.008236] Initmem setup node 0 [mem=20
0x0000000000001000-0x000000045f7fffff]
[    0.008239] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.008240] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.008258] On node 0, zone DMA: 96 pages in unavailable ranges
[    0.010977] On node 0, zone DMA32: 1 pages in unavailable ranges
[    0.011105] On node 0, zone DMA32: 16912 pages in unavailable ranges
[    0.028151] On node 0, zone Normal: 256 pages in unavailable ranges
[    0.028167] On node 0, zone Normal: 2048 pages in unavailable ranges
[    0.028210] Reserving Intel graphics memory at [mem=20
0x98800000-0xa07fffff]
[    0.029634] ACPI: PM-Timer IO Port: 0x1808
[    0.029641] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.029642] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.029642] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.029642] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.029643] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.029643] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.029643] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.029644] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.029644] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
[    0.029644] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
[    0.029645] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
[    0.029645] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
[    0.029645] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
[    0.029646] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
[    0.029646] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
[    0.029646] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.029647] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.029647] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])
[    0.029648] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])
[    0.029648] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])
[    0.029687] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI=
=20
0-119
[    0.029689] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.029690] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.029693] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.029694] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.029696] TSC deadline timer available
[    0.029698] CPU topo: Max. logical packages:   1
[    0.029699] CPU topo: Max. logical dies:       1
[    0.029699] CPU topo: Max. dies per package:   1
[    0.029702] CPU topo: Max. threads per core:   2
[    0.029702] CPU topo: Num. cores per package:     6
[    0.029702] CPU topo: Num. threads per package:  12
[    0.029703] CPU topo: Allowing 12 present CPUs plus 0 hotplug CPUs
[    0.029714] PM: hibernation: Registered nosave memory: [mem=20
0x00000000-0x00000fff]
[    0.029715] PM: hibernation: Registered nosave memory: [mem=20
0x0009e000-0x0009efff]
[    0.029716] PM: hibernation: Registered nosave memory: [mem=20
0x000a0000-0x000fffff]
[    0.029717] PM: hibernation: Registered nosave memory: [mem=20
0x7b884000-0x7b884fff]
[    0.029718] PM: hibernation: Registered nosave memory: [mem=20
0x897a3000-0x897a3fff]
[    0.029719] PM: hibernation: Registered nosave memory: [mem=20
0x8bcef000-0x8fefefff]
[    0.029719] PM: hibernation: Registered nosave memory: [mem=20
0x8ff00000-0xffffffff]
[    0.029720] [mem 0xa0800000-0xfdffffff] available for PCI devices
[    0.029722] clocksource: refined-jiffies: mask: 0xffffffff=20
max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.035451] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:12=20
nr_cpu_ids:12 nr_node_ids:1
[    0.035967] percpu: Embedded 77 pages/cpu s190040 r8192 d117160 u524288
[    0.035988] Kernel command line:=20
BOOT_IMAGE=3D(hd1,gpt1)/vmlinuz-6.15.3-rc1_MY=20
root=3DUUID=3D704d7d4e-6ca3-4647-b027-44dc162e2b3c ro rootflags=3Dsubvol=
=3DROOT=20
console=3Dtty0 console=3Dtty1 console=3DttyS0,115200 systemd.log_level=3Dd=
ebug=20
no_console_suspend
[    0.036058] Unknown kernel command line parameters=20
"BOOT_IMAGE=3D(hd1,gpt1)/vmlinuz-6.15.3-rc1_MY", will be passed to user sp=
ace.
[    0.036065] printk: log buffer data + meta data: 262144 + 917504 =3D=20
1179648 bytes
[    0.037215] Dentry cache hash table entries: 2097152 (order: 12,=20
16777216 bytes, linear)
[    0.037824] Inode-cache hash table entries: 1048576 (order: 11,=20
8388608 bytes, linear)
[    0.037940] software IO TLB: area num 16.
[    0.047363] Fallback order for Node 0: 0
[    0.047367] Built 1 zonelists, mobility grouping on.  Total pages:=20
4109453
[    0.047368] Policy zone: Normal
[    0.047551] mem auto-init: stack:all(zero), heap alloc:on, heap free:of=
f
[    0.070269] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D12,=
 Nodes=3D1
[    0.078350] ftrace: allocating 66606 entries in 262 pages
[    0.078351] ftrace: allocated 262 pages with 3 groups
[    0.079225] Dynamic Preempt: voluntary
[    0.079277] rcu: Preemptible hierarchical RCU implementation.
[    0.079277] rcu: 	RCU restricting CPUs from NR_CPUS=3D8192 to=20
nr_cpu_ids=3D12.
[    0.079278] 	Trampoline variant of Tasks RCU enabled.
[    0.079279] 	Rude variant of Tasks RCU enabled.
[    0.079279] 	Tracing variant of Tasks RCU enabled.
[    0.079280] rcu: RCU calculated value of scheduler-enlistment delay=20
is 100 jiffies.
[    0.079280] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_id=
s=3D12
[    0.079287] RCU Tasks: Setting shift to 4 and lim to 1=20
rcu_task_cb_adjust=3D1 rcu_task_cpu_ids=3D12.
[    0.079289] RCU Tasks Rude: Setting shift to 4 and lim to 1=20
rcu_task_cb_adjust=3D1 rcu_task_cpu_ids=3D12.
[    0.079290] RCU Tasks Trace: Setting shift to 4 and lim to 1=20
rcu_task_cb_adjust=3D1 rcu_task_cpu_ids=3D12.
[    0.084250] NR_IRQS: 524544, nr_irqs: 2152, preallocated irqs: 16
[    0.084656] rcu: srcu_init: Setting srcu_struct sizes based on=20
contention.
[    0.084882] kfence: initialized - using 2097152 bytes for 255 objects=
=20
at 0x(____ptrval____)-0x(____ptrval____)
[    0.084916] Console: colour dummy device 80x25
[    0.084918] printk: legacy console [tty0] enabled
[    0.085142] printk: legacy console [ttyS0] enabled
[    1.476406] ACPI: Core revision 20240827
[    1.480716] clocksource: hpet: mask: 0xffffffff max_cycles:=20
0xffffffff, max_idle_ns: 79635855245 ns
[    1.489887] APIC: Switch to symmetric I/O mode setup
[    1.494904] DMAR: Host address width 39
[    1.498861] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    1.504226] DMAR: dmar0: reg_base_addr fed90000 ver 4:0 cap=20
1c0000c40660462 ecap 29a00f0505e
[    1.512732] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    1.518126] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap=20
d2008c40660462 ecap f050da
[    1.526070] DMAR: RMRR base: 0x00000098000000 end: 0x000000a07fffff
[    1.532408] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    1.538807] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    1.544270] DMAR-IR: Queued invalidation will be enabled to support=20
x2apic and Intr-remapping.
[    1.554650] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    1.560057] x2apic enabled
[    1.562921] APIC: Switched APIC routing to: cluster x2apic
[    1.572998] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=
=3D-1
[    1.583837] clocksource: tsc-early: mask: 0xffffffffffffffff=20
max_cycles: 0x255cb6cc5db, max_idle_ns: 440795203504 ns
[    1.594365] Calibrating delay loop (skipped), value calculated using=20
timer frequency.. 5184.00 BogoMIPS (lpj=3D2592000)
[    1.595388] CPU0: Thermal monitoring enabled (TM1)
[    1.596366] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    1.597424] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    1.598365] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    1.599366] process: using mwait in idle threads
[    1.600366] Spectre V1 : Mitigation: usercopy/swapgs barriers and=20
__user pointer sanitization
[    1.601366] Spectre V2 : Spectre BHI mitigation: SW BHB clearing on=20
syscall and VM exit
[    1.602365] Spectre V2 : Mitigation: Enhanced / Automatic IBRS
[    1.603365] Spectre V2 : Spectre v2 / PBRSB-eIBRS: Retire a single=20
CALL on VMEXIT
[    1.604365] RETBleed: Mitigation: Enhanced IBRS
[    1.605365] Spectre V2 : mitigation: Enabling conditional Indirect=20
Branch Prediction Barrier
[    1.606366] Speculative Store Bypass: Mitigation: Speculative Store=20
Bypass disabled via prctl
[    1.607369] MMIO Stale Data: Mitigation: Clear CPU buffers
[    1.608366] GDS: Mitigation: Microcode
[    1.609365] ITS: Mitigation: Aligned branch/return thunks
[    1.610369] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating=20
point registers'
[    1.611365] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    1.612365] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    1.613365] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds=20
registers'
[    1.614365] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    1.615365] x86/fpu: Supporting XSAVE feature 0x020: 'AVX-512 opmask'
[    1.617364] x86/fpu: Supporting XSAVE feature 0x040: 'AVX-512 Hi256'
[    1.618365] x86/fpu: Supporting XSAVE feature 0x080: 'AVX-512 ZMM_Hi256=
'
[    1.619365] x86/fpu: Supporting XSAVE feature 0x200: 'Protection Keys=
=20
User registers'
[    1.620365] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    1.621365] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    1.622365] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    1.623365] x86/fpu: xstate_offset[5]:  960, xstate_sizes[5]:   64
[    1.624365] x86/fpu: xstate_offset[6]: 1024, xstate_sizes[6]:  512
[    1.625365] x86/fpu: xstate_offset[7]: 1536, xstate_sizes[7]: 1024
[    1.626365] x86/fpu: xstate_offset[9]: 2560, xstate_sizes[9]:    8
[    1.627365] x86/fpu: Enabled xstate features 0x2ff, context size is=20
2568 bytes, using 'compacted' format.
[    1.628643] BUG: unable to handle page fault for address:=20
ffffffffc0400000
[    1.629364] #PF: supervisor write access in kernel mode
[    1.629364] #PF: error_code(0x0003) - permissions violation
[    1.629364] PGD 453e29067 P4D 453e29067 PUD 453e2b067 PMD 100e001a1
[    1.629364] Oops: Oops: 0003 [#1] SMP NOPTI
[    1.629364] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted=20
6.15.3-rc1_MY #1 PREEMPT(voluntary)
[    1.629364] Hardware name: ASUS System Product Name/ROG STRIX B560-G=20
GAMING WIFI, BIOS 2302 11/13/2024
[    1.629364] RIP: 0010:apply_retpolines+0x220/0x500
[    1.629364] Code: 00 4c 89 04 c2 e8 d0 92 4b 00 4c 8b 04 24 49 8d 78=20
08 4c 89 c1 48 b8 cc cc cc cc cc cc cc cc 4c 89 05 9c 81 c3 03 48 83 e7=20
f8 <49> 89 00 48 29 f9 49 89 80 f8 0f 00 00 81 c1 00 10 00 00 c1 e9 03
[    1.629364] RSP: 0000:ffffffffb9e03e00 EFLAGS: 00010282
[    1.629364] RAX: cccccccccccccccc RBX: ffffffffbad11c58 RCX:=20
ffffffffc0400000
[    1.629364] RDX: 0000000000000000 RSI: ffffffffba045f70 RDI:=20
ffffffffc0400008
[    1.629364] RBP: ffffffffb731189d R08: ffffffffc0400000 R09:=20
ffff9ac9c0308b08
[    1.629364] R10: ffff9ac9c0308b88 R11: ffff9ac9c0308b08 R12:=20
ffff9acd1f7cdfc0
[    1.629364] R13: ffffffffbad1e2e0 R14: 0000000000000000 R15:=20
0000000000000000
[    1.629364] FS:  0000000000000000(0000) GS:ffff9acd640d6000(0000)=20
knlGS:0000000000000000
[    1.629364] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.629364] CR2: ffffffffc0400000 CR3: 0000000453e26001 CR4:=20
0000000000770ef0
[    1.629364] PKRU: 55555554
[    1.629364] Call Trace:
[    1.629364]  <TASK>
[    1.629364]  ? events_sysfs_show+0x5d/0x80
[    1.629364]  ? events_sysfs_show+0x6c/0x80
[    1.629364]  ? events_sysfs_show+0x62/0x80
[    1.629364]  alternative_instructions+0x34/0x130
[    1.629364]  arch_cpu_finalize_init+0x108/0x150
[    1.629364]  start_kernel+0x927/0x9c0
[    1.629364]  x86_64_start_reservations+0x24/0x30
[    1.629364]  x86_64_start_kernel+0xe3/0xf0
[    1.629364]  common_startup_64+0x13e/0x148
[    1.629364]  </TASK>
[    1.629364] Modules linked in:
[    1.629364] CR2: ffffffffc0400000
[    1.629364] ---[ end trace 0000000000000000 ]---
[    1.629364] RIP: 0010:apply_retpolines+0x220/0x500
[    1.629364] Code: 00 4c 89 04 c2 e8 d0 92 4b 00 4c 8b 04 24 49 8d 78=20
08 4c 89 c1 48 b8 cc cc cc cc cc cc cc cc 4c 89 05 9c 81 c3 03 48 83 e7=20
f8 <49> 89 00 48 29 f9 49 89 80 f8 0f 00 00 81 c1 00 10 00 00 c1 e9 03
[    1.629364] RSP: 0000:ffffffffb9e03e00 EFLAGS: 00010282
[    1.629364] RAX: cccccccccccccccc RBX: ffffffffbad11c58 RCX:=20
ffffffffc0400000
[    1.629364] RDX: 0000000000000000 RSI: ffffffffba045f70 RDI:=20
ffffffffc0400008
[    1.629364] RBP: ffffffffb731189d R08: ffffffffc0400000 R09:=20
ffff9ac9c0308b08
[    1.629364] R10: ffff9ac9c0308b88 R11: ffff9ac9c0308b08 R12:=20
ffff9acd1f7cdfc0
[    1.629364] R13: ffffffffbad1e2e0 R14: 0000000000000000 R15:=20
0000000000000000
[    1.629364] FS:  0000000000000000(0000) GS:ffff9acd640d6000(0000)=20
knlGS:0000000000000000
[    1.629364] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.629364] CR2: ffffffffc0400000 CR3: 0000000453e26001 CR4:=20
0000000000770ef0
[    1.629364] PKRU: 55555554
[    1.629364] Kernel panic - not syncing: Attempted to kill the idle task=
!
[    1.629364] ---[ end Kernel panic - not syncing: Attempted to kill=20
the idle task! ]---

