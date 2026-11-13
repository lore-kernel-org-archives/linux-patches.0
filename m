Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585423;
	b=l6LG2Dt5jRzC5lH+SHt3jMro+lJQyBSKoNrxQN2+Q7Cd6/uA/WdSUMTXIhB6a9/8yoh1
	 12sUU2BX4foGkELnkuMWRdaNES6HSodx2oWIT65flAG/54FS6aFzJ27dKuIEaEinXDY/R
	 zGRct6EDq/2ms4dKiWozymFbap+HOeumH31NxBMk0my4yuG8P6LlxUKW2QhXrCTn48yrE
	 yRRkPVO4mTCDQ054yZPGITdF7h72rUSRALQ6pGz820r+eO8ktZgV/Xy/92fbeHpNSEUvG
	 hxUjgFwQFvtTlSzecDJb+EfL8q1Yn0NoqtwvvMQv3IFu1LedM4YFDV/DBzpIDYRL/nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ia509vguSL4R+wVxynWs0pl/yoR/mM5jf7Kha+E+TuI=;
	b=l62QYwGFETDAEurUgALJduOdCA/udDtFIbqKeqjUoWO2GX9sllQD8gQwzJHiYTimugdV
	 Fp+tLFQ4DTCYSaXKWS9ITqRKDCSDmKULuYc3BlkBxEuZhceu1Srdtgs6EBwhzLOTT2I+v
	 ERlpSs0HhJYgMwBhMsbsgMtkxl+hiTKFErqqQB3VHCTPxrR4ASPyD3Ugr8KGH2BfG7KTC
	 x1gRmCLtuz/F4VR6Qs/JKxmfXTCZNd2K1yjgyL1/a+JUHGIgtomAUPgTWaI+OM25FmQ5U
	 qVqa8PeqiX75TZGBclokeQFC3RKwDMvkpUSLYcGYCDwH9aKqTZQTc+ciEP7hkpQ1ROw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d/29w4af";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95A6606A88F;
	Fri, 13 Nov 2026 15:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d/29w4af
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650C81F000C5;
	Fri, 13 Nov 2026 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585423;
	bh=ia509vguSL4R+wVxynWs0pl/yoR/mM5jf7Kha+E+TuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/29w4af8EPuy4r9XLGQfsSvNr+kxLBduLLPmrpnHcwcfzH0hkHLsTKk0HzWpysNU
	 P4Giy9JBZV47+XTGEQMnASbQo70yYNzJD3YYtma9IlK9nphrrUdLmRujXXWe4NiFlJ
	 2VzJ5LwDkogYxZvKQXs55rn+pmWsW802NHYcs1Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 087/507] batman-adv: tt: ignore ROAM flag of received ADD changes
Date: Fri, 13 Nov 2026 10:46:31 -0500
Message-ID: <20261113153756.913198016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit c5d68abe6e7f1dbd132a602cb696fe1fff0389eb ]

A received TT change (OGM diff or full table response) with the ROAM flag
but without DEL is handled by batadv_tt_global_add() like a ROAMING_ADV:

* a newly created global entry gets BATADV_TT_CLIENT_ROAM and is
  therefore excluded from the global CRC. The sender has it in its local
  CRC and the receiver has to request the full table again
* batadv_tt_global_purge_local() removes the local entry of the
  receiver. The receiver's own client is considered as roamed to the sender
  and frames for it are rerouted

The ROAM flag only has a meaning together with DEL. Drop it on reception to
keep it from populating the global table with a temporary ROAMING entry
which is not part of the CRC - and therefore causing a CRC mismatch.

Cc: stable@vger.kernel.org
Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 68f79853032ed..6802203119dfa 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3408,21 +3408,30 @@ static void _batadv_tt_update_changes(struct batadv_priv *bat_priv,
 				      u16 tt_num_changes, u8 ttvn)
 {
 	int roams;
+	u8 flags;
 	int i;
 
 	for (i = 0; i < tt_num_changes; i++) {
-		if ((tt_change + i)->flags & BATADV_TT_CLIENT_DEL) {
-			roams = (tt_change + i)->flags & BATADV_TT_CLIENT_ROAM;
+		flags = (tt_change + i)->flags;
+
+		if (flags & BATADV_TT_CLIENT_DEL) {
+			roams = flags & BATADV_TT_CLIENT_ROAM;
 			batadv_tt_global_del(bat_priv, orig_node,
 					     (tt_change + i)->addr,
 					     ntohs((tt_change + i)->vid),
 					     "tt removed by changes",
 					     roams);
 		} else {
+			/* an announced client cannot have roamed away from
+			 * orig_node. Only a ROAMING_ADV is allowed to add a
+			 * global entry with the ROAM flag
+			 */
+			flags &= ~BATADV_TT_CLIENT_ROAM;
+
 			if (!batadv_tt_global_add(bat_priv, orig_node,
 						  (tt_change + i)->addr,
 						  ntohs((tt_change + i)->vid),
-						  (tt_change + i)->flags, ttvn))
+						  flags, ttvn))
 				/* In case of problem while storing a
 				 * global_entry, we stop the updating
 				 * procedure without committing the
-- 
2.53.0



