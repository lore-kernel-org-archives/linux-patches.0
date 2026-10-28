Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212357;
	b=e62MWuq+iVOegGw851jHk/ZBbx8QzwwposMDdTjOTwSb3WFm49jlck6V2XJAYKfwlejw
	 UBUUe8TYZLmNBZTfA28XLuE5oIb+PiCQAcXfImstBy5+j3tXnHbafyXgYHinpKQwsuk6d
	 WNFm8hPB2JL8/klLQE5Ix1/h0Tp082zaAMkCjTrw+0tAVDvd4imhQ+qbfhjVaDIE01GXS
	 faBkoBTlzuuaxTxEDoZni6nYeTR8mXOGRq0RZkqQg6cNayBRncbiQrep7NSYuBDJmqKDC
	 hImtqZTgrmWfaybcS4dC0o2iN9SOUrNX+OxFiVutoj/hSQroXIFfOACUTF+uhFpWV3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aNWNmRQlHJJ8+r4mLNLbF/T4TFXw1JSpDAED6jWxmFQ=;
	b=zHGm0zRWaysaP3Rfo8ntCVqT0B/m3lSVjNL+AXzfaBCDG0sQOOrKHww9oyQ9kgp/JMN2
	 D1tSkzcPYuaNhnGsloje/vruPnub+6zwQn0rVKuYQD/D9z2Wi5zu/6a+bLJxmeu+ASuUB
	 hNkJ+REFZKzDtqWU69ayTLC5p7CgJONXvl7G6qGawpPK+sk/GgjtWZbdg1w/Vaikq4ceb
	 3E8CDElltg/gt2ScI6xdebKCRZb4Wx5h5bBymicakg8m+JGX1WbT3qyfFzEtLOeHfVN7l
	 bfGo/1iL2eyxVIv7A9keJyEmxdnsqoDij29bJQg6pgdzaIZbpT/3SkbsjKtsdKGRa0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tw1w7oh2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC610606A331;
	Wed, 28 Oct 2026 18:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tw1w7oh2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F451F01825;
	Wed, 28 Oct 2026 18:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212356;
	bh=aNWNmRQlHJJ8+r4mLNLbF/T4TFXw1JSpDAED6jWxmFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tw1w7oh2CJAjOerDWJ9Q40J8pE0vJojCCmidDy9W4yxfzJT7MG2Brk5CZKaiTXrns
	 fIJJGdENoISjQeeYwzPCAs3nMXaZph6dEYpUTAQMHdEkMRxQ8QkPAZawox5k0ug0/q
	 /dlaaR+93iD8sT4GGUXVUBQK8ZtOGu28m2BI+A4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0126/1887] mptcp: pm: userspace: fix address ID overflow
Date: Wed, 28 Oct 2026 17:37:02 +0100
Message-ID: <20261028170502.105012808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Qing Luo <luoqing@kylinos.cn>

[ Upstream commit f9f0068e8813d8c10d016b030fc3a320d0b6767c ]

When all MPTCP address IDs (1-255) are exhausted in the userspace PM,
find_next_zero_bit() returns MPTCP_PM_MAX_ADDR_ID + 1 (256). This value
overflows when stored in the u8 field e->addr.id, resulting in ID 0
being stored and the entry being incorrectly added to the list.

ID 0 is reserved for the initial connection in MPTCP, so this overflow
can cause address conflicts.

Note: the in-kernel PM already has an 'endpoints == MPTCP_PM_MAX_ADDR_ID'
check in mptcp_pm_nl_append_new_local_addr() that returns -ERANGE before
reaching find_next_zero_bit(), preventing this overflow. So this fix only
addresses the userspace PM path.

Check the find_next_zero_bit() result against MPTCP_PM_MAX_ADDR_ID and
return -ENOSPC if all IDs are truly exhausted. Move the ID allocation
check before the memory allocation so that the error path does not need
to free the allocated entry.

Fixes: 4638de5aefe5 ("mptcp: handle local addrs announced by userspace PMs")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-8-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_userspace.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 1bc270276db46..a455303d2ed64 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -67,6 +67,19 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 	}
 
 	if (!addr_match && !id_match) {
+		unsigned int id;
+
+		if (!entry->addr.id && needs_id) {
+			id = find_next_zero_bit(id_bitmap,
+						MPTCP_PM_MAX_ADDR_ID + 1, 1);
+			if (id > MPTCP_PM_MAX_ADDR_ID) {
+				ret = -ENOSPC;
+				goto append_err;
+			}
+		} else {
+			id = entry->addr.id;
+		}
+
 		/* Memory for the entry is allocated from the
 		 * sock option buffer.
 		 */
@@ -76,10 +89,7 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 			goto append_err;
 		}
 
-		if (!e->addr.id && needs_id)
-			e->addr.id = find_next_zero_bit(id_bitmap,
-							MPTCP_PM_MAX_ADDR_ID + 1,
-							1);
+		e->addr.id = id;
 		list_add_tail_rcu(&e->list, &msk->pm.userspace_pm_local_addr_list);
 		msk->pm.local_addr_used++;
 		ret = e->addr.id;
-- 
2.53.0



