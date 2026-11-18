Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040609;
	b=CvhVxSu+XldvaJHUnietXjL+VwAUuSIUWsTctQRH4bOv60yDl+oN0o2u7ltTHTSKj70L
	 DruPT83CecH457+UriJ1mLCyxl19N9BwwRO4l9nIw6wkLF7a8/ctddcTozt2dE65yiXvD
	 obdTwH3RTxWe+gWtx11W16fKPfRB1g0RsPmFTDmLk9viSQGWNbdf7IiwwHMmU3AKYzSsq
	 bEpn+lr/GcMeKSnInkQ9bI2oEdOW0KdCxedx/UGVCkLN2AaBeWROpkepajiBtN9dLHqw9
	 Omx9A8IXz/17/0soPL6wWZp67HZSqbs0snOmiPuQ4LmJC0TtHT7oztKxyJqgH2VDGNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HmF8LAswtaWBbkswKaSaGR8biVK0kwCLK8BuP8YzFoY=;
	b=xAviWBx5TBwcuNZHwrbSxZXQqEopMBiK/pF1Pjcnq8uUPOm96H63+l7uUuQO+LMcQXgD
	 yM8uDxdtrPpUYnSeegU07wXzqjXZPH5Ds1ukpw1CEPyxtVKKcSMsxKPjcMsH9VWG5VGN6
	 XOZC1t8L08ln0ySMJS5PunCTsTlpJcbDJ4YgLLARAiXVUoYnLWLrvRsmxuGQzMXbKn8HN
	 tMBg/88TNQWdAt6MGM0vfk4lKNGXjgLC+Oxb9AZnVryOSRNuW/B4DNhGmX1G8YQ1fpL9K
	 a+Sqvt+1MXS8l1EymeTlImyehRdqwp4g0g2CqDKXBZbB4ln+WMy1oB1Ija8K7YXG5wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnJYk5ze;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B366B606A32C;
	Wed, 18 Nov 2026 22:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnJYk5ze
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D58A1F000C4;
	Wed, 18 Nov 2026 22:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040609;
	bh=HmF8LAswtaWBbkswKaSaGR8biVK0kwCLK8BuP8YzFoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnJYk5zekoUd2uxie0nKATIFg7u6izPBGUNWIY/RPGZU9A0kqGuyyo76bNDQFuUAz
	 uR6gvHbD72/lXxj4g21AT8TLkCPiyXN8EZGm52+Cua7jvXUvINA/Ips+Fp74ZTpXuP
	 JJOH145Be+3xNdupGyaMftZsFmF8q7FWQd8DoZpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2518/3318] isofs: return long Joliet names whole
Date: Wed, 18 Nov 2026 15:52:20 +0100
Message-ID: <20261118150436.910982537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit b8253bcf92d6365b20eea6465f5a93c9fc4aa029 ]

get_joliet_filename() writes into a buffer allocated by its caller but
is not told how big that buffer is.  It hardcodes PAGE_SIZE as the
output limit for utf16s_to_utf8s() and gives uni16_to_x8() no limit at
all.  PAGE_SIZE was never the right bound.  Before commit b2eb2e288604
("isofs: Drop support of directory entries straddling blocks") both
callers allocated a page, but only its first 1024 bytes were for the
name, the rest holding a copy of a directory record that straddled a
block.  It could not overflow only because a directory record holds at
most 222 bytes of name (255 bytes, 33 of them fixed), which no converter
expands beyond 1024 bytes.

It also keeps the converted length in an unsigned char.  222 bytes of
name are 111 UTF-16 units, and the UTF-8 converter, used for
iocharset=utf8 and when CONFIG_NLS_DEFAULT is "utf8", needs three bytes
for each CJK, Thai or Devanagari character, so such a name can take up
to 333 bytes.  Past 255 the length wraps.  readdir then reports a short
name that usually ends in the middle of a UTF-8 sequence, and lookup
finds the file only under that name, never under its real one; a name
that wraps to exactly 0 bytes is not listed at all.

Such names are out of spec, since Joliet allows 64 units, but common
tools write them: PowerISO 9.5 and UltraISO 9.76 both keep up to 110
units by default.  Windows, for which Joliet was made, returns them
whole, including 111-unit names in records that leave out the padding
byte.

Return them whole here too.  Pass the buffer size down and have both
converters respect it.  utf16s_to_utf8s() stops before a character that
does not fit, and uni16_to_x8() now hands uni2char() the space that
actually remains and stops on -ENAMETOOLONG, as fs/hfsplus/unicode.c
does.  Both callers pass JOLIET_NAME_MAX + 1, room for 111 units at
three bytes each plus the terminator; no character set needs more than
three bytes for a UTF-16 unit, and isofs_dir_record_valid() already
rejects a record whose name_len claims more than the record holds, so no
name is cut.  Make the length an int, which is what both converters
return.

These names are longer than NAME_MAX.  POSIX lets the limit vary by
filesystem, reported by pathconf(_PC_NAME_MAX), and the VFS limits a
name only by PATH_MAX (verify_dirent_name() in fs/readdir.c).

vfat, exfat, hfsplus and ntfs3 already return names of up to 255 UTF-16
units, 765 bytes of UTF-8, and such names break the same things there:
copying the file to a filesystem with a 255-byte limit, such as ext4 or
tmpfs, fails with ENAMETOOLONG, and cp, tar, rsync and Python's shutil
report that file and carry on with the rest, so the copy is incomplete
but says so.  glibc's readdir() returns the names, but the deprecated
readdir_r() skips them and fails with ENAMETOOLONG, and an inotify
reader with the buffer size inotify(7) suggests gets EINVAL.  In the
kernel, fanotify reports events on such a file without its name and
warns once in fanotify_info_copy_name(), and a directory with such a
name cannot be reconnected from a file handle, because the generic
get_name() in fs/exportfs, which isofs uses, skips names longer than
NAME_MAX.  Cutting at NAME_MAX would avoid these, but would list names
that Windows does not show and that can coincide within a directory.

Every name of at most 255 bytes is returned exactly as before.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Link: https://patch.msgid.link/20260926042916.3277409-2-matthias.goergens@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/dir.c    |  4 +++-
 fs/isofs/isofs.h  | 11 ++++++++++-
 fs/isofs/joliet.c | 27 ++++++++++++++++++++-------
 fs/isofs/namei.c  |  3 ++-
 4 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 09df40b612fbf..f55528bb376af 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -215,7 +215,9 @@ static int do_isofs_readdir(struct inode *inode, struct file *file,
 		if (map) {
 #ifdef CONFIG_JOLIET
 			if (sbi->s_joliet_level) {
-				len = get_joliet_filename(de, tmpname, inode);
+				len = get_joliet_filename(de, tmpname,
+							  JOLIET_NAME_MAX + 1,
+							  inode);
 				p = tmpname;
 			} else
 #endif
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index 3459cefe1003c..ed174b1a12ea3 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -116,7 +116,16 @@ extern int parse_rock_ridge_inode(struct iso_directory_record *, struct inode *,
 extern int get_rock_ridge_filename(struct iso_directory_record *, char *, struct inode *);
 extern int isofs_name_translate(struct iso_directory_record *, char *, struct inode *);
 
-int get_joliet_filename(struct iso_directory_record *, unsigned char *, struct inode *);
+/*
+ * The longest name the Joliet converter returns, in bytes.  A directory
+ * record is at most 255 bytes long, which leaves room for 111 UTF-16 units
+ * of name, and no character set needs more than three bytes for one unit.
+ */
+#define JOLIET_NAME_MAX \
+	((255 - sizeof(struct iso_directory_record)) / 2 * 3)
+
+int get_joliet_filename(struct iso_directory_record *de, unsigned char *outname,
+			int outsize, struct inode *inode);
 int get_acorn_filename(struct iso_directory_record *, char *, struct inode *);
 
 extern struct dentry *isofs_lookup(struct inode *, struct dentry *, unsigned int flags);
diff --git a/fs/isofs/joliet.c b/fs/isofs/joliet.c
index c0f04a1e7f695..d37e67c5e36f4 100644
--- a/fs/isofs/joliet.c
+++ b/fs/isofs/joliet.c
@@ -15,19 +15,26 @@
  * Convert Unicode 16 to UTF-8 or ASCII.
  */
 static int
-uni16_to_x8(unsigned char *ascii, __be16 *uni, int len, struct nls_table *nls)
+uni16_to_x8(unsigned char *ascii, __be16 *uni, int len, struct nls_table *nls,
+	    int outsize)
 {
 	__be16 *ip, ch;
-	unsigned char *op;
+	unsigned char *op, *end;
 
 	ip = uni;
 	op = ascii;
+	end = ascii + outsize - 1;	/* leave room for the terminator */
 
 	while ((ch = get_unaligned(ip)) && len) {
 		int llen;
-		llen = nls->uni2char(be16_to_cpu(ch), op, NLS_MAX_CHARSET_SIZE);
+
+		if (op >= end)
+			break;
+		llen = nls->uni2char(be16_to_cpu(ch), op, end - op);
 		if (llen > 0)
 			op += llen;
+		else if (llen == -ENAMETOOLONG)
+			break;
 		else
 			*op++ = '?';
 		ip++;
@@ -38,21 +45,27 @@ uni16_to_x8(unsigned char *ascii, __be16 *uni, int len, struct nls_table *nls)
 	return (op - ascii);
 }
 
+/*
+ * Convert the Joliet name of @de into @outname, a buffer of @outsize bytes.
+ * The result is at most @outsize - 1 bytes long; a longer name is cut at a
+ * character boundary.
+ */
 int
-get_joliet_filename(struct iso_directory_record * de, unsigned char *outname, struct inode * inode)
+get_joliet_filename(struct iso_directory_record *de, unsigned char *outname,
+		    int outsize, struct inode *inode)
 {
 	struct nls_table *nls;
-	unsigned char len = 0;
+	int len = 0;
 
 	nls = ISOFS_SB(inode->i_sb)->s_nls_iocharset;
 
 	if (!nls) {
 		len = utf16s_to_utf8s((const wchar_t *) de->name,
 				de->name_len[0] >> 1, UTF16_BIG_ENDIAN,
-				outname, PAGE_SIZE);
+				outname, outsize - 1);
 	} else {
 		len = uni16_to_x8(outname, (__be16 *) de->name,
-				de->name_len[0] >> 1, nls);
+				de->name_len[0] >> 1, nls, outsize);
 	}
 	if ((len > 2) && (outname[len-2] == ';') && (outname[len-1] == '1'))
 		len -= 2;
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index 58f80e1b3ac0d..62c2f15fc6004 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -112,7 +112,8 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
 			dpnt = tmpname;
 #ifdef CONFIG_JOLIET
 		} else if (sbi->s_joliet_level) {
-			dlen = get_joliet_filename(de, tmpname, dir);
+			dlen = get_joliet_filename(de, tmpname,
+						   JOLIET_NAME_MAX + 1, dir);
 			dpnt = tmpname;
 #endif
 		} else if (sbi->s_mapping == 'a') {
-- 
2.53.0



