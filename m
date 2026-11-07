Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061436;
	b=uAHfljyQIBcocU3I8owmGBAcuhSgrAFy/PIkZkHVMoU0CqKIynHkZSYGy5b5pzcp4cLD
	 H0+mrEYgKIDde16YKL2smkVWDbI1JYzNVW1qbe7VgcQb3GjsYtQKiAJt90VtTMi+54ikE
	 D5LOIq1obMMLLVTplo17MFFfKcRbv5mPo0bQlLVtNzE8OW4JTmm9wHzWV8bHqjWYZVMUq
	 HJAYOr239BiT4/h9eihm86ZBGlp0gY6f5xduzoea/WBtSq6UyYpDjVQzeULqZOt4ybI7B
	 MYDdFLuQkCFQVRRaAijapU+AL54Ih3KO4Xlqru8wMAinQ/k0TYOHv/UY4JqIewf2RNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m8DqQABGU8lFM3MQ3o14fss6uo7NQLlEGplqQfTN0ms=;
	b=1GQFx6XFSA96AZ3Zt33wFIBtEKU0StNnsFS79pEtocJeaG/QNwUfoaIg0bwnN2ou/DYw
	 5rTmQQ0DLY5xUcfBC1/9Jk8uiNIpz4tBH75tIQZ48M9J4Ov3FP008VKYdyWd/aVhFXh+p
	 z+DU+OBX+ikUz2prUc4NUpOuKexQkzzHmIFsw55FXh0brxyLs1LXopuWtaxI5vEC3qRjM
	 kApeHimInSQSVELIeQQvjX0NS2zIrD2OZY4WlH+nPCRZNtitSRlaQddaODsHUIGDt14sC
	 KJxHPZzbh/rgPBDDuztaOP30H1AOYwF5bMWHEyCCs1iIUEYQ4e4HEsX1YeFA7CgD4zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dc4a7gif;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C8C606A32F;
	Sat,  7 Nov 2026 14:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dc4a7gif
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1291C1F0089F;
	Sat,  7 Nov 2026 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061436;
	bh=m8DqQABGU8lFM3MQ3o14fss6uo7NQLlEGplqQfTN0ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dc4a7gifmxZNMhcO/72Fx+cTOp8yELQF4eB1pc6h6DKT1dDRzCOrHwnC2XvWxM8ux
	 vN1EoLFfPDCz+gWDAXiAejt3sjuNekR9QjucB6HDQtVnb0yR00lFQvUM2sPaQNDlRk
	 02uTm1G6kwDaVUOG2XVmxSstvWTa/Z4ZeQzwdY9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+675c91651049ad042c5f@syzkaller.appspotmail.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0546/1536] dm-integrity: validate the superblock on resume
Date: Sat,  7 Nov 2026 08:42:42 -0500
Message-ID: <20261107135012.951316882@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 50 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index dbfe8128fcb26..f5f34ab02cd99 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -179,6 +179,7 @@ struct dm_integrity_c {
 	struct dm_bufio_client *bufio;
 	struct workqueue_struct *metadata_wq;
 	struct superblock *sb;
+	struct superblock *sb_copy;
 	unsigned int journal_pages;
 	unsigned int n_bitmap_blocks;
 
@@ -3706,6 +3707,35 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
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
+						   SB_FLAG_FIXED_HMAC |
+						   SB_FLAG_INLINE);
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
 	struct dm_integrity_c *ic = ti->private;
@@ -3724,6 +3754,18 @@ static void dm_integrity_resume(struct dm_target *ti)
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
 
@@ -5236,6 +5278,13 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		ic->just_formatted = true;
 	}
 
+	ic->sb_copy = kmemdup(ic->sb, sizeof(struct superblock), GFP_KERNEL);
+	if (!ic->sb_copy) {
+		ti->error = "Cannot allocate superblock copy";
+		r = -ENOMEM;
+		goto bad;
+	}
+
 	if (!ic->meta_dev && ic->mode != 'I') {
 		r = dm_set_target_max_io_len(ti, 1U << ic->sb->log2_interleave_sectors);
 		if (r)
@@ -5332,6 +5381,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	kvfree(ic->journal_tree);
 	if (ic->sb)
 		free_pages_exact(ic->sb, SB_SECTORS << SECTOR_SHIFT);
+	kfree(ic->sb_copy);
 
 	if (ic->internal_shash)
 		crypto_free_shash(ic->internal_shash);
-- 
2.53.0



