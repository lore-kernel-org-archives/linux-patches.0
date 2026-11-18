Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053567;
	b=BiiB1SGQhIORC02ZBfxcVwyBA6vE8S0yAm/4hqf856HADMQ6xLsjaGUCr7conrUpXj8Z
	 9P0wUUP+QjDBv1uwjIU3XcL1RZN4IntDoW1wPf1oM02FVxMipaJ4puVH0y96+Btf0B6tJ
	 ym+zoMbxQHj+sEArH5Q3/64k59xsDkp7pc4xdDlRUOojaCwxafxD1RRAUafH4wIsJ8aJN
	 8kNFbhokWXd60WIiqxw0Ih3v+HgwvEcTR689xdfKisBDEcUBzxzfqkr1PkfppXFClfUaO
	 OEmSHVX6ONk8AU20mx6TImJE7EmFLLcmb2HEpHTNwnak+7f/mUevj2WQA9iRW1WobIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KFGXhP1ysHUsOVMotRoGGor+oh7J57au+PUdWRCXFWs=;
	b=Lsj2NziOZWqUQ+/LmtsjzAW3enE6qWhQ999ku7bIrI/gjttxCv3zuZGIAWXg7VekIbNu
	 h01BnbhHoKUzxqOSD8vON/1FCYLZL1TXKmeoGavsqp/TS9aoM1M3he5wtCjj/22P4ipCu
	 cHIkIhyM1+NbekaGpc6ojTwA/5OTsUVTP9SgzxA1yjVnmIqsaNLOdlLrFLMowJNgKGyO5
	 LL+fhhQ/hKcBREq3+vsFtNTYSNvsDInI7uaW8jL4X4zjOYbA7rMoGhfpDi7NHws1e56DL
	 TqjfZ2AzC/mkwc6p8+ZP3IYNm3Y0XS5Dy2SuIbRaLBmoMA9ySkpr7q3UaXQlaOI/CUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qpv6p8BF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8CB606A31C;
	Thu, 19 Nov 2026 01:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qpv6p8BF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EE31F000C5;
	Thu, 19 Nov 2026 01:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053567;
	bh=KFGXhP1ysHUsOVMotRoGGor+oh7J57au+PUdWRCXFWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qpv6p8BFIAf/HjZyOxX/OnD1WnPPwY54uUGzNa7zdeIOJIYSXEPT0YxwpNhnaXoHz
	 jWl/QeE5i5sp/MZ4Q2f8bTRh/vmGeNgsgZBoTwNbpb5Y1TjebszanaxnPvCMojiS/1
	 oGkNEz71lqne5MQ/vHkaRaV4jUS+gcGVQdiV/AUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0964/2214] batman-adv: tt: only transmit local ROAM flag together with DEL
Date: Wed, 18 Nov 2026 15:44:00 +0100
Message-ID: <20261118150050.861316933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 10f24f058417024a2c19cb8d88a6a0678a58a21b upstream.

BATADV_TT_CLIENT_ROAM is part of BATADV_TT_REMOTE_MASK but on the wire it
only has a defined meaning together with BATADV_TT_CLIENT_DEL: the
originator no longer serves the client because it roamed to another node.
Such a DEL is only relevant for events (non-full table requests).

An ADD carrying ROAM is processed (by accident) by the receiver like a
ROAMING_ADV: a newly created global entry is marked as roaming and is
excluded from the global CRC. But the sender includes it in its local CRC.

But such a behavior doesn't make sense for non-ROAM_ADV because a new TTVN
is meant as announced commit of the local TT table of a node and should
therefore not be used to create a temporary (roam) global entry in a node.

At the moment, such an ADD with the BATADV_TT_CLIENT_ROAM flag set can
happen due to two mechanisms:

batadv_tt_local_valid() copies all flags of the local entry into a full
table response. It is not synchronized with batadv_tt_local_mark_removed().
An entry which was marked as ROAM|PENDING by a ROAMING_ADV is still part of
the current TTVN and is sent with the ROAM flag set. The receivers then
create a roaming global entry for it and detect a CRC mismatch, which
causes them to request the full table again.

The same can happen for an ADD change which is queued for an entry which
(still) has the ROAM flag set. For example when only the dynamic WIFI or
ISOLA flags were updated.

It is not triggered by batadv_send_other_tt_response() because
batadv_tt_global_valid() is already taking care of filtering out
BATADV_TT_CLIENT_ROAM entries.

For the two problematic announcement mechanism, only send the ROAM flag of
local entries together with a DEL.

This only fixes the ROAM marking of the global entry and the resulting CRC
mismatch. When the requester of the full table is the node which sent the
ROAMING_ADV, the still announced entry will (independent of the ROAM flag)
cause batadv_tt_global_purge_local() to remove the requester's own (new)
local entry for the client. This is not addressed here.

Cc: stable@vger.kernel.org
Fixes: 27b37ebfa2d2 ("batman-adv: correctly pass the client flag on tt_response")
Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
[ Context, use direct tt_common_entry->flags access ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 65b0d2284eaed..a6c92a34b999b 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -470,7 +470,6 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 	if (!tt_change_node)
 		return;
 
-	tt_change_node->change.flags = flags;
 	memset(tt_change_node->change.reserved, 0,
 	       sizeof(tt_change_node->change.reserved));
 	ether_addr_copy(tt_change_node->change.addr, common->addr);
@@ -478,6 +477,15 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 
 	del_op_requested = flags & BATADV_TT_CLIENT_DEL;
 
+	/* the ROAM flag is only meaningful for the receiver in combination
+	 * with a DEL. An ADD with ROAM would be interpreted as a roaming
+	 * advertisement
+	 */
+	if (!del_op_requested)
+		flags &= ~BATADV_TT_CLIENT_ROAM;
+
+	tt_change_node->change.flags = flags;
+
 	/* check for ADD+DEL or DEL+ADD events */
 	spin_lock_bh(&bat_priv->tt.changes_list_lock);
 	list_for_each_entry_safe(entry, safe, &bat_priv->tt.changes_list,
@@ -2757,8 +2765,12 @@ static bool batadv_tt_local_valid(const void *entry_ptr,
 	if (tt_common_entry->flags & BATADV_TT_CLIENT_NEW)
 		return false;
 
+	/* the entry is (still) announced. A ROAM flag of an entry which is
+	 * pending to be removed must not be transmitted. Otherwise, the
+	 * receiver would handle it like a roaming advertisement
+	 */
 	if (flags)
-		*flags = tt_common_entry->flags;
+		*flags = tt_common_entry->flags & ~BATADV_TT_CLIENT_ROAM;
 
 	return true;
 }
-- 
2.53.0



