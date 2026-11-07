Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063977;
	b=qMpY0V6HBoI4Ql16Ur14+3JCbLt1jix7p1yoi+qSrU6J+5/y8bOVanNfDEwJ85/T22Xm
	 v9Xg6QEchD5ZbBcei7pR7efsh+XScoe14gwXSQLABXZRf8OBoBzTbeS8LSYUY2BBiCIuz
	 XrCWjcan/hIaWxmBh0CpDwr7gXQDNRKHZGOgDORUT17k1tMfGmKCMnx9pVTTexADQCIHz
	 KPA0tfjtNQos8TlFqQbhpPlCqF4UKquyfEDgIhXChe9KmVUVSl0+C+S7M+yi92Q+jt9dp
	 01ngyqjQhzg0dTUU88sNOIPPjbwJYriB5yPbOiYKSTluwRAboV8WsnoWWb2soaQFshA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RmUlha5j++Cn2pikrn1pw2RRUtDqF3pS83OezHbJtuI=;
	b=01iEKLvzThWqA7tOUbIkXx9R4zOYo4puyStQY9npPOYhR4FhssvYJuELf6Xmp03KOu7l
	 VXwvS19r1EMArsi5Lm+VqYc9iLabDNiWdZsvr/g4GJv4LmXnwcXRL69OrOuZs3feEv0B/
	 /l9oUwejlSB23FqI4JqYUxGu6Pwkl0sYXcFAXOsda+rMhia8cdBprflpAc6sUJjMPdzj7
	 /3EIrJAbp69/t1LAqs2E6FsouitcFm1ig+1JhVeT3j57ilM9X9c9NcFHH4eU5KCQWrcd6
	 OiNE7saNM1A3BqSS6DEoshgOV7RZjWXxPH9uqWtQOPPlfMPwZ7HPLSL7IjWQ2eLQORw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LuBb8lzo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3827F6082BD6;
	Sat,  7 Nov 2026 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LuBb8lzo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5241F008A1;
	Sat,  7 Nov 2026 15:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063976;
	bh=RmUlha5j++Cn2pikrn1pw2RRUtDqF3pS83OezHbJtuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LuBb8lzosg3nSedKNNUW8DiMLHv7OY8y/X51oB1JF6y9H3P/HeUp1Bzpbbor2+F04
	 1gIaAnCGHZ2wssXHrh0HLGfzwt0S8tntacGC4qQ7N/V8v84BeRps2NsuRdeO3+BzGV
	 JoM5DEvpYgvVVF7+a3XLNiD0/uNE6Lou/uiVfs0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0160/1257] f2fs: drop pending discard commands before reserving device alias
Date: Sat,  7 Nov 2026 08:40:56 -0500
Message-ID: <20261107134943.749220239@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 5d37f99e4d25eaf42efe2dda8b947585478168f6 ]

When reserving a device alias via f2fs_ioc_reserve_dev_alias(),
f2fs_reserve_device_alias() bulk-marks all blocks in the target device
range as valid in SIT.

However, if the device was previously in the released state, stale
pending discard commands covering that range may still exist in dcc->root.
When f2fs_issue_discard_thread later processes those commands,
__check_sit_bitmap() detects valid blocks in the discard range and
triggers a kernel BUG().

To fix this:
1. Introduce f2fs_drop_discard_cmd_range() to traverse the discard rbtree,
   drop all pending D_PREP discard commands in the range,
   and wait for any in-flight discard bios under dcc->cmd_lock.
2. Call f2fs_drop_discard_cmd_range() in f2fs_ioc_reserve_dev_alias()
   before f2fs_reserve_device_alias().

Reported-by: Wenjie Qi <qiwenjie@xiaomi.com>
Fixes: eae3faf210bd ("f2fs: support dynamic reserve/release for device aliasing")
Cc: stable@vger.kernel.org
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Wenjie Qi <qiwenjie@xiaomi.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    |  3 +++
 fs/f2fs/file.c    |  1 +
 fs/f2fs/segment.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9940a6cecf1a2..0c85d90307f70 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -466,6 +466,7 @@ struct discard_entry {
 #define MAX_PLIST_NUM		512
 #define plist_idx(blk_num)	((blk_num) >= MAX_PLIST_NUM ?		\
 					(MAX_PLIST_NUM - 1) : ((blk_num) - 1))
+#define MAX_DISCARD_DROP_COUNT	512
 
 enum {
 	D_PREP,			/* initial */
@@ -4064,6 +4065,8 @@ void f2fs_reserve_device_alias(struct f2fs_sb_info *sbi, block_t addr,
 bool f2fs_is_checkpointed_data(struct f2fs_sb_info *sbi, block_t blkaddr);
 int f2fs_start_discard_thread(struct f2fs_sb_info *sbi);
 void f2fs_drop_discard_cmd(struct f2fs_sb_info *sbi);
+void f2fs_drop_discard_cmd_range(struct f2fs_sb_info *sbi,
+					block_t start, block_t len);
 void f2fs_stop_discard_thread(struct f2fs_sb_info *sbi);
 bool f2fs_issue_discard_timeout(struct f2fs_sb_info *sbi, bool need_check);
 void f2fs_clear_prefree_segments(struct f2fs_sb_info *sbi,
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index edc352569e87e..29466a7367e55 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3843,6 +3843,7 @@ static int f2fs_ioc_reserve_dev_alias(struct file *filp)
 	write_unlock(&et->lock);
 	clear_inode_flag(inode, FI_NO_EXTENT);
 
+	f2fs_drop_discard_cmd_range(sbi, ei.blk, ei.len);
 	f2fs_reserve_device_alias(sbi, ei.blk, ei.len);
 
 	i_size_write(inode, (loff_t)ei.len << sbi->log_blocksize);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 63b712d3d599e..db4af7a6b138e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1871,6 +1871,60 @@ static unsigned int __wait_all_discard_cmd(struct f2fs_sb_info *sbi,
 	return discard_blks;
 }
 
+void f2fs_drop_discard_cmd_range(struct f2fs_sb_info *sbi,
+					block_t start, block_t len)
+{
+	struct discard_cmd_control *dcc = SM_I(sbi)->dcc_info;
+	struct discard_cmd *prev_dc = NULL, *next_dc = NULL;
+	struct rb_node **insert_p = NULL, *insert_parent = NULL;
+	struct discard_cmd *dc, *wait_dc;
+	u64 cur = start;
+	u64 end = (u64)start + len;
+	int count;
+
+	if (!f2fs_realtime_discard_enable(sbi))
+		return;
+
+next:
+	count = 0;
+	wait_dc = NULL;
+
+	mutex_lock(&dcc->cmd_lock);
+	while (cur < end) {
+		dc = __lookup_discard_cmd_ret(&dcc->root, cur,
+				&prev_dc, &next_dc, &insert_p, &insert_parent);
+		if (!dc)
+			dc = next_dc;
+
+		if (!dc || (u64)dc->di.lstart >= end)
+			break;
+
+		if (dc->state == D_PREP) {
+			cur = (u64)dc->di.lstart + dc->di.len;
+			__remove_discard_cmd(sbi, dc);
+			if (++count >= MAX_DISCARD_DROP_COUNT)
+				break;
+			continue;
+		}
+
+		dc->ref++;
+		cur = (u64)dc->di.lstart + dc->di.len;
+		wait_dc = dc;
+		break;
+	}
+	mutex_unlock(&dcc->cmd_lock);
+
+	if (wait_dc) {
+		__wait_one_discard_bio(sbi, wait_dc);
+		goto next;
+	}
+
+	if (count >= MAX_DISCARD_DROP_COUNT) {
+		cond_resched();
+		goto next;
+	}
+}
+
 /* This should be covered by global mutex, &sit_i->sentry_lock */
 static void f2fs_wait_discard_bio(struct f2fs_sb_info *sbi, block_t blkaddr)
 {
-- 
2.53.0



