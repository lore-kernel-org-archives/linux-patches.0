Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [84.16.66.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37D359E34E
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657274; cv=none; b=VvyARFVsgwQV/xFppDVSHOA7O2xfVe86bMRw5Kz0hXHUoiFOnsMf/AP7oyXqfjsMob1bZCrk4hq8yacPgBQ4YHAmgFOv3DBGe0n+8PsDdgxslbAeoQ+OI+I422UUJyN4EKWUuhofxezb0W0slKx6uXf59E88iQ5ws0i14YYBI4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657274; c=relaxed/simple;
	bh=0m7Y88fV0dWH85L8Qp0r+3GXJ+3nTEkVngv40ATPdt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J4q3SHKF1C531eKEU0M7LC+U1lUN+6l/vyjAOG+YWMudCDtSJzwQzO/YjWi900uBbYSkNXXSdv2z92AbdT1jVYASSa+0wb57uAu/8sUEEp2q44rd4ve740Vw/qADx+0VMJE/N6ItkGrWRohJl6ygIpblfysckrgXBnJDvpoiYq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=e3cHohy7; arc=none smtp.client-ip=84.16.66.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="e3cHohy7"
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hlzTf0pjkz3yj;
	Thu, 17 Sep 2026 17:00:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1789657253;
	bh=71BgvP1k8eHPwNTYeZZj+YyDryF7umHQRV/B+HsUXbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3cHohy7y+AVE+AQ851nf0CkPVFKyGR43BIfJ4LroYgs8M78mHxtfQOTV1COwrI4A
	 vjWApW6KQxcfX14miR4jjj9vhA9x2woOlIpYdVGHxQ+7L+eFeUJI34GZv9SQPRHVLy
	 j+O1bRdA1Kc47OXK4mLxz0Knw0k44dgylGyFfus0=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4hlzTd251Nzcng;
	Thu, 17 Sep 2026 17:00:53 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	syzbot+bf4903dc7e12b18ebc87@syzkaller.appspotmail.com
Subject: [PATCH 6.1.y] selftests/landlock: Add layout1.refer_mount_root
Date: Thu, 17 Sep 2026 17:00:49 +0200
Message-ID: <661e8a7821258da80d7ab0e2c2d7e19b07ccfae0.1789655724.git.mic@digikod.net>
In-Reply-To: <20240619125600.199822604@linuxfoundation.org>
References: <20240619125600.199822604@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

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
---
 tools/testing/selftests/landlock/fs_test.c | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 864309ebb0b4..b37c694d5c10 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -10,6 +10,7 @@
 #define _GNU_SOURCE
 #include <fcntl.h>
 #include <linux/landlock.h>
+#include <linux/mount.h>
 #include <sched.h>
 #include <stdio.h>
 #include <string.h>
@@ -32,6 +33,13 @@ int renameat2(int olddirfd, const char *oldpath, int newdirfd,
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
@@ -2178,6 +2186,43 @@ TEST_F_FORK(layout1, refer_denied_by_default4)
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
