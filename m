Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209429;
	b=XTnMAyArfqpuUldSaY2cLPwn9glQVcNF9P6/rw83UF5TxiO9zGsxqg4YYeL5qvRX88kf
	 tQdFsvTUgYAI0V/4m+QbJiFkMICUQmPnWOkroR/vG0SpHtfXUkCAsWgb69n6GLq37AMKc
	 8XShA8E6KmmZibwIVkxoonDWKECAPciWe1kaealf1QzMAs82cTIyURowB2WCMHeLo+8eA
	 771f46rVXfIfKKnnHlcn3NN3Ju2/VbYppzn1vJydeqOEB/6+VxOzsy1Q9cGUog7De9mSA
	 auZ/MlI/UCFsm/HUpJQ3hqvt7FX66ZNPA00gtDabp1yhwB1NorNyA3m/EDJ/NkB8stw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kIHdnxLFlW+f8+snIQYseqld/pBzN5hcRulTcZT4E4Q=;
	b=pq56Y9wM6vL7HAuAIa2GBql+IxIvaPHREUUmEABHrGcGlj5/ayMDuF4PvEcFhokSmVt+
	 +JvSSoecOUowSPTfkQm50srafWKLratMWU8yZUztwRLSfS9d5FXhJKqUVuOKaoMGu0ECo
	 WXHqxv35ZF/5zOP0PfbuLpgc5ooj3m01LgAaegLngHWTmt8fYG6YgD4BHDnkJNepMt5i5
	 pGiHQvpVebPEZa6KEVXfSMh/5HVm1U9hOLdKNdZI3Jlp1xLy8RNloV1ibFtGcyyQ9ryr9
	 Jk/mAOf8b9z2wPDbHQUVBGyMY8jU/6zWNM+Oa2ZcE0RjhWyh8JENa+WwR7nj01amcOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8W6Ljg6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716AD606A31C;
	Wed, 28 Oct 2026 17:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8W6Ljg6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03CE1F01825;
	Wed, 28 Oct 2026 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209429;
	bh=kIHdnxLFlW+f8+snIQYseqld/pBzN5hcRulTcZT4E4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8W6Ljg6FTvaRO++mSfZxPDpaEeYV0mm5JWYIqIqSp7OiC1iZHGu06XC3eJ7FgAZ2
	 hMkRUbskxG/XHWPHqzo2znhUrMqt96s3YKtVOF850XhaNbbuivUDGCwQxupdyPR+cA
	 ubb4JTwlf8weFenkuK4ELBkXMc3x5Rhq5XHRK4EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.10 424/516] skmsg: Skip zero length skb in sk_msg_recvmsg
Date: Wed, 28 Oct 2026 17:59:36 +0100
Message-ID: <20261028170013.531934247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit f0c18025693707ec344a70b6887f7450bf4c826b ]

When running BPF selftests (./test_progs -t sockmap_basic) on a Loongarch
platform, the following kernel panic occurs:

  [...]
  Oops[#1]:
  CPU: 22 PID: 2824 Comm: test_progs Tainted: G           OE  6.10.0-rc2+ #18
  Hardware name: LOONGSON Dabieshan/Loongson-TC542F0, BIOS Loongson-UDK2018
     ... ...
     ra: 90000000048bf6c0 sk_msg_recvmsg+0x120/0x560
    ERA: 9000000004162774 copy_page_to_iter+0x74/0x1c0
   CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
   PRMD: 0000000c (PPLV0 +PIE +PWE)
   EUEN: 00000007 (+FPE +SXE +ASXE -BTE)
   ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
  ESTAT: 00010000 [PIL] (IS= ECode=1 EsubCode=0)
   BADV: 0000000000000040
   PRID: 0014c011 (Loongson-64bit, Loongson-3C5000)
  Modules linked in: bpf_testmod(OE) xt_CHECKSUM xt_MASQUERADE xt_conntrack
  Process test_progs (pid: 2824, threadinfo=0000000000863a31, task=...)
  Stack : ...
  Call Trace:
  [<9000000004162774>] copy_page_to_iter+0x74/0x1c0
  [<90000000048bf6c0>] sk_msg_recvmsg+0x120/0x560
  [<90000000049f2b90>] tcp_bpf_recvmsg_parser+0x170/0x4e0
  [<90000000049aae34>] inet_recvmsg+0x54/0x100
  [<900000000481ad5c>] sock_recvmsg+0x7c/0xe0
  [<900000000481e1a8>] __sys_recvfrom+0x108/0x1c0
  [<900000000481e27c>] sys_recvfrom+0x1c/0x40
  [<9000000004c076ec>] do_syscall+0x8c/0xc0
  [<9000000003731da4>] handle_syscall+0xc4/0x160
  Code: ...
  ---[ end trace 0000000000000000 ]---
  Kernel panic - not syncing: Fatal exception
  Kernel relocated by 0x3510000
   .text @ 0x9000000003710000
   .data @ 0x9000000004d70000
   .bss  @ 0x9000000006469400
  ---[ end Kernel panic - not syncing: Fatal exception ]---
  [...]

This crash happens every time when running sockmap_skb_verdict_shutdown
subtest in sockmap_basic.

This crash is because a NULL pointer is passed to page_address() in the
sk_msg_recvmsg(). Due to the different implementations depending on the
architecture, page_address(NULL) will trigger a panic on Loongarch
platform but not on x86 platform. So this bug was hidden on x86 platform
for a while, but now it is exposed on Loongarch platform. The root cause
is that a zero length skb (skb->len == 0) was put on the queue.

This zero length skb is a TCP FIN packet, which was sent by shutdown(),
invoked in test_sockmap_skb_verdict_shutdown():

	shutdown(p1, SHUT_WR);

In this case, in sk_psock_skb_ingress_enqueue(), num_sge is zero, and no
page is put to this sge (see sg_set_page in sg_set_page), but this empty
sge is queued into ingress_msg list.

And in sk_msg_recvmsg(), this empty sge is used, and a NULL page is got by
sg_page(sge). Pass this NULL page to copy_page_to_iter(), which passes it
to kmap_local_page() and to page_address(), then kernel panics.

To solve this, we should skip this zero length skb. So in sk_msg_recvmsg(),
if copy is zero, that means it's a zero length skb, skip invoking
copy_page_to_iter(). We are using the EFAULT return triggered by
copy_page_to_iter to check for is_fin in tcp_bpf.c.

[moved the change from sk_msg_recvmsg in net/core/skmsg.c to
__tcp_bpf_recvmsg in net/ipv4/tcp_bpf.c, as we are before
2bc793e3272a13e337416c057cb81c5396ad91d1 ("skmsg: Extract
__tcp_bpf_recvmsg() and tcp_bpf_wait_data()")

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Suggested-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/e3a16eacdc6740658ee02a33489b1b9d4912f378.1719992715.git.tanggeliang@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 458b8a694b9d5..0897513572445 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -38,7 +38,8 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 			page = sg_page(sge);
 			if (copied + copy > len)
 				copy = len - copied;
-			copy = copy_page_to_iter(page, sge->offset, copy, iter);
+			if (copy)
+				copy = copy_page_to_iter(page, sge->offset, copy, iter);
 			if (!copy)
 				return copied ? copied : -EFAULT;
 
-- 
2.53.0



