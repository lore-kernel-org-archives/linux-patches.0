Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064489;
	b=FRKt1KZ0aGLWcShz+mFZhwafQDW0nZiR0PcoDdUMc3RIg+o/7BKloEK8TfsHL9hWchyY
	 ZXx8V2WS98E4BkrWaEE6ryD9aTR6icoZkp6xQ66KQiXFYg1iFH+TyWSeCYEpFel0adKMD
	 +cnQYCzzbQ2carYVGhfi055qJ2YOBR8JT/TkjGxFu8dp/7qCjCfUYPL0vjloi40FZFlzi
	 igK/m+7VhLJFsNtKFOrSuW7wn6wbXZMM8Lfjq5LSgM3g5M2O6rSyuxedgvN2i9qiVvzIo
	 Tu0e7hs2qPxO8MNPrCeeewhcgEPN0hNHvTRivTEeC5JTlFIN+zZLakmu+u9w96LeW7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KBh55ii2u/r9weXSmyFTofszItfkStyOwfC0IsrQZqQ=;
	b=PLPStvVkF5kJNrrsrWpXW01GT7vW6kCoSBHk9kV7z7Gg0s9NTDRGESpV1gj1FZylHmA0
	 D2WFLXM6fhP3PgslTM/+FctdfA2aYnilsbW1KNyJgtLEzglxeBEUdHyILxsSb/2FUgIKP
	 8r68CE+0NVQWALrOv+KWfS25yNuRv4/GJ2s4awAE3PeISCHjuJJrkYYO6JQewWmUAYgWc
	 KZJmbKEKi1CVcUdkHtZ2OPOGeaKnq0gXeV5jj9oHouV5S6kw4+I7XpwGQUJxgHZk+YlnT
	 V3/K7eJs23r0/2Qi2kzhVpnCES7TpkNUPwQ+CKznetBOmShH/BvKiBe8MBWt6NHywIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lnqf0bT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D75606A9EE;
	Sat,  7 Nov 2026 15:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lnqf0bT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2FD1F008A3;
	Sat,  7 Nov 2026 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064488;
	bh=KBh55ii2u/r9weXSmyFTofszItfkStyOwfC0IsrQZqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lnqf0bT5aZYuORt/5xptHfCRqqgC9Yzhr2PRbl9+ZK2jIJkhcttxiwzRAYM3iqf9g
	 YWS/Xsu4f1XiqizaC6qGY7ZO20l2dmcNBA/8yn9cRQUfaHDScve4ikZUXfBxL19kAe
	 E8xpQ79dYQScGQjjc/JZpRLebHSEzMx8h/HDHiQE=
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
Subject: [PATCH 7.3 0525/1257] ocfs2: exit recovery thread on mount error path
Date: Sat,  7 Nov 2026 08:47:01 -0500
Message-ID: <20261107134953.918064193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index acce465f45b02..736cc1fa8b23e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1170,8 +1170,17 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
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



