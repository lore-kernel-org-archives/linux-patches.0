Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019093;
	b=w6/0ciPvZi6LHxkYrOstUTZ4+1Rw62QG6P6uU3RjBSrV2L3QFLO3/5p4cZwUtCjrSI7J
	 7CXfww+QrJ2KLlcxuU666XiiqGXQx5pbk2JZ9L6FWgZh23DZSRY2B+hoFG0vZjzy+wVOj
	 ogq/6AyMnmeYt3vJa8vhz2g20AK1zSMqDRgoBQwcH0/tPRooKHg5dME3nyiy3aVkS6zfu
	 PUSfwcBrobwNfzfI1NqohJPdP2xs2nQV19+LmhY3L4qwrvxm+rlApULF/dyTgahajP9ag
	 D7f1Ghnn+NoV+IeiVaoKwz/lETVCsht6ySvuLlmEQdeQdEzXlsfKshlNwDLL3V+sQaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mlR0hRfhZVkqiNck+toLvXo5jHEm+Z2H4NT6bLJrdhk=;
	b=nMSpmaGOlhCvR5HQhF0wDnZtbm6iYV7lfqdWcAYlMg6SWm2in8yzkofqAsRfvn16t6xf
	 YHTv6GQgcdC/+nJo8pMQ0nWd9vb3lDzHf2XhlM8vqYqBo1E5fWUUf8FPuhy6HsfBAxGjS
	 PS9AuEUh7u2MPOlQsBNaGivECBNL56sPWzaI91UY3JCz49prd53hwaUj6NCqBcehiUAD/
	 RC6QYqfmcYhM/xohd1nCRNyuhW8vn1ajZmqkf/epIGbC9DOSwv5LrELp/PtGr/BU48Jp1
	 dBHYyC4ZAatLOHDV4aCoyoWDs8ULjoQ2UIZaZdXSFq7OqEMX4FCxPPYNQupAR7WYqOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ZenycIn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DF260A2615;
	Wed, 18 Nov 2026 16:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ZenycIn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3304D1F000C6;
	Wed, 18 Nov 2026 16:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019093;
	bh=mlR0hRfhZVkqiNck+toLvXo5jHEm+Z2H4NT6bLJrdhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZenycIn44DFmkVCNgK+1ifygQp+vp94LZH92D3gCKyCn4Oc7WczYt37HcFUgxT44
	 c1wgBM1bCwgBNWLVPU+EOoCxlCdkqyrFzLETuXdBUGxI81asR9B66wHHgqizT7rB/B
	 E3tHyw/oAykf4JHtz/vycdMKlnecK6X7s4J/XJ7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1472/2651] wifi: mt76: mt7996: upload only the keys of the link being set up
Date: Wed, 18 Nov 2026 15:45:12 +0100
Message-ID: <20261118150341.024642195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 2ec14ab42dfd195976bd834fecbcea00ae7da600 ]

mt7996_vif_link_add() and mt7996_vif_link_destroy() walk the vif keys
through mt7996_key_iter(), which passes every group key to
mt7996_set_hw_key() for the link being set up. On an MLD interface each
group key belongs to one link, as key->link_id says, so a new link gets
the GTK and BIGTK of the other links written to its group WTBL entry,
and its hw_key_idx set to their key index.

Skip keys that belong to a different link, as mt7996_set_key() already
does for keys that mac80211 installs.

Fixes: eddc7286f6bb ("wifi: mt76: mt7996: fix key add/remove imbalance")
Link: https://patch.msgid.link/20261006205936.669125-7-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index cfdb2c4c7771e..1ce4a3be93395 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -291,6 +291,9 @@ mt7996_key_iter(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (sta)
 		return;
 
+	if (key->link_id >= 0 && key->link_id != it->link_id)
+		return;
+
 	WARN_ON(mt7996_set_hw_key(hw, it->cmd, vif, NULL, it->link_id, key));
 }
 
-- 
2.53.0



