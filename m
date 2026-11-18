Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059428;
	b=g6Oiy0Zrla0r80g1TRQl9itUa0peOuoEUJlOtrZLqEN93m2jNOaGDt9hNEqXiB4lg851
	 4jQwMxyy3KtAMaQZ/kUmV6JaVPDpp+2yXJ80t0NFvlhxxGegX+V7Cdr2LMt5VgBqyRZV5
	 D6feQBDiaS0fM8DSWQx38wjsjAoa3xZGu4aoWbvyVNyETS2bkPbL4IMlmuFgr1Grhhjm/
	 qUnxe8G6vmrY2Vme79cFzvpm/hNttMtJqIhMHuz6StyagESzO+9QJFDoBnn4aO+hNRJhn
	 giNijs53Dx3UJs2sO+5VuggZgmMgEhk+85353OZCgL60t5QNemqswSCFfbFAIVg6WYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yk5LH01t9C25WzWEJtlnDpRT7LfKmzmqdE7vUS9qTWI=;
	b=iCBlpchPQeQ5YlezUcvDy1iTCyhIiHHNdZRyMrftq0DIVDkyd5Q4y2fi2VdDThgHqOO/
	 p6SPIB1tGeCJ2016+WlbkRIF4vPt41Tk+byBhk9ve489lPMo96OFsyuH8h6DKVMdFjuXW
	 wKjY4Eb0v2ZeDw6oUm18suIj5JbtMkOZTDNvgdPG9z2yLSwGVAXh70NidvB+1ityxCi/x
	 pBpIrGc0dEHtBbW89PU8TkFyqWAZySXsTAc4vKDnQE1fexIeCYb9D2QwCvhDhoNETPOI3
	 6bhPTDEe1wc/EciSnvgOU4kOLjw4QIVmJ5bd6IiL2P7/FgnBNNRExXeVJgvdtDieGMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yJAZpDrb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301EF606A330;
	Thu, 19 Nov 2026 03:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yJAZpDrb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9141F000C4;
	Thu, 19 Nov 2026 03:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059428;
	bh=yk5LH01t9C25WzWEJtlnDpRT7LfKmzmqdE7vUS9qTWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJAZpDrbmtRCdMHNHJKo5XP33aJ3ebxvBL2yW0L7QTYnGwO3dZCj5KEPDwM874sPU
	 6h6PZwexj5Cvw/mo/YAqidY6+IdmNTeC2+De+gkCnM+yTh2sICx35TqWn08u9I8blT
	 Jglg4tS0sHbPN85lLFQA8yw5cY/z6oqAfHi00iUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0836/1848] sctp: hold shkey across socket migration
Date: Wed, 18 Nov 2026 15:47:54 +0100
Message-ID: <20261118145951.665149298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit ad1320865b1826ffa2e81e37c49535751e81335c ]

sctp_sock_migrate() transfers queued DATA skbs from the old socket to the
new one. skb_orphan() invokes sctp_wfree() during that transfer and drops
the skb-owned shared-key reference.

If userspace has removed that key from the association, this can be the
final reference. The following sctp_set_owner_w() then dereferences the
freed chunk->shkey while trying to take the new owner reference.

Take a temporary shared-key reference before orphaning the skb and release
it after the new owner has taken its reference. This preserves the selected
authentication key throughout the ownership transfer.

Bug found and triaged by OpenAI Security Research and
validated by Trail of Bits.

Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261009074244.3718-2-juny24602@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 52ffeaa358d1 ("sctp: re-point retained control chunks on association migration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 96215fc4ee466..a3e9996120b89 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -146,9 +146,19 @@ static inline void sctp_set_owner_w(struct sctp_chunk *chunk)
 
 static void sctp_clear_owner_w(struct sctp_chunk *chunk)
 {
+	/* Keep the shkey alive until the new owner takes its reference. */
+	if (chunk->shkey)
+		sctp_auth_shkey_hold(chunk->shkey);
 	skb_orphan(chunk->skb);
 }
 
+static void sctp_set_owner_w_migrate(struct sctp_chunk *chunk)
+{
+	sctp_set_owner_w(chunk);
+	if (chunk->shkey)
+		sctp_auth_shkey_release(chunk->shkey);
+}
+
 #define traverse_and_process()	\
 do {				\
 	msg = chunk->msg;	\
@@ -9462,7 +9472,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
 	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w_migrate);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
-- 
2.53.0



