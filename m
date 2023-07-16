Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045F58F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2E8C433C7;
	Sun, 16 Jul 2023 20:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540871;
	bh=aiVK1UWL8gYxpPbS9xuZi2N6SPlPIisio+FvWQ6FfgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUpWfGQEoBZH5EfPbwfKeEtTwCNPIaVEaS/BH1T7qUPNIkJW7EYKA6WFuqJKoZFYN
	 Ts6bB/Y6u4vThGS6M7ObNFwqhZ1i0WGqKQYFKMUYEYVksCf7QHAU+Wup/WbmcM2Ibk
	 BUtsy3eUkaHYFiAEAckkYtLIopglTQ1bwZSW7XwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 517/591] dm: fix undue/missing spaces
Date: Sun, 16 Jul 2023 21:50:56 +0200
Message-ID: <20230716194937.253575719@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heinz Mauelshagen <heinzm@redhat.com>

[ Upstream commit 43be9c743c2553519c2093d1798b542f28095a51 ]

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Stable-dep-of: 249bed821b4d ("dm ioctl: Avoid double-fetch of version")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ioctl.c           | 4 ++--
 drivers/md/dm-mpath.c           | 2 +-
 drivers/md/dm-ps-service-time.c | 3 +--
 drivers/md/dm-snap.c            | 6 +++---
 drivers/md/dm-table.c           | 2 +-
 drivers/md/dm-uevent.h          | 2 +-
 drivers/md/dm-writecache.c      | 4 ++--
 drivers/md/dm-zoned-metadata.c  | 2 +-
 8 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 6ae1c19b82433..9fc4a5d51b3fc 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1572,7 +1572,7 @@ static void retrieve_deps(struct dm_table *table,
 	/*
 	 * Count the devices.
 	 */
-	list_for_each (tmp, dm_table_get_devices(table))
+	list_for_each(tmp, dm_table_get_devices(table))
 		count++;
 
 	/*
@@ -1589,7 +1589,7 @@ static void retrieve_deps(struct dm_table *table,
 	 */
 	deps->count = count;
 	count = 0;
-	list_for_each_entry (dd, dm_table_get_devices(table), list)
+	list_for_each_entry(dd, dm_table_get_devices(table), list)
 		deps->dev[count++] = huge_encode_dev(dd->dm_dev->bdev->bd_dev);
 
 	param->data_size = param->data_start + needed;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 91c25ad8eed84..66032ab3c4e92 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1086,7 +1086,7 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 			goto fail;
 		}
 		j = sprintf(p, "%d", hw_argc - 1);
-		for (i = 0, p+=j+1; i <= hw_argc - 2; i++, p+=j+1)
+		for (i = 0, p += j + 1; i <= hw_argc - 2; i++, p += j + 1)
 			j = sprintf(p, "%s", as->argv[i]);
 	}
 	dm_consume_args(as, hw_argc - 1);
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index 84d26234dc053..eba2293be6864 100644
--- a/drivers/md/dm-ps-service-time.c
+++ b/drivers/md/dm-ps-service-time.c
@@ -127,8 +127,7 @@ static int st_add_path(struct path_selector *ps, struct dm_path *path,
 	 * 			The valid range: 0-<ST_MAX_RELATIVE_THROUGHPUT>
 	 *			If not given, minimum value '1' is used.
 	 *			If '0' is given, the path isn't selected while
-	 * 			other paths having a positive value are
-	 * 			available.
+	 *			other paths having a positive value are	available.
 	 */
 	if (argc > 2) {
 		*error = "service-time ps: incorrect number of arguments";
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c64d987c544d7..cb80d03b37370 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -388,7 +388,7 @@ static struct origin *__lookup_origin(struct block_device *origin)
 	struct origin *o;
 
 	ol = &_origins[origin_hash(origin)];
-	list_for_each_entry (o, ol, hash_list)
+	list_for_each_entry(o, ol, hash_list)
 		if (bdev_equal(o->bdev, origin))
 			return o;
 
@@ -407,7 +407,7 @@ static struct dm_origin *__lookup_dm_origin(struct block_device *origin)
 	struct dm_origin *o;
 
 	ol = &_dm_origins[origin_hash(origin)];
-	list_for_each_entry (o, ol, hash_list)
+	list_for_each_entry(o, ol, hash_list)
 		if (bdev_equal(o->dev->bdev, origin))
 			return o;
 
@@ -2446,7 +2446,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 	chunk_t chunk;
 
 	/* Do all the snapshots on this origin */
-	list_for_each_entry (snap, snapshots, list) {
+	list_for_each_entry(snap, snapshots, list) {
 		/*
 		 * Don't make new exceptions in a merging snapshot
 		 * because it has effectively been deleted
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3acded2f976db..337e667323c4a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -211,7 +211,7 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
 {
 	struct dm_dev_internal *dd;
 
-	list_for_each_entry (dd, l, list)
+	list_for_each_entry(dd, l, list)
 		if (dd->dm_dev->bdev->bd_dev == dev)
 			return dd;
 
diff --git a/drivers/md/dm-uevent.h b/drivers/md/dm-uevent.h
index 2c9ba561fd8e9..12a5d4fb7d441 100644
--- a/drivers/md/dm-uevent.h
+++ b/drivers/md/dm-uevent.h
@@ -3,7 +3,7 @@
  * Device Mapper Uevent Support
  *
  * Copyright IBM Corporation, 2007
- * 	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
+ *	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
  */
 #ifndef DM_UEVENT_H
 #define DM_UEVENT_H
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 431c84595ddb7..c6ff43a8f0b25 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -85,12 +85,12 @@ struct wc_entry {
 	unsigned short wc_list_contiguous;
 	bool write_in_progress
 #if BITS_PER_LONG == 64
-		:1
+		: 1
 #endif
 	;
 	unsigned long index
 #if BITS_PER_LONG == 64
-		:47
+		: 47
 #endif
 	;
 	unsigned long age;
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index c795ea7da7917..13070c25adc3d 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1013,7 +1013,7 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_sb *dsb,
 	}
 
 	sb_block = le64_to_cpu(sb->sb_block);
-	if (sb_block != (u64)dsb->zone->id << zmd->zone_nr_blocks_shift ) {
+	if (sb_block != (u64)dsb->zone->id << zmd->zone_nr_blocks_shift) {
 		dmz_dev_err(dev, "Invalid superblock position "
 			    "(is %llu expected %llu)",
 			    sb_block,
-- 
2.39.2



