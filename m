Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619243;
	b=aSrbqx70yZ4gLLf2PiyLdjOE971ckTIUBZt1S7OhZfMDC482bW2bDp0+J6CaPYeVMRJQ
	 oGXz3vPcVQgLN413fHk3jIVl6zgfH5UjMEQKZurRuD99RO1yKos0vOdHI2zZhHSdhDkym
	 z+SyBiwR/FeIAEODQvRWB38bmdABa9AnGgVgyjYsEafGrVPimQVoZyX4fPxk2dR/TJ0ih
	 hG6cKcAhlVdApqRowFat6sXy44MyBthos5ryogCq1QHN/zKyhL34zXpDCH94bnrTpejf2
	 vobRkto4lxw0aFmRGXedpYcvhBKPhQe3eLUYD/DIdkJAyB2vjefY05fksb/t/Q9wF6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=71yK2FDSGKzcqArqVfpMceyHYsncVcd7S+MrbidsbJQ=;
	b=Ro4RMxDU73VTwvFDhblNrKAZZh1DUP+K72JaZHUWmUizEomvktkOIJKALssTkiPZ098q
	 e7ug6R2Rw1Lzav0eO/GgReoXgyZ14eOjyE0eTFu2ixrblG1bj9cps8G9CrcHirXmk1tsa
	 gio674TToDOZtnMSekXqlDKSHoRd/TXgc/PskQntet3Up3kTainOeaPaOiF0PNga5GXEK
	 jtNEfPoBTHWFeU7xSVTq9IudvZlXqNKHfqEZUQEzZ4HRt1Fji71uSOGkS/GOF/6MQ3G3y
	 jG/BNiBhDUCMAz8CK2cSRuAub9oCvq4PfhYHyxhGv+xM4mdg0UZ62oCgnyc51h2yuqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIZngXKG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF5A606A31E;
	Wed, 25 Nov 2026 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIZngXKG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5FC1F000D1;
	Wed, 25 Nov 2026 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619243;
	bh=71yK2FDSGKzcqArqVfpMceyHYsncVcd7S+MrbidsbJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIZngXKG+cJjvl2zs4kWkAgTPJ7Uvuel+1rrQKwTCIU635OUlwvswwFNZgvVRHdxZ
	 RUuBREYsBAlZydyRj/kdg/l8qmfmzRx08kfiKzGkwk6ewvQQ/KWxImMZJ7u0WmcYp5
	 HKU5tF0+Z6EEBIRdz3fQAstxdvuK0hFDG55HgZWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0534/1005] net: Make PSP skb extension survive packet scrubbing
Date: Wed, 25 Nov 2026 15:31:12 +0100
Message-ID: <20261125143834.256686097@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Wang <weiwan@google.com>

[ Upstream commit b22268fc3ddc1e634daf177e53b04e96fa58c330 ]

skb_scrub_packet() drops all skb extensions unconditionally via
skb_ext_reset(). It runs on tunnel encap/decap (ip_tunnel_rcv, vxlan_rcv,
etc.) and virtual device forwarding/redirection (dev_forward_skb,
netkit_xmit, skb_do_redirect).

When a virtual device such as netkit is associated with a PSP device in
another network namespace via PSP_CMD_DEV_ASSOC, incoming PSP packets
decapsulated by psp_dev_rcv() lose their SKB_EXT_PSP extension when
scrubbed during redirection into the peer netns. Without SKB_EXT_PSP,
__psp_sk_rx_policy_check() rejects incoming TCP data segments at the
socket layer with SKB_DROP_REASON_PSP_INPUT.

Introduce a static skb_ext_scrub() helper in net/core/skbuff.c to
preserve SKB_EXT_PSP across skb_scrub_packet() while dropping all other
extensions. If SKB_EXT_PSP is not active, skb_ext_scrub() simply calls
skb_ext_reset(). If SKB_EXT_PSP is the only extension in the skb_ext
buffer, nothing needs to be scrubbed. Otherwise, save the PSP metadata,
reset the extension block, and re-add a fresh SKB_EXT_PSP extension.

Fixes: 06c2dce2d0f6 ("psp: add new netlink cmd for dev-assoc and dev-disassoc")
Link: https://lore.kernel.org/r/20260910-bpf-meta-inside-skb-ext-v2-3-0b21e42180b0@cloudflare.com
Reported-by: Daniel Zahka <daniel.zahka@gmail.com>
Closes: https://lore.kernel.org/netdev/DLODSKPY6ON6.1G6SP3CFFLCPJ@gmail.com/
Co-developed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20261106182007.374660-2-weiwan@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 892ab589ad396..e685964654df5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6311,6 +6311,31 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 }
 EXPORT_SYMBOL(skb_try_coalesce);
 
+static void skb_ext_scrub(struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_INET_PSP)
+	struct psp_skb_ext *pse = skb_ext_find(skb, SKB_EXT_PSP);
+
+	if (pse) {
+		struct skb_ext *ext = skb->extensions;
+		struct psp_skb_ext tmp;
+
+		/* Nothing else to scrub if PSP is the only extension in ext. */
+		if (ext->chunks == SKB_EXT_CHUNKSIZEOF(*ext) +
+				   skb_ext_type_len[SKB_EXT_PSP])
+			return;
+
+		tmp = *pse;
+		skb_ext_reset(skb);
+		pse = skb_ext_add(skb, SKB_EXT_PSP);
+		if (pse)
+			memcpy(pse, &tmp, sizeof(*pse));
+		return;
+	}
+#endif
+	skb_ext_reset(skb);
+}
+
 /**
  * skb_scrub_packet - scrub an skb
  *
@@ -6322,7 +6347,8 @@ EXPORT_SYMBOL(skb_try_coalesce);
  * operations.
  * skb_scrub_packet can also be used to clean a skb before injecting it in
  * another namespace (@xnet == true). We have to clear all information in the
- * skb that could impact namespace isolation.
+ * skb that could impact namespace isolation. Note that PSP skb extension is
+ * preserved across packet scrubbing by design.
  */
 void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 {
@@ -6330,7 +6356,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->skb_iif = 0;
 	skb->ignore_df = 0;
 	skb_dst_drop(skb);
-	skb_ext_reset(skb);
+	skb_ext_scrub(skb);
 	nf_reset_ct(skb);
 	nf_reset_trace(skb);
 
-- 
2.53.0



