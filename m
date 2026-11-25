Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619897;
	b=WCzvuIt9VOD1/8mwIZU5nrd4z15vgi/AD34pEQAO74Eo/Y9qUCFEemCyZ8b/pwZED49Y
	 bQAEKBNEPP/DyyfA1xa1Eq1SkIP//sl847MjqvgU+vkyF01F/mwrLdu23wuedsfkq7+dP
	 /jJdkdoFRGUYBhNunmWUhlFRxzq45CYyGP0zJS3A6yWPvd7q8a0JxKro5pmZSDdEoWMBE
	 OaRBoYZwLNRp4H9HBrhy/LPzdpyXibVsTbDKL/9ZRwENS3FBbFvoLVpKHx3NcGlnTZ7NK
	 3vlo0rlzLR82DGLoeupms6N7mRmlJjtQ+g0nAjhE8pWCjj9LR19L5XhFf4CqghzTsEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/eO5qqBnWePh0pHRXSYKQypMgvQFWjknnw3iD/Vs4TI=;
	b=T1L/tWGAYwMthA1TKr9X0olMeM8mPoRi10TNtE6+pjc3gBVTVoSZ13VuAeX+FJiSPqTF
	 6N/kyGAkdDS+THO3W5z+/2vCKF4SPF2b++sl6Ar+D4m+dsEXcu8y78TKPxM8Nfu7ya4oF
	 6v7uZbz14oSSc6ZI84BwK2HGiZRH34IQgmBHs89oJXF7Vcy1H7vNVRt1P6gJtcFl8gXE9
	 cKt1NhHlC53MfcKEpyE3WUypVsIR94fgtTwMxiV1CcbaxCHQxWpIwuTM0i/2TSdXZUZCq
	 lfovdSaV/vyKsV52pljjCFQSetNqj+YcVFnzwEJn9lm/VkVSlHTzw/zbNF0uSdgN6jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g6Z75Vha;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21254606A31E;
	Wed, 25 Nov 2026 15:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g6Z75Vha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB4A1F000C6;
	Wed, 25 Nov 2026 15:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619896;
	bh=/eO5qqBnWePh0pHRXSYKQypMgvQFWjknnw3iD/Vs4TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6Z75VhajfcwMJF1kae3wXxfjGL1P43TficRN/P4hARXcEsCGxidzvbZgIaTBKYGJ
	 fyf6VolTPunyDNmYq7fjlu7GZ78PtOq1EsEhrDP9TZ6wyZZfsF3QB6c8whv7CJOEPB
	 rO6E2u04sY1G6gv5uRrkiWbj5supYhc2L859vAB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0697/1005] ext2: add ext2_inode_block() helper
Date: Wed, 25 Nov 2026 15:33:55 +0100
Message-ID: <20261125143838.083095493@linuxfoundation.org>
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

commit 57a84ef0520b0d17e930ff15cbd13af687e6d233 upstream.

Move the lookup of the inode table block that holds an inode out of
ext2_get_inode() into a helper. ext2_sync_inode_metadata() is going to
use it to find the block without reading it from disk.

No functional changes.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261109-work-inode-metadata_writeback-v3-1-91ac6c024018@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext2/inode.c |   49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1264,46 +1264,59 @@ static int ext2_setsize(struct inode *in
 	return 0;
 }
 
-static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
-					struct buffer_head **p)
+/*
+ * Find the inode table block that holds inode @ino and the offset of the
+ * inode in that block.
+ */
+static int ext2_inode_block(struct super_block *sb, ino_t ino,
+			    unsigned long *block, unsigned long *offset)
 {
-	struct buffer_head * bh;
 	unsigned long block_group;
-	unsigned long block;
-	unsigned long offset;
 	struct ext2_group_desc * gdp;
 
-	*p = NULL;
 	if ((ino != EXT2_ROOT_INO && ino < EXT2_FIRST_INO(sb)) ||
-	    ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
-		goto Einval;
+	    ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count)) {
+		ext2_error(sb, __func__, "bad inode number: %lu",
+			   (unsigned long) ino);
+		return -EINVAL;
+	}
 
 	block_group = (ino - 1) / EXT2_INODES_PER_GROUP(sb);
 	gdp = ext2_get_group_desc(sb, block_group, NULL);
 	if (!gdp)
-		goto Egdp;
+		return -EIO;
 	/*
 	 * Figure out the offset within the block group inode table
 	 */
-	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(sb)) * EXT2_INODE_SIZE(sb);
-	block = le32_to_cpu(gdp->bg_inode_table) +
-		(offset >> EXT2_BLOCK_SIZE_BITS(sb));
+	*offset = ((ino - 1) % EXT2_INODES_PER_GROUP(sb)) * EXT2_INODE_SIZE(sb);
+	*block = le32_to_cpu(gdp->bg_inode_table) +
+		(*offset >> EXT2_BLOCK_SIZE_BITS(sb));
+	*offset &= (EXT2_BLOCK_SIZE(sb) - 1);
+	return 0;
+}
+
+static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
+					struct buffer_head **p)
+{
+	struct buffer_head *bh;
+	unsigned long block;
+	unsigned long offset;
+	int err;
+
+	*p = NULL;
+	err = ext2_inode_block(sb, ino, &block, &offset);
+	if (err)
+		return ERR_PTR(err);
 	if (!(bh = sb_bread(sb, block)))
 		goto Eio;
 
 	*p = bh;
-	offset &= (EXT2_BLOCK_SIZE(sb) - 1);
 	return (struct ext2_inode *) (bh->b_data + offset);
 
-Einval:
-	ext2_error(sb, "ext2_get_inode", "bad inode number: %lu",
-		   (unsigned long) ino);
-	return ERR_PTR(-EINVAL);
 Eio:
 	ext2_error(sb, "ext2_get_inode",
 		   "unable to read inode block - inode=%lu, block=%lu",
 		   (unsigned long) ino, block);
-Egdp:
 	return ERR_PTR(-EIO);
 }
 


