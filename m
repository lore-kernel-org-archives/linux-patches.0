Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030350;
	b=l0/LGMWiHY7vFB3hyq9WW+CzVnaaM9Acug83W4jo1Nv4UO0oMasXGTfEVUkNJJdA02XR
	 tfmW77rmjK10DYBWV3TiDLRn9oBhOL5E8JMEnTc8KNmep2At0lCQeV6Ol9NlXg9+3/v/t
	 uQwNQk5A4Pm41hHca1lz7shK364hx0fQB4YiskPAHrJQ6DGDiIp0kMy+db+HfpRr82Dxo
	 exsP2Z9/gI9hER5Maz3lG2c3YGQGFntu8DPOGRjUmtYtS1liIcLKixuhn3ho1MZ1Ys/Pp
	 9siNYsDGpZLz/fsNJVspIVdHq8nkjcHHSis/ypYZP40he8BX8UFA0Quy6TJh8oPjXwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2k+JOmMYH0FbF58Frme9GJZSFhv11Q6ZbZZbxeYNfN8=;
	b=O86cJHZckGWmrX4D8as8ycTw4wRhqlfouHYdDCLIA4NcKbnBjCYXwkWcbzMK7lOs0SUw
	 KrnrPvTxT5IcySXcHkio1e1OsNdzl1PnSqGyDhPfjpJm1+3U1WowX1vQiSd6g61G75H8+
	 LyQgWa5XLPgWqmDF6j96+Yb9YcbIQQYuWUghy8tiAdlVPr4FfMzDQ2HRu7wIBptTUX3jH
	 YcRasm2XUFKQKCwqjJ6Lc/FB79U4T4NntN076ZNnWLL3AZBveqQsWsIH/SRhToi11api0
	 gVNosG6EPrb73oDFOSgM8w4Y9CvKy/a/2X684V6K/JBanwWHPKIfw+jzERpCr4o2FPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=No8I6d1L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9918E606A33A;
	Wed, 18 Nov 2026 19:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=No8I6d1L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F391F000C4;
	Wed, 18 Nov 2026 19:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030350;
	bh=2k+JOmMYH0FbF58Frme9GJZSFhv11Q6ZbZZbxeYNfN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=No8I6d1LQauRe9Mw+OV31x26nu+uztdwFIndPlYT75Sw+WBC6dkh+hVqqs3HqoNa5
	 WJ8iaXG5UdJkL+ZLBipZnvvxF+whkP1KR82chia66LCJEIQeEvqhapbDe+CB5M9RwN
	 JTnH/cH8PuKhZT4ejj19dTkgebqNgKHkImhIXN/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0673/1756] IB/isert: Dont share drop_cmd_list across concurrent connection teardowns
Date: Wed, 18 Nov 2026 15:46:40 +0100
Message-ID: <20261118150036.067764940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index b3fc753982a38..e3ff99c75b308 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2586,7 +2586,7 @@ static void
 isert_put_unsol_pending_cmds(struct iscsit_conn *conn)
 {
 	struct iscsit_cmd *cmd, *tmp;
-	static LIST_HEAD(drop_cmd_list);
+	LIST_HEAD(drop_cmd_list);
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, tmp, &conn->conn_cmd_list, i_conn_node) {
-- 
2.53.0



