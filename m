Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213977;
	b=Is7bgdBOqJXxpOHUdbSRNFxMXoImgmyVYBF/ZNMutLsztgDy9Br1Zd59CGEkMwW9LBCv
	 zc07EKd7rIgF0rZ29Stufa7WFBKN/prULoDr0KfWWtaOtifb3L/omnQlljMq1EBg4UKKE
	 yVHQ2NPjhrH9snUlfP7s70C5lKvgG2h6EZGF8QTvLaWBFEYuA3e4y6CORJUaDvnfouapK
	 HnktXWNMAxWXku9wBWS7GmaTAgKUvtJqZ3ZKDZR+kuTmphzL5oQnFMdHThOaXfjZb810s
	 f6j/767oyYO1d6RaquwYGlBOgffJefHvXzAkZx8dzSfBOjSwP5kLIYMgnzpDi5dc4hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c+6LNc2MzamyJSDAQZuwO64UwOLADb65Vpsy8ifWTqs=;
	b=D+EJqvIi/UPfJxm3nAhJmh9woj0OeYj4FXiKUXev9v4TfWHwmRTGP/evX7Aq+y1LrFt5
	 qaDgRHlU+iwvL83F44ZXAxfDF8q1BbfRIQktsCOTr/QmR7oTv04TmSnO5vBEwLm0KdWYg
	 LgZFi9TbjTy/c5Wv3vGSl35kiSle2mE+rW6ExeSD9Q4b3mATG9PyS6wzTbJmD0gA7Fl+1
	 9kFPBNETHc4XeIAG73ePP35K1Ewg9u87XEYWuSI5YZaCLtyJSCcRJm7CFISwD49LxSQZ7
	 Z4Bvl/AmMhEjRsKmsnd1u7wGy+/GRse9xt+ygnEXS0LwLUqpVEESAZb+8eD+L7VXhSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vMOVvCVm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D55606A31C;
	Wed, 28 Oct 2026 18:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vMOVvCVm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C6F1F01825;
	Wed, 28 Oct 2026 18:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213976;
	bh=c+6LNc2MzamyJSDAQZuwO64UwOLADb65Vpsy8ifWTqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMOVvCVmq6BrNZ01ceeyRpQFMGu4f8Jf9S7BEB0GsLDUGRDgIGxmALLNu+Ibf8fE2
	 m4aO4nWC286EQBrQjawSUa+pNVYL7I0x5141pCcaRqWSgz/PLm6D4Nimz39P4Leom1
	 g9fZNhiRtKYM5i3lZtPbCKuLOPQWt2Dwglu3t9WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0696/1887] sunrpc: fix one UAF issue caused by sunrpc kernel tcp socket
Date: Wed, 28 Oct 2026 17:46:32 +0100
Message-ID: <20261028170515.249524481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 3f23f96528e8fcf8619895c4c916c52653892ec1 ]

BUG: KASAN: slab-use-after-free in tcp_write_timer_handler+0x156/0x3e0
Read of size 1 at addr ffff888111f322cd by task swapper/0/0

CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.0-rc4-dirty #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
Call Trace:
 <IRQ>
 dump_stack_lvl+0x68/0xa0
 print_address_description.constprop.0+0x2c/0x3d0
 print_report+0xb4/0x270
 kasan_report+0xbd/0xf0
 tcp_write_timer_handler+0x156/0x3e0
 tcp_write_timer+0x66/0x170
 call_timer_fn+0xfb/0x1d0
 __run_timers+0x3f8/0x480
 run_timer_softirq+0x9b/0x100
 handle_softirqs+0x153/0x390
 __irq_exit_rcu+0x103/0x120
 irq_exit_rcu+0xe/0x20
 sysvec_apic_timer_interrupt+0x76/0x90
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20
RIP: 0010:default_idle+0xf/0x20
Code: 4c 01 c7 4c 29 c2 e9 72 ff ff ff 90 90 90 90 90 90 90 90 90 90 90 90
 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 33 f8 25 00 fb f4 <fa> c3 cc cc cc
 cc 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
RSP: 0018:ffffffffa2007e28 EFLAGS: 00000242
RAX: 00000000000f3b31 RBX: 1ffffffff4400fc7 RCX: ffffffffa09c3196
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff9f00590f
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed102360835d
R10: ffff88811b041aeb R11: 0000000000000001 R12: 0000000000000000
R13: ffffffffa202d7c0 R14: 0000000000000000 R15: 00000000000147d0
 default_idle_call+0x6b/0xa0
 cpuidle_idle_call+0x1af/0x1f0
 do_idle+0xbc/0x130
 cpu_startup_entry+0x33/0x40
 rest_init+0x11f/0x210
 start_kernel+0x39a/0x420
 x86_64_start_reservations+0x18/0x30
 x86_64_start_kernel+0x97/0xa0
 common_startup_64+0x13e/0x141
 </TASK>

Allocated by task 595:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 __kasan_slab_alloc+0x87/0x90
 kmem_cache_alloc_noprof+0x12b/0x3f0
 copy_net_ns+0x94/0x380
 create_new_namespaces+0x24c/0x500
 unshare_nsproxy_namespaces+0x75/0xf0
 ksys_unshare+0x24e/0x4f0
 __x64_sys_unshare+0x1f/0x30
 do_syscall_64+0x70/0x180
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Freed by task 100:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x54/0x70
 kmem_cache_free+0x156/0x5d0
 cleanup_net+0x5d3/0x670
 process_one_work+0x776/0xa90
 worker_thread+0x2e2/0x560
 kthread+0x1a8/0x1f0
 ret_from_fork+0x34/0x60
 ret_from_fork_asm+0x1a/0x30

Reproduction script:

mkdir -p /mnt/nfsshare
mkdir -p /mnt/nfs/netns_1
mkfs.ext4 /dev/sdb
mount /dev/sdb /mnt/nfsshare
systemctl restart nfs-server
chmod 777 /mnt/nfsshare
exportfs -i -o rw,no_root_squash *:/mnt/nfsshare

ip netns add netns_1
ip link add name veth_1_peer type veth peer veth_1
ifconfig veth_1_peer 11.11.0.254 up
ip link set veth_1 netns netns_1
ip netns exec netns_1 ifconfig veth_1 11.11.0.1

ip netns exec netns_1 /root/iptables -A OUTPUT -d 11.11.0.254 -p tcp \
	--tcp-flags FIN FIN  -j DROP

(note: In my environment, a DESTROY_CLIENTID operation is always sent
 immediately, breaking the nfs tcp connection.)
ip netns exec netns_1 timeout -s 9 300 mount -t nfs -o proto=tcp,vers=4.1 \
	11.11.0.254:/mnt/nfsshare /mnt/nfs/netns_1

ip netns del netns_1

The reason here is that the tcp socket in netns_1 (nfs side) has been
shutdown and closed (done in xs_destroy), but the FIN message (with ack)
is discarded, and the nfsd side keeps sending retransmission messages.
As a result, when the tcp sock in netns_1 processes the received message,
it sends the message (FIN message) in the sending queue, and the tcp timer
is re-established. When the network namespace is deleted, the net structure
accessed by tcp's timer handler function causes problems.

To fix this problem, let's hold netns refcnt for the tcp kernel socket as
done in other modules. This is an ugly hack which can easily be backported
to earlier kernels. A proper fix which cleans up the interfaces will
follow, but may not be so easy to backport.

Fixes: 26abe14379f8 ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcsock.c  | 3 +++
 net/sunrpc/xprtsock.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 23b4c728de598..69d40d0980cf0 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1457,6 +1457,9 @@ static struct svc_xprt *svc_create_socket(struct svc_serv *serv,
 	newlen = error;
 
 	if (protocol == IPPROTO_TCP) {
+		sock->sk->sk_net_refcnt = 1;
+		get_net_track(net, &sock->sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(net, 1);
 		if ((error = kernel_listen(sock, 64)) < 0)
 			goto bummer;
 	}
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index b9dc8e197dde8..74689050038a2 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1855,6 +1855,12 @@ static struct socket *xs_create_sock(struct rpc_xprt *xprt,
 		goto out;
 	}
 
+	if (protocol == IPPROTO_TCP) {
+		sock->sk->sk_net_refcnt = 1;
+		get_net_track(xprt->xprt_net, &sock->sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(xprt->xprt_net, 1);
+	}
+
 	filp = sock_alloc_file(sock, O_NONBLOCK, NULL);
 	if (IS_ERR(filp))
 		return ERR_CAST(filp);
-- 
2.53.0



