Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216660;
	b=vKBbxgL2kUTAbQL0dzUMil8uWVpUz1Urp6vDxOAkk4Van2v8cJG/eYoBi/QK8WwPR1oG
	 Jui5VexGSD5tOD2Ng6FM3aZRinII2ZP6nGZd192mW3Gbhk4j8Rrf5B0rmqz4Twh4ytxzw
	 i7eAgF1htKQDdl0wR1mLd8V+8L6VxbYPgJ8AFREZWfLR3c/Txzwv6XasPQobPCa5p19dx
	 kw4bNhW8LrQRVO5duNyz3igrFDlG1eYbVCEmXE0HUk9sN2yeUnGX+H4xH9aQYPoXzpKzk
	 59VZWBTgfGzNAc0IJpwxbzhnzx9hALLlTyaf7cxFcTzCXc4If+PaOV3k2rc5FwRlpXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vVSNwhfV41Inxq0EXc1f+U/68Uqsvc5CaeE8sFVNB3U=;
	b=hczqqt2yPTJD9PXmpxmlDxuMeBKXxhfK/u0gMFqt9kIoOvT8Qm7rAeFlSnvcIpIVeZiJ
	 +6RIG4lKz6+SLGAjmdaocxcwDSvm6qVjLGi6dUnm1E4JoUW0EEyZpEUExUocKqnV1lM3Y
	 yKgouOEyXG/VXNfs3bxGX7QtAFUEUkqFCn3RCIx7eZ4YB44VnoZA318k12ndompseR2SH
	 ROoTxiSfx7IC8RwWVtu9cMeFoxNYJTF/pdoiNN/x1fGmSmBzbnMAr/9a8Dd0Pf57928MX
	 8sa21Lu3tFjm74K1q5YkpYKStF0PWALGOlyi5r/d1nfJDaL3SJX2i74F8CpVLRWN9Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ajtwce6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14787606A31E;
	Wed, 28 Oct 2026 19:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ajtwce6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8B71F01825;
	Wed, 28 Oct 2026 19:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216659;
	bh=vVSNwhfV41Inxq0EXc1f+U/68Uqsvc5CaeE8sFVNB3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ajtwce6uRkTtePqQcLsDE3pANX4pdVXpzyWIyYwIQFYYFx2p1wAshCHwtsVfJTVn9
	 ssDl4UYgm8YM1SCAp6s0wG8hWhhIiXEBxHhe7EkE95aJgpLcGE2/jWrIhMP55h3qqx
	 6e9sNarzUol9zJz4dW47LdUO7oEcPA1PvFRXeM38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1633/1887] cgroup/cpuset: introduce cpuset-v1.c
Date: Wed, 28 Oct 2026 18:02:09 +0100
Message-ID: <20261028170536.628209933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 563492fd3ca26..bf4a79088f500 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5293,6 +5293,8 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 F:	Documentation/admin-guide/cgroup-v1/cpusets.rst
 F:	include/linux/cpuset.h
+F:	kernel/cgroup/cpuset-internal.h
+F:	kernel/cgroup/cpuset-v1.c
 F:	kernel/cgroup/cpuset.c
 
 CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
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



