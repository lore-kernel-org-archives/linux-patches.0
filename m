Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037496;
	b=HUJ9YxyD05wSvdmi7uTxvdRmx0knaWGp+qzs9q+hq8NFGyfDggpd3pezU3H5j8NhveMN
	 tKaF2EekMS2rM2NC1Ruk0Hck8110M65NlrnNpTwew9vmOTsnjZCtThfwwdfFoaaX2MDwf
	 4IbysyURhBGQgfvQ70zznZNPv05SLqCNcxJnaCRiG45x64INmBO5uEVdXBwTp3DhIOjwY
	 Kw3tNyQs8cFUvK0fj30Y6Yg8Nz4BgPzW7UfmqVAHv64rdUT+4z0h/v0ybFtfX5X2N6IaL
	 3/M3e9uzBvwTaSaK5z0F582T8J+w2mo8r7Mfft0tpUatYoC+Y2lGy0yWFcutrRWyymA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k89PG3vf7PwJIt6170Aq+BM6jDa/QGDiwqrrVK4DyX8=;
	b=kgK2PciyJjOmNwbe/Hcgar/xVPrcDEMedHn2xbWTiTZEdlfIVxrenhtdffxWpEcldkcB
	 trLcOYZOHtTHTy7Ex7vLPcivnq17DMPz1CVO2NAhDL3Tg5TAmBOucyn+sCKrrvFBbF8Mq
	 rpavsGQDHYNh0/HBWodKRmTdevPoK2dU7GQ998ayIawI39gqHNFF30N42dxzhsa2gobCD
	 i6Myt8ReYbfcjxHnPCZHwvg3lWx3MhNY4nb2wjfb/wzxBYho+nduH+3I7DT8YqurI9V7b
	 gRy7KyyLNEFB/i4kE6Yo/Htd++EYWiWWIE3wxbuo7v24m84ucJw3fm9gmoJFLWSEoiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JAh8w1q3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE67606A320;
	Wed, 18 Nov 2026 21:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JAh8w1q3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23721F000C4;
	Wed, 18 Nov 2026 21:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037496;
	bh=k89PG3vf7PwJIt6170Aq+BM6jDa/QGDiwqrrVK4DyX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAh8w1q3Ge5cSwdoBNntGDDxPkW2CW4pIPgIQFHzyGm/KyVU49YNXc4qc+uheI9YA
	 SSEbhib6ZOOH4KwwV7BIk9936gISQoYk9mPNEjR6/855pqRfQafsjrxrvWqOWDrFo2
	 Ay+EeqYWo+l7/h36g+nhA404/0+bTKbriw1TrzFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1416/3318] batman-adv: dat: initialize orig_node of unfilled candidate slots
Date: Wed, 18 Nov 2026 15:33:58 +0100
Message-ID: <20261118150403.162416639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 4eb19a389d74f06901b4cd6f24b996b2e84eaefc ]

batadv_dat_select_candidates() allocates the candidate array without
zeroing it. batadv_choose_next_candidate() marks each slot as
BATADV_DAT_CANDIDATE_NOT_FOUND but only sets orig_node when an eligible
originator was found. In the following rounds,
batadv_is_orig_node_eligible() compares res[j].orig_node of all previous
slots against the evaluated originator. For slots without candidates, it
reads uninitialized memory.

The orig_node has to be cleared together with the
BATADV_DAT_CANDIDATE_NOT_FOUND type.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-b25d9aa4-10bb-427c-a145-ccaadc2a1bb9
Fixes: 785ea1144182 ("batman-adv: Distributed ARP Table - create DHT helper functions")
Acked-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/distributed-arp-table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index c6b7b3bece813..fb6ca168ad0b9 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -583,6 +583,7 @@ static void batadv_choose_next_candidate(struct batadv_priv *bat_priv,
 	 * NOT_FOUND
 	 */
 	cands[select].type = BATADV_DAT_CANDIDATE_NOT_FOUND;
+	cands[select].orig_node = NULL;
 
 	/* iterate over the originator list and find the node with the closest
 	 * dat_address which has not been selected yet
-- 
2.53.0



