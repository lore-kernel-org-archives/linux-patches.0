Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052929;
	b=nbHI09NY/mPorZ1wn95FA2OrRtRJMPfLRrJlQkXDQ7t9bMzUzWmr9B8mxpfv3TGk4xE0
	 uV/Mmz6DvO462tJBJixPr0PYuEIwzT1HchwOE8emQCQxgGT5gYoaH6zr32z9nhORk3xS1
	 KELfT9YifHNgk6dxy0MFmqnW7uhhVgDP5d28wKHM1IwEYjajXp+3y22U6OONpydCGE8Gb
	 Di/MVr8tbwESxahmF+JJHizTKj3wObTY0CCGYW7qhgBG5cbB3c8V3T/z4JD1QW+F/poRR
	 V8vBQ9IfW66Kny4df9NvEfDtfApu0nYtd4xZkDjKjTHjeSS7mg1l7A+vXB/BY5upyPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tx8i+PEJBez7U8PQoMa4QJ5OSU0XJyJdrNpUx5772cI=;
	b=BxlXxp37YjwPtLIEfZ+eGlcg54Rmv0VowydTF5SmqAxUAQxO4M35ydWpmgkr9KAbQLGr
	 +56B0Dc9T2qnaK/aMBhbYO34OmBGc+RpGDLYBI36L88mqVLa4sizMw8Psp6cKTRV8g2vt
	 Lyit0be6cIqMO5dN8PEB2sd0hvzgYMnzHj27gNfh7u+V/pVXLE9NjJJQJiy4v9DBHSTYu
	 WaTrRwjN42V6jkA2LfIELSau42eO9swuqNbKSxJbAqJEx6VFOTo9tL8IglRCDNsxq9IR8
	 kmjUfb8GWe7tRscf8t0TjVLYwnke7112zmID80k106HICMmliNJ9WhkjwS1KTUd3B1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hatM9Gur;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6DB606A320;
	Thu, 19 Nov 2026 01:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hatM9Gur
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA52D1F000C4;
	Thu, 19 Nov 2026 01:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052929;
	bh=Tx8i+PEJBez7U8PQoMa4QJ5OSU0XJyJdrNpUx5772cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hatM9GurOkpVgRahJdpUt7Z/3w/ph2KyrkJynrsukGvvcgNCNpp47H/DSjkGX4JoD
	 D1ud/yq9aamZsgLL+nB7IQrT2lN97UtYxHgAGWSh1qyEKbBLfoJNinjFjHFgkLN2aH
	 ONtWsBxjin6SLM70oKOiQ/VCsJ1MDAE7kKHbAf7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0688/2214] writeback: reset dirtied_when when switching wbs
Date: Wed, 18 Nov 2026 15:39:24 +0100
Message-ID: <20261118150039.256721754@linuxfoundation.org>
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
index aff9f0613495a..c6c2dad201564 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -427,12 +427,12 @@ static bool inode_do_switch_wbs(struct inode *inode,
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
index 41b3ebe4e8e71..a6845fdc73cf9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -679,7 +679,9 @@ struct inode {
 	unsigned long		i_state;
 	struct rw_semaphore	i_rwsem;
 
-	unsigned long		dirtied_when;	/* jiffies of first dirtying */
+	/* Timestamp for writeback list ordering and age checks (jiffies). */
+	unsigned long		dirtied_when;
+	/* Start time for deciding when lazytime updates need writeback (jiffies). */
 	unsigned long		dirtied_time_when;
 
 	struct hlist_node	i_hash;
-- 
2.53.0



