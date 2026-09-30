Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D5A4E4306;
	Wed, 30 Sep 2026 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786244; cv=none; b=hbFBd1ZiaP099moB7TEdBgL+KV0JkNrWCL+HIl+ll+vKwQAIGfWPMHuZusNV3OIRw3W9asTt9BQksyKMbt90Dn10rkv8KCFpmKcx1qCj1D0xu0QtzBWpHGzz7yHUdC2tuDsjTrJJ4fo0zk/2na/+SAiSGAqfKZoVcrKOnEsqPYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786244; c=relaxed/simple;
	bh=8SIgM9QCQ6RR9U83ROifbmS0vSu8l91ct3Hcy7BjwL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VeoDQ9x3p983kfQFPIEB/Ffwp2yKoIWg6XXNHkRowbUOhpEa7j8chhKvlDDTt8sjNhVtBk+FP0lOgIEqhPV3DbukDvQhIIytyYD4NWF0y2y1dEk5Oz0V7tZpWtFDeBYA9kRwb0eYB7Movuc+4xOZxN2Y9ZbBEaTTZXqGW6nfgqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phwhuPw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phwhuPw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AD41F000FF;
	Wed, 30 Sep 2026 16:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786242;
	bh=QOvgHHHKJUb5zqL+6Dqx5zOGrUOgmEioJr3HNRjg/9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phwhuPw+s8IEQidSy7NpPd/Vy4n9nw+k20wNXF3y6CqePLaf2+9uAqPh4+T8+OI8y
	 4vEBd/QnSm14Ex0+bAy6c22QGSyGRbPLra3PnsXPTvGYCHIokwMsZHPAzK02e1drmi
	 vFYjIbjk7CocbtqBtewX+EHJlSTwUpCatP/Ta54g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 794/982] selftests/landlock: Add layout1.refer_mount_root
Date: Wed, 30 Sep 2026 17:25:30 +0200
Message-ID: <20260930152433.810592124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -21,6 +21,12 @@
 #include <sys/sysmacros.h>
 #include <unistd.h>
 
+/*
+ * Intentionally included last to work around header conflict.
+ * See https://sourceware.org/glibc/wiki/Synchronizing_Headers.
+ */
+#include <linux/mount.h>
+
 #include "common.h"
 
 #ifndef renameat2
@@ -32,6 +38,13 @@ int renameat2(int olddirfd, const char *
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
@@ -2400,6 +2413,43 @@ TEST_F_FORK(layout1, refer_denied_by_def
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


