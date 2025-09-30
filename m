Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAA6173;
	Tue, 30 Sep 2025 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244577; cv=none; b=WGKIvcntDQMMy8tKOYm/Uf6sN6W9Zu58N9kWQK50sGpvzRkCk3CrP8LTNu48bufo3VkujuTFMjSmrOxv4FNTJHjUUZKHJeLBq9OB1EZ9N1BNjx9ZTXQ2l9Z/8IwVC7XP6hXv5wI5VPgOln6IviArAs8YIEHiDEkOup8lJRi+dYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244577; c=relaxed/simple;
	bh=YuYC9inX43D78xW0nbaRkukcRc4krcV4+ZIoKnj67mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbJzg2NWd5O3WkdbIbfqx+zJmXW+GyiC+YHLq74uL+D9T4uU/unzKxaW3XLJjCpJR8kvGCFSsYiVwTbfI6mTuYk4+d9cWq6YDQepkMqdHrXuZ8aPguYmiUZ0ceuFDfeh8YV/UgFyUBGZ+mKYn8dLiMRJIVMwSKKS4OvcEQl9CxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haAHDsEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haAHDsEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77EAC4CEF0;
	Tue, 30 Sep 2025 15:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244577;
	bh=YuYC9inX43D78xW0nbaRkukcRc4krcV4+ZIoKnj67mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haAHDsEn1kc8YV7VjcvAT5zju+ju9cN4FqOf7+93WnzBE+48xx4d0FaajLDbKOFGw
	 KwhkAMaDPWkHpMxB0YFLeo9dBdm4JgVzbOOIXvYzB5Bgg+xKqbP4ovYf9QoZWCPugs
	 3yjxtrUG4GnPwCvnr6zLFyrJ/xPSRGmJROISraBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xing Guo <higuoxing@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 048/143] selftests/fs/mount-notify: Fix compilation failure.
Date: Tue, 30 Sep 2025 16:46:12 +0200
Message-ID: <20250930143833.148586862@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xing Guo <higuoxing@gmail.com>

[ Upstream commit e51bd0e595476c1527bb0b4def095a6fd16b2563 ]

Commit c6d9775c2066 ("selftests/fs/mount-notify: build with tools include
dir") introduces the struct __kernel_fsid_t to decouple dependency with
headers_install.  The commit forgets to define a macro for __kernel_fsid_t
and it will cause type re-definition issue.

Signed-off-by: Xing Guo <higuoxing@gmail.com>
Link: https://lore.kernel.org/20250813031647.96411-1-higuoxing@gmail.com
Acked-by: Amir Goldstein <amir73il@gmail.com>
Closes: https://lore.kernel.org/oe-lkp/202508110628.65069d92-lkp@intel.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mount-notify/mount-notify_test.c           | 17 ++++++++---------
 .../mount-notify/mount-notify_test_ns.c        | 18 ++++++++----------
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/filesystems/mount-notify/mount-notify_test.c b/tools/testing/selftests/filesystems/mount-notify/mount-notify_test.c
index 63ce708d93ed0..e4b7c2b457ee7 100644
--- a/tools/testing/selftests/filesystems/mount-notify/mount-notify_test.c
+++ b/tools/testing/selftests/filesystems/mount-notify/mount-notify_test.c
@@ -2,6 +2,13 @@
 // Copyright (c) 2025 Miklos Szeredi <miklos@szeredi.hu>
 
 #define _GNU_SOURCE
+
+// Needed for linux/fanotify.h
+typedef struct {
+	int	val[2];
+} __kernel_fsid_t;
+#define __kernel_fsid_t __kernel_fsid_t
+
 #include <fcntl.h>
 #include <sched.h>
 #include <stdio.h>
@@ -10,20 +17,12 @@
 #include <sys/mount.h>
 #include <unistd.h>
 #include <sys/syscall.h>
+#include <sys/fanotify.h>
 
 #include "../../kselftest_harness.h"
 #include "../statmount/statmount.h"
 #include "../utils.h"
 
-// Needed for linux/fanotify.h
-#ifndef __kernel_fsid_t
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-#endif
-
-#include <sys/fanotify.h>
-
 static const char root_mntpoint_templ[] = "/tmp/mount-notify_test_root.XXXXXX";
 
 static const int mark_cmds[] = {
diff --git a/tools/testing/selftests/filesystems/mount-notify/mount-notify_test_ns.c b/tools/testing/selftests/filesystems/mount-notify/mount-notify_test_ns.c
index 090a5ca65004a..9f57ca46e3afa 100644
--- a/tools/testing/selftests/filesystems/mount-notify/mount-notify_test_ns.c
+++ b/tools/testing/selftests/filesystems/mount-notify/mount-notify_test_ns.c
@@ -2,6 +2,13 @@
 // Copyright (c) 2025 Miklos Szeredi <miklos@szeredi.hu>
 
 #define _GNU_SOURCE
+
+// Needed for linux/fanotify.h
+typedef struct {
+	int	val[2];
+} __kernel_fsid_t;
+#define __kernel_fsid_t __kernel_fsid_t
+
 #include <fcntl.h>
 #include <sched.h>
 #include <stdio.h>
@@ -10,21 +17,12 @@
 #include <sys/mount.h>
 #include <unistd.h>
 #include <sys/syscall.h>
+#include <sys/fanotify.h>
 
 #include "../../kselftest_harness.h"
-#include "../../pidfd/pidfd.h"
 #include "../statmount/statmount.h"
 #include "../utils.h"
 
-// Needed for linux/fanotify.h
-#ifndef __kernel_fsid_t
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-#endif
-
-#include <sys/fanotify.h>
-
 static const char root_mntpoint_templ[] = "/tmp/mount-notify_test_root.XXXXXX";
 
 static const int mark_types[] = {
-- 
2.51.0



