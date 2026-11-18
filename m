Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057579;
	b=D3WALn+rGK4L+l5RLorpurh3uLSb3Ztnai0HItJD+08RqjNzyu0AaEfb/6eZa9DaU3pr
	 rWKwOZKU0bE8N82vLhjfZ+F0ls7GyHfK9AyYo03qxfNRl7YWvV2hrPK/dDJ4mqTfPTTCh
	 gqzix2MOkIJrhWqDFf0bhmCcN0E9hcH4oQRp7usEOgVbw8bNe0IQ7XQ+UV9ecBlYs+7uj
	 7W7ee0joDOTwmN7tww5jHtXCaU/niSFMdSVSpQKt2pIJyJh8PMY/UcqvcC3AU+BVieYcA
	 zi93HL4SRv9rDtAdWNTCaT9fgC74K8UhB3D6LSwzBU9VXpVy3xngocR1rixNC9VVICQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QafXqsAfdx+9p0D97bbIDUh2ddC0U8pefGxWu67pry8=;
	b=UPldnx/UzlAoPlN1WB/nZ+NwdEU7Pqx9/cpll34NhjYcVZ0hKISaXik8L1CDABkHuec0
	 KaOVV7mGwWbLtpFgd3yjwF7L9MS291JllC+qvBxpwqT/UpuvByee/bF8uz4OW5AZoljPz
	 lIOZ61jNVwBBwYJAQbl5Vj30mt4SDZJMNtw4gkOajrw6vubWW6BCSs09c7Pp6RBe+O0sa
	 gRuCs3/MZudFoXHS5c8ooewyKCTn//WBqRGUbnPbLelgdgi40+4Xx/N7xBIcAX6Woy1pG
	 HkHVhC26hXQBaDqgQtEahGvKrTzN3ABKh0fKSUhpXuq3Ta7BRxew/WlAeRsZdfeyCoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRB5BGNg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5782560A2604;
	Thu, 19 Nov 2026 03:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRB5BGNg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD14C1F000C4;
	Thu, 19 Nov 2026 03:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057579;
	bh=QafXqsAfdx+9p0D97bbIDUh2ddC0U8pefGxWu67pry8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRB5BGNg1p7l4uXlED8R50GHyMCnSK9k4YNG02b9ticLVZwQI54sLGOiCrKRU1cTq
	 VPkpJBGI8BI04Uq/u5gGdnKUdQN7qeoOAbelGp8FSrLNbw+n77QU+Hd+fIL9x7p+Hb
	 Gy2rNFOsPGPawRYRS4qIw6Y2CLKzr+hYq4rzGnyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Rausch <gerd.rausch@oracle.com>,
	Sharath Srinivasan <sharath.srinivasan@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0145/1848] net/rds: fix rds_message leak in the rds_send_xmit() drop path
Date: Wed, 18 Nov 2026 15:36:23 +0100
Message-ID: <20261118145917.369155910@linuxfoundation.org>
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
index 48132826ba00c..bd27e73e30849 100644
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



