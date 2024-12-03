Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183C71DE8A5;
	Tue,  3 Dec 2024 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241613; cv=none; b=qLsJAdMLJQ2JDQshUDRTBQKKT+VgDftWnodUKrQpfKTAXsvahV/jzKD7aOxykgHierWwpqZc8ed1h1H4iAt5q83q0nfszk0hE/8EBpr5oAvmg7NLLtEkvzmaj76rGh45sIEiV0VZDthQQ8OKEW/v2wGJ1xYr7bFtce3yW8UQ/g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241613; c=relaxed/simple;
	bh=akShsFEil0YacuqeQe43BUgNuPtIIN64SmY3xWamGDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bah2sNfCU76sKYPRNWwBzpKh5by5iyeaDc1SWX1SsTdRQEhEmzNTSrlcZt2XsljvYha5X9l+Wv8DfnPLYVzI3Cj48X80IYNoQNDGnip3uC54foJmynxzyNKh05z5HKPF/HbuCJHgW5sAyRkEX1wuVeca7xpA5GkfIA6eA/B0UVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmeyTokV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmeyTokV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB5EC4CECF;
	Tue,  3 Dec 2024 16:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241612;
	bh=akShsFEil0YacuqeQe43BUgNuPtIIN64SmY3xWamGDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmeyTokVOps9Yb6UGG+K6493tZdwxxBSOEaP1vc47hmwyBiXRmzAicwg1fmgqmAx0
	 CniH5mDmK3H+cOPRJccsBzyGpKeIIWa6jmsgW2XiWk2YdiafhzX3hjNiTLioAQqEr9
	 ikfSf7OIdxLxEFv5YFQyS92UoXnwgJfX2Q0OcG08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 467/826] gfs2: Rename GLF_VERIFY_EVICT to GLF_VERIFY_DELETE
Date: Tue,  3 Dec 2024 15:43:14 +0100
Message-ID: <20241203144801.980796502@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 820ce8ed53ce2111aa5171f7349f289d7e9d0693 ]

Rename the GLF_VERIFY_EVICT flag to GLF_VERIFY_DELETE: that flag
indicates that we want to delete an inode / verify that it has been
deleted.

To match, rename gfs2_queue_verify_evict() to
gfs2_queue_verify_delete().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 7c6f714d8847 ("gfs2: Fix unlinked inode cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c  | 14 +++++++-------
 fs/gfs2/incore.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 269c3bc7fced7..5addf4ebf33bd 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1013,11 +1013,11 @@ bool gfs2_queue_try_to_evict(struct gfs2_glock *gl)
 				  &gl->gl_delete, 0);
 }
 
-static bool gfs2_queue_verify_evict(struct gfs2_glock *gl)
+static bool gfs2_queue_verify_delete(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 
-	if (test_and_set_bit(GLF_VERIFY_EVICT, &gl->gl_flags))
+	if (test_and_set_bit(GLF_VERIFY_DELETE, &gl->gl_flags))
 		return false;
 	return queue_delayed_work(sdp->sd_delete_wq,
 				  &gl->gl_delete, 5 * HZ);
@@ -1052,19 +1052,19 @@ static void delete_work_func(struct work_struct *work)
 		if (gfs2_try_evict(gl)) {
 			if (test_bit(SDF_KILL, &sdp->sd_flags))
 				goto out;
-			if (gfs2_queue_verify_evict(gl))
+			if (gfs2_queue_verify_delete(gl))
 				return;
 		}
 		goto out;
 	}
 
-	if (test_and_clear_bit(GLF_VERIFY_EVICT, &gl->gl_flags)) {
+	if (test_and_clear_bit(GLF_VERIFY_DELETE, &gl->gl_flags)) {
 		inode = gfs2_lookup_by_inum(sdp, no_addr, gl->gl_no_formal_ino,
 					    GFS2_BLKST_UNLINKED);
 		if (IS_ERR(inode)) {
 			if (PTR_ERR(inode) == -EAGAIN &&
 			    !test_bit(SDF_KILL, &sdp->sd_flags) &&
-			    gfs2_queue_verify_evict(gl))
+			    gfs2_queue_verify_delete(gl))
 				return;
 		} else {
 			d_prune_aliases(inode);
@@ -2118,7 +2118,7 @@ static void glock_hash_walk(glock_examiner examiner, const struct gfs2_sbd *sdp)
 void gfs2_cancel_delete_work(struct gfs2_glock *gl)
 {
 	clear_bit(GLF_TRY_TO_EVICT, &gl->gl_flags);
-	clear_bit(GLF_VERIFY_EVICT, &gl->gl_flags);
+	clear_bit(GLF_VERIFY_DELETE, &gl->gl_flags);
 	if (cancel_delayed_work(&gl->gl_delete))
 		gfs2_glock_put(gl);
 }
@@ -2371,7 +2371,7 @@ static const char *gflags2str(char *buf, const struct gfs2_glock *gl)
 		*p++ = 'N';
 	if (test_bit(GLF_TRY_TO_EVICT, gflags))
 		*p++ = 'e';
-	if (test_bit(GLF_VERIFY_EVICT, gflags))
+	if (test_bit(GLF_VERIFY_DELETE, gflags))
 		*p++ = 'E';
 	*p = 0;
 	return buf;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index aa4ef67a34e03..bd1348bff90eb 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -329,7 +329,7 @@ enum {
 	GLF_BLOCKING			= 15,
 	GLF_UNLOCKED			= 16, /* Wait for glock to be unlocked */
 	GLF_TRY_TO_EVICT		= 17, /* iopen glocks only */
-	GLF_VERIFY_EVICT		= 18, /* iopen glocks only */
+	GLF_VERIFY_DELETE		= 18, /* iopen glocks only */
 };
 
 struct gfs2_glock {
-- 
2.43.0



