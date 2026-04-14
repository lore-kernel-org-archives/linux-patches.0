Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5697242D9B
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 01:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776130214; cv=none; b=NCDj23RPGLufhVLOGcoaobHBhW94LcO+BwXnDkTFKGFjOXYSMZOM4pdZHiunuiakkXEwFXmzS7N3AkGT4ZAFM8LiyPlDHc3cialTYlHkUWZTLxDU3OzJ+azFVcORKfrdb4xJ2/y/+OqhjRmuUnN1xzzNfs8XWQjZolVc2yAS3JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776130214; c=relaxed/simple;
	bh=5d55Sby67zAEYxk/ZlCGmEDM6wEznQfAbF+exNlILNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jWqeAiFHj86ZNHkFEelv6UYWykk+D6Vqh/XV5A0YfoRF90X4To/90BL0KuYwEtOXQD+egRIYiXQr8/FCgRD7mWd3dLlSuHHq1mRp1y19waa5e2iv8kLyTUXm3W0ZYvGYq9PB8e1slKI4Ha48S1/1WTRMCk2s10d5yv8fcNuR4fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=qVinjA+G; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="qVinjA+G"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=a2lsAbL/CAN5MRMomF38fQZ/Gb6tGyKqmrVF9Fctvfs=;
	b=qVinjA+G0DIiCayRAsJTmi3Vz9GSSya5RFuqY4oi91XLDrdGb/p/eELTzkvS61swnLkSJfyZh
	sw/NGaYts3AK9eJXchfUicPqsh6+LpqiNmxe0zMWtd/EOftP0n1LYcYcg2WFTPxJbHRDFkOvV7I
	R7G00SngLzUb/jmjnoxXQ0c=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fvml104gtzpSvH;
	Tue, 14 Apr 2026 09:23:57 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id 272364056E;
	Tue, 14 Apr 2026 09:30:07 +0800 (CST)
Received: from [10.174.178.79] (10.174.178.79) by
 kwepemj500018.china.huawei.com (7.202.194.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Apr 2026 09:30:06 +0800
Message-ID: <52ea906c-0953-4d2c-98ee-b873ecc6a075@huawei.com>
Date: Tue, 14 Apr 2026 09:30:06 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 14/50] mptcp: fix soft lockup in mptcp_recvmsg()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <patches@lists.linux.dev>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, <stable@vger.kernel.org>,
	<zhangchangzhong@huawei.com>, <weiyongjun1@huawei.com>,
	<yuehaibing@huawei.com>
References: <20260413155724.497323914@linuxfoundation.org>
 <20260413155725.042518976@linuxfoundation.org>
From: Li Xiasong <lixiasong1@huawei.com>
In-Reply-To: <20260413155725.042518976@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemj500018.china.huawei.com (7.202.194.48)

Hi Greg,

On 4/14/2026 12:00 AM, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 

Sorry for the delayed reply. Please drop this patch from 6.6.y - the fix
targets mptcp_recvmsg() soft lockup, but the receive queue handling differs
between mainline and 6.6:

  - Mainline: both MSG_PEEK data access and sk_wait_data use
sk->sk_receive_queue
  - 6.6.y: MSG_PEEK data access uses msk->receive_queue, while sk_wait_data
           waits on sk->sk_receive_queue

This structural difference means the fix is not applicable to 6.6.y.

Note that the soft lockup issue still exists in 6.6. A different approach
may be needed for this branch.

Thanks,
Li Xiasong

> ------------------
> 
> From: Li Xiasong <lixiasong1@huawei.com>
> 
> commit 5dd8025a49c268ab6b94d978532af3ad341132a7 upstream.
> 
> syzbot reported a soft lockup in mptcp_recvmsg() [0].
> 
> When receiving data with MSG_PEEK | MSG_WAITALL flags, the skb is not
> removed from the sk_receive_queue. This causes sk_wait_data() to always
> find available data and never perform actual waiting, leading to a soft
> lockup.
> 
> Fix this by adding a 'last' parameter to track the last peeked skb.
> This allows sk_wait_data() to make informed waiting decisions and prevent
> infinite loops when MSG_PEEK is used.
> 
> [0]:
> watchdog: BUG: soft lockup - CPU#2 stuck for 156s! [server:1963]
> Modules linked in:
> CPU: 2 UID: 0 PID: 1963 Comm: server Not tainted 6.19.0-rc8 #61 PREEMPT(none)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:sk_wait_data+0x15/0x190
> Code: 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 41 56 41 55 41 54 49 89 f4 55 48 89 d5 53 48 89 fb <48> 83 ec 30 65 48 8b 05 17 a4 6b 01 48 89 44 24 28 31 c0 65 48 8b
> RSP: 0018:ffffc90000603ca0 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: ffff888102bf0800 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffffc90000603d18 RDI: ffff888102bf0800
> RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000101
> R10: 0000000000000000 R11: 0000000000000075 R12: ffffc90000603d18
> R13: ffff888102bf0800 R14: ffff888102bf0800 R15: 0000000000000000
> FS:  00007f6e38b8c4c0(0000) GS:ffff8881b877e000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055aa7bff1680 CR3: 0000000105cbe000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  mptcp_recvmsg+0x547/0x8c0 net/mptcp/protocol.c:2329
>  inet_recvmsg+0x11f/0x130 net/ipv4/af_inet.c:891
>  sock_recvmsg+0x94/0xc0 net/socket.c:1100
>  __sys_recvfrom+0xb2/0x130 net/socket.c:2256
>  __x64_sys_recvfrom+0x1f/0x30 net/socket.c:2267
>  do_syscall_64+0x59/0x2d0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e arch/x86/entry/entry_64.S:131
> RIP: 0033:0x7f6e386a4a1d
> Code: 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8d 05 f1 de 2c 00 41 89 ca 8b 00 85 c0 75 20 45 31 c9 45 31 c0 b8 2d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 6b f3 c3 66 0f 1f 84 00 00 00 00 00 41 56 41
> RSP: 002b:00007ffc3c4bb078 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
> RAX: ffffffffffffffda RBX: 000000000000861e RCX: 00007f6e386a4a1d
> RDX: 00000000000003ff RSI: 00007ffc3c4bb150 RDI: 0000000000000004
> RBP: 00007ffc3c4bb570 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000103 R11: 0000000000000246 R12: 00005605dbc00be0
> R13: 00007ffc3c4bb650 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> Fixes: 8e04ce45a8db ("mptcp: fix MSG_PEEK stream corruption")
> Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
> Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> Link: https://patch.msgid.link/20260330120335.659027-1-lixiasong1@huawei.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [ Conflicts in protocol.c, because commit bc68b0efa1bf ("mptcp: move the
>   whole rx path under msk socket lock protection") and commit
>   d88b2127b242 ("mptcp: add eat_recv_skb helper") (with some
>   dependences) are not in this version. These conflicts were in the
>   context, and not related to this fix. ]
> Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/mptcp/protocol.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -1960,7 +1960,7 @@ static int __mptcp_recvmsg_mskq(struct m
>  				struct msghdr *msg,
>  				size_t len, int flags, int copied_total,
>  				struct scm_timestamping_internal *tss,
> -				int *cmsg_flags)
> +				int *cmsg_flags, struct sk_buff **last)
>  {
>  	struct sk_buff *skb, *tmp;
>  	int total_data_len = 0;
> @@ -1976,6 +1976,7 @@ static int __mptcp_recvmsg_mskq(struct m
>  			/* skip already peeked skbs */
>  			if (total_data_len + data_len <= copied_total) {
>  				total_data_len += data_len;
> +				*last = skb;
>  				continue;
>  			}
>  
> @@ -2016,6 +2017,8 @@ static int __mptcp_recvmsg_mskq(struct m
>  			WRITE_ONCE(msk->rmem_released, msk->rmem_released + skb->truesize);
>  			__skb_unlink(skb, &msk->receive_queue);
>  			__kfree_skb(skb);
> +		} else {
> +			*last = skb;
>  		}
>  
>  		if (copied >= len)
> @@ -2237,10 +2240,12 @@ static int mptcp_recvmsg(struct sock *sk
>  		cmsg_flags = MPTCP_CMSG_INQ;
>  
>  	while (copied < len) {
> +		struct sk_buff *last = NULL;
>  		int err, bytes_read;
>  
>  		bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied, flags,
> -						  copied, &tss, &cmsg_flags);
> +						  copied, &tss, &cmsg_flags,
> +						  &last);
>  		if (unlikely(bytes_read < 0)) {
>  			if (!copied)
>  				copied = bytes_read;
> @@ -2298,7 +2303,7 @@ static int mptcp_recvmsg(struct sock *sk
>  
>  		pr_debug("block timeout %ld\n", timeo);
>  		mptcp_cleanup_rbuf(msk, copied);
> -		err = sk_wait_data(sk, &timeo, NULL);
> +		err = sk_wait_data(sk, &timeo, last);
>  		if (err < 0) {
>  			err = copied ? : err;
>  			goto out_err;
> 
> 
