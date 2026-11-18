Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045348;
	b=T/zJSfJoED69HhIJJdRi6RNPXpQ6BPeVtDjuLM3xWiqF+0LOMVoICtzP91aQUtC9uy8r
	 GSx0GFcOhIKPvIL0jLSYgzjP608fchx6T9uXX8yTeUS/9n41awZ7gbtQJxrPk4N05qtb1
	 bh00krc+R+KlqiNwTs86++mWnaZj9Zn2+wIuf9ke/UOP1piGNxjkAlk6f+476Mxz0/zFf
	 BoljThxap5fzAl2uSvuAaPNWe1wLzXNvhvSALLzO7T8hHu5K07zOLpbrIiFLFdxA8nSMn
	 ckryOCGcR49t2F/ML+DZbHnfnUMo4+ATHtBdrHf2Oahxu9+xFnDH/4wfBx3X/Y2s6Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pjuBo7+HCgrRBco4zqLCaskHZeOYCvUduZIwork3Q0c=;
	b=PsIlPaEtxkBEA+LB1Jzk8eYc9wV1G5OGWdRHZ+VBvm7xhRi41QkNDnFHI7yHOc2dodK3
	 AqbLsnzKzwSpE5QVMqW3YaufNysOlkkCWsTix50gF/Mc98L2X2aW654Sy4ysHz9E5gO8i
	 h05cPKtaIFsrH2aWtiMMyIYRtss7vs53IsN8g7Hczqy+DEmWxpd0kAmzjaCJqiGklpECf
	 bHFDxg+V0KllwihLygFWr1VS5qFEh18wqoPtx1OBTKNTW5sqOtF8cALThEoeN7jZdjoTk
	 bDOSQds/6+UJM+XukaUj+dBhiOZRFo/Fu673xSH1wVIvFdw2QrTu3nKOJ9tBFGfbXTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QL1oY32B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E96606A320;
	Wed, 18 Nov 2026 23:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QL1oY32B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E701F000C4;
	Wed, 18 Nov 2026 23:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045347;
	bh=pjuBo7+HCgrRBco4zqLCaskHZeOYCvUduZIwork3Q0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QL1oY32BUYh5VjBmcfXAyfdSq9ptG4KCLUG8M7CJMvM7BFfqday/yQHhx5lBARhSA
	 8oTK5AOMq7RONjSj6tlzWYAUJn7Wo8BLWwh2mG69woTCcuJntWLnZJLOTnd815dN9w
	 2uoT3C53wn7pDEDpk36pr+P60MPk6y2a/zagCksA=
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
Subject: [PATCH 6.1 0888/2857] ocfs2: exit recovery thread on mount error path
Date: Wed, 18 Nov 2026 15:32:02 +0100
Message-ID: <20261118150233.528813456@linuxfoundation.org>
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
index 59b6ec7eec4f2..8dd141609f69c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1169,8 +1169,17 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
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



