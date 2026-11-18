Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053570;
	b=G1eBbkO/N4ON6MVPysPnPThwYXJLtTXQY3PVJtuzWrSzCUqz4oaoDan/g3ht9icj4bZ+
	 n7+JuRsM5MSR9OJzh7sQZYPg8Jz1QwUZieMQBFlWfthc3Qie3Z/JRBvKZi0/iHHyqvGqw
	 UMZ0Bo/ExYuh+8VMF54G/UVWhHJsQ30DEqzCfIRD82kfPAyx6iDdF0WBOZ9z6nTv3cPd8
	 Yo+bF4dNowgAOyKjpm8Gyx79KDgsk+9RLkWpepK+gaJlbVhE5Ikf275EjcGLLySk0Xv4k
	 O/s4x6V8dxsNlkqeG2L3nBqPiy7sjEZDfQVRozu9zyvJQfZp7rBZH72OuS4WD6PeiBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ec9Gj8xIY2mnptLbmI0U6Av9Z9Yj9a5Q5Z2ZG7C6xFw=;
	b=oto4BOshrowqyFnA0xOf9fq/AOh3sM2g7ZfNFJvRW7DGrey9YC97ZexbG2GtkHJtbUoK
	 h1s4DJQCXnG9vtdTIOJemPdwxH7RXPV8vE5i5owbR0l4Bar5Ki6658YHmoAImxvfKaUDi
	 c2AXmrrnyyBPWSf8sBfw1Vr39P5UP8sjsUUFHF+ADIrpsBqY8ZlSoVFkDJDDXRAK/gNz0
	 Rac7UVU+ZDWUUVCQXzyy3DaBqQXecwoKjRLbJYNmlQuLi2UjyJKyoVTwqZmylyXUZ0uNi
	 FtBWUy0EOq/mVsxivbHB5cCHaf6Xmanu4FEXjr4VVJqs+jOs4h0u5FEKeYtJLQLFbVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BvHCKU7u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F15606A31C;
	Thu, 19 Nov 2026 01:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BvHCKU7u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5596E1F000C4;
	Thu, 19 Nov 2026 01:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053569;
	bh=ec9Gj8xIY2mnptLbmI0U6Av9Z9Yj9a5Q5Z2ZG7C6xFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BvHCKU7u74Plw5Wx9PEZbbU95G57EYzU5Q2DFlJPid5tiH5AX+NY/woezgJtDa9Bm
	 C/UsJk6IwJk97X2B3Hka/MquKkaBgosUou+Y1kBlMEy/UXX/AWU6eBOMgtRVF3g2F/
	 0P/WTHxERhlCRkW2mXnRedpENThVT/ekVqYb/EfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0965/2214] batman-adv: tt: clear ROAM flag when re-adding a pending local client
Date: Wed, 18 Nov 2026 15:44:01 +0100
Message-ID: <20261118150050.896752546@linuxfoundation.org>
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

commit cc2186d7854785b30d423f5d43757b086b300e55 upstream.

When a ROAMING_ADV is received for an announced local client,
batadv_tt_local_mark_removed() sets BATADV_TT_CLIENT_ROAM, queues a
DEL|ROAM change and marks the entry as BATADV_TT_CLIENT_PENDING. If the
client sends a frame again before the next TTVN commit,
batadv_tt_local_add_existing() only clears the PENDING flag and returns
early. The ADD cancels the queued DEL, but the entry keeps the ROAM flag:

* batadv_is_my_client() reports the client as not served by this node
* batadv_tt_local_client_is_roaming() reroutes unicast frames for it to
  the node which sent the ROAMING_ADV

The ROAM flag is only removed with the next frame of the client.

Since BATADV_TT_CLIENT_ROAM is set together with BATADV_TT_CLIENT_PENDING,
it has to be cleared also at the same time with BATADV_TT_CLIENT_PENDING
when the client roamed back.

Cc: stable@vger.kernel.org
Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
[ adjust code still in batadv_tt_local_add ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index a6c92a34b999b..300e3f9b60200 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -658,6 +658,7 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 	int hash_added, table_size, packet_size_max;
 	bool ret = false;
 	bool roamed_back = false;
+	bool added = false;
 	u8 remote_flags;
 	u32 match_mark;
 
@@ -684,7 +685,7 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 			 * flag can be reset like it was never enqueued
 			 */
 			tt_local->common.flags &= ~BATADV_TT_CLIENT_PENDING;
-			goto add_event;
+			added = true;
 		}
 
 		if (tt_local->common.flags & BATADV_TT_CLIENT_ROAM) {
@@ -765,10 +766,12 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 		goto out;
 	}
 
-add_event:
-	batadv_tt_local_event(bat_priv, tt_local, BATADV_NO_FLAGS);
+	added = true;
 
 check_roaming:
+	if (added)
+		batadv_tt_local_event(bat_priv, tt_local, BATADV_NO_FLAGS);
+
 	/* Check whether it is a roaming, but don't do anything if the roaming
 	 * process has already been handled
 	 */
-- 
2.53.0



