Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064166;
	b=d47u/521L3ZPw4ZCTp+2rX9od1kSkiTACEi9slkxmgxx1L/Gu4mHOubV10vmXPOTGTBC
	 YaTZ/Y54MSxleedauWeBhJg66rPUkrQ3bMwEzOteIy+NMrBrCqL4BrVxahN7MYJ0K9x9f
	 5goF+UpmBT2lGcbIi/TIqQOf3fwWQGCOu3nrqsxvYi6M1ObJxYRsKtxycdk+B5CcjLqka
	 OoZaMnKp6mVv+Q2Iq8LDdNiOFP7zkgMEi5vliGD9Yh4WP/67GWsOCmzRB3TZGXDJBeFBT
	 MvLUX3qFTgWoW+bEujf0t1q6kU+xUHiKApEAMd48ad33ryWyBh2WHgrgsLBdhqHfaEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JthqFYubZ43f3bvIEJ8kCKxFEm/Rm8JT3S9Jk6GPOP0=;
	b=5q93oRDlSgVztcUbUrFHqKEkpMuFaJkGe1dlfqtfJ6kOZrhX+8GALL/LWcIvDVdnNlBt
	 +6+EhgU8zQwNy7snmONjc5euGKQYxtp7prGdrpI5+du3TmtdaCh1gm0Z6viRgjl+3+5U4
	 aRn/4y/XC6UikOMbEVmtPeQAxKb5mK7eHG/vHbT3Jtk/HAc/wSUHHC+sByaQPd138rUdd
	 ayBn4nFsWu2mIpm2yJNxodU7kUpoofzcUmbvWPFJ21WuNBo/Xj4A+GFejh+J8sG/Nuwuv
	 yvG8qHp2grTy/i5PM7tpQI5jit+0XYlclEjjYmaw7nPlb4LWaK12rOfyh45NpZdbsIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5mLJHah;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD221606A32E;
	Sat,  7 Nov 2026 15:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5mLJHah
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD7A1F008A1;
	Sat,  7 Nov 2026 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064165;
	bh=JthqFYubZ43f3bvIEJ8kCKxFEm/Rm8JT3S9Jk6GPOP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5mLJHahwFEQSI3rCjKHFBykQbLJpykiRx1atxO5pRYQX+9xD6LA3OkYKDIC/80kJ
	 hi3sPEm3XnP04IG/cHAIrqAXmjWY3dZZ+Tu7/v4fI6hTYrFoe+fGs6TsE3WtolYdJM
	 oCEOuPAIiJWVm7LPnnZ/BxBQGSQonA6bAROFZD+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0312/1257] dcache: report a Tasks-RCU quiescent state in dentry_kill()
Date: Sat,  7 Nov 2026 08:43:28 -0500
Message-ID: <20261107134948.050729387@linuxfoundation.org>
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
index 2eb23222be549..91fbaa818baa7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -843,7 +843,7 @@ static struct dentry *dentry_kill(struct dentry *dentry)
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	/* now that it's negative, ->d_parent is stable */
 	if (!IS_ROOT(dentry)) {
 		parent = dentry->d_parent;
-- 
2.53.0



