Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062216;
	b=RLd9ZIrrSlOb/VNaVDB1tYrfyflFhpMqvGqtqCQHlAgbPB7dxT0FhGPWduncz622bS/T
	 zUdsn3LQdi5d7jIlujv1vT1BB7l36aOzPMM6ktMUJ3H5wKQw4bgKoZxkiA1KBKvqCX24V
	 1Y9J73dLLIXWtKbqIdK01nfkSHtSFuYuvX8rQCsyauwApNI78CCq/csFDjoCji9T7v6qQ
	 A/QLDUPeeOC7A0SAT++6sH693D1X/u9r3KvwnnA7O4W85pJkQpGf+jNuZ4o4DYFTDRL4u
	 MKv90Y8M9EiGreuNmbsPSIKa0aTIXlhlqT1/8OHIH6Knk+CmFfqgq+pC3iVpScoxhIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HJZZ8b0TDo++nMM/HbTti9ZJCGcjFNb+WXRLctzOAzE=;
	b=ukyuSNAlyBpsUj+0TMW4V2CJreIgg4iKxbohoI3yG/Wt9hAxKFVCIlrADBVeRAxDA/y2
	 ln+sPAAL1ZCrTGyMA9thXpdmQ4BGR9AqVmhEDB1INVXcNOzlqOs47zUY68K4zWEkAzCkm
	 1FqJDmUGH9cBaq6n6S6wifNJgFhdk5hSo7yvxRugX0w7qPFuSqXNpV9TQUPt2h0spg7NR
	 yQdKKIQ15ALKTJPtjmFr1h7O+DM6j0tKej4YzGxYsCgFX5M+ARKBmo/S9y+N0I5YlYuR8
	 0GdOB8eK1vBWbwUC2Ud+1OYxabAgvQKwKc9bgU/tiOMOcSa8ZsyNH7DizXk5nC8kiow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k2X/HGcz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D109606A326;
	Sat,  7 Nov 2026 14:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2X/HGcz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E281F0089F;
	Sat,  7 Nov 2026 14:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062215;
	bh=HJZZ8b0TDo++nMM/HbTti9ZJCGcjFNb+WXRLctzOAzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2X/HGczErdZ7aFPFcHjs7qO/xK5DoZKmrYqUoofkL20H4aUvAbB0US5WcpQJQhsX
	 v+dm5VItB17p75xAjSWVtsE0Sc70AKPs2qE54EUZ80eZGQN6/bNMQj7kjqiszDuhDd
	 uM1d1DXrgpPx5/vBaAHvUV5OIldCcSP+yNjpQdYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+e64c6472a3d96a75172a@syzkaller.appspotmail.com,
	syzbot+26461e903494e689c24f@syzkaller.appspotmail.com,
	Yemu Lu <prcups@krgm.moe>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1170/1536] fat: fix fat_ent_write() for reverting the value
Date: Sat,  7 Nov 2026 08:53:06 -0500
Message-ID: <20261107135030.596484149@linuxfoundation.org>
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

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

[ Upstream commit 63c4b67ee163b2a67a7561314bf2106d6c79c53c ]

commit 64d9183203ee ("fat: restore original value when fat_ent_write
failed") try to revert the fatent value to old value when got the error on
mirror FAT.

However it didn't work if the error is when writing the fatent bh.  In
that case, the bh is cleared the uptodate flag, so reuse bh is invalid.

Fix this by reverting the fatent only if got the error on mirror FAT.

Link: https://lore.kernel.org/87ik4yz9fv.fsf_-_@mail.parknet.co.jp
Fixes: 64d9183203ee ("fat: restore original value when fat_ent_write failed")
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+e64c6472a3d96a75172a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e64c6472a3d96a75172a
Reported-by: syzbot+26461e903494e689c24f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=26461e903494e689c24f
Cc: Yemu Lu <prcups@krgm.moe>
Cc: Ren Wei <n05ec@lzu.edu.cn>
Cc: Yuan Tan <yuantan098@gmail.com>
Cc: Yifan Wu <yifanwucs@gmail.com>
Cc: Juefei Pu <tomapufckgml@gmail.com>
Cc: Xin Liu <bird@lzu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/fat.h    |  2 +-
 fs/fat/fatent.c | 21 ++++++++++++++++++---
 fs/fat/file.c   |  3 ++-
 fs/fat/misc.c   |  6 ++----
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index d3e426de5f016..6748dea6cd216 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -389,7 +389,7 @@ extern void fat_ent_access_init(struct super_block *sb);
 extern int fat_ent_read(struct inode *inode, struct fat_entry *fatent,
 			int entry);
 extern int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
-			 int new, int wait);
+			 int new, int old, int wait);
 extern int fat_alloc_clusters(struct inode *inode, int *cluster,
 			      int nr_cluster);
 extern int fat_free_clusters(struct inode *inode, int cluster);
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 1db348f8f887a..1288947a41f03 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -408,7 +408,7 @@ static int fat_mirror_bhs(struct super_block *sb, struct buffer_head **bhs,
 }
 
 int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
-		  int new, int wait)
+		  int new, int old, int wait)
 {
 	struct super_block *sb = inode->i_sb;
 	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
@@ -417,10 +417,25 @@ int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
 	ops->ent_put(fatent, new);
 	if (wait) {
 		err = fat_sync_bhs(fatent->bhs, fatent->nr_bhs);
-		if (err)
+		if (err) {
+			/*
+			 * bhs are not uptodate after I/O error. So we
+			 * can't simply re-dirty to revert. And it
+			 * would not have value to write again on I/O
+			 * error.
+			 */
 			return err;
+		}
 	}
-	return fat_mirror_bhs(sb, fatent->bhs, fatent->nr_bhs);
+
+	err = fat_mirror_bhs(sb, fatent->bhs, fatent->nr_bhs);
+	if (err) {
+		/* Try to revert if got the error on mirror FAT */
+		ops->ent_put(fatent, old);
+		if (wait)
+			fat_sync_bhs(fatent->bhs, fatent->nr_bhs);
+	}
+	return err;
 }
 
 static inline int fat_ent_next(struct msdos_sb_info *sbi,
diff --git a/fs/fat/file.c b/fs/fat/file.c
index e887e9ab74728..c5b64596d25b2 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -360,7 +360,8 @@ static int fat_free(struct inode *inode, int skip)
 				     __func__, MSDOS_I(inode)->i_pos);
 			ret = -EIO;
 		} else if (ret > 0) {
-			err = fat_ent_write(inode, &fatent, FAT_ENT_EOF, wait);
+			err = fat_ent_write(inode, &fatent, FAT_ENT_EOF, ret,
+					    wait);
 			if (err)
 				ret = err;
 		}
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 13941b1bd2d4a..97cf1da8db472 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -133,11 +133,9 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 		ret = fat_ent_read(inode, &fatent, last);
 		if (ret >= 0) {
 			int wait = inode_needs_sync(inode);
-			int old = ret;
 
-			ret = fat_ent_write(inode, &fatent, new_dclus, wait);
-			if (ret < 0)
-				fat_ent_write(inode, &fatent, old, wait);
+			ret = fat_ent_write(inode, &fatent, new_dclus, ret,
+					    wait);
 			fatent_brelse(&fatent);
 		}
 		if (ret < 0)
-- 
2.53.0



