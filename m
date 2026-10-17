Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DDB387373;
	Sat, 17 Oct 2026 18:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260282; cv=none; b=I+3tZYO/kSjf1lkxbJXlqyz7nzzn+/GaSAAb3nsB4JHRkodfPtT7DYq3EWUhQmkygVdTEaMh8g4/oOjkizgpsG5Fy0NxL4wSM9QW7DrsYMJwCz7a5fdnSj+OVCp30CvhOzhkMvx0mfRBv22Rru0bT3U1AF22fonGgbtt6nCQ4Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260282; c=relaxed/simple;
	bh=9SnjHXa944qqL9mHbJgHqkwKpNQhcYIWcajDRAToSH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxP+ubbYRhId0JkE7yYVfpYRm+7gJr0aQFMI4+QTpwftzSlUn1RYKFLCdiBdkszlmoaU+XO8au/gnkrY/uuxCmVYZF4YgXa4ym6lKiltehqI+ikSIDxbxbeVa4gI0qJ2xLpV8gcdq+KUvh95Lkhl4JtAYxj0++d/PC54VDc04h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ln4lqys3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ln4lqys3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2A61F000C4;
	Sat, 17 Oct 2026 18:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260281;
	bh=rJnnT+iYBt2MBy6cSe9OfhRL3Dz0sB5TBSztKApgDQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ln4lqys3GGbo8dGo+U3niYX+4yZfTCsQB77xud8kaXloCwuuvGlC5YoUQ72N3xh24
	 d2XHkM9QvB0flLb9Q0xVlSrU9FKz2DDbi5MzYZ0gUaDP/DNGSTn9cq4gT+RXdFGxxF
	 7KSgrdmvxi1r19jwdSU8bNfquVpWdnW0aff8MZgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1491/1674] cgroup/cpuset: introduce cpuset-v1.c
Date: Sat, 17 Oct 2026 18:02:43 +0200
Message-ID: <20261017160509.414216417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 71e934a80863c2a9f4d27ee3360dc17e0a609aa6 ]

This patch introduces the cgroup/cpuset-v1.c source file which will be
used for all legacy (cgroup v1) cpuset cgroup code. It also introduces
cgroup/cpuset-internal.h to keep declarations shared between
cgroup/cpuset.c and cpuset/cpuset-v1.c.

As of now, let's compile it if CONFIG_CPUSET is set. Later on it can be
switched to use a separate config option, so that the legacy code won't be
compiled if not required.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 95220e1f18f6 ("cgroup/cpuset: Make nr_deadline_tasks an atomic_t")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                     | 2 ++
 kernel/cgroup/Makefile          | 2 +-
 kernel/cgroup/cpuset-internal.h | 6 ++++++
 kernel/cgroup/cpuset-v1.c       | 3 +++
 4 files changed, 12 insertions(+), 1 deletion(-)
 create mode 100644 kernel/cgroup/cpuset-internal.h
 create mode 100644 kernel/cgroup/cpuset-v1.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 199a825bd21c8..48f89f4638fc8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5280,6 +5280,8 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 F:	Documentation/admin-guide/cgroup-v1/cpusets.rst
 F:	include/linux/cpuset.h
+F:	kernel/cgroup/cpuset-internal.h
+F:	kernel/cgroup/cpuset-v1.c
 F:	kernel/cgroup/cpuset.c
 F:	tools/testing/selftests/cgroup/test_cpuset.c
 F:	tools/testing/selftests/cgroup/test_cpuset_prs.sh
diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index 12f8457ad1f90..005ac4c675cb1 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -4,6 +4,6 @@ obj-y := cgroup.o rstat.o namespace.o cgroup-v1.o freezer.o
 obj-$(CONFIG_CGROUP_FREEZER) += legacy_freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
 obj-$(CONFIG_CGROUP_RDMA) += rdma.o
-obj-$(CONFIG_CPUSETS) += cpuset.o
+obj-$(CONFIG_CPUSETS) += cpuset.o cpuset-v1.o
 obj-$(CONFIG_CGROUP_MISC) += misc.o
 obj-$(CONFIG_CGROUP_DEBUG) += debug.o
diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
new file mode 100644
index 0000000000000..034de3cbf3add
--- /dev/null
+++ b/kernel/cgroup/cpuset-internal.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __CPUSET_INTERNAL_H
+#define __CPUSET_INTERNAL_H
+
+#endif /* __CPUSET_INTERNAL_H */
diff --git a/kernel/cgroup/cpuset-v1.c b/kernel/cgroup/cpuset-v1.c
new file mode 100644
index 0000000000000..bdec4b1969867
--- /dev/null
+++ b/kernel/cgroup/cpuset-v1.c
@@ -0,0 +1,3 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cpuset-internal.h"
-- 
2.53.0



