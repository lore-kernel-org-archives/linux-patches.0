Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036337;
	b=0Em46uFf2H1mIA0/py1Dj8gV7zfhyJet16BBZg9ROq97EHCUMhpg5jQDbnYDYi1BQuUC
	 gMJZoOY2svBAflLlir5lagZ8jgIXWZIS3Nyzdv1Xaj9zK4r0RKeORnRhA0DmUfiPIPUh6
	 BIZANV+dnXDX+RvWbcmZ6C3J/lkl/SuGIk53sYEEHG3aRDRI5OpzNI1V4p+202M6KWP9c
	 13Uze06GrufOdVxyRmve3kqRRDmNeHcm0dPcXE7OW6Y8hDsir8EwqxOEQ7VJP3RBVm1ct
	 58AqG2BOcDYq8lqhDbmOp9gMcT9/+QSeW05Zz7lWW7GFapDmGb16DQhwTLJpu+Bb5HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VYC+aGPuwVp42kW/9ZZaGWHrBk6znIr5rNCPnXUVTMo=;
	b=PjIe1eo9OGtOcwQh6w2VFvo7sIBjx90TmRBg6BYTCpOo/BeAQPtoS7+ZZbTOryMf6vlL
	 BwrN77X5Dy1UZdKymcKN8vcA+LAmWO4iBTBRdP3QC0w10C18AnScarJ6pkRk4xmmPYSEh
	 XWBMkBu81Ij11se+iHhuUN8pqldD7A7cJicOG2E5pIcrqTySiFeeifxd2uIr00XhYn8aC
	 pXyhToNCtAmWR2cONLJEVWXjO96gZsn3hQ2YYb6BFCeBShm1ecLp7CbO6JCuN/Kv0NtmD
	 C5ixwZq7LLrHbT1m86Ujg59wW/ZuK6nM17gCHW0K7t4wNJoHsmcMd8tLv9TygrSdGaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjUp7kaJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E177C60A2606;
	Wed, 18 Nov 2026 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjUp7kaJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D011F000D2;
	Wed, 18 Nov 2026 21:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036336;
	bh=VYC+aGPuwVp42kW/9ZZaGWHrBk6znIr5rNCPnXUVTMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjUp7kaJXNonPkCN0MR5Sb/cK3IEZ2Zr247EuhPnP3u8xg0XMxbnXG0qd4HUxqx7P
	 LJtM6rNqsnd6xNvLSGVSdtY60GeeaL3GYUOX91XxTWOBzCYuNPShyLY2bNzdzQQegB
	 q62FtmgoPAj4viGqXjqsB6lME5DGaxNjdJx8sk4M=
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
Subject: [PATCH 6.6 1024/3318] ocfs2: exit recovery thread on mount error path
Date: Wed, 18 Nov 2026 15:27:26 +0100
Message-ID: <20261118150350.602478472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f3911dfb597d..edb04328c9656 100644
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



