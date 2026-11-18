Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046620;
	b=4xgSoQ/esKWpYjTyCyUkryK9WCNtQQwmN7oteDs+687269N8QJYCcc7Qg9GT0sAGcZtE
	 89x6iRYoTTpQJWaKTLEoD1qWYYQyPGB25atbmF7ff45lJ9gIyHW+1FZaXjrVIgG2Fe4F+
	 BeAZPxOYK83b+HUEZBdnTmZngWBdXXjR5nmOeKGj/rPADBmAaFSvKmAtFL5s5U+5Cg8Tb
	 NptIqpCRDI7ztDnfMY1KzNiFIcs4P0m54lCva0MsA3aiyeOyG/yB9qPkEHBelinvC/EGy
	 wJOvS3Nvxx3mUEEVmwCmuYNaXl+7j65sw1zAz7pCMS+DzMiq+3lB0a+n/iUxXDKHaPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQqieRhVc7qPaXeYjCzBEd7mwI38r+A7l8nn+ZlqBt8=;
	b=OPnrhyenjYan8D/zteS1D/TDcKq2YXlx3FUP8WXy3XehVNs2Gn/o1J1LxqFzJQblek4k
	 edQXVxVEE1AD+HDZ4SDw+97Xk7jHKkANQnkrVV1cJGJngpJZTDizmE7igHOhPZY9xnMrW
	 OKZy+nQJ184j9pOUYdNR0kkvYLWS/Y0ZNYU6Ycv8OIBwmQ1dQdIjmUHCeEx5Alkn1Xzzs
	 tQaV8Wnj6JkxkPicPw7jVHzN36FuPyctkQLq6G6SQb9o3W9RmA3Kv35FhbViM171tOuoD
	 f6wrsovuqZTQ8Dr0JZgx8fwLty6m1gM1bF8yp3zFQ30r4mRR4ULKkCqLcZGgKgDBOpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0hB+HFY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44700606A31C;
	Thu, 19 Nov 2026 00:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0hB+HFY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB5D1F000C4;
	Thu, 19 Nov 2026 00:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046620;
	bh=IQqieRhVc7qPaXeYjCzBEd7mwI38r+A7l8nn+ZlqBt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0hB+HFYTlR+/l4yt69J0m0kwvDLuicMuDswv25AhXTGLFnq8qqOT32Megsyq7N6h
	 /pHu7O57iktmNSM8veOI8ybNn84fqIi95zTE+IK9wylxLDyMnaLpqkP4mht7ipOcGx
	 bB5nVr/yyMdGMMPSx6MCx9ybARbVorwhqoGFp/QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1347/2857] batman-adv: tt: ignore ROAM flag of received ADD changes
Date: Wed, 18 Nov 2026 15:39:41 +0100
Message-ID: <20261118150249.917356823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a2b38e5980615..8ff98e5dbdbb3 100644
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



