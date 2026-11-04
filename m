Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829749;
	b=hcAs/hsx28VqEqZLe9KJsSdkcEj5Xla6oeSxcZPvGenxmvOGVyS1YcOUooPoImV7QnY8
	 15pXHQe80e0qL9w5r8RKQI5Z4FRPEFkbOHjA8nfsGA+I7LTJZdBZDjlAi9nONs1Zt4f/j
	 y1e1mqtij8wncmRT6oe0SHrZ0MK3LeraLhBKLkLTp+qD828qEi/C7fPX6jKHmHEJxRuZD
	 lt834pIy6ied1TsOSWgJMSymUlQl9ioVS2qA0JhisXuzdD8f2P1hSCBcn+obxixtTtSRr
	 ClxZ9VPFsxPM6di4yRFfOa+9AEv/8ej0mOWX067eOXoQIoc+Gdk4g+WaQomhQNP8D0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l+2uC1D7lmIqwOM99TBCm7P1zu8/7UHLzaSxXFP8Y4U=;
	b=4nmx0gYUPdF4LXA5kixyA/EysKewL+0Y9R8jRPEGXTRlx3YC+TfCH+n7VcMWQFM0u9yw
	 36yJ2wgTfCbRoUWeUp3UFIJAPCeX5JfDf3kyipx+W6d6oj7o58CU0MXRf+WVXo1ikvjC8
	 sjVHj3Co3S+084/wwLhmFmjFUsBW37LlXLdVdFgrm/BJeZMHnClkeutxKkC0y+1o7JAMK
	 1Nl5oRWUnMqQNLM/OdgVmuUY0rsHgac20aQ5CenglXxCvGP9rAGHD/IykcXSw+7AbdeuK
	 Tck+6KvVkXae3Bi4br+xH/WBLYZageJot/nWcyPVzMRqABmnTcOjPP6RXWduZqYDelg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qc4ye4Ja;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817EC606C5AD;
	Wed,  4 Nov 2026 22:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qc4ye4Ja
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C081F00A1A;
	Wed,  4 Nov 2026 22:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829749;
	bh=l+2uC1D7lmIqwOM99TBCm7P1zu8/7UHLzaSxXFP8Y4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qc4ye4JaNO4jHnwAX9DMjfKeiFTj0tFkfsAcKTvTfJVG07d+iH04vsWFZwHYnPfVf
	 we7voNVbCs09ehJq6ulhJokRwMQlZqg4W2Jo2YSzvdpmyc/AEfHW+Ba2lEsmllVIIw
	 ZoQUnXeWj5vYMf3Ww1BdRN8Sj8j8BWPlDzbpB7pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Rausch <gerd.rausch@oracle.com>,
	Sharath Srinivasan <sharath.srinivasan@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0320/1005] net/rds: fix rds_message leak in the rds_send_xmit() drop path
Date: Wed,  4 Nov 2026 16:00:53 -0500
Message-ID: <20261104211052.905700877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 5d09c7654f136..0a541cfc90185 100644
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



