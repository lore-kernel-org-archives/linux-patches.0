Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624436;
	b=rCLmpb0z95XT5xYzw1r1PPMZdqdmc8IcRyuZj8x/qLV1tdMf0aCAeUfcb5roa3wjxJh2
	 iBbROKvGXTZM8WKWeipT/nuyTSKNLlsFMFXMkcUu9hrxOLMUFfWUQXmv5EWYlUmihbg0+
	 ZaWEkHyKc+nd36ScUloxrGELhuYt7NtCAc5JOIErcjtzatvcGachpn9AGmsFUMDgacvlD
	 XRKvvTfC4NNUZf3EhsOMY+fayRQZgw7MvJKTlvrrQ6VO7q1D3hRdSTAeHOk+rSiI2EaOB
	 gqVnpz2ufjxNU5ibI3DNCZRKMuu9iCg672LCRBnijEror03+6ypKxrAtPCb6PcD1zwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aeP74NYbQRNhKWMmmZye3u2iCCI9g6nozmeFu2+ce0E=;
	b=Z/4xxDIkNwD4UcIx1ziV69bCwNi7tXx3R3OLfQJ5BzSqasmbCkwBY4+UplNT+1p+2ZWq
	 dJ8nA3fmK3ExAiTfnf61zz390yi2EP/SGzYdAdIm+clybPy5wzCd+UzeNp3fCaI9Jap63
	 hc8XUht8V6q9UQch2d4mRfnClDfrOmL1EftLs2nuBFVcd5gQF6iS7g+BHwgJDqv0f9SC7
	 wRcYYJpMPS4V4skx/F/ZuhIOjWZVnNtcxQKuL95+wyV6JFe1Kt/18bmD+9g4HkHJK6yeZ
	 t/fl7dUBuPH/yCitjGNyEWK3VqJMNGXkIUopscRS+ZNKGJPpsDqn9ed7X7CC3MFVWeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ivr9qHBC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132CD606A33A;
	Wed, 25 Nov 2026 16:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ivr9qHBC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EE31F000C6;
	Wed, 25 Nov 2026 16:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624435;
	bh=aeP74NYbQRNhKWMmmZye3u2iCCI9g6nozmeFu2+ce0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ivr9qHBCOhyYpJrgU6IeWQRToRFZQfrYyQWPNkxFx0wanvfd6zTR7ZEVKORJCSCM4
	 7oKAhD47mGwY4V/Qx3f0R8ofFOc1ij6IXBLxrm8lQ+dvtvbGhpWSM6jtDvI4GV0dT7
	 oQhoXY8P4lAht1MUH+JlvQTqJnKnCHrLma7N5Mcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Goodkind <alex@goodkind.io>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/816] net: ethernet: mediatek: preserve sibling PPE bindings
Date: Wed, 25 Nov 2026 15:29:00 +0100
Message-ID: <20261125143853.638377629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Alexander Goodkind <alex@goodkind.io>

[ Upstream commit 34cc22a9ce6ae0228dcd09a57df23aea62e22b04 ]

__mtk_ppe_check_skb() clears entry->hash for flows bound to other
hardware slots in the same software hash bucket. mtk_flow_offload_stats()
then skips their hardware counter updates. L2 cleanup also frees sibling
subflows without invalidating their hardware rules.

Restrict both cleanup paths to entries assigned to the inspected slot.

Two UDP trials reproduced the counter failure on a GL-MT3000/MT7981
running unmodified OpenWrt 25.12.5 with Linux 6.12.94:

1. Start a UDP connection.
2. Add a control connection in a different hash bucket.
3. Add a connection in the first connection's hash bucket.

AI code review of the original patch identified the cleanup problem
in L2 subflows.

Full ARM64 builds with allmodconfig and allyesconfig passed before
and after the patch using GCC 14.2.0 and W=1, without new warnings.
The builds used CONFIG_WERROR=n because the unmodified ARM64 kernel
already emits warnings. Hardware testing has not run for this revision.

Fixes: c4f033d9e03e ("net: ethernet: mtk_eth_soc: rework hardware flow table management")
Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Link: https://github.com/openwrt/openwrt/pull/26107
Signed-off-by: Alexander Goodkind <alex@goodkind.io>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261030010517.45639-1-alex@goodkind.io
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index bb01a7355932a..fc1362cd821cd 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -754,8 +754,7 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 
 	hlist_for_each_entry_safe(entry, n, head, list) {
 		if (entry->type == MTK_FLOW_TYPE_L2_SUBFLOW) {
-			if (unlikely(FIELD_GET(MTK_FOE_IB1_STATE, hwe->ib1) ==
-				     MTK_FOE_STATE_BIND))
+			if (entry->hash != hash)
 				continue;
 
 			entry->hash = 0xffff;
@@ -764,7 +763,7 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 		}
 
 		if (found || !mtk_flow_entry_match(ppe->eth, entry, hwe)) {
-			if (entry->hash != 0xffff)
+			if (entry->hash == hash)
 				entry->hash = 0xffff;
 			continue;
 		}
-- 
2.53.0



