Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621442;
	b=H0ifFJCIcT1Sl2Lwv58kiwyp4uNQZGVl8vom8LJGPA0cP/khhMAoPtLKmBlDAZ8MtIW6
	 l62Ka2hTqB1DMLBKlsB5JigAs5yVfWo5RVSIe9nV/CQqbHHKeSdq8zesNL7q7NIm61vZO
	 jTo83SNBKtRpko8ZRx7Io3ND7lxFE4lqR1/3n1cBz85Zrdmb6h6WI2NGNjC5fdr+2gQAB
	 SLznXSVq/axVxPJxQcQOTe0nHA+qXSWVgFgpyeEvCftpuQJAnSE/apbrKcUULGqghD2Hc
	 Q0jmOQf//47BXcLpz9/Ll2A//f9qnc/NmICvWgLnj9j+RvfbIsm4I224mKhDamlG0Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r0z6W9xj6A8Zf/+mAzrD/N76DmKRRaAmQGhlByoguoE=;
	b=OrBig9PGQ+V1ea+nRKd59KxM1taENC5TwO5dLvvvuCpLpledbidLjTbG6vSgAlwoR+Wf
	 GfXAItuHdqHvsP0GEB2OcoZD21Jzh+3jg5z1ZeMbWmjHAQA4aSzcXcWmMIzjbgAyrZKnt
	 qramG92OwX0zZh67jVtSiOePU6AuJ4JQleu/PX2RvL5zeNiZKcwLWSlkLJVCniBaumiah
	 iBjySyLA5ImIuor791zJXFhrF+JDLrvwpMIjB5CTb1ihxsomo2dEmq7sbL5K6x2waLqON
	 9xbNaLCG/tiumNpqUydvQFqetJ+GbXIdVBZlKGBbBMtzWSCrQD2j1ZftWYlRHx/JTDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TFMz/EA0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813D1606A329;
	Wed, 25 Nov 2026 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TFMz/EA0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990F41F000C4;
	Wed, 25 Nov 2026 15:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621442;
	bh=r0z6W9xj6A8Zf/+mAzrD/N76DmKRRaAmQGhlByoguoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFMz/EA0GxHRafGOcqA6OuR/bRD/3q0ae2RMsplwftHR8J4cyw4QKuRqUD4hj1xON
	 Hgn1odz2xIw0HN7eWaLfpcmRBsH/s//gDY7DxWh4Tzu/FmbatetBSQwlYyQ/mAH+tU
	 SHBGRD8TAQpbSCNUHdbazdNoCAnVoZowVd2u3oz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Goodkind <alex@goodkind.io>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 226/990] net: ethernet: mediatek: preserve sibling PPE bindings
Date: Wed, 25 Nov 2026 15:26:33 +0100
Message-ID: <20261125143827.384306202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



