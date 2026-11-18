Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046744;
	b=Vha4n8ZoCEp79bMJeMYG9hrdiCbWPASkq3Lg5Z4gUCiLdbNsPHh10qXoJilzrHqGSeTj
	 r/R9hqemvcX4qLjsuAfF1OfBO4pDCfjeK+WJYUr043U0HEa/cc7J2dO5yOzhIBQ67/zl4
	 7UV8LOS+iwTaEyDzyyLDzCM2NAj9vBa3ukia+h4jJbYkj4MISRb48OtucoGBWVOV+CRVW
	 o0IqjlCjY0znTK1TLqTf2/ywB4H1pwdp1cvBp+t0xK7IQg99MBdirZFn6uicsw2YvMHhi
	 0tdWXUEeiQHuSSuuu3uE7yqwI6G0Cfc07i3W5LF5hfs4Yw4gjmeKXezu71bF20soaXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ePCEBQLRMufPiFX1pg3Xf41xfhcA4OQKfZvFW0JAnyM=;
	b=cGqhbGokUegoK0b/BiQ8eAJNDhE4GEeCIILNXr1jxfQmyxVvp20TM9B/mmUoahaEew/a
	 MelyfKmISP7o/lJlKA0qmx1y2XwL8V/JR3WBhB0icmLsSi1Eiw8rFma21iVqEOVBwUoW3
	 MitMhbS6BYYExyZeLtCYNTU7mS5M+WVajGbktCD/lL3CW+9bb1iuyX0kVL1IrOllr1vcu
	 xvukB2q9DL7MyGP+QKKg4xyRK9fCmBTe4t86dk5y1NSr5Y9qeKkWxDTSVHJeGqQlHcA2a
	 iKd0dbaIyYN8EM+4J/oP+kcPf0Pt7iGwGN1OiOkqDU0KjSEK0ex6O/LaiFqtjG/v5Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XKEtHiPl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAE660A260A;
	Thu, 19 Nov 2026 00:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XKEtHiPl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FBD1F000C4;
	Thu, 19 Nov 2026 00:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046744;
	bh=ePCEBQLRMufPiFX1pg3Xf41xfhcA4OQKfZvFW0JAnyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKEtHiPlMBglPv0Prsy+BGRm7zwATkuRfgD2ZkaJR8bPnu7mDHQoDYN1ewf0XMSRC
	 ZjMtVeUWvBfQLwLh4k7kDwhs32EjCM/Wq2YyeSMH1qHbFfl4oTv2XUfmY16klNw1wI
	 Qpqjq1to+JOVZl8Wa4b/JAwKTcL1ahv/dOHmr3/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1391/2857] sctp: hold shkey across socket migration
Date: Wed, 18 Nov 2026 15:40:25 +0100
Message-ID: <20261118150251.445685166@linuxfoundation.org>
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
index e9e13ba9ae4c7..04c3b8a8d2dd2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -147,9 +147,19 @@ static inline void sctp_set_owner_w(struct sctp_chunk *chunk)
 
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
@@ -9692,7 +9702,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
 	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w_migrate);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
-- 
2.53.0



