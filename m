Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618958;
	b=jX8ON9kNicbZt9rIiboBIp/ddHYgfXyZlB/5ts0DNNrN1qKb8rufkn4Y1vfV/vwzzPL0
	 GH3s/XGaNwsHJqqRojuR2RhBqV38oTwoMJw+uYuLomThd0N/bzTjW+BuPXqwbQwA9FYHN
	 1R6LD+Q5RbEqKg+Uft9M0oawchFYG4w1pLqwZXF/rXSnE4lUP4K1tGZCsucyERpXaELSS
	 efUCYg2vkAVNFUSgcb4tOpqMp+Ns4mIYgzQF/4vx7laWvusCrqWsCkHM4O/Wr4q99t52h
	 oFsxKc7QjyIhExVncFsMj2AzBLc5gguF3s2twh9HQTDGYgPfmSm1xNMHtZo0RIO3qpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rC2gZU+RC+v9JjDP0ro/WgtSVSyTVC49n5Bgwgh1kvc=;
	b=D+jv54lTT/seVoznDRWo/wLz/At1sHL/FF6tLBMgW+r9luLxv+qjpx2sGFJZI2WG0aY2
	 BlcbD4FAGySW2LqMj+MxEC6cAlapSHGRk+xXJiSK0zC+yjTLREvOjfNO9JsuxVfD7yHJB
	 WhWkQPbkdn/pnDsxDDudfZwgMqMqJVRd5mJG3NdUpALToPW5B6bDs/4d5VT142qwEHEXN
	 OnVFSmReA9Erv8wflMrcE9yv9Z0fHwwa1p9CligzEz0m/fyGLNbXi/Lq3lKEdOP+l1ZKa
	 gEmbbYEZkZUi9cvfyBOaONLuR31Lgk+G5pwca7C90HwptLvLBQx7QDgNmZU6NhmX9EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMsxiKlq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A53606A31E;
	Wed, 25 Nov 2026 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMsxiKlq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874AF1F000CA;
	Wed, 25 Nov 2026 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618958;
	bh=rC2gZU+RC+v9JjDP0ro/WgtSVSyTVC49n5Bgwgh1kvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMsxiKlqfel/jKLvNpe/kV7+DO3eO4m/Yh71SWKg6yA2uM7SfNRI9xExHJen2MTpn
	 PAPxgRUHOAHmOwd61RaFYyKMBQiw2aKWoxGscr1P/q7NIW9Xr4R+4iB92fFOJnzKP8
	 ZBE2HjjTOdxqYRlgkXopU+k1rjjYY7PuafN7YCA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nagato Shiratana <zuomao338@gmail.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0442/1005] xsk: fix list corruption in xsk_buff_add_frag()
Date: Wed, 25 Nov 2026 15:29:40 +0100
Message-ID: <20261125143832.102976497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 94ae1259175f566ed5a33f37b09b6f32a1b2d8af ]

In aligned mode, a fill ring address maps straight to its pool->heads[]
entry. If user space posts the same address twice, a driver can pass
xsk_buff_add_frag() a buffer that is the head of the frame or is
already on pool->xskb_list or pool->free_list.

Re-adding a linked node corrupts the list. With buffers A, B, C, B,
xsk_rcv_zc() emits two descriptors instead of four and leaves the list
head pointing at a self-linked B. When the Rx ring later has no room
for a frame, the xsk_buff_free() cleanup follows B into pool->free_list
and passes the list head to xp_free():

  BUG: kernel NULL pointer dereference, address: 00000000000000c0
  RIP: 0010:xp_free+0x1a/0x50
  Call Trace:
   xsk_rcv_zc+0xca/0x200

The head is not on any list and needs a separate check. Adding it as
its own frag lets bpf_xdp_adjust_tail() free the in-use head and wrap
sinfo->nr_frags to 255.

Reject such buffers before adding them to the frags array, as commit
e37b2abca804 ("xsk: fix NULL pointer dereference in __xsk_rcv()") does
in the copy path. Callers already drop the frame on failure.

Unaligned mode is not affected, as each fill ring entry gets its own
xskb from pool->free_heads[].

Reproduced with a KUnit test feeding synthetic buffers to xsk_rcv_zc(),
by Nagato Shiratana.

Fixes: 24ea50127ecf ("xsk: support mbuf on ZC RX")
Reported-by: Nagato Shiratana <zuomao338@gmail.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-2-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock_drv.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index d94aeb506379c..29965e3695983 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -160,15 +160,18 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 static inline bool xsk_buff_add_frag(struct xdp_buff *head,
 				     struct xdp_buff *xdp)
 {
+	struct xdp_buff_xsk *frag = container_of(xdp, struct xdp_buff_xsk, xdp);
 	const void *data = xdp->data;
-	struct xdp_buff_xsk *frag;
+
+	/* Duplicate fill ring entries map to the same xskb in aligned mode */
+	if (unlikely(xdp == head || !list_empty(&frag->list_node)))
+		return false;
 
 	if (!__xdp_buff_add_frag(head, virt_to_netmem(data),
 				 offset_in_page(data), xdp->data_end - data,
 				 xdp->frame_sz, false))
 		return false;
 
-	frag = container_of(xdp, struct xdp_buff_xsk, xdp);
 	list_add_tail(&frag->list_node, &frag->pool->xskb_list);
 
 	return true;
-- 
2.53.0



