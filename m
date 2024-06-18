Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75349155C90;
	Tue, 18 Jun 2024 12:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715511; cv=none; b=FWPG0dzKzqORqpPYjULdMqQY/Yt3UQI+LezcaXsOTE8BJ8AL/SKRvjFH4dTbKnhuUL3XVlKCiHaDsqa2KhYC4+w/+CRSTSDkIOtcyV7d/TnGP+8E6UBZwtELnzm3QTAvXAxREFDhtxnphu05t7u5vzrmYNNR5TCXE7/TrbDepBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715511; c=relaxed/simple;
	bh=aaOpg0tKR43rVJPshUu9UY5+Um8GbZiazk27+Hi5GYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB0P3AKSEmNPCE+/PdQqHRSS3gYkVKUE2nH/TbeQZY6qorHob/7fkLbandCmyB3Bop2DpPbR5OJt7YH3lcTKP2uEne3CXhkLIzboHMfBSdm+0hgDN8FnnCVkH8VkM9jY4UYfLNQ2pi3+CS1/pr8GCAomFt3ULvb1y7Bf/MfbFgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUW0Q2r2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUW0Q2r2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D48C3277B;
	Tue, 18 Jun 2024 12:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715511;
	bh=aaOpg0tKR43rVJPshUu9UY5+Um8GbZiazk27+Hi5GYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUW0Q2r2o5NbaaEPPc0o8zNZrR2FJ4kB8VR6x1GGozHzZ0FzAQE4X8Kw8Mtmaf85t
	 6mD/FIlsCcK4hKdZcPgzx4QOsKeqKVkceNd7glzoBDjAn263fNIfEqSLtrPJtCODlo
	 DHOq1erQ3GAuS3LmFTmpoJu2+UrAi139IWIIqDtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bobrowski <repnop@google.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/770] fanotify: minor cosmetic adjustments to fid labels
Date: Tue, 18 Jun 2024 14:33:06 +0200
Message-ID: <20240618123420.121763646@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Bobrowski <repnop@google.com>

[ Upstream commit d3424c9bac893bd06f38a20474cd622881d384ca ]

With the idea to support additional info record types in the future
i.e. fanotify_event_info_pidfd, it's a good idea to rename some of the
labels assigned to some of the existing fid related functions,
parameters, etc which more accurately represent the intent behind
their usage.

For example, copy_info_to_user() was defined with a generic function
label, which arguably reads as being supportive of different info
record types, however the parameter list for this function is
explicitly tailored towards the creation and copying of the
fanotify_event_info_fid records. This same point applies to the macro
defined as FANOTIFY_INFO_HDR_LEN.

With fanotify_event_info_len(), we change the parameter label so that
the function implies that it can be extended to calculate the length
for additional info record types.

Link: https://lore.kernel.org/r/7c3ec33f3c718dac40764305d4d494d858f59c51.1628398044.git.repnop@google.com
Signed-off-by: Matthew Bobrowski <repnop@google.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 33 +++++++++++++++++-------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 1c439e2fdcd80..74b51dab2cdce 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -104,7 +104,7 @@ struct kmem_cache *fanotify_path_event_cachep __read_mostly;
 struct kmem_cache *fanotify_perm_event_cachep __read_mostly;
 
 #define FANOTIFY_EVENT_ALIGN 4
-#define FANOTIFY_INFO_HDR_LEN \
+#define FANOTIFY_FID_INFO_HDR_LEN \
 	(sizeof(struct fanotify_event_info_fid) + sizeof(struct file_handle))
 
 static int fanotify_fid_info_len(int fh_len, int name_len)
@@ -114,10 +114,11 @@ static int fanotify_fid_info_len(int fh_len, int name_len)
 	if (name_len)
 		info_len += name_len + 1;
 
-	return roundup(FANOTIFY_INFO_HDR_LEN + info_len, FANOTIFY_EVENT_ALIGN);
+	return roundup(FANOTIFY_FID_INFO_HDR_LEN + info_len,
+		       FANOTIFY_EVENT_ALIGN);
 }
 
-static int fanotify_event_info_len(unsigned int fid_mode,
+static int fanotify_event_info_len(unsigned int info_mode,
 				   struct fanotify_event *event)
 {
 	struct fanotify_info *info = fanotify_event_info(event);
@@ -128,7 +129,8 @@ static int fanotify_event_info_len(unsigned int fid_mode,
 
 	if (dir_fh_len) {
 		info_len += fanotify_fid_info_len(dir_fh_len, info->name_len);
-	} else if ((fid_mode & FAN_REPORT_NAME) && (event->mask & FAN_ONDIR)) {
+	} else if ((info_mode & FAN_REPORT_NAME) &&
+		   (event->mask & FAN_ONDIR)) {
 		/*
 		 * With group flag FAN_REPORT_NAME, if name was not recorded in
 		 * event on a directory, we will report the name ".".
@@ -303,9 +305,10 @@ static int process_access_response(struct fsnotify_group *group,
 	return -ENOENT;
 }
 
-static int copy_info_to_user(__kernel_fsid_t *fsid, struct fanotify_fh *fh,
-			     int info_type, const char *name, size_t name_len,
-			     char __user *buf, size_t count)
+static int copy_fid_info_to_user(__kernel_fsid_t *fsid, struct fanotify_fh *fh,
+				 int info_type, const char *name,
+				 size_t name_len,
+				 char __user *buf, size_t count)
 {
 	struct fanotify_event_info_fid info = { };
 	struct file_handle handle = { };
@@ -463,10 +466,11 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	if (fanotify_event_dir_fh_len(event)) {
 		info_type = info->name_len ? FAN_EVENT_INFO_TYPE_DFID_NAME :
 					     FAN_EVENT_INFO_TYPE_DFID;
-		ret = copy_info_to_user(fanotify_event_fsid(event),
-					fanotify_info_dir_fh(info),
-					info_type, fanotify_info_name(info),
-					info->name_len, buf, count);
+		ret = copy_fid_info_to_user(fanotify_event_fsid(event),
+					    fanotify_info_dir_fh(info),
+					    info_type,
+					    fanotify_info_name(info),
+					    info->name_len, buf, count);
 		if (ret < 0)
 			goto out_close_fd;
 
@@ -512,9 +516,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 			info_type = FAN_EVENT_INFO_TYPE_FID;
 		}
 
-		ret = copy_info_to_user(fanotify_event_fsid(event),
-					fanotify_event_object_fh(event),
-					info_type, dot, dot_len, buf, count);
+		ret = copy_fid_info_to_user(fanotify_event_fsid(event),
+					    fanotify_event_object_fh(event),
+					    info_type, dot, dot_len,
+					    buf, count);
 		if (ret < 0)
 			goto out_close_fd;
 
-- 
2.43.0



