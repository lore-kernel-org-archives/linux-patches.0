Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062222;
	b=s1KjxzUFZdO8twa+v7THpUxDdv2BQ9yzEAvzVYMKkAxly7xMLPnlCMZQsSaw9ynjAgED
	 ESvHk9F5LCKj3W6Nt/kYGfDkCALMAdGfagxtDECCcQzrm+iCsec3sJ4/szVAZteDT6xSO
	 PhoFwSAAobz3PWpU1yedrx5WOQq74WtFQ7eXDF03s5UTHghHIyDc4g4ZH6oZJ/qUUiuEl
	 LyAelf06mTE4S4MiyKd+74t8FwLOcCIbXcQhnUQBP3d3vCA5ikZCuXcwheUd8mbR+sBp8
	 jZx5+m+ZSX40KCtyvZfieIh2VMm+sZsgSEjOJi/vthuYRjjz40DvgIsG/oHjvSq/jxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nbwe6sqOMAWSmel+JsFdSHjerLkHrluHnGxXf4TWr1s=;
	b=IdwKRiT5+sd0wEO15JTaeB7HtiNu1bgwkaf76+bmGWB+IkUqRwHAgIV0mREyjTJ+qFjL
	 f6T4Zpgu/Q0NpCFqXkHUbYLM6XzF4qGXpDz9+GRcpioauXSVuP9bG2UqmaLTrvewuHWb4
	 OJ8vd029FmosQB+4iA+RQsZ3jxzXqvbZcWqWujzcN1dg13h/lVdurNB/ZrKtriAsw1ZRL
	 AJ6kMg3OMj9xgXXul341eONnQBfowJnTleQV8dVyfYH/0Zdkl1+sd/+aAQh6/OPlDz8WT
	 1bANe+qLbMN8pjcOEspv0rOq4F7tnJUHfgDVLtCd912OjKjGBlOiwZhpOLrIb8RYPHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnTkF1G1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39251606D83C;
	Sat,  7 Nov 2026 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnTkF1G1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA89B1F0089F;
	Sat,  7 Nov 2026 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062221;
	bh=Nbwe6sqOMAWSmel+JsFdSHjerLkHrluHnGxXf4TWr1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnTkF1G1bB1PrVcRyX9S/sq+Q26Ed2SeECfTLyyMSxX9N6J5SyB8PnTHzhMvRGAeK
	 ijYUmtfszsf+IVR7Pd3MM7XiQRxr0Zt7OA7V4Pjm8V63tBtF6Ujr83c3u6Lf+hBAY4
	 Zn6nF7l9pRQmdm7manN2E+vXt5q+2M2x5Pn6ezzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Changwei Ge <gechangwei@live.cn>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1174/1536] ocfs2: exit recovery thread on mount error path
Date: Sat,  7 Nov 2026 08:53:10 -0500
Message-ID: <20261107135030.711883120@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 6163a859649e9432e9c79c541f36dbf3bba9172f ]

When a mount fails after the cluster connection has been established, e.g.
in ocfs2_mount_volume(), ocfs2_fill_super() unwinds via
out_debugfs/out_super and frees the osb without disabling recovery.

A node failure event can concurrently launch the recovery thread, which
blocks in __ocfs2_wait_on_mount() waiting for the volume state to become
VOLUME_MOUNTED or VOLUME_DISABLED.  As the mount error path neither sets
VOLUME_DISABLED nor wakes osb_mount_event, the thread can never make
progress: the kthread leaks and stays blocked on the wait queue embedded
in the freed osb, which may then be accessed as freed memory.

Fix it by setting VOLUME_DISABLED and waking osb_mount_event on this path
so the thread bails out, and replace the plain kfree(osb->recovery_map)
with ocfs2_recovery_exit(), which waits for a running recovery thread to
exit before the recovery map is freed.

Link: https://lore.kernel.org/20260828112825.666097-1-joseph.qi@linux.alibaba.com
Fixes: f1e75d128b46 ("ocfs2: rewrite error handling of ocfs2_fill_super")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/super.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 19f0cb9267caf..6d30b8b05a080 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1171,8 +1171,17 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 out_debugfs:
 	debugfs_remove_recursive(osb->osb_debug_root);
 out_super:
+	/*
+	 * A recovery thread launched by a node failure event may still be
+	 * waiting for the volume to be mounted.  Set VOLUME_DISABLED and
+	 * wake it up, then wait for it to exit before osb is freed,
+	 * otherwise the kthread would leak and stay blocked on the wait
+	 * queue embedded in the freed osb.
+	 */
+	atomic_set(&osb->vol_state, VOLUME_DISABLED);
+	wake_up(&osb->osb_mount_event);
 	ocfs2_release_system_inodes(osb);
-	kfree(osb->recovery_map);
+	ocfs2_recovery_exit(osb);
 	ocfs2_delete_osb(osb);
 	kfree(osb);
 out:
-- 
2.53.0



