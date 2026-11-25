Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619662;
	b=NeAIbZ7sqI8gHVVRkbxmC5Ijfw4vQnotXWKkGXVaTjzwBrFfYH4iqQPpy6i6BToXcM48
	 vpFBD61lxpxb2cDeZSfgVxgIEj6EMYa1FUIZBXviyvgX1JeVJQPIJBdPSoZ/KMEUNsnPq
	 WF1EAscqJr7yAT16v1jBER0cg+hRFb8LliHfTlhfZFVOcxHBh6eK9lw8Ba4gVavwFyPwR
	 /gXtGyO8L8yc9R6TTw5L2V1O0mzJzbaoUlMwRCJ1UIaiXRhGkHEq2G8bGfK0vNFWowpJB
	 UWwiRGouVqTs7fQf4OJA4epi/955t/lcz2csaCqHfGw+vnlPNc9TKf9MTDVzC7SQgXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0n3RnnX3FbRF0YN12mB+PZjvL1Za3VDRHDP0LshfGMI=;
	b=fSbz/LlnpgWWeO4Rr9GnjVbID5fK02itq60FGDdPubeaAUv5LMDoWKvnSwsdQNMB5OPT
	 giDapW632wh38InPYMIcTLH5660qe6sgExBtrFUBf61DsYIYDVTbGdCEzw5AeZAWeWHmO
	 +bGE04oyDOZPpYEf7wGqEf2fNMvy66G7Z717w/cpAyXnNm+uo2VlaZ6XtGUEgqJtJDz8b
	 P51M3Pf1NhBl8QNc0BghVrM4cFRU1tyFEK/UUeQrBv7IXlE7QEND+Qtcqj2Dz/YL9eiKs
	 JbHtuTsbrA8aJLMeBmcGSZ2HLMe/oUr5G9Xkco9v+RVAqHtFsTT/jqR2ZShd0LmyAQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bRx3NDB6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0C5606A696;
	Wed, 25 Nov 2026 15:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bRx3NDB6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346BE1F00AD4;
	Wed, 25 Nov 2026 15:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619661;
	bh=0n3RnnX3FbRF0YN12mB+PZjvL1Za3VDRHDP0LshfGMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRx3NDB6117F0Ddtr0A0HoFdvDPdozQds+O3FlPuhBU6vZSqgnDXDIoju+HTHVQQM
	 /vR5dNfz82Aurml5SxaVsR9Zcsn7VQibyf9vu0tXmFhv0FhZQXy9wcItxJB6pt72VY
	 QIU9c0yECAK1ucwLVQ/pk1YXj9aiDQJY2Gejnil4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0669/1005] minix: add minix_inode_block() helper
Date: Wed, 25 Nov 2026 15:33:27 +0100
Message-ID: <20261125143837.421952596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 1037134824e9d5c8cc04eea5ec6a5eb3ef4312bb upstream.

Move the lookup of the block that holds an inode out of
minix_V1_raw_inode() and minix_V2_raw_inode() into a helper.
minix_sync_inode_metadata() is going to use it to find the block
without reading it from disk.

No functional changes.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261109-work-inode-metadata_writeback-v3-5-91ac6c024018@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/minix/bitmap.c |   37 +++++++++++++++++++++++--------------
 fs/minix/minix.h  |    1 +
 2 files changed, 24 insertions(+), 14 deletions(-)

--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -103,21 +103,35 @@ unsigned long minix_count_free_blocks(st
 		<< sbi->s_log_zone_size);
 }
 
-struct minix_inode *
-minix_V1_raw_inode(struct super_block *sb, ino_t ino, struct buffer_head **bh)
+/* Return the block that holds inode @ino or 0 if @ino is out of range. */
+int minix_inode_block(struct super_block *sb, ino_t ino)
 {
-	int block;
 	struct minix_sb_info *sbi = minix_sb(sb);
-	struct minix_inode *p;
+	int inodes_per_block;
 
 	if (!ino || ino > sbi->s_ninodes) {
 		printk("Bad inode number on dev %s: %ld is out of range\n",
 		       sb->s_id, (long)ino);
-		return NULL;
+		return 0;
 	}
+	if (sbi->s_version == MINIX_V1)
+		inodes_per_block = MINIX_INODES_PER_BLOCK;
+	else
+		inodes_per_block = sb->s_blocksize / sizeof(struct minix2_inode);
+	return 2 + sbi->s_imap_blocks + sbi->s_zmap_blocks +
+		 (ino - 1) / inodes_per_block;
+}
+
+struct minix_inode *
+minix_V1_raw_inode(struct super_block *sb, ino_t ino, struct buffer_head **bh)
+{
+	int block;
+	struct minix_inode *p;
+
+	block = minix_inode_block(sb, ino);
+	if (!block)
+		return NULL;
 	ino--;
-	block = 2 + sbi->s_imap_blocks + sbi->s_zmap_blocks +
-		 ino / MINIX_INODES_PER_BLOCK;
 	*bh = sb_bread(sb, block);
 	if (!*bh) {
 		printk("Unable to read inode block\n");
@@ -131,19 +145,14 @@ struct minix2_inode *
 minix_V2_raw_inode(struct super_block *sb, ino_t ino, struct buffer_head **bh)
 {
 	int block;
-	struct minix_sb_info *sbi = minix_sb(sb);
 	struct minix2_inode *p;
 	int minix2_inodes_per_block = sb->s_blocksize / sizeof(struct minix2_inode);
 
 	*bh = NULL;
-	if (!ino || ino > sbi->s_ninodes) {
-		printk("Bad inode number on dev %s: %ld is out of range\n",
-		       sb->s_id, (long)ino);
+	block = minix_inode_block(sb, ino);
+	if (!block)
 		return NULL;
-	}
 	ino--;
-	block = 2 + sbi->s_imap_blocks + sbi->s_zmap_blocks +
-		 ino / minix2_inodes_per_block;
 	*bh = sb_bread(sb, block);
 	if (!*bh) {
 		printk("Unable to read inode block\n");
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -47,6 +47,7 @@ void __minix_error_inode(struct inode *i
 			 unsigned int line, const char *fmt, ...);
 
 struct inode *minix_iget(struct super_block *, unsigned long);
+int minix_inode_block(struct super_block *sb, ino_t ino);
 struct minix_inode *minix_V1_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 struct minix2_inode *minix_V2_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 struct inode *minix_new_inode(const struct inode *, umode_t);


