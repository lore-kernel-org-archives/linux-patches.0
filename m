Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063572;
	b=yD6HPaYkQncoLl0FgdekFsfkZVo79dbZd64GXaE+5KMTUumo241UzPSs+li6ja0dBjpo
	 aHUVbQXIMurAlU2VRwNqtBB+ewTy6g19vf4G+qkttLO7W8Sg0vDBuFTz0WvtCTwTWMhol
	 9zoI8Ek+L+OKB5IoLe7uou6y5w8OaYlO1Ou5ijOzlQJfYmsQWQDyglEomGKnuK1nd2y3M
	 vx6Aw/dnb92kdbX9U+zcoLTaSlj+um8SqvrPG2WZknx+XTvIPwxrgam25QQ/5YPDm3Wmd
	 t1uM2K+Vp969Y+C2YQ5WxZac6X2HlTMeLJgp1KHQ2aWxK2Mi0+X1zwFAXpfCdG4ypnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LCIfC4eORIBb9Lu9e/faLETaUQ4soDyVI7zlxeOd6dg=;
	b=TWPJn9UMQCOPkmlSELYkYmKpMZGYzzHuXlMMDaIu2rw5J0oCQtqqqqKOUrld0l67Sp3e
	 eyCRmjnN7df0S7QwaYL27kpptk+g/ZtHThl1iFO2JiUl3HBKjj4qTMBJXV4zhUw9345yS
	 u3O3emoY9571b9u0tbNutY5Kbq5nZs/+Bj1uOwJtvn7oKcp4CIaeMYfiF7xtoJhSHi32u
	 2tMc0LdoGZgtQal2h3HxLQB7NxZ22hJNXlkE9WIdwzvoN7alSEjkGPnEd8+Pqv8F0bZ5u
	 zkMfv6JHwAccIHyB300GcKIJVzyz8i4qSakuYA9RaPFTcPIYD5A2BW58ALvkbLYy3qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNyT3tZL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1F360A260B;
	Sat,  7 Nov 2026 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNyT3tZL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3031F008BF;
	Sat,  7 Nov 2026 14:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063572;
	bh=LCIfC4eORIBb9Lu9e/faLETaUQ4soDyVI7zlxeOd6dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNyT3tZLoTFDnZ08+IpIw46NUaGfJDM1VjBBCktDt6b0vqK2sltOOjRJqZvsIS5vy
	 dGUPsYax9asSQswQg48aA7LJ7tWgvOcWJX+hyZKkRRUEhdsIOdZvx7DsMFu7+1bjVJ
	 mvZaRSXwgRNcYl+zbM0qwfeJ8yYar4x95ueUHumg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 703/869] writeback: reset dirtied_when when switching wbs
Date: Sat,  7 Nov 2026 08:56:25 -0500
Message-ID: <20261107134916.771407536@linuxfoundation.org>
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

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 13b9a606dd0a6cf9bac12894c97b9546d22a7425 ]

When switching a dirty inode to another wb, inode_do_switch_wbs() puts
it at the newest end of the target b_dirty list instead of searching
for its sorted position. This requires updating dirtied_when, which
move_expired_inodes() uses to decide where to stop scanning.

However, the switch updates dirtied_time_when instead. This leaves
b_dirty out of order and can make the scan stop before reaching older
inodes. It also resets the lazytime expiration timestamp, potentially
delaying timestamp writeback.

Update dirtied_when instead, preserving both the constant-time insertion
and the lazytime expiration timestamp. Correct the field name in the
comment and document the distinction between the two inode timestamps.

Fixes: 9a6ebbdbd412 ("writeback: Avoid excessively long inode switching times")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20261016115230.3640770-2-sunjunchao@bytedance.com
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c  | 6 +++---
 include/linux/fs.h | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 094d2872881d3..b74a7387bea74 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -454,12 +454,12 @@ static bool inode_do_switch_wbs(struct inode *inode,
 		if (inode->i_state & I_DIRTY_ALL) {
 			/*
 			 * We need to keep b_dirty list sorted by
-			 * dirtied_time_when. However properly sorting the
+			 * dirtied_when. However properly sorting the
 			 * inode in the list gets too expensive when switching
 			 * many inodes. So just attach inode at the end of the
-			 * dirty list and clobber the dirtied_time_when.
+			 * dirty list and clobber the dirtied_when.
 			 */
-			inode->dirtied_time_when = jiffies;
+			inode->dirtied_when = jiffies;
 			inode_io_list_move_locked(inode, new_wb,
 						  &new_wb->b_dirty);
 		} else {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 55ecd9d26b4fb..349b7fc57db36 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -847,7 +847,9 @@ struct inode {
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
-	unsigned long		dirtied_when;	/* jiffies of first dirtying */
+	/* Timestamp for writeback list ordering and age checks (jiffies). */
+	unsigned long		dirtied_when;
+	/* Start time for deciding when lazytime updates need writeback (jiffies). */
 	unsigned long		dirtied_time_when;
 
 	struct hlist_node	i_hash;
-- 
2.53.0



