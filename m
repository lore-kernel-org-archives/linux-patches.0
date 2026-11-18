Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044180;
	b=PDYsHoaZFVp18rNCfwLklMwYYYiZf8FNW5CH1E9cjzmQJFTdvqxcD1xVO3cFWIKFUuHy
	 SqklR5N5okZ3A7K9gzk4bocydvo0adP/gGoNyDqnczZ5pIBJeFWwUfbPkog/jhuS9Gcd+
	 Z4fH6/gXfhozlete/a/jGa6OHmIA9ZVnV1xRQF2kVJS2Cxen2X4heZTKIeTedRoJRa/RM
	 YiSJ3nxjY+sKyXYN2CpqZEMy1w4TuzC7hKMmIn2Cq2Rezo4yfihA5s15UGPGLm/i/oUB4
	 u+ZtdabWWT7YjOcN6lUWBr504nIM/plkcd6ldJQb0iXsUXBoMZ4lyhiXl61lxVmVsWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nUAuPoZt9IATNuVqd0gYoBhOo77bok5n65bBT5JCbvY=;
	b=MyA/cNZ8XB5aupkjDnoZucWiLQODy0ZnEWxr8n9/AFzi7v8hi74FAzpcQEfv8w14tFVM
	 7jO0AIUIMBehHAnw9JwtKOX7IM2tt9jquKXVqggI5avmQzxCwhSzIJzHDBCmK0UTNlxwg
	 JUgaurc97MI0VklKyWPy2opOhvnl95LGsdGg+vvSScilXOb+Ph2JL12WZlWBp1xrJOMXz
	 Mrg2NskE+pBd6DP0jp+zWMeE7dyPD1BL+uL4hc9MdvNgVCTi6D/fBOu07u8yT6RJ3PWCR
	 NOzTiLD/iurYDRuOFlDTzqnZLZmgQXtyH5/xot4fbeMdyRKQ9oDEmXbrHHyZR+uUh6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2GEwSj7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D441606A31C;
	Wed, 18 Nov 2026 23:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2GEwSj7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDF21F000C4;
	Wed, 18 Nov 2026 23:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044180;
	bh=nUAuPoZt9IATNuVqd0gYoBhOo77bok5n65bBT5JCbvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2GEwSj7qW9z9Vir/JROliyqYbxSLqTx8rVtouUYMoSPVSTk5Uogp8wszE1afYQk9
	 9i6o6DC1qqpp8DRKaSgHlv4uMJHTN8YV6rJ4TWkU6gETY/SStWGjVpp3pMhB99Zv3J
	 UR32ihMZsyN6MNsCxHrHwjvuHvYxR3KZD+YmGFHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+675c91651049ad042c5f@syzkaller.appspotmail.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0477/2857] dm-integrity: validate the superblock on resume
Date: Wed, 18 Nov 2026 15:25:11 +0100
Message-ID: <20261118150218.618232762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit fc79aeb86a2c244c1f1894e2d8f2966fe2b60fa2 ]

dm_integrity_resume() re-reads the superblock from the device so that it
picks up the flags and the recalculate position. It performs no
validation on the result, while the constructor validates the superblock
it reads and sizes all the in-memory structures according to it. The user
may modify the superblock on the underlying device while the dm-integrity
device is suspended, so that the two no longer agree.

In particular, access_journal_data() shifts the journal entry index by
ic->sb->log2_sectors_per_block, while ic->journal_section_sectors and the
journal page list were computed with the value that was present at
constructor time. Increasing log2_sectors_per_block makes the index run
past the end of the journal, and dm-integrity then writes 512 bytes
through lowmem_page_address(NULL).

Snapshot the validated superblock in the constructor and refuse to resume
if any of the fields that describe the on-disk geometry changed.

Reported-by: syzbot+675c91651049ad042c5f@syzkaller.appspotmail.com
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 118ba36e446c ("dm-integrity: fix recalculation in bitmap mode")
Assisted-by: Claude:claude-opus-5
[ sashal: Dropped SB_FLAG_INLINE from the immutable flags mask because that flag does not exist in this tree; the rest matches upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 49 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 3264d38e21cd5..24adced8cf028 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -171,6 +171,7 @@ struct dm_integrity_c {
 	struct dm_bufio_client *bufio;
 	struct workqueue_struct *metadata_wq;
 	struct superblock *sb;
+	struct superblock *sb_copy;
 	unsigned int journal_pages;
 	unsigned int n_bitmap_blocks;
 
@@ -3238,6 +3239,34 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 	ic->journal_uptodate = true;
 }
 
+/*
+ * The superblock is re-read from the device on every resume, so that we pick
+ * up the flags and the recalculate position. The geometry described by the
+ * superblock must not change though - the in-memory structures (and the
+ * journal in particular) were sized according to the superblock that was
+ * validated in the constructor. Reject a superblock that was modified behind
+ * our back.
+ *
+ * Only the fields that the driver never rewrites may be tested here. In
+ * particular, "version" is recalculated by sb_set_version on every superblock
+ * write and it depends on SB_FLAG_RECALCULATING and SB_FLAG_DIRTY_BITMAP, and
+ * SB_FLAG_DISCARD_KEYED may be set by dm_integrity_resume itself.
+ */
+static bool superblock_changed(struct dm_integrity_c *ic)
+{
+	const __le32 immutable_flags = cpu_to_le32(SB_FLAG_HAVE_JOURNAL_MAC |
+						   SB_FLAG_FIXED_PADDING |
+						   SB_FLAG_FIXED_HMAC);
+
+	return memcmp(ic->sb->magic, ic->sb_copy->magic, sizeof(ic->sb->magic)) != 0 ||
+	       ic->sb->log2_interleave_sectors != ic->sb_copy->log2_interleave_sectors ||
+	       ic->sb->integrity_tag_size != ic->sb_copy->integrity_tag_size ||
+	       ic->sb->journal_sections != ic->sb_copy->journal_sections ||
+	       ic->sb->log2_sectors_per_block != ic->sb_copy->log2_sectors_per_block ||
+	       ((ic->sb->flags ^ ic->sb_copy->flags) & immutable_flags) != 0 ||
+	       memcmp(ic->sb->salt, ic->sb_copy->salt, SALT_SIZE) != 0;
+}
+
 static void dm_integrity_resume(struct dm_target *ti)
 {
 	struct dm_integrity_c *ic = (struct dm_integrity_c *)ti->private;
@@ -3254,6 +3283,18 @@ static void dm_integrity_resume(struct dm_target *ti)
 	if (r)
 		dm_integrity_io_error(ic, "reading superblock", r);
 
+	if (unlikely(superblock_changed(ic))) {
+		/*
+		 * Restore the superblock that we validated in the constructor,
+		 * so that the rest of the driver doesn't operate on values
+		 * that don't match the in-memory structures.
+		 */
+		memcpy(ic->sb, ic->sb_copy, sizeof(struct superblock));
+		DMERR("The superblock was changed while the device was suspended");
+		dm_integrity_io_error(ic, "superblock check", -EINVAL);
+		goto skip_writes;
+	}
+
 	if (ic->mode == 'R')
 		goto skip_writes;
 
@@ -4667,6 +4708,13 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		ic->just_formatted = true;
 	}
 
+	ic->sb_copy = kmemdup(ic->sb, sizeof(struct superblock), GFP_KERNEL);
+	if (!ic->sb_copy) {
+		ti->error = "Cannot allocate superblock copy";
+		r = -ENOMEM;
+		goto bad;
+	}
+
 	if (!ic->meta_dev) {
 		r = dm_set_target_max_io_len(ti, 1U << ic->sb->log2_interleave_sectors);
 		if (r)
@@ -4763,6 +4811,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	kvfree(ic->journal_tree);
 	if (ic->sb)
 		free_pages_exact(ic->sb, SB_SECTORS << SECTOR_SHIFT);
+	kfree(ic->sb_copy);
 
 	if (ic->internal_hash)
 		crypto_free_shash(ic->internal_hash);
-- 
2.53.0



