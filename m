Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046359;
	b=ukWb5sTglXc7mCDqdUBm6PVidHqMFftL921qJYZ5LtYBSgWZ7UYMzm42Iao1SfUAODzE
	 LXnj5ApKuaGtMWg6TxIP3pywyGeLEiQPnuKUOI/o3MhP1N9VEC1bSlxqGfsDr/wN/Bdte
	 SaLsMgxjowfjg9n1sSwt/uyveb3j7GHo2v0/bJm3sbMcmr6lBrafVxZNRwSKVB9snU5Q7
	 iXHVsM/a+67P5RLcS2n7QIb2aBtItG+Ywq1VmxkfSw+v+5EGsU+o8++MEpXm1qZaUy+Oa
	 mhJ4QUTiXsKcU5vkWU3qIItysMiADuXWvgferpoRKQHAaBKeHLi9BNvdAHjwZA1eUuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bu6pMUT4FutS1LCoMAt4OiPcUeOPYx6mJwpISEAMkaI=;
	b=1jh7SxiWeE81wSwssNq4j7oZuZ6eIwP9KN8CfEkSCI1zvlxes1MpyX0+dlEYR3lLVidu
	 /Kx3n8hKhms/3Rw5FF9UaVJSUQRsEMh5Xhw1VKnHl7anThx+zCEhXty+1h1Autq8fLZyn
	 x92ieq1TVAbI2r/mfPs+0gCvOEHG2LjLcVsM7qtTI2PavLGKQNloJBUoXxK54GslA9b1r
	 GXTvfwSdZ24yJg4B+fJyqMrR/Iy4DokLTE37Evskz4RENaBEyqjbA//IM+TnNp/PgP++s
	 4bZ5jaKTUTqqiwMTVUbOiit+tH7tX+cC3oLCQY3txN6KcpDnx0Wf282lBbESABm4Irw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuSd74Ju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9408E606A32A;
	Wed, 18 Nov 2026 23:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuSd74Ju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53501F000C4;
	Wed, 18 Nov 2026 23:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046359;
	bh=Bu6pMUT4FutS1LCoMAt4OiPcUeOPYx6mJwpISEAMkaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuSd74JujtDgESu8zndaj5CHsuZPiY5TyrmWvO5ZL+0zz5ZcG0IHPpzyTyskfFkJY
	 2hQvUBaGhPGOxNvyOquwrDwa9LnY3YfbQcygtNZYQWUnTEANhU8VbKxSbMM6UTcsVQ
	 YnShI2otFYX28Wy8yXksNkdxZyB8rI87jn5ArIR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1202/2857] 9p/xen: validate the response size from the backend
Date: Wed, 18 Nov 2026 15:37:16 +0100
Message-ID: <20261118150244.883175662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 9b4cf60c6b739461c5b4ec9c52587da6b2608786 ]

p9_xen_response() takes the length of an incoming response from the ring
-- the first field of the 9p header, which the Xen transport reuses as
its framing header -- and uses it to advance the consumer index, but
never checks that it is at least the header size or no larger than the
number of bytes the backend has actually produced.

A malicious or buggy backend can post a response whose size is smaller
than the header (for example 0). The consumer index then never advances,
so the response work re-reads the same ring contents instead of making
progress. In testing this raced with the teardown that the malformed
reply triggers and dereferenced a freed p9_client:

  9pfs 9pfs-0: Wrong req tag=ffff
  BUG: kernel NULL pointer dereference, address: 0000000000000060
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0000 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted 7.2.0-rc5 #6 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
  Workqueue: events p9_xen_response
  RIP: 0010:idr_find+0x4/0x10
  RSP: 0018:ffffbf5d80063de8 EFLAGS: 00010202
  RAX: 0000000000000001 RBX: ffffa229c21195a0 RCX: ffffa229c2400000
  RDX: ffffa229c11c2200 RSI: 000000000000ffff RDI: 0000000000000050
  RBP: 000000000000ffff R08: 3fffffffffffdfff R09: ffffffffffffffff
  R10: 3fffffffffffdfff R11: ffffffff87a60e80 R12: 0000000000000050
  R13: 0000000000000000 R14: 000000000000ffff R15: 0000000000100000
  FS:  0000000000000000(0000) GS:ffffa22a7661c000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000060 CR3: 000000003ac34002 CR4: 0000000000770ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   p9_tag_lookup+0x2b/0x90
   p9_xen_response+0x17c/0x2e0
   process_one_work+0x16a/0x3a0
   worker_thread+0x172/0x2e0
   kthread+0xdd/0x110
   ret_from_fork+0x18b/0x240
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  Modules linked in:
  CR2: 0000000000000060
  ---[ end trace 0000000000000000 ]---

Reject a response whose size is outside [sizeof(header), queued] before
using it, matching the validation the backend already applies to
incoming requests.

Fixes: f66c72bea129 ("xen/9pfs: receive responses")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261005125640.274054-1-yhlee@isslab.korea.ac.kr>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 4b712a040ef4b..48a412f6242d1 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -199,6 +199,14 @@ static void p9_xen_response(struct work_struct *work)
 				     masked_prod, &masked_cons,
 				     XEN_9PFS_RING_SIZE(ring));
 
+		if (h.size < sizeof(h) ||
+		    h.size > xen_9pfs_queued(prod, cons,
+					     XEN_9PFS_RING_SIZE(ring))) {
+			dev_warn_ratelimited(&priv->dev->dev,
+					     "bad response size %u from backend\n", h.size);
+			break;
+		}
+
 		req = p9_tag_lookup(priv->client, h.tag);
 		if (!req || req->status != REQ_STATUS_SENT) {
 			dev_warn(&priv->dev->dev, "Wrong req tag=%x\n", h.tag);
-- 
2.53.0



