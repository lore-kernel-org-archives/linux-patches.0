Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061467;
	b=bEiM4/Ee0kw0U3M0hHv8qAgmEKC4xItUAHkwcxnACbB502XF9Op6Js3sMEuZlvN/B+Pd
	 6t6QgwLcPvLfn5d1P07D93DvtdiSsYz5iSMrUuNUGGQpZ50MwhJZPxf63zmLRJSm+aGgu
	 7Xi2ukEdiN0NhPteSuj+d934XXZbMfYo4gTOofHwzhvDDwaq4KZ0uP0p5Fn2QNe/EYGaO
	 g0LRq4tdtHGZSvGYVDQEkN9PpT8S/7tIASime/l9WEMvUc7h7ZSqqPWI3TDnYVx+fdWDw
	 5MaA48zz/Rmsik0c4S9bOmxeTiNblAikNjKj1vihPlKtBf8EhEXdR8AFBrMbb7JxavA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FjSNOvHj6P/LFxX3nPHhNA8NypoifTrijLy6ew5+S3s=;
	b=LNwY/5deJY3moYyG3gQoGATpckdCUzkjm3k/VGACxetRNwiNYT0RQL70dQNnMOUmvgjv
	 AKbNqtacZFOl8BdolMbBBEhi//R4CMjt/gTFBcGCRaAKgWgJMnz7QFQ+yQZ3cQb7qCvQU
	 iXkPIgD9LDV0MYgoq06hDu7ICn4RTwpn/TGXStlbaRtEdRt1Sg/mUxYcWyARYelQKRM7Y
	 L7a0f6CQx68pyKx3az9zCrSjJisx+k4CNbA2yCDj4CZEGsVarA4mSsMOoBlkWA8q5dHQD
	 KQBf/FTzCDquMK7oBUy4wEEJlOYa1s7ykllKS/buZ/GlxuoPBWoyzwsYNdXEGVtfQsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQvGZozu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E44606A326;
	Sat,  7 Nov 2026 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQvGZozu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4582E1F0089F;
	Sat,  7 Nov 2026 14:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061467;
	bh=FjSNOvHj6P/LFxX3nPHhNA8NypoifTrijLy6ew5+S3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQvGZozu4xpJprM+zU7h/HD5anO/4JFfG2BHJ3klcU5iMhw4hIDy0QR4zqAntcwA7
	 XtSMWX8gD8gMK+8pDVVluStL+UE9hRZXc/Uz3X88IYIJo54KNOzKHDXGsWGfyYvYzo
	 L5F9N/7i1feTeYZdY/1qpKUxyGbLzKWeyHhfLwJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0568/1536] net/sched: cls_bpf: accept dev-bound programs on shared blocks
Date: Sat,  7 Nov 2026 08:43:04 -0500
Message-ID: <20261107135013.528046605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

commit d305547d1632a242818c5ebb430c85121a2ed434 upstream.

The issue:
Follow-up to commit 120977e2c096 ("net/sched: cls_bpf: reject dev-bound
programs bound to a different device"), which derived the target device
from block->q:

	dev = block->q ? qdisc_dev(block->q) : NULL;

tcf_block_create() leaves block->q NULL for shared blocks, so a
device-bound program attached through a shared block is rejected with
-EINVAL even when it is bound to a netdev that owns the block.  The
offload path (cls_bpf_offload_cmd()) never consults block->q and drives
the per-device callbacks for shared blocks as before.

The Fix:
Accept the attach on a shared block when bpf_offload_dev_match() matches
every netdev bound to the block, and reject an empty block.  Every member
must match because the offload path broadcasts the program to every
callback registered on the block, so an any-member check would re-admit
the wrong-device attach on a mixed block.  Every dev-bound SCHED_CLS
attach is skip_sw, which becomes err_stop and aborts the offload on the
first failing callback, so the all-members rule is the offload path's own
semantics.

Iterate the public block->ports xarray (913b47d3424e, v6.8-rc1) rather
than block->owner_list, which is private to cls_api.c.  The shared-block
rejection reports "Program is not bound to every device in the block",
distinct from the non-shared message, because a member can exist without
a registered callback (netdevsim registers its block callback
ingress-only).

Context note:
This patch is not an independent fix: it re-exposes the shared-block
replay path that commit 120977e2c096 ("net/sched: cls_bpf: reject
dev-bound programs bound to a different device") had closed, so patch 1
must be applied first, including in stable.  A stable tree taking this
patch alone would re-enable shared-block attaches on a kernel whose
netdevsim callback is still unchecked.

Conditions to recreate the bug:
  - CONFIG_NETDEVSIM=y, CONFIG_NET_CLS_BPF=y
  - load a dev-bound SCHED_CLS program for netdevsim device B
    (prog_ifindex=B), pin it in bpffs
  - tc qdisc add dev B ingress_block 22 clsact
  - tc filter add block 22 ingress bpf da object-pinned <pin> skip_sw
  Unfixed, the filter add fails with -EINVAL ("Program is bound to a
  different device"); fixed, it succeeds.  Adding a second, independently
  backed netdevsim device to the same block makes the attach fail again.

Fixes: 120977e2c096 ("net/sched: cls_bpf: reject dev-bound programs bound to a different device")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/netdev/20260809094418.901607-1-jhs@mojatatu.com/
Link: https://lore.kernel.org/netdev/QDISC-PYC7.v1.20261003103747@mojatatu.com/
Cc: stable@vger.kernel.org
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/QDISC-PYC7.v2.20261010165947-3@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_bpf.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -392,11 +392,31 @@ static int cls_bpf_prog_from_efd(struct
 	if (bpf_prog_is_dev_bound(fp->aux)) {
 		struct tcf_block *block = tp->chain->block;
 		struct net_device *dev;
+		unsigned long ifindex;
+		bool match = false;
 
-		dev = block->q ? qdisc_dev(block->q) : NULL;
-		if (!dev || !bpf_offload_dev_match(fp, dev)) {
-			NL_SET_ERR_MSG(extack,
-				       "Program is bound to a different device");
+		/* A shared block has no qdisc of its own, but it may bind
+		 * several netdevs and the program is offloaded to all of them;
+		 * require a match with every member.
+		 */
+		if (!tcf_block_shared(block)) {
+			dev = qdisc_dev(tcf_block_q(block));
+			match = bpf_offload_dev_match(fp, dev);
+			if (!match)
+				NL_SET_ERR_MSG(extack,
+					       "Program is bound to a different device");
+		} else {
+			xa_for_each(&block->ports, ifindex, dev) {
+				match = bpf_offload_dev_match(fp, dev);
+				if (!match)
+					break;
+			}
+			if (!match)
+				NL_SET_ERR_MSG(extack,
+					       "Program is not bound to every device in the block");
+		}
+
+		if (!match) {
 			bpf_prog_put(fp);
 			return -EINVAL;
 		}


