Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015499;
	b=vPaMrYsyVC8SsdlnSbdQmkfVWCXbyNBucrwUF+xY9U9qvndBRPXSEgo2V7JehxZ1FTT8
	 PeRFl6zq5c5Wod2Q9iGqR892h1Kx+FouSMxrQs/fG2jFdDyk8wjWlk4LRItenrng7Mg/B
	 K07cXLhXdPte+UDX6/tTMq8nUzZObXnkie7E7rfhVIuAaPdBKvgvqHFVge/g2B0/zAT3U
	 mJdlVuf3Zo3e+7loVw7lqArWvn7vsY2G6YHA7EJiHtxEHcTafn0iKgVUoATzV2SUDmCkE
	 xA4gur7CqYrV2rJva9tDAzkqLcG1OPC9PT2SqqSY8mncwHI+IyUX/km+Xvcjkb/zuDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mv38nGt1iI4qBm5+zTj2fdF6EzBn/vvuOaOnx6iY3tI=;
	b=JSuLEQSbr/qpvqgiG8mgp6YPmWfsRMChHvvCJcz1WsQJRVEPL9pszxxL1RBrvY6LzpIe
	 hSSAn4hrGhLCGETA0cr9pfDPg3+imC/UXBl3Lovk8auN/XlwG+xN4mlWEnfXVs4w1dNed
	 462C7d5pxlY441qppXXaUzBceoUX99ucXefVscMvC6BQuCwDFvni1/A+cwauCE6rWuy4M
	 Nz8kWAwRguzBZtoUmldjR6zEGpRMBK9ynkLpoQ4DmtPgJcWtplhv6/cxI+BcmkZ8jlPSi
	 1jLdvj7VC6RSjVViuybjnU522tlzUJroWmVDEx77BQuV0IG+f/BJzTdBEqrXLKo21wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/XEUswg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8142B606A31C;
	Wed, 18 Nov 2026 15:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/XEUswg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1701F000C4;
	Wed, 18 Nov 2026 15:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015499;
	bh=mv38nGt1iI4qBm5+zTj2fdF6EzBn/vvuOaOnx6iY3tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/XEUswgIwrg9kI9O7frtkxMVIHzxTlKT4rNH37s6xP09Rp9oSHLxT+48Di74Vwf6
	 20Uli9oHdNGT2EC2b4jc8P+WTJK5SStZi2VP5JGGEbDxRgy8pyvKrp6l7adbtk/yq5
	 VoqUcOElw0e5dLdIw6b5Qj23P3l4PlwqdNWB6FiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0194/2651] f2fs: wait for inode record work before clearing ino bitmaps
Date: Wed, 18 Nov 2026 15:23:54 +0100
Message-ID: <20261118150254.844092083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit 56bcda97b38a54b18df380ca928120a05d2a269a ]

APPEND/UPDATE inode state recording was moved to the inode eviction
workqueue. These entries were later converted to bitmap values stored in
XArrays, but the workqueue drain was left behind in the list cleanup loop
where it is now a no-op.

During unmount, inode eviction work can therefore remain queued when
f2fs_release_ino_entry() destroys the bitmap XArrays. A delayed worker can
repopulate them before the workqueue is finally destroyed, leaking newly
allocated XArray nodes when the F2FS superblock is freed.

Wait for APPEND/UPDATE inode record work before destroying each bitmap
XArray, restoring the required ordering.

Fixes: 9a9ee7408a1f ("f2fs: reduce memory footprint of ino management")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index a84517023e54f..0692b198d0b08 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -824,15 +824,6 @@ static void __clear_ino_bitmap(struct f2fs_sb_info *sbi, nid_t ino, int type)
 	spin_unlock(&im->ino_lock);
 }
 
-static void f2fs_wait_for_inode_record(struct f2fs_sb_info *sbi, int mode)
-{
-	if (mode != APPEND_INO && mode != UPDATE_INO)
-		return;
-
-	/* Let's wait for some pending updates for APPEND_INO and UPDATE_INO. */
-	flush_workqueue(sbi->evict_wq);
-}
-
 static void __f2fs_add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino,
 					unsigned int devidx, int type)
 {
@@ -886,8 +877,6 @@ void f2fs_release_ino_entry(struct f2fs_sb_info *sbi, bool all)
 	for (i = all ? ORPHAN_INO : FLUSH_INO; i <= FLUSH_INO; i++) {
 		struct inode_management *im = &sbi->im[i];
 
-		f2fs_wait_for_inode_record(sbi, i);
-
 		spin_lock(&im->ino_lock);
 		list_for_each_entry_safe(e, tmp, &im->ino_list, list) {
 			list_del(&e->list);
@@ -898,6 +887,9 @@ void f2fs_release_ino_entry(struct f2fs_sb_info *sbi, bool all)
 		spin_unlock(&im->ino_lock);
 	}
 
+	/* Wait for pending APPEND/UPDATE inode state updates. */
+	flush_workqueue(sbi->evict_wq);
+
 	for (i = APPEND_INO; i < MAX_INO_ENTRY; i++) {
 		struct inode_management *im = &sbi->im[i];
 
-- 
2.53.0



