Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD579303CB0;
	Fri, 15 May 2026 16:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861524; cv=none; b=R23lnCRl5zgSjuXTFnzMvUeWXxitUenz6/dgfiTXHUi53S/cD5K45A1WjloP1U6T6JdbgA01qb3vi12Te0mlyEDvzrRwBFFsCjVqP+NuLZjDpP0jzIc32ARCpn3bayZtJQw+/1LACjttop2BBUfM7A0x5AvOkjdd/yBFMBYCiwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861524; c=relaxed/simple;
	bh=/zu6UhuCyJF01PlVG8Ste5jHKF8Ll2MzhEYK2OKPTfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EC7PtkBASSsGltaNZD+G83smKS1AmU3Xu5JjQ93gysPduHljAmrRzn+UjCAD2WHUvQWv12+uIB3anwX4y0zLxVkDPc5DOOe2s/VCbyg0sJMCDqwo4HdpDjqEwYXrgOv29n8Y8jjJwUWSpTHiBmHQf7P6nMjxrAFPqscsgffjvm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzE9tdy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzE9tdy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C86FC2BCB3;
	Fri, 15 May 2026 16:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861524;
	bh=/zu6UhuCyJF01PlVG8Ste5jHKF8Ll2MzhEYK2OKPTfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzE9tdy/KVJa5jBxFMo6yB4ALDKPddXnyHnEgak0qFhZk5S3niIt5rPUm1B5wm0C3
	 JKpcpJ+mrwKn6+IY3qlAxAAiYVbTmn7hdKByNRRCEzxzdEwyOJfeq0GkMLxDBK2k97
	 0nAZDX6gBRv2HR1O58Y9RgT6fj4PS6ulnM3oFWRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 362/474] smb: move some duplicate definitions to common/smbacl.h
Date: Fri, 15 May 2026 17:47:51 +0200
Message-ID: <20260515154722.851773123@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit b51174da743b6b7cd87c02e882ebe60dcb99f8bf ]

In order to maintain the code more easily, move duplicate definitions
to new common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: d07b26f39246 ("ksmbd: require minimum ACE size in smb_check_perm_dacl()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.h |   91 ------------------------------------
 fs/smb/common/smbacl.h  |  121 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smbacl.h  |  111 --------------------------------------------
 3 files changed, 123 insertions(+), 200 deletions(-)
 create mode 100644 fs/smb/common/smbacl.h

--- a/fs/smb/client/cifsacl.h
+++ b/fs/smb/client/cifsacl.h
@@ -9,8 +9,7 @@
 #ifndef _CIFSACL_H
 #define _CIFSACL_H
 
-#define NUM_AUTHS (6)	/* number of authority fields */
-#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
+#include "../common/smbacl.h"
 
 #define READ_BIT        0x4
 #define WRITE_BIT       0x2
@@ -23,12 +22,6 @@
 #define UBITSHIFT	6
 #define GBITSHIFT	3
 
-#define ACCESS_ALLOWED	0
-#define ACCESS_DENIED	1
-
-#define SIDOWNER 1
-#define SIDGROUP 2
-
 /*
  * Security Descriptor length containing DACL with 3 ACEs (one each for
  * owner, group and world).
@@ -38,88 +31,6 @@
 			      (sizeof(struct smb_ace) * 4))
 
 /*
- * Maximum size of a string representation of a SID:
- *
- * The fields are unsigned values in decimal. So:
- *
- * u8:  max 3 bytes in decimal
- * u32: max 10 bytes in decimal
- *
- * "S-" + 3 bytes for version field + 15 for authority field + NULL terminator
- *
- * For authority field, max is when all 6 values are non-zero and it must be
- * represented in hex. So "-0x" + 12 hex digits.
- *
- * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
- */
-#define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
-#define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string */
-
-struct smb_ntsd {
-	__le16 revision; /* revision level */
-	__le16 type;
-	__le32 osidoffset;
-	__le32 gsidoffset;
-	__le32 sacloffset;
-	__le32 dacloffset;
-} __attribute__((packed));
-
-struct smb_sid {
-	__u8 revision; /* revision level */
-	__u8 num_subauth;
-	__u8 authority[NUM_AUTHS];
-	__le32 sub_auth[SID_MAX_SUB_AUTHORITIES]; /* sub_auth[num_subauth] */
-} __attribute__((packed));
-
-/* size of a struct smb_sid, sans sub_auth array */
-#define CIFS_SID_BASE_SIZE (1 + 1 + NUM_AUTHS)
-
-struct smb_acl {
-	__le16 revision; /* revision level */
-	__le16 size;
-	__le32 num_aces;
-} __attribute__((packed));
-
-/* ACE types - see MS-DTYP 2.4.4.1 */
-#define ACCESS_ALLOWED_ACE_TYPE	0x00
-#define ACCESS_DENIED_ACE_TYPE	0x01
-#define SYSTEM_AUDIT_ACE_TYPE	0x02
-#define SYSTEM_ALARM_ACE_TYPE	0x03
-#define ACCESS_ALLOWED_COMPOUND_ACE_TYPE 0x04
-#define ACCESS_ALLOWED_OBJECT_ACE_TYPE	0x05
-#define ACCESS_DENIED_OBJECT_ACE_TYPE	0x06
-#define SYSTEM_AUDIT_OBJECT_ACE_TYPE	0x07
-#define SYSTEM_ALARM_OBJECT_ACE_TYPE	0x08
-#define ACCESS_ALLOWED_CALLBACK_ACE_TYPE 0x09
-#define ACCESS_DENIED_CALLBACK_ACE_TYPE	0x0A
-#define ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE 0x0B
-#define ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE  0x0C
-#define SYSTEM_AUDIT_CALLBACK_ACE_TYPE	0x0D
-#define SYSTEM_ALARM_CALLBACK_ACE_TYPE	0x0E /* Reserved */
-#define SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE 0x0F
-#define SYSTEM_ALARM_CALLBACK_OBJECT_ACE_TYPE 0x10 /* reserved */
-#define SYSTEM_MANDATORY_LABEL_ACE_TYPE	0x11
-#define SYSTEM_RESOURCE_ATTRIBUTE_ACE_TYPE 0x12
-#define SYSTEM_SCOPED_POLICY_ID_ACE_TYPE 0x13
-
-/* ACE flags */
-#define OBJECT_INHERIT_ACE	0x01
-#define CONTAINER_INHERIT_ACE	0x02
-#define NO_PROPAGATE_INHERIT_ACE 0x04
-#define INHERIT_ONLY_ACE	0x08
-#define INHERITED_ACE		0x10
-#define SUCCESSFUL_ACCESS_ACE_FLAG 0x40
-#define FAILED_ACCESS_ACE_FLAG	0x80
-
-struct smb_ace {
-	__u8 type; /* see above and MS-DTYP 2.4.4.1 */
-	__u8 flags;
-	__le16 size;
-	__le32 access_req;
-	struct smb_sid sid; /* ie UUID of user or group who gets these perms */
-} __attribute__((packed));
-
-/*
  * The current SMB3 form of security descriptor is similar to what was used for
  * cifs (see above) but some fields are split, and fields in the struct below
  * matches names of fields to the spec, MS-DTYP (see sections 2.4.5 and
--- /dev/null
+++ b/fs/smb/common/smbacl.h
@@ -0,0 +1,121 @@
+/* SPDX-License-Identifier: LGPL-2.1+ */
+/*
+ *   Copyright (c) International Business Machines  Corp., 2007
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *   Modified by Namjae Jeon (linkinjeon@kernel.org)
+ */
+
+#ifndef _COMMON_SMBACL_H
+#define _COMMON_SMBACL_H
+
+#define NUM_AUTHS (6)	/* number of authority fields */
+#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
+
+/* ACE types - see MS-DTYP 2.4.4.1 */
+#define ACCESS_ALLOWED_ACE_TYPE 0x00
+#define ACCESS_DENIED_ACE_TYPE  0x01
+#define SYSTEM_AUDIT_ACE_TYPE   0x02
+#define SYSTEM_ALARM_ACE_TYPE   0x03
+#define ACCESS_ALLOWED_COMPOUND_ACE_TYPE 0x04
+#define ACCESS_ALLOWED_OBJECT_ACE_TYPE  0x05
+#define ACCESS_DENIED_OBJECT_ACE_TYPE   0x06
+#define SYSTEM_AUDIT_OBJECT_ACE_TYPE    0x07
+#define SYSTEM_ALARM_OBJECT_ACE_TYPE    0x08
+#define ACCESS_ALLOWED_CALLBACK_ACE_TYPE 0x09
+#define ACCESS_DENIED_CALLBACK_ACE_TYPE 0x0A
+#define ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE 0x0B
+#define ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE  0x0C
+#define SYSTEM_AUDIT_CALLBACK_ACE_TYPE  0x0D
+#define SYSTEM_ALARM_CALLBACK_ACE_TYPE  0x0E /* Reserved */
+#define SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE 0x0F
+#define SYSTEM_ALARM_CALLBACK_OBJECT_ACE_TYPE 0x10 /* reserved */
+#define SYSTEM_MANDATORY_LABEL_ACE_TYPE 0x11
+#define SYSTEM_RESOURCE_ATTRIBUTE_ACE_TYPE 0x12
+#define SYSTEM_SCOPED_POLICY_ID_ACE_TYPE 0x13
+
+/* ACE flags */
+#define OBJECT_INHERIT_ACE		0x01
+#define CONTAINER_INHERIT_ACE		0x02
+#define NO_PROPAGATE_INHERIT_ACE	0x04
+#define INHERIT_ONLY_ACE		0x08
+#define INHERITED_ACE			0x10
+#define SUCCESSFUL_ACCESS_ACE_FLAG	0x40
+#define FAILED_ACCESS_ACE_FLAG		0x80
+
+/*
+ * Maximum size of a string representation of a SID:
+ *
+ * The fields are unsigned values in decimal. So:
+ *
+ * u8:  max 3 bytes in decimal
+ * u32: max 10 bytes in decimal
+ *
+ * "S-" + 3 bytes for version field + 15 for authority field + NULL terminator
+ *
+ * For authority field, max is when all 6 values are non-zero and it must be
+ * represented in hex. So "-0x" + 12 hex digits.
+ *
+ * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
+ */
+#define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
+#define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string */
+
+#define DOMAIN_USER_RID_LE	cpu_to_le32(513)
+
+/*
+ * ACE types - see MS-DTYP 2.4.4.1
+ */
+enum {
+	ACCESS_ALLOWED,
+	ACCESS_DENIED,
+};
+
+/*
+ * Security ID types
+ */
+enum {
+	SIDOWNER = 1,
+	SIDGROUP,
+	SIDCREATOR_OWNER,
+	SIDCREATOR_GROUP,
+	SIDUNIX_USER,
+	SIDUNIX_GROUP,
+	SIDNFS_USER,
+	SIDNFS_GROUP,
+	SIDNFS_MODE,
+};
+
+struct smb_ntsd {
+	__le16 revision; /* revision level */
+	__le16 type;
+	__le32 osidoffset;
+	__le32 gsidoffset;
+	__le32 sacloffset;
+	__le32 dacloffset;
+} __attribute__((packed));
+
+struct smb_sid {
+	__u8 revision; /* revision level */
+	__u8 num_subauth;
+	__u8 authority[NUM_AUTHS];
+	__le32 sub_auth[SID_MAX_SUB_AUTHORITIES]; /* sub_auth[num_subauth] */
+} __attribute__((packed));
+
+/* size of a struct smb_sid, sans sub_auth array */
+#define CIFS_SID_BASE_SIZE (1 + 1 + NUM_AUTHS)
+
+struct smb_acl {
+	__le16 revision; /* revision level */
+	__le16 size;
+	__le32 num_aces;
+} __attribute__((packed));
+
+struct smb_ace {
+	__u8 type; /* see above and MS-DTYP 2.4.4.1 */
+	__u8 flags;
+	__le16 size;
+	__le32 access_req;
+	struct smb_sid sid; /* ie UUID of user or group who gets these perms */
+} __attribute__((packed));
+
+#endif /* _COMMON_SMBACL_H */
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -8,6 +8,7 @@
 #ifndef _SMBACL_H
 #define _SMBACL_H
 
+#include "../common/smbacl.h"
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
@@ -15,32 +16,6 @@
 
 #include "mgmt/tree_connect.h"
 
-#define NUM_AUTHS (6)	/* number of authority fields */
-#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
-
-/*
- * ACE types - see MS-DTYP 2.4.4.1
- */
-enum {
-	ACCESS_ALLOWED,
-	ACCESS_DENIED,
-};
-
-/*
- * Security ID types
- */
-enum {
-	SIDOWNER = 1,
-	SIDGROUP,
-	SIDCREATOR_OWNER,
-	SIDCREATOR_GROUP,
-	SIDUNIX_USER,
-	SIDUNIX_GROUP,
-	SIDNFS_USER,
-	SIDNFS_GROUP,
-	SIDNFS_MODE,
-};
-
 /* Revision for ACLs */
 #define SD_REVISION	1
 
@@ -62,92 +37,8 @@ enum {
 #define RM_CONTROL_VALID	0x4000
 #define SELF_RELATIVE		0x8000
 
-/* ACE types - see MS-DTYP 2.4.4.1 */
-#define ACCESS_ALLOWED_ACE_TYPE 0x00
-#define ACCESS_DENIED_ACE_TYPE  0x01
-#define SYSTEM_AUDIT_ACE_TYPE   0x02
-#define SYSTEM_ALARM_ACE_TYPE   0x03
-#define ACCESS_ALLOWED_COMPOUND_ACE_TYPE 0x04
-#define ACCESS_ALLOWED_OBJECT_ACE_TYPE  0x05
-#define ACCESS_DENIED_OBJECT_ACE_TYPE   0x06
-#define SYSTEM_AUDIT_OBJECT_ACE_TYPE    0x07
-#define SYSTEM_ALARM_OBJECT_ACE_TYPE    0x08
-#define ACCESS_ALLOWED_CALLBACK_ACE_TYPE 0x09
-#define ACCESS_DENIED_CALLBACK_ACE_TYPE 0x0A
-#define ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE 0x0B
-#define ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE  0x0C
-#define SYSTEM_AUDIT_CALLBACK_ACE_TYPE  0x0D
-#define SYSTEM_ALARM_CALLBACK_ACE_TYPE  0x0E /* Reserved */
-#define SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE 0x0F
-#define SYSTEM_ALARM_CALLBACK_OBJECT_ACE_TYPE 0x10 /* reserved */
-#define SYSTEM_MANDATORY_LABEL_ACE_TYPE 0x11
-#define SYSTEM_RESOURCE_ATTRIBUTE_ACE_TYPE 0x12
-#define SYSTEM_SCOPED_POLICY_ID_ACE_TYPE 0x13
-
-/* ACE flags */
-#define OBJECT_INHERIT_ACE		0x01
-#define CONTAINER_INHERIT_ACE		0x02
-#define NO_PROPAGATE_INHERIT_ACE	0x04
-#define INHERIT_ONLY_ACE		0x08
-#define INHERITED_ACE			0x10
-#define SUCCESSFUL_ACCESS_ACE_FLAG	0x40
-#define FAILED_ACCESS_ACE_FLAG		0x80
-
-/*
- * Maximum size of a string representation of a SID:
- *
- * The fields are unsigned values in decimal. So:
- *
- * u8:  max 3 bytes in decimal
- * u32: max 10 bytes in decimal
- *
- * "S-" + 3 bytes for version field + 15 for authority field + NULL terminator
- *
- * For authority field, max is when all 6 values are non-zero and it must be
- * represented in hex. So "-0x" + 12 hex digits.
- *
- * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
- */
-#define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
-#define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string */
-
-#define DOMAIN_USER_RID_LE	cpu_to_le32(513)
-
 struct ksmbd_conn;
 
-struct smb_ntsd {
-	__le16 revision; /* revision level */
-	__le16 type;
-	__le32 osidoffset;
-	__le32 gsidoffset;
-	__le32 sacloffset;
-	__le32 dacloffset;
-} __packed;
-
-struct smb_sid {
-	__u8 revision; /* revision level */
-	__u8 num_subauth;
-	__u8 authority[NUM_AUTHS];
-	__le32 sub_auth[SID_MAX_SUB_AUTHORITIES]; /* sub_auth[num_subauth] */
-} __packed;
-
-/* size of a struct cifs_sid, sans sub_auth array */
-#define CIFS_SID_BASE_SIZE (1 + 1 + NUM_AUTHS)
-
-struct smb_acl {
-	__le16 revision; /* revision level */
-	__le16 size;
-	__le32 num_aces;
-} __packed;
-
-struct smb_ace {
-	__u8 type;
-	__u8 flags;
-	__le16 size;
-	__le32 access_req;
-	struct smb_sid sid; /* ie UUID of user or group who gets these perms */
-} __packed;
-
 struct smb_fattr {
 	kuid_t	cf_uid;
 	kgid_t	cf_gid;


