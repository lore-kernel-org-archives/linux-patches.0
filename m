Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038671;
	b=gwGXeXS9SGaHNNM7ixiWxVMS1ge55ZVsOVUkjMBhYCkxwmOb9wb77Al1Z0XDhV2aDNW8
	 0qBEDOuaZ6gDrcm38GJgXxF1Zd92GGskwNt0G588zwTNOrXlnfyUr/IXukRSNQiC3uk+3
	 gudEFCPkVhtLPvO8zqgBny3JuRHOeJUC16kWOjLklpCyXo5qzqcGN+Di5aj/y1ejTnKiW
	 wfFmxEGXxDuOj+0GOgPLpLl/OzJ6boYWD7u8DSEyRFIK3hBeZFDh96beIMi3ogVy+x82g
	 PmvGWczS/mBczS2rmFOepcyfKPv3xa0pdsJC/WzpjpEy2BlgyytVxINU/a5DduNYWxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lRqcin1gznutA2hgtfxFy2+EY5//54kX+Oz+X+PYgjs=;
	b=tzMuXZqpC8o/BkOxy77Yt63dIDrC+7hAO2nawEsg3UbUUdLnNjEVXtv45UdaMHfUzQ+b
	 n4eftYrmBhbk4H2zreyeb5V5p0HU8pNzggoMAjafYCrWhkaBn+NACijhPLBT9dE3svMSY
	 rbu9mps7RKQQbrnC1yawaOmxWtayF1Gh3leN/lYTdga+0udsvhiAzvWXVSOPnDXCo4oVT
	 sQSfnwXdLJ9aXVSm9lvoFwC2x0DY6nhhFeE4Yz+oV+JEaWo/V2iDdpx7mU16/hv0oVeII
	 OpTjjhUXrCgTnwVJXTIartkL3PqNM9o3gc+5D19jquXBgR4gFY8iRNoEV6BzRgFJZfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ks8Fo7s8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA593606A31C;
	Wed, 18 Nov 2026 21:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ks8Fo7s8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259F61F000C4;
	Wed, 18 Nov 2026 21:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038671;
	bh=lRqcin1gznutA2hgtfxFy2+EY5//54kX+Oz+X+PYgjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ks8Fo7s81zwVJkR+yfybq7GJnYFjQ/Ofm4Rr9VbzV83+u88jlBbc/lSQsdhQitkJ4
	 Y/1l6T8yX7uOa/73PcghKnas6IL3j4N52Km2tE+xkSTDUVP4DwLoMnI1k0JIf6vavI
	 8KR0+mbfNXx5o/szjEz8xVuJnCEMnvnpK4WyiHkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1824/3318] dcache: report a Tasks-RCU quiescent state in dentry_kill()
Date: Wed, 18 Nov 2026 15:40:46 +0100
Message-ID: <20261118150416.585156283@linuxfoundation.org>
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
[ sashal: applied the reschedule helper replacement at the existing end of __dentry_kill() instead of the restructured dentry_kill() location ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index e1f4a9e61e589..023a9ab9c7574 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -625,7 +625,7 @@ static void __dentry_kill(struct dentry *dentry)
 	spin_unlock(&dentry->d_lock);
 	if (likely(can_free))
 		dentry_free(dentry);
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 }
 
 static struct dentry *__lock_parent(struct dentry *dentry)
-- 
2.53.0



