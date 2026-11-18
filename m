Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053575;
	b=L5OX+4RT6LMkkHUG/Zag2GKghblG5aS/vT2QeNGsYegvM00b+Mc9xYSTERdFvacj+lR2
	 alld2BwLEHnunYBhxn5fDlfLShu1wN58sX6HSinKy+eCfYsPl8MuhZ/uXKVoY9AkJ/NOp
	 GhhTztN5rqqhGQuPi9yl1WJulsSv4AIW5tafM3Rlxcyt1jpyJDL3BihIaWg0v9wyWoTPP
	 tHFFfL6RBO907sHh+t+7XQd+REXXcr83f5qEnzFH66igQXJejtFJzs+4WnnoJRLpKq8pl
	 z9n3tf+ps3NfS+tYwjr45pMbfkcsrG8iMHdkYS+CYJ9Y5cckrHHHWW1MdYigJ44YpMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YBxjlLxKebFTOIY2TsPdi501qgqfVY0hzDZBjA/3134=;
	b=wAp3aDxCQXLJPfv4L2kMnzDU3GMUs0F4jV64ooqUAZ4nQFqBn6oMRzVgBZOJTAJExvXr
	 tNrZa49L+GJ57TNiQSUQlfb+ECUk5mFPGSxhXumxbKtAKiJIWyxTmbbfUCX7meZQPKW7t
	 0jDgTsCRLfbQnp4z6cb/sxN5wr0UwMx++y8n1VS1tkGxck9MiNu3K74Ct/qU8bBiqUd4z
	 XWGzUS54soi5HmeD292EBee5+rSoUXoVaJL2B50zka+fyZuL6D5xc2l7NtFYQH5vaukE6
	 uXq1TA/8QdrTOOWeepjw3aHm7Rs+ckLCdLoncqJD8Y1y9HnW9H4clZxpyk+hq4QrGKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AARzyA+k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99363606A320;
	Thu, 19 Nov 2026 01:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AARzyA+k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBE51F000C4;
	Thu, 19 Nov 2026 01:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053575;
	bh=YBxjlLxKebFTOIY2TsPdi501qgqfVY0hzDZBjA/3134=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AARzyA+kPeyy2dWoWVRZgJx50ouch21E8diGR+APKQGXbtGAqAarDK5YXDbHCA2ZA
	 ROk3PmVVWRGA7ooQtYIr8FGqDkK3zCP6oLImrn/zLEhBBecdL1OPzUYynXCJ9G2Q3o
	 sEyknSo7XqSERVlL1+1oIJCmOKZz4vdlqau2PwC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0967/2214] batman-adv: tt: ignore ROAM flag of received ADD changes
Date: Wed, 18 Nov 2026 15:44:03 +0100
Message-ID: <20261118150050.975350271@linuxfoundation.org>
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
index ed74e02f5bb20..11b01428e707a 100644
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



