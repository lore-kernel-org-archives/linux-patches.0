Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE02B3EF0D1
	for <patches@lists.linux.dev>; Wed, 27 May 2026 10:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779878743; cv=none; b=EkE0TsorRUsyCfO3dm8GSgulLbNxoQzZPLd1bkosTIx8JbGIpHhoI2ZtSXRnZbY3WCWUZk3NsY3veoSM2ixWvl0DKkdiu/lbb9kzbtjlBdaoMO1S8pHv9UUml5C1hTZME1Qw26qZe+eX+zyXZCV6EqSJrNb/2ymdOGbMgnB4PHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779878743; c=relaxed/simple;
	bh=OjgVdxfIapTmIVZ4E6ItV4aTR3p9FAnYA9UXpwXjjJM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=qJyZwVCL5nY4YV6JG2GeU8l8twoWY5BQah0fRG8KA7pfsTUqeMqs4CSbbE+XENPHlBiM8A7KLFxiMDxhTUcyh086XlpmxOjWkrzJKgaXOvuH/x951pbGP7uo3MXA+M0tYxObhjABDLF+rkoZZ6uDgeYrbve+Hf2a5IAxqXbCqLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=cW6Xjxgt; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="cW6Xjxgt"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FavTVuWYb8sCNd5Y1V9N2YKOs48UrbTxHozMjLISuwo=;
	b=cW6Xjxgtxgrs1Ej+gekXkr9t+GB79SFgVC7EtfumYSan6OkmiqGG8wkrSJc9F6uUoLoT0ps/e
	YzjdBIS580HZEU4rYb9KdJyAQEVyXm2x/bt6f3Rq0BbcMnP86XhmSYaOm1xG8iGHqCz4F33Yf+2
	BpI4kxJd4GG5hLO1TPmjoco=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gQR0D6dyjzKm4D;
	Wed, 27 May 2026 18:37:48 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id 179A3402AB;
	Wed, 27 May 2026 18:45:37 +0800 (CST)
Received: from [10.174.178.79] (10.174.178.79) by
 kwepemj500018.china.huawei.com (7.202.194.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 May 2026 18:45:36 +0800
Message-ID: <8f4eda80-bae9-4a68-b983-0acd53d2569f@huawei.com>
Date: Wed, 27 May 2026 18:45:34 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 28/70] mptcp: fix soft lockup in mptcp_recvmsg()
From: Li Xiasong <lixiasong1@huawei.com>
To: Jiping Ma <jiping.ma2@windriver.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"kuba@kernel.org" <kuba@kernel.org>, "matttbe@kernel.org"
	<matttbe@kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "weiyongjun (A)"
	<weiyongjun1@huawei.com>, yuehaibing <yuehaibing@huawei.com>, zhangchangzhong
	<zhangchangzhong@huawei.com>
References: <52ea906c-0953-4d2c-98ee-b873ecc6a075@huawei.com>
 <20260527030537.1305489-1-jiping.ma2@windriver.com>
 <b01d1b99-b988-456b-8e6c-ac3868fdb03b@huawei.com>
In-Reply-To: <b01d1b99-b988-456b-8e6c-ac3868fdb03b@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj500018.china.huawei.com (7.202.194.48)

Hi,

One clarification to my previous email:

The `v6.18.32` kernel used in my test was built with commit
`58b58b9ba89c` ("mptcp: fix soft lockup in mptcp_recvmsg()") reverted.
So the reproduction result I reported for `v6.18.32` is based on a
kernel without that patch.

Regards,
Li Xiasong

On 5/27/2026 6:22 PM, Li Xiasong wrote:
> Hi, Jiping
> 
> On 5/27/2026 11:05 AM, Jiping Ma wrote:
>> Hi, Xiasong
>>
>> Could you share how to reproduce the issue?
>> I used the following code to reproduce it, and do the test in v6.18.32. but the test results are the same with and without the fix(I revert the commit 58b58b9ba89c43914eea90c18928e51852d10c24).
>> The client task will be waked up after 10 minutes.  There is not soft lockup.
>>
> 
> Thanks for sharing the reproducer.
> 
> Your test program itself looks fine to me, and I can reproduce the issue
> with the reproducer you provided in my test environment.[0]
> 
> I think the reproduction result depends on the kernel preemption model.
> The issue is easier to trigger with a non-preemptible kernel
> (e.g. `PREEMPT_NONE`). On other preemption configurations, it may be
> harder to reproduce, but the program can still be observed consuming
> nearly 100% system CPU. So the same test can show different behavior
> under different `CONFIG_PREEMPT*` settings.
> 
> Also, if you want to reproduce this on `6.6.y` or `6.12.y`, based on
> the previous analysis, have the sender transmit two packets with an
> interval between them.
> 
> Hope this helps.
> 
> [0] Relevant dmesg log:
> Linux ubuntu 6.18.32+ #15 SMP PREEMPT_DYNAMIC Wed May 27 15:25:52 CST 2026 x86_64 x86_64 x86_64 GNU/Linux
> root@ubuntu:~# [  960.743413] watchdog: BUG: soft lockup - CPU#5 stuck for 261s! [client:1260]
> [  960.743433] Modules linked in:
> [  960.743463] CPU: 5 UID: 0 PID: 1260 Comm: client Not tainted 6.18.32+ #15 PREEMPT(none)
> [  960.743469] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [  960.743474] RIP: 0010:_raw_spin_lock_bh+0x1b/0x60
> [  960.743518] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 65 81 05 d0 a2 a1 01 01 02 00 00 31 c0 ba 01 00 00 00 f0 0f b1 17 <75> 1b 31 c0 31 d2 31 c9 31 f6 31 ff 45 31 c0 45 31 c9 45 31 d2 45
> [  960.743521] RSP: 0018:ffffc9000259fb08 EFLAGS: 00000246
> [  960.743524] RAX: 0000000000000000 RBX: ffff888106efc480 RCX: 0000000000000000
> [  960.743529] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff888106efc5c0
> [  960.743531] RBP: ffffc9000259fb68 R08: 0000000000000000 R09: 0000000000000000
> [  960.743533] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  960.743535] R13: ffff888106efc5c0 R14: ffff888106efc528 R15: 0000000000000000
> [  960.743537] FS:  000079482a7b7740(0000) GS:ffff8881b70e7000(0000) knlGS:0000000000000000
> [  960.743540] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  960.743542] CR2: 00005a8d794c3008 CR3: 00000001033ea000 CR4: 00000000000006f0
> [  960.743547] Call Trace:
> [  960.743550]  <TASK>
> [  960.743552]  ? sk_wait_data+0xc2/0x1a0
> [  960.743564]  ? __pfx_woken_wake_function+0x10/0x10
> [  960.743571]  mptcp_recvmsg+0x623/0x9a0
> [  960.743578]  ? __wake_up+0x45/0x70
> [  960.743582]  inet_recvmsg+0x124/0x130
> [  960.743588]  ? apparmor_socket_recvmsg+0x25/0x40
> [  960.743595]  ? security_socket_recvmsg+0x1a9/0x1d0
> [  960.743602]  sock_recvmsg+0xb7/0xc0
> [  960.743608]  __sys_recvfrom+0xd2/0x170
> [  960.743612]  ? ksys_write+0x69/0xf0
> [  960.743618]  ? __x64_sys_write+0x19/0x30
> [  960.743622]  ? x64_sys_call+0x18fc/0x2760
> [  960.743628]  ? do_syscall_64+0xb8/0x1300
> [  960.743635]  ? do_syscall_64+0xb8/0x1300
> [  960.743640]  __x64_sys_recvfrom+0x24/0x40
> [  960.743642]  x64_sys_call+0x2694/0x2760
> [  960.743646]  do_syscall_64+0x80/0x1300
> [  960.743650]  ? count_memcg_events+0xed/0x1e0
> [  960.743655]  ? handle_mm_fault+0x210/0x2f0
> [  960.743661]  ? do_user_addr_fault+0x300/0x8d0
> [  960.743666]  ? irqentry_exit_to_user_mode+0x2e/0x330
> [  960.743670]  ? irqentry_exit+0x43/0x50
> [  960.743672]  ? exc_page_fault+0x93/0x1b0
> [  960.743675]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  960.743678] RIP: 0033:0x79482a49eba6
> [  960.743691] Code: 00 00 48 8b 15 53 12 17 00 64 89 02 48 c7 c2 ff ff ff ff 48 8b 5d f8 c9 48 89 d0 c3 0f 1f 84 00 00 00 00 00 48 8b 45 10 0f 05 <48> 63 d0 3d 00 f0 ff ff 77 10 48 8b 5d f8 48 89 d0 c9 c3 0f 1f 80
> [  960.743693] RSP: 002b:00007ffd26c7bdc0 EFLAGS: 00000202 ORIG_RAX: 000000000000002d
> [  960.743696] RAX: ffffffffffffffda RBX: 000079482a7b7740 RCX: 000079482a49eba6
> [  960.743698] RDX: 0000000000000400 RSI: 00007ffd26c7be20 RDI: 0000000000000003
> [  960.743699] RBP: 00007ffd26c7bdd0 R08: 0000000000000000 R09: 0000000000000000
> [  960.743701] R10: 0000000000000102 R11: 0000000000000202 R12: 0000000000000001
> [  960.743702] R13: 0000000000000000 R14: 00005a8d75ae6d78 R15: 000079482a806000
> [  960.743707]  </TASK>

