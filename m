Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B8835201C;
	Tue, 21 Jul 2026 20:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666815; cv=none; b=b7DAiLZ9TnlCeL3WNwFlh0JnN4yhKgqCHGomk9WzfoYhr628raT6q8UrJ1KyLQSbZZqBSwqscecgvLSiVlzcgvKwmVgBqnQDkW2VCq6FwpSuJ8XNqp2c5LXKm8UdPp0Ir2BsoHH5IIQe2NZJBwQwZsv0fdyPyI+Bop6hthUUpRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666815; c=relaxed/simple;
	bh=Gr3TfG1qxHXKVgrtqK4cChChbP8ZZTxvJU7aZQ6Oh+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRBr9d64N/VAKEQM/HE0bFhyN7HwV8OwerQB8D5HGp2odPkwpAAQ6598Fm0TJlpH50kXTI8ZkBd3ul6icUInPwBCBZHCekPWCuptx4t/rB6la31kA4DzEKNueOw2NVtPLq9w8wWgyXoR6lQP05eO5QpOQv+OurM9OzpvTNgHawY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZVVycCm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZVVycCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6C91F000E9;
	Tue, 21 Jul 2026 20:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666813;
	bh=WTqb2s/NpH7sc/b5OrqJnynOuKCvan7LkgHypMckiLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZVVycCmA2QNpFKMbqmEzo7OQw8PjH9zrrV8pbjrjNcFdy+eEHnK8LyHBX/AZpngs
	 KYo9xvp8DDRZ6IRbNmV4O2FmhSCVEc3fB0XsQFKNtvyyYixKWuZNY18XIqwG8Rec1P
	 ORYu5hIRDvV3ACPXVpfxg+FBexqN0lj+3KUvPYwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0823/1266] smb: move some duplicate definitions to common/cifsglob.h
Date: Tue, 21 Jul 2026 17:21:00 +0200
Message-ID: <20260721152500.273711610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit d877470b59910b5c50383d634dda3782386bba51 ]

In order to maintain the code more easily, move duplicate definitions to
new common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 38637163501f ("ksmbd: fix use-after-free of fp->owner.name in durable handle owner check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h   | 19 +------------------
 fs/smb/common/cifsglob.h   | 30 ++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h | 14 +-------------
 3 files changed, 32 insertions(+), 31 deletions(-)
 create mode 100644 fs/smb/common/cifsglob.h

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 8e85332cb7abcc..97f70d437a7eb1 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -25,6 +25,7 @@
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
 #include <uapi/linux/cifs/cifs_mount.h>
+#include "../common/cifsglob.h"
 #include "../common/smb2pdu.h"
 #include "smb2pdu.h"
 #include <linux/filelock.h>
@@ -669,12 +670,6 @@ get_rfc1002_length(void *buf)
 	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
 }
 
-static inline void
-inc_rfc1001_len(void *buf, int count)
-{
-	be32_add_cpu((__be32 *)buf, count);
-}
-
 struct TCP_Server_Info {
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
@@ -982,8 +977,6 @@ compare_mid(__u16 mid, const struct smb_hdr *smb)
 #define CIFS_MAX_RFC1002_WSIZE ((1<<17) - 1 - sizeof(WRITE_REQ) + 4)
 #define CIFS_MAX_RFC1002_RSIZE ((1<<17) - 1 - sizeof(READ_RSP) + 4)
 
-#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
-
 /*
  * Windows only supports a max of 60kb reads and 65535 byte writes. Default to
  * those values when posix extensions aren't in force. In actuality here, we
@@ -2131,30 +2124,20 @@ extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
 
 /* Operations for different SMB versions */
-#define SMB1_VERSION_STRING	"1.0"
-#define SMB20_VERSION_STRING    "2.0"
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 extern struct smb_version_operations smb1_operations;
 extern struct smb_version_values smb1_values;
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
 #endif /* CIFS_ALLOW_INSECURE_LEGACY */
-#define SMB21_VERSION_STRING	"2.1"
 extern struct smb_version_operations smb21_operations;
 extern struct smb_version_values smb21_values;
-#define SMBDEFAULT_VERSION_STRING "default"
 extern struct smb_version_values smbdefault_values;
-#define SMB3ANY_VERSION_STRING "3"
 extern struct smb_version_values smb3any_values;
-#define SMB30_VERSION_STRING	"3.0"
 extern struct smb_version_operations smb30_operations;
 extern struct smb_version_values smb30_values;
-#define SMB302_VERSION_STRING	"3.02"
-#define ALT_SMB302_VERSION_STRING "3.0.2"
 /*extern struct smb_version_operations smb302_operations;*/ /* not needed yet */
 extern struct smb_version_values smb302_values;
-#define SMB311_VERSION_STRING	"3.1.1"
-#define ALT_SMB311_VERSION_STRING "3.11"
 extern struct smb_version_operations smb311_operations;
 extern struct smb_version_values smb311_values;
 
diff --git a/fs/smb/common/cifsglob.h b/fs/smb/common/cifsglob.h
new file mode 100644
index 00000000000000..00fd215e3eb547
--- /dev/null
+++ b/fs/smb/common/cifsglob.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002,2008
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *              Jeremy Allison (jra@samba.org)
+ *
+ */
+#ifndef _COMMON_CIFS_GLOB_H
+#define _COMMON_CIFS_GLOB_H
+
+static inline void inc_rfc1001_len(void *buf, int count)
+{
+	be32_add_cpu((__be32 *)buf, count);
+}
+
+#define SMB1_VERSION_STRING	"1.0"
+#define SMB20_VERSION_STRING    "2.0"
+#define SMB21_VERSION_STRING	"2.1"
+#define SMBDEFAULT_VERSION_STRING "default"
+#define SMB3ANY_VERSION_STRING "3"
+#define SMB30_VERSION_STRING	"3.0"
+#define SMB302_VERSION_STRING	"3.02"
+#define ALT_SMB302_VERSION_STRING "3.0.2"
+#define SMB311_VERSION_STRING	"3.1.1"
+#define ALT_SMB311_VERSION_STRING "3.11"
+
+#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
+
+#endif	/* _COMMON_CIFS_GLOB_H */
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index bc832fa9a82c87..3f274af060dab9 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -10,6 +10,7 @@
 
 #include "glob.h"
 #include "nterr.h"
+#include "../common/cifsglob.h"
 #include "../common/smb2pdu.h"
 #include "smb2pdu.h"
 
@@ -26,16 +27,8 @@
 #define SMB311_PROT		6
 #define BAD_PROT		0xFFFF
 
-#define SMB1_VERSION_STRING	"1.0"
-#define SMB20_VERSION_STRING	"2.0"
-#define SMB21_VERSION_STRING	"2.1"
-#define SMB30_VERSION_STRING	"3.0"
-#define SMB302_VERSION_STRING	"3.02"
-#define SMB311_VERSION_STRING	"3.1.1"
-
 #define SMB_ECHO_INTERVAL	(60 * HZ)
 
-#define CIFS_DEFAULT_IOSIZE	(64 * 1024)
 #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
 
 #define MAX_STREAM_PROT_LEN	0x00FFFFFF
@@ -462,9 +455,4 @@ static inline unsigned int get_rfc1002_len(void *buf)
 {
 	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
 }
-
-static inline void inc_rfc1001_len(void *buf, int count)
-{
-	be32_add_cpu((__be32 *)buf, count);
-}
 #endif /* __SMB_COMMON_H__ */
-- 
2.53.0



