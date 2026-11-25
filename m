Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618359;
	b=SzNiko/kkEPqNJEDEtgZQQD5eLCyH9zpB5c/70xHCS1SKWTXJP1/UogxNEKkPKLy52z5
	 9G4USijtmybiPulmxVrmC0D6WNA1E8Xe5U8U54Y0rj9R5kRIAwdrOl/xOksoITGbAB9V9
	 M+cfkxd4S9NdlGRAI3FgdQ2pcf858HewJGFjSeSMRqWahE/VE9V/IAnoEf4uUY5s899xu
	 B8i8PPkdktPQGcsl1LIDe9v5m4bD0kInf6ZVoLfz9dZj9JFI7baR/gQO77Pk7s392Ta/h
	 2/FigezoonhShHF7Iw15nNfnxx2aI48TIw3z6gwoN2UeaNVjOIAs1tcZ1j/HzJyXcnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nNNJip760frXzhWhMcS7zXtk1k7rWKByeV8keOJgNIk=;
	b=VwjgYZ0ShXD66wxGM8ZBf/D8yjxCURvh+4fblF15yOsEqRf7n3WTfWnA0INWPPoFA5nc
	 kGRNwm8HXFEPTIyZtKLeu5xZ3qh500cNApuoSYN1djKTi3dguP3/IIuFp76YyX3fvQF49
	 ILupSwxUxDlGCy2gITwAkLUrFp38wjtCy8yii6aq14ok+b2sK+e5kY0z9fghj1a6zmlX3
	 5ZIjiKllzdWYkXWGVRuxzBcvMtWSLUqJw+5Q/Sx8YjHEORx/NkD+5bdwhiQlqHo8cXrXs
	 IJf+umH3RSgd/0s+Tvd4cz8MwyJ3Z3KjCK1/uuJnH72awBIHI6M8Y4HQadvgYAH8xIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcaJfim7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C55606A31E;
	Wed, 25 Nov 2026 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcaJfim7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE5D1F000C6;
	Wed, 25 Nov 2026 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618358;
	bh=nNNJip760frXzhWhMcS7zXtk1k7rWKByeV8keOJgNIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcaJfim70bG6TlJeHe4mYsyAc6c6w3Bt5B+nKX4zAArcW4OFqpiRp795sANvInFal
	 hGM4bQsqDz7huiVU8lkc9lWDR+35pv0SXwcyH/zHaElBVKTpoEH5MN/UhpPP+2kQIX
	 aHbEOo4/+INsFmXZxJ2HJN0dIsEMOQZ7oY2paxQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Goodkind <alex@goodkind.io>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0253/1005] net: ethernet: mediatek: preserve sibling PPE bindings
Date: Wed, 25 Nov 2026 15:26:31 +0100
Message-ID: <20261125143827.667118694@linuxfoundation.org>
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
index 8451dc3fd00aa..d8fa1f2b43244 100644
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



