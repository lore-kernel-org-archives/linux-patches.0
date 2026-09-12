Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D492E06E4;
	Sat, 12 Sep 2026 12:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216833; cv=none; b=hCdD2QAff3bq9ssxhNOwUDq1FYa8XHWF6QcGP6kd/nKsGS4Z441Kd5YmOSo89LBJqnjbqag1rdH5P+tu7u2UNVKrUAKCGtrRhvZb70iyGcU25BqjEbuXd6/3jnd65ShxFXisQm4CUgvc3f2zn/gCPxfIKum+OYOAe8A6wAVVyqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216833; c=relaxed/simple;
	bh=fUJDKYsn3LpxkNdMdHdmeV26/BnyfQlRoH3Y2wQ76M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcP08B5CPHo0DfUa7sdU3A4TnDC8BE7blYrc78tF8NEjo4xSRQDnpOVvHLHLpfKYeU7IR7XWPWqTZK6p6edZ2rohh/ipKZwOqFzejgQQdKjvcQrQc93Lk+uphY8Z1al0wNd4KWL3Mu63RsJXBz/EMS+GhIfKaYQ/FQBsyu4otxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxjdbRF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxjdbRF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717531F000FF;
	Sat, 12 Sep 2026 12:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216832;
	bh=x+FKlgeyL4MBz8l8BkOeAaVOHKljBpvsttW2LTMT8yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxjdbRF5sPCWs7ZoilDzptK5ZEpn9gUCdbgJaiKXV3E7vOWx4IutXpyzGO7U7D8mV
	 b6JXK/lFe2MZvI0Y/xSOV+c8M4+EpZ7TCBfvSSsJ04+0Xn2AEWmV5wejItt9gEfwbk
	 7nmN4Z+2uUPwJwEgz28IN9upqJ2QIR7V7sTvpioY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0790/1376] md: merge mddev has_superblock into mddev_flags
Date: Sat, 12 Sep 2026 08:53:36 +0200
Message-ID: <20260912065625.144564848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit fba4a980403d2f489bc680dbff7d7d2514e669f9 ]

There is not need to use a separate field in struct mddev, there are no
functional changes.

Link: https://lore.kernel.org/linux-raid/20260114171241.3043364-3-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Stable-dep-of: 140234b2380f ("md/raid1: create serial pool adding rdev to array with serialize_policy=1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 6 +++---
 drivers/md/md.h | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9ad6835a3c143..6d0ab9a471316 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6063,7 +6063,7 @@ int md_run(struct mddev *mddev)
 	 * the only valid external interface is through the md
 	 * device.
 	 */
-	mddev->has_superblocks = false;
+	clear_bit(MD_HAS_SUPERBLOCK, &mddev->flags);
 	rdev_for_each(rdev, mddev) {
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
@@ -6076,7 +6076,7 @@ int md_run(struct mddev *mddev)
 		}
 
 		if (rdev->sb_page)
-			mddev->has_superblocks = true;
+			set_bit(MD_HAS_SUPERBLOCK, &mddev->flags);
 
 		/* perform some consistency tests on the device.
 		 * We don't want the data to overlap the metadata,
@@ -8722,7 +8722,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 	rcu_read_unlock();
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
-	if (!mddev->has_superblocks)
+	if (!test_bit(MD_HAS_SUPERBLOCK, &mddev->flags))
 		return;
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 9a44676102f20..e5b37aafc0591 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -312,6 +312,7 @@ struct md_cluster_info;
  *		   array is ready yet.
  * @MD_BROKEN: This is used to stop writes and mark array as failed.
  * @MD_DELETED: This device is being deleted
+ * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -327,6 +328,7 @@ enum mddev_flags {
 	MD_NOT_READY,
 	MD_BROKEN,
 	MD_DELETED,
+	MD_HAS_SUPERBLOCK,
 };
 
 enum mddev_sb_flags {
@@ -587,7 +589,6 @@ struct mddev {
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
 
-	bool	has_superblocks:1;
 	bool	fail_last_dev:1;
 	bool	serialize_policy:1;
 };
-- 
2.53.0



