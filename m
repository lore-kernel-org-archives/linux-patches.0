Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F2F79955;
	Mon,  8 Apr 2024 13:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584579; cv=none; b=TeJ/04qXabxZhgJrybJhelrrwKcvJIY0lKyy06NSNg3YA2k2ziJRuyt1jypOZ/SK3yUmtXqAnjELg2SZNP6v89V5V7+qeHPxHWat6L4Ne5mOmqqT4ib9a11Iq5HKgs3uVXJYl/sHVRul9Vh/3I4L+4GMYQbhsJMNj8qlSHyIJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584579; c=relaxed/simple;
	bh=6qUhdZ9AnB/Gs6tnVNw1n5e5cR6FnFlGeRMzy38ShnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INVUtpNika5LTKTQJTSeRQJjEGHElALFf9cM8rLpNWmsWN8aJi7PxmNvgaxSWnXuTfD6D0d26+tf27Uqf7Kc4bKVwifbQrrd5DkHXNLFTLITgQizvBIl9tIhOD5Qt+Ygko33ZvRZEpGcDF9l7oA7FOQUfmDuru/VeRMu1TMepnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAsnVBSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAsnVBSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F943C433F1;
	Mon,  8 Apr 2024 13:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584579;
	bh=6qUhdZ9AnB/Gs6tnVNw1n5e5cR6FnFlGeRMzy38ShnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAsnVBSfjaVTCLXlzj99EI/ecgW93xNM7A62DbmZi0g1fjwldVbKoWaUWOio1+Lr0
	 xcAMG9HbkbYqfEAn02x0ABxNG0C9zc/GnhYWVezvE9Hr3Sz+9uhDH/GbtDFaUVl8hy
	 YjB+Ofkc2oy4wcvjxcStHUOrReSqkc2j/e8xAmgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bobrowski <repnop@google.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 456/690] fs/notify: constify path
Date: Mon,  8 Apr 2024 14:55:22 +0200
Message-ID: <20240408125416.153679277@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit d5bf88895f24686641c39420ee6df716dc1d95d8 ]

Reviewed-by: Matthew Bobrowski <repnop@google.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c      | 2 +-
 fs/notify/fanotify/fanotify.h      | 2 +-
 fs/notify/fanotify/fanotify_user.c | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index cd7d09a569fff..a2a15bc4df280 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -18,7 +18,7 @@
 
 #include "fanotify.h"
 
-static bool fanotify_path_equal(struct path *p1, struct path *p2)
+static bool fanotify_path_equal(const struct path *p1, const struct path *p2)
 {
 	return p1->mnt == p2->mnt && p1->dentry == p2->dentry;
 }
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 1d9f11255c64f..bf6d4d38afa04 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -458,7 +458,7 @@ static inline bool fanotify_event_has_path(struct fanotify_event *event)
 		event->type == FANOTIFY_EVENT_TYPE_PATH_PERM;
 }
 
-static inline struct path *fanotify_event_path(struct fanotify_event *event)
+static inline const struct path *fanotify_event_path(struct fanotify_event *event)
 {
 	if (event->type == FANOTIFY_EVENT_TYPE_PATH)
 		return &FANOTIFY_PE(event)->path;
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 879cd65b15187..d93418f213863 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -245,7 +245,7 @@ static struct fanotify_event *get_one_event(struct fsnotify_group *group,
 	return event;
 }
 
-static int create_fd(struct fsnotify_group *group, struct path *path,
+static int create_fd(struct fsnotify_group *group, const struct path *path,
 		     struct file **file)
 {
 	int client_fd;
@@ -615,7 +615,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 				  char __user *buf, size_t count)
 {
 	struct fanotify_event_metadata metadata;
-	struct path *path = fanotify_event_path(event);
+	const struct path *path = fanotify_event_path(event);
 	struct fanotify_info *info = fanotify_event_info(event);
 	unsigned int info_mode = FAN_GROUP_FLAG(group, FANOTIFY_INFO_MODES);
 	unsigned int pidfd_mode = info_mode & FAN_REPORT_PIDFD;
@@ -1549,7 +1549,7 @@ static int fanotify_test_fid(struct dentry *dentry)
 }
 
 static int fanotify_events_supported(struct fsnotify_group *group,
-				     struct path *path, __u64 mask,
+				     const struct path *path, __u64 mask,
 				     unsigned int flags)
 {
 	unsigned int mark_type = flags & FANOTIFY_MARK_TYPE_BITS;
-- 
2.43.0



