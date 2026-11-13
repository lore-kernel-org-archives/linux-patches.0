Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591299;
	b=Ua+HZg2rRtJf134x5cV+nNT4Xq1ICOF7M0xowJdi3KS3VuEi2MVcq2OdaGols87g8RMq
	 RIXS6JLklfmw8m6TVhxnFHVc22vaX82GbSynPm2moNAa2qoCCS0ms9drdHFQ8sJrIeG1S
	 TRCcJ+ypQCuzByXTzs0EB1NxD4v8dmx09NnBRRRtvq6zS1yCIVMgk8fUkX6547JxJCuMa
	 YoqZiX5Z5ZELD7/9hY0H3pvJ+mxlJfirEN0nEVooRzWf0llc4KuDbXLea9MgASUpL0M0/
	 blGU3yhbpkSrnqm7ySL2iBWgjP5H/zKZMkUHMzdwSqhlR/XxmIi1SPjFFBXkvl0X8xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WXuF9W785pfddw/hPwLHpuVQ8mto8KYFkB6ijhp50ao=;
	b=O1ffHOiLbdqYH1DtLr8zrvQpYAG5o46zCCIFDZQCf1KGRjuPWo2H70WZQCMu5FO899+B
	 9TpoEP9Z/4zqMEX2h8hREUQZbCcE0Q5xioZxe1plQTZ7N6OLZHeV/q9644BOwxUxTY9B7
	 QznSXAg7jQ7Pg626eM0asJU6UAeVy5YEOtkHqLuvRzxhlVtMGD661sJiMy2jY7FjWZ2KT
	 iLPbTv3jI8NgU3E/bzJVB9L7DVLqhvRQAjGQT6bjnoEzk5WAc40r2TcDZs1H2OzXO2lZI
	 JoIOwXpF94rJPjn5DjboByBFfBhzorsEX5w6EDBFv97Wzzu+mC1S0nmWuGAOeCwSn7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvGi5XUb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC87606B205;
	Fri, 13 Nov 2026 17:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvGi5XUb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AF21F000C4;
	Fri, 13 Nov 2026 17:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591299;
	bh=WXuF9W785pfddw/hPwLHpuVQ8mto8KYFkB6ijhp50ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvGi5XUbIlLo4BOtim/RHvnCuPommgMXz6YheFGGaGM/QB9zfWlMON1CsOBmMx1Vp
	 4aMSgWCU8ktTYExybEicRn9BTrbwm4+vMfV1w1syT/WO5cHPIyeuuGheO97WI0N8+Q
	 g0HM17AKMtNKK7P2GKYK2+iTHijZYpF+mIyAujOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 415/670] batman-adv: tt: ignore ROAM flag of received ADD changes
Date: Fri, 13 Nov 2026 10:49:39 -0500
Message-ID: <20261113153825.807460373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit c5d68abe6e7f1dbd132a602cb696fe1fff0389eb upstream.

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
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 8397b9edb5aea..96d67ec1a8af9 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3339,20 +3339,29 @@ static void _batadv_tt_update_changes(struct batadv_priv *bat_priv,
 {
 	int i;
 	int roams;
+	u8 flags;
 
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



