Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590600;
	b=tv7oJe8GhEHmhmMyLiRZf7GgZJJjLFI6XxLH4DnzYk2Hxkx0eVxIZGm/s4yWm4iUHWiM
	 wZA2KA6tRD8e5vblAPV6Ltm2FPS7TqXJKu94jbrGjNVW7nowOSbbFpOuefHyKIja6s+jR
	 rlDqQAbGrWrdk1ASxaeRDjd9KEWIVyl1krrge5KmD2hGjaKjc44GvUUkFchaysClFtN1f
	 xBsFv+3Cw9e8yzME28yiLB/0zT9zedWMdnS4RgnNamk1ewx+lNLKlZL4OEJMFC5uIreU1
	 kcVRSm0rj70SRk7j8Rw+g4iXd4ozjrPOqhIrImXfILcxTFRsp/Bogze+M0Y+IgUxzIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HtK8jCeN1NH6O0Cf1XsNbcs4yETxmwJxVjEUKvyaSok=;
	b=2X+zcWxizMvkHOk0sCkLy7Qd89SDtXuwcBvugZ/zUO9bkNn2qZgof4mO51sAzCv0J7a4
	 ntim+ziXfuv6J+cNrRw+uoIfC/Ude0+7hQwQAC9f47zt7lrR+EKHfX3az/BG6/wxsOmLa
	 U4hE8DRoJC0KQ2y0w6iA8uZzpy05srdF8xNq4qMttoe5W3cmrOt+whdcZKLMBGnAJvm73
	 iFCWBYHE9+UcaejmoD25zE9LmcAqNIXQDmu3GteMEpoW9izTKDv54/t9JJ/QJdRzC/uWI
	 JayX0ox8XpFLD6W/IEvnSKDt7/5QVKU+tMec+XO+X7ZhxrzG/JNRhLQy2y8U5HdUOOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jynIz9FW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD416073FD8;
	Fri, 13 Nov 2026 17:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jynIz9FW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280EF1F000D1;
	Fri, 13 Nov 2026 17:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590600;
	bh=HtK8jCeN1NH6O0Cf1XsNbcs4yETxmwJxVjEUKvyaSok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jynIz9FWAVzyOx5rYrc6TvOlxiil1GXy7Lf68vy7NMJW9qo/L3VGEcVs6YUyLjdKs
	 g7Fba4c3fcnsAStfmXrLVTepUEMdWKztpWAcVL5aEApO0iEIKUqxLHWVnnDloi1DdM
	 WP3fSafgLqeeS1srY9tjDz1w5JoGiBwMAZ7JdL1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 529/686] sctp: hold shkey across socket migration
Date: Fri, 13 Nov 2026 10:51:02 -0500
Message-ID: <20261113153839.060933403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8c9970352952e..285cd8e0a1cfe 100644
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
@@ -9669,7 +9679,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
 	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w_migrate);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
-- 
2.53.0



