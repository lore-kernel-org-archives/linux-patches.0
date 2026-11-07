Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063828;
	b=IL7PEhVkCPj8MzchfnmP/hn62L6S6Cz08KiDKeHqy5ez33XMj9cOQYu7pGkM9IDAD5HD
	 qPREx3YFUm8fzVIOnUp+V0UmBluNccRSFoAanxuTJsiwQ6rDIChxuXw3jZsNS+EQVBYuz
	 dPnYl9PC1QdeG45zeUNrh6HY6NhZ0ThyTiGAoaBLr4bXH2P4u13PHdZhsvI4Q4ZBwsX+C
	 AsET3+Q32IwdYwoJgYUr/hs1XodXQ2LeXDCN90faRguZsxAzYB8yaCpFCSCRm4HPn8biP
	 IbOv/g7i3JljPPjC2+8MR2vtkhTUzHCzH05lMRyR6AvvTo8RSeesWHVRx84VAE9pTZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D8/RRpo/24E/0/9odecLL9/NSRILKa+ZklBaLqODb8k=;
	b=lgIIj7wpoWVPVjZ8KdHTQ26aO9kEfexi/DcadMGp+hO0y/zOvGJWa3906s5TOKMZCqFP
	 DMlOuuCc9XgaAJmKoetv61DHl3fLS6bLY52rlzAhBFI2pp36N162VRwp6ZXLvU9HaX/d1
	 gmqzqfispfsBj9HIyD/Fj7kPlFNhaVw0YoYSI+6EnxJwvlwWfn/SoejPUYIy5OJPpfC69
	 XBB0cqgi+W4U3muyt0ND4zhBEg/oM4ac/2J223DNYAAgxtNqBpWQlFQ9OiR0+WZvsJ1NN
	 PKbLPzx7awfqKtpDQevCcFBeKHWNVRs9VPz+0KpZY5t48SGlGvHI7yU4EdcLpQiQzHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wLazkXMR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EACD606A326;
	Sat,  7 Nov 2026 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wLazkXMR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D7F1F0089F;
	Sat,  7 Nov 2026 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063828;
	bh=D8/RRpo/24E/0/9odecLL9/NSRILKa+ZklBaLqODb8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wLazkXMRMvty5tiI/Je7Z2DK9od2K3Re/pZRh322jW7r9rfycLocyGDMgJFIzqRgC
	 3Z0DsKUhUKClJCiRLc7/58y7vOMG1qNXzIp+FKoe603HEWV7/mtyrICjyYUz+2m5Xs
	 O9/VQc+/UyuRMdVbPk07tbYL3dayFUO80tmQY+EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0010/1257] media: rc: Replace open coded krealloc() for keymap
Date: Sat,  7 Nov 2026 08:38:26 -0500
Message-ID: <20261107134939.712907710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit e4b4aa413cc2e48a261c8c513ced964a3390c0cf ]

Replace open coded krealloc() and remove superfluous member of struct
rc_map - we don't need to track both the size in bytes and entries.

Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: ab9567336171 ("media: rc: Add missing locking for keymap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/rc-main.c | 45 +++++++++++++++++++-------------------
 include/media/rc-map.h     |  2 --
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 85c9be43b9127..81f3aafcae8f4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -17,9 +17,8 @@
 #include <linux/module.h>
 #include "rc-core-priv.h"
 
-/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
-#define IR_TAB_MIN_SIZE	256
-#define IR_TAB_MAX_SIZE	8192
+#define IR_TAB_MIN_ENTRIES	32
+#define IR_TAB_MAX_ENTRIES	1024
 
 static const struct {
 	const char *name;
@@ -214,21 +213,23 @@ static int scancode_to_u64(const struct input_keymap_entry *ke, u64 *scancode)
 static int ir_create_table(struct rc_dev *dev, struct rc_map *rc_map,
 			   const char *name, u64 rc_proto, size_t size)
 {
+	unsigned int alloc;
 	rc_map->name = kstrdup(name, GFP_KERNEL);
 	if (!rc_map->name)
 		return -ENOMEM;
+	alloc = roundup_pow_of_two(size);
 	rc_map->rc_proto = rc_proto;
-	rc_map->alloc = roundup_pow_of_two(size * sizeof(struct rc_map_table));
-	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
-	rc_map->scan = kmalloc(rc_map->alloc, GFP_KERNEL);
+	rc_map->len = 0;
+	rc_map->size = alloc;
+	rc_map->scan = kmalloc_objs(struct rc_map_table, alloc, GFP_KERNEL);
 	if (!rc_map->scan) {
 		kfree(rc_map->name);
 		rc_map->name = NULL;
 		return -ENOMEM;
 	}
 
-	dev_dbg(&dev->dev, "Allocated space for %u keycode entries (%u bytes)\n",
-		rc_map->size, rc_map->alloc);
+	dev_dbg(&dev->dev, "Allocated space for %u keycode entries (%zu bytes)\n",
+		alloc, alloc * sizeof(struct rc_map_table));
 	return 0;
 }
 
@@ -262,38 +263,36 @@ static void ir_free_table(struct rc_map *rc_map)
 static int ir_resize_table(struct rc_dev *dev, struct rc_map *rc_map,
 			   gfp_t gfp_flags)
 {
-	unsigned int oldalloc = rc_map->alloc;
-	unsigned int newalloc = oldalloc;
-	struct rc_map_table *oldscan = rc_map->scan;
+	unsigned int newsize = rc_map->size;
 	struct rc_map_table *newscan;
 
 	if (rc_map->size == rc_map->len) {
 		/* All entries in use -> grow keytable */
-		if (rc_map->alloc >= IR_TAB_MAX_SIZE)
+		if (newsize >= IR_TAB_MAX_ENTRIES)
 			return -ENOMEM;
 
-		newalloc *= 2;
-		dev_dbg(&dev->dev, "Growing table to %u bytes\n", newalloc);
+		newsize *= 2;
+
+		dev_dbg(&dev->dev, "Growing table to %u entries\n", newsize);
 	}
 
-	if ((rc_map->len * 3 < rc_map->size) && (oldalloc > IR_TAB_MIN_SIZE)) {
+	if (rc_map->len * 3 < rc_map->size && rc_map->size > IR_TAB_MIN_ENTRIES) {
 		/* Less than 1/3 of entries in use -> shrink keytable */
-		newalloc /= 2;
-		dev_dbg(&dev->dev, "Shrinking table to %u bytes\n", newalloc);
+		newsize /= 2;
+		dev_dbg(&dev->dev, "Shrinking table to %u entries\n", newsize);
 	}
 
-	if (newalloc == oldalloc)
+	if (newsize == rc_map->size)
 		return 0;
 
-	newscan = kmalloc(newalloc, gfp_flags);
+	newscan = krealloc_array(rc_map->scan, newsize,
+				 sizeof(struct rc_map_table), gfp_flags);
 	if (!newscan)
 		return -ENOMEM;
 
-	memcpy(newscan, rc_map->scan, rc_map->len * sizeof(struct rc_map_table));
 	rc_map->scan = newscan;
-	rc_map->alloc = newalloc;
-	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
-	kfree(oldscan);
+	rc_map->size = newsize;
+
 	return 0;
 }
 
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index d95ed3e96de28..f167c37179c8f 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -148,7 +148,6 @@ struct rc_map_table {
  * @scan: pointer to struct &rc_map_table
  * @size: Max number of entries
  * @len: Number of entries that are in use
- * @alloc: size of \*scan, in bytes
  * @rc_proto: type of the remote controller protocol, as defined at
  *	     enum &rc_proto
  * @name: name of the key map table
@@ -158,7 +157,6 @@ struct rc_map {
 	struct rc_map_table	*scan;
 	unsigned int		size;
 	unsigned int		len;
-	unsigned int		alloc;
 	enum rc_proto		rc_proto;
 	const char		*name;
 	spinlock_t		lock;
-- 
2.53.0



