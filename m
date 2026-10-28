Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214949;
	b=Idk0ZvQJ6BUK+9NThBW9fhakGlP4pJLWyeeJ8lXocV8w8umyZWWAtxxaETBrRimu4d1C
	 47Yk6qqPQp3+UBpRtLwxbIdRrR3hr0wtClw3f0kRZK6HIG7oDvHVuLM99T+2qdx5/zhyZ
	 i3r++5JXIXPVeMEF+fcU8ij9QSXT/chFzAbgmbXUJfZCwEWgnbDq8xYFzQludFxZZfl25
	 7hh49BhDxYdF6hTL8UqxEVDIrDsgg2gVuG8YBEiJMpumiPM35viKAJ/FM4CP3XiVXuJlZ
	 DskDg53uth7pUZi5YUmhA6Sl4UGbTbfu9TFoznJKHM+imcmyTKfQflbVegV7u0Go/zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n/AnEy/lQQyx1McFdlGbvURG5P+aXaYfXYTz3gQ9k04=;
	b=Lvu1tVpT+O47cdk31l/I3z3u2pRmOPJYvQXoOHYcZlEUazeAKdZAgTyUSsZ2XjWAphJw
	 kLVdi7ekoakiQ2Mqw6Vos0LDyUwDYIpUyp+yOy0/76QCEYrGcraHA6ef0yDXMvaW3n++7
	 +lpLxVRHptoW19EKNB557osSRPVcs6j5QYQNVgqfsSfcOs9XaIuEMAw4ed5UClTQJbf+t
	 +peGMK17AZrn2C9HA9ooC9YmAX0QsjzEi7YK+yiH8PO6i3bfybxs7+Kjbirx/FB5aE6d/
	 vEMFBKswzD7X8HfoO6OWI5rCZBwdSvvYd2MkwA15LVQ0hv20D+kLWr19vQ3wowq+QZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztYR6VQB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB60606A337;
	Wed, 28 Oct 2026 19:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztYR6VQB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36511F01825;
	Wed, 28 Oct 2026 19:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214949;
	bh=n/AnEy/lQQyx1McFdlGbvURG5P+aXaYfXYTz3gQ9k04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztYR6VQBQ1Cv4aEn7C8USagg62eokssI02h7ld14dYEJ8pUpNZ2t2fzTX98qT76Hg
	 DfHP9JLBD94qB4K7ITf8nHLa65wPHsOy0XbTS8n8c3Ujj147XRqc7BMeYaQDgXbYkj
	 i9LUNwp8lmkyS1auKvDvlvK+6gvGfObv8QSJKgTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1037/1887] ext4: fix e4b bitmap inconsistency reports
Date: Wed, 28 Oct 2026 17:52:13 +0100
Message-ID: <20261028170523.010729449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongjian Sun <sunyongjian1@huawei.com>

[ Upstream commit bdc56a9c46b2a99c12313122b9352b619a2e719e ]

A bitmap inconsistency issue was observed during stress tests under
mixed huge-page workloads. Ext4 reported multiple e4b bitmap check
failures like:

ext4_mb_complex_scan_group:2508: group 350, 8179 free clusters as
per group info. But got 8192 blocks

Analysis and experimentation confirmed that the issue is caused by a
race condition between page migration and bitmap modification. Although
this timing window is extremely narrow, it is still hit in practice:

folio_lock                        ext4_mb_load_buddy
__migrate_folio
  check ref count
  folio_mc_copy                     __filemap_get_folio
                                      folio_try_get(folio)
                                  ......
                                  mb_mark_used
                                  ext4_mb_unload_buddy
  __folio_migrate_mapping
    folio_ref_freeze
folio_unlock

The root cause of this issue is that the fast path of load_buddy only
increments the folio's reference count, which is insufficient to prevent
concurrent folio migration. We observed that the folio migration process
acquires the folio lock. Therefore, we can determine whether to take the
fast path in load_buddy by checking the lock status. If the folio is
locked, we opt for the slow path (which acquires the lock) to close this
concurrency window.

Additionally, this change addresses the following issues:

When the DOUBLE_CHECK macro is enabled to inspect bitmap-related
issues, the following error may be triggered:

corruption in group 324 at byte 784(6272): f in copy != ff on
disk/prealloc

Analysis reveals that this is a false positive. There is a specific race
window where the bitmap and the group descriptor become momentarily
inconsistent, leading to this error report:

ext4_mb_load_buddy                   ext4_mb_load_buddy
  __filemap_get_folio(create|lock)
    folio_lock
  ext4_mb_init_cache
    folio_mark_uptodate
                                     __filemap_get_folio(no lock)
                                     ......
                                     mb_mark_used
                                       mb_mark_used_double
  mb_cmp_bitmaps
                                       mb_set_bits(e4b->bd_bitmap)
  folio_unlock

The original logic assumed that since mb_cmp_bitmaps is called when the
bitmap is newly loaded from disk, the folio lock would be sufficient to
prevent concurrent access. However, this overlooks a specific race
condition: if another process attempts to load buddy and finds the folio
is already in an uptodate state, it will immediately begin using it without
holding folio lock.

Signed-off-by: Yongjian Sun <sunyongjian1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260106090820.836242-1-sunyongjian@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 64b1e2f5367ff..2f7809db4432d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1533,16 +1533,17 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 
 	/* Avoid locking the folio in the fast path ... */
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio)) {
+	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
+		/*
+		 * folio_test_locked is employed to detect ongoing folio
+		 * migrations, since concurrent migrations can lead to
+		 * bitmap inconsistency. And if we are not uptodate that
+		 * implies somebody just created the folio but is yet to
+		 * initialize it. We can drop the folio reference and
+		 * try to get the folio with lock in both cases to avoid
+		 * concurrency.
+		 */
 		if (!IS_ERR(folio))
-			/*
-			 * drop the folio reference and try
-			 * to get the folio with lock. If we
-			 * are not uptodate that implies
-			 * somebody just created the folio but
-			 * is yet to initialize it. So
-			 * wait for it to initialize.
-			 */
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
 				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
@@ -1584,7 +1585,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	poff = block % blocks_per_page;
 
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio)) {
+	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
 		if (!IS_ERR(folio))
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
-- 
2.53.0



