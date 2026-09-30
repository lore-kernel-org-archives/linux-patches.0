Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5D33E2ADB;
	Wed, 30 Sep 2026 19:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796591; cv=none; b=s4Zb1xmdKSSa1oj/xdWFCXgQTW9cAfrj3T6uZheXEFargqc8+AmxUsE9BhjK9kQYeKlox6lsj/iBJNQit+7O6UMdymfdhMdb53IlbyseSxM3aeJP8pt32vUiL8b0t3Nl64VfNCiE3XD+QhUW7OIBJYVxN3KLzJA985jfY0M0Vjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796591; c=relaxed/simple;
	bh=i85iMLIxpsZGMMN2CkyvyuUbHR2zM2K2ptjIrvwJdAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pSyfwEp+YeDBUh3r5hxudKM6zDjDYGzavjP0zCiaO+phYhxmWhP2q1Wr4ggv4b9uuREi2/a3JJqS//+hzOH5hSlgbP5QKcQrFSVjSVx8g5+OJO/vn62qg6SHcidkmE+e8Oa4K3CFKUbDgJTNjt07sXxXL+sgKu7qN1Aq9uS69dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpeXKcYf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpeXKcYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668CC1F000FF;
	Wed, 30 Sep 2026 19:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796589;
	bh=Ni0/7ZMbA/1PnUyOxIrli6N3lZz/VJzcUavvFkuIJRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpeXKcYfqR5wsrbAO5Zi8fXz23LZn/bixJH54+4/KDS1vJU5okhymq1TW//SgRWKD
	 sZqvdBY8qKRs+QZRV3hnU9QAXrJWsFrxnCkWY//3krl0o2cMOAWmRsCn2PrMrrxkrG
	 lf9br7xFOGKzsO9KwcFvvw6w4vy6/tb2++ovefAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0950/1193] selftests/landlock: Add layout1.refer_mount_root
Date: Wed, 30 Sep 2026 17:27:14 +0200
Message-ID: <20260930152455.346841584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 0055f53aac80fd938bf7cdfad7ad414ca6c0e198 ]

Add tests to check error codes when linking or renaming a mount root
directory.  This previously triggered a kernel warning, but it is fixed
with the previous commit.

Cc: Günther Noack <gnoack@google.com>
Cc: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/20240516181935.1645983-3-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
[mic: Backport: adapt to the older selftest header layout]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c |   50 +++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -23,6 +23,12 @@
 #include <sys/vfs.h>
 #include <unistd.h>
 
+/*
+ * Intentionally included last to work around header conflict.
+ * See https://sourceware.org/glibc/wiki/Synchronizing_Headers.
+ */
+#include <linux/mount.h>
+
 #include "common.h"
 
 #ifndef renameat2
@@ -34,6 +40,13 @@ int renameat2(int olddirfd, const char *
 }
 #endif
 
+#ifndef open_tree
+int open_tree(int dfd, const char *filename, unsigned int flags)
+{
+	return syscall(__NR_open_tree, dfd, filename, flags);
+}
+#endif
+
 #ifndef RENAME_EXCHANGE
 #define RENAME_EXCHANGE (1 << 1)
 #endif
@@ -2486,6 +2499,43 @@ TEST_F_FORK(layout1, refer_denied_by_def
 				layer_dir_s1d1_refer);
 }
 
+/*
+ * Tests walking through a denied root mount.
+ */
+TEST_F_FORK(layout1, refer_mount_root_deny)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_fs = LANDLOCK_ACCESS_FS_MAKE_DIR,
+	};
+	int root_fd, ruleset_fd;
+
+	/* Creates a mount object from a non-mount point. */
+	set_cap(_metadata, CAP_SYS_ADMIN);
+	root_fd =
+		open_tree(AT_FDCWD, dir_s1d1,
+			  AT_EMPTY_PATH | OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	clear_cap(_metadata, CAP_SYS_ADMIN);
+	ASSERT_LE(0, root_fd);
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0));
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	/* Link denied by Landlock: EACCES. */
+	EXPECT_EQ(-1, linkat(root_fd, ".", root_fd, "does_not_exist", 0));
+	EXPECT_EQ(EACCES, errno);
+
+	/* renameat2() always returns EBUSY. */
+	EXPECT_EQ(-1, renameat2(root_fd, ".", root_fd, "does_not_exist", 0));
+	EXPECT_EQ(EBUSY, errno);
+
+	EXPECT_EQ(0, close(root_fd));
+}
+
 TEST_F_FORK(layout1, reparent_link)
 {
 	const struct rule layer1[] = {


