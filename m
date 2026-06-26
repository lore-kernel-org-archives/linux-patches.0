Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552F03AFAEF
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 22:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782512604; cv=none; b=e1SNVIB7CicPN2DFaH7AMEG6KqTd8LKvUtrrQbdQAOI7RIfadoQTmmmrJM6zZ68/m0IVXuxquwMwpfxktdlVNR6JVnMXPTv/iAGc/drF9MXj66m8ZVoMdr/ctenFzGSHHX+EjZY9uwDyMYjjzlCqQHmp+j2XTHaHJOVydPVXAOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782512604; c=relaxed/simple;
	bh=yc0EIB0nqxXoZufK4Pekkq+clLF+5HPsnhEXHeiYvxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cOEEOOiM4NJtORuCIn/Q6QFeh67HgnEMxAbV6GW4jHb+or4EyaLQKmXnN9UJKiQD8Fjt+frIgxxIvXLSslRXmBrImMOpx7VxxkYWi6P71+RxGtuj64X/8iLA6EZq2zHzZBZoZ2Y8NkVNvUCwTwqRL38pMSAi3Hs8YhAg7WGLxP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=nYfJSW7d; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=K9qxegME; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="nYfJSW7d";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="K9qxegME"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 2A72F1D0002A;
	Fri, 26 Jun 2026 18:23:17 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-01.internal (MEProxy); Fri, 26 Jun 2026 18:23:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1782512597;
	 x=1782598997; bh=8cvHaAiGdDgg0cZ2GQWq338UWq+er7V/yeFltNGDww4=; b=
	nYfJSW7dGpYD1JLbqlLIZ3gyzo3iBJw9dGMJRWEtFhaAYAgggpSZkcMTwbX5vTOk
	EVd3u0gdDRp/pdfc5Bew3jFbNWMCjQEDbBqqLgjceifCg8FHiAx6osufq1+Lz93D
	LVbePUTj6EgfvEQv5MFNRXPNg6sgoM8Gz9Q6R8Mr2LSuEdTnku5frY35AqdmSZ4a
	yx2inyi1A2C8Aqn1eaGm23XlU+i2Q72GOSK5gt1Nq91zaZf96Bd1kn2wnE2Ywq7+
	BsJvkiZd+bw1h4wovffrT5NSIStr5kkP0a20/yfKnrwFFKtikowIX0aZ358DKk5u
	9K+ysNwDV6iwhkzZaNg2Pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782512597; x=
	1782598997; bh=8cvHaAiGdDgg0cZ2GQWq338UWq+er7V/yeFltNGDww4=; b=K
	9qxegMEnKaR3pfwp9ISTK/NTi7e+SCAHQpd2b3bsWxu7DlEcENL39AdLazVNEiPR
	5o8EZVeD4Qt8AGN7/q2/+M+Eo6d00tUJGtgE7uZJyXinBsnylQgRXxAD3PpEJOGO
	2seX6k4MXPp72rOOQiSFMjsxpv1Cx9z4M9L/bJgzOMg5feRWRRbpB8siklTLdsHO
	DIHIlUpGyqVrNWTI85aBLoxwtXUk7FLFTcyDHjtaYr8RPxpS50joOB5fO4OCwxX2
	9X4Piv+KvGYnpI0mN8WhLdsznXjnUxcg0QsfyYbwQZYpZVczdyfXr5btvcteI7+/
	JPTeY/8EKcgeh1t+UE+QA==
X-ME-Sender: <xms:0_s-aqI_KSY7DYLk6Z2NzVHAzFNGQ7O9DrZ1-NJcImRGZlSghrbZMA>
    <xme:0_s-aihYIj5AqTeH_tJOcMsHH7rE6b-34xIGv_SiM6kC4RXtNLlblpgu9DZJjiJcg
    d7MgQFjNRboEnAG4rAfs31X3-FwgvVBbvSRbOYsVZP4IdAfphpc>
X-ME-Received: <xmr:0_s-ar2GbcPiigYLnBAWwMsXMIRpQkZK7GRKv6Hc8RGDtAiqes0VUFw6-OglRnoY-J075-rXZo13RijD7VIEUQVfE-WODVnc>
X-ME-Proxy-Cause: dmFkZTFs3PeKzifZl5Z36KUHgKVuZh1Pkka6VksxlTNrpGXAcsiuDWfOYFYWc+oRnOZEUA
    jwSkqCmqmuaQWjbjWhXl0S01+z+Vkaf3lyL4es3s5k7Gw8ZFkVzS8Dj7MlzxK7VMqoC8WJ
    GUwS2yRq5tAo7x1sPgAJmtp+eKN0denikAARBGBtZcp6moIEcz3Kc0GoKqXsrKg1tCkOcA
    YX59WZVJihbpsEultui7/Ges0OKFXe+ESA3u+Shyl4sjQ3K8in+jP5doYY5jHBni7YXRtO
    i6dprFuOofo/C+P/OAmK0ma5H14Jj6leMej+uADImghmCx9YxoXulnjlDSRQsvhbWw1CGJ
    za1CReWdqqX40E5OQtieHh4fgshc6dgMNiy7CLtQ2ziZ0JxB++Z4F4V9sPWI6NWIXS7++a
    XdtpYEHAVtUPad+v9P8Ew2zYudWfPYEUkQ2cQwFATvLqMt/T4xrSRmvX2jwUoJfCcGHyq3
    o1j7gTNHu+da5KKrwyygYT4VIHnduA/+z6k4x5mgD88xC4PlIqvse8gOP2kXLGtwJjODow
    763JZ4ACcF94Bhl0sEfaPTMf1uPqcN9/pKm844j2XImllxdtecmZOb/+JobzBjr6IwDg1U
    uZbCPyIbIzzJX7PRpTd6Eymp8F9vq0e4/PUyvTTf6V4GjsMhgiLVupdxN3tw
X-ME-Proxy: <xmx:0_s-arbdvVZp9SNGAhuYGufw986K5AigmzVhV9LwhlIb0gCjEZ94XA>
    <xmx:0_s-agjv_1ZvYop8swRWPWvqnVmIKph7SUM7A0n83g-WGtNuMgSesg>
    <xmx:0_s-ajie1fElhzaV0qXYNm7s2XilwqZ2bXUDSH1Xyw7AuxqOV9CJWQ>
    <xmx:0_s-alBL4JX_QT8ySIkSj1CRg6DbG8nLQzg0V9HaVQV333L35NltYg>
    <xmx:1fs-atCXxrNZ1y4_u73pq1dDY3BJFS5DAbw0BTWXg8UY1aPyLKl_TDjx>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 26 Jun 2026 18:23:13 -0400 (EDT)
Message-ID: <626fc564-6f4b-430d-92f3-653981e3dcdd@pobox.com>
Date: Fri, 26 Jun 2026 15:23:12 -0700
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
 <ab7df7bf-1b30-40c0-9463-a469abfa2bda@pobox.com>
 <aj7r1Eqt2SEnWsMZ@google.com>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <aj7r1Eqt2SEnWsMZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/26/26 2:17 PM, Dmitry Torokhov wrote:
> On Fri, Jun 26, 2026 at 01:41:38PM -0700, Barry K. Nathan wrote:
>> On 6/26/26 12:56 PM, Dmitry Torokhov wrote:
>>> Hi Barry,
>>>
>>> On Fri, Jun 26, 2026 at 10:56:21AM -0700, Barry K. Nathan wrote:
>>>> (cc Dmitry Torokhov because this is related to two of your commits)
>>>>
>>>> On 6/25/26 6:03 AM, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 7.1.2 release.
>>>>> There are 21 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
>>>>> or in the git tree and branch at:
>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>
>>>> Unfortunately, 7.1.2-rc1 breaks the Synaptics touchpad on my Lenovo
>>>> ThinkPad T14 Gen 1 -- the pointer no longer moves when I touch the
>>>> touchpad. Potentially relevant line from dmesg:
>>>>
>>>> rmi4_f01 rmi4-00.fn01: found RMI device, manufacturer: Synaptics, product: TM3471-020, fw id: 3972349
>>>>
>>>>> Dmitry Torokhov<dmitry.torokhov@gmail.com>
>>>>>        Input: rmi4 - refactor register descriptor parsing
>>>>>
>>>>> Dmitry Torokhov<dmitry.torokhov@gmail.com>
>>>>>        Input: rmi4 - fix register descriptor address calculation
>>>>>> Both of these patches seem bad in my testing. Either one, individually,
>>>> causes the pointer to no longer move when I touch the touchpad. If I
>>>> revert both of them, then my touchpad works again.
>>>>
>>>> I have not yet tested 7.0.14-rc1 or 6.18.37-rc1. However, the problem
>>>> also reproduces on current mainline as of this writing (commit
>>>> 51cb1aa1250c36269474b8b6ca6b6319e170f5a5).
>>> Could you please try applying this debug patch and send me dmesg?
>> Sure, I applied the patch on top of mainline, and the dmesg output is
>> below.
> Thank you! So I messed up and "Input: rmi4 - fix register descriptor
> address calculation" is totally wrong.
> 
> Can you please revert it (keeping the debug patch) and try booting again
> and if the touchpad still does not work post the dmesg again.
> 
> Thanks!

I did the revert, while keeping the debug patch. With this kernel, the
touchpad still doesn't work for me, so here's the new dmesg.

[    0.000000] Linux version 7.1.0-t14test202606+ (barryn@debian12vm2) (x86_64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44) #3 SMP PREEMPT_DYNAMIC Fri Jun 26 15:04:56 PDT 2026
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
[    0.000026] e820: update [mem 0x00000000-0x00000fff] System RAM ==> device reserved
[    0.000031] e820: remove [mem 0x000a0000-0x000fffff] System RAM
[    0.000042] last_pfn = 0x84c800 max_arch_pfn = 0x400000000
[    0.000049] MTRR map: 5 entries (3 fixed + 2 variable; max 23), built from 10 variable MTRRs
[    0.000053] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.000632] last_pfn = 0xa9750 max_arch_pfn = 0x400000000
[    0.014135] esrt: Reserving ESRT space from 0x00000000a4b3a000 to 0x00000000a4b3a0d8.
[    0.014151] Using GB pages for direct mapping
[    0.014503] Secure boot disabled
[    0.014504] RAMDISK: [mem 0x76bdb000-0x79b18fff]
[    0.014578] ACPI: Early table checksum verification disabled
[    0.014582] ACPI: RSDP 0x00000000A974E014 000024 (v02 LENOVO)
[    0.014589] ACPI: XSDT 0x00000000A974C188 00010C (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014598] ACPI: FACP 0x00000000A6560000 000114 (v06 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014606] ACPI: DSDT 0x00000000A652F000 02C5BD (v02 LENOVO CML      20170001 INTL 20160422)
[    0.014611] ACPI: FACS 0x00000000A947B000 000040
[    0.014615] ACPI: SSDT 0x00000000A65BC000 0020AE (v02 LENOVO CpuSsdt  00003000 INTL 20160527)
[    0.014620] ACPI: SSDT 0x00000000A65BB000 0005A1 (v02 LENOVO CtdpB    00001000 INTL 20160527)
[    0.014625] ACPI: SSDT 0x00000000A657E000 003532 (v02 LENOVO DptfTabl 00001000 INTL 20160527)
[    0.014630] ACPI: SSDT 0x00000000A6568000 00331E (v02 LENOVO SaSsdt   00003000 INTL 20160527)
[    0.014635] ACPI: SSDT 0x00000000A6567000 00060E (v02 LENOVO Tpm2Tabl 00001000 INTL 20160527)
[    0.014640] ACPI: TPM2 0x00000000A6566000 000034 (v04 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014644] ACPI: BOOT 0x00000000A6564000 000028 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014649] ACPI: HPET 0x00000000A655F000 000038 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014654] ACPI: APIC 0x00000000A655E000 000164 (v04 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014659] ACPI: MCFG 0x00000000A655D000 00003C (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014663] ACPI: ECDT 0x00000000A655C000 000053 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014668] ACPI: SSDT 0x00000000A652D000 001F15 (v02 LENOVO WHL_Tbt_ 00001000 INTL 20160527)
[    0.014673] ACPI: SSDT 0x00000000A652C000 0000A6 (v02 LENOVO PID0Ssdt 00000010 INTL 20160527)
[    0.014678] ACPI: SSDT 0x00000000A6528000 003AD0 (v02 LENOVO ProjSsdt 00000010 INTL 20160527)
[    0.014682] ACPI: NHLT 0x00000000A6526000 00189E (v00 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014687] ACPI: MSDM 0x00000000A6525000 000055 (v03 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014692] ACPI: SSDT 0x00000000A6348000 000FCE (v02 LENOVO UsbCTabl 00001000 INTL 20160527)
[    0.014697] ACPI: LPIT 0x00000000A6347000 000094 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014701] ACPI: WSMT 0x00000000A6346000 000028 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014706] ACPI: SSDT 0x00000000A6343000 00281B (v02 LENOVO TbtTypeC 00000000 INTL 20160527)
[    0.014711] ACPI: DBGP 0x00000000A6342000 000034 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014716] ACPI: DBG2 0x00000000A6341000 000054 (v00 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014720] ACPI: BATB 0x00000000A6340000 00004A (v02 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014725] ACPI: DMAR 0x00000000A6563000 0000C8 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014730] ACPI: ASF! 0x00000000A4B38000 0000A0 (v32 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014735] ACPI: BGRT 0x00000000A4B37000 000038 (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014740] ACPI: UEFI 0x00000000A9430000 00012A (v01 LENOVO TP-N2X   00001350 PTEC 00000002)
[    0.014744] ACPI: FPDT 0x00000000A4B36000 000034 (v01 LENOVO TP-N2X   00001350 PTEC 00001350)
[    0.014748] ACPI: Reserving FACP table memory at [mem 0xa6560000-0xa6560113]
[    0.014751] ACPI: Reserving DSDT table memory at [mem 0xa652f000-0xa655b5bc]
[    0.014753] ACPI: Reserving FACS table memory at [mem 0xa947b000-0xa947b03f]
[    0.014754] ACPI: Reserving SSDT table memory at [mem 0xa65bc000-0xa65be0ad]
[    0.014756] ACPI: Reserving SSDT table memory at [mem 0xa65bb000-0xa65bb5a0]
[    0.014757] ACPI: Reserving SSDT table memory at [mem 0xa657e000-0xa6581531]
[    0.014759] ACPI: Reserving SSDT table memory at [mem 0xa6568000-0xa656b31d]
[    0.014760] ACPI: Reserving SSDT table memory at [mem 0xa6567000-0xa656760d]
[    0.014762] ACPI: Reserving TPM2 table memory at [mem 0xa6566000-0xa6566033]
[    0.014763] ACPI: Reserving BOOT table memory at [mem 0xa6564000-0xa6564027]
[    0.014765] ACPI: Reserving HPET table memory at [mem 0xa655f000-0xa655f037]
[    0.014766] ACPI: Reserving APIC table memory at [mem 0xa655e000-0xa655e163]
[    0.014768] ACPI: Reserving MCFG table memory at [mem 0xa655d000-0xa655d03b]
[    0.014769] ACPI: Reserving ECDT table memory at [mem 0xa655c000-0xa655c052]
[    0.014771] ACPI: Reserving SSDT table memory at [mem 0xa652d000-0xa652ef14]
[    0.014772] ACPI: Reserving SSDT table memory at [mem 0xa652c000-0xa652c0a5]
[    0.014774] ACPI: Reserving SSDT table memory at [mem 0xa6528000-0xa652bacf]
[    0.014775] ACPI: Reserving NHLT table memory at [mem 0xa6526000-0xa652789d]
[    0.014777] ACPI: Reserving MSDM table memory at [mem 0xa6525000-0xa6525054]
[    0.014778] ACPI: Reserving SSDT table memory at [mem 0xa6348000-0xa6348fcd]
[    0.014780] ACPI: Reserving LPIT table memory at [mem 0xa6347000-0xa6347093]
[    0.014781] ACPI: Reserving WSMT table memory at [mem 0xa6346000-0xa6346027]
[    0.014783] ACPI: Reserving SSDT table memory at [mem 0xa6343000-0xa634581a]
[    0.014784] ACPI: Reserving DBGP table memory at [mem 0xa6342000-0xa6342033]
[    0.014786] ACPI: Reserving DBG2 table memory at [mem 0xa6341000-0xa6341053]
[    0.014787] ACPI: Reserving BATB table memory at [mem 0xa6340000-0xa6340049]
[    0.014789] ACPI: Reserving DMAR table memory at [mem 0xa6563000-0xa65630c7]
[    0.014790] ACPI: Reserving ASF! table memory at [mem 0xa4b38000-0xa4b3809f]
[    0.014792] ACPI: Reserving BGRT table memory at [mem 0xa4b37000-0xa4b37037]
[    0.014793] ACPI: Reserving UEFI table memory at [mem 0xa9430000-0xa9430129]
[    0.014795] ACPI: Reserving FPDT table memory at [mem 0xa4b36000-0xa4b36033]
[    0.014974] No NUMA configuration found
[    0.014976] Faking a node at [mem 0x0000000000000000-0x000000084c7fffff]
[    0.014995] NODE_DATA(0) allocated [mem 0x84c7d5200-0x84c7fffff]
[    0.015470] Reserving Intel graphics memory at [mem 0xab800000-0xaf7fffff]
[    0.015751] ACPI: PM-Timer IO Port: 0x1808
[    0.015763] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.015766] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.015768] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.015769] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.015770] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.015772] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.015773] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.015775] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.015776] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
[    0.015777] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
[    0.015779] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
[    0.015780] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
[    0.015781] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
[    0.015783] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
[    0.015784] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
[    0.015785] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.015787] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.015788] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])
[    0.015790] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])
[    0.015791] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])
[    0.015833] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-119
[    0.015838] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.015841] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.015848] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.015850] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.015862] e820: update [mem 0xa0503000-0xa0593fff] System RAM ==> device reserved
[    0.015876] TSC deadline timer available
[    0.015881] CPU topo: Max. logical packages:   1
[    0.015883] CPU topo: Max. logical nodes:      1
[    0.015884] CPU topo: Num. nodes per package:  1
[    0.015889] CPU topo: Max. logical dies:       1
[    0.015890] CPU topo: Max. dies per package:   1
[    0.015899] CPU topo: Max. threads per core:   2
[    0.015900] CPU topo: Num. cores per package:     4
[    0.015901] CPU topo: Num. threads per package:   8
[    0.015902] CPU topo: Allowing 8 present CPUs plus 0 hotplug CPUs
[    0.015920] PM: hibernation: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.015924] PM: hibernation: Registered nosave memory: [mem 0x0009f000-0x000fffff]
[    0.015927] PM: hibernation: Registered nosave memory: [mem 0xa0503000-0xa0593fff]
[    0.015930] PM: hibernation: Registered nosave memory: [mem 0xa40b7000-0xa974efff]
[    0.015933] PM: hibernation: Registered nosave memory: [mem 0xa9750000-0xffffffff]
[    0.015935] [gap 0xaf800000-0xfed1ffff] available for PCI devices
[    0.015938] Booting paravirtualized kernel on bare hardware
[    0.015941] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.028895] Zone ranges:
[    0.028896]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.028900]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.028903]   Normal   [mem 0x0000000100000000-0x000000084c7fffff]
[    0.028906]   Device   empty
[    0.028908] Movable zone start for each node
[    0.028912] Early memory node ranges
[    0.028913]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.028915]   node   0: [mem 0x0000000000100000-0x00000000a40b6fff]
[    0.028918]   node   0: [mem 0x00000000a974f000-0x00000000a974ffff]
[    0.028920]   node   0: [mem 0x0000000100000000-0x000000084c7fffff]
[    0.028928] Initmem setup node 0 [mem 0x0000000000001000-0x000000084c7fffff]
[    0.028938] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.028976] On node 0, zone DMA: 97 pages in unavailable ranges
[    0.035495] On node 0, zone DMA32: 22168 pages in unavailable ranges
[    0.036222] On node 0, zone Normal: 26800 pages in unavailable ranges
[    0.036399] On node 0, zone Normal: 14336 pages in unavailable ranges
[    0.036411] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.037143] percpu: Embedded 82 pages/cpu s212992 r8192 d114688 u524288
[    0.037154] pcpu-alloc: s212992 r8192 d114688 u524288 alloc=1*2097152
[    0.037158] pcpu-alloc: [0] 0 1 2 3 [0] 4 5 6 7
[    0.037195] Kernel command line: BOOT_IMAGE=/vmlinuz-7.1.0-t14test202606+ root=UUID=acabe8be-6dd5-4d04-a138-22fdf9a0b015 ro preempt=full
[    0.038258] Dynamic Preempt: full
[    0.038305] printk: log buffer data + meta data: 131072 + 458752 = 589824 bytes
[    0.042550] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes, linear)
[    0.044680] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes, linear)
[    0.044862] software IO TLB: area num 8.
[    0.062067] Fallback order for Node 0: 0
[    0.062073] Built 1 zonelists, mobility grouping on.  Total pages: 8325206
[    0.062075] Policy zone: Normal
[    0.062087] mem auto-init: stack:all(zero), heap alloc:on, heap free:off
[    0.082370] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.098118] ftrace: allocating 50623 entries in 200 pages
[    0.098121] ftrace: allocated 200 pages with 3 groups
[    0.098393] rcu: Preemptible hierarchical RCU implementation.
[    0.098394] rcu: 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
[    0.098396] 	Trampoline variant of Tasks RCU enabled.
[    0.098397] 	Rude variant of Tasks RCU enabled.
[    0.098398] 	Tracing variant of Tasks RCU enabled.
[    0.098404] rcu: RCU calculated value of scheduler-enlistment delay is 100 jiffies.
[    0.098406] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.098429] RCU Tasks: Setting shift to 3 and lim to 1 rcu_task_cb_adjust=1 rcu_task_cpu_ids=8.
[    0.098433] RCU Tasks Rude: Setting shift to 3 and lim to 1 rcu_task_cb_adjust=1 rcu_task_cpu_ids=8.
[    0.110774] NR_IRQS: 524544, nr_irqs: 2048, preallocated irqs: 16
[    0.111134] rcu: srcu_init: Setting srcu_struct sizes based on contention.
[    0.111364] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.111488] Console: colour dummy device 80x25
[    0.111493] printk: legacy console [tty0] enabled
[    0.112211] ACPI: Core revision 20260408
[    0.112616] hpet: HPET dysfunctional in PC10. Force disabled.
[    0.112678] APIC: Switch to symmetric I/O mode setup
[    0.112684] DMAR: Host address width 39
[    0.112688] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.112704] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 19e2ff0505e
[    0.112714] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.112723] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c40660462 ecap f050da
[    0.112730] DMAR: RMRR base: 0x000000a81d0000 end: 0x000000a81effff
[    0.112737] DMAR: RMRR base: 0x000000ab000000 end: 0x000000af7fffff
[    0.112742] DMAR: RMRR base: 0x000000a8201000 end: 0x000000a8280fff
[    0.112748] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.112754] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.112759] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.115210] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.115217] x2apic enabled
[    0.115341] APIC: Switched APIC routing to: cluster x2apic
[    0.120902] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x1fb62f12e8c, max_idle_ns: 440795238402 ns
[    0.120915] Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.99 BogoMIPS (lpj=2199996)
[    0.120963] x86/cpu: SGX disabled or unsupported by BIOS.
[    0.120975] CPU0: Thermal monitoring enabled (TM1)
[    0.121068] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.121073] Last level dTLB entries: 4KB 64, 2MB 32, 4MB 32, 1GB 4
[    0.121092] process: using mwait in idle threads
[    0.121098] mitigations: Enabled attack vectors: user_kernel, user_user, guest_host, guest_guest, SMT mitigations: auto
[    0.121111] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
[    0.121118] SRBDS: Mitigation: Microcode
[    0.121124] Spectre V2 : Mitigation: Enhanced / Automatic IBRS
[    0.121129] RETBleed: Mitigation: Enhanced IBRS
[    0.121133] ITS: Mitigation: Aligned branch/return thunks
[    0.121138] MMIO Stale Data: Mitigation: Clear CPU buffers
[    0.121142] VMSCAPE: Mitigation: IBPB before exit to userspace
[    0.121146] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.121152] Spectre V2 : Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT
[    0.121159] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.121180] GDS: Mitigation: Microcode
[    0.121184] active return thunk: its_return_thunk
[    0.121193] Spectre V2 : Spectre BHI mitigation: SW BHB clearing on syscall and VM exit
[    0.121206] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.121213] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.121218] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.121222] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
[    0.121227] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.121232] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.121238] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.121243] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.121247] x86/fpu: Enabled xstate features 0x1f, context size is 960 bytes, using 'compacted' format.
[    0.121912] pid_max: default: 32768 minimum: 301
[    0.121912] landlock: Up and running.
[    0.121912] Yama: becoming mindful.
[    0.121912] AppArmor: AppArmor initialized
[    0.121912] TOMOYO Linux initialized
[    0.121912] LSM support for eBPF active
[    0.121912] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.121912] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.121912] VFS: Finished mounting rootfs on nullfs
[    0.121912] smpboot: CPU0: Intel(R) Core(TM) i5-10310U CPU @ 1.70GHz (family: 0x6, model: 0x8e, stepping: 0xc)
[    0.121912] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR, full-width counters, Intel PMU driver.
[    0.121912] ... version:                   4
[    0.121912] ... bit width:                 48
[    0.121912] ... generic counters:          4
[    0.121912] ... generic bitmap:            000000000000000f
[    0.121912] ... fixed-purpose counters:    3
[    0.121912] ... fixed-purpose bitmap:      0000000000000007
[    0.121912] ... value mask:                0000ffffffffffff
[    0.121912] ... max period:                00007fffffffffff
[    0.121912] ... global_ctrl mask:          000000070000000f
[    0.121912] signal: max sigframe size: 2032
[    0.121912] Estimated ratio of average max frequency by base frequency (times 1024): 1861
[    0.121912] rcu: Hierarchical SRCU implementation.
[    0.121912] rcu: 	Max phase no-delay instances is 400.
[    0.121912] Timer migration: 1 hierarchy levels; 8 children per group; 1 crossnode level
[    0.126945] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.127092] smp: Bringing up secondary CPUs ...
[    0.127266] smpboot: x86: Booting SMP configuration:
[    0.127272] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.130414] MMIO Stale Data CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processor_mmio_stale_data.html for more details.
[    0.131005] smp: Brought up 1 node, 8 CPUs
[    0.131005] smpboot: Total of 8 processors activated (35199.93 BogoMIPS)
[    0.192921] node 0 deferred pages initialised in 61ms
[    0.193147] Memory: 32485912K/33300824K available (18454K kernel code, 2763K rwdata, 8120K rodata, 4296K init, 3716K bss, 794976K reserved, 0K cma-reserved)
[    0.194435] devtmpfs: initialized
[    0.194435] x86/mm: Memory block size: 128MB
[    0.199746] ACPI: PM: Registering ACPI NVS region [mem 0xa8295000-0xa961efff] (20488192 bytes)
[    0.200227] posixtimers hash table entries: 4096 (order: 4, 65536 bytes, linear)
[    0.200227] futex hash table entries: 2048 (131072 bytes on 1 NUMA nodes, total 128 KiB, linear).
[    0.201353] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.202016] DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic allocations
[    0.202375] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    0.202766] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.202801] audit: initializing netlink subsys (disabled)
[    0.202828] audit: type=2000 audit(1782511708.081:1): state=initialized audit_enabled=0 res=1
[    0.203091] thermal_sys: Registered thermal governor 'fair_share'
[    0.203094] thermal_sys: Registered thermal governor 'bang_bang'
[    0.203100] thermal_sys: Registered thermal governor 'step_wise'
[    0.203104] thermal_sys: Registered thermal governor 'user_space'
[    0.203108] thermal_sys: Registered thermal governor 'power_allocator'
[    0.203125] cpuidle: using governor ladder
[    0.203125] cpuidle: using governor menu
[    0.203125] Simple Boot Flag at 0x47 set to 0x1
[    0.203125] Freeing SMP alternatives memory: 48K
[    0.209694] efi: Freeing EFI boot services memory: 57488K
[    0.209704] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.209710] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.209942] PCI: ECAM [mem 0xf0000000-0xf7ffffff] (base 0xf0000000) for domain 0000 [bus 00-7f]
[    0.209969] PCI: Using configuration type 1 for base access
[    0.210119] kprobes: kprobe jump-optimization is enabled. All kprobes are optimized if possible.
[    0.210130] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
[    0.210130] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
[    0.210130] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
[    0.210130] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    0.212699] ACPI: Added _OSI(Module Device)
[    0.212708] ACPI: Added _OSI(Processor Device)
[    0.212715] ACPI: Added _OSI(Processor Aggregator Device)
[    0.308683] ACPI: 11 ACPI AML tables successfully acquired and loaded
[    0.310109] ACPI: EC: EC started
[    0.310114] ACPI: EC: interrupt blocked
[    0.311086] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.311091] ACPI: EC: Boot ECDT EC used to handle transactions
[    0.313669] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.373679] ACPI: \_SB_: platform _OSC: OS support mask [002e7eff]
[    0.373679] ACPI: \_SB_: platform _OSC: OS control mask [002e7eff]
[    0.373679] ACPI: Dynamic OEM Table Load:
[    0.373679] ACPI: SSDT 0xFFFF8BD4C0DCD400 000400 (v02 PmRef  Cpu0Cst  00003001 INTL 20160527)
[    0.373790] ACPI: Dynamic OEM Table Load:
[    0.373797] ACPI: SSDT 0xFFFF8BD4C1BDB800 0005FD (v02 PmRef  Cpu0Ist  00003000 INTL 20160527)
[    0.373912] ACPI: Dynamic OEM Table Load:
[    0.373912] ACPI: SSDT 0xFFFF8BD4C2520500 0000FC (v02 PmRef  Cpu0Psd  00003000 INTL 20160527)
[    0.375003] ACPI: Dynamic OEM Table Load:
[    0.375009] ACPI: SSDT 0xFFFF8BD4C14C1C00 00016C (v02 PmRef  Cpu0Hwp  00003000 INTL 20160527)
[    0.375563] ACPI: Dynamic OEM Table Load:
[    0.375569] ACPI: SSDT 0xFFFF8BD4C1BE4000 000BEA (v02 PmRef  HwpLvt   00003000 INTL 20160527)
[    0.376266] ACPI: Dynamic OEM Table Load:
[    0.376273] ACPI: SSDT 0xFFFF8BD4C1BDE000 000778 (v02 PmRef  ApIst    00003000 INTL 20160527)
[    0.376928] ACPI: Dynamic OEM Table Load:
[    0.376934] ACPI: SSDT 0xFFFF8BD4C0DCC400 0003D7 (v02 PmRef  ApHwp    00003000 INTL 20160527)
[    0.377585] ACPI: Dynamic OEM Table Load:
[    0.377592] ACPI: SSDT 0xFFFF8BD4C1BE3000 000D22 (v02 PmRef  ApPsd    00003000 INTL 20160527)
[    0.378570] ACPI: Dynamic OEM Table Load:
[    0.378576] ACPI: SSDT 0xFFFF8BD4C0DCB000 0003CA (v02 PmRef  ApCst    00003000 INTL 20160527)
[    0.380613] ACPI: Interpreter enabled
[    0.380651] ACPI: PM: (supports S0 S3 S4 S5)
[    0.380653] ACPI: Using IOAPIC for interrupt routing
[    0.380683] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.380686] PCI: Ignoring E820 reservations for host bridge windows
[    0.380942] ACPI: Enabled 7 GPEs in block 00 to 7F
[    0.384435] ACPI: \_SB_.PCI0.LPCB.EC__.PUBS: New power resource
[    0.386555] ACPI: \_SB_.PCI0.XHC_.RHUB.HS10.BTPR: New power resource
[    0.386806] ACPI: \_SB_.PCI0.XHC_.RHUB.HS10.BTRT: New power resource
[    0.387408] ACPI: \_SB_.PCI0.XDCI.USBC: New power resource
[    0.388505] ACPI: \_SB_.PCI0.RP05.PXP_: New power resource
[    0.390312] ACPI: \_SB_.PCI0.RP07.PXP_: New power resource
[    0.394036] ACPI: \_SB_.PCI0.SAT0.VOL0.V0PR: New power resource
[    0.394136] ACPI: \_SB_.PCI0.SAT0.VOL1.V1PR: New power resource
[    0.394228] ACPI: \_SB_.PCI0.SAT0.VOL2.V2PR: New power resource
[    0.395090] ACPI: \_SB_.PCI0.CNVW.WRST: New power resource
[    0.397679] ACPI: \PIN_: New power resource
[    0.397697] ACPI: \PINP: New power resource
[    0.398005] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    0.398013] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
[    0.399218] acpi PNP0A08:00: _OSC: platform does not support [AER]
[    0.401597] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug SHPCHotplug PME PCIeCapability LTR]
[    0.401600] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.403304] PCI host bridge to bus 0000:00
[    0.403308] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.403311] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.403314] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.403316] pci_bus 0000:00: root bus resource [mem 0xaf800000-0xefffffff window]
[    0.403319] pci_bus 0000:00: root bus resource [mem 0xfc800000-0xfdffffff window]
[    0.403321] pci_bus 0000:00: root bus resource [bus 00-7e]
[    0.403346] pci 0000:00:00.0: [8086:9b61] type 00 class 0x060000 conventional PCI endpoint
[    0.403422] pci 0000:00:02.0: [8086:9b41] type 00 class 0x030000 PCIe Root Complex Integrated Endpoint
[    0.403438] pci 0000:00:02.0: BAR 0 [mem 0xed000000-0xedffffff 64bit]
[    0.403441] pci 0000:00:02.0: BAR 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.403443] pci 0000:00:02.0: BAR 4 [io  0x4000-0x403f]
[    0.403455] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.403585] pci 0000:00:04.0: [8086:1903] type 00 class 0x118000 conventional PCI endpoint
[    0.403604] pci 0000:00:04.0: BAR 0 [mem 0xef730000-0xef737fff 64bit]
[    0.403826] pci 0000:00:08.0: [8086:1911] type 00 class 0x088000 conventional PCI endpoint
[    0.403845] pci 0000:00:08.0: BAR 0 [mem 0xef742000-0xef742fff 64bit]
[    0.403950] pci 0000:00:12.0: [8086:02f9] type 00 class 0x118000 conventional PCI endpoint
[    0.403990] pci 0000:00:12.0: BAR 0 [mem 0xef743000-0xef743fff 64bit]
[    0.404105] pci 0000:00:14.0: [8086:02ed] type 00 class 0x0c0330 conventional PCI endpoint
[    0.404138] pci 0000:00:14.0: BAR 0 [mem 0xef720000-0xef72ffff 64bit]
[    0.404173] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.404458] pci 0000:00:14.2: [8086:02ef] type 00 class 0x050000 conventional PCI endpoint
[    0.404498] pci 0000:00:14.2: BAR 0 [mem 0xef740000-0xef741fff 64bit]
[    0.404502] pci 0000:00:14.2: BAR 2 [mem 0xef744000-0xef744fff 64bit]
[    0.404616] pci 0000:00:14.3: [8086:02f0] type 00 class 0x028000 PCIe Root Complex Integrated Endpoint
[    0.404671] pci 0000:00:14.3: BAR 0 [mem 0xef738000-0xef73bfff 64bit]
[    0.404769] pci 0000:00:14.3: PME# supported from D0 D3hot D3cold
[    0.404976] pci 0000:00:16.0: [8086:02e0] type 00 class 0x078000 conventional PCI endpoint
[    0.405020] pci 0000:00:16.0: BAR 0 [mem 0xef745000-0xef745fff 64bit]
[    0.405068] pci 0000:00:16.0: PME# supported from D3hot
[    0.405312] pci 0000:00:16.3: [8086:02e3] type 00 class 0x070002 conventional PCI endpoint
[    0.405347] pci 0000:00:16.3: BAR 0 [io  0x4060-0x4067]
[    0.405350] pci 0000:00:16.3: BAR 1 [mem 0xef748000-0xef748fff]
[    0.405472] pci 0000:00:1c.0: [8086:02b8] type 01 class 0x060400 PCIe Root Port
[    0.405490] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.405496] pci 0000:00:1c.0:   bridge window [mem 0xef600000-0xef6fffff]
[    0.405555] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.405944] pci 0000:00:1c.4: [8086:02bc] type 01 class 0x060400 PCIe Root Port
[    0.405962] pci 0000:00:1c.4: PCI bridge to [bus 03-2b]
[    0.405968] pci 0000:00:1c.4:   bridge window [mem 0xe0000000-0xec1fffff]
[    0.405975] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.406030] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.406422] pci 0000:00:1d.0: [8086:02b0] type 01 class 0x060400 PCIe Root Port
[    0.406443] pci 0000:00:1d.0: PCI bridge to [bus 2d]
[    0.406447] pci 0000:00:1d.0:   bridge window [io  0x3000-0x3fff]
[    0.406451] pci 0000:00:1d.0:   bridge window [mem 0xeec00000-0xef5fffff]
[    0.406459] pci 0000:00:1d.0:   bridge window [mem 0xee000000-0xee9fffff 64bit pref]
[    0.406508] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.406865] pci 0000:00:1d.4: [8086:02b4] type 01 class 0x060400 PCIe Root Port
[    0.406884] pci 0000:00:1d.4: PCI bridge to [bus 2e]
[    0.406889] pci 0000:00:1d.4:   bridge window [mem 0xeeb00000-0xeebfffff]
[    0.406949] pci 0000:00:1d.4: PME# supported from D0 D3hot D3cold
[    0.407337] pci 0000:00:1f.0: [8086:0284] type 00 class 0x060100 conventional PCI endpoint
[    0.407705] pci 0000:00:1f.3: [8086:02c8] type 00 class 0x040380 conventional PCI endpoint
[    0.407777] pci 0000:00:1f.3: BAR 0 [mem 0xef73c000-0xef73ffff 64bit]
[    0.407786] pci 0000:00:1f.3: BAR 4 [mem 0xeea00000-0xeeafffff 64bit]
[    0.407855] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.408205] pci 0000:00:1f.4: [8086:02a3] type 00 class 0x0c0500 conventional PCI endpoint
[    0.408250] pci 0000:00:1f.4: BAR 0 [mem 0xef746000-0xef7460ff 64bit]
[    0.408261] pci 0000:00:1f.4: BAR 4 [io  0xefa0-0xefbf]
[    0.408464] pci 0000:00:1f.5: [8086:02a4] type 00 class 0x0c8000 conventional PCI endpoint
[    0.408507] pci 0000:00:1f.5: BAR 0 [mem 0xfe010000-0xfe010fff]
[    0.408578] pci 0000:00:1f.6: [8086:0d4e] type 00 class 0x020000 conventional PCI endpoint
[    0.408661] pci 0000:00:1f.6: BAR 0 [mem 0xef700000-0xef71ffff]
[    0.408737] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.408874] pci 0000:02:00.0: [10ec:522a] type 00 class 0xff0000 PCIe Endpoint
[    0.408933] pci 0000:02:00.0: BAR 0 [mem 0xef600000-0xef600fff]
[    0.409045] pci 0000:02:00.0: supports D1 D2
[    0.409047] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.409261] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.409340] pci 0000:03:00.0: [8086:15c0] type 01 class 0x060400 PCIe Switch Upstream Port
[    0.409369] pci 0000:03:00.0: PCI bridge to [bus 04-2b]
[    0.409379] pci 0000:03:00.0:   bridge window [mem 0xe0000000-0xec1fffff]
[    0.409390] pci 0000:03:00.0:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.409404] pci 0000:03:00.0: enabling Extended Tags
[    0.409494] pci 0000:03:00.0: supports D1 D2
[    0.409496] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.409670] pci 0000:00:1c.4: PCI bridge to [bus 03-2b]
[    0.409758] pci 0000:04:00.0: [8086:15c0] type 01 class 0x060400 PCIe Switch Downstream Port
[    0.409789] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.409798] pci 0000:04:00.0:   bridge window [mem 0xec100000-0xec1fffff]
[    0.409824] pci 0000:04:00.0: enabling Extended Tags
[    0.409915] pci 0000:04:00.0: supports D1 D2
[    0.409917] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.410095] pci 0000:04:01.0: [8086:15c0] type 01 class 0x060400 PCIe Switch Downstream Port
[    0.410126] pci 0000:04:01.0: PCI bridge to [bus 06-2a]
[    0.410135] pci 0000:04:01.0:   bridge window [mem 0xe0100000-0xec0fffff]
[    0.410147] pci 0000:04:01.0:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.410163] pci 0000:04:01.0: enabling Extended Tags
[    0.410257] pci 0000:04:01.0: supports D1 D2
[    0.410258] pci 0000:04:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.410434] pci 0000:04:02.0: [8086:15c0] type 01 class 0x060400 PCIe Switch Downstream Port
[    0.410464] pci 0000:04:02.0: PCI bridge to [bus 2b]
[    0.410474] pci 0000:04:02.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.410499] pci 0000:04:02.0: enabling Extended Tags
[    0.410589] pci 0000:04:02.0: supports D1 D2
[    0.410591] pci 0000:04:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.410773] pci 0000:03:00.0: PCI bridge to [bus 04-2b]
[    0.410873] pci 0000:05:00.0: [8086:15bf] type 00 class 0x088000 PCIe Endpoint
[    0.410925] pci 0000:05:00.0: BAR 0 [mem 0xec100000-0xec13ffff]
[    0.410928] pci 0000:05:00.0: BAR 1 [mem 0xec140000-0xec140fff]
[    0.410945] pci 0000:05:00.0: enabling Extended Tags
[    0.411059] pci 0000:05:00.0: supports D1 D2
[    0.411061] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.411252] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.411303] pci 0000:04:01.0: PCI bridge to [bus 06-2a]
[    0.411418] pci 0000:2b:00.0: [8086:15c1] type 00 class 0x0c0330 PCIe Endpoint
[    0.411478] pci 0000:2b:00.0: BAR 0 [mem 0xe0000000-0xe000ffff]
[    0.411498] pci 0000:2b:00.0: enabling Extended Tags
[    0.411622] pci 0000:2b:00.0: supports D1 D2
[    0.411624] pci 0000:2b:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.411860] pci 0000:04:02.0: PCI bridge to [bus 2b]
[    0.411947] pci 0000:00:1d.0: PCI bridge to [bus 2d]
[    0.412011] pci 0000:2e:00.0: [c0a9:5426] type 00 class 0x010802 PCIe Endpoint
[    0.412053] pci 0000:2e:00.0: BAR 0 [mem 0xeeb00000-0xeeb03fff 64bit]
[    0.412264] pci 0000:2e:00.0: 31.504 Gb/s available PCIe bandwidth, limited by 8.0 GT/s PCIe x4 link at 0000:00:1d.4 (capable of 63.012 Gb/s with 16.0 GT/s PCIe x4 link)
[    0.412367] pci 0000:00:1d.4: PCI bridge to [bus 2e]
[    0.416001] ACPI: EC: interrupt unblocked
[    0.416004] ACPI: EC: event unblocked
[    0.416016] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.416018] ACPI: EC: GPE=0x16
[    0.416020] ACPI: \_SB_.PCI0.LPCB.EC__: Boot ECDT EC initialization complete
[    0.416022] ACPI: \_SB_.PCI0.LPCB.EC__: EC: Used to handle transactions and events
[    0.416100] iommu: Default domain type: Translated
[    0.416100] iommu: DMA domain TLB invalidation policy: lazy mode
[    0.416100] ACPI: bus type USB registered
[    0.416100] usbcore: registered new interface driver usbfs
[    0.416100] usbcore: registered new interface driver hub
[    0.416100] usbcore: registered new device driver usb
[    0.416100] pps_core: LinuxPPS API ver. 1 registered
[    0.416100] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.416100] PTP clock support registered
[    0.416100] EDAC MC: Ver: 3.0.0
[    0.416145] efivars: Registered efivars operations
[    0.416145] NetLabel: Initializing
[    0.416145] NetLabel:  domain hash size = 128
[    0.416145] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.416145] NetLabel:  unlabeled traffic allowed by default
[    0.416919] PCI: Using ACPI for IRQ routing
[    0.432796] PCI: pci_cache_line_size set to 64 bytes
[    0.432865] pci 0000:00:1f.5: BAR 0 [mem 0xfe010000-0xfe010fff]: can't claim; no compatible bridge window
[    0.432929] e820: register RAM buffer resource [mem 0x0009f000-0x0009ffff]
[    0.432931] e820: register RAM buffer resource [mem 0xa0503000-0xa3ffffff]
[    0.432933] e820: register RAM buffer resource [mem 0xa40b7000-0xa7ffffff]
[    0.432935] e820: register RAM buffer resource [mem 0xa9750000-0xabffffff]
[    0.432937] e820: register RAM buffer resource [mem 0x84c800000-0x84fffffff]
[    0.432958] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.432958] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.432958] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=mem,locks=none
[    0.432958] vgaarb: loaded
[    0.433039] clocksource: Switched to clocksource tsc-early
[    0.433072] VFS: Disk quotas dquot_6.6.0
[    0.433084] VFS: Dquot-cache hash table entries: 512 (4096 bytes)
[    0.433158] AppArmor: AppArmor Filesystem Enabled
[    0.433288] acpi PNP0C02:00: Reserved [mem 0xfd000000-0xfd69ffff]
[    0.433294] acpi PNP0C02:00: Reserved [mem 0xfd6b0000-0xfd6cffff]
[    0.433296] acpi PNP0C02:00: Reserved [mem 0xfd6f0000-0xfdffffff]
[    0.433298] acpi PNP0C02:00: Reserved [mem 0xfe000000-0xfe01ffff]
[    0.433300] acpi PNP0C02:00: Reserved [mem 0xfe200000-0xfe7fffff]
[    0.433302] acpi PNP0C02:00: Reserved [mem 0xff000000-0xffffffff]
[    0.433305] acpi PNP0C02:00: Could not reserve [io  0x1800-0x18fe]
[    0.433485] acpi PNP0C02:01: Reserved [io  0x2000-0x20fe]
[    0.433491] acpi PNP0C02:02: Skipped [io  0x002e-0x002f]
[    0.433493] acpi PNP0C02:02: Skipped [io  0x004e-0x004f]
[    0.433496] acpi PNP0C02:02: Skipped [io  0x0061]
[    0.433498] acpi PNP0C02:02: Skipped [io  0x0063]
[    0.433500] acpi PNP0C02:02: Skipped [io  0x0065]
[    0.433502] acpi PNP0C02:02: Skipped [io  0x0067]
[    0.433504] acpi PNP0C02:02: Skipped [io  0x0070]
[    0.433505] acpi PNP0C02:02: Skipped [io  0x0080]
[    0.433507] acpi PNP0C02:02: Skipped [io  0x0092]
[    0.433509] acpi PNP0C02:02: Skipped [io  0x00b2-0x00b3]
[    0.433511] acpi PNP0C02:02: Reserved [io  0x0680-0x069f]
[    0.433513] acpi PNP0C02:02: Reserved [io  0x164e-0x164f]
[    0.433527] acpi PNP0C02:03: Skipped [io  0x0010-0x001f]
[    0.433529] acpi PNP0C02:03: Skipped [io  0x0090-0x009f]
[    0.433530] acpi PNP0C02:03: Skipped [io  0x0024-0x0025]
[    0.433532] acpi PNP0C02:03: Skipped [io  0x0028-0x0029]
[    0.433534] acpi PNP0C02:03: Skipped [io  0x002c-0x002d]
[    0.433536] acpi PNP0C02:03: Skipped [io  0x0030-0x0031]
[    0.433537] acpi PNP0C02:03: Skipped [io  0x0034-0x0035]
[    0.433539] acpi PNP0C02:03: Skipped [io  0x0038-0x0039]
[    0.433541] acpi PNP0C02:03: Skipped [io  0x003c-0x003d]
[    0.433543] acpi PNP0C02:03: Skipped [io  0x00a4-0x00a5]
[    0.433546] acpi PNP0C02:03: Skipped [io  0x00a8-0x00a9]
[    0.433548] acpi PNP0C02:03: Skipped [io  0x00ac-0x00ad]
[    0.433552] acpi PNP0C02:03: Skipped [io  0x00b0-0x00b5]
[    0.433554] acpi PNP0C02:03: Skipped [io  0x00b8-0x00b9]
[    0.433555] acpi PNP0C02:03: Skipped [io  0x00bc-0x00bd]
[    0.433557] acpi PNP0C02:03: Skipped [io  0x0050-0x0053]
[    0.433559] acpi PNP0C02:03: Skipped [io  0x0072-0x0077]
[    0.433561] acpi PNP0C02:03: Could not reserve [io  0x1800-0x189f]
[    0.433563] acpi PNP0C02:03: Reserved [io  0x0800-0x087f]
[    0.433565] acpi PNP0C02:03: Reserved [io  0x0880-0x08ff]
[    0.433567] acpi PNP0C02:03: Reserved [io  0x0900-0x097f]
[    0.433569] acpi PNP0C02:03: Reserved [io  0x0980-0x09ff]
[    0.433570] acpi PNP0C02:03: Reserved [io  0x0a00-0x0a7f]
[    0.433572] acpi PNP0C02:03: Reserved [io  0x0a80-0x0aff]
[    0.433574] acpi PNP0C02:03: Reserved [io  0x0b00-0x0b7f]
[    0.433576] acpi PNP0C02:03: Reserved [io  0x0b80-0x0bff]
[    0.433578] acpi PNP0C02:03: Reserved [io  0x15e0-0x15ef]
[    0.433580] acpi PNP0C02:03: Could not reserve [io  0x1600-0x167f]
[    0.433582] acpi PNP0C02:03: Could not reserve [io  0x1640-0x165f]
[    0.433585] acpi PNP0C02:03: Reserved [mem 0xf0000000-0xf7ffffff]
[    0.433588] acpi PNP0C02:03: Reserved [mem 0xfed10000-0xfed13fff]
[    0.433590] acpi PNP0C02:03: Reserved [mem 0xfed18000-0xfed18fff]
[    0.433592] acpi PNP0C02:03: Reserved [mem 0xfed19000-0xfed19fff]
[    0.433594] acpi PNP0C02:03: Reserved [mem 0xfeb00000-0xfebfffff]
[    0.433596] acpi PNP0C02:03: Reserved [mem 0xfed20000-0xfed3ffff]
[    0.433599] acpi PNP0C02:03: Could not reserve [mem 0xfed90000-0xfed93fff]
[    0.433650] acpi PNP0C02:04: Could not reserve [mem 0xfed10000-0xfed17fff]
[    0.433653] acpi PNP0C02:04: Reserved [mem 0xfed18000-0xfed18fff]
[    0.433655] acpi PNP0C02:04: Reserved [mem 0xfed19000-0xfed19fff]
[    0.433657] acpi PNP0C02:04: Reserved [mem 0xf0000000-0xf7ffffff]
[    0.433660] acpi PNP0C02:04: Reserved [mem 0xfed20000-0xfed3ffff]
[    0.433666] acpi PNP0C02:04: Could not reserve [mem 0xfed90000-0xfed93fff]
[    0.433669] acpi PNP0C02:04: Could not reserve [mem 0xfed45000-0xfed8ffff]
[    0.433671] acpi PNP0C02:04: Reserved [mem 0xfee00000-0xfeefffff]
[    0.433761] acpi PNP0C02:05: Reserved [mem 0xfe038000-0xfe038fff]
[    0.433854] acpi PNP0C01:00: Could not reserve [mem 0x00000000-0x0009ffff]
[    0.433856] acpi PNP0C01:00: Could not reserve [mem 0x000c0000-0x000c3fff]
[    0.433858] acpi PNP0C01:00: Could not reserve [mem 0x000c8000-0x000cbfff]
[    0.433860] acpi PNP0C01:00: Could not reserve [mem 0x000d0000-0x000d3fff]
[    0.433862] acpi PNP0C01:00: Could not reserve [mem 0x000d8000-0x000dbfff]
[    0.433864] acpi PNP0C01:00: Could not reserve [mem 0x000e0000-0x000e3fff]
[    0.433866] acpi PNP0C01:00: Could not reserve [mem 0x000e8000-0x000ebfff]
[    0.433868] acpi PNP0C01:00: Could not reserve [mem 0x000f0000-0x000fffff]
[    0.433870] acpi PNP0C01:00: Could not reserve [mem 0x00100000-0xaf7fffff]
[    0.433872] acpi PNP0C01:00: Could not reserve [mem 0xfec00000-0xfed3ffff]
[    0.433874] acpi PNP0C01:00: Could not reserve [mem 0xfed4c000-0xffffffff]
[    0.433884] pnp: PnP ACPI init
[    0.434739] pnp: PnP ACPI: found 2 devices
[    0.440155] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.440208] NET: Registered PF_INET protocol family
[    0.440292] IP idents hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.442278] tcp_listen_portaddr_hash hash table entries: 16384 (order: 6, 262144 bytes, linear)
[    0.442304] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    0.442386] TCP established hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.442648] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes, linear)
[    0.442803] TCP: Hash tables configured (established 262144 bind 65536)
[    0.442903] MPTCP token hash table entries: 32768 (order: 8, 786432 bytes, linear)
[    0.443000] UDP hash table entries: 16384 (order: 8, 1048576 bytes, linear)
[    0.443112] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.443511] NET: Registered PF_XDP protocol family
[    0.443569] pci 0000:04:01.0: bridge window [io  0x1000-0x0fff] to [bus 06-2a] add_size 1000
[    0.443577] pci 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04-2b] add_size 1000
[    0.443580] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 03-2b] add_size 2000
[    0.443591] pci 0000:00:1c.4: bridge window [io  0x5000-0x6fff]: assigned
[    0.443594] pci 0000:00:1f.5: BAR 0 [mem 0xaf800000-0xaf800fff]: assigned
[    0.443608] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.443612] pci 0000:00:1c.0:   bridge window [mem 0xef600000-0xef6fffff]
[    0.443619] pci 0000:03:00.0: bridge window [io  0x5000-0x5fff]: assigned
[    0.443622] pci 0000:04:01.0: bridge window [io  0x5000-0x5fff]: assigned
[    0.443624] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.443629] pci 0000:04:00.0:   bridge window [mem 0xec100000-0xec1fffff]
[    0.443638] pci 0000:04:01.0: PCI bridge to [bus 06-2a]
[    0.443641] pci 0000:04:01.0:   bridge window [io  0x5000-0x5fff]
[    0.443646] pci 0000:04:01.0:   bridge window [mem 0xe0100000-0xec0fffff]
[    0.443651] pci 0000:04:01.0:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.443658] pci 0000:04:02.0: PCI bridge to [bus 2b]
[    0.443663] pci 0000:04:02.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.443672] pci 0000:03:00.0: PCI bridge to [bus 04-2b]
[    0.443675] pci 0000:03:00.0:   bridge window [io  0x5000-0x5fff]
[    0.443680] pci 0000:03:00.0:   bridge window [mem 0xe0000000-0xec1fffff]
[    0.443684] pci 0000:03:00.0:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.443690] pci 0000:00:1c.4: PCI bridge to [bus 03-2b]
[    0.443693] pci 0000:00:1c.4:   bridge window [io  0x5000-0x6fff]
[    0.443696] pci 0000:00:1c.4:   bridge window [mem 0xe0000000-0xec1fffff]
[    0.443700] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.443705] pci 0000:00:1d.0: PCI bridge to [bus 2d]
[    0.443710] pci 0000:00:1d.0:   bridge window [io  0x3000-0x3fff]
[    0.443714] pci 0000:00:1d.0:   bridge window [mem 0xeec00000-0xef5fffff]
[    0.443718] pci 0000:00:1d.0:   bridge window [mem 0xee000000-0xee9fffff 64bit pref]
[    0.443723] pci 0000:00:1d.4: PCI bridge to [bus 2e]
[    0.443727] pci 0000:00:1d.4:   bridge window [mem 0xeeb00000-0xeebfffff]
[    0.443733] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.443735] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.443737] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.443739] pci_bus 0000:00: resource 7 [mem 0xaf800000-0xefffffff window]
[    0.443742] pci_bus 0000:00: resource 8 [mem 0xfc800000-0xfdffffff window]
[    0.443744] pci_bus 0000:02: resource 1 [mem 0xef600000-0xef6fffff]
[    0.443746] pci_bus 0000:03: resource 0 [io  0x5000-0x6fff]
[    0.443748] pci_bus 0000:03: resource 1 [mem 0xe0000000-0xec1fffff]
[    0.443750] pci_bus 0000:03: resource 2 [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.443752] pci_bus 0000:04: resource 0 [io  0x5000-0x5fff]
[    0.443754] pci_bus 0000:04: resource 1 [mem 0xe0000000-0xec1fffff]
[    0.443756] pci_bus 0000:04: resource 2 [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.443759] pci_bus 0000:05: resource 1 [mem 0xec100000-0xec1fffff]
[    0.443761] pci_bus 0000:06: resource 0 [io  0x5000-0x5fff]
[    0.443763] pci_bus 0000:06: resource 1 [mem 0xe0100000-0xec0fffff]
[    0.443765] pci_bus 0000:06: resource 2 [mem 0xb0000000-0xcbffffff 64bit pref]
[    0.443767] pci_bus 0000:2b: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.443769] pci_bus 0000:2d: resource 0 [io  0x3000-0x3fff]
[    0.443771] pci_bus 0000:2d: resource 1 [mem 0xeec00000-0xef5fffff]
[    0.443773] pci_bus 0000:2d: resource 2 [mem 0xee000000-0xee9fffff 64bit pref]
[    0.443775] pci_bus 0000:2e: resource 1 [mem 0xeeb00000-0xeebfffff]
[    0.444453] PCI: CLS 0 bytes, default 64
[    0.444491] DMAR: Intel-IOMMU force enabled due to platform opt in
[    0.444500] DMAR: No ATSR found
[    0.444501] DMAR: No SATC found
[    0.444502] DMAR: dmar0: Using Queued invalidation
[    0.444506] DMAR: dmar1: Using Queued invalidation
[    0.444577] Unpacking initramfs...
[    0.445060] pci 0000:00:02.0: Adding to iommu group 0
[    0.445098] pci 0000:00:00.0: Adding to iommu group 1
[    0.445107] pci 0000:00:04.0: Adding to iommu group 2
[    0.445116] pci 0000:00:08.0: Adding to iommu group 3
[    0.445127] pci 0000:00:12.0: Adding to iommu group 4
[    0.445141] pci 0000:00:14.0: Adding to iommu group 5
[    0.445148] pci 0000:00:14.2: Adding to iommu group 5
[    0.445157] pci 0000:00:14.3: Adding to iommu group 6
[    0.445171] pci 0000:00:16.0: Adding to iommu group 7
[    0.445179] pci 0000:00:16.3: Adding to iommu group 7
[    0.445190] pci 0000:00:1c.0: Adding to iommu group 8
[    0.445210] pci 0000:00:1c.4: Adding to iommu group 9
[    0.445225] pci 0000:00:1d.0: Adding to iommu group 10
[    0.445236] pci 0000:00:1d.4: Adding to iommu group 11
[    0.445259] pci 0000:00:1f.0: Adding to iommu group 12
[    0.445268] pci 0000:00:1f.3: Adding to iommu group 12
[    0.445278] pci 0000:00:1f.4: Adding to iommu group 12
[    0.445286] pci 0000:00:1f.5: Adding to iommu group 12
[    0.445294] pci 0000:00:1f.6: Adding to iommu group 12
[    0.445304] pci 0000:02:00.0: Adding to iommu group 13
[    0.445317] pci 0000:03:00.0: Adding to iommu group 14
[    0.445334] pci 0000:04:00.0: Adding to iommu group 15
[    0.445344] pci 0000:04:01.0: Adding to iommu group 16
[    0.445353] pci 0000:04:02.0: Adding to iommu group 17
[    0.445357] pci 0000:05:00.0: Adding to iommu group 15
[    0.445363] pci 0000:2b:00.0: Adding to iommu group 17
[    0.445378] pci 0000:2e:00.0: Adding to iommu group 18
[    0.445507] DMAR: Intel(R) Virtualization Technology for Directed I/O
[    0.445510] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.445511] software IO TLB: mapped [mem 0x000000009b291000-0x000000009f291000] (64MB)
[    0.445989] Initialise system trusted keyrings
[    0.446001] Key type blacklist registered
[    0.446147] workingset: timestamp_bits=36 (anon: 31) max_order=23 bucket_order=0 (anon: 0)
[    0.446350] fuse: init (API version 7.45)
[    0.446509] integrity: Platform Keyring initialized
[    0.446514] integrity: Machine keyring initialized
[    0.455123] Key type asymmetric registered
[    0.455132] Asymmetric key parser 'x509' registered
[    0.455273] alg: full crypto tests enabled.  This is intended for developer use only.
[    0.458806] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 245)
[    0.459003] io scheduler mq-deadline registered
[    0.462656] ledtrig-cpu: registered to indicate activity on CPUs
[    0.462890] pcieport 0000:00:1c.0: PME: Signaling with IRQ 123
[    0.463054] pcieport 0000:00:1c.4: PME: Signaling with IRQ 124
[    0.463076] pcieport 0000:00:1c.4: pciehp: Slot #4 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Interlock- NoCompl+ IbPresDis- LLActRep+
[    0.463337] pcieport 0000:00:1d.0: PME: Signaling with IRQ 125
[    0.463367] pcieport 0000:00:1d.0: pciehp: Slot #0 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Interlock- NoCompl+ IbPresDis- LLActRep+
[    0.463680] pcieport 0000:00:1d.4: PME: Signaling with IRQ 126
[    0.464044] pcieport 0000:04:01.0: pciehp: Slot #1 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Interlock- NoCompl+ IbPresDis- LLActRep+
[    0.469239] acpi LNXTHERM:00: registered as thermal_zone0
[    0.469244] ACPI: thermal: Thermal Zone [THM0] (51 C)
[    0.469405] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.470109] serial 0000:00:16.3: enabling device (0001 -> 0003)
[    0.470796] 0000:00:16.3: ttyS0 at I/O 0x4060 (irq = 19, base_baud = 115200) is a 16550A
[    0.471057] hpet_acpi_probe: no address or irqs in _CRS
[    0.473300] tpm_tis STM0125:00: 2.0 TPM (vendor-id 0x104A, device-id 0x0, rev-id 78)
[    0.575450] Freeing initrd memory: 48376K
[    0.695462] UEFI TPM log area empty
[    0.698963] ACPI: bus type drm_connector registered
[    0.706508] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.713635] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.713641] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.713903] mousedev: PS/2 mouse device common for all mice
[    0.713984] rtc_cmos PNP0B00:00: RTC can wake from S4
[    0.715638] rtc_cmos PNP0B00:00: registered as rtc0
[    0.715898] rtc_cmos PNP0B00:00: setting system clock to 2026-06-26T22:08:29 UTC (1782511709)
[    0.715928] rtc_cmos PNP0B00:00: alarms up to one month, y3k, 242 bytes nvram
[    0.715983] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.716556] intel_pstate: Intel P-state driver initializing
[    0.717033] intel_pstate: HWP enabled
[    0.717346] simple-framebuffer simple-framebuffer.0: [drm] Registered 1 planes with drm panic
[    0.717391] [drm] Initialized simpledrm 1.0.0 for simple-framebuffer.0 on minor 0
[    0.723284] Console: switching to colour frame buffer device 240x67
[    0.725501] simple-framebuffer simple-framebuffer.0: [drm] fb0: simpledrmdrmfb frame buffer device
[    0.725748] NET: Registered PF_INET6 protocol family
[    0.726853] Segment Routing with IPv6
[    0.726870] In-situ OAM (IOAM) with IPv6
[    0.726893] mip6: Mobile IPv6
[    0.726899] NET: Registered PF_PACKET protocol family
[    0.727043] mpls_gso: MPLS GSO support
[    0.727785] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.728058] microcode: Current revision: 0x00000100
[    0.728389] IPI shorthand broadcast: enabled
[    0.729609] sched_clock: Marking stable (720001057, 9549547)->(783788255, -54237651)
[    0.729897] registered taskstats version 1
[    0.729957] Loading compiled-in X.509 certificates
[    0.765312] Loaded X.509 cert 'Build time autogenerated kernel key: 9d0a22ebf69e94394359820e3dc224cdddc631d6'
[    0.768933] Demotion targets for Node 0: null
[    0.768986] Key type .fscrypt registered
[    0.768993] Key type fscrypt-provisioning registered
[    0.798527] Key type encrypted registered
[    0.798576] AppArmor: AppArmor sha256 policy hashing enabled
[    0.800508] ima: Allocated hash algorithm: sha256
[    0.872079] ima: No architecture policies found
[    0.872153] evm: Initialising EVM extended attributes:
[    0.872168] evm: security.selinux
[    0.872180] evm: security.SMACK64 (disabled)
[    0.872193] evm: security.SMACK64EXEC (disabled)
[    0.872207] evm: security.SMACK64TRANSMUTE (disabled)
[    0.872221] evm: security.SMACK64MMAP (disabled)
[    0.872234] evm: security.apparmor
[    0.872245] evm: security.ima
[    0.872254] evm: security.capability
[    0.872266] evm: HMAC attrs: 0x1
[    0.873270] integrity: Loading X.509 certificate: UEFI:db
[    0.873460] integrity: Loaded X.509 cert 'Lenovo Ltd.: ThinkPad Product CA 2012: 838b1f54c1550463f45f98700640f11069265949'
[    0.873492] integrity: Loading X.509 certificate: UEFI:db
[    0.873574] integrity: Loaded X.509 cert 'Lenovo UEFI CA 2014: 4b91a68732eaefdd2c8ffffc6b027ec3449e9c8f'
[    0.873604] integrity: Loading X.509 certificate: UEFI:db
[    0.873685] integrity: Loaded X.509 cert 'Microsoft Corporation UEFI CA 2011: 13adbf4309bd82709c8cd54f316ed522988a1bd4'
[    0.873714] integrity: Loading X.509 certificate: UEFI:db
[    0.873777] integrity: Loaded X.509 cert 'Microsoft Windows Production PCA 2011: a92902398e16c49778cd90f99e4f9ae17c55af53'
[    0.873809] integrity: Loading X.509 certificate: UEFI:db
[    0.873866] integrity: Loaded X.509 cert 'Microsoft Corporation: Windows UEFI CA 2023: aefc5fbbbe055d8f8daa585473499417ab5a5272'
[    0.873896] integrity: Loading X.509 certificate: UEFI:db
[    0.874808] integrity: Loaded X.509 cert 'Microsoft UEFI CA 2023: 81aa6b3244c935bce0d6628af39827421e32497d'
[    0.875618] integrity: Loading X.509 certificate: UEFI:db
[    0.876702] integrity: Loaded X.509 cert 'Microsoft Option ROM UEFI CA 2023: 514fbf937fa46fb57bf07af8bed84b3b864b1711'
[    0.902446] alg: No test for mldsa87 (mldsa87-lib)
[    0.902496] alg: No test for mldsa65 (mldsa65-lib)
[    0.902564] alg: No test for mldsa44 (mldsa44-lib)
[    0.910239] RAS: Correctable Errors collector initialized.
[    0.911776] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    0.933689] Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    0.934824] Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
[    0.935209] clk: Disabling unused clocks
[    0.936972] Freeing unused decrypted memory: 2028K
[    0.938996] Freeing unused kernel image (initmem) memory: 4296K
[    0.939324] Write protecting the kernel read-only data: 28672k
[    0.940392] Freeing unused kernel image (text/rodata gap) memory: 2024K
[    0.940757] Freeing unused kernel image (rodata/data gap) memory: 72K
[    0.952173] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    0.952414] Run /init as init process
[    0.953561]   with arguments:
[    0.953564]     /init
[    0.953565]   with environment:
[    0.953566]     HOME=/
[    0.953567]     TERM=linux
[    1.109742] rtsx_pci 0000:02:00.0: enabling device (0000 -> 0002)
[    1.123150] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[    1.123998] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[    1.126224] i2c i2c-0: Successfully instantiated SPD at 0x51
[    1.140261] ACPI: bus type thunderbolt registered
[    1.142170] thunderbolt 0000:05:00.0: enabling device (0000 -> 0002)
[    1.144638] nvme nvme0: pci function 0000:2e:00.0
[    1.144642] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.145746] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.147297] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x110 quirks 0x0000000000009810
[    1.148481] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.149034] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.149577] xhci_hcd 0000:00:14.0: Host supports USB 3.1 Enhanced SuperSpeed
[    1.150318] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 7.01
[    1.150870] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.151399] usb usb1: Product: xHCI Host Controller
[    1.151884] usb usb1: Manufacturer: Linux 7.1.0-t14test202606+ xhci-hcd
[    1.152273] usb usb1: SerialNumber: 0000:00:14.0
[    1.152855] e1000e: Intel(R) PRO/1000 Network Driver
[    1.152958] hub 1-0:1.0: USB hub found
[    1.153287] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    1.153896] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.153930] hub 1-0:1.0: 12 ports detected
[    1.156471] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 7.01
[    1.156850] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.157119] usb usb2: Product: xHCI Host Controller
[    1.157391] usb usb2: Manufacturer: Linux 7.1.0-t14test202606+ xhci-hcd
[    1.157665] usb usb2: SerialNumber: 0000:00:14.0
[    1.158123] hub 2-0:1.0: USB hub found
[    1.158443] hub 2-0:1.0: 6 ports detected
[    1.160015] xhci_hcd 0000:2b:00.0: xHCI Host Controller
[    1.160352] xhci_hcd 0000:2b:00.0: new USB bus registered, assigned bus number 3
[    1.161806] xhci_hcd 0000:2b:00.0: hcc params 0x200077c1 hci version 0x110 quirks 0x0000000200009810
[    1.162579] xhci_hcd 0000:2b:00.0: xHCI Host Controller
[    1.162934] xhci_hcd 0000:2b:00.0: new USB bus registered, assigned bus number 4
[    1.163245] xhci_hcd 0000:2b:00.0: Host supports USB 3.1 Enhanced SuperSpeed
[    1.163611] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 7.01
[    1.163924] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.164208] usb usb3: Product: xHCI Host Controller
[    1.164507] usb usb3: Manufacturer: Linux 7.1.0-t14test202606+ xhci-hcd
[    1.164794] usb usb3: SerialNumber: 0000:2b:00.0
[    1.165278] hub 3-0:1.0: USB hub found
[    1.165592] hub 3-0:1.0: 2 ports detected
[    1.167208] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 7.01
[    1.167668] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.168114] usb usb4: Product: xHCI Host Controller
[    1.168524] usb usb4: Manufacturer: Linux 7.1.0-t14test202606+ xhci-hcd
[    1.168643] nvme nvme0: passthrough uses implicit buffer lengths
[    1.168947] usb usb4: SerialNumber: 0000:2b:00.0
[    1.170699] hub 4-0:1.0: USB hub found
[    1.171781] hub 4-0:1.0: 2 ports detected
[    1.177548] nvme nvme0: allocated 64 MiB host memory buffer (16 segments).
[    1.194519] nvme nvme0: 8/0/0 default/read/poll queues
[    1.199265]  nvme0n1: p1 p2 p3 p4
[    1.207315] iTCO_wdt iTCO_wdt: Found a Intel PCH TCO device (Version=6, TCOBASE=0x0400)
[    1.207957] iTCO_wdt iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.232629] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): registered PHC clock
[    1.294634] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 8c:8c:aa:54:44:f3
[    1.295562] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Connection
[    1.296217] e1000e 0000:00:1f.6 eth0: MAC: 13, PHY: 12, PBA No: FFFFFF-0FF
[    1.297915] e1000e 0000:00:1f.6 enp0s31f6: renamed from eth0
[    1.392604] usb 1-6: new full-speed USB device number 2 using xhci_hcd
[    1.487196] typec port0: bound usb1-port2 (ops connector_ops)
[    1.487719] typec port0: bound usb2-port2 (ops connector_ops)
[    1.496558] tsc: Refined TSC clocksource calibration: 2207.990 MHz
[    1.496841] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fd3aeb5d14, max_idle_ns: 440795226789 ns
[    1.497419] clocksource: Switched to clocksource tsc
[    1.520768] usb 1-6: New USB device found, idVendor=04f3, idProduct=289b, bcdDevice=57.13
[    1.521161] usb 1-6: New USB device strings: Mfr=4, Product=14, SerialNumber=0
[    1.521538] usb 1-6: Product: Touchscreen
[    1.521929] usb 1-6: Manufacturer: ELAN
[    1.635556] usb 1-8: new high-speed USB device number 3 using xhci_hcd
[    1.772009] usb 1-8: New USB device found, idVendor=04ca, idProduct=7070, bcdDevice= 0.25
[    1.772442] usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.772857] usb 1-8: Product: Integrated Camera
[    1.773248] usb 1-8: Manufacturer: 8SSC20F27068V1SR0B5D74K
[    1.886556] usb 1-10: new full-speed USB device number 4 using xhci_hcd
[    1.949566] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4694]
[    1.954518] hid: raw HID events driver (C) Jiri Kosina
[    1.954853] i915 0000:00:02.0: enabling device (0006 -> 0007)
[    1.954989] i915 0000:00:02.0: [drm] Found cometlake/ult (device ID 9b41) integrated display version 9.00 stepping N/A
[    1.956202] i915 0000:00:02.0: [drm] VT-d active for gfx access
[    1.972526] usbcore: registered new interface driver usbhid
[    1.972884] usbhid: USB HID core driver
[    1.977888] Console: switching to colour dummy device 80x25
[    1.979870] i915 0000:00:02.0: vgaarb: deactivate vga console
[    1.979946] i915 0000:00:02.0: [drm] Using Transparent Hugepages
[    1.980833] psmouse serio1: synaptics: queried min coordinates: x [1266..], y [1162..]
[    1.980841] psmouse serio1: synaptics: Trying to set up SMBus access
[    1.982461] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input3
[    1.982513] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input4
[    1.982530] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input5
[    1.982610] hid-generic 0003:04F3:289B.0001: input,hiddev0,hidraw0: USB HID v1.10 Device [ELAN Touchscreen] on usb-0000:00:14.0-6/input0
[    1.983526] i915 0000:00:02.0: [drm] Finished loading DMC firmware i915/kbl_dmc_ver1_04.bin (v1.4)
[    2.003556] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input7
[    2.003682] input: ELAN Touchscreen UNKNOWN as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input8
[    2.003702] input: ELAN Touchscreen UNKNOWN as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:04F3:289B.0001/input/input9
[    2.003868] hid-multitouch 0003:04F3:289B.0001: input,hiddev0,hidraw0: USB HID v1.10 Device [ELAN Touchscreen] on usb-0000:00:14.0-6/input0
[    2.012473] usb 1-10: New USB device found, idVendor=8087, idProduct=0026, bcdDevice= 0.02
[    2.012479] usb 1-10: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.022315] i915 0000:00:02.0: vgaarb: VGA decodes changed: olddecodes=io+mem,decodes=io:owns=mem
[    2.037095] i915 0000:00:02.0: [drm] Registered 3 planes with drm panic
[    2.043774] [drm] Initialized i915 1.6.0 for 0000:00:02.0 on minor 1
[    2.050875] ACPI: video: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.050984] input: Video Bus as /devices/pci0000:00/acpi.video_bus.0/input/input11
[    2.128956] fbcon: i915drmfb (fb0) is primary device
[    2.135477] Console: switching to colour frame buffer device 240x67
[    2.169963] i915 0000:00:02.0: [drm] fb0: i915drmfb frame buffer device
[    2.218569] xor: automatically using best checksumming function   avx
[    2.227231] raid6: using avx2x2 recovery algorithm
[    2.243574] raid6: avx2x1   gen() 38364 MB/s
[    2.260553] raid6: avx2x2   gen() 34869 MB/s
[    2.278584] raid6: avx2x4   gen() 39439 MB/s
[    2.278751] raid6: using algorithm avx2x4 gen() 39439 MB/s
[    2.295596] raid6: .... xor() 12289 MB/s, rmw enabled
[    2.298984] async_tx: api initialized (async)
[    2.360317] load module synosnap failed, abort cbt reloading
[    2.404500] typec port1: bound usb1-port5 (ops connector_ops)
[    2.404509] typec port1: bound usb4-port1 (ops connector_ops)
[    2.748798] Btrfs loaded, zoned=yes, fsverity=yes
[    2.776833] PM: Image not found (code -22)
[    3.474703] SGI XFS with ACLs, security attributes, realtime, scrub, repair, quota, no debug enabled
[    3.478773] XFS (nvme0n1p3): Mounting V5 Filesystem acabe8be-6dd5-4d04-a138-22fdf9a0b015
[    3.485023] XFS (nvme0n1p3): Ending clean mount
[    3.514504] Not activating Mandatory Access Control as /sbin/tomoyo-init does not exist.
[    3.607735] systemd[1]: Inserted module 'autofs4'
[    3.625601] systemd[1]: systemd 257.13-1~deb13u1 running in system mode (+PAM +AUDIT +SELINUX +APPARMOR +IMA +IPE +SMACK +SECCOMP +GCRYPT -GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP +LIBCRYPTSETUP_PLUGINS +LIBFDISK +PCRE2 +PWQUALITY +P11KIT +QRENCODE +TPM2 +BZIP2 +LZ4 +XZ +ZLIB +ZSTD +BPF_FRAMEWORK +BTF -XKBCOMMON -UTMP +SYSVINIT +LIBARCHIVE)
[    3.626354] systemd[1]: Detected architecture x86-64.
[    3.629724] systemd[1]: Hostname set to <t14>.
[    3.688875] systemd[1]: bpf-restrict-fs: Failed to load BPF object: No such process
[    3.710431] systemd-sysv-generator[373]: SysV service '/etc/init.d/uml-utilities' lacks a native systemd unit file, automatically generating a unit file for compatibility.
[    3.710828] systemd-sysv-generator[373]: Please update package to include a native systemd unit file.
[    3.711220] systemd-sysv-generator[373]: ! This compatibility logic is deprecated, expect removal soon. !
[    3.767889] systemd[1]: /etc/systemd/system/synology-active-backup-business-linux-service.service:6: PIDFile= references a path below legacy directory /var/run/, updating /var/run/synology-backupd.pid → /run/synology-backupd.pid; please update the unit file accordingly.
[    3.850950] systemd[1]: Queued start job for default target graphical.target.
[    3.858127] systemd[1]: Created slice machine.slice - Virtual Machine and Container Slice.
[    3.859303] systemd[1]: Created slice system-getty.slice - Slice /system/getty.
[    3.860029] systemd[1]: Created slice system-modprobe.slice - Slice /system/modprobe.
[    3.860978] systemd[1]: Created slice system-systemd\x2dfsck.slice - Slice /system/systemd-fsck.
[    3.862092] systemd[1]: Created slice system-xfs_scrub.slice - xfs_scrub background service slice.
[    3.863116] systemd[1]: Created slice user.slice - User and Session Slice.
[    3.863900] systemd[1]: Started systemd-ask-password-wall.path - Forward Password Requests to Wall Directory Watch.
[    3.864497] systemd[1]: Set up automount proc-sys-fs-binfmt_misc.automount - Arbitrary Executable File Formats File System Automount Point.
[    3.865322] systemd[1]: Expecting device dev-disk-by\x2dlabel-boot.device - /dev/disk/by-label/boot...
[    3.866219] systemd[1]: Expecting device dev-disk-by\x2dpartuuid-942cfd1f\x2d5513\x2d4bfb\x2d9850\x2dae56cf0e0eb4.device - /dev/disk/by-partuuid/942cfd1f-5513-4bfb-9850-ae56cf0e0eb4...
[    3.867171] systemd[1]: Expecting device dev-disk-by\x2duuid-45595b04\x2d0bed\x2d47c6\x2d9a8d\x2d7cad4e58007d.device - /dev/disk/by-uuid/45595b04-0bed-47c6-9a8d-7cad4e58007d...
[    3.868133] systemd[1]: Reached target integritysetup.target - Local Integrity Protected Volumes.
[    3.869128] systemd[1]: Reached target nss-user-lookup.target - User and Group Name Lookups.
[    3.870119] systemd[1]: Reached target slices.target - Slice Units.
[    3.871144] systemd[1]: Reached target veritysetup.target - Local Verity Protected Volumes.
[    3.872149] systemd[1]: Reached target virt-guest-shutdown.target - libvirt guests shutdown target.
[    3.873237] systemd[1]: Listening on dm-event.socket - Device-mapper event daemon FIFOs.
[    3.874300] systemd[1]: Listening on lvm2-lvmpolld.socket - LVM2 poll daemon socket.
[    3.876566] systemd[1]: Listening on systemd-creds.socket - Credential Encryption/Decryption.
[    3.877450] systemd[1]: Listening on systemd-initctl.socket - initctl Compatibility Named Pipe.
[    3.878536] systemd[1]: Listening on systemd-journald-dev-log.socket - Journal Socket (/dev/log).
[    3.879593] systemd[1]: Listening on systemd-journald.socket - Journal Sockets.
[    3.880591] systemd[1]: systemd-pcrextend.socket - TPM PCR Measurements skipped, unmet condition check ConditionSecurity=measured-uki
[    3.880604] systemd[1]: systemd-pcrlock.socket - Make TPM PCR Policy skipped, unmet condition check ConditionSecurity=measured-uki
[    3.880664] systemd[1]: Listening on systemd-udevd-control.socket - udev Control Socket.
[    3.882598] systemd[1]: Listening on systemd-udevd-kernel.socket - udev Kernel Socket.
[    3.884375] systemd[1]: Mounting dev-hugepages.mount - Huge Pages File System...
[    3.885706] systemd[1]: Mounting dev-mqueue.mount - POSIX Message Queue File System...
[    3.887421] systemd[1]: Mounting run-lock.mount - Legacy Locks Directory /run/lock...
[    3.889094] systemd[1]: Mounting sys-kernel-debug.mount - Kernel Debug File System...
[    3.899369] systemd[1]: Mounting sys-kernel-tracing.mount - Kernel Trace File System...
[    3.901566] systemd[1]: Starting keyboard-setup.service - Set the console keyboard layout...
[    3.903346] systemd[1]: Starting kmod-static-nodes.service - Create List of Static Device Nodes...
[    3.904938] systemd[1]: Starting lvm2-monitor.service - Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling...
[    3.906536] systemd[1]: Starting modprobe@configfs.service - Load Kernel Module configfs...
[    3.908182] systemd[1]: Starting modprobe@drm.service - Load Kernel Module drm...
[    3.909826] systemd[1]: Starting modprobe@efi_pstore.service - Load Kernel Module efi_pstore...
[    3.912208] systemd[1]: Starting modprobe@fuse.service - Load Kernel Module fuse...
[    3.914262] systemd[1]: Starting modprobe@nvme_fabrics.service - Load Kernel Module nvme_fabrics...
[    3.915484] systemd[1]: systemd-hibernate-clear.service - Clear Stale Hibernate Storage Info skipped, unmet condition check ConditionPathExists=/sys/firmware/efi/efivars/HibernateLocation-8cf2644b-4b0b-428f-9387-6d876050dc67
[    3.917580] systemd[1]: Starting systemd-journald.service - Journal Service...
[    3.920124] systemd[1]: Starting systemd-modules-load.service - Load Kernel Modules...
[    3.921680] systemd[1]: systemd-pcrmachine.service - TPM PCR Machine ID Measurement skipped, unmet condition check ConditionSecurity=measured-uki
[    3.922751] systemd[1]: Starting systemd-remount-fs.service - Remount Root and Kernel File Systems...
[    3.924080] systemd[1]: systemd-tpm2-setup-early.service - Early TPM SRK Setup skipped, unmet condition check ConditionSecurity=measured-uki
[    3.924263] pstore: Using crash dump compression: deflate
[    3.927591] systemd[1]: Starting systemd-udev-load-credentials.service - Load udev Rules from Credentials...
[    3.942879] systemd[1]: Starting systemd-udev-trigger.service - Coldplug All udev Devices...
[    3.951073] pstore: Registered efi_pstore as persistent store backend
[    3.960719] systemd-journald[393]: Collecting audit messages is disabled.
[    3.960936] systemd[1]: Mounted dev-hugepages.mount - Huge Pages File System.
[    3.962502] systemd[1]: Mounted dev-mqueue.mount - POSIX Message Queue File System.
[    3.965370] systemd[1]: Mounted run-lock.mount - Legacy Locks Directory /run/lock.
[    3.966574] systemd[1]: Mounted sys-kernel-debug.mount - Kernel Debug File System.
[    3.969098] systemd[1]: Mounted sys-kernel-tracing.mount - Kernel Trace File System.
[    3.970925] systemd[1]: Finished kmod-static-nodes.service - Create List of Static Device Nodes.
[    3.972646] systemd[1]: modprobe@configfs.service: Deactivated successfully.
[    3.972843] systemd[1]: Finished modprobe@configfs.service - Load Kernel Module configfs.
[    3.973734] lp: driver loaded but no devices found
[    3.975733] systemd[1]: modprobe@drm.service: Deactivated successfully.
[    3.975914] systemd[1]: Finished modprobe@drm.service - Load Kernel Module drm.
[    3.977661] systemd[1]: modprobe@efi_pstore.service: Deactivated successfully.
[    3.977838] systemd[1]: Finished modprobe@efi_pstore.service - Load Kernel Module efi_pstore.
[    3.979854] systemd[1]: modprobe@fuse.service: Deactivated successfully.
[    3.980074] systemd[1]: Finished modprobe@fuse.service - Load Kernel Module fuse.
[    3.980145] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is disabled. Duplicate IMA measurements will not be recorded in the IMA log.
[    3.980211] device-mapper: uevent: version 1.0.3
[    3.980310] device-mapper: ioctl: 4.50.0-ioctl (2025-04-28) initialised: dm-devel@lists.linux.dev
[    3.982997] systemd[1]: modprobe@nvme_fabrics.service: Deactivated successfully.
[    3.983182] systemd[1]: Finished modprobe@nvme_fabrics.service - Load Kernel Module nvme_fabrics.
[    3.985413] ppdev: user-space parallel port driver
[    3.985829] systemd[1]: Finished systemd-remount-fs.service - Remount Root and Kernel File Systems.
[    3.987162] systemd[1]: Finished systemd-udev-load-credentials.service - Load udev Rules from Credentials.
[    3.989259] systemd[1]: Mounting sys-fs-fuse-connections.mount - FUSE Control File System...
[    3.990775] systemd[1]: Mounting sys-kernel-config.mount - Kernel Configuration File System...
[    3.992108] systemd[1]: systemd-hwdb-update.service - Rebuild Hardware Database skipped, unmet condition check ConditionNeedsUpdate=/etc
[    3.992158] systemd[1]: systemd-pstore.service - Platform Persistent Storage Archival skipped, unmet condition check ConditionDirectoryNotEmpty=/sys/fs/pstore
[    3.993418] systemd[1]: Starting systemd-random-seed.service - Load/Save OS Random Seed...
[    4.001467] systemd[1]: Starting systemd-tmpfiles-setup-dev-early.service - Create Static Device Nodes in /dev gracefully...
[    4.002277] systemd[1]: systemd-tpm2-setup.service - TPM SRK Setup skipped, unmet condition check ConditionSecurity=measured-uki
[    4.003537] systemd[1]: Mounted sys-fs-fuse-connections.mount - FUSE Control File System.
[    4.004279] systemd[1]: Mounted sys-kernel-config.mount - Kernel Configuration File System.
[    4.005964] systemd[1]: Finished lvm2-monitor.service - Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling.
[    4.008925] systemd[1]: Finished systemd-random-seed.service - Load/Save OS Random Seed.
[    4.011893] systemd[1]: Finished systemd-modules-load.service - Load Kernel Modules.
[    4.014121] systemd[1]: Starting systemd-sysctl.service - Apply Kernel Variables...
[    4.015779] systemd[1]: Finished keyboard-setup.service - Set the console keyboard layout.
[    4.023814] systemd[1]: Started systemd-journald.service - Journal Service.
[    4.046585] systemd-journald[393]: Received client request to flush runtime journal.
[    4.215797] intel_pch_thermal 0000:00:12.0: enabling device (0000 -> 0002)
[    4.227965] input: Sleep Button as /devices/platform/PNP0C0E:00/input/input12
[    4.230992] ACPI: button: Sleep Button [SLPB]
[    4.241928] input: Lid Switch as /devices/platform/PNP0C0D:00/input/input13
[    4.248125] ACPI: button: Lid Switch [LID]
[    4.249208] input: Power Button as /devices/platform/LNXPWRBN:00/input/input14
[    4.255530] ACPI: button: Power Button [PWRF]
[    4.266868] ACPI: AC: AC Adapter [AC] (on-line)
[    4.300979] Adding 25165820k swap on /dev/nvme0n1p2.  Priority:-1 extents:1 across:25165820k SS
[    4.334214] ACPI: battery: Slot [BAT0] (battery present)
[    4.336483] mc: Linux media interface: v0.10
[    4.340053] iwlwifi 0000:00:14.3: enabling device (0000 -> 0002)
[    4.343223] iwlwifi 0000:00:14.3: Detected crf-id 0x3617, cnv-id 0x20000302 wfpm id 0x80000000
[    4.343932] iwlwifi 0000:00:14.3: PCI dev 02f0/0070, rev=0x351, rfid=0x10a100
[    4.344614] iwlwifi 0000:00:14.3: Detected Intel(R) Wi-Fi 6 AX201 160MHz
[    4.348118] Non-volatile memory driver v1.3
[    4.352743] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[    4.355344] iwlwifi 0000:00:14.3: loaded firmware version 77.2753b721.0 QuZ-a0-hr-b0-77.ucode op_mode iwlmvm
[    4.362790] ee1004 0-0051: 512 byte EE1004-compliant SPD EEPROM, read-only
[    4.382855] thinkpad_acpi: ThinkPad ACPI Extras v0.26
[    4.383350] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.384811] thinkpad_acpi: ThinkPad BIOS N2XET45W (1.35 ), EC N2XHT27W
[    4.385411] thinkpad_acpi: Lenovo ThinkPad T14 Gen 1, model 20S1S6D700
[    4.387311] thinkpad_acpi: radio switch found; radios are enabled
[    4.387913] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    4.388489] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    4.392640] videodev: Linux video capture interface: v2.00
[    4.394376] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    4.401092] rmi4_smbus 0-002c: registering SMbus-connected sensor
[    4.425670] thinkpad_acpi: battery 1 registered (start 0, stop 100, behaviours: 0xb)
[    4.429893] ACPI: battery: new hook: ThinkPad Battery Extension
[    4.445105] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input15
[    4.457576] input: PC Speaker as /devices/platform/pcspkr/input/input16
[    4.467823] resource: resource sanity check: requesting [mem 0x00000000fed10000-0x00000000fed15fff], which spans more than PNP0C02:03 [mem 0xfed10000-0xfed13fff]
[    4.468477] caller snb_uncore_imc_init_box+0x86/0xe0 [intel_uncore] mapping multiple BARs
[    4.469890] Bluetooth: Core ver 2.22
[    4.473960] NET: Registered PF_BLUETOOTH protocol family
[    4.476979] Bluetooth: HCI device and connection manager initialized
[    4.477769] Bluetooth: HCI socket layer initialized
[    4.478445] Bluetooth: L2CAP socket layer initialized
[    4.478454] Bluetooth: SCO socket layer initialized
[    4.501043] uvcvideo 1-8:1.0: Found UVC 1.00 device Integrated Camera (04ca:7070)
[    4.511689] proc_thermal 0000:00:04.0: enabling device (0000 -> 0002)
[    4.519012] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360 ms ovfl timer
[    4.519015] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    4.519016] RAPL PMU: hw unit of domain package 2^-14 Joules
[    4.519016] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    4.519017] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    4.519017] RAPL PMU: hw unit of domain psys 2^-14 Joules
[    4.524752] intel_rapl_common: Found RAPL domain package
[    4.524756] intel_rapl_common: Found RAPL domain dram
[    4.528229] iwlwifi 0000:00:14.3: Detected RF HR B3, rfid=0x10a100
[    4.530835] usbcore: registered new interface driver uvcvideo
[    4.535014] rmi4_f01 rmi4-00.fn01: found RMI device, manufacturer: Synaptics, product: TM3471-020, fw id: 3972349
[    4.545322] usbcore: registered new interface driver btusb
[    4.546953] Bluetooth: hci0: Bootloader revision 0.4 build 0 week 30 2018
[    4.547951] rmi_read_register_desc: starting read at addr 0x0054
[    4.547965] Bluetooth: hci0: Device revision is 2
[    4.547967] Bluetooth: hci0: Secure boot is enabled
[    4.547968] Bluetooth: hci0: OTP lock is enabled
[    4.547969] Bluetooth: hci0: API lock is enabled
[    4.547970] Bluetooth: hci0: Debug lock is disabled
[    4.547971] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
[    4.549453] rmi_read_register_desc: size_presence_reg = 4
[    4.554100] rmi_read_register_desc: presence reg: 2b ff 27 00
[    4.554607] mei_hdcp 0000:00:16.0-b638ab7e-94e2-4ea2-a552-d1c54b627f04: bound 0000:00:02.0 (ops i915_hdcp_ops [i915])
[    4.555581] rmi_read_register_desc: advanced addr to 0x0056 (after skipping presence reg)
[    4.569558] Bluetooth: hci0: Found device firmware: intel/ibt-19-0-4.sfi
[    4.569925] rmi_read_register_desc: struct_size = 43
[    4.571053] Bluetooth: hci0: Boot Address: 0x24800
[    4.571512] rmi_read_register_desc: num_registers = 12
[    4.572187] Bluetooth: hci0: Firmware Version: 132-3.24
[    4.576032] rmi_read_register_desc: reading struct_buf from addr 0x0056, size 43
[    4.583621] rmi_struct: 00000000: 01 01 01 01 04 03 2b ff cf 80 00 01 01 0c 03 1a
[    4.583625] rmi_struct: 00000010: 80 9e e2 86 81 80 80 80 81 80 80 00 01 01 06 03
[    4.583626] rmi_struct: 00000020: 00 00 00 00 00 00 00 00 00 00 00
[    4.583628] rmi_read_register_desc: parsed item 0: reg: 0 reg size: 1 subpackets: 1
[    4.583630] rmi_read_register_desc: parsed item 1: reg: 1 reg size: 1 subpackets: 1
[    4.583632] rmi_read_register_desc: parsed item 2: reg: 2 reg size: 4 subpackets: 2
[    4.583633] rmi_read_register_desc: parsed item 3: reg: 3 reg size: 43 subpackets: 12
[    4.583635] rmi_read_register_desc: parsed item 4: reg: 4 reg size: 1 subpackets: 1
[    4.583636] rmi_read_register_desc: parsed item 5: reg: 5 reg size: 12 subpackets: 2
[    4.583638] rmi_read_register_desc: parsed item 6: reg: 6 reg size: 26 subpackets: 11
[    4.583639] rmi_read_register_desc: parsed item 7: reg: 7 reg size: 1 subpackets: 1
[    4.583641] rmi_read_register_desc: parsed item 8: reg: 8 reg size: 6 subpackets: 2
[    4.583642] rmi_read_register_desc: parsed item 9: reg: 9 reg size: 0 subpackets: 0
[    4.583643] rmi_parse_register_desc_item: error: size - offset < 4 (3 - 3 < 4)
[    4.583646] rmi4_f12 rmi4-00.fn12: Failed to read the Query Register Descriptor: -5
[    4.583649] rmi4_f12 rmi4-00.fn12: probe with driver rmi4_f12 failed with error -5
[    4.595070] iwlwifi 0000:00:14.3: base HW address: 40:1c:83:ca:fa:8a
[    4.608735] alg: skcipher: skipping comparison tests for xctr-aes-aesni-avx because xctr(aes-lib) is unavailable
[    4.626672] iwlwifi 0000:00:14.3 wlp0s20f3: renamed from wlan0
[    4.630432] input: Synaptics TM3471-020 as /devices/pci0000:00/0000:00:1f.4/i2c-0/0-002c/rmi4-00/input/input17
[    4.640584] serio: RMI4 PS/2 pass-through port at rmi4-00.fn03
[    4.774240] psmouse serio2: trackpoint: Elan TrackPoint firmware: 0x11, buttons: 3/3
[    4.793900] snd_hda_intel 0000:00:1f.3: enabling device (0004 -> 0006)
[    4.794469] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops intel_audio_component_bind_ops [i915])
[    4.811139] input: TPPS/2 Elan TrackPoint as /devices/pci0000:00/0000:00:1f.4/i2c-0/0-002c/rmi4-00/rmi4-00.fn03/serio2/input/input18
[    4.823505] intel_pmc_core intel_pmc_core.0:  initialized
[    4.841748] intel_rapl_common: Found RAPL domain package
[    4.842378] intel_rapl_common: Found RAPL domain core
[    4.842406] snd_hda_codec_alc269 hdaudioC0D0: ALC257: picked fixup  for PCI SSID 17aa:0000
[    4.843067] intel_rapl_common: Found RAPL domain uncore
[    4.844069] snd_hda_codec_alc269 hdaudioC0D0: autoconfig for ALC257: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    4.844279] intel_rapl_common: Found RAPL domain dram
[    4.845020] snd_hda_codec_alc269 hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.845661] intel_rapl_common: Found RAPL domain psys
[    4.846769] snd_hda_codec_alc269 hdaudioC0D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[    4.847311] snd_hda_codec_alc269 hdaudioC0D0:    mono: mono_out=0x0
[    4.847312] snd_hda_codec_alc269 hdaudioC0D0:    inputs:
[    4.847313] snd_hda_codec_alc269 hdaudioC0D0:      Mic=0x19
[    4.907338] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.3/sound/card0/input19
[    4.909233] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input20
[    4.909301] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input21
[    4.909378] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input22
[    4.909433] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input23
[    4.909481] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input24
[    4.973113] XFS (nvme0n1p4): Mounting V5 Filesystem 900b5e70-35d0-4fdc-9f3f-a87f11b47fa9
[    4.979431] XFS (nvme0n1p4): Ending clean mount
[    5.047558] audit: type=1400 audit(1782511713.830:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="Discord" pid=794 comm="apparmor_parser"
[    5.049166] audit: type=1400 audit(1782511713.830:3): apparmor="STATUS" operation="profile_load" profile="unconfined" name="buildah" pid=800 comm="apparmor_parser"
[    5.051289] audit: type=1400 audit(1782511713.830:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="brave" pid=799 comm="apparmor_parser"
[    5.051292] audit: type=1400 audit(1782511713.830:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="balena-etcher" pid=798 comm="apparmor_parser"
[    5.051294] audit: type=1400 audit(1782511713.830:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="QtWebEngineProcess" pid=796 comm="apparmor_parser"
[    5.051296] audit: type=1400 audit(1782511713.830:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name=4D6F6E676F444220436F6D70617373 pid=795 comm="apparmor_parser"
[    5.051297] audit: type=1400 audit(1782511713.830:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="1password" pid=793 comm="apparmor_parser"
[    5.051299] audit: type=1400 audit(1782511713.831:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="cam" pid=804 comm="apparmor_parser"
[    5.051301] audit: type=1400 audit(1782511713.831:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="busybox" pid=803 comm="apparmor_parser"
[    5.356648] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.356651] Bluetooth: BNEP filters: protocol multicast
[    5.356655] Bluetooth: BNEP socket layer initialized
[    5.431508] block nvme0n1: No UUID available providing old NGUID
[    5.504317] NET: Registered PF_QIPCRTR protocol family
[    5.700094] kauditd_printk_skb: 129 callbacks suppressed
[    5.700098] audit: type=1400 audit(1782511714.483:140): apparmor="DENIED" operation="open" class="file" profile="/usr/sbin/cupsd" name="/etc/paperspecs" pid=1183 comm="cupsd" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
[    5.882454] audit: type=1400 audit(1782511714.665:141): apparmor="DENIED" operation="capable" class="cap" profile="/usr/sbin/cupsd" pid=1183 comm="cupsd" capability=12  capname="net_admin"
[    6.297065] Bluetooth: hci0: Waiting for firmware download to complete
[    6.297976] Bluetooth: hci0: Firmware loaded in 1686597 usecs
[    6.298734] Bluetooth: hci0: Waiting for device to boot
[    6.313092] Bluetooth: hci0: Device booted in 14144 usecs
[    6.314901] Bluetooth: hci0: Found Intel DDC parameters: intel/ibt-19-0-4.ddc
[    6.317164] Bluetooth: hci0: Applying Intel DDC parameters completed
[    6.319037] Bluetooth: hci0: Firmware revision 0.4 build 132 week 3 2024
[    6.321139] Bluetooth: hci0: HCI LE Coded PHY feature bit is set, but its usage is not supported.
[    6.386730] Bluetooth: MGMT ver 1.23
[    6.411046] NET: Registered PF_ALG protocol family
[    6.453778] Bluetooth: RFCOMM TTY layer initialized
[    6.454679] Bluetooth: RFCOMM socket layer initialized
[    6.455274] Bluetooth: RFCOMM ver 1.11
[    9.221345] e1000e 0000:00:1f.6 enp0s31f6: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   13.531972] rfkill: input handler disabled
[   18.392430] rfkill: input handler enabled
[   19.589679] rfkill: input handler disabled
[   21.182733] SCSI subsystem initialized

-- 
-Barry K. Nathan  <barryn@pobox.com>
