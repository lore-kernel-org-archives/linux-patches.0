Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062148;
	b=b1ZSdv0FMkeyE4e5yivQmBMk8eBTXwFFQMlKBUjme0nBlUyI39E2ZA6u0wYvzOLxmC6d
	 jSwYFPXAJ1sd8p6JU/33FOGqX3P3/fGrQwc/SKO6J/FD2Kj6QfK+lnyVWPDovl5zX6qJm
	 k2xODbKfCbz+GA+N5uud4685LBsC1jDn9Pgno/M14vV8SoBZq2d6Zh7KXiCkAL37GhmZl
	 q61W2AI9SEA8p0QbusGQgRJes0Om8QDeF/ud7hK+Cajbb1jT2tGRjRyfhcFRcfH4plI+9
	 MIjFcVTqLqBsGsr8xhrmzj62MwGeRb51yc+cHjYOd6dF0oWXEDFLSnsqWI7yQXmhOFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TkjueNYHvJqYfc5WL6bNfOJldIv2r1PPJ/AQoAYNP6M=;
	b=k32Nvpl1lcQf8nIUqakd8JJ15VDJgqgHNAEz/wagRbAg1YA5O8YA/o4Nrtp4eVAY9vE9
	 9RihpHC1wxxvvZBlYZZWo88iAuvLPU+xiVCwWsdIt8/HGUvnWHmOF0oygktuv9jOZm/QB
	 VAFU3XWBJhPVd2jLETMErjWIdTK5yIWnsHUNJIZcqvcXgUQCokC22XMPx3qf8VgrLv5Q1
	 z3r0seW+361UItTtBRyYR40vpnHQt3U25qbOMs83mb2HJhxjNzyXe0RjdvSAPPyk9hzSv
	 /psEbE2XMwGpzRJPMOKjY4BOQPM31We3s0zxqvalLKf9sD0btbQ5NGbjDzkT3oKo/WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kno56V01;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F61606A66A;
	Sat,  7 Nov 2026 14:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kno56V01
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CD61F008A6;
	Sat,  7 Nov 2026 14:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062148;
	bh=TkjueNYHvJqYfc5WL6bNfOJldIv2r1PPJ/AQoAYNP6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kno56V01TvaQF56CK2Dr8LcuAF108GZA1bFLLEMjwrNbu2VDaMwSfpIcVgT/wzdBU
	 oIwsu0CVMTgERnsw3mtRNKg0WcyLpB4trq9dKIEJ/4zMQJLcFkvAHINNnAtdsY6XDR
	 UBxmhQKLI8qo5kgtyUuYv/9OwyZVfnK88lOHSIeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1075/1536] dcache: report a Tasks-RCU quiescent state in dentry_kill()
Date: Sat,  7 Nov 2026 08:51:31 -0500
Message-ID: <20261107135027.886705701@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit a647a53bc89a046bee4a12a0a5627f2dfaaef807 ]

I am constantly seeing the following warning on Meta's fleet:

  INFO: rcu_tasks detected stalls on tasks:
    native_queued_spin_lock_slowpath
    locked_inode_to_wb_and_lock_list
    inode_io_list_del
    evict
    __dentry_kill
    shrink_dentry_list
    shrink_dcache_tree
    d_invalidate
    btrfs_delete_subvolume
    btrfs_ioctl_snap_destroy
    btrfs_ioctl
    do_syscall_64

dentry_kill() is the common funnel for dentry teardown: dput(),
shrink_dentry_list() and shrink_dcache_tree() all reach it, once per
dentry, and its cond_resched() is the only reschedule point on that path.

cond_resched() is not an RCU-tasks quiescent state.

Use cond_resched_tasks_rcu_qs() so the teardown reports an RCU-tasks
quiescent state as it proceeds.

Fixes: 9c5f1d30199d ("dcache: move cond_resched() into the end of __dentry_kill()")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260918-dcache-task-rcu-qa-v1-1-963ec83e6d0b@debian.org
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index ad31c9dd53f77..482b8b6d0eeeb 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -632,7 +632,7 @@ static struct dentry *__dentry_kill(struct dentry *dentry)
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	/* now that it's negative, ->d_parent is stable */
 	if (!IS_ROOT(dentry)) {
 		parent = dentry->d_parent;
-- 
2.53.0



