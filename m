Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585862;
	b=FFYV0re75st89SGshgIHSyuFF5c2BXUy7FG9OPjNevD+t6ltbLrGwrwNIafNZ+XdifPd
	 W2h2Gi57/mcR2FEP9FO2UejHWzb4JfUmooUZIrkpAgQ0xqkITDzBv3kTnQvvbkJ/5DhGM
	 ktVqJiHtx81YMu7TLAB0QfdeucOi6ymk+zpXYeidB+ElLncbU+wsVQoRsvc7RlEwcdicc
	 sLU1z0DXgcklsmht+QX7ou1TcZe58XjMJ1POPsAlt/J2km0b+7G8hvQVxHmSTNHOqNv4z
	 3m4OycB8wPTsXasOe4CTHR0gypEf4tZTFtj4F8vmM0NqIu5s4FNq6dB2Y8QDYer0/uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kGmenLHEjHKa96G0wAJlSYMtzfj3z6ZSeyUlyrps/X0=;
	b=C1BUv5pLKycMY+6/TGak7xQgfQI6XagIm9sl0DBInL0BwARumx+C4Qw5LtdKN8gqYwfv
	 rZOReJipClMxZJ7/PeABhIBX92GiRqQKaiwhDLHtI9CqfhXpSDpPbDQEesjWKBzbJ1oSE
	 F2DOpY17ZzO7PzD5+KMIdaiyG2LupgziELZ2kN9l5evg+ZaEFfHmFw+eUKtCYB8nXcQot
	 0D1PjLfTuWDf3bkKLmvj43Bf+DVFvJE7NWlfIyOhxcD3F6wu37sgkWg0uxLzE+2ngrjGV
	 s20JnF9wAbl9iRvyu5T82h3zFyMQilQGiir1TsJ7Y9zCBg018Rhva8Nh3QBxVr7Ic3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pYL6Ggi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF3E606BAB8;
	Fri, 13 Nov 2026 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pYL6Ggi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499031F000C5;
	Fri, 13 Nov 2026 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585862;
	bh=kGmenLHEjHKa96G0wAJlSYMtzfj3z6ZSeyUlyrps/X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pYL6GgiUduGHCSrvm1S7cAZ6zldJ6lMAisMA+EJNWI0PobDojo2KxhDMzSVMmHmL
	 TAf3j2TRIRQEaBThuX741Rg5TLd4SY0CdoVjAy3Ws6vsf/qRVFc8SZ4CYeZTZL4Ksb
	 fPcWN6ll/gRYI9Usk4b3d3Xb78YVGwVNdXMsWd/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 436/507] batman-adv: tt: only transmit local ROAM flag together with DEL
Date: Fri, 13 Nov 2026 10:52:20 -0500
Message-ID: <20261113153811.513713211@linuxfoundation.org>
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
[ use direct tt_common_entry->flags access ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index b1dae5e1bc23d..d1b1b8459279b 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -436,7 +436,6 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 	if (!tt_change_node)
 		return;
 
-	tt_change_node->change.flags = flags;
 	memset(tt_change_node->change.reserved, 0,
 	       sizeof(tt_change_node->change.reserved));
 	ether_addr_copy(tt_change_node->change.addr, common->addr);
@@ -444,6 +443,15 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 
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
 	/* check for ADD+DEL, DEL+ADD, ADD+ADD or DEL+DEL events */
 	spin_lock_bh(&bat_priv->tt.changes_list_lock);
 	changes = READ_ONCE(bat_priv->tt.local_changes);
@@ -2851,8 +2859,12 @@ static bool batadv_tt_local_valid(const void *entry_ptr,
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



