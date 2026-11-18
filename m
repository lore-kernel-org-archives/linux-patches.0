Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052494;
	b=Vn+Pz3l8l4SVvatNaQB7XibQhNmfkzdwuF0iMbU3okxkNrjIlI5OpCya9rMjaXsu44Ap
	 oDP5zLbopHRqFXuTaR6TaIY5P9yJ6kZvh0p2JnkjlfMn7lZXzX7526aIxEkomaQUfG9eC
	 7e6C7amthcduX4YAIMW7mNDJo7Dr6ZmQtLA1dAUP4vRoReZeNCazyG3NwaT1UlvzeA0qc
	 K1H99G7cuJ64Jzcz1KnHKz1DLOUk5wUlVJpSvIHS6WDka068F9CALSJcbUr0BQhSql7pZ
	 Zp2q8isyaN5UhLXoRp2ZD2842UrwQoN8pvKc+2hGixsVyqYR+8ltLYnSDhbctOBrLfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ltRk/sg/9HdNCD4w5KrD1pUFiSgRAzPQYoc7IZYQKdA=;
	b=SC8ZdUJ676cllZrP63fsydNMcjN0vo85Xm63gF7lTp6QfU4/pzEgbsK6vVHu4bEteOVx
	 fBudRHye2UnrXOWXSdQEw2Q6HUKApM/bR2RlK8UQmz0ipznCFvZSy0LyhwxNei4yYJsRg
	 CgRf47b/4Hx5G3ZIP+FQg/IgJoG64agSbbQ00CLI6zwnZeYN53wTuhpARB7AkE8WMPo+v
	 ukmhkhaS2qAnHmNdoIgKlF4rc7ABctzvho8jPda9nOG9tJ0KLZN9SGuOZ++gI4lShNc2k
	 ZJB5SY6j5xg490zoXLgGYnqn+UEKaAJK2SW4k/bYZi7hoHhAdhfO3YOkuYa22Z+USAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlNNeZEd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8F0606A31C;
	Thu, 19 Nov 2026 01:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlNNeZEd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1FE1F000C4;
	Thu, 19 Nov 2026 01:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052494;
	bh=ltRk/sg/9HdNCD4w5KrD1pUFiSgRAzPQYoc7IZYQKdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlNNeZEdcMX1ZIe/bejxsqLZpO9CyS5/TRqoUVV8NroSzatJNy5jRWaWm9IIlCCMC
	 ifGkXeFhaBWVpM4SCyKhAfnUnpCyoNy/J0uk6qt3Inpb4f3iJ8CEAcmC1D5CKsUxN/
	 pKA42htdmqzGcnT721jWpm9GJmJjLdEPkb7KzXkM=
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
Subject: [PATCH 5.15 0585/2214] ocfs2: exit recovery thread on mount error path
Date: Wed, 18 Nov 2026 15:37:41 +0100
Message-ID: <20261118150034.319218346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index deabd61568c1c..052dfe49e03e4 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1170,8 +1170,17 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
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



