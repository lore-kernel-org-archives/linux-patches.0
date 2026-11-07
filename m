Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060887;
	b=IY33ExmxOFs/Z8WueJToNofoYwapDqop/tX1E0m8dogxMTNLQa8jnbS2wC9EiYhS7qNe
	 z1XzyZrqZ1zZrQF0Y5jW7r/2GXc3XU0kdVgaONnZfXtTmMgYwqBOe4BpomvvJRsVea8ZP
	 CD6AJkTVibHyFLxTUJQFZ5/nJBh3YNR0lvbtX/P7Gh+Kziko54t16lNEGeMNDRsB4gUBy
	 ZnbLc5RrUdIZvcVSYG+t1CVm5/V5v9QEyNx0ylYxkdm6LMf9eXhytU7FxkNNuUanFC6qk
	 g5sc+QUAUWD4Xf8X2y0GMbK6FBpYuIRd2JK53+dHJ4P/AYFD4a2BGDSnKcr4d7FpX4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UD2lkiSdsewqxipVZwENQB08whCfZKCsBmT5LA2BS3E=;
	b=C9ONz6yr8hGAi8IMHdyu/GLQJQxYMwZ9j3/nYxJUDwbjX4cFxNmGO9Z+jBPVjmWWPaym
	 6HKxfQlieltS/y+sWlUmAVYEDdQ0Fn1I++eFp7S1aZ9eQbIgraMkVD1t1Ksaf7Io1kQgY
	 eW6a219m2DF/+QsLtePlUsBbSjh+yhNZGrQTeqEa6cEQILUOaUA4+Xbf9N6eIsHnQagJk
	 +D4/DLeKb/FKmfDHVI5zPl0F6IogNyDNn9Gbfg1WeZsp84gJihYCXFyiBuvHX8J0eL1UI
	 DClbO3gJ5B7G9J9Uk2zSQjtJJI4CbjecAfQqUlaBPRCfjHEEMs3p7wBFDcY4r/cZjxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HCnQNPzP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68528606A336;
	Sat,  7 Nov 2026 14:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HCnQNPzP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105C11F0089F;
	Sat,  7 Nov 2026 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060887;
	bh=UD2lkiSdsewqxipVZwENQB08whCfZKCsBmT5LA2BS3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCnQNPzPrsJsgrFsveHx+vmxldras7BfJwg/tAb9wjOrcNyzKNnEjYenGKH/BEErI
	 q4INWocgCeCH823EoKOVRYkCmIlo+XiCB5cGLOzyZVx+O/BhUtn8B0Qe+uRRXl9kp9
	 lHSMwQKKzot4ekPxIQw4Y1cKgm7g8ed96dZoEnPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Rausch <gerd.rausch@oracle.com>,
	Sharath Srinivasan <sharath.srinivasan@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0265/1536] net/rds: fix rds_message leak in the rds_send_xmit() drop path
Date: Sat,  7 Nov 2026 08:38:01 -0500
Message-ID: <20261107135005.125590359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Sharath Srinivasan <sharath.srinivasan@oracle.com>

[ Upstream commit eb8a59a17f4a8b6f2afb4a8063e99dd96cc3fab0 ]

When rds_send_xmit() picks the next message off cp_send_queue it takes
its own reference with rds_message_addref().  If the message then hits
the never-retransmit check (RDS_MSG_FLUSH, or an RDMA op that was
already retransmitted), it is moved to the local to_be_dropped list and
that reference is dropped after the batch.

However, if RDS_MSG_ON_CONN has already been cleared, the message is
not added to to_be_dropped and the reference taken above is never
dropped: cp_xmit_rm has not been set at this point, so the loop simply
abandons rm and the rds_message (and everything it pins: pages, MRs,
notifiers) leaks after an RDMA error.

The only other places that clear RDS_MSG_ON_CONN are
rds_send_path_drop_acked() and rds_send_drop_to(), and both can run
while rds_send_xmit() has dropped cp_lock between moving the message
to cp_retrans and re-taking the lock in the never-retransmit check:
rds_send_path_drop_acked() can ack away a message that already sat on
cp_retrans - the RDS_MSG_RETRANSMITTED case above - and
rds_send_drop_to() runs on socket close.  Both unlink the message
under cp_lock and put their own reference, leaving the xmit-path
reference stranded.

Drop the reference directly in that case.

This mirrors Oracle UEK commit "net/rds: fix rds_message memleak in
rds_send_xmit".

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
[achender: port to net-next; update commit message, checkpatch nits]
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260730041629.3512480-4-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/send.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 02a29d453bed1..27cedbbd140db 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -288,9 +288,21 @@ int rds_send_xmit(struct rds_conn_path *cp)
 			    (rm->rdma.op_active &&
 			    test_bit(RDS_MSG_RETRANSMITTED, &rm->m_flags))) {
 				spin_lock_irqsave(&cp->cp_lock, flags);
-				if (test_and_clear_bit(RDS_MSG_ON_CONN, &rm->m_flags))
-					list_move(&rm->m_conn_item, &to_be_dropped);
-				spin_unlock_irqrestore(&cp->cp_lock, flags);
+				if (test_and_clear_bit(RDS_MSG_ON_CONN,
+						       &rm->m_flags)) {
+					/* our ref is put after the batch */
+					list_move(&rm->m_conn_item,
+						  &to_be_dropped);
+					spin_unlock_irqrestore(&cp->cp_lock,
+							       flags);
+				} else {
+					/* already off the conn list; drop
+					 * the ref taken above ourselves
+					 */
+					spin_unlock_irqrestore(&cp->cp_lock,
+							       flags);
+					rds_message_put(rm);
+				}
 				continue;
 			}
 
-- 
2.53.0



