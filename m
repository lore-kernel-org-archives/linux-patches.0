Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038247;
	b=XKIGk/vw5unn9AHyIikT1vSaYBzUNRtFSQix+PJHcYZPr0Vuwx7WBeR9/P36AKkAhPP7
	 8RG3IHDaOvUt/l6wJOq2kmUVV5HQB6EQuJP59J5AIG/YBbNajFVGeHgYHGzdtahSZCIfK
	 tncwg9K0haRRX4lZjnaIU5MJXcIbi1DZH5yVZwVJi/VYNqkFvb7cHTjWNF1zL91R0N6Cr
	 27xo/ToHEUkBa7GIIxhuZNrN5RKxhULA3AMZJpJYHeg1dBs3hng7zbT0dr2UZPuq+e+eB
	 C/C8W1VMYZ3neS3x2BiLLOtELaQVABmZCqbIKOIhMMc3SPZM+yZhFPXJcavfTI0T6Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vnNum6WcG1DRiJ6foEAkIz4hpy7nN+e2k2h5atpIB0Q=;
	b=npmmVugiaSJ+f+0XjjFqdQn4InWMuljlnOaDeetnj9XJucDYjK3WuM09LSNzXlEZ5woU
	 WB4M6D+Ez7038rk2QDy6UO/1nKdDqfzY6m1HMoO7ETB2XrkxveCWUgo828Yq8JQxWkQip
	 7htSKpAzsXRR7FLCeFK9+cKDhqN45g+DMQWNjCMa8Qub6AiWoCZGegnJGVXOoiQ6fDXJN
	 b34u7aEWZcO9MQK6CVxodYrW/cb48zcQLSpSg8l/zH4m+9mrqOFQUC1YyQqQD+wde0dJU
	 XjdHFBpvE5WRS3rejXQ/TJqn852ezUwYV6js3JPP2vj4Oc1k3uYUobCFQVPdvWE893g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O7/xgShD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4867606A31C;
	Wed, 18 Nov 2026 21:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7/xgShD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1871F000C4;
	Wed, 18 Nov 2026 21:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038246;
	bh=vnNum6WcG1DRiJ6foEAkIz4hpy7nN+e2k2h5atpIB0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7/xgShDSpTO1TcgGZKevycrW2wOk2uWT2hkEVzz6VqI+8lG8y6t6QUfZsgZUpWEM
	 Pa57V7g7ntPnvMgWdlr+MW74ISkU7iArTNkvqJiZFzCQdwfPKhMYt5dRz/MHukW3Qk
	 pi0FoQyMhc/QM7qk7uiT97Y9D/2m+Q/CWZR1yLe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1650/3318] sctp: hold shkey across socket migration
Date: Wed, 18 Nov 2026 15:37:52 +0100
Message-ID: <20261118150411.261900918@linuxfoundation.org>
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
index 4f9978e4f268d..d974d5d147771 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -148,9 +148,19 @@ static inline void sctp_set_owner_w(struct sctp_chunk *chunk)
 
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
@@ -9700,7 +9710,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
 	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w_migrate);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
-- 
2.53.0



