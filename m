Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059833;
	b=IDvB6aID5xYqZdhPKM4YE5cKvGOmhRqlro2Z96BnaaBnAGWWjgr6Qk0XOKBGXmVsS5q/
	 LvvwQeyiFpjBWyl+IB8nA1ZcfneU0ttvd0tvLTJ+p9ryyZlFSMKzOEvOrjYY5YjD7ssuT
	 hLW3zOx6FB47qGAPghFmLsCmZwWA3xFCSyUb7i0jCNDujKVpFOsj+c4RrAYrByHxQm+yt
	 uHj92b49mWQHRwJzFxlXpCIOtv614Ca5JSwbMzRSGJyypxI25LOKYaQZzV6TyVLKby+Do
	 nt/BowkLDRCjHnkKVmC2HoQfkhpDWHyQJ6NnJjlWyfGEZVZtkJenEexz4Iyfmlpi3NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WifheW7fzfhiXuz6kSuq11/odfSky8xNr2R/GcjQm/o=;
	b=eSrVgoHqeCRIL6jKnMW09t3YFHjS4U82wLK2R5Bh9qaG7baes4Y9GBz7+4850iB7gRWI
	 jSf/ftnzp4nip0hrjMU+Lg1bBd1lNOmqJzpYIWdFsq4PcZecdt30K4IgBPg7bepMyEHPw
	 RzO6z/4xHUSU3qMveiyw8q3c9x7Z6X3i7metXthv4uyLA/voyETL4EO3yZsg619Lz59bz
	 sB0zvrmoWBPaRK4nMZe8dY6QM3oIFgCnhP/3gTTDYKkvp1YuAFJaPhQu4LVAn3y8ouok5
	 orSJtnxzY2G7iX4LzbEVSStd0VY1iKb4lIUi5mVUjoPQYzPOIDxoqgBtqWlUtO51W4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oc2r5MpY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EB9606A320;
	Thu, 19 Nov 2026 03:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oc2r5MpY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A001F000C4;
	Thu, 19 Nov 2026 03:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059833;
	bh=WifheW7fzfhiXuz6kSuq11/odfSky8xNr2R/GcjQm/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oc2r5MpYPoKvyuuWUGR78RJSl8wuubSCKp5j0KIDCSghUXtfa59RNSvd/sT8m/9yn
	 bVSPnDaYBeOCRIt02bOF/emclW+zBi3BfzRhF7r7eA5TYcbG1dgfbiE/qKMarkGWuy
	 42AOPxlMIb+EOFDG1I9r7UdvCdJM5tVcE5a/+i+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0984/1848] dcache: report a Tasks-RCU quiescent state in dentry_kill()
Date: Wed, 18 Nov 2026 15:50:22 +0100
Message-ID: <20261118145958.102041165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: applied the cond_resched() replacement in __dentry_kill() instead of dentry_kill() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index d17c98508a088..34e8a97e0323e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -595,7 +595,7 @@ static void __dentry_kill(struct dentry *dentry)
 	spin_unlock(&dentry->d_lock);
 	if (likely(can_free))
 		dentry_free(dentry);
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 }
 
 static struct dentry *__lock_parent(struct dentry *dentry)
-- 
2.53.0



