Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB7E3009EE
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 09:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774429450; cv=none; b=K4O4v7m+EEI5XiTL8X4HSnxpkM1r8SlfkjtkOfharhnve5Gpk8IYJKKYgeqMNYi+udesL7hiMw6u9aKMbqKXema3SiZylCRl2QAnSvEnMq6Ir6Zh/65iQSh88V4RaZib5P1TGuusTCskNe0kqvb7W13q7NJsbtDjkmpLYmW388E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774429450; c=relaxed/simple;
	bh=vzi6NHBBrXn9qk2xAXLb2l6r5lQDVMm9KrsKz9ZitEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NJwru3vYw52GW12Q6C5AzbX5cw0uAL85zFqKtsqQlhbrTMeSeXumk7mVId0/AD2LKOpk8LxijjDwDsNLYlLgKV8ay01Cd7+kVVZ/GsHQWt3xIScDpjAKmmuSoKCKsFiNgIDka6TvZ/RLuTnDeHqjePmZ+qHnYcbr7uI1wnaIVbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Q3so9jNA; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Q3so9jNA"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=I+L+8iy/GgS091Zx+7OYvPcU5cy2o7r0H6J5dVMu4qw=;
	b=Q3so9jNA2V0VLF3oSPdXoh3uBoJWqdFVTpaY1zy4p/sqG+Xzxdhm577v7I1wgFc5La4bE89jb
	YFIHtp0Br5d3akp4iwe49Yeu6cj12j1T5CzENKI8aByLI9V5fPC+zvph/herH+xvgPGWOrnn/yy
	1QUEk3Zo9UMPddSWwzH4ojQ=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fggml2BS4z12LCr;
	Wed, 25 Mar 2026 16:58:31 +0800 (CST)
Received: from kwepemr100006.china.huawei.com (unknown [7.202.194.218])
	by mail.maildlp.com (Postfix) with ESMTPS id 9C80640538;
	Wed, 25 Mar 2026 17:03:58 +0800 (CST)
Received: from [10.174.179.92] (10.174.179.92) by
 kwepemr100006.china.huawei.com (7.202.194.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 25 Mar 2026 17:03:57 +0800
Message-ID: <d22ffe9f-8cd5-41ee-9da1-d0d2800a5f16@huawei.com>
Date: Wed, 25 Mar 2026 17:03:37 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
To: Francesco Dolcini <francesco@dolcini.it>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <sr@sladewatkins.com>, Jan Kara
	<jack@suse.cz>, Brian Foster <bfoster@redhat.com>, Matthew Wilcox
	<willy@infradead.org>, Gou Hao <gouhao@uniontech.com>, Theodore Ts'o
	<tytso@mit.edu>, Kemeng Shi <shikemeng@huaweicloud.com>, Zhang Yi
	<yi.zhang@huawei.com>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260324073447.GA5062@francesco-nb>
From: Sun Yongjian <sunyongjian1@huawei.com>
In-Reply-To: <20260324073447.GA5062@francesco-nb>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100006.china.huawei.com (7.202.194.218)



在 2026/3/24 15:34, Francesco Dolcini 写道:
> Hi Greg,
> 
> On Mon, Mar 23, 2026 at 02:39:42PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.167 release.
>> There are 481 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
>> Anything received after that time might be too late.
> 
> Not ok
> 
> I have an ext4 Oops on arm
> 
> [   27.908560] 8<--- cut here ---
> [   27.911697] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> [   27.919880] [00000000] *pgd=00000000
> [   27.923482] Internal error: Oops: 5 [#1] SMP ARM
> [   27.928117] Modules linked in: 8021q cfg80211 imx_sdma coda_vpu v4l2_jpeg imx_vdoa dw_hdmi_ahb_audio fuse
> [   27.937784] CPU: 1 PID: 736 Comm: tar Not tainted 6.1.167-rc1-6.8.6-devel+git.67c872a868ac #1
> [   27.946342] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [   27.952889] PC is at ext4_mb_load_buddy_gfp+0xac/0x438
> [   27.958083] LR is at 0xe0f39b18
> [   27.961248] pc : [<c035bc54>]    lr : [<e0f39b18>]    psr: 000f0013
> [   27.967536] sp : e0f39b60  ip : 00000000  fp : c43046f8
> [   27.972781] r10: 00000001  r9 : 00000c40  r8 : 00000016
> [   27.978025] r7 : 00000016  r6 : c2b24000  r5 : e0f39bcc  r4 : 00000000
> [   27.984574] r3 : d21b9611  r2 : d21b9611  r1 : c4277e40  r0 : 00000000
> [   27.991123] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [   27.998287] Control: 10c5387d  Table: 131c804a  DAC: 00000051
> [   28.004050] Register r0 information: NULL pointer
> [   28.008787] Register r1 information: slab radix_tree_node start c4277e40 pointer offset 0
> [   28.017024] Register r2 information: 0-page vmalloc region starting at 0xd0000000 allocated at iotable_init+0x0/0xf4
> [   28.027619] Register r3 information: 0-page vmalloc region starting at 0xd0000000 allocated at iotable_init+0x0/0xf4
> [   28.038199] Register r4 information: NULL pointer
> [   28.042930] Register r5 information: 2-page vmalloc region starting at 0xe0f38000 allocated at kernel_clone+0x88/0x338
> [   28.053693] Register r6 information: slab kmalloc-1k start c2b24000 pointer offset 0 size 1024
> [   28.062369] Register r7 information: non-paged memory
> [   28.067449] Register r8 information: non-paged memory
> [   28.072527] Register r9 information: non-paged memory
> [   28.077605] Register r10 information: non-paged memory
> [   28.082771] Register r11 information: slab ext4_inode_cache start c4304620 pointer offset 216 size 60
> [   28.092056] Register r12 information: NULL pointer
> [   28.096875] Process tar (pid: 736, stack limit = 0x116a0825)
> [   28.102562] Stack: (0xe0f39b60 to 0xe0f3a000)
> [   28.106955] 9b60: e0f39b5c 00000000 c0c1b414 c2916000 c2b24000 c42e55d8 c2b24000 c29162a8
> [   28.115162] 9b80: 00000048 c4589000 0000000b c035f804 00000001 00000001 00000001 c2b24000
> [   28.123368] 9ba0: c2916000 0000001d 00000010 00000000 00000009 00000024 00000000 00000000
> [   28.131573] 9bc0: c2b92300 00000001 00000000 00000000 e0f39d30 00000000 c2b92300 c42e55d8
> [   28.139778] 9be0: c2b24000 0000000c 0000000b d21b9611 00000000 c4589000 c2b24000 e0f39d30
> [   28.147983] 9c00: 00000001 c2916000 00000000 c42fbf60 00000001 c03628c0 00000001 00000000
> [   28.156188] 9c20: e0f39d14 c2b92300 00000001 00000000 00000029 00000000 00000000 c03328b4
> [   28.164393] 9c40: 00000000 00000000 c4886a60 c033be7c 00000000 c0294008 00000000 00000000
> [   28.172597] 9c60: c48867d0 d21b9611 c2b92300 00000001 00000001 c2916000 00000000 00000000
> [   28.180802] 9c80: 00000000 c48868a8 e0f39e10 c0336970 e0f39d24 47ffffff c2b24000 00000000
> [   28.189007] 9ca0: c48868a8 00000000 e0f39d88 c0330844 00000000 00000001 c2b92300 c42fbf60
> [   28.197212] 9cc0: e0f39d88 ffffffff 00000000 ffffffff c308da80 00000000 00000001 c308da98
> [   28.205416] 9ce0: 00000000 c03362f4 ffffffff ffffffff 00000008 00000010 00000000 cf358340
> [   28.213620] 9d00: c42fbf60 00000000 c0c1b2c8 00000000 c308da80 00000000 00000000 c4540001
> [   28.221825] 9d20: 00000000 c0395154 c2b92300 000009dd c48868a8 00000001 00000000 00000000
> [   28.230029] 9d40: 00000000 c034c0c0 00000000 00000000 00000000 00000000 00000000 00000000
> [   28.238234] 9d60: 00000000 00000000 c4886a60 d21b9611 00000020 e0f39e10 c48868a8 00000000
> [   28.246438] 9d80: 00000001 c42fbf60 c2b92300 00001000 00000000 c034ccdc 00000000 00000000
> [   28.254642] 9da0: 00000000 00000000 c42fbf60 c4886890 00000000 00000000 c48868a8 00000000
> [   28.262847] 9dc0: c4886a60 00000000 ffffffff e0f39e70 ffffffff 47ffffff 00000000 d21b9611
> [   28.271052] 9de0: c2b92300 c48868a8 c48868a8 c42fbf60 c2b92300 00000000 00000001 00001000
> [   28.279256] 9e00: 00000000 c034dc98 c48868a8 c038d7f4 00000000 00000000 00000000 00000001
> [   28.287461] 9e20: 00000000 cf358300 00000000 d21b9611 c48868f0 c48868a8 00000000 c42fbf60
> [   28.295666] 9e40: c2b92300 e0f39ec0 00000001 c034ded0 c48868a8 00000000 c42fbf60 c0367fec
> [   28.303871] 9e60: 0000001d 000041ed 00000000 c42ffcd8 00000000 00000000 00000000 00000001
> [   28.312076] 9e80: 00000000 c48868a8 69c15bf6 d21b9611 119d9a05 c48868a8 c2b24000 00000000
> [   28.320281] 9ea0: 00000000 c42fbf60 c2b92300 c036e134 00000000 c036b544 00000000 c43043e8
> [   28.328486] 9ec0: 00000000 d21b9611 0000000c c48868a8 c48868a8 c42fbf60 c43043e8 c0c1bc80
> [   28.336690] 9ee0: 000041ed c2b92300 c120d3e8 c036e410 c42ffcd8 00000000 00000000 00000000
> [   28.344895] 9f00: 00000004 00000bfa 00000027 c02a9b20 00000000 00000027 c42ffcd8 c42ffcc0
> [   28.353100] 9f20: 00000000 d21b9611 00000002 c43043e8 c036e298 c120d3e8 c42ffcc0 00000000
> [   28.361305] 9f40: 00000002 c2b92300 be83b824 c02ab1a0 c34dc010 d21b9611 01db0478 c34dc000
> [   28.369510] 9f60: c42ffcc0 c34dc000 ffffff9c 000041ed 00000000 c02b0268 be83b824 c20c6910
> [   28.377715] 9f80: c42e2a18 d21b9611 01db0478 01db01f8 00000000 00000027 c01002e8 c2b92300
> [   28.385920] 9fa0: 00000027 c0100080 01db0478 01db01f8 01db0478 000041ed 00000020 00004000
> [   28.394124] 9fc0: 01db0478 01db01f8 00000000 00000027 00000000 00000007 01db01f8 be83b824
> [   28.402330] 9fe0: 00545dbc be83b754 004f9b0b b6e5ff98 600f0030 01db0478 00000000 00000000
> [   28.410535]  ext4_mb_load_buddy_gfp from ext4_mb_regular_allocator+0x318/0xee0
> [   28.417826]  ext4_mb_regular_allocator from ext4_mb_new_blocks+0x724/0x1000
> [   28.424847]  ext4_mb_new_blocks from ext4_ext_map_blocks+0x7d8/0x1600
> [   28.431351]  ext4_ext_map_blocks from ext4_map_blocks+0x21c/0x604
> [   28.437492]  ext4_map_blocks from ext4_getblk+0x68/0x298
> [   28.442844]  ext4_getblk from ext4_bread+0x8/0xa0
> [   28.447587]  ext4_bread from ext4_append+0x98/0x1b4
> [   28.452514]  ext4_append from ext4_init_new_dir+0x7c/0x1e0
> [   28.458061]  ext4_init_new_dir from ext4_mkdir+0x178/0x384
> [   28.463608]  ext4_mkdir from vfs_mkdir+0xcc/0x168
> [   28.468364]  vfs_mkdir from do_mkdirat+0x80/0x104
> [   28.473107]  do_mkdirat from ret_fast_syscall+0x0/0x54
> [   28.478285] Exception stack(0xe0f39fa8 to 0xe0f39ff0)
> [   28.483367] 9fa0:                   01db0478 01db01f8 01db0478 000041ed 00000020 00004000
> [   28.491573] 9fc0: 01db0478 01db01f8 00000000 00000027 00000000 00000007 01db01f8 be83b824
> [   28.499775] 9fe0: 00545dbc be83b754 004f9b0b b6e5ff98
> [   28.504856] Code: ebfbad72 e3700a01 e1a04000 8a00005d (e5903000)
> [   28.511102] ---[ end trace 0000000000000000 ]---
> 
> 
> The bug is not systematic, and I do not see myself having the time to
> bisect it in the next couple of days (it was reproduced by our CI / Lava
> infrastructure).
> 
> I have added some of the ext4 folks to this thread, in case they know
> how to help.
> 
> Francesco
> 

Actually, this concurrency issue stems from mainline patch 060913999d7a 
(part of tags/v6.11-rc1), which reordered the migrate mapping and folio 
copy operations. Since 6.1 lacks this patch, the race window doesn't 
exist there. My apologies for the missing Fixes tag.

