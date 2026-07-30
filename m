Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781C9445AE0;
	Thu, 30 Jul 2026 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425541; cv=none; b=XSUkCWODIdytHmmYlHXN9+iOZrNyXE3PoeZ9JpEMsehs2Zl87XyQT4+r4HB+5sxLgK2Nuo86zh2ITORdINr3gsAGGOt4u5E9nvZXGCc0EWyYFHPdqYoDvii4TJEUVGBc0JSe1jy35r5FV7KWRtDUuywyGIiokfcCJY/mjS0B2Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425541; c=relaxed/simple;
	bh=uJkI/dOwq94LRFlOm5ubVQcGY0Tp2vtJ/1+jrnDD4H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb/T8UZ4uRyI2r5+EcoWsbky2fC0zH/EAPFJfn7dAdQfNg6GJJggH1wAlj7n+Ar1TXarcBd8anO8qlVEJS9CMaKXQUmECTFGr4YYNapbfe/TJ3dY7zeNOa6Y4VJBtJWBIWmU81jaBD+xUDqD5eKXjvBEIlFJhs1GQr+6h4cUbGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jH8+qoOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jH8+qoOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09A21F000E9;
	Thu, 30 Jul 2026 15:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425540;
	bh=ilYvOtJNlgeV1BVHdbF91IIXhxj+5VIWq+5Q2Y84BLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jH8+qoOWBCgalL2L8cIx5+zY7W1x9P7W1yr3ZfkWxkwgErSiy3TwFrMKJopyOKg7k
	 Ryb5Bw35J74edAEt6UA+v4PpZ7NYRSEWD1JJI6sjFliCKuRmFvZA2zWJRy84fHdcE+
	 40tQ8Die6S//V9/TsCuslXJdCIi5dC8c0WMelY68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/602] smb: move some duplicate definitions to common/cifsglob.h
Date: Thu, 30 Jul 2026 16:08:18 +0200
Message-ID: <20260730141438.219640334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit d877470b59910b5c50383d634dda3782386bba51 ]

In order to maintain the code more easily, move duplicate definitions to
new common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: aa5d8f3f96aa ("ksmbd: pin conn during async oplock break notification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h   | 19 +------------------
 fs/smb/common/cifsglob.h   | 30 ++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h | 14 +-------------
 3 files changed, 32 insertions(+), 31 deletions(-)
 create mode 100644 fs/smb/common/cifsglob.h

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index dcfadbc20723f0..c054ee44269416 100644
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
@@ -986,8 +981,6 @@ compare_mid(__u16 mid, const struct smb_hdr *smb)
 #define CIFS_MAX_RFC1002_WSIZE ((1<<17) - 1 - sizeof(WRITE_REQ) + 4)
 #define CIFS_MAX_RFC1002_RSIZE ((1<<17) - 1 - sizeof(READ_RSP) + 4)
 
-#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
-
 /*
  * Windows only supports a max of 60kb reads and 65535 byte writes. Default to
  * those values when posix extensions aren't in force. In actuality here, we
@@ -2094,30 +2087,20 @@ extern mempool_t cifs_io_request_pool;
 extern mempool_t cifs_io_subrequest_pool;
 
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
index a3d8a905b07e07..a353e187dfd7ad 100644
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



