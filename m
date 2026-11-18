Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054167;
	b=C5I8gki5xeaHBqAwYllErnhfxsHXdKV+Tbakjk2H3cC+phLyxcrj4qC7SSG1wm/UqWZH
	 Tnm3N/H34QBjBCjjJGO7xAs1Z3+1+1vVQKIA6RAdgc0DXewUObbTpQubDde+fU9v8XJ95
	 odKCBUMnSTkFNUGjzT1wUZEBf9j3SumjmzBco1i6v2HRWj58eqpLE6iRdt7GV/s0yllcB
	 MCPgsQ3iMJEn63ORq1b6UjdqWFMJlr4j2oinIhT5ndv+i8/mSWbHZ5isVFAWj91FbXPdn
	 eBxL4h7y2XOeH6NFdId/qVCD796Auyj9MLNel8FbnxdOqLfutGqRkCiruk8qTguW6jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/khlP4YPSzOyh89AiiUOZ6ayl2TvrawisbR44VixhnE=;
	b=TTYMPbcruotewVNWrbNNL7pC7yJJZEYixbhIhhiQKGM0SbpH2Wy5mpuAtmqpswV3za7W
	 uNSxD6dTUmVMZ5Qs/5Qh9m/YGSCBZzTSh3Etc3aVM10Ng5xhGhqQJAT+DwW36+BpjyK2L
	 uoqwQJ0F5UgpY499/JVvqWj6QzJNnIMcNS8HCejckGNU4wK6IT91Jbx30rlFOus+xHFGa
	 0VYGEoCStH0T1Ia1cdgSPZY+MYuCsc2U20HA5irQJ/Xf5XKfwNJ21kTw3c3OLwxIc+LLK
	 yAOaTeLkXSw/MwPKlzpURo08Z0ow72KuH2mvSgRrNE3i/0hPuMrmXumj6REFkt0MSMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K/cVVRXa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113A3606A32C;
	Thu, 19 Nov 2026 02:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K/cVVRXa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655C41F000C4;
	Thu, 19 Nov 2026 02:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054166;
	bh=/khlP4YPSzOyh89AiiUOZ6ayl2TvrawisbR44VixhnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/cVVRXa849s1IL61OU6uhciMDwrND/6eDbUmYAHsNkKnpulCkCa6GleeZfME7zLX
	 8tMKeS1aKabrKaOS0jUPwYwQvs8XlDnymugKDdvNWmLoRFQdm31VpAB90TC5Tv3dGO
	 6RM4LQIXVb8bfC317gxhbrEDSV/4uvZkujkBsyJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1178/2214] dcache: report a Tasks-RCU quiescent state in dentry_kill()
Date: Wed, 18 Nov 2026 15:47:34 +0100
Message-ID: <20261118150059.084053477@linuxfoundation.org>
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
[ sashal: applied the rescheduling change in __dentry_kill() instead of dentry_kill() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 7d75ff9d507d2..ac8f2b6c95576 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -598,7 +598,7 @@ static void __dentry_kill(struct dentry *dentry)
 	spin_unlock(&dentry->d_lock);
 	if (likely(can_free))
 		dentry_free(dentry);
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 }
 
 static struct dentry *__lock_parent(struct dentry *dentry)
-- 
2.53.0



