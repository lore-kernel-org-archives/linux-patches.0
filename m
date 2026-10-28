Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207428;
	b=QiXOUVB7VCzmQEXJKYCgorPhnfySsSadQ96XIGk+nvjjdb37PzmWmk4OGtx+Opg49HRF
	 tiKbvRcckGfRu2meCZ0UBlBkXWP828J3BYBWHHypiDSu6xyOX5qLRssHwzEdLKjsEcjgz
	 yNNGT62UCqcbp7wH4euIrdFQqUtrgRp7tHpcDcRU8KnVxndwqQEudPTNFqHej2y2rZj5o
	 Btno06W8dt6Dk39o1vmwhu5QEhSyL6pRxI0jPCrNFOq4Z8s/3oIxL6XhcAxcmYm0pn1bD
	 hT0Y4DmvynRPDwUgQmQ22LR1y6mvJi4Kbc9paIkV4YjJc3RRLXlVVM+JL9CL68qIRVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=twFa7eUCl7YW/qCUw40wwqzJxbETF4Kb1ky98BsQWH0=;
	b=GtJWdwsWaIGGHijqKLZlDNzvnsTdm9cpPdm4YhDx+CqSCGuWCD5X0pkEOBHL8HvVPwYz
	 75nkbqs0rftG5XAN9xv3IDhbwVhrjArRy3nlhYBCSHpb3zHw8uoZ24Qzoh1Vk5yePjmMM
	 avCgDO9e8/edJDn6UApYvs56m8pxdSwqgX1JyGjlsYJ0CQ/qIEtlLkIRxQtyEkqLwnPsM
	 GGVMzLe3HJnm45eyWfYUipAlbso4y51/EqflZuJtqM1MoYJ60qNr8yzh+owhV1iXaZP/E
	 sCXAffiBMKhI6IoHZa0k3cjz9jWkaqGcIiMlLNfBZlwIjJ/PJsqaR5C2wMAcSYVjq9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1WCzMsB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FFA606A31A;
	Wed, 28 Oct 2026 17:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1WCzMsB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A386D1F01825;
	Wed, 28 Oct 2026 17:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207428;
	bh=twFa7eUCl7YW/qCUw40wwqzJxbETF4Kb1ky98BsQWH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1WCzMsBepEmhTakTdbodl5Y2HrnDrL3MXGeJ+0SX/wtp3emp5sQx9WJ3lhVQirmA
	 fbHOS/XcFSKc+sdtS98XDIeqkmTvyj1iQFGk6RdNPbujuSp5gflVwHEUXYJPQg/dom
	 AvhY8507SSwRwhDH97HW5t9LCt8OgZ9d+I5M9rU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Redaelli <tredaelli@redhat.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Matteo Croce <teknoraver@meta.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/247] fat: stop reading directory entries past the end-of-directory marker
Date: Wed, 28 Oct 2026 17:56:57 +0100
Message-ID: <20261028165947.695636946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Matteo Croce <technoboy85@gmail.com>

commit 6a2875517c778ac1111b6920e94cbab91cda8724 upstream.

The FAT specification[1] (FAT Directory Structure -> "DIR_Name[0]") states:

    If DIR_Name[0] == 0x00, then the directory entry is free (same as for
    0xE5), and there are no allocated directory entries after this one
    (all of the DIR_Name[0] bytes in all of the entries after this one
    are also set to 0).

    The special 0 value, rather than the 0xE5 value, indicates to FAT
    file system driver code that the rest of the entries in this
    directory do not need to be examined because they are all free.

Linux did not honour this. fat_get_entry() kept advancing past the 0x00
terminator; if the trailing on-disk slots were not zero-filled (buggy
formatters, read-only media written by other operating systems, on-disk
corruption) the driver surfaced arbitrary bytes as real directory
entries. On a typical affected image, `ls /mnt` returns ~150 bogus
entries with random binary names, multi-gigabyte sizes, dates ranging
from 1980 to 2106, and a flood of -EIO from stat().

Earlier attempts (v1..v3, see [2][3][4]) added `de->name[0] == 0` guards
at each call site. As Hirofumi pointed out on v3, those guards reject
the entry but fat_get_entry() has already advanced *pos past it; the
next readdir() resumes after the marker and walks straight back into
the garbage. His suggestion was to centralise the check.

This patch:

  * Adds fat_get_entry_eod(), a small wrapper around fat_get_entry()
    that returns -1 when name[0] == 0 and seeks *pos to dir->i_size.
    Per spec every slot after the 0x00 marker is also zero, so jumping
    to the end of the directory is correct: subsequent reads return -1
    from fat_bmap() without re-fetching trailing zero slots, and
    callers persisting *pos across invocations (notably readdir's
    ctx->pos) keep reporting end-of-directory on re-entry.

  * Converts the read/search paths to use the new wrapper:
      fat_parse_long(), fat_search_long(), __fat_readdir(),
      and fat_get_short_entry() -- the last covers
      fat_get_dotdot_entry(), fat_dir_empty(), fat_subdirs(),
      fat_scan(), and fat_scan_logstart() transitively.

  * Leaves fat_add_entries() and __fat_remove_entries() on raw
    fat_get_entry(): the write paths legitimately need to operate on
    free/zero slots. fat_add_entries() additionally detects an
    allocated entry past a 0x00 marker (the spec violation that
    produces the garbage) and treats it as filesystem corruption:
    fat_fs_error_ratelimit() is called -- which honours the configured
    errors= mount option (panic / remount-ro / continue) -- and the
    operation returns -EIO so we don't write fresh entries into an
    already-corrupt directory.

[1] https://download.microsoft.com/download/1/6/1/161ba512-40e2-4cc9-843a-923143f3456c/fatgen103.doc
[2] https://lore.kernel.org/lkml/20181207013410.7050-1-mcroce@redhat.com/
[3] https://lore.kernel.org/lkml/20181216231510.26854-1-mcroce@redhat.com/
[4] https://lore.kernel.org/lkml/20190201001408.7453-1-mcroce@redhat.com/

Reported-by: Timothy Redaelli <tredaelli@redhat.com>
Suggested-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Matteo Croce <teknoraver@meta.com>
Link: https://patch.msgid.link/20260616163346.32603-1-technoboy85@gmail.com
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[nb: keep i_pos in fat_add_entries(), it is still used here because
  the fat_add_new_entries() rework is not in this tree]
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/dir.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index acbec5bdd5210..ce6b87210e189 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -128,6 +128,31 @@ static inline int fat_get_entry(struct inode *dir, loff_t *pos,
 	return fat__get_entry(dir, pos, bh, de);
 }
 
+/*
+ * Like fat_get_entry(), but honour the FAT end-of-directory marker:
+ * a dirent whose first name byte is NUL terminates iteration per the
+ * spec, which also guarantees that every following slot is zeroed.
+ * Skip straight to the end of the directory so the next call returns
+ * -1 from fat_bmap() without re-reading the trailing zero slots, and
+ * so callers that persist *pos across invocations (e.g. readdir's
+ * ctx->pos) keep reporting EOD.  Release *bh and set it to NULL to
+ * match fat_get_entry()'s contract that *bh is NULL on the -1 return.
+ */
+static int fat_get_entry_eod(struct inode *dir, loff_t *pos,
+			     struct buffer_head **bh,
+			     struct msdos_dir_entry **de)
+{
+	int err = fat_get_entry(dir, pos, bh, de);
+
+	if (err == 0 && (*de)->name[0] == 0) {
+		brelse(*bh);
+		*bh = NULL;
+		*pos = dir->i_size;
+		return -1;
+	}
+	return err;
+}
+
 /*
  * Convert Unicode 16 to UTF-8, translated Unicode, or ASCII.
  * If uni_xlate is enabled and we can't get a 1:1 conversion, use a
@@ -325,7 +350,7 @@ static int fat_parse_long(struct inode *dir, loff_t *pos,
 
 		if (ds->id & 0x40)
 			(*unicode)[offset + 13] = 0;
-		if (fat_get_entry(dir, pos, bh, de) < 0)
+		if (fat_get_entry_eod(dir, pos, bh, de) < 0)
 			return PARSE_EOF;
 		if (slot == 0)
 			break;
@@ -487,7 +512,7 @@ int fat_search_long(struct inode *inode, const unsigned char *name,
 
 	err = -ENOENT;
 	while (1) {
-		if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
+		if (fat_get_entry_eod(inode, &cpos, &bh, &de) == -1)
 			goto end_of_dir;
 parse_record:
 		nr_slots = 0;
@@ -599,7 +624,7 @@ static int __fat_readdir(struct inode *inode, struct file *file,
 
 	bh = NULL;
 get_new:
-	if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
+	if (fat_get_entry_eod(inode, &cpos, &bh, &de) == -1)
 		goto end_of_dir;
 parse_record:
 	nr_slots = 0;
@@ -882,7 +907,7 @@ static int fat_get_short_entry(struct inode *dir, loff_t *pos,
 			       struct buffer_head **bh,
 			       struct msdos_dir_entry **de)
 {
-	while (fat_get_entry(dir, pos, bh, de) >= 0) {
+	while (fat_get_entry_eod(dir, pos, bh, de) >= 0) {
 		/* free entry or long name entry or volume label */
 		if (!IS_FREE((*de)->name) && !((*de)->attr & ATTR_VOLUME))
 			return 0;
@@ -1299,6 +1324,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	struct msdos_dir_entry *de;
 	int err, free_slots, i, nr_bhs;
 	loff_t pos, i_pos;
+	bool saw_eod;
 
 	sinfo->nr_slots = nr_slots;
 
@@ -1307,12 +1333,15 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	bh = prev = NULL;
 	pos = 0;
 	err = -ENOSPC;
+	saw_eod = false;
 	while (fat_get_entry(dir, &pos, &bh, &de) > -1) {
 		/* check the maximum size of directory */
 		if (pos >= FAT_MAX_DIR_SIZE)
 			goto error;
 
 		if (IS_FREE(de->name)) {
+			if (de->name[0] == 0)
+				saw_eod = true;
 			if (prev != bh) {
 				get_bh(bh);
 				bhs[nr_bhs] = prev = bh;
@@ -1322,6 +1351,13 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			if (free_slots == nr_slots)
 				goto found;
 		} else {
+			if (saw_eod) {
+				fat_fs_error_ratelimit(sb,
+					"allocated dir entry found after end-of-directory marker (i_pos %lld)",
+					MSDOS_I(dir)->i_pos);
+				err = -EIO;
+				goto error;
+			}
 			for (i = 0; i < nr_bhs; i++)
 				brelse(bhs[i]);
 			prev = NULL;
-- 
2.53.0



