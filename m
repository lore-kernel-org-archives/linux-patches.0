Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55633161BF;
	Mon, 13 Apr 2026 16:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099034; cv=none; b=Op7gWX9l/Zf+5fNZyvSeTuem6jE+oNtfQVvkLrveSpQJ2ad+XD5jRXvrAzFuvBCGbyLA856PxLe9X4d7XAR9U4aFDTY0FpZJ4uhLSGATwcoaAmZ9++RMYFJCalf5Hg0OjLtzCHn+UodJboqh4jhubQ5HhhIHYI+zJVLJKTtzuPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099034; c=relaxed/simple;
	bh=BTB2l3NXFp0AjC1GXaHE+ZUFu9TAhkpMCzO4bx5JoFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2BCUP3e4FmezWzVkWD2/3fh1Ck+Iwcwh+nDgmVBSRG/S1Rj71WSFxUYlmgV9EUk3MQaHzlhkP27LE95cLyDhjbKnzlidkdS5f2s42dOSni0I0QPzwv5AnSGBEYsNstCi4vlAR+jsz8S6Vn4ID939feF/T2YBQsLc3Gba/siPWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhyoO4Mn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhyoO4Mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFAEC2BCAF;
	Mon, 13 Apr 2026 16:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099034;
	bh=BTB2l3NXFp0AjC1GXaHE+ZUFu9TAhkpMCzO4bx5JoFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhyoO4MnX7e7/58fci+pvEpvw1sj3wFIw8QPNtdb/tK9gde8eJa24X8XalVcUvaBu
	 9Zy48G4bkBzHpd7I6W0B5T6FsR156TsNbRDpdtl+jF1xj5xKDcxtRBGxGIetdocPSl
	 H3dRvjrSI3byQjm0EwkZ1itk1QbAEchR5mvNjj8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corentin Labbe <clabbe@baylibre.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/491] mtd: partitions: redboot: fix style issues
Date: Mon, 13 Apr 2026 17:57:10 +0200
Message-ID: <20260413155825.990247919@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit eb1765c40530ccc8690b9dad88cec6aaa6bfb498 ]

This patch fixes easy checkpatch issues.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210520114851.1274609-2-clabbe@baylibre.com
Stable-dep-of: 8e2f8020270a ("mtd: Avoid boot crash in RedBoot partition table parser")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/parsers/redboot.c |   69 ++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

--- a/drivers/mtd/parsers/redboot.c
+++ b/drivers/mtd/parsers/redboot.c
@@ -17,15 +17,15 @@
 #include <linux/module.h>
 
 struct fis_image_desc {
-    unsigned char name[16];      // Null terminated name
-    uint32_t	  flash_base;    // Address within FLASH of image
-    uint32_t	  mem_base;      // Address in memory where it executes
-    uint32_t	  size;          // Length of image
-    uint32_t	  entry_point;   // Execution entry point
-    uint32_t	  data_length;   // Length of actual data
-    unsigned char _pad[256-(16+7*sizeof(uint32_t))];
-    uint32_t	  desc_cksum;    // Checksum over image descriptor
-    uint32_t	  file_cksum;    // Checksum over image data
+	unsigned char name[16];      // Null terminated name
+	u32	  flash_base;    // Address within FLASH of image
+	u32	  mem_base;      // Address in memory where it executes
+	u32	  size;          // Length of image
+	u32	  entry_point;   // Execution entry point
+	u32	  data_length;   // Length of actual data
+	unsigned char _pad[256 - (16 + 7 * sizeof(u32))];
+	u32	  desc_cksum;    // Checksum over image descriptor
+	u32	  file_cksum;    // Checksum over image data
 };
 
 struct fis_list {
@@ -91,12 +91,12 @@ static int parse_redboot_partitions(stru
 
 	parse_redboot_of(master);
 
-	if ( directory < 0 ) {
+	if (directory < 0) {
 		offset = master->size + directory * master->erasesize;
 		while (mtd_block_isbad(master, offset)) {
 			if (!offset) {
-			nogood:
-				printk(KERN_NOTICE "Failed to find a non-bad block to check for RedBoot partition table\n");
+nogood:
+				pr_notice("Failed to find a non-bad block to check for RedBoot partition table\n");
 				return -EIO;
 			}
 			offset -= master->erasesize;
@@ -114,8 +114,8 @@ static int parse_redboot_partitions(stru
 	if (!buf)
 		return -ENOMEM;
 
-	printk(KERN_NOTICE "Searching for RedBoot partition table in %s at offset 0x%lx\n",
-	       master->name, offset);
+	pr_notice("Searching for RedBoot partition table in %s at offset 0x%lx\n",
+		  master->name, offset);
 
 	ret = mtd_read(master, offset, master->erasesize, &retlen,
 		       (void *)buf);
@@ -151,14 +151,13 @@ static int parse_redboot_partitions(stru
 			     && swab32(buf[i].size) < master->erasesize)) {
 				int j;
 				/* Update numslots based on actual FIS directory size */
-				numslots = swab32(buf[i].size) / sizeof (struct fis_image_desc);
+				numslots = swab32(buf[i].size) / sizeof(struct fis_image_desc);
 				for (j = 0; j < numslots; ++j) {
-
 					/* A single 0xff denotes a deleted entry.
 					 * Two of them in a row is the end of the table.
 					 */
 					if (buf[j].name[0] == 0xff) {
-				  		if (buf[j].name[1] == 0xff) {
+						if (buf[j].name[1] == 0xff) {
 							break;
 						} else {
 							continue;
@@ -185,8 +184,8 @@ static int parse_redboot_partitions(stru
 	}
 	if (i == numslots) {
 		/* Didn't find it */
-		printk(KERN_NOTICE "No RedBoot partition table detected in %s\n",
-		       master->name);
+		pr_notice("No RedBoot partition table detected in %s\n",
+			  master->name);
 		ret = 0;
 		goto out;
 	}
@@ -205,7 +204,7 @@ static int parse_redboot_partitions(stru
 			break;
 
 		new_fl = kmalloc(sizeof(struct fis_list), GFP_KERNEL);
-		namelen += strlen(buf[i].name)+1;
+		namelen += strlen(buf[i].name) + 1;
 		if (!new_fl) {
 			ret = -ENOMEM;
 			goto out;
@@ -214,13 +213,13 @@ static int parse_redboot_partitions(stru
 		if (data && data->origin)
 			buf[i].flash_base -= data->origin;
 		else
-			buf[i].flash_base &= master->size-1;
+			buf[i].flash_base &= master->size - 1;
 
 		/* I'm sure the JFFS2 code has done me permanent damage.
 		 * I now think the following is _normal_
 		 */
 		prev = &fl;
-		while(*prev && (*prev)->img->flash_base < new_fl->img->flash_base)
+		while (*prev && (*prev)->img->flash_base < new_fl->img->flash_base)
 			prev = &(*prev)->next;
 		new_fl->next = *prev;
 		*prev = new_fl;
@@ -240,7 +239,7 @@ static int parse_redboot_partitions(stru
 		}
 	}
 #endif
-	parts = kzalloc(sizeof(*parts)*nrparts + nulllen + namelen, GFP_KERNEL);
+	parts = kzalloc(sizeof(*parts) * nrparts + nulllen + namelen, GFP_KERNEL);
 
 	if (!parts) {
 		ret = -ENOMEM;
@@ -249,23 +248,22 @@ static int parse_redboot_partitions(stru
 
 	nullname = (char *)&parts[nrparts];
 #ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
-	if (nulllen > 0) {
+	if (nulllen > 0)
 		strcpy(nullname, nullstring);
-	}
 #endif
 	names = nullname + nulllen;
 
-	i=0;
+	i = 0;
 
 #ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
 	if (fl->img->flash_base) {
-	       parts[0].name = nullname;
-	       parts[0].size = fl->img->flash_base;
-	       parts[0].offset = 0;
+		parts[0].name = nullname;
+		parts[0].size = fl->img->flash_base;
+		parts[0].offset = 0;
 		i++;
 	}
 #endif
-	for ( ; i<nrparts; i++) {
+	for ( ; i < nrparts; i++) {
 		parts[i].size = fl->img->size;
 		parts[i].offset = fl->img->flash_base;
 		parts[i].name = names;
@@ -273,17 +271,17 @@ static int parse_redboot_partitions(stru
 		strcpy(names, fl->img->name);
 #ifdef CONFIG_MTD_REDBOOT_PARTS_READONLY
 		if (!memcmp(names, "RedBoot", 8) ||
-				!memcmp(names, "RedBoot config", 15) ||
-				!memcmp(names, "FIS directory", 14)) {
+		    !memcmp(names, "RedBoot config", 15) ||
+		    !memcmp(names, "FIS directory", 14)) {
 			parts[i].mask_flags = MTD_WRITEABLE;
 		}
 #endif
-		names += strlen(names)+1;
+		names += strlen(names) + 1;
 
 #ifdef CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED
-		if(fl->next && fl->img->flash_base + fl->img->size + master->erasesize <= fl->next->img->flash_base) {
+		if (fl->next && fl->img->flash_base + fl->img->size + master->erasesize <= fl->next->img->flash_base) {
 			i++;
-			parts[i].offset = parts[i-1].size + parts[i-1].offset;
+			parts[i].offset = parts[i - 1].size + parts[i - 1].offset;
 			parts[i].size = fl->next->img->flash_base - parts[i].offset;
 			parts[i].name = nullname;
 		}
@@ -297,6 +295,7 @@ static int parse_redboot_partitions(stru
  out:
 	while (fl) {
 		struct fis_list *old = fl;
+
 		fl = fl->next;
 		kfree(old);
 	}


