Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062998;
	b=IIZHWPFCqlI56Cb0JTlK7pWtZhgjzQPHjMpG4Tr1vT48j+RYDST3RnlNvSP443DTSCDo
	 uH44ltaD7O/j6IbSLT1f0KfcoCg8qDZw/pw4pKd2TxYG+ikxkR1txyj7O8M4fE0pMwzpq
	 fEpVtRPNPab3VD47nZPG0MFBB1/RvNZZUHNOKdFUCk5GzGj5v86JA4XIunFyZ1XIrFetH
	 kC3KRMYd9lSjJEJzk8kMb+T1Z9k2dPLucdhJ/Kx/gMBvva7vRo0/g0r+bK+MIkV6BMi9U
	 gkFqpCLQy4qpNXUK2PXfR2+AeUIlKqFqGRfDEF5gmQ5QWnub4p18c3UrzPNBB2ro1XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LFnEDQJ1TaIaLbXp8hNjJ1Y/vIF3yAfMssbiEuKMz/M=;
	b=RsUEbN4pIJgH/2JsAWaYTgYL4uypJ/eKAur7HhH3y8aXjTJ+y/Fq2xeU9RG4Ah+5XI2w
	 rCAjxT7CxEOlq9tdUle5c65YkJ38gsGMkdrwPhXzq8ggghoPHMlqwNc4u9DEXrkMQ0qiu
	 mHi3MXBQ73VCOFgJzlaY+vzojnZKIOMCVsDRfUhSR6Or0YobCTxUbGkPeevD0bQaOcuDy
	 Hfs0C2nequy5GkRBK2ARk/IXfFj6Tqg9/lX9Ph7k+YN/rCC9/PzFYmD9ydpKkXKH9L5ng
	 f253CA7VOBVBWhVtmFqYF5fWXsYVzX6nTxBWgku13ci5QJqaqdqq4qvCpw/V7evAQxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I0kckoCz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF26B606A331;
	Sat,  7 Nov 2026 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I0kckoCz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172111F0089F;
	Sat,  7 Nov 2026 14:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062997;
	bh=LFnEDQJ1TaIaLbXp8hNjJ1Y/vIF3yAfMssbiEuKMz/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0kckoCzSIs4cO2vyrkJoISzdBFXftMTTgLU2QgHwlWKxY0+VgsBlsH8R4Z+t3Y9D
	 OAZlvaj1/bJHWWcZhyVh3oDRmK6GBUidpzw02xZ29DtdYugyInpcLy2uB80HRYbjAJ
	 9cHrapAJWSh9fGMI5I06up9dYeEu4y+JIv6GWskc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 253/869] dcache: report a Tasks-RCU quiescent state in dentry_kill()
Date: Sat,  7 Nov 2026 08:48:55 -0500
Message-ID: <20261107134900.372877428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1b4c210338022..04adb623e584e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -686,7 +686,7 @@ static struct dentry *__dentry_kill(struct dentry *dentry)
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	/* now that it's negative, ->d_parent is stable */
 	if (!IS_ROOT(dentry)) {
 		parent = dentry->d_parent;
-- 
2.53.0



