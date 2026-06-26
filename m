Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9833BF66C
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 20:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782506510; cv=none; b=gCBQ1uwAHGgPc1CyZj6+KIyxg1EzGKIwNKPTJDseBqxS7/PcDE9jv/e1GDTYlyJHiEsLmFc7SCif2OJq2Tkemfo59lP+Yyc7BuJciSEnHV40hrwiBxxYUTajy3JEKdxhfzl6MbuhZCdEvy4PkHHlP8kQct6EJyW4Dfo+PL/Ewa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782506510; c=relaxed/simple;
	bh=LV7IBALRSHdt+BGczk24gnkid62jxb685PZZDyyv+OM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ngcKIeSu5tsMPZPMGctbbwbDdlc3ytqG6X5PNIxxdPt/fQfA2neOOZ/uE4CvT6Tet6mdhFmMU+LmSeg3RbiiPEp4hJPIWkuhVcKsvY5IsdwUNZAMk8/s4VStIERMnF25yD+Pk0g9COlsfZvFrgbQpuHtG2PtN0SIqLm89VwzcuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=bDvw4iX6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kz7sztAo; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="bDvw4iX6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kz7sztAo"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id A79441D000D4;
	Fri, 26 Jun 2026 16:41:43 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-04.internal (MEProxy); Fri, 26 Jun 2026 16:41:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1782506503;
	 x=1782592903; bh=V3gWXwskMvgRY+nh2KcaStNjJiptoz+2QGT3AFGR5cA=; b=
	bDvw4iX6fPVSQhpZKQFhrCewfcCKqFDEpJg/8DLQ/QyDLCah4CVQAr2FGfKvmaw4
	Bqk8fk/qKHC2eLd7rTU6E14pA5Rwoq+b95A38oLe3aWR5bIPrk3yn3uuPArIQHJl
	1TcR5im/pOeTM4+kzlIOmX5v5djKmdQgYBX4evh6LMtjMm4XjWrktJLSBLxzbC4E
	iN7+nHEdglcI4HoapspHMwF/AEdhi2peZ46kcAgZceg1xUpECUM+5+53W47oK0Q0
	tMHLl8tbrK1O0bGqwXTUwkBqQQAyMyw9Xyzmh0CWblqVaJ7RKtWkR1qvbuHQjemm
	fX6CsQNLa6tCaO4m+0Lxrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782506503; x=
	1782592903; bh=V3gWXwskMvgRY+nh2KcaStNjJiptoz+2QGT3AFGR5cA=; b=k
	z7sztAoQPB/5zYX6smlywTNijm8YIIVfzBcyr5Okw8v4dT2OqU5JeeoDMEp/7qDg
	PHHC9t1ZB2BggAXvA4e3VBFZbSwQo1G1wH+T1+x3wYCw9coLDkgaOwzP5IPMHKot
	Vjt/QWJGuE/0fRbpbaIlIxtuSfN1TNsh2ptnZFiyaGh6dZYWENc/nC358PDXaR5u
	5wIlfHRhZQ2ZY4SujB5wpeNHHan3sJrjgGX5AFDfoJD8tkOPagbPAYnqOQjT8Ma9
	mpWDSDLgRjmQMtd6/KJc49DcvUkFaTJEuunSlzi0pNLtLz/Mhv5fyFJCeFK7/hKr
	mKjL3n8x9w4SO53QdktmA==
X-ME-Sender: <xms:BuQ-aplm2XbuwkkTE4UBGMg8lgViBybdJkYJiS2EOtNM1sXd1fPp-Q>
    <xme:BuQ-alPZ2PnjbDM_K0jSidrjbO96WsCRj_zIK4DFW1IP9eyETO8Vi-HxgLIonPvgF
    fX3qgRmwwlTEGLNHel1qL4upv01k28RFLLpFJTANH9JN2IDxyCPqQ>
X-ME-Received: <xmr:BuQ-agwo0wVMEIWtpiDnjoGrdfXYTlzlZZV5uCBGOj44hP8YqAm_jQKY-hG8-fKWnyzlt_jKpDUG90H1YIDUOT2VVhnUQY_L>
X-ME-Proxy-Cause: dmFkZTEsmW2ygfpZlQjozOm2o157aRTz4yb3SdUY5jXg5WfBKRWDfJgK5IItJWAW+6Ou3e
    rK38yx7VjDNl2nRQjmryyqLV1vbQqj8s1zPv8ACdz9PrZI2n+8Kl0tAwHAq1jQItmqIEjL
    uHF+FmUHPkepehrsQsHoB00rmqYIiUlM8e2VMrdE2wFleGGFGtfYmLw642RN2cT6zLDxrl
    yTSCBzLmvfCARtgdy15jLIG0F8x+MnNgmOfj/sRhlUSA/6JX/V2TDS0bdGZ+hJz/ElZRoA
    bbd9v7tlD6aXmF8iRIV0qber3ahATpzbKkU0r8gu0ZZw/+8AsukhU6CqXe4KeK4lAyVpB5
    6dFZqq0F4f4rxj+QaewlQ1wVlBb4nfU3ZCCLtC3hoW1VAxhSTpzJFSt0vh0nWInyMkNImQ
    kiiyXW6XAVJ6jkILf/RnW51KbuhpMoWH7I4Cj/qKMtcX72SwHq4Bxij4j5tL8MeNREpL37
    snqnf9wDobp7nQZ75WfiacWA6yZid4eIzVZvMIPVM04Uo+wcWk0c91Ca+BisuiYl1FkCDV
    u8Wi1xvYb4npwkJGtzYKdN9vIrolTq3YLvETMndkzKASLGosH2NEKNdUVH1/RPi9cdNJ5+
    +r6tmSKzINaBdC37GeodH68XMsIgtzZoywmtPsJb+48cKjslYBdpxYLr/TIA
X-ME-Proxy: <xmx:BuQ-almGxCF1Mpj5U0-df7plIX38FLWRBQpOCThJhntamcRVLofMBw>
    <xmx:BuQ-am8unJShrkhHwbTywXXAVXyxs2d8zL6qETLeISGSyfH2gEmVUQ>
    <xmx:BuQ-ahMnR1M6pnKhUqpDTE85eyvho_Wug1KL251ibvvHljLM-wNISA>
    <xmx:BuQ-ao9SECg7RFLWBuhcwSciWWDf76wLtYfOwRZ9XbqkIdWbtO8dGw>
    <xmx:B-Q-aqKKAC0KLazpbNF4S-utqM9l7E28dgFA9NJhwag9oeN5uQFcuvXT>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 26 Jun 2026 16:41:39 -0400 (EDT)
Message-ID: <ab7df7bf-1b30-40c0-9463-a469abfa2bda@pobox.com>
Date: Fri, 26 Jun 2026 13:41:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260625125613.243729608@linuxfoundation.org>
 <b7bd471b-e9da-4bfc-ad1d-24b378bd1e44@pobox.com>
 <aj7RmyBck8EkPn_s@google.com>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <aj7RmyBck8EkPn_s@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/26/26 12:56 PM, Dmitry Torokhov wrote:
> Hi Barry,
> 
> On Fri, Jun 26, 2026 at 10:56:21AM -0700, Barry K. Nathan wrote:
>> (cc Dmitry Torokhov because this is related to two of your commits)
>>
>> On 6/25/26 6:03 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 7.1.2 release.
>>> There are 21 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>> Unfortunately, 7.1.2-rc1 breaks the Synaptics touchpad on my Lenovo
>> ThinkPad T14 Gen 1 -- the pointer no longer moves when I touch the
>> touchpad. Potentially relevant line from dmesg:
>>
>> rmi4_f01 rmi4-00.fn01: found RMI device, manufacturer: Synaptics, product: TM3471-020, fw id: 3972349
>>
>>> Dmitry Torokhov<dmitry.torokhov@gmail.com>
>>>       Input: rmi4 - refactor register descriptor parsing
>>>
>>> Dmitry Torokhov<dmitry.torokhov@gmail.com>
>>>       Input: rmi4 - fix register descriptor address calculation
>>>> Both of these patches seem bad in my testing. Either one, individually,
>> causes the pointer to no longer move when I touch the touchpad. If I
>> revert both of them, then my touchpad works again.
>>
>> I have not yet tested 7.0.14-rc1 or 6.18.37-rc1. However, the problem
>> also reproduces on current mainline as of this writing (commit
>> 51cb1aa1250c36269474b8b6ca6b6319e170f5a5).
>
> Could you please try applying this debug patch and send me dmesg?

Sure, I applied the patch on top of mainline, and the dmesg output is
below. A couple of clarifications to avoid confusion:

1. I set CONFIG_LOCALVERSION to "-t14test202606" when building this
    kernel.

2. The "debian12vm2" that I used to build this kernel is actually
    running Debian 13 trixie now, but I never changed the hostname.
    (My ThinkPad is also running trixie.)


[    0.000000] Linux version 7.1.0-t14test202606+ (barryn@debian12vm2) (x86_64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44) #2 SMP PREEMPT_DYNAMIC Fri Jun 26 13:08:00 PDT 2026
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-7.1.0-t14test202606+ root=UUID=acabe8be-6dd5-4d04-a138-22fdf9a0b015 ro preempt=full
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff]  System RAM
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x00000000000fffff]  device reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000a40b6fff]  System RAM
[    0.000000] BIOS-e820: [mem 0x00000000a40b7000-0x00000000a8294fff]  device reserved
[    0.000000] BIOS-e820: [mem 0x00000000a8295000-0x00000000a961efff]  ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000a961f000-0x00000000a974efff]  ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000a974f000-0x00000000a974ffff]  System RAM
[    0.000000] BIOS-e820: [mem 0x00000000a9750000-0x00000000af7fffff]  device reserved
[    0.000000] BIOS-e820: [gap 0x00000000af800000-0x00000000fed1ffff]
[    0.000000] BIOS-e820: [mem 0x00000000fed20000-0x00000000fed7ffff]  device reserved
[    0.000000] BIOS-e820: [gap 0x00000000fed80000-0x00000000ffffffff]
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000084c7fffff]  System RAM
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] APIC: Static calls initialized
[    0.000000] efi: EFI v2.7 by Lenovo
[    0.000000] efi: TPMFinalLog=0xa9617000 SMBIOS=0xa66b8000 SMBIOS 3.0=0xa66ab000 ACPI=0xa974e000 ACPI 2.0=0xa974e014 MEMATTR=0xa0c96018 ESRT=0xa4b3a000 MOKvar=0xa4b34000 INITRD=0x831b7818 RNG=0xa974d018 TPMEventLog=0xa974df18
[    0.000000] random: crng init done
[    0.000000] DMI: SMBIOS 3.2.0 present.
[    0.000000] DMI: LENOVO 20S1S6D700/20S1S6D700, BIOS N2XET45W (1.35 ) 04/08/2026
[    0.000000] DMI: Memory slots populated: 2/2
[    0.000000] tsc: Detected 2200.000 MHz processor
[    0.000000] tsc: Detected 2199.996 MHz TSC
[    0.000033] e820: update [mem 0x00000000-0x00000fff] System RAM ==> device reserved
[    0.000038] e820: remove [mem 0x000a0000-0x000fffff] System RAM
[    0.000048] last_pfn = 0x84c800 max_arch_pfn = 0x400000000
[    0.000056] MTRR map: 5 entries (3 fixed + 2 variable; max 23), built from 10 variable MTRRs
[    0.000059] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.000637] last_pfn = 0xa9750 max_arch_pfn = 0x400000000
[    0.014154] esrt: Reserving ESRT space from 0x00000000a4b3a000 to 0x00000000a4b3a0d8.
[    0.014171] Using GB pages for direct mapping
[    0.014544] Secure boot disabled
[    0.014545] RAMDISK: [mem 0x76bd6000-0x79b13fff]
[    0.014620] ACPI: Early table checksum verification disabled
[    0.014624] ACPI: RSDP 0x00000000A974E014 000024 (v02 LENOVO)
[    0.014631] ACPI: XSDT 0x00000000A974C188 00010C (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014640] ACPI: FACP 0x00000000A6560000 000114 (v06 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014648] ACPI: DSDT 0x00000000A652F000 02C5BD (v02 LENOVO CML      20170001 INTL 20160422)
[    0.014653] ACPI: FACS 0x00000000A947B000 000040
[    0.014657] ACPI: SSDT 0x00000000A65BC000 0020AE (v02 LENOVO CpuSsdt  00003000 INTL 20160527)
[    0.014662] ACPI: SSDT 0x00000000A65BB000 0005A1 (v02 LENOVO CtdpB    00001000 INTL 20160527)
[    0.014667] ACPI: SSDT 0x00000000A657E000 003532 (v02 LENOVO DptfTabl 00001000 INTL 20160527)
[    0.014672] ACPI: SSDT 0x00000000A6568000 00331E (v02 LENOVO SaSsdt   00003000 INTL 20160527)
[    0.014677] ACPI: SSDT 0x00000000A6567000 00060E (v02 LENOVO Tpm2Tabl 00001000 INTL 20160527)
[    0.014681] ACPI: TPM2 0x00000000A6566000 000034 (v04 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014686] ACPI: BOOT 0x00000000A6564000 000028 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014691] ACPI: HPET 0x00000000A655F000 000038 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014696] ACPI: APIC 0x00000000A655E000 000164 (v04 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014700] ACPI: MCFG 0x00000000A655D000 00003C (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014705] ACPI: ECDT 0x00000000A655C000 000053 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014710] ACPI: SSDT 0x00000000A652D000 001F15 (v02 LENOVO WHL_Tbt_ 00001000 INTL 20160527)
[    0.014715] ACPI: SSDT 0x00000000A652C000 0000A6 (v02 LENOVO PID0Ssdt 00000010 INTL 20160527)
[    0.014719] ACPI: SSDT 0x00000000A6528000 003AD0 (v02 LENOVO ProjSsdt 00000010 INTL 20160527)
[    0.014724] ACPI: NHLT 0x00000000A6526000 00189E (v00 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014729] ACPI: MSDM 0x00000000A6525000 000055 (v03 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014734] ACPI: SSDT 0x00000000A6348000 000FCE (v02 LENOVO UsbCTabl 00001000 INTL 20160527)
[    0.014738] ACPI: LPIT 0x00000000A6347000 000094 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014743] ACPI: WSMT 0x00000000A6346000 000028 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014748] ACPI: SSDT 0x00000000A6343000 00281B (v02 LENOVO TbtTypeC 00000000 INTL 20160527)
[    0.014753] ACPI: DBGP 0x00000000A6342000 000034 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014757] ACPI: DBG2 0x00000000A6341000 000054 (v00 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014762] ACPI: BATB 0x00000000A6340000 00004A (v02 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014767] ACPI: DMAR 0x00000000A6563000 0000C8 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014771] ACPI: ASF! 0x00000000A4B38000 0000A0 (v32 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014776] ACPI: BGRT 0x00000000A4B37000 000038 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014781] ACPI: UEFI 0x00000000A9430000 00012A (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014786] ACPI: FPDT 0x00000000A4B36000 000034 (v01 LENOVO TP-N2X   00001350 PTEC 00001350)
[    0.014790] ACPI: Reserving FACP table memory at [mem 0xa6560000-0xa6560113]
[    0.014793] ACPI: Reserving DSDT table memory at [mem 0xa652f000-0xa655b5bc]
[    0.014795] ACPI: Reserving FACS table memory at [mem 0xa947b000-0xa947b03f]
[    0.014796] ACPI: Reserving SSDT table memory at [mem 0xa65bc000-0xa65be0ad]
[    0.014798] ACPI: Reserving SSDT table memory at [mem 0xa65bb000-0xa65bb5a0]
[    0.014799] ACPI: Reserving SSDT table memory at [mem 0xa657e000-0xa6581531]
[    0.014801] ACPI: Reserving SSDT table memory at [mem 0xa6568000-0xa656b31d]
[    0.014802] ACPI: Reserving SSDT table memory at [mem 0xa6567000-0xa656760d]
[    0.014803] ACPI: Reserving TPM2 table memory at [mem 0xa6566000-0xa6566033]
[    0.014805] ACPI: Reserving BOOT table memory at [mem 0xa6564000-0xa6564027]
[    0.014806] ACPI: Reserving HPET table memory at [mem 0xa655f000-0xa655f037]
[    0.014808] ACPI: Reserving APIC table memory at [mem 0xa655e000-0xa655e163]
[    0.014809] ACPI: Reserving MCFG table memory at [mem 0xa655d000-0xa655d03b]
[    0.014811] ACPI: Reserving ECDT table memory at [mem 0xa655c000-0xa655c052]
[    0.014812] ACPI: Reserving SSDT table memory at [mem 0xa652d000-0xa652ef14]
[    0.014814] ACPI: Reserving SSDT table memory at [mem 0xa652c000-0xa652c0a5]
[    0.014815] ACPI: Reserving SSDT table memory at [mem 0xa6528000-0xa652bacf]
[    0.014817] ACPI: Reserving NHLT table memory at [mem 0xa6526000-0xa652789d]
[    0.014818] ACPI: Reserving MSDM table memory at [mem 0xa6525000-0xa6525054]
[    0.014820] ACPI: Reserving SSDT table memory at [mem 0xa6348000-0xa6348fcd]
[    0.014821] ACPI: Reserving LPIT table memory at [mem 0xa6347000-0xa6347093]
[    0.014823] ACPI: Reserving WSMT table memory at [mem 0xa6346000-0xa6346027]
[    0.014824] ACPI: Reserving SSDT table memory at [mem 0xa6343000-0xa634581a]
[    0.014826] ACPI: Reserving DBGP table memory at [mem 0xa6342000-0xa6342033]
[    0.014827] ACPI: Reserving DBG2 table memory at [mem 0xa6341000-0xa6341053]
[    0.014829] ACPI: Reserving BATB table memory at [mem 0xa6340000-0xa6340049]
[    0.014830] ACPI: Reserving DMAR table memory at [mem 0xa6563000-0xa65630c7]
[    0.014832] ACPI: Reserving ASF! table memory at [mem 0xa4b38000-0xa4b3809f]
[    0.014833] ACPI: Reserving BGRT table memory at [mem 0xa4b37000-0xa4b37037]
[    0.014835] ACPI: Reserving UEFI table memory at [mem 0xa9430000-0xa9430129]
[    0.014836] ACPI: Reserving FPDT table memory at [mem 0xa4b36000-0xa4b36033]
[    0.015016] No NUMA configuration found
[    0.015017] Faking a node at [mem 0x0000000000000000-0x000000084c7fffff]
[    0.015037] NODE_DATA(0) allocated [mem 0x84c7d5200-0x84c7fffff]
[    0.015512] Reserving Intel graphics memory at [mem 0xab800000-0xaf7fffff]
[    0.015793] ACPI: PM-Timer IO Port: 0x1808
[    0.015805] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.015808] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.015809] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.015811] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.015813] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.015814] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.015815] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.015817] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.015818] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
[    0.015819] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
[    0.015821] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
[    0.015822] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
[    0.015823] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
[    0.015825] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
[    0.015826] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
[    0.015827] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.015829] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.015830] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])
[    0.015832] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])
[    0.015833] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])
[    0.015875] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-119
[    0.015880] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.015883] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.015891] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.015892] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.015905] e820: update [mem 0xa0503000-0xa0593fff] System RAM ==> device reserved
[    0.015919] TSC deadline timer available
[    0.015924] CPU topo: Max. logical packages:   1
[    0.015926] CPU topo: Max. logical nodes:      1
[    0.015927] CPU topo: Num. nodes per package:  1
[    0.015932] CPU topo: Max. logical dies:       1
[    0.015933] CPU topo: Max. dies per package:   1
[    0.015942] CPU topo: Max. threads per core:   2
[    0.015943] CPU topo: Num. cores per package:     4
[    0.015944] CPU topo: Num. threads per package:   8
[    0.015945] CPU topo: Allowing 8 present CPUs plus 0 hotplug CPUs
[    0.015964] PM: hibernation: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.015968] PM: hibernation: Registered nosave memory: [mem 0x0009f000-0x000fffff]
[    0.015971] PM: hibernation: Registered nosave memory: [mem 0xa0503000-0xa0593fff]
[    0.015974] PM: hibernation: Registered nosave memory: [mem 0xa40b7000-0xa974efff]
[    0.015976] PM: hibernation: Registered nosave memory: [mem 0xa9750000-0xffffffff]
[    0.015979] [gap 0xaf800000-0xfed1ffff] available for PCI devices
[    0.015982] Booting paravirtualized kernel on bare hardware
[    0.015984] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.028985] Zone ranges:
[    0.028986]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.028990]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.028993]   Normal   [mem 0x0000000100000000-0x000000084c7fffff]
[    0.028995]   Device   empty
[    0.028997] Movable zone start for each node
[    0.029001] Early memory node ranges
[    0.029002]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.029004]   node   0: [mem 0x0000000000100000-0x00000000a40b6fff]
[    0.029007]   node   0: [mem 0x00000000a974f000-0x00000000a974ffff]
[    0.029008]   node   0: [mem 0x0000000100000000-0x000000084c7fffff]
[    0.029017] Initmem setup node 0 [mem 0x0000000000001000-0x000000084c7fffff]
[    0.029027] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.029065] On node 0, zone DMA: 97 pages in unavailable ranges
[    0.035574] On node 0, zone DMA32: 22168 pages in unavailable ranges
[    0.036314] On node 0, zone Normal: 26800 pages in unavailable ranges
[    0.036474] On node 0, zone Normal: 14336 pages in unavailable ranges
[    0.036487] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.037232] percpu: Embedded 82 pages/cpu s212992 r8192 d114688 u524288
[    0.037252] pcpu-alloc: s212992 r8192 d114688 u524288 alloc=1*2097152
[    0.037256] pcpu-alloc: [0] 0 1 2 3 [0] 4 5 6 7
[    0.037291] Kernel command line: BOOT_IMAGE=/vmlinuz-7.1.0-t14test202606+ root=UUID=acabe8be-6dd5-4d04-a138-22fdf9a0b015 ro preempt=full
[    0.038359] Dynamic Preempt: full
[    0.038406] printk: log buffer data + meta data: 131072 + 458752 = 589824 bytes
[    0.042665] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes, linear)
[    0.044784] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes, linear)
[    0.044974] software IO TLB: area num 8.
[    0.062221] Fallback order for Node 0: 0
[    0.062228] Built 1 zonelists, mobility grouping on.  Total pages: 8325206
[    0.062230] Policy zone: Normal
[    0.062241] mem auto-init: stack:all(zero), heap alloc:on, heap free:off
[    0.082430] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.098163] ftrace: allocating 50623 entries in 200 pages
[    0.098166] ftrace: allocated 200 pages with 3 groups
[    0.098448] rcu: Preemptible hierarchical RCU implementation.
[    0.098449] rcu: 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
[    0.098452] 	Trampoline variant of Tasks RCU enabled.
[    0.098453] 	Rude variant of Tasks RCU enabled.
[    0.098453] 	Tracing variant of Tasks RCU enabled.
[    0.098454] rcu: RCU calculated value of scheduler-enlistment delay is 100 jiffies.
[    0.098456] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.098473] RCU Tasks: Setting shift to 3 and lim to 1 rcu_task_cb_adjust=1 rcu_task_cpu_ids=8.
[    0.098476] RCU Tasks Rude: Setting shift to 3 and lim to 1 rcu_task_cb_adjust=1 rcu_task_cpu_ids=8.
[    0.110824] NR_IRQS: 524544, nr_irqs: 2048, preallocated irqs: 16
[    0.111184] rcu: srcu_init: Setting srcu_struct sizes based on contention.
[    0.111416] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.111540] Console: colour dummy device 80x25
[    0.111553] printk: legacy console [tty0] enabled
[    0.112281] ACPI: Core revision 20260408
[    0.112694] hpet: HPET dysfunctional in PC10. Force disabled.
[    0.112758] APIC: Switch to symmetric I/O mode setup
[    0.112764] DMAR: Host address width 39
[    0.112768] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.112794] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 19e2ff0505e
[    0.112803] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.112812] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c40660462 ecap f050da
[    0.112821] DMAR: RMRR base: 0x000000a81d0000 end: 0x000000a81effff
[    0.112828] DMAR: RMRR base: 0x000000ab000000 end: 0x000000af7fffff
[    0.112833] DMAR: RMRR base: 0x000000a8201000 end: 0x000000a8280fff
[    0.112839] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.112846] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.112851] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.115172] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.115179] x2apic enabled
[    0.115320] APIC: Switched APIC routing to: cluster x2apic
[    0.120890] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x1fb62f12e8c, max_idle_ns: 440795238402 ns
[    0.120905] Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.99 BogoMIPS (lpj=2199996)
[    0.120954] x86/cpu: SGX disabled or unsupported by BIOS.
[    0.120967] CPU0: Thermal monitoring enabled (TM1)
[    0.121059] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.121064] Last level dTLB entries: 4KB 64, 2MB 32, 4MB 32, 1GB 4
[    0.121083] process: using mwait in idle threads
[    0.121089] mitigations: Enabled attack vectors: user_kernel, user_user, guest_host, guest_guest, SMT mitigations: auto
[    0.121101] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
[    0.121108] SRBDS: Mitigation: Microcode
[    0.121114] Spectre V2 : Mitigation: Enhanced / Automatic IBRS
[    0.121119] RETBleed: Mitigation: Enhanced IBRS
[    0.121123] ITS: Mitigation: Aligned branch/return thunks
[    0.121127] MMIO Stale Data: Mitigation: Clear CPU buffers
[    0.121132] VMSCAPE: Mitigation: IBPB before exit to userspace
[    0.121136] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.121142] Spectre V2 : Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT
[    0.121148] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.121170] GDS: Mitigation: Microcode
[    0.121174] active return thunk: its_return_thunk
[    0.121183] Spectre V2 : Spectre BHI mitigation: SW BHB clearing on syscall and VM exit
[    0.121196] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.121202] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.121207] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.121212] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
[    0.121217] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.121222] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.121228] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.121233] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.121238] x86/fpu: Enabled xstate features 0x1f, context size is 960 bytes, using 'compacted' format.
[    0.121901] pid_max: default: 32768 minimum: 301
[    0.121901] landlock: Up and running.
[    0.121901] Yama: becoming mindful.
[    0.121901] AppArmor: AppArmor initialized
[    0.121901] TOMOYO Linux initialized
[    0.121901] LSM support for eBPF active
[    0.121901] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.121901] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.121901] VFS: Finished mounting rootfs on nullfs
[    0.121901] smpboot: CPU0: Intel(R) Core(TM) i5-10310U CPU @ 1.70GHz (family: 0x6, model: 0x8e, stepping: 0xc)
[    0.121901] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR, full-width counters, Intel PMU driver.
[    0.121901] ... version:                   4
[    0.121901] ... bit width:                 48
[    0.121901] ... generic counters:          4
[    0.121901] ... generic bitmap:            000000000000000f
[    0.121901] ... fixed-purpose counters:    3
[    0.121901] ... fixed-purpose bitmap:      0000000000000007
[    0.121901] ... value mask:                0000ffffffffffff
[    0.121901] ... max period:                00007fffffffffff
[    0.121901] ... global_ctrl mask:          000000070000000f
[    0.121901] signal: max sigframe size: 2032
[    0.121901] Estimated ratio of average max frequency by base frequency (times 1024): 1861
[    0.121901] rcu: Hierarchical SRCU implementation.
[    0.121901] rcu: 	Max phase no-delay instances is 400.
[    0.121901] Timer migration: 1 hierarchy levels; 8 children per group; 1 crossnode level
[    0.126955] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.127098] smp: Bringing up secondary CPUs ...
[    0.127280] smpboot: x86: Booting SMP configuration:
[    0.127285] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.130496] MMIO Stale Data CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processor_mmio_stale_data.html for more details.
[    0.130997] smp: Brought up 1 node, 8 CPUs
[    0.130997] smpboot: Total of 8 processors activated (35199.93 BogoMIPS)
[    0.191909] node 0 deferred pages initialised in 60ms
[    0.192488] Memory: 32485468K/33300824K available (18454K kernel code, 2763K rwdata, 8120K rodata, 4296K init, 3716K bss, 794984K reserved, 0K cma-reserved)
[    0.193747] devtmpfs: initialized
[    0.193985] x86/mm: Memory block size: 128MB
[    0.199045] ACPI: PM: Registering ACPI NVS region [mem 0xa8295000-0xa961efff] (20488192 bytes)
[    0.199356] posixtimers hash table entries: 4096 (order: 4, 65536 bytes, linear)
[    0.199356] futex hash table entries: 2048 (131072 bytes on 1 NUMA nodes, total 128 KiB, linear).
[    0.200655] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.201300] DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic allocations
[    0.201661] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    0.202054] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.202089] audit: initializing netlink subsys (disabled)
[    0.202110] audit: type=2000 audit(1782504666.081:1): state=initialized audit_enabled=0 res=1
[    0.202110] thermal_sys: Registered thermal governor 'fair_share'
[    0.202111] thermal_sys: Registered thermal governor 'bang_bang'
[    0.202118] thermal_sys: Registered thermal governor 'step_wise'
[    0.202122] thermal_sys: Registered thermal governor 'user_space'
[    0.202125] thermal_sys: Registered thermal governor 'power_allocator'
[    0.202141] cpuidle: using governor ladder
[    0.202141] cpuidle: using governor menu
[    0.202141] Simple Boot Flag at 0x47 set to 0x1
[    0.202141] Freeing SMP alternatives memory: 48K
[    0.208966] efi: Freeing EFI boot services memory: 57488K
[    0.208975] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.208981] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.209363] PCI: ECAM [mem 0xf0000000-0xf7ffffff] (base 0xf0000000) for domain 0000 [bus 00-7f]
[    0.209389] PCI: Using configuration type 1 for base access
[    0.209503] kprobes: kprobe jump-optimization is enabled. All kprobes are optimized if possible.
[    0.209948] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
[    0.209954] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
[    0.209963] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
[    0.209971] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    0.212171] ACPI: Added _OSI(Module Device)
[    0.212180] ACPI: Added _OSI(Processor Device)
[    0.212187] ACPI: Added _OSI(Processor Aggregator Device)
[    0.306534] ACPI: 11 ACPI AML tables successfully acquired and loaded
[    0.307963] ACPI: EC: EC started
[    0.307968] ACPI: EC: interrupt blocked
[    0.308938] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.308944] ACPI: EC: Boot ECDT EC used to handle transactions
[    0.311517] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.369944] ACPI: \_SB_: platform _OSC: OS support mask [002e7eff]
[    0.370108] ACPI: \_SB_: platform _OSC: OS control mask [002e7eff]
[    0.370151] ACPI: Dynamic OEM Table Load:
[    0.370159] ACPI: SSDT 0xFFFF8C7D8198F400 000400 (v02 PmRef  Cpu0Cst  00003001 INTL 20160527)
[    0.370791] ACPI: Dynamic OEM Table Load:
[    0.370798] ACPI: SSDT 0xFFFF8C7D814DB000 0005FD (v02 PmRef  Cpu0Ist  00003000 INTL 20160527)
[    0.371422] ACPI: Dynamic OEM Table Load:
[    0.371427] ACPI: SSDT 0xFFFF8C7D825B1000 0000FC (v02 PmRef  Cpu0Psd  00003000 INTL 20160527)
[    0.372007] ACPI: Dynamic OEM Table Load:
[    0.372012] ACPI: SSDT 0xFFFF8C7D814CC800 00016C (v02 PmRef  Cpu0Hwp  00003000 INTL 20160527)
[    0.372566] ACPI: Dynamic OEM Table Load:
[    0.372574] ACPI: SSDT 0xFFFF8C7D8262C000 000BEA (v02 PmRef  HwpLvt   00003000 INTL 20160527)
[    0.373266] ACPI: Dynamic OEM Table Load:
[    0.373273] ACPI: SSDT 0xFFFF8C7D814DA800 000778 (v02 PmRef  ApIst    00003000 INTL 20160527)
[    0.373923] ACPI: Dynamic OEM Table Load:
[    0.373929] ACPI: SSDT 0xFFFF8C7D8198A800 0003D7 (v02 PmRef  ApHwp    00003000 INTL 20160527)
[    0.374577] ACPI: Dynamic OEM Table Load:
[    0.374584] ACPI: SSDT 0xFFFF8C7D8262A000 000D22 (v02 PmRef  ApPsd    00003000 INTL 20160527)
[    0.375565] ACPI: Dynamic OEM Table Load:
[    0.375571] ACPI: SSDT 0xFFFF8C7D8198B800 0003CA (v02 PmRef  ApCst    00003000 INTL 20160527)
[    0.378604] ACPI: Interpreter enabled
[    0.378640] ACPI: PM: (supports S0 S3 S4 S5)
[    0.378642] ACPI: Using IOAPIC for interrupt routing
[    0.378678] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.378680] PCI: Ignoring E820 reservations for host bridge windows
[    0.378941] ACPI: Enabled 7 GPEs in block 00 to 7F
[    0.381396] ACPI: \_SB_.PCI0.LPCB.EC__.PUBS: New power resource
[    0.383569] ACPI: \_SB_.PCI0.XHC_.RHUB.HS10.BTPR: New power resource
[    0.383825] ACPI: \_SB_.PCI0.XHC_.RHUB.HS10.BTRT: New power resource
[    0.384418] ACPI: \_SB_.PCI0.XDCI.USBC: New power resource
[    0.385524] ACPI: \_SB_.PCI0.RP05.PXP_: New power resource
[    0.387333] ACPI: \_SB_.PCI0.RP07.PXP_: New power resource
[    0.391013] ACPI: \_SB_.PCI0.SAT0.VOL0.V0PR: New power resource
[    0.391112] ACPI: \_SB_.PCI0.SAT0.VOL1.V1PR: New power resource
[    0.391206] ACPI: \_SB_.PCI0.SAT0.VOL2.V2PR: New power resource
[    0.392061] ACPI: \_SB_.PCI0.CNVW.WRST: New power resource
[    0.394643] ACPI: \PIN_: New power resource
[    0.394660] ACPI: \PINP: New power resource
[    0.394968] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    0.394975] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
[    0.396189] acpi PNP0A08:00: _OSC: platform does not support [AER]
[    0.398592] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug SHPCHotplug PME PCIeCapability LTR]
[    0.398595] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.400263] PCI host bridge to bus 0000:00
[    0.400268] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.400271] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.400273] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.400275] pci_bus 0000:00: root bus resource [mem 0xaf800000-0xefffffff window]
[    0.400278] pci_bus 0000:00: root bus resource [mem 0xfc800000-0xfdffffff window]
[    0.400280] pci_bus 0000:00: root bus resource [bus 00-7e]
[    0.400303] pci 0000:00:00.0: [8086:9b61] type 00 class 0x060000 conventional PCI endpoint
[    0.400381] pci 0000:00:02.0: [8086:9b41] type 00 class 0x030000 PCIe Root Complex Integrated Endpoint
[    0.400397] pci 0000:00:02.0: BAR 0 [mem 0xed000000-0xedffffff 64bit]
[    0.400400] pci 0000:00:02.0: BAR 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.400403] pci 0000:00:02.0: BAR 4 [io  0x4000-0x403f]
[    0.400414] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.400542] pci 0000:00:04.0: [8086:1903] type 00 class 0x118000 conventional PCI endpoint
[    0.400561] pci 0000:00:04.0: BAR 0 [mem 0xef730000-0xef737fff 64bit]
[    0.400780] pci 0000:00:08.0: [8086:1911] type 00 class 0x088000 conventional PCI endpoint
[    0.400798] pci 0000:00:08.0: BAR 0 [mem 0xef742000-0xef742fff 64bit]
[    0.400905] pci 0000:00:12.0: [8086:02f9] type 00 class 0x118000 conventional PCI endpoint
[    0.400945] pci 0000:00:12.0: BAR 0 [mem 0xef743000-0xef743fff 64bit]
[    0.401062] pci 0000:00:14.0: [8086:02ed] type 00 class 0x0c0330 conventional PCI endpoint
[    0.401094] pci 0000:00:14.0: BAR 0 [mem 0xef720000-0xef72ffff 64bit]
[    0.401128] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.401410] pci 0000:00:14.2: [8086:02ef] type 00 class 0x050000 conventional PCI endpoint
[    0.401450] pci 0000:00:14.2: BAR 0 [mem 0xef740000-0xef741fff 64bit]
[    0.401454] pci 0000:00:14.2: BAR 2 [mem 0xef744000-0xef744fff 64bit]
[    0.401566] pci 0000:00:14.3: [8086:02f0] type 00 class 0x028000 PCIe Root Complex Integrated Endpoint
[    0.401622] pci 0000:00:14.3: BAR 0 [mem 0xef738000-0xef73bfff 64bit]
[    0.401718] pci 0000:00:14.3: PME# supported from D0 D3hot D3cold
[    0.401926] pci 0000:00:16.0: [8086:02e0] type 00 class 0x078000 conventional PCI endpoint
[    0.401970] pci 0000:00:16.0: BAR 0 [mem 0xef745000-0xef745fff 64bit]
[    0.402017] pci 0000:00:16.0: PME# supported from D3hot
[    0.402258] pci 0000:00:16.3: [8086:02e3] type 00 class 0x070002 conventional PCI endpoint
[    0.402293] pci 0000:00:16.3: BAR 0 [io  0x4060-0x4067]
[    0.402296] pci 0000:00:16.3: BAR 1 [mem 0xef748000-0xef748fff]
[    0.402418] pci 0000:00:1c.0: [8086:02b8] type 01 class 0x060400 PCIe Root Port
[    0.402435] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.402441] pci 0000:00:1c.0:   bridge window [mem 0xef600000-0xef6fffff]
[    0.402504] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.402898] pci 0000:00:1c.4: [8086:02bc] type 01 class 0x060400 PCIe Root Port
[    0.402917] pci 0000:00:1c.4: PCI bridge to [bus 03-2b]
[    0.402922] pci 0000:00:1c.4:   bridge window [mem 0xe0000000-0xec1fffff]
[    0.402929] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.402984] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.403372] pci 0000:00:1d.0: [8086:02b0] type 01 class 0x060400 PCIe Root Port
[    0.403393] pci 0000:00:1d.0: PCI bridge to [bus 2d]
[    0.403397] pci 0000:00:1d.0:   bridge window [io  0x3000-0x3fff]
[    0.403400] pci 0000:00:1d.0:   bridge window [mem 0xeec00000-0xef5fffff]
[    0.403409] pci 0000:00:1d.0:   bridge window [mem 0xee000000-0xee9fffff 64bit pref]
[    0.403457] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.403815] pci 0000:00:1d.4: [8086:02b4] type 01 class 0x060400 PCIe Root Port
[    0.403836] pci 0000:00:1d.4: PCI bridge to [bus 2e]
[    0.403842] pci 0000:00:1d.4:   bridge window [mem 0xeeb00000-0xeebfffff]
[    0.403909] pci 0000:00:1d.4: PME# supported from D0 D3hot D3cold
[    0.404310] pci 0000:00:1f.0: [8086:0284] type 00 class 0x060100 conventional PCI endpoint
[    0.404675] pci 0000:00:1f.3: [8086:02c8] type 00 class 0x040380 conventional PCI endpoint
[    0.404747] pci 0000:00:1f.3: BAR 0 [mem 0xef73c000-0xef73ffff 64bit]
[    0.404756] pci 0000:00:1f.3: BAR 4 [mem 0xeea00000-0xeeafffff 64bit]
[    0.404824] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.405178] pci 0000:00:1f.4: [8086:02a3] type 00 class 0x0c0500 conventional PCI endpoint
[    0.405222] pci 0000:00:1f.4: BAR 0 [mem 0xef746000-0xef7460ff 64bit]
[    0.405234] pci 0000:00:1f.4: BAR 4 [io  0xefa0-0xefbf]
[    0.405444] pci 0000:00:1f.5: [8086:02a4] type 00 class 0x0c8000 conventional PCI endpoint
[    0.405487] pci 0000:00:1f.5: BAR 0 [mem 0xfe010000-0xfe010fff]
[    0.405558] pci 0000:00:1f.6: [8086:0d4e] type 00 class 0x020000 conventional PCI endpoint
[    0.405640] pci 0000:00:1f.6: BAR 0 [mem 0xef700000-0xef71ffff]
[    0.405716] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.405855] pci 0000:02:00.0: [10ec:522a] type 00 class 0xff0000 PCIe Endpoint
[    0.405914] pci 0000:02:00.0: BAR 0 [mem 0xef600000-0xef600fff]
[    0.406026] pci 0000:02:00.0: supports D1 D2
[    0.406028] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.406248] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.406324] pci 0000:03:00.0: [8086:15c0] type 01 class 0x060400 PCIe Switch Upstream Port
[    0.406353] pci 0000:03:00.0: PCI bridge to [bus 04-2b]
[    0.406363] pci 0000:03:00.0:   bridge window [mem 0xe0000000-0xec1fffff]
[    0.406374] pci 0000:03:00.0:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.406388] pci 0000:03:00.0: enabling Extended Tags
[    0.406478] pci 0000:03:00.0: supports D1 D2
[    0.406480] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.406654] pci 0000:00:1c.4: PCI bridge to [bus 03-2b]
[    0.406744] pci 0000:04:00.0: [8086:15c0] type 01 class 0x060400 PCIe Switch Downstream Port
[    0.406774] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.406784] pci 0000:04:00.0:   bridge window [mem 0xec100000-0xec1fffff]
[    0.406809] pci 0000:04:00.0: enabling Extended Tags
[    0.406899] pci 0000:04:00.0: supports D1 D2
[    0.406901] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.407081] pci 0000:04:01.0: [8086:15c0] type 01 class 0x060400 PCIe Switch Downstream Port
[    0.407111] pci 0000:04:01.0: PCI bridge to [bus 06-2a]
[    0.407121] pci 0000:04:01.0:   bridge window [mem 0xe0100000-0xec0fffff]
[    0.407133] pci 0000:04:01.0:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.407148] pci 0000:04:01.0: enabling Extended Tags
[    0.407242] pci 0000:04:01.0: supports D1 D2
[    0.407244] pci 0000:04:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.407419] pci 0000:04:02.0: [8086:15c0] type 01 class 0x060400 PCIe Switch Downstream Port
[    0.407449] pci 0000:04:02.0: PCI bridge to [bus 2b]
[    0.407458] pci 0000:04:02.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.407483] pci 0000:04:02.0: enabling Extended Tags
[    0.407573] pci 0000:04:02.0: supports D1 D2
[    0.407575] pci 0000:04:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.407755] pci 0000:03:00.0: PCI bridge to [bus 04-2b]
[    0.407858] pci 0000:05:00.0: [8086:15bf] type 00 class 0x088000 PCIe Endpoint
[    0.407910] pci 0000:05:00.0: BAR 0 [mem 0xec100000-0xec13ffff]
[    0.407913] pci 0000:05:00.0: BAR 1 [mem 0xec140000-0xec140fff]
[    0.407930] pci 0000:05:00.0: enabling Extended Tags
[    0.408044] pci 0000:05:00.0: supports D1 D2
[    0.408046] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.408237] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.408289] pci 0000:04:01.0: PCI bridge to [bus 06-2a]
[    0.408403] pci 0000:2b:00.0: [8086:15c1] type 00 class 0x0c0330 PCIe Endpoint
[    0.408463] pci 0000:2b:00.0: BAR 0 [mem 0xe0000000-0xe000ffff]
[    0.408483] pci 0000:2b:00.0: enabling Extended Tags
[    0.408607] pci 0000:2b:00.0: supports D1 D2
[    0.408609] pci 0000:2b:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.408844] pci 0000:04:02.0: PCI bridge to [bus 2b]
[    0.408930] pci 0000:00:1d.0: PCI bridge to [bus 2d]
[    0.409245] pci 0000:2e:00.0: [c0a9:5426] type 00 class 0x010802 PCIe Endpoint
[    0.409334] pci 0000:2e:00.0: BAR 0 [mem 0xeeb00000-0xeeb03fff 64bit]
[    0.409791] pci 0000:2e:00.0: 31.504 Gb/s available PCIe bandwidth, limited by 8.0 GT/s PCIe x4 link at 0000:00:1d.4 (capable of 63.012 Gb/s with 16.0 GT/s PCIe x4 link)
[    0.410238] pci 0000:00:1d.4: PCI bridge to [bus 2e]
[    0.414174] ACPI: EC: interrupt unblocked
[    0.414177] ACPI: EC: event unblocked
[    0.414188] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.414191] ACPI: EC: GPE=0x16
[    0.414193] ACPI: \_SB_.PCI0.LPCB.EC__: Boot ECDT EC initialization complete
[    0.414195] ACPI: \_SB_.PCI0.LPCB.EC__: EC: Used to handle transactions and events
[    0.414267] iommu: Default domain type: Translated
[    0.414267] iommu: DMA domain TLB invalidation policy: lazy mode
[    0.414267] ACPI: bus type USB registered
[    0.414267] usbcore: registered new interface driver usbfs
[    0.414267] usbcore: registered new interface driver hub
[    0.414267] usbcore: registered new device driver usb
[    0.414267] pps_core: LinuxPPS API ver. 1 registered
[    0.414267] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.414267] PTP clock support registered
[    0.414267] EDAC MC: Ver: 3.0.0
[    0.414907] efivars: Registered efivars operations
[    0.415043] NetLabel: Initializing
[    0.415046] NetLabel:  domain hash size = 128
[    0.415047] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.415061] NetLabel:  unlabeled traffic allowed by default
[    0.415074] PCI: Using ACPI for IRQ routing
[    0.431067] PCI: pci_cache_line_size set to 64 bytes
[    0.431353] pci 0000:00:1f.5: BAR 0 [mem 0xfe010000-0xfe010fff]: can't claim; no compatible bridge window
[    0.431638] e820: register RAM buffer resource [mem 0x0009f000-0x0009ffff]
[    0.431641] e820: register RAM buffer resource [mem 0xa0503000-0xa3ffffff]
[    0.431643] e820: register RAM buffer resource [mem 0xa40b7000-0xa7ffffff]
[    0.431645] e820: register RAM buffer resource [mem 0xa9750000-0xabffffff]
[    0.431647] e820: register RAM buffer resource [mem 0x84c800000-0x84fffffff]
[    0.431669] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.431669] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.431669] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=mem,locks=none
[    0.431669] vgaarb: loaded
[    0.432044] clocksource: Switched to clocksource tsc-early
[    0.432073] VFS: Disk quotas dquot_6.6.0
[    0.432086] VFS: Dquot-cache hash table entries: 512 (4096 bytes)
[    0.432180] AppArmor: AppArmor Filesystem Enabled
[    0.432298] acpi PNP0C02:00: Reserved [mem 0xfd000000-0xfd69ffff]
[    0.432302] acpi PNP0C02:00: Reserved [mem 0xfd6b0000-0xfd6cffff]
[    0.432305] acpi PNP0C02:00: Reserved [mem 0xfd6f0000-0xfdffffff]
[    0.432307] acpi PNP0C02:00: Reserved [mem 0xfe000000-0xfe01ffff]
[    0.432309] acpi PNP0C02:00: Reserved [mem 0xfe200000-0xfe7fffff]
[    0.432311] acpi PNP0C02:00: Reserved [mem 0xff000000-0xffffffff]
[    0.432313] acpi PNP0C02:00: Could not reserve [io  0x1800-0x18fe]
[    0.432520] acpi PNP0C02:01: Reserved [io  0x2000-0x20fe]
[    0.432527] acpi PNP0C02:02: Skipped [io  0x002e-0x002f]
[    0.432529] acpi PNP0C02:02: Skipped [io  0x004e-0x004f]
[    0.432531] acpi PNP0C02:02: Skipped [io  0x0061]
[    0.432533] acpi PNP0C02:02: Skipped [io  0x0063]
[    0.432534] acpi PNP0C02:02: Skipped [io  0x0065]
[    0.432536] acpi PNP0C02:02: Skipped [io  0x0067]
[    0.432538] acpi PNP0C02:02: Skipped [io  0x0070]
[    0.432539] acpi PNP0C02:02: Skipped [io  0x0080]
[    0.432541] acpi PNP0C02:02: Skipped [io  0x0092]
[    0.432543] acpi PNP0C02:02: Skipped [io  0x00b2-0x00b3]
[    0.432545] acpi PNP0C02:02: Reserved [io  0x0680-0x069f]
[    0.432547] acpi PNP0C02:02: Reserved [io  0x164e-0x164f]
[    0.432569] acpi PNP0C02:03: Skipped [io  0x0010-0x001f]
[    0.432571] acpi PNP0C02:03: Skipped [io  0x0090-0x009f]
[    0.432576] acpi PNP0C02:03: Skipped [io  0x0024-0x0025]
[    0.432579] acpi PNP0C02:03: Skipped [io  0x0028-0x0029]
[    0.432580] acpi PNP0C02:03: Skipped [io  0x002c-0x002d]
[    0.432582] acpi PNP0C02:03: Skipped [io  0x0030-0x0031]
[    0.432584] acpi PNP0C02:03: Skipped [io  0x0034-0x0035]
[    0.432586] acpi PNP0C02:03: Skipped [io  0x0038-0x0039]
[    0.432587] acpi PNP0C02:03: Skipped [io  0x003c-0x003d]
[    0.432589] acpi PNP0C02:03: Skipped [io  0x00a4-0x00a5]
[    0.432591] acpi PNP0C02:03: Skipped [io  0x00a8-0x00a9]
[    0.432593] acpi PNP0C02:03: Skipped [io  0x00ac-0x00ad]
[    0.432594] acpi PNP0C02:03: Skipped [io  0x00b0-0x00b5]
[    0.432596] acpi PNP0C02:03: Skipped [io  0x00b8-0x00b9]
[    0.432598] acpi PNP0C02:03: Skipped [io  0x00bc-0x00bd]
[    0.432600] acpi PNP0C02:03: Skipped [io  0x0050-0x0053]
[    0.432601] acpi PNP0C02:03: Skipped [io  0x0072-0x0077]
[    0.432603] acpi PNP0C02:03: Could not reserve [io  0x1800-0x189f]
[    0.432605] acpi PNP0C02:03: Reserved [io  0x0800-0x087f]
[    0.432607] acpi PNP0C02:03: Reserved [io  0x0880-0x08ff]
[    0.432609] acpi PNP0C02:03: Reserved [io  0x0900-0x097f]
[    0.432611] acpi PNP0C02:03: Reserved [io  0x0980-0x09ff]
[    0.432613] acpi PNP0C02:03: Reserved [io  0x0a00-0x0a7f]
[    0.432615] acpi PNP0C02:03: Reserved [io  0x0a80-0x0aff]
[    0.432617] acpi PNP0C02:03: Reserved [io  0x0b00-0x0b7f]
[    0.432619] acpi PNP0C02:03: Reserved [io  0x0b80-0x0bff]
[    0.432620] acpi PNP0C02:03: Reserved [io  0x15e0-0x15ef]
[    0.432622] acpi PNP0C02:03: Could not reserve [io  0x1600-0x167f]
[    0.432624] acpi PNP0C02:03: Could not reserve [io  0x1640-0x165f]
[    0.432627] acpi PNP0C02:03: Reserved [mem 0xf0000000-0xf7ffffff]
[    0.432629] acpi PNP0C02:03: Reserved [mem 0xfed10000-0xfed13fff]
[    0.432631] acpi PNP0C02:03: Reserved [mem 0xfed18000-0xfed18fff]
[    0.432633] acpi PNP0C02:03: Reserved [mem 0xfed19000-0xfed19fff]
[    0.432635] acpi PNP0C02:03: Reserved [mem 0xfeb00000-0xfebfffff]
[    0.432637] acpi PNP0C02:03: Reserved [mem 0xfed20000-0xfed3ffff]
[    0.432639] acpi PNP0C02:03: Could not reserve [mem 0xfed90000-0xfed93fff]
[    0.432702] acpi PNP0C02:04: Could not reserve [mem 0xfed10000-0xfed17fff]
[    0.432704] acpi PNP0C02:04: Reserved [mem 0xfed18000-0xfed18fff]
[    0.432706] acpi PNP0C02:04: Reserved [mem 0xfed19000-0xfed19fff]
[    0.432708] acpi PNP0C02:04: Reserved [mem 0xf0000000-0xf7ffffff]
[    0.432710] acpi PNP0C02:04: Reserved [mem 0xfed20000-0xfed3ffff]
[    0.432712] acpi PNP0C02:04: Could not reserve [mem 0xfed90000-0xfed93fff]
[    0.432714] acpi PNP0C02:04: Could not reserve [mem 0xfed45000-0xfed8ffff]
[    0.432716] acpi PNP0C02:04: Reserved [mem 0xfee00000-0xfeefffff]
[    0.432792] acpi PNP0C02:05: Reserved [mem 0xfe038000-0xfe038fff]
[    0.432870] acpi PNP0C01:00: Could not reserve [mem 0x00000000-0x0009ffff]
[    0.432872] acpi PNP0C01:00: Could not reserve [mem 0x000c0000-0x000c3fff]
[    0.432874] acpi PNP0C01:00: Could not reserve [mem 0x000c8000-0x000cbfff]
[    0.432876] acpi PNP0C01:00: Could not reserve [mem 0x000d0000-0x000d3fff]
[    0.432878] acpi PNP0C01:00: Could not reserve [mem 0x000d8000-0x000dbfff]
[    0.432880] acpi PNP0C01:00: Could not reserve [mem 0x000e0000-0x000e3fff]
[    0.432882] acpi PNP0C01:00: Could not reserve [mem 0x000e8000-0x000ebfff]
[    0.432883] acpi PNP0C01:00: Could not reserve [mem 0x000f0000-0x000fffff]
[    0.432885] acpi PNP0C01:00: Could not reserve [mem 0x00100000-0xaf7fffff]
[    0.432887] acpi PNP0C01:00: Could not reserve [mem 0xfec00000-0xfed3ffff]
[    0.432889] acpi PNP0C01:00: Could not reserve [mem 0xfed4c000-0xffffffff]
[    0.432899] pnp: PnP ACPI init
[    0.433865] pnp: PnP ACPI: found 2 devices
[    0.439279] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.439332] NET: Registered PF_INET protocol family
[    0.439416] IP idents hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.441463] tcp_listen_portaddr_hash hash table entries: 16384 (order: 6, 262144 bytes, linear)
[    0.441492] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    0.441602] TCP established hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.441830] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes, linear)
[    0.441986] TCP: Hash tables configured (established 262144 bind 65536)
[    0.442070] MPTCP token hash table entries: 32768 (order: 8, 786432 bytes, linear)
[    0.442166] UDP hash table entries: 16384 (order: 8, 1048576 bytes, linear)
[    0.442283] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.442616] NET: Registered PF_XDP protocol family
[    0.442632] pci 0000:04:01.0: bridge window [io  0x1000-0x0fff] to [bus 06-2a] add_size 1000
[    0.442639] pci 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04-2b] add_size 1000
[    0.442642] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 03-2b] add_size 2000
[    0.442653] pci 0000:00:1c.4: bridge window [io  0x5000-0x6fff]: assigned
[    0.442656] pci 0000:00:1f.5: BAR 0 [mem 0xaf800000-0xaf800fff]: assigned
[    0.442669] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.442673] pci 0000:00:1c.0:   bridge window [mem 0xef600000-0xef6fffff]
[    0.442695] pci 0000:03:00.0: bridge window [io  0x5000-0x5fff]: assigned
[    0.442697] pci 0000:04:01.0: bridge window [io  0x5000-0x5fff]: assigned
[    0.442699] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.442704] pci 0000:04:00.0:   bridge window [mem 0xec100000-0xec1fffff]
[    0.442713] pci 0000:04:01.0: PCI bridge to [bus 06-2a]
[    0.442716] pci 0000:04:01.0:   bridge window [io  0x5000-0x5fff]
[    0.442721] pci 0000:04:01.0:   bridge window [mem 0xe0100000-0xec0fffff]
[    0.442725] pci 0000:04:01.0:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.442732] pci 0000:04:02.0: PCI bridge to [bus 2b]
[    0.442738] pci 0000:04:02.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.442746] pci 0000:03:00.0: PCI bridge to [bus 04-2b]
[    0.442749] pci 0000:03:00.0:   bridge window [io  0x5000-0x5fff]
[    0.442754] pci 0000:03:00.0:   bridge window [mem 0xe0000000-0xec1fffff]
[    0.442758] pci 0000:03:00.0:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.442764] pci 0000:00:1c.4: PCI bridge to [bus 03-2b]
[    0.442767] pci 0000:00:1c.4:   bridge window [io  0x5000-0x6fff]
[    0.442770] pci 0000:00:1c.4:   bridge window [mem 0xe0000000-0xec1fffff]
[    0.442773] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.442778] pci 0000:00:1d.0: PCI bridge to [bus 2d]
[    0.442783] pci 0000:00:1d.0:   bridge window [io  0x3000-0x3fff]
[    0.442787] pci 0000:00:1d.0:   bridge window [mem 0xeec00000-0xef5fffff]
[    0.442791] pci 0000:00:1d.0:   bridge window [mem 0xee000000-0xee9fffff 64bit pref]
[    0.442796] pci 0000:00:1d.4: PCI bridge to [bus 2e]
[    0.442803] pci 0000:00:1d.4:   bridge window [mem 0xeeb00000-0xeebfffff]
[    0.442810] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.442812] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.442814] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.442816] pci_bus 0000:00: resource 7 [mem 0xaf800000-0xefffffff window]
[    0.442818] pci_bus 0000:00: resource 8 [mem 0xfc800000-0xfdffffff window]
[    0.442823] pci_bus 0000:02: resource 1 [mem 0xef600000-0xef6fffff]
[    0.442825] pci_bus 0000:03: resource 0 [io  0x5000-0x6fff]
[    0.442827] pci_bus 0000:03: resource 1 [mem 0xe0000000-0xec1fffff]
[    0.442829] pci_bus 0000:03: resource 2 [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.442831] pci_bus 0000:04: resource 0 [io  0x5000-0x5fff]
[    0.442833] pci_bus 0000:04: resource 1 [mem 0xe0000000-0xec1fffff]
[    0.442835] pci_bus 0000:04: resource 2 [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.442837] pci_bus 0000:05: resource 1 [mem 0xec100000-0xec1fffff]
[    0.442839] pci_bus 0000:06: resource 0 [io  0x5000-0x5fff]
[    0.442841] pci_bus 0000:06: resource 1 [mem 0xe0100000-0xec0fffff]
[    0.442843] pci_bus 0000:06: resource 2 [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.442845] pci_bus 0000:2b: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.442847] pci_bus 0000:2d: resource 0 [io  0x3000-0x3fff]
[    0.442849] pci_bus 0000:2d: resource 1 [mem 0xeec00000-0xef5fffff]
[    0.442850] pci_bus 0000:2d: resource 2 [mem 0xee000000-0xee9fffff 64bit pref]
[    0.442853] pci_bus 0000:2e: resource 1 [mem 0xeeb00000-0xeebfffff]
[    0.443711] PCI: CLS 0 bytes, default 64
[    0.443764] DMAR: Intel-IOMMU force enabled due to platform opt in
[    0.443774] DMAR: No ATSR found
[    0.443775] DMAR: No SATC found
[    0.443777] DMAR: dmar0: Using Queued invalidation
[    0.443780] DMAR: dmar1: Using Queued invalidation
[    0.443872] Unpacking initramfs...
[    0.444346] pci 0000:00:02.0: Adding to iommu group 0
[    0.444385] pci 0000:00:00.0: Adding to iommu group 1
[    0.444394] pci 0000:00:04.0: Adding to iommu group 2
[    0.444402] pci 0000:00:08.0: Adding to iommu group 3
[    0.444412] pci 0000:00:12.0: Adding to iommu group 4
[    0.444425] pci 0000:00:14.0: Adding to iommu group 5
[    0.444432] pci 0000:00:14.2: Adding to iommu group 5
[    0.444439] pci 0000:00:14.3: Adding to iommu group 6
[    0.444452] pci 0000:00:16.0: Adding to iommu group 7
[    0.444460] pci 0000:00:16.3: Adding to iommu group 7
[    0.444471] pci 0000:00:1c.0: Adding to iommu group 8
[    0.444481] pci 0000:00:1c.4: Adding to iommu group 9
[    0.444501] pci 0000:00:1d.0: Adding to iommu group 10
[    0.444572] pci 0000:00:1d.4: Adding to iommu group 11
[    0.444594] pci 0000:00:1f.0: Adding to iommu group 12
[    0.444603] pci 0000:00:1f.3: Adding to iommu group 12
[    0.444611] pci 0000:00:1f.4: Adding to iommu group 12
[    0.444632] pci 0000:00:1f.5: Adding to iommu group 12
[    0.444640] pci 0000:00:1f.6: Adding to iommu group 12
[    0.444648] pci 0000:02:00.0: Adding to iommu group 13
[    0.444665] pci 0000:03:00.0: Adding to iommu group 14
[    0.444681] pci 0000:04:00.0: Adding to iommu group 15
[    0.444692] pci 0000:04:01.0: Adding to iommu group 16
[    0.444703] pci 0000:04:02.0: Adding to iommu group 17
[    0.444708] pci 0000:05:00.0: Adding to iommu group 15
[    0.444712] pci 0000:2b:00.0: Adding to iommu group 17
[    0.444724] pci 0000:2e:00.0: Adding to iommu group 18
[    0.444882] DMAR: Intel(R) Virtualization Technology for Directed I/O
[    0.444884] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.444886] software IO TLB: mapped [mem 0x000000009b291000-0x000000009f291000] (64MB)
[    0.445387] Initialise system trusted keyrings
[    0.445441] Key type blacklist registered
[    0.445615] workingset: timestamp_bits=36 (anon: 31) max_order=23 bucket_order=0 (anon: 0)
[    0.445799] fuse: init (API version 7.45)
[    0.445977] integrity: Platform Keyring initialized
[    0.445982] integrity: Machine keyring initialized
[    0.454445] Key type asymmetric registered
[    0.454452] Asymmetric key parser 'x509' registered
[    0.454550] alg: full crypto tests enabled.  This is intended for developer use only.
[    0.458166] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 245)
[    0.458331] io scheduler mq-deadline registered
[    0.462451] ledtrig-cpu: registered to indicate activity on CPUs
[    0.462687] pcieport 0000:00:1c.0: PME: Signaling with IRQ 123
[    0.462819] pcieport 0000:00:1c.4: PME: Signaling with IRQ 124
[    0.462841] pcieport 0000:00:1c.4: pciehp: Slot #4 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Interlock- NoCompl+ IbPresDis- LLActRep+
[    0.463145] pcieport 0000:00:1d.0: PME: Signaling with IRQ 125
[    0.463174] pcieport 0000:00:1d.0: pciehp: Slot #0 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Interlock- NoCompl+ IbPresDis- LLActRep+
[    0.463540] pcieport 0000:00:1d.4: PME: Signaling with IRQ 126
[    0.463959] pcieport 0000:04:01.0: pciehp: Slot #1 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Interlock- NoCompl+ IbPresDis- LLActRep+
[    0.469249] acpi LNXTHERM:00: registered as thermal_zone0
[    0.469254] ACPI: thermal: Thermal Zone [THM0] (47 C)
[    0.469428] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.470226] serial 0000:00:16.3: enabling device (0001 -> 0003)
[    0.470863] 0000:00:16.3: ttyS0 at I/O 0x4060 (irq = 19, base_baud = 115200) is a 16550A
[    0.471102] hpet_acpi_probe: no address or irqs in _CRS
[    0.473238] tpm_tis STM0125:00: 2.0 TPM (vendor-id 0x104A, device-id 0x0, rev-id 78)
[    0.573897] Freeing initrd memory: 48376K
[    0.694449] UEFI TPM log area empty
[    0.697048] ACPI: bus type drm_connector registered
[    0.704670] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.712704] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.712730] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.712896] mousedev: PS/2 mouse device common for all mice
[    0.712949] rtc_cmos PNP0B00:00: RTC can wake from S4
[    0.714260] rtc_cmos PNP0B00:00: registered as rtc0
[    0.714572] rtc_cmos PNP0B00:00: setting system clock to 2026-06-26T20:11:06 UTC (1782504666)
[    0.714638] rtc_cmos PNP0B00:00: alarms up to one month, y3k, 242 bytes nvram
[    0.715274] intel_pstate: Intel P-state driver initializing
[    0.715702] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.715879] intel_pstate: HWP enabled
[    0.716291] simple-framebuffer simple-framebuffer.0: [drm] Registered 1 planes with drm panic
[    0.716338] [drm] Initialized simpledrm 1.0.0 for simple-framebuffer.0 on minor 0
[    0.721868] Console: switching to colour frame buffer device 240x67
[    0.724702] simple-framebuffer simple-framebuffer.0: [drm] fb0: simpledrmdrmfb frame buffer device
[    0.725135] NET: Registered PF_INET6 protocol family
[    0.725739] Segment Routing with IPv6
[    0.725762] In-situ OAM (IOAM) with IPv6
[    0.725789] mip6: Mobile IPv6
[    0.725798] NET: Registered PF_PACKET protocol family
[    0.725918] mpls_gso: MPLS GSO support
[    0.726609] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.726883] microcode: Current revision: 0x00000100
[    0.727292] IPI shorthand broadcast: enabled
[    0.728491] sched_clock: Marking stable (719001105, 9486458)->(782349974, -53862411)
[    0.728888] registered taskstats version 1
[    0.728936] Loading compiled-in X.509 certificates
[    0.763542] Loaded X.509 cert 'Build time autogenerated kernel key: 9d0a22ebf69e94394359820e3dc224cdddc631d6'
[    0.767014] Demotion targets for Node 0: null
[    0.767103] Key type .fscrypt registered
[    0.767123] Key type fscrypt-provisioning registered
[    0.795565] Key type encrypted registered
[    0.795582] AppArmor: AppArmor sha256 policy hashing enabled
[    0.797439] ima: Allocated hash algorithm: sha256
[    0.872153] ima: No architecture policies found
[    0.872228] evm: Initialising EVM extended attributes:
[    0.872243] evm: security.selinux
[    0.872254] evm: security.SMACK64 (disabled)
[    0.872266] evm: security.SMACK64EXEC (disabled)
[    0.872278] evm: security.SMACK64TRANSMUTE (disabled)
[    0.872292] evm: security.SMACK64MMAP (disabled)
[    0.872304] evm: security.apparmor
[    0.872314] evm: security.ima
[    0.872323] evm: security.capability
[    0.872347] evm: HMAC attrs: 0x1
[    0.873388] integrity: Loading X.509 certificate: UEFI:db
[    0.873550] integrity: Loaded X.509 cert 'Lenovo Ltd.: ThinkPad Product CA 2012: 838b1f54c1550463f45f98700640f11069265949'
[    0.873581] integrity: Loading X.509 certificate: UEFI:db
[    0.873636] integrity: Loaded X.509 cert 'Lenovo UEFI CA 2014: 4b91a68732eaefdd2c8ffffc6b027ec3449e9c8f'
[    0.873661] integrity: Loading X.509 certificate: UEFI:db
[    0.873737] integrity: Loaded X.509 cert 'Microsoft Corporation UEFI CA 2011: 13adbf4309bd82709c8cd54f316ed522988a1bd4'
[    0.873763] integrity: Loading X.509 certificate: UEFI:db
[    0.873817] integrity: Loaded X.509 cert 'Microsoft Windows Production PCA 2011: a92902398e16c49778cd90f99e4f9ae17c55af53'
[    0.873843] integrity: Loading X.509 certificate: UEFI:db
[    0.873895] integrity: Loaded X.509 cert 'Microsoft Corporation: Windows UEFI CA 2023: aefc5fbbbe055d8f8daa585473499417ab5a5272'
[    0.873922] integrity: Loading X.509 certificate: UEFI:db
[    0.874741] integrity: Loaded X.509 cert 'Microsoft UEFI CA 2023: 81aa6b3244c935bce0d6628af39827421e32497d'
[    0.875473] integrity: Loading X.509 certificate: UEFI:db
[    0.876652] integrity: Loaded X.509 cert 'Microsoft Option ROM UEFI CA 2023: 514fbf937fa46fb57bf07af8bed84b3b864b1711'
[    0.893478] alg: No test for mldsa87 (mldsa87-lib)
[    0.895121] alg: No test for mldsa65 (mldsa65-lib)
[    0.896428] alg: No test for mldsa44 (mldsa44-lib)
[    0.910307] RAS: Correctable Errors collector initialized.
[    0.911518] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    0.933936] Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    0.934339] Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
[    0.934625] clk: Disabling unused clocks
[    0.937103] Freeing unused decrypted memory: 2028K
[    0.938876] Freeing unused kernel image (initmem) memory: 4296K
[    0.939211] Write protecting the kernel read-only data: 28672k
[    0.941158] Freeing unused kernel image (text/rodata gap) memory: 2024K
[    0.941492] Freeing unused kernel image (rodata/data gap) memory: 72K
[    0.952352] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    0.953604] Run /init as init process
[    0.953821]   with arguments:
[    0.953822]     /init
[    0.953823]   with environment:
[    0.953824]     HOME=/
[    0.953824]     TERM=linux
[    1.110583] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[    1.111147] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[    1.115069] i2c i2c-0: Successfully instantiated SPD at 0x51
[    1.117967] rtsx_pci 0000:02:00.0: enabling device (0000 -> 0002)
[    1.137546] e1000e: Intel(R) PRO/1000 Network Driver
[    1.139322] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    1.141479] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.148393] ACPI: bus type thunderbolt registered
[    1.149415] thunderbolt 0000:05:00.0: enabling device (0000 -> 0002)
[    1.151079] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.151697] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.153310] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x110 quirks 0x0000000000009810
[    1.154294] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.154876] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.155429] xhci_hcd 0000:00:14.0: Host supports USB 3.1 Enhanced SuperSpeed
[    1.156020] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 7.01
[    1.156519] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.157017] usb usb1: Product: xHCI Host Controller
[    1.157510] usb usb1: Manufacturer: Linux 7.1.0-t14test202606+ xhci-hcd
[    1.158017] usb usb1: SerialNumber: 0000:00:14.0
[    1.158752] hub 1-0:1.0: USB hub found
[    1.159346] hub 1-0:1.0: 12 ports detected
[    1.160043] iTCO_wdt iTCO_wdt: Found a Intel PCH TCO device (Version=6, TCOBASE=0x0400)
[    1.160657] iTCO_wdt iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.161942] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 7.01
[    1.162460] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.162920] usb usb2: Product: xHCI Host Controller
[    1.163303] usb usb2: Manufacturer: Linux 7.1.0-t14test202606+ xhci-hcd
[    1.163682] usb usb2: SerialNumber: 0000:00:14.0
[    1.164221] hub 2-0:1.0: USB hub found
[    1.164700] hub 2-0:1.0: 6 ports detected
[    1.165455] nvme nvme0: pci function 0000:2e:00.0
[    1.167030] xhci_hcd 0000:2b:00.0: xHCI Host Controller
[    1.167431] xhci_hcd 0000:2b:00.0: new USB bus registered, assigned bus number 3
[    1.168935] xhci_hcd 0000:2b:00.0: hcc params 0x200077c1 hci version 0x110 quirks 0x0000000200009810
[    1.169766] xhci_hcd 0000:2b:00.0: xHCI Host Controller
[    1.170280] xhci_hcd 0000:2b:00.0: new USB bus registered, assigned bus number 4
[    1.170767] xhci_hcd 0000:2b:00.0: Host supports USB 3.1 Enhanced SuperSpeed
[    1.171308] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 7.01
[    1.171801] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.172269] usb usb3: Product: xHCI Host Controller
[    1.172736] usb usb3: Manufacturer: Linux 7.1.0-t14test202606+ xhci-hcd
[    1.173154] usb usb3: SerialNumber: 0000:2b:00.0
[    1.173826] hub 3-0:1.0: USB hub found
[    1.174268] hub 3-0:1.0: 2 ports detected
[    1.176482] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 7.01
[    1.177719] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.178052] usb usb4: Product: xHCI Host Controller
[    1.178349] usb usb4: Manufacturer: Linux 7.1.0-t14test202606+ xhci-hcd
[    1.178624] usb usb4: SerialNumber: 0000:2b:00.0
[    1.179092] hub 4-0:1.0: USB hub found
[    1.179367] hub 4-0:1.0: 2 ports detected
[    1.188444] nvme nvme0: passthrough uses implicit buffer lengths
[    1.193905] nvme nvme0: allocated 64 MiB host memory buffer (16 segments).
[    1.212535] nvme nvme0: 8/0/0 default/read/poll queues
[    1.216953] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): registered PHC clock
[    1.217771]  nvme0n1: p1 p2 p3 p4
[    1.280184] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 8c:8c:aa:54:44:f3
[    1.280593] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Connection
[    1.281273] e1000e 0000:00:1f.6 eth0: MAC: 13, PHY: 12, PBA No: FFFFFF-0FF
[    1.283150] e1000e 0000:00:1f.6 enp0s31f6: renamed from eth0
[    1.400552] usb 1-6: new full-speed USB device number 2 using xhci_hcd
[    1.473624] typec port0: bound usb1-port2 (ops connector_ops)
[    1.474090] typec port0: bound usb2-port2 (ops connector_ops)
[    1.496520] tsc: Refined TSC clocksource calibration: 2208.000 MHz
[    1.496806] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fd3b81b95f, max_idle_ns: 440795257325 ns
[    1.497901] clocksource: Switched to clocksource tsc
[    1.527807] usb 1-6: New USB device found, idVendor=04f3, idProduct=289b, bcdDevice=57.13
[    1.528065] usb 1-6: New USB device strings: Mfr=4, Product=14, SerialNumber=0
[    1.528276] usb 1-6: Product: Touchscreen
[    1.528495] usb 1-6: Manufacturer: ELAN
[    1.641531] usb 1-8: new high-speed USB device number 3 using xhci_hcd
[    1.777020] usb 1-8: New USB device found, idVendor=04ca, idProduct=7070, bcdDevice= 0.25
[    1.777337] usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.777619] usb 1-8: Product: Integrated Camera
[    1.777864] usb 1-8: Manufacturer: 8SSC20F27068V1SR0B5D74K
[    1.891533] usb 1-10: new full-speed USB device number 4 using xhci_hcd
[    1.941540] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4694]
[    1.944499] hid: raw HID events driver (C) Jiri Kosina
[    1.944929] i915 0000:00:02.0: enabling device (0006 -> 0007)
[    1.948085] i915 0000:00:02.0: [drm] Found cometlake/ult (device ID 9b41) integrated display version 9.00 stepping N/A
[    1.949999] i915 0000:00:02.0: [drm] VT-d active for gfx access
[    1.967154] usbcore: registered new interface driver usbhid
[    1.967498] usbhid: USB HID core driver
[    1.969666] Console: switching to colour dummy device 80x25
[    1.972136] i915 0000:00:02.0: vgaarb: deactivate vga console
[    1.972178] i915 0000:00:02.0: [drm] Using Transparent Hugepages
[    1.975748] psmouse serio1: synaptics: queried min coordinates: x [1266..], y [1162..]
[    1.975757] psmouse serio1: synaptics: Trying to set up SMBus access
[    1.976208] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input3
[    1.976254] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input4
[    1.976269] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input5
[    1.976322] hid-generic 0003:04F3:289B.0001: input,hiddev0,hidraw0: USB HID v1.10 Device [ELAN Touchscreen] on usb-0000:00:14.0-6/input0
[    1.978139] i915 0000:00:02.0: [drm] Finished loading DMC firmware i915/kbl_dmc_ver1_04.bin (v1.4)
[    1.990264] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input7
[    1.990305] input: ELAN Touchscreen UNKNOWN as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input8
[    1.990323] input: ELAN Touchscreen UNKNOWN as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input9
[    1.990367] hid-multitouch 0003:04F3:289B.0001: input,hiddev0,hidraw0: USB HID v1.10 Device [ELAN Touchscreen] on usb-0000:00:14.0-6/input0
[    2.013193] i915 0000:00:02.0: vgaarb: VGA decodes changed: olddecodes=io+mem,decodes=io:owns=mem
[    2.018225] usb 1-10: New USB device found, idVendor=8087, idProduct=0026, bcdDevice= 0.02
[    2.018231] usb 1-10: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.022490] i915 0000:00:02.0: [drm] Registered 3 planes with drm panic
[    2.038675] [drm] Initialized i915 1.6.0 for 0000:00:02.0 on minor 1
[    2.052111] ACPI: video: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.052228] input: Video Bus as /devices/pci0000:00/acpi.video_bus.0/input/input11
[    2.129278] fbcon: i915drmfb (fb0) is primary device
[    2.138433] Console: switching to colour frame buffer device 240x67
[    2.172873] i915 0000:00:02.0: [drm] fb0: i915drmfb frame buffer device
[    2.233591] xor: automatically using best checksumming function   avx
[    2.247124] raid6: using avx2x2 recovery algorithm
[    2.263485] raid6: avx2x1   gen() 21316 MB/s
[    2.280483] raid6: avx2x2   gen() 28552 MB/s
[    2.297484] raid6: avx2x4   gen() 30858 MB/s
[    2.298056] raid6: using algorithm avx2x4 gen() 30858 MB/s
[    2.314485] raid6: .... xor() 14170 MB/s, rmw enabled
[    2.317646] async_tx: api initialized (async)
[    2.383117] load module synosnap failed, abort cbt reloading
[    2.384824] typec port1: bound usb1-port5 (ops connector_ops)
[    2.384841] typec port1: bound usb4-port1 (ops connector_ops)
[    2.761349] Btrfs loaded, zoned=yes, fsverity=yes
[    2.782968] PM: Image not found (code -22)
[    3.489336] SGI XFS with ACLs, security attributes, realtime, scrub, repair, quota, no debug enabled
[    3.493426] XFS (nvme0n1p3): Mounting V5 Filesystem acabe8be-6dd5-4d04-a138-22fdf9a0b015
[    3.503384] XFS (nvme0n1p3): Ending clean mount
[    3.535852] Not activating Mandatory Access Control as /sbin/tomoyo-init does not exist.
[    3.626513] systemd[1]: Inserted module 'autofs4'
[    3.650609] systemd[1]: systemd 257.13-1~deb13u1 running in system mode (+PAM +AUDIT +SELINUX +APPARMOR +IMA +IPE +SMACK +SECCOMP +GCRYPT -GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP +LIBCRYPTSETUP_PLUGINS +LIBFDISK +PCRE2 +PWQUALITY +P11KIT +QRENCODE +TPM2 +BZIP2 +LZ4 +XZ +ZLIB +ZSTD +BPF_FRAMEWORK +BTF -XKBCOMMON -UTMP +SYSVINIT +LIBARCHIVE)
[    3.652750] systemd[1]: Detected architecture x86-64.
[    3.657356] systemd[1]: Hostname set to <t14>.
[    3.733520] systemd[1]: bpf-restrict-fs: Failed to load BPF object: No such process
[    3.755528] systemd-sysv-generator[372]: SysV service '/etc/init.d/uml-utilities' lacks a native systemd unit file, automatically generating a unit file for compatibility.
[    3.755928] systemd-sysv-generator[372]: Please update package to include a native systemd unit file.
[    3.756317] systemd-sysv-generator[372]: ! This compatibility logic is deprecated, expect removal soon. !
[    3.832456] systemd[1]: /etc/systemd/system/synology-active-backup-business-linux-service.service:6: PIDFile= references a path below legacy directory /var/run/, updating /var/run/synology-backupd.pid → /run/synology-backupd.pid; please update the unit file accordingly.
[    3.919633] systemd[1]: Queued start job for default target graphical.target.
[    3.927175] systemd[1]: Created slice machine.slice - Virtual Machine and Container Slice.
[    3.928582] systemd[1]: Created slice system-getty.slice - Slice /system/getty.
[    3.929985] systemd[1]: Created slice system-modprobe.slice - Slice /system/modprobe.
[    3.931085] systemd[1]: Created slice system-systemd\x2dfsck.slice - Slice /system/systemd-fsck.
[    3.932350] systemd[1]: Created slice system-xfs_scrub.slice - xfs_scrub background service slice.
[    3.933168] systemd[1]: Created slice user.slice - User and Session Slice.
[    3.934064] systemd[1]: Started systemd-ask-password-wall.path - Forward Password Requests to Wall Directory Watch.
[    3.934800] systemd[1]: Set up automount proc-sys-fs-binfmt_misc.automount - Arbitrary Executable File Formats File System Automount Point.
[    3.935831] systemd[1]: Expecting device dev-disk-by\x2dlabel-boot.device - /dev/disk/by-label/boot...
[    3.936971] systemd[1]: Expecting device dev-disk-by\x2dpartuuid-942cfd1f\x2d5513\x2d4bfb\x2d9850\x2dae56cf0e0eb4.device - /dev/disk/by-partuuid/942cfd1f-5513-4bfb-9850-ae56cf0e0eb4...
[    3.938168] systemd[1]: Expecting device dev-disk-by\x2duuid-45595b04\x2d0bed\x2d47c6\x2d9a8d\x2d7cad4e58007d.device - /dev/disk/by-uuid/45595b04-0bed-47c6-9a8d-7cad4e58007d...
[    3.939398] systemd[1]: Reached target integritysetup.target - Local Integrity Protected Volumes.
[    3.940661] systemd[1]: Reached target nss-user-lookup.target - User and Group Name Lookups.
[    3.941909] systemd[1]: Reached target slices.target - Slice Units.
[    3.943199] systemd[1]: Reached target veritysetup.target - Local Verity Protected Volumes.
[    3.944453] systemd[1]: Reached target virt-guest-shutdown.target - libvirt guests shutdown target.
[    3.945803] systemd[1]: Listening on dm-event.socket - Device-mapper event daemon FIFOs.
[    3.947125] systemd[1]: Listening on lvm2-lvmpolld.socket - LVM2 poll daemon socket.
[    3.949758] systemd[1]: Listening on systemd-creds.socket - Credential Encryption/Decryption.
[    3.951083] systemd[1]: Listening on systemd-initctl.socket - initctl Compatibility Named Pipe.
[    3.952435] systemd[1]: Listening on systemd-journald-dev-log.socket - Journal Socket (/dev/log).
[    3.953759] systemd[1]: Listening on systemd-journald.socket - Journal Sockets.
[    3.955004] systemd[1]: systemd-pcrextend.socket - TPM PCR Measurements skipped, unmet condition check ConditionSecurity=measured-uki
[    3.955018] systemd[1]: systemd-pcrlock.socket - Make TPM PCR Policy skipped, unmet condition check ConditionSecurity=measured-uki
[    3.955092] systemd[1]: Listening on systemd-udevd-control.socket - udev Control Socket.
[    3.957528] systemd[1]: Listening on systemd-udevd-kernel.socket - udev Kernel Socket.
[    3.959687] systemd[1]: Mounting dev-hugepages.mount - Huge Pages File System...
[    3.961192] systemd[1]: Mounting dev-mqueue.mount - POSIX Message Queue File System...
[    3.963037] systemd[1]: Mounting run-lock.mount - Legacy Locks Directory /run/lock...
[    3.964890] systemd[1]: Mounting sys-kernel-debug.mount - Kernel Debug File System...
[    3.973272] systemd[1]: Mounting sys-kernel-tracing.mount - Kernel Trace File System...
[    3.975813] systemd[1]: Starting keyboard-setup.service - Set the console keyboard layout...
[    3.977321] systemd[1]: Starting kmod-static-nodes.service - Create List of Static Device Nodes...
[    3.979019] systemd[1]: Starting lvm2-monitor.service - Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling...
[    3.980842] systemd[1]: Starting modprobe@configfs.service - Load Kernel Module configfs...
[    3.983057] systemd[1]: Starting modprobe@drm.service - Load Kernel Module drm...
[    3.984905] systemd[1]: Starting modprobe@efi_pstore.service - Load Kernel Module efi_pstore...
[    3.986871] systemd[1]: Starting modprobe@fuse.service - Load Kernel Module fuse...
[    3.989450] systemd[1]: Starting modprobe@nvme_fabrics.service - Load Kernel Module nvme_fabrics...
[    3.990696] systemd[1]: systemd-hibernate-clear.service - Clear Stale Hibernate Storage Info skipped, unmet condition check ConditionPathExists=/sys/firmware/efi/efivars/HibernateLocation-8cf2644b-4b0b-428f-9387-6d876050dc67
[    3.992871] systemd[1]: Starting systemd-journald.service - Journal Service...
[    3.995397] systemd[1]: Starting systemd-modules-load.service - Load Kernel Modules...
[    3.996258] systemd[1]: systemd-pcrmachine.service - TPM PCR Machine ID Measurement skipped, unmet condition check ConditionSecurity=measured-uki
[    3.997397] systemd[1]: Starting systemd-remount-fs.service - Remount Root and Kernel File Systems...
[    3.998705] systemd[1]: systemd-tpm2-setup-early.service - Early TPM SRK Setup skipped, unmet condition check ConditionSecurity=measured-uki
[    3.998766] pstore: Using crash dump compression: deflate
[    4.001844] systemd[1]: Starting systemd-udev-load-credentials.service - Load udev Rules from Credentials...
[    4.023713] systemd[1]: Starting systemd-udev-trigger.service - Coldplug All udev Devices...
[    4.025057] pstore: Registered efi_pstore as persistent store backend
[    4.028776] systemd[1]: Mounted dev-hugepages.mount - Huge Pages File System.
[    4.029601] systemd[1]: Mounted dev-mqueue.mount - POSIX Message Queue File System.
[    4.030270] systemd[1]: Mounted run-lock.mount - Legacy Locks Directory /run/lock.
[    4.032155] systemd[1]: Mounted sys-kernel-debug.mount - Kernel Debug File System.
[    4.033252] systemd[1]: Mounted sys-kernel-tracing.mount - Kernel Trace File System.
[    4.035722] systemd[1]: Finished kmod-static-nodes.service - Create List of Static Device Nodes.
[    4.036922] systemd[1]: modprobe@configfs.service: Deactivated successfully.
[    4.037121] systemd[1]: Finished modprobe@configfs.service - Load Kernel Module configfs.
[    4.038593] systemd[1]: modprobe@drm.service: Deactivated successfully.
[    4.038780] systemd[1]: Finished modprobe@drm.service - Load Kernel Module drm.
[    4.040274] systemd[1]: modprobe@efi_pstore.service: Deactivated successfully.
[    4.040461] systemd[1]: Finished modprobe@efi_pstore.service - Load Kernel Module efi_pstore.
[    4.041816] systemd[1]: modprobe@fuse.service: Deactivated successfully.
[    4.042003] systemd[1]: Finished modprobe@fuse.service - Load Kernel Module fuse.
[    4.043066] systemd-journald[394]: Collecting audit messages is disabled.
[    4.044230] systemd[1]: modprobe@nvme_fabrics.service: Deactivated successfully.
[    4.044403] systemd[1]: Finished modprobe@nvme_fabrics.service - Load Kernel Module nvme_fabrics.
[    4.045847] systemd[1]: Finished systemd-remount-fs.service - Remount Root and Kernel File Systems.
[    4.047028] systemd[1]: Finished systemd-udev-load-credentials.service - Load udev Rules from Credentials.
[    4.048434] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is disabled. Duplicate IMA measurements will not be recorded in the IMA log.
[    4.048491] device-mapper: uevent: version 1.0.3
[    4.048581] device-mapper: ioctl: 4.50.0-ioctl (2025-04-28) initialised: dm-devel@lists.linux.dev
[    4.049372] systemd[1]: Mounting sys-fs-fuse-connections.mount - FUSE Control File System...
[    4.051916] systemd[1]: Mounting sys-kernel-config.mount - Kernel Configuration File System...
[    4.053025] lp: driver loaded but no devices found
[    4.054039] systemd[1]: systemd-hwdb-update.service - Rebuild Hardware Database skipped, unmet condition check ConditionNeedsUpdate=/etc
[    4.054096] systemd[1]: systemd-pstore.service - Platform Persistent Storage Archival skipped, unmet condition check ConditionDirectoryNotEmpty=/sys/fs/pstore
[    4.055109] systemd[1]: Starting systemd-random-seed.service - Load/Save OS Random Seed...
[    4.060212] ppdev: user-space parallel port driver
[    4.067671] systemd[1]: Starting systemd-tmpfiles-setup-dev-early.service - Create Static Device Nodes in /dev gracefully...
[    4.068547] systemd[1]: systemd-tpm2-setup.service - TPM SRK Setup skipped, unmet condition check ConditionSecurity=measured-uki
[    4.069374] systemd[1]: Mounted sys-fs-fuse-connections.mount - FUSE Control File System.
[    4.070737] systemd[1]: Mounted sys-kernel-config.mount - Kernel Configuration File System.
[    4.073402] systemd[1]: Finished systemd-random-seed.service - Load/Save OS Random Seed.
[    4.075553] systemd[1]: Finished lvm2-monitor.service - Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling.
[    4.078023] systemd[1]: Finished keyboard-setup.service - Set the console keyboard layout.
[    4.081069] systemd[1]: Finished systemd-modules-load.service - Load Kernel Modules.
[    4.082686] systemd[1]: Starting systemd-sysctl.service - Apply Kernel Variables...
[    4.093817] systemd[1]: Finished systemd-tmpfiles-setup-dev-early.service - Create Static Device Nodes in /dev gracefully.
[    4.094379] systemd[1]: systemd-sysusers.service - Create System Users skipped, no trigger condition checks were met.
[    4.095746] systemd[1]: Starting systemd-timesyncd.service - Network Time Synchronization...
[    4.097227] systemd[1]: Starting systemd-tmpfiles-setup-dev.service - Create Static Device Nodes in /dev...
[    4.101936] systemd[1]: Finished systemd-sysctl.service - Apply Kernel Variables.
[    4.108206] systemd[1]: Finished systemd-tmpfiles-setup-dev.service - Create Static Device Nodes in /dev.
[    4.110394] systemd[1]: Starting systemd-udevd.service - Rule-based Manager for Device Events and Files...
[    4.121077] systemd[1]: Started systemd-journald.service - Journal Service.
[    4.148264] systemd-journald[394]: Received client request to flush runtime journal.
[    4.283840] intel_pch_thermal 0000:00:12.0: enabling device (0000 -> 0002)
[    4.295584] input: Sleep Button as /devices/platform/PNP0C0E:00/input/input12
[    4.303789] ACPI: button: Sleep Button [SLPB]
[    4.312243] input: Lid Switch as /devices/platform/PNP0C0D:00/input/input13
[    4.317792] ACPI: button: Lid Switch [LID]
[    4.323396] input: Power Button as /devices/platform/LNXPWRBN:00/input/input14
[    4.329212] ACPI: button: Power Button [PWRF]
[    4.341395] ACPI: AC: AC Adapter [AC] (on-line)
[    4.372793] mc: Linux media interface: v0.10
[    4.373197] Adding 25165820k swap on /dev/nvme0n1p2.  Priority:-1 extents:1 across:25165820k SS
[    4.389083] iwlwifi 0000:00:14.3: enabling device (0000 -> 0002)
[    4.390182] ACPI: battery: Slot [BAT0] (battery present)
[    4.415882] iwlwifi 0000:00:14.3: Detected crf-id 0x3617, cnv-id 0x20000302 wfpm id 0x80000000
[    4.416671] iwlwifi 0000:00:14.3: PCI dev 02f0/0070, rev=0x351, rfid=0x10a100
[    4.417413] iwlwifi 0000:00:14.3: Detected Intel(R) Wi-Fi 6 AX201 160MHz
[    4.419911] Non-volatile memory driver v1.3
[    4.427613] iwlwifi 0000:00:14.3: loaded firmware version 77.2753b721.0 QuZ-a0-hr-b0-77.ucode op_mode iwlmvm
[    4.430242] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[    4.432288] ee1004 0-0051: 512 byte EE1004-compliant SPD EEPROM, read-only
[    4.448909] videodev: Linux video capture interface: v2.00
[    4.451023] rmi4_smbus 0-002c: registering SMbus-connected sensor
[    4.462323] thinkpad_acpi: ThinkPad ACPI Extras v0.26
[    4.462768] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.463194] thinkpad_acpi: ThinkPad BIOS N2XET45W (1.35 ), EC N2XHT27W
[    4.464055] thinkpad_acpi: Lenovo ThinkPad T14 Gen 1, model 20S1S6D700
[    4.464150] input: PC Speaker as /devices/platform/pcspkr/input/input15
[    4.481084] thinkpad_acpi: radio switch found; radios are enabled
[    4.482268] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    4.483770] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    4.498986] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    4.511475] Bluetooth: Core ver 2.22
[    4.512189] NET: Registered PF_BLUETOOTH protocol family
[    4.512851] Bluetooth: HCI device and connection manager initialized
[    4.513546] Bluetooth: HCI socket layer initialized
[    4.514190] Bluetooth: L2CAP socket layer initialized
[    4.514196] Bluetooth: SCO socket layer initialized
[    4.526797] resource: resource sanity check: requesting [mem 0x00000000fed10000-0x00000000fed15fff], which spans more than PNP0C02:03 [mem 0xfed10000-0xfed13fff]
[    4.527481] caller snb_uncore_imc_init_box+0x86/0xe0 [intel_uncore] mapping multiple BARs
[    4.541616] thinkpad_acpi: battery 1 registered (start 0, stop 100, behaviours: 0xb)
[    4.542198] ACPI: battery: new hook: ThinkPad Battery Extension
[    4.555306] proc_thermal 0000:00:04.0: enabling device (0000 -> 0002)
[    4.562967] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360 ms ovfl timer
[    4.562971] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    4.562972] RAPL PMU: hw unit of domain package 2^-14 Joules
[    4.562973] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    4.562974] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    4.562975] RAPL PMU: hw unit of domain psys 2^-14 Joules
[    4.566621] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input16
[    4.573058] intel_rapl_common: Found RAPL domain package
[    4.573061] intel_rapl_common: Found RAPL domain dram
[    4.581077] rmi4_f01 rmi4-00.fn01: found RMI device, manufacturer: Synaptics, product: TM3471-020, fw id: 3972349
[    4.587908] usbcore: registered new interface driver btusb
[    4.588832] Bluetooth: hci0: Bootloader revision 0.4 build 0 week 30 2018
[    4.589837] Bluetooth: hci0: Device revision is 2
[    4.589839] Bluetooth: hci0: Secure boot is enabled
[    4.589839] Bluetooth: hci0: OTP lock is enabled
[    4.589840] Bluetooth: hci0: API lock is enabled
[    4.589840] Bluetooth: hci0: Debug lock is disabled
[    4.589841] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
[    4.592010] rmi_read_register_desc: starting read at addr 0x0054
[    4.593382] rmi_read_register_desc: size_presence_reg = 4
[    4.596851] Bluetooth: hci0: Found device firmware: intel/ibt-19-0-4.sfi
[    4.596961] Bluetooth: hci0: Boot Address: 0x24800
[    4.596963] Bluetooth: hci0: Firmware Version: 132-3.24
[    4.596999] rmi_read_register_desc: presence reg: 2b ff 27 00
[    4.597001] rmi_read_register_desc: advanced addr to 0x0059 (after skipping presence reg)
[    4.597002] rmi_read_register_desc: struct_size = 43
[    4.597004] rmi_read_register_desc: num_registers = 12
[    4.597006] rmi_read_register_desc: reading struct_buf from addr 0x0059, size 43
[    4.612001] rmi_struct: 00000000: 0f 1f 14 87 12 13 2f 19 c9 03 07 83 02 43 80 1f
[    4.612005] rmi_struct: 00000010: 01 02 04 05 03 07 01 01 04 01 06 0e 36 82 00 00
[    4.612006] rmi_struct: 00000020: 00 00 00 00 00 00 00 00 00 00 00
[    4.612008] rmi_read_register_desc: parsed item 0: reg: 0 reg size: 15 subpackets: 5
[    4.612010] rmi_read_register_desc: parsed item 1: reg: 1 reg size: 20 subpackets: 5
[    4.612011] rmi_read_register_desc: parsed item 2: reg: 2 reg size: 19 subpackets: 5
[    4.612013] rmi_read_register_desc: parsed item 3: reg: 3 reg size: 25 subpackets: 5
[    4.612014] rmi_read_register_desc: parsed item 4: reg: 4 reg size: 7 subpackets: 3
[    4.612016] rmi_read_register_desc: parsed item 5: reg: 5 reg size: 67 subpackets: 5
[    4.612017] rmi_read_register_desc: parsed item 6: reg: 6 reg size: 1 subpackets: 1
[    4.612019] rmi_read_register_desc: parsed item 7: reg: 7 reg size: 4 subpackets: 2
[    4.612020] rmi_read_register_desc: parsed item 8: reg: 8 reg size: 3 subpackets: 3
[    4.612022] rmi_read_register_desc: parsed item 9: reg: 9 reg size: 1 subpackets: 1
[    4.612023] rmi_read_register_desc: parsed item 10: reg: 10 reg size: 4 subpackets: 1
[    4.612025] rmi_read_register_desc: parsed item 11: reg: 13 reg size: 6 subpackets: 3
[    4.612026] rmi_read_register_desc: starting read at addr 0x0057
[    4.612959] uvcvideo 1-8:1.0: Found UVC 1.00 device Integrated Camera (04ca:7070)
[    4.615098] rmi_read_register_desc: size_presence_reg = 12
[    4.644133] mei_hdcp 0000:00:16.0-b638ab7e-94e2-4ea2-a552-d1c54b627f04: bound 0000:00:02.0 (ops i915_hdcp_ops [i915])
[    4.647549] alg: skcipher: skipping comparison tests for xctr-aes-aesni-avx because xctr(aes-lib) is unavailable
[    4.648550] rmi_read_register_desc: presence reg: 1a 00 8f d8 10 00 00 00 01 00 00 00
[    4.648676] iwlwifi 0000:00:14.3: Detected RF HR B3, rfid=0x10a100
[    4.649043] rmi_read_register_desc: advanced addr to 0x0064 (after skipping presence reg)
[    4.649293] usbcore: registered new interface driver uvcvideo
[    4.653182] rmi_read_register_desc: struct_size = 26
[    4.653185] rmi_read_register_desc: num_registers = 11
[    4.653187] rmi_read_register_desc: reading struct_buf from addr 0x0064, size 26
[    4.657334] rmi_struct: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    4.657338] rmi_struct: 00000010: 00 00 00 00 00 00 00 00 00 00
[    4.657340] rmi_read_register_desc: parsed item 0: reg: 8 reg size: 0 subpackets: 0
[    4.657342] rmi_read_register_desc: parsed item 1: reg: 9 reg size: 0 subpackets: 0
[    4.657343] rmi_read_register_desc: parsed item 2: reg: 10 reg size: 0 subpackets: 0
[    4.657345] rmi_parse_register_desc_item: error: size - offset < 2 (2 - 1 < 2)
[    4.657348] rmi4_f12 rmi4-00.fn12: Failed to read the Control Register Descriptor: -5
[    4.657351] rmi4_f12 rmi4-00.fn12: probe with driver rmi4_f12 failed with error -5
[    4.711325] input: Synaptics TM3471-020 as /devices/pci0000:00/0000:00:1f.4/i2c-0/0-002c/rmi4-00/input/input17
[    4.717767] iwlwifi 0000:00:14.3: base HW address: 40:1c:83:ca:fa:8a
[    4.718914] serio: RMI4 PS/2 pass-through port at rmi4-00.fn03
[    4.771194] iwlwifi 0000:00:14.3 wlp0s20f3: renamed from wlan0
[    4.837386] snd_hda_intel 0000:00:1f.3: enabling device (0004 -> 0006)
[    4.838552] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops intel_audio_component_bind_ops [i915])
[    4.852045] psmouse serio2: trackpoint: Elan TrackPoint firmware: 0x11, buttons: 3/3
[    4.860752] intel_pmc_core intel_pmc_core.0:  initialized
[    4.876139] intel_rapl_common: Found RAPL domain package
[    4.876808] intel_rapl_common: Found RAPL domain core
[    4.877279] intel_rapl_common: Found RAPL domain uncore
[    4.877749] intel_rapl_common: Found RAPL domain dram
[    4.878193] intel_rapl_common: Found RAPL domain psys
[    4.888947] input: TPPS/2 Elan TrackPoint as /devices/pci0000:00/0000:00:1f.4/i2c-0/0-002c/rmi4-00/rmi4-00.fn03/serio2/input/input18
[    4.891762] snd_hda_codec_alc269 hdaudioC0D0: ALC257: picked fixup  for PCI SSID 17aa:0000
[    4.892508] snd_hda_codec_alc269 hdaudioC0D0: autoconfig for ALC257: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    4.892510] snd_hda_codec_alc269 hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.892511] snd_hda_codec_alc269 hdaudioC0D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[    4.892512] snd_hda_codec_alc269 hdaudioC0D0:    mono: mono_out=0x0
[    4.892513] snd_hda_codec_alc269 hdaudioC0D0:    inputs:
[    4.892514] snd_hda_codec_alc269 hdaudioC0D0:      Mic=0x19
[    4.946186] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.3/sound/card0/input19
[    4.947633] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input20
[    4.947704] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input21
[    4.947763] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input22
[    4.947835] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input23
[    4.948003] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input24
[    5.039175] XFS (nvme0n1p4): Mounting V5 Filesystem 900b5e70-35d0-4fdc-9f3f-a87f11b47fa9
[    5.044692] XFS (nvme0n1p4): Ending clean mount
[    5.111917] audit: type=1400 audit(1782504670.896:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="buildah" pid=800 comm="apparmor_parser"
[    5.113671] audit: type=1400 audit(1782504670.896:3): apparmor="STATUS" operation="profile_load" profile="unconfined" name="Discord" pid=793 comm="apparmor_parser"
[    5.115571] audit: type=1400 audit(1782504670.896:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="brave" pid=799 comm="apparmor_parser"
[    5.115574] audit: type=1400 audit(1782504670.896:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="balena-etcher" pid=798 comm="apparmor_parser"
[    5.115576] audit: type=1400 audit(1782504670.896:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="1password" pid=792 comm="apparmor_parser"
[    5.115577] audit: type=1400 audit(1782504670.896:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name=4D6F6E676F444220436F6D70617373 pid=795 comm="apparmor_parser"
[    5.115580] audit: type=1400 audit(1782504670.898:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="QtWebEngineProcess" pid=796 comm="apparmor_parser"
[    5.115581] audit: type=1400 audit(1782504670.899:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="ch-checkns" pid=805 comm="apparmor_parser"
[    5.115583] audit: type=1400 audit(1782504670.899:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="cam" pid=804 comm="apparmor_parser"
[    5.202800] kauditd_printk_skb: 115 callbacks suppressed
[    5.202803] audit: type=1400 audit(1782504670.987:126): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/papers" pid=888 comm="apparmor_parser"
[    5.205354] audit: type=1400 audit(1782504670.987:127): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/papers//sanitized_helper" pid=888 comm="apparmor_parser"
[    5.205357] audit: type=1400 audit(1782504670.987:128): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/papers//snap_browsers" pid=888 comm="apparmor_parser"
[    5.205358] audit: type=1400 audit(1782504670.987:129): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/papers-previewer" pid=888 comm="apparmor_parser"
[    5.205360] audit: type=1400 audit(1782504670.987:130): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/papers-previewer//sanitized_helper" pid=888 comm="apparmor_parser"
[    5.205362] audit: type=1400 audit(1782504670.987:131): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/papers-thumbnailer" pid=888 comm="apparmor_parser"
[    5.215774] audit: type=1400 audit(1782504671.000:132): apparmor="STATUS" operation="profile_load" profile="unconfined" name="libreoffice-soffice" pid=893 comm="apparmor_parser"
[    5.215777] audit: type=1400 audit(1782504671.000:133): apparmor="STATUS" operation="profile_load" profile="unconfined" name="libreoffice-soffice//gpg" pid=893 comm="apparmor_parser"
[    5.221647] audit: type=1400 audit(1782504671.006:134): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/evince" pid=886 comm="apparmor_parser"
[    5.221650] audit: type=1400 audit(1782504671.006:135): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/evince//sanitized_helper" pid=886 comm="apparmor_parser"
[    5.408037] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.408675] Bluetooth: BNEP filters: protocol multicast
[    5.409281] Bluetooth: BNEP socket layer initialized
[    5.486683] block nvme0n1: No UUID available providing old NGUID
[    5.558146] NET: Registered PF_QIPCRTR protocol family
[    6.300224] Bluetooth: hci0: Waiting for firmware download to complete
[    6.301809] Bluetooth: hci0: Firmware loaded in 1664994 usecs
[    6.301840] Bluetooth: hci0: Waiting for device to boot
[    6.316023] Bluetooth: hci0: Device booted in 13862 usecs
[    6.317816] Bluetooth: hci0: Found Intel DDC parameters: intel/ibt-19-0-4.ddc
[    6.319977] Bluetooth: hci0: Applying Intel DDC parameters completed
[    6.320877] Bluetooth: hci0: Firmware revision 0.4 build 132 week 3 2024
[    6.324006] Bluetooth: hci0: HCI LE Coded PHY feature bit is set, but its usage is not supported.
[    6.389690] Bluetooth: MGMT ver 1.23
[    6.415900] NET: Registered PF_ALG protocol family
[    6.489360] Bluetooth: RFCOMM TTY layer initialized
[    6.490317] Bluetooth: RFCOMM socket layer initialized
[    6.490856] Bluetooth: RFCOMM ver 1.11
[    9.259257] e1000e 0000:00:1f.6 enp0s31f6: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   11.331382] rfkill: input handler disabled
[   23.047109] rfkill: input handler enabled
[   24.176902] rfkill: input handler disabled
[   25.743455] SCSI subsystem initialized

-- 
-Barry K. Nathan  <barryn@pobox.com>
