Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038015;
	b=txatYVacxAEYOdGnUH6qFgrLV/yhSLn5RSo70Ex4oApWSGmk1i2xQsezgisI69e63cBR
	 iwo7uC5ucFn+ODFevwd98EefCFJmcZjCYu5ckQJymPrDpk9ESaBFHp8r4rFrDLgyGoUOp
	 EqcxM60kOPQVXS9a3wP55p/BykcnqZjxrXVP4dH+Gtxq+LLN/F38KVVhQ/D1eDOJGphjB
	 xdZ/uydljg5+BSecifPzLSDOQAdKNZgn9fviby/S4YqpBqBI27boz/uJN1eyqsqfiEKBC
	 1AYGl0z9GV0M9obeE1qQL5Gt0GoWonwD2/7uuTBp4R88gATBHCc/1ROf9xXXbCPzicg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ufdVwt/WOoYbajn2Vvxf/XOHcEOGn9UNQPss3N6FrZw=;
	b=vFga5NqMSqSMes3r7afX07v/IpVzoX5GC/6FmvKSGkII14Q0HXq7I0dAGodiby45QkDC
	 /CsWN5LWW43pi9/2QIqJpNobU1aiZ6QbUGVQqkCcZ2+eQw3VJ2zKeMye6g5G7kNJ4dThv
	 6atSXI/pW0fTzC3qmN6D3aNUFOGn/ELgad7gAViXeo2lEa/mRzL0v7w3GvSsFH5j3FO2h
	 2XeVCMbdQMNU0iKt0HsvB24wPCE6J4q26OHxMeoztbzpvvzH5BWWVw7Dv/QiI2aWJX+q8
	 Cq73Inzz8MhroJn3mkaYfyPDOqihLoEhJbmea0WwoiICWZvwqu4YppKeGowAumL5gWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyssctBk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6411606A320;
	Wed, 18 Nov 2026 21:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyssctBk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0483D1F000C5;
	Wed, 18 Nov 2026 21:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038015;
	bh=ufdVwt/WOoYbajn2Vvxf/XOHcEOGn9UNQPss3N6FrZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyssctBkIZdjP4FVN05QuWe6LTAGW/fgP8wdhhLqZOKrQT8iKP0EL/tnUDLzueqTk
	 aZgGUbAke02t3YC+JARsq435jFPOyY/yDI/Z6TNaa7MaQ+5MdQQyP2zbjnUh2zUKxg
	 r/oTnK0OlhISnTsQp4hcoRkuD8Gt1U7Nhl5LSiOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1595/3318] batman-adv: tt: ignore ROAM flag of received ADD changes
Date: Wed, 18 Nov 2026 15:36:57 +0100
Message-ID: <20261118150409.007488391@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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



