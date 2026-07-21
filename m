Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B90721FF2E;
	Tue, 21 Jul 2026 22:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672929; cv=none; b=C6AjRScrWhQC0cuV5qK+CPszzKlJ4NWc0BL7rWaYqC9jo5MihTZKruR7DALEfg1wXrxiC6HrXH8mdQeLGfsmqcdgOPpE9TSbToMzQS00kE2W0w8CC7ZTHWnAng+6l9KuDdjYZVD0B2oKXou+VX39rD2GxrR2zufOa0iU5DD3YVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672929; c=relaxed/simple;
	bh=r9k9+11sX/NJL8yscpCjuRsAEZibhzDVeaj09ofAIFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsoSkHdzkPK59VivzibX9spgnzZd3De/vHNz5zPihfITYfW38rPWa0IqkKTTEC88wDhS9ziOnXgWJ84JDM1aXpWa5NeWwLYYPMpb7CflBG8a9NJCQXoOt5GU/biMHXTaB4jaRPJLg/B3p5GlxPWvmhzCjxZ95e6YrAaWQyUFQvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usdqbnas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usdqbnas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EF31F00A3A;
	Tue, 21 Jul 2026 22:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672925;
	bh=GTgpZtIslrg+mnQKuSDmYuiuXJYGSN+V/lovm0ARRH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=usdqbnas2FRWRgoWJtMQjOjzIQGXJiA1d1P6pYpoUzDVlQg3/Hht098e/9SnvMr37
	 6Tplb/1ODd5jAqzON1YUI0lilgZc+VXspTbyVhwCzuGc0YkM+1m7peZRLM46ne/DbY
	 dSpfxddslv/q3BCJUym4t0D4Inq4nyjEW3h3Knac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Toke Hoiland-Jorgensen <toke@redhat.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 808/843] xdp: introduce flags field in xdp_buff/xdp_frame
Date: Tue, 21 Jul 2026 17:27:23 +0200
Message-ID: <20260721152424.246690558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2e88d4ff03013937028f5397268b21e10cf68713 ]

Introduce flags field in xdp_frame and xdp_buffer data structures
to define additional buffer features. At the moment the only
supported buffer feature is frags bit (XDP_FLAGS_HAS_FRAGS).
frags bit is used to specify if this is a linear buffer
(XDP_FLAGS_HAS_FRAGS not set) or a frags frame (XDP_FLAGS_HAS_FRAGS
set). In the latter case the driver is expected to initialize the
skb_shared_info structure at the end of the first buffer to link together
subsequent buffers belonging to the same frame.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/e389f14f3a162c0a5bc6a2e1aa8dd01a90be117d.1642758637.git.lorenzo@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: aa496720618f ("bpf: Reject fragmented frames in devmap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/xdp.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -66,6 +66,10 @@ struct xdp_txq_info {
 	struct net_device *dev;
 };
 
+enum xdp_buff_flags {
+	XDP_FLAGS_HAS_FRAGS	= BIT(0), /* non-linear xdp buff */
+};
+
 struct xdp_buff {
 	void *data;
 	void *data_end;
@@ -74,13 +78,30 @@ struct xdp_buff {
 	struct xdp_rxq_info *rxq;
 	struct xdp_txq_info *txq;
 	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 flags; /* supported values defined in xdp_buff_flags */
 };
 
+static __always_inline bool xdp_buff_has_frags(struct xdp_buff *xdp)
+{
+	return !!(xdp->flags & XDP_FLAGS_HAS_FRAGS);
+}
+
+static __always_inline void xdp_buff_set_frags_flag(struct xdp_buff *xdp)
+{
+	xdp->flags |= XDP_FLAGS_HAS_FRAGS;
+}
+
+static __always_inline void xdp_buff_clear_frags_flag(struct xdp_buff *xdp)
+{
+	xdp->flags &= ~XDP_FLAGS_HAS_FRAGS;
+}
+
 static __always_inline void
 xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 {
 	xdp->frame_sz = frame_sz;
 	xdp->rxq = rxq;
+	xdp->flags = 0;
 }
 
 static __always_inline void
@@ -122,8 +143,14 @@ struct xdp_frame {
 	 */
 	struct xdp_mem_info mem;
 	struct net_device *dev_rx; /* used by cpumap */
+	u32 flags; /* supported values defined in xdp_buff_flags */
 };
 
+static __always_inline bool xdp_frame_has_frags(struct xdp_frame *frame)
+{
+	return !!(frame->flags & XDP_FLAGS_HAS_FRAGS);
+}
+
 #define XDP_BULK_QUEUE_SIZE	16
 struct xdp_frame_bulk {
 	int count;
@@ -180,6 +207,7 @@ void xdp_convert_frame_to_buff(struct xd
 	xdp->data_end = frame->data + frame->len;
 	xdp->data_meta = frame->data - frame->metasize;
 	xdp->frame_sz = frame->frame_sz;
+	xdp->flags = frame->flags;
 }
 
 static inline
@@ -206,6 +234,7 @@ int xdp_update_frame_from_buff(struct xd
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
 	xdp_frame->frame_sz = xdp->frame_sz;
+	xdp_frame->flags = xdp->flags;
 
 	return 0;
 }


