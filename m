Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017739;
	b=RU7Z3LFQctlh+ZvCqwLoEx3xGhlqYcJ6KRmWILefiuF9IyM4wwkKIqG1bcQ0VXSSGtZn
	 63VNecSoJueOFRYV6+X8h4iEiBNss6rOYePWa90hZq+owoVV0PaWNfn8/FfBzrhn3YldB
	 HbkPPxAd7F2KrGTie9HKCPSJbXGNeIt0y8U3r6K3RvZrMoXP6PspWFNWGiWFN04TfPs/f
	 P2gRp4AomweyYqrpEHhg/IQs9eS+gUqQ386H00wbOEEh0b/pCVnTOpGZU+/Jc82nowXzI
	 ULzrbRUS62ZsLZd412/Z7wWs71xD7WOxL//St2FVkIItR1OkKnJs1eT9CJqtDyVeS4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+jrFf4KINjB9ekVc/MFIhFpHM3cS3oC6HvjTQ4kp1Us=;
	b=E8tjI3fsUz57MRirpAfFmvRBWPR07QH/WOePnnZVVkpa9Sx/deDVtXQrlf7eBO3J8YF6
	 gjOHpSoT341e5BS/+9ivTrFjcPJjkuDZbjCN0eZtg+T3rRXdqNEgUYVWdzaS9hIk4QPXU
	 O2NwJ/fJdmzLsC5K3RjwumpY69qsf/GU9u8PqNHgodI2rHAEp+6QHPVLCXPfZwGTUsbBY
	 aW/iYxNRi4Xl1h6VoN1epP8Ea5F/ZV/3bMpVnaHIRlFm9WBg6d+0SPTdIk1WjiAAyZ64s
	 EymJfHLjilqk0TuhpfxmLLmyy7j/YvLCXuPIkSgB3YdPQP5it150j2ghROEakVvoeuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k/J6pEZH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052C9606A325;
	Wed, 18 Nov 2026 16:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k/J6pEZH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042731F000C4;
	Wed, 18 Nov 2026 16:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017738;
	bh=+jrFf4KINjB9ekVc/MFIhFpHM3cS3oC6HvjTQ4kp1Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/J6pEZHDH5YM4l+KudJPMg6GjzQdUTu58n8sEQa0EJkft46BmaEXs/3CEQw1l2sq
	 0R5BSy9ADnhTy2uYZmg4hhz2RP1wRMEUP08naV7uWeP+lJ2UqBR9feLi2Pg2dd8nq7
	 Pr86kUfpo9WbejFVXl+bqnUHm7rxqhWkvn1YZbQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0990/2651] IB/isert: Dont share drop_cmd_list across concurrent connection teardowns
Date: Wed, 18 Nov 2026 15:37:10 +0100
Message-ID: <20261118150323.543680355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit d30e9b1bc47bd9be4b2fc97b0e4074bc02c4203a ]

isert_put_unsol_pending_cmds() declares drop_cmd_list as a static
LIST_HEAD, so the list is shared across all invocations of the function.
It is called from isert_wait_conn(), the per-connection .iscsit_wait_conn
transport callback, which runs independently for each connection during
teardown.

conn->cmd_lock only protects each connection's own conn_cmd_list, not the
shared drop_cmd_list.  If two connections tear down at the same time, both
threads list_move_tail() commands into the same drop_cmd_list without any
mutual exclusion, and then both iterate and list_del/put it concurrently.
This corrupts the linked list and can double-free iscsit_cmd structures.

Make drop_cmd_list a stack-local list, matching the pattern already used
in isert_free_np().

Fixes: 3e03c4b01da3 ("iser-target: Put the reference on commands waiting for unsol data")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260921031100.2199-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e69db43370ff9..efa8d7b7844c9 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2583,7 +2583,7 @@ static void
 isert_put_unsol_pending_cmds(struct iscsit_conn *conn)
 {
 	struct iscsit_cmd *cmd, *tmp;
-	static LIST_HEAD(drop_cmd_list);
+	LIST_HEAD(drop_cmd_list);
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, tmp, &conn->conn_cmd_list, i_conn_node) {
-- 
2.53.0



