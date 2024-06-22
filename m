Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D30155CBD;
	Sat, 22 Jun 2024 15:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719069270; cv=none; b=He0IX7VQZ4K2Gi8zZb8r9pmMpwuz2pjWRWOVMivXfSH3+uw/Mo6kYZqg2AHzj60UiqkW3Hvqe6BKIt8iaJWB4b6ODLjSF8h2dW/m45C+ii3OCaqjsb1zsdkUh5odiiIvrw9/O/rfo+wV8x1XbLbxF69+qMMQOB62WCe43mnHafo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719069270; c=relaxed/simple;
	bh=31L1bW51+/PZMxPY/hV6L9VSGfhxAOumJiD/xpDCH1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PrCrfjWaTVFe+lcNUywk1iw/SHVx4eyTpoDqlYDhZqhVDIT39yqVcYdX78N6DCFIB+cv6cWQZx5RySHogoE7M+u4kk3ENcpE04KaAfMNM7+ibtFdXi5h/drjjBo6Pypr8OhstX81RiCPo4mmqY50VGViSJKMeI0chf9/EV3ub3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b=bmh2hlrU; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b="bmh2hlrU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1719069238; x=1719674038; i=deller@gmx.de;
	bh=31L1bW51+/PZMxPY/hV6L9VSGfhxAOumJiD/xpDCH1k=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=bmh2hlrUclQqXW0kdtw3QIbi/ZcXj/eI27eQKb1lAb3AMVNep52YFgrPbEvix1/D
	 ek4SUvmBWBJBdBDW1pv7ZEokS24bu13zImgksWJ45SV7GtbqbJsN0FN39e5MVdffo
	 7QagwSNIf2+34n0F2ku3AYGm8XfdRrGkNYVfq0i12Mb3O8Uwnpp0uFyt8BqV2u9t7
	 qul27RcacC/8AaJ5iDSMM/momvdqYXT5t5Zsvnf9Emv4aP84FyMQlDqjQMiZRpy7V
	 DXrdpPtcru362Bt6xDCHasfMJFAja9FP9kit3u98s1HaZRM4bpohxHpEy9P9jIvxj
	 G/1N/ORKaH8E4gKBig==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.55] ([109.250.63.133]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MwQXN-1sbc150W5F-00umQG; Sat, 22
 Jun 2024 17:13:58 +0200
Message-ID: <21d5c00f-a373-4173-84e5-33dbd6305b57@gmx.de>
Date: Sat, 22 Jun 2024 17:13:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review [parisc64/C3700 boot
 failures]
To: Guenter Roeck <linux@roeck-us.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org, Oleg Nesterov <oleg@redhat.com>,
 linux-parisc@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240619125556.491243678@linuxfoundation.org>
 <614d86a1-72c4-489b-94f9-fbe553c25f28@roeck-us.net>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <614d86a1-72c4-489b-94f9-fbe553c25f28@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2OTcpGty8ABz5p53n0q/knsE7zls/ggZ+/7/OrB372wriJ61Rsu
 qZdknND3RGH8rnI3Rb2Ysqc3FfcP8Xi3yW+wXp4+R0uboz3fOcadaSDOsTXNbW5/zq+bhNr
 ZLTV3R+2NU4dDlIwBT9eOwxtDmuhoQVlreKZUdYOsPv6ZtQGyIxVAsOB+ve6OD8z01F4DE/
 d4PHTEv4vf691KlnIX+sA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cdL3Dv/J8nE=;o4eDe5Ub9BBlcTPC3qMD/IIDueY
 MnyLrxnCYIz9p3IXaHLrgbpAlig1ju8MgnMVGjsREhJfeLqbWVHrzYZS2yx3BLjOLg2VRg+dt
 JyEWS+v6VpwGZSdkp47H4mhZ33ZwXh2qeU0np2hPT1BOQ2/hg9l7LX5QiXCTm02SXg5lkNnsc
 G3LFrQ9uNWZBFMOMwMsyPB7hvA1wI433APWzn+ql+4djtvT9gUOJWnQ5gcdeAlMYM6kYGWvd5
 yGbPh5sET2+I4a9DgZRxW22YjVQIhzco9ujInGe2XQB9BQ5IT41XdETcwx3zHtUOxGmFCgXqU
 kIX1M68fWH/h48mUBysHapYhIvd4MVk4yEc/o5MubbYWqri5w/SCSyU44I/xZxZ+2UgEEr5sd
 6UUSlSSRQy5ZGOtVgcWt4uvFTBTuY6H/lPRbEGHSxgzbzyoV++ajqyFG1P60sPkzRypMGQl8H
 9vqPX7qq8fAN/vTd7XVrqMGX09/lfGXz2I1o6NCEf6IUjypm2s2TT8YvPfa6wVlBwvdM+5mKP
 f819FR4srZ709dXeqTqxwDN68nAceTuTixftNos4CNCdKsyIXoNXJNE89ldTkVrCmQafieW8x
 toOnmWs4e9dyioXeACnFd3h93F1DF2rHQoDzA+K31459fBBfemPukEBGKuN95Zfqnm6G2QHoy
 Clm7DZ5cBo5P5po3pbU2GAmJPojPhU2NK9xTiWNZFEKCftjeL5Rg2OFEbuuiFDgLtL8lLjUbX
 ceDEpKDKnMcDqsJ5RiUexgX1dH9jq3RjmplMenM+GJST0lXtRXYZF0n0yyZEj2HeaYuPGH+zu
 ay2jLMRXfilGEo015EYCfdoBqOu/ZPxBxK6qW6WAvDTbc=

On 6/22/24 16:58, Guenter Roeck wrote:
> [ Copying parisc maintainers - maybe they can test on real hardware ]
>
> On 6/19/24 05:54, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.95 release.
>> There are 217 patches in this series, all will be posted as a response
>> to this one.=C2=A0 If anyone has any issues with these being applied, p=
lease
>> let me know.
>>
>> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
>> Anything received after that time might be too late.
>>
> ...
>> Oleg Nesterov <oleg@redhat.com>
>> =C2=A0=C2=A0=C2=A0=C2=A0 zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL =
along with TIF_SIGPENDING
>>
>
> I can not explain it, but this patch causes all my parisc64 (C3700)
> boot tests to crash. There are lots of memory corruption BUGs such as
>
> [=C2=A0=C2=A0=C2=A0 0.000000] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [=C2=A0=C2=A0=C2=A0 0.000000] BUG kmalloc-96 (Not tainted): Padding over=
written. 0x0000000043411dd0-0x0000000043411f5f @offset=3D3536
>
> ultimately followed by
>
> [=C2=A0=C2=A0=C2=A0 0.462562] Unaligned handler failed, ret =3D -14
> ...
> [=C2=A0=C2=A0=C2=A0 0.469160]=C2=A0 IAOQ[0]: idr_alloc_cyclic+0x48/0x118
> [=C2=A0=C2=A0=C2=A0 0.469372]=C2=A0 IAOQ[1]: idr_alloc_cyclic+0x54/0x118
> [=C2=A0=C2=A0=C2=A0 0.469548]=C2=A0 RP(r2): __kernfs_new_node.constprop.=
0+0x160/0x420
> [=C2=A0=C2=A0=C2=A0 0.469782] Backtrace:
> [=C2=A0=C2=A0=C2=A0 0.469928]=C2=A0 [<00000000404af108>] __kernfs_new_no=
de.constprop.0+0x160/0x420
> [=C2=A0=C2=A0=C2=A0 0.470285]=C2=A0 [<00000000404b0cac>] kernfs_new_node=
+0xbc/0x118
> [=C2=A0=C2=A0=C2=A0 0.470523]=C2=A0 [<00000000404b158c>] kernfs_create_e=
mpty_dir+0x54/0xf0
> [=C2=A0=C2=A0=C2=A0 0.470756]=C2=A0 [<00000000404b665c>] sysfs_create_mo=
unt_point+0x4c/0xb0
> [=C2=A0=C2=A0=C2=A0 0.470996]=C2=A0 [<00000000401181cc>] cgroup_init+0x5=
b4/0x738
> [=C2=A0=C2=A0=C2=A0 0.471213]=C2=A0 [<0000000040102220>] start_kernel+0x=
1238/0x1308
> [=C2=A0=C2=A0=C2=A0 0.471429]=C2=A0 [<0000000040107c90>] start_parisc+0x=
188/0x1d0
> ...
> [=C2=A0=C2=A0=C2=A0 0.474956] Kernel panic - not syncing: Attempted to k=
ill the idle task!
> SeaBIOS wants SYSTEM RESET.
>
> This is with qemu v9.0.1.

Just to be sure, did you tested the same kernel on physical hardware as we=
ll?

Please note, that 64-bit hppa (C3700) support in qemu was just recently ad=
ded
and is still considered experimental.
So, maybe it's not a bug in the source, but in qemu...?!?

> Reverting this patch fixes the problem (I tried several times to be sure
> since I don't see the connection). I don't see the problem in any other
> branch. Bisect log is attached for reference.
>
> Guenter
>
> ---
> # bad: [a6398e37309000e35cedb5cc328a0f8d00d7d7b9] Linux 6.1.95
> # good: [eb44d83053d66372327e69145e8d2fa7400a4991] Linux 6.1.94
> git bisect start 'HEAD' 'v6.1.94'
> # good: [f17443d52d805c9a7fab5e67a4e8b973626fe1cd] cachefiles: resend an=
 open request if the read request's object is closed
> git bisect good f17443d52d805c9a7fab5e67a4e8b973626fe1cd
> # good: [cc09e1d3519feab823685f4297853d468f44549d] iio: imu: inv_icm4260=
0: delete unneeded update watermark call
> git bisect good cc09e1d3519feab823685f4297853d468f44549d
> # good: [b7b6bc60edb2132a569899bcd9ca099a0556c6ee] intel_th: pci: Add Gr=
anite Rapids SOC support
> git bisect good b7b6bc60edb2132a569899bcd9ca099a0556c6ee
> # good: [35e395373ecd14b64da7d54f565927a9368dcf20] mptcp: pm: update add=
_addr counters after connect
> git bisect good 35e395373ecd14b64da7d54f565927a9368dcf20
> # good: [29d35f0b53d4bd82ebc37c500a8dd73da61318ff] serial: 8250_dw: fall=
 back to poll if there's no interrupt
> git bisect good 29d35f0b53d4bd82ebc37c500a8dd73da61318ff
> # good: [ea25a4c0de5700928c7fd0aa789eee39a457ba95] misc: microchip: pci1=
xxxx: Fix a memory leak in the error handling of gp_aux_bus_probe()
> git bisect good ea25a4c0de5700928c7fd0aa789eee39a457ba95
> # good: [e44999ec0b49dca9a9a2090c5432d893ea4f8d20] i2c: designware: Fix =
the functionality flags of the slave-only interface
> git bisect good e44999ec0b49dca9a9a2090c5432d893ea4f8d20
> # bad: [edd2754a62bee8d97b4808a15de024f66a1ddccf] zap_pid_ns_processes: =
clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING
> git bisect bad edd2754a62bee8d97b4808a15de024f66a1ddccf
> # first bad commit: [edd2754a62bee8d97b4808a15de024f66a1ddccf] zap_pid_n=
s_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING
>
>

