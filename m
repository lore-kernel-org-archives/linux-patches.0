Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D182429000;
	Sat, 12 Sep 2026 12:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216678; cv=none; b=KakfPn8p910kDhQeupsjKFrdBg8d9ZNbo9/vDFPFRlsh4BZHYFgmMDvcIJ6UyP3Omvu6BZls4Md/Kdp7ZAMeq6THjt7knYWjydOZbbNtEqpb6VhmHf0DvDePqF9PpFfCbEw1uRMRqMGGjYSS9StG97OQ1GiEV15hbm+ilQgS+Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216678; c=relaxed/simple;
	bh=9z6YUnpTk3TUiUACKg7lQnkJ/O3r7LZHdgyQzWnth3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnO6W88rFtYdOHpzFV4H/B4HgoiM5poirsuVgRd3o8hWDEAviSCo9om0oa8ULBlSudTFTrMLPO3FOZxmWBEhPIbbefkB4H65lCvCX4p+STcPhCmw/WKUUjRZXbIlnBdemlmJcG/G/vRDy08TyIRfKVCg1zK3LryS8V+tyOS6it8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKtDAlLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKtDAlLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E881F000FF;
	Sat, 12 Sep 2026 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216677;
	bh=OMzA1Com/5k4jd64ozXB866fytWWe2hRJpIKZbLf5lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKtDAlLnZGtHfwXm6EEyhtct8ugIPhuZ/rz+5fEMklVQW4qqIj6SkfJu0vq5rjmlS
	 4u600japZl1ZS/Rvyaak/2jAzQ8MrwMqnqhaDxXsUZZVUC6wf4LTMpoxSs1bqybgyg
	 MHxVzdBijL3yR6RhmJqmnTJKiAgKXqUnP/08K3KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0783/1376] md: remove unused mddev argument from export_rdev
Date: Sat, 12 Sep 2026 08:53:29 +0200
Message-ID: <20260912065624.988349870@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 6f507eb2bb5491327fe634dc23558d4ca5d710b8 ]

The mddev argument in export_rdev() is never used. Remove it to
simplify callers.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/linux-raid/20260304111417.20777-1-chencheng@fnnas.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Stable-dep-of: bace2010dd7a ("md: scope memalloc_noio to allocation critical sections")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3e683b9626df5..47b5415cd5a3b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -105,7 +105,7 @@ struct workqueue_struct *md_bitmap_wq;
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
-static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
+static void export_rdev(struct md_rdev *rdev);
 static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
 
 /*
@@ -865,7 +865,7 @@ void mddev_unlock(struct mddev *mddev)
 	list_for_each_entry_safe(rdev, tmp, &delete, same_set) {
 		list_del_init(&rdev->same_set);
 		kobject_del(&rdev->kobj);
-		export_rdev(rdev, mddev);
+		export_rdev(rdev);
 	}
 }
 EXPORT_SYMBOL_GPL(mddev_unlock);
@@ -2498,7 +2498,7 @@ void md_autodetect_dev(dev_t dev);
 /* just for claiming the bdev */
 static struct md_rdev claim_rdev;
 
-static void export_rdev(struct md_rdev *rdev, struct mddev *mddev)
+static void export_rdev(struct md_rdev *rdev)
 {
 	pr_debug("md: export_rdev(%pg)\n", rdev->bdev);
 	md_rdev_clear(rdev);
@@ -4637,7 +4637,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	err = bind_rdev_to_array(rdev, mddev);
  out:
 	if (err)
-		export_rdev(rdev, mddev);
+		export_rdev(rdev);
 	mddev_unlock_and_resume(mddev);
 	if (!err)
 		md_new_event();
@@ -6718,7 +6718,7 @@ static void autorun_devices(int part)
 			rdev_for_each_list(rdev, tmp, &candidates) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
-					export_rdev(rdev, mddev);
+					export_rdev(rdev);
 			}
 			autorun_array(mddev);
 			mddev_unlock_and_resume(mddev);
@@ -6728,7 +6728,7 @@ static void autorun_devices(int part)
 		 */
 		rdev_for_each_list(rdev, tmp, &candidates) {
 			list_del_init(&rdev->same_set);
-			export_rdev(rdev, mddev);
+			export_rdev(rdev);
 		}
 		mddev_put(mddev);
 	}
@@ -6916,13 +6916,13 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 				pr_warn("md: %pg has different UUID to %pg\n",
 					rdev->bdev,
 					rdev0->bdev);
-				export_rdev(rdev, mddev);
+				export_rdev(rdev);
 				return -EINVAL;
 			}
 		}
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err)
-			export_rdev(rdev, mddev);
+			export_rdev(rdev);
 		return err;
 	}
 
@@ -6965,7 +6965,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 			/* This was a hot-add request, but events doesn't
 			 * match, so reject it.
 			 */
-			export_rdev(rdev, mddev);
+			export_rdev(rdev);
 			return -EINVAL;
 		}
 
@@ -6991,7 +6991,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 				}
 			}
 			if (has_journal || mddev->bitmap) {
-				export_rdev(rdev, mddev);
+				export_rdev(rdev);
 				return -EBUSY;
 			}
 			set_bit(Journal, &rdev->flags);
@@ -7006,7 +7006,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 				/* --add initiated by this node */
 				err = md_cluster_ops->add_new_disk(mddev, rdev);
 				if (err) {
-					export_rdev(rdev, mddev);
+					export_rdev(rdev);
 					return err;
 				}
 			}
@@ -7016,7 +7016,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 		err = bind_rdev_to_array(rdev, mddev);
 
 		if (err)
-			export_rdev(rdev, mddev);
+			export_rdev(rdev);
 
 		if (mddev_is_clustered(mddev)) {
 			if (info->state & (1 << MD_DISK_CANDIDATE)) {
@@ -7079,7 +7079,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err) {
-			export_rdev(rdev, mddev);
+			export_rdev(rdev);
 			return err;
 		}
 	}
@@ -7192,7 +7192,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	return 0;
 
 abort_export:
-	export_rdev(rdev, mddev);
+	export_rdev(rdev);
 	return err;
 }
 
-- 
2.53.0



