Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9B81C7B9D;
	Tue, 27 Aug 2024 15:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771867; cv=none; b=WF3wNloPAMhtjoWtwUIRGAioYm1ayfgPj0YxbzYiEL0RyAWI2jKPrZ9l68YOy96LXuJn6zIhdk+mmMrtpjzZayZHgnRWljXvYZVWdQVLLfobHlL5CIfALmslHBISz2hP4rYncNU7Z8DNXj9sdTKMAzs5/7kz1qHor/LKhJDY+4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771867; c=relaxed/simple;
	bh=m/vEOTo3VzeDYYM2JEillxT7K3W9e7hKkpEDRKzW0oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eM3MEuu7uDWcRg/RNF75Az34+aQhLn+unaUPdBRpkekRx47VAjEpJUWHD24uczxmGFzYe7aKZzQS/vQOe85Gj2QCAE64le9WAWc22upEthEc9rZ3WcgIaZr1xJPmw7i325EyTBq/rDSCLL3gIzawjdur5f8xoPWEJPlfpFgiW2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=re0gkmH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="re0gkmH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B69C61051;
	Tue, 27 Aug 2024 15:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771867;
	bh=m/vEOTo3VzeDYYM2JEillxT7K3W9e7hKkpEDRKzW0oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=re0gkmH/PG70EEUTkurVFLxeLS+nQwer0dXIo3AXB6rzdotPclIp5u0zYkSdXv8vw
	 EzJ4g2gKmyogtc7bYUMIt9uenFzaSCOp1mRunr2ZhbsTDkX5yFerqyxh08k4nkZ6Th
	 x144ThPiMZGOzpipKycSJaZ0fdEkeC7IaUuUYRcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/321] gfs2: Rename SDF_{FS_FROZEN => FREEZE_INITIATOR}
Date: Tue, 27 Aug 2024 16:35:53 +0200
Message-ID: <20240827143839.943724802@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit cad1e15804a83afd9a5c1d95a428d60d1f9c0340 ]

Rename the SDF_FS_FROZEN flag to SDF_FREEZE_INITIATOR to indicate more
clearly that the node that has this flag set is the initiator of the
freeze.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com
Stable-dep-of: f66af88e3321 ("gfs2: Stop using gfs2_make_fs_ro for withdraw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/incore.h | 2 +-
 fs/gfs2/super.c  | 8 ++++----
 fs/gfs2/sys.c    | 2 +-
 fs/gfs2/util.c   | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index d09d9892cd055..113aeb5877027 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -600,7 +600,7 @@ enum {
 	SDF_RORECOVERY		= 7, /* read only recovery */
 	SDF_SKIP_DLM_UNLOCK	= 8,
 	SDF_FORCE_AIL_FLUSH     = 9,
-	SDF_FS_FROZEN           = 10,
+	SDF_FREEZE_INITIATOR	= 10,
 	SDF_WITHDRAWING		= 11, /* Will withdraw eventually */
 	SDF_WITHDRAW_IN_PROG	= 12, /* Withdraw is in progress */
 	SDF_REMOTE_WITHDRAW	= 13, /* Performing remote recovery */
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index cb05332e473bd..cdfbfda046945 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -676,8 +676,8 @@ void gfs2_freeze_func(struct work_struct *work)
 		gfs2_freeze_unlock(&freeze_gh);
 	}
 	deactivate_super(sb);
-	clear_bit_unlock(SDF_FS_FROZEN, &sdp->sd_flags);
-	wake_up_bit(&sdp->sd_flags, SDF_FS_FROZEN);
+	clear_bit_unlock(SDF_FREEZE_INITIATOR, &sdp->sd_flags);
+	wake_up_bit(&sdp->sd_flags, SDF_FREEZE_INITIATOR);
 	return;
 }
 
@@ -720,7 +720,7 @@ static int gfs2_freeze_super(struct super_block *sb)
 		fs_err(sdp, "retrying...\n");
 		msleep(1000);
 	}
-	set_bit(SDF_FS_FROZEN, &sdp->sd_flags);
+	set_bit(SDF_FREEZE_INITIATOR, &sdp->sd_flags);
 out:
 	mutex_unlock(&sdp->sd_freeze_mutex);
 	return error;
@@ -745,7 +745,7 @@ static int gfs2_thaw_super(struct super_block *sb)
 
 	gfs2_freeze_unlock(&sdp->sd_freeze_gh);
 	mutex_unlock(&sdp->sd_freeze_mutex);
-	return wait_on_bit(&sdp->sd_flags, SDF_FS_FROZEN, TASK_INTERRUPTIBLE);
+	return wait_on_bit(&sdp->sd_flags, SDF_FREEZE_INITIATOR, TASK_INTERRUPTIBLE);
 }
 
 /**
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index d87ea98cf5350..e1fa76d4a7c22 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -110,7 +110,7 @@ static ssize_t status_show(struct gfs2_sbd *sdp, char *buf)
 		     test_bit(SDF_RORECOVERY, &f),
 		     test_bit(SDF_SKIP_DLM_UNLOCK, &f),
 		     test_bit(SDF_FORCE_AIL_FLUSH, &f),
-		     test_bit(SDF_FS_FROZEN, &f),
+		     test_bit(SDF_FREEZE_INITIATOR, &f),
 		     test_bit(SDF_WITHDRAWING, &f),
 		     test_bit(SDF_WITHDRAW_IN_PROG, &f),
 		     test_bit(SDF_REMOTE_WITHDRAW, &f),
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 1195ea08f9ca4..ebf87fb7b3bf5 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -187,7 +187,7 @@ static void signal_our_withdraw(struct gfs2_sbd *sdp)
 	}
 	sdp->sd_jinode_gh.gh_flags |= GL_NOCACHE;
 	gfs2_glock_dq(&sdp->sd_jinode_gh);
-	if (test_bit(SDF_FS_FROZEN, &sdp->sd_flags)) {
+	if (test_bit(SDF_FREEZE_INITIATOR, &sdp->sd_flags)) {
 		/* Make sure gfs2_thaw_super works if partially-frozen */
 		flush_work(&sdp->sd_freeze_work);
 		atomic_set(&sdp->sd_freeze_state, SFS_FROZEN);
-- 
2.43.0



