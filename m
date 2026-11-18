Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043409;
	b=34X5042dPk3eXRk9GXIvvz8jfdQQG2kTvfYfBf12DnJum8usWXNlaYayrzYaCCcskiTn
	 I2V4M3PRdm8l6mIR0S45eBv9QE9DpZ33wgR4ymh0Ojq3vlP9vswVsNI5gkSPcnfEK+nTZ
	 U8YMShfiBLxv8h2lrRaXr17s7fMBrJu9Wm9aAmh4D8RAXYopFdPPdHyFKCxKd9xK9/zPQ
	 5aqPH3IaA+Zvn41RCoWP0WFQOgTcP981O5yTtBFc0vvbjW4iwcyibp5uHsRQyzEf48Zau
	 v4/beN48k9G5yY36gHkhCXbICJ3sX5bW+zgLIQYNvSfONOSD+9s37+210YMWupZE+Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FNV1o1iRPmuPguJBGtrAk5QeP7laJOTYRLc/kJeUTAU=;
	b=zskkqrO+ojLciyCg1moMrkGXOyHcsX48u7KHHDn3OG4LqmzWxHTndo1157Fz9kzgxOvU
	 BPgo08bKVkNHhCScT6zX4gmwsZ+vQAvkJ+P/zdFE3h7pZCpDoO0z6tWmiEEMe4iNi/eLs
	 JBrfzYXE92M2z3GiyupRKC775J68LQpaYA7FeaPMvoT3tDHDgCm86ghP2oRC7kZcpC8YA
	 DyyF7noL8i9R184pRGbpeOCxfsPtoP7hwUyQJug991EzhzZqZ27HYtc4FrqUdE1UhXQaa
	 I5C+ia67cX/mCBOJd3bsc/hJDtFPvBr99JpGgn2LsluE8xACfBGCqCTyhw8ciQ1WmAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McE+BDS5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8143606A325;
	Wed, 18 Nov 2026 23:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McE+BDS5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B201F000C4;
	Wed, 18 Nov 2026 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043408;
	bh=FNV1o1iRPmuPguJBGtrAk5QeP7laJOTYRLc/kJeUTAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McE+BDS5S8m24vazAHp94kAYf0xJZeeJWI1XdGg6wRe4rTEK0y5WfuC/gXC6xq0lh
	 9gdBkXtrNt93dlsG0uN3YzQos3Lq4XT92NgAR0oEOfqWvdZ2YJL0MinYAJV6WGWY5B
	 CHQQjtzpnHfuLlLbzLRKKT85+b31713pPHFldmWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Rausch <gerd.rausch@oracle.com>,
	Sharath Srinivasan <sharath.srinivasan@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0193/2857] net/rds: fix rds_message leak in the rds_send_xmit() drop path
Date: Wed, 18 Nov 2026 15:20:27 +0100
Message-ID: <20261118150208.305035991@linuxfoundation.org>
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
index c2ef236076188..516ebd03c8400 100644
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



