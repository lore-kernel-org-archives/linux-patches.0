Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585969;
	b=tmrvxs5XhGevLbS8k4PCCiME4pJMrL95kE0v1UcMM+jHc8F39w8JjkvhYkVLYWrTRC4X
	 OKn2SM70EfPTWDkQTxK+sNMSU7zZ8Kg9dkU0/jpazY0wc3Wm10NISeTYvDJlXRRtZ70Es
	 QqRuJq/sEKWVkYDpPeYqTW/bUdttU3IXH1DnUAhmQDE0l5ebXVkyq1XfdBKHPEKxLnuMk
	 CbE62akO7t7R35XH3peTrWwhFPYtWQhCSYFCPLrfrU5HGUdgOOpoDZ5GTajChHs/dSMSd
	 /hpLWYO/jIEVLTJV/fePwfrjhRGNjxyZ4Q88ZIKpLIWOYZ4SQ1DT1rgBZfIZvBNnrAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r5daKFsHFhuP2GoCzw6A0A0L58PGfCX4MVvmEjkFZck=;
	b=RvMueeXKdE+UpzbRXFEybH8gnL7f5+Aad0rXwfCWMMO7Pq21GxorBWE85c9FyhhkIG3l
	 iU/mM082UjFxDrg8UqkCVfclH/PJzn5hQik4piyD392OZlnTswpA7ivlmWeRicjZfiqGz
	 iTimx1wLZ0P5gS6QdJj6ZhGGGcbELxlmuuUeQUgDGmEONcpPcJ8eZKDQrkGomOtiuPL4X
	 fqQUyl2NV2fNWGTDBKu3CNiiuC3FKTDVFeAdg4OWx147dnoSlrLjjHg+Dkrn6SWqkgJSM
	 dmkCxL6G+MbZ/Ng8y0ejEWHfzCKMECFbLX8FNt5vzKI5oGbtCajKTkTXZRDmERxZ0GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmW+crxz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9561E6072306;
	Fri, 13 Nov 2026 16:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmW+crxz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA561F000C6;
	Fri, 13 Nov 2026 16:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585969;
	bh=r5daKFsHFhuP2GoCzw6A0A0L58PGfCX4MVvmEjkFZck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmW+crxzUg71ljhDZLzjFwvhh5rzjiRgTUMyLxsPoazd1s2XFCh87XnSzbv6cDAAj
	 QnK+ejnCiQEYAQP64Hbx1e8EJUi7IRriR/EXXMqJm7ckjXZkhF8o1PIZM9v8FWqUJx
	 ax1MJT1bCBjDU9RpBiZcLHBMcZ6Mi4wQoJF9XfxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/686] smb: move list of FileSystemAttributes to common/fscc.h
Date: Fri, 13 Nov 2026 10:42:31 -0500
Message-ID: <20261113153821.536724117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 84d8d4cf8873b4a9da0d76e9ba9d94ec88311cfd ]

These definitions are exactly the same on both client and server,
so move them to new common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: f8171804a39e ("smb: client: fix OOB read of the resume name sent in TRANS2_FIND_NEXT2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h   |  1 +
 fs/smb/client/cifspdu.h    | 27 ------------------------
 fs/smb/common/fscc.h       | 42 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h | 28 +------------------------
 4 files changed, 44 insertions(+), 54 deletions(-)
 create mode 100644 fs/smb/common/fscc.h

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index d529446e4984b..2d5a4a26c931e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -28,6 +28,7 @@
 #include <uapi/linux/cifs/cifs_mount.h>
 #include "../common/cifsglob.h"
 #include "../common/smb2pdu.h"
+#include "../common/fscc.h"
 #include "smb2pdu.h"
 #include <linux/filelock.h>
 
diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 212cd57357ce2..3ea8aa2a8d2db 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2100,33 +2100,6 @@ typedef struct {
 /* minimum includes first three fields, and empty FS Name */
 #define MIN_FS_ATTR_INFO_SIZE 12
 
-
-/* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
-#define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
-#define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
-#define FILE_SUPPORT_INTEGRITY_STREAMS	0x04000000
-#define FILE_SUPPORTS_USN_JOURNAL	0x02000000
-#define FILE_SUPPORTS_OPEN_BY_FILE_ID	0x01000000
-#define FILE_SUPPORTS_EXTENDED_ATTRIBUTES 0x00800000
-#define FILE_SUPPORTS_HARD_LINKS	0x00400000
-#define FILE_SUPPORTS_TRANSACTIONS	0x00200000
-#define FILE_SEQUENTIAL_WRITE_ONCE	0x00100000
-#define FILE_READ_ONLY_VOLUME		0x00080000
-#define FILE_NAMED_STREAMS		0x00040000
-#define FILE_SUPPORTS_ENCRYPTION	0x00020000
-#define FILE_SUPPORTS_OBJECT_IDS	0x00010000
-#define FILE_VOLUME_IS_COMPRESSED	0x00008000
-#define FILE_SUPPORTS_POSIX_UNLINK_RENAME 0x00000400
-#define FILE_RETURNS_CLEANUP_RESULT_INFO  0x00000200
-#define FILE_SUPPORTS_REMOTE_STORAGE	0x00000100
-#define FILE_SUPPORTS_REPARSE_POINTS	0x00000080
-#define FILE_SUPPORTS_SPARSE_FILES	0x00000040
-#define FILE_VOLUME_QUOTAS		0x00000020
-#define FILE_FILE_COMPRESSION		0x00000010
-#define FILE_PERSISTENT_ACLS		0x00000008
-#define FILE_UNICODE_ON_DISK		0x00000004
-#define FILE_CASE_PRESERVED_NAMES	0x00000002
-#define FILE_CASE_SENSITIVE_SEARCH	0x00000001
 typedef struct {
 	__le32 Attributes;
 	__le32 MaxPathNameComponentLength;
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
new file mode 100644
index 0000000000000..c8bfb87232ac0
--- /dev/null
+++ b/fs/smb/common/fscc.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *
+ *   Copyright (c) International Business Machines  Corp., 2009, 2013
+ *                 Etersoft, 2012
+ *                 2018 Samsung Electronics Co., Ltd.
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *              Pavel Shilovsky (pshilovsky@samba.org) 2012
+ *              Namjae Jeon (linkinjeon@kernel.org)
+ *
+ */
+#ifndef _COMMON_SMB_FSCC_H
+#define _COMMON_SMB_FSCC_H
+
+/* List of FileSystemAttributes - see MS-FSCC 2.5.1 */
+#define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
+#define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
+#define FILE_SUPPORT_INTEGRITY_STREAMS	0x04000000
+#define FILE_SUPPORTS_USN_JOURNAL	0x02000000
+#define FILE_SUPPORTS_OPEN_BY_FILE_ID	0x01000000
+#define FILE_SUPPORTS_EXTENDED_ATTRIBUTES 0x00800000
+#define FILE_SUPPORTS_HARD_LINKS	0x00400000
+#define FILE_SUPPORTS_TRANSACTIONS	0x00200000
+#define FILE_SEQUENTIAL_WRITE_ONCE	0x00100000
+#define FILE_READ_ONLY_VOLUME		0x00080000
+#define FILE_NAMED_STREAMS		0x00040000
+#define FILE_SUPPORTS_ENCRYPTION	0x00020000
+#define FILE_SUPPORTS_OBJECT_IDS	0x00010000
+#define FILE_VOLUME_IS_COMPRESSED	0x00008000
+#define FILE_SUPPORTS_POSIX_UNLINK_RENAME 0x00000400
+#define FILE_RETURNS_CLEANUP_RESULT_INFO  0x00000200
+#define FILE_SUPPORTS_REMOTE_STORAGE	0x00000100
+#define FILE_SUPPORTS_REPARSE_POINTS	0x00000080
+#define FILE_SUPPORTS_SPARSE_FILES	0x00000040
+#define FILE_VOLUME_QUOTAS		0x00000020
+#define FILE_FILE_COMPRESSION		0x00000010
+#define FILE_PERSISTENT_ACLS		0x00000008
+#define FILE_UNICODE_ON_DISK		0x00000004
+#define FILE_CASE_PRESERVED_NAMES	0x00000002
+#define FILE_CASE_SENSITIVE_SEARCH	0x00000001
+
+#endif /* _COMMON_SMB_FSCC_H */
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 4568896273bec..bea0a250169c3 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -12,6 +12,7 @@
 #include "nterr.h"
 #include "../common/cifsglob.h"
 #include "../common/smb2pdu.h"
+#include "../common/fscc.h"
 #include "smb2pdu.h"
 
 /* ksmbd's Specific ERRNO */
@@ -50,33 +51,6 @@
 #define ATTR_NO_BUFFERING		0x20000000
 #define ATTR_WRITE_THROUGH		0x80000000
 
-/* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
-#define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
-#define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
-#define FILE_SUPPORT_INTEGRITY_STREAMS	0x04000000
-#define FILE_SUPPORTS_USN_JOURNAL	0x02000000
-#define FILE_SUPPORTS_OPEN_BY_FILE_ID	0x01000000
-#define FILE_SUPPORTS_EXTENDED_ATTRIBUTES 0x00800000
-#define FILE_SUPPORTS_HARD_LINKS	0x00400000
-#define FILE_SUPPORTS_TRANSACTIONS	0x00200000
-#define FILE_SEQUENTIAL_WRITE_ONCE	0x00100000
-#define FILE_READ_ONLY_VOLUME		0x00080000
-#define FILE_NAMED_STREAMS		0x00040000
-#define FILE_SUPPORTS_ENCRYPTION	0x00020000
-#define FILE_SUPPORTS_OBJECT_IDS	0x00010000
-#define FILE_VOLUME_IS_COMPRESSED	0x00008000
-#define FILE_SUPPORTS_POSIX_UNLINK_RENAME 0x00000400
-#define FILE_RETURNS_CLEANUP_RESULT_INFO  0x00000200
-#define FILE_SUPPORTS_REMOTE_STORAGE	0x00000100
-#define FILE_SUPPORTS_REPARSE_POINTS	0x00000080
-#define FILE_SUPPORTS_SPARSE_FILES	0x00000040
-#define FILE_VOLUME_QUOTAS		0x00000020
-#define FILE_FILE_COMPRESSION		0x00000010
-#define FILE_PERSISTENT_ACLS		0x00000008
-#define FILE_UNICODE_ON_DISK		0x00000004
-#define FILE_CASE_PRESERVED_NAMES	0x00000002
-#define FILE_CASE_SENSITIVE_SEARCH	0x00000001
-
 /* Combinations of file access permission bits */
 #define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
 		| FILE_READ_ATTRIBUTES \
-- 
2.53.0



