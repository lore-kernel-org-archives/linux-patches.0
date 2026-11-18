Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050314;
	b=YSMQGt7f8B9e7e7bqvgqXjqmsuUyPfPPskoQe/PHuFYo/AshxZyFvI55rj2aqWAsCtsJ
	 lNdJbvy33vUX/n4MdRs+nc3iWjB7xt/LxTtHHYUaLp5ZvpwIBdHK8kys5APjxnRFG9QVL
	 36MKPi26NBabhynqMXI/bQWhKmvM4ziyzrp9xYi81mSBprIuGsisIKZEmct4cEvhXp//K
	 ODx5XIyImEOy7qwIkl0CwalLT8hJPdmBew6dVnG9izyjkn8DNF8ex7mHTLAhSq2Iuf623
	 iHkb1RsqzBjaswP8u0YBD3+OEcVwXsYuoIcZiTsf7lEB6HUuHsBiR/IlQNXJnx2fR3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/bfo1Z15djoQtWv766xMUh2w5SG7xH+hfGXEtpVR2WI=;
	b=f2gP5vpKDggQ69pxeYSfjOhD7fsTXKwQ6wvzJtgOZP1nSoNdodGA2HrtxnVslKnXz2TY
	 x3iWh2wkbkrZ0f2uBwVTCDTBZ99VsaUdac6TJ8a+DSTEpYPERKH52/wSiHlnsWTNfeDi7
	 WAVvi07eqC32nUVpX52RCR+M6H6Yb52LXeJr+9nx5a+PkM3yg+FevahiuTX84YNRXxE0S
	 rMqpgFEp2ZOz8Jqoc6dxfkIaTC8q7ez+u6JluG3NdqEhcg1k9pJRI0Jxc2jmONEp7WkiL
	 Tgnv1ckSbZ4sm0+4LY+RyzeW3sQOM7fjJEIKcJomCnDjrLEZm3ZuKfsS+9rE8PKBXUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNov+2hF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88965606A331;
	Thu, 19 Nov 2026 01:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNov+2hF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90CC1F000C5;
	Thu, 19 Nov 2026 01:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050314;
	bh=/bfo1Z15djoQtWv766xMUh2w5SG7xH+hfGXEtpVR2WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNov+2hFp0JEMPPFXdjXCdJjWOyR1AreJ1seRINo5qYywZ1nu0z+h2EGBtG3xl/Y9
	 sQBsag5Xuh3RwUjfujvVbGUTNmpUECDNEAwHRjQB05Ebg3+wK0Cyhf8hArYXzzvCBM
	 1nLYpT6InQgJGSydxKypb5McPUAYLpgNl3D7ODVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shen Lichuan <shenlichuan@vivo.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2662/2857] ksmbd: Correct typos in multiple comments across various files
Date: Wed, 18 Nov 2026 16:01:36 +0100
Message-ID: <20261118150337.424878577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Shen Lichuan <shenlichuan@vivo.com>

[ Upstream commit 9e676e571d39eb6189bf6d55a9c401ba2dd13410 ]

Fixed some confusing typos that were currently identified witch codespell,
the details are as follows:

-in the code comments:
fs/smb/common/smb2pdu.h:9: specfication ==> specification
fs/smb/common/smb2pdu.h:494: usally ==> usually
fs/smb/common/smb2pdu.h:1064: Attrubutes ==> Attributes
fs/smb/server/connection.c:28: cleand ==> cleaned
fs/smb/server/ksmbd_netlink.h:216: struture ==> structure
fs/smb/server/oplock.c:799: conains ==> contains
fs/smb/server/oplock.c:1487: containted ==> contained
fs/smb/server/server.c:282: proccessing ==> processing
fs/smb/server/smb_common.c:491: comforms ==> conforms
fs/smb/server/xattr.h:102: ATTRIBUITE ==> ATTRIBUTE

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: e8486c5cfbdd ("smb/server: fix trailing period in generated short names")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h       | 6 +++---
 fs/smb/server/connection.c    | 2 +-
 fs/smb/server/ksmbd_netlink.h | 2 +-
 fs/smb/server/oplock.c        | 4 ++--
 fs/smb/server/server.c        | 2 +-
 fs/smb/server/smb_common.c    | 2 +-
 fs/smb/server/xattr.h         | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 430b65512228f..6df31af2d1a94 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -6,7 +6,7 @@
  * Note that, due to trying to use names similar to the protocol specifications,
  * there are many mixed case field names in the structures below.  Although
  * this does not match typical Linux kernel style, it is necessary to be
- * able to match against the protocol specfication.
+ * able to match against the protocol specification.
  *
  * SMB2 commands
  * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
@@ -480,7 +480,7 @@ struct smb2_encryption_neg_context {
 	__le16	ContextType; /* 2 */
 	__le16	DataLength;
 	__le32	Reserved;
-	/* CipherCount usally 2, but can be 3 when AES256-GCM enabled */
+	/* CipherCount usually 2, but can be 3 when AES256-GCM enabled */
 	__le16	CipherCount; /* AES128-GCM and AES128-CCM by default */
 	__le16	Ciphers[];
 } __packed;
@@ -1036,7 +1036,7 @@ struct smb2_change_notify_rsp {
 #define IL_IMPERSONATION	cpu_to_le32(0x00000002)
 #define IL_DELEGATE		cpu_to_le32(0x00000003)
 
-/* File Attrubutes */
+/* File Attributes */
 #define FILE_ATTRIBUTE_READONLY			0x00000001
 #define FILE_ATTRIBUTE_HIDDEN			0x00000002
 #define FILE_ATTRIBUTE_SYSTEM			0x00000004
diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 28c60d3070a25..131fd307d53df 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -63,7 +63,7 @@ void ksmbd_conn_put(struct ksmbd_conn *conn)
 /**
  * ksmbd_conn_free() - free resources of the connection instance
  *
- * @conn:	connection instance to be cleand up
+ * @conn:	connection instance to be cleaned up
  *
  * During the thread termination, the corresponding conn instance
  * resources(sock/memory) are released and finally the conn object is freed.
diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 475de7289e220..c45785bd8ddf4 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -214,7 +214,7 @@ struct ksmbd_tree_connect_response {
 };
 
 /*
- * IPC Request struture to disconnect tree connection.
+ * IPC Request structure to disconnect tree connection.
  */
 struct ksmbd_tree_disconnect_request {
 	__u64	session_id;	/* session id */
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 325d9a55ca657..4d13eb0471d53 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -869,7 +869,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 /**
  * smb2_lease_break_noti() - break lease when a new client request
  *			write lease
- * @opinfo:		conains lease state information
+ * @opinfo:		contains lease state information
  *
  * Return:	0 on success, otherwise error
  */
@@ -1577,7 +1577,7 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
 }
 
 /**
- * parse_lease_state() - parse lease context containted in file open request
+ * parse_lease_state() - parse lease context contained in file open request
  * @open_req:	buffer containing smb2 file open(create) request
  * @is_dir:	whether leasing file is directory
  *
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index d314e21b753b6..3ca7fa8f6096b 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -312,7 +312,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 
 /**
  * queue_ksmbd_work() - queue a smb request to worker thread queue
- *		for proccessing smb command and sending response
+ *		for processing smb command and sending response
  * @conn:	connection instance
  *
  * read remaining data from socket create and submit work.
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index d30547f656ccd..87e95f34ee0d3 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -491,7 +491,7 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
  * @shortname:	destination short filename
  *
  * Return:	shortname length or 0 when source long name is '.' or '..'
- * TODO: Though this function comforms the restriction of 8.3 Filename spec,
+ * TODO: Though this function conforms the restriction of 8.3 Filename spec,
  * but the result is different with Windows 7's one. need to check.
  */
 int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
diff --git a/fs/smb/server/xattr.h b/fs/smb/server/xattr.h
index 16499ca5c82d3..64a5a322fcd70 100644
--- a/fs/smb/server/xattr.h
+++ b/fs/smb/server/xattr.h
@@ -99,7 +99,7 @@ struct xattr_ntacl {
 	__u8	posix_acl_hash[XATTR_SD_HASH_SIZE]; /* 64bytes hash for posix acl */
 };
 
-/* DOS ATTRIBUITE XATTR PREFIX */
+/* DOS ATTRIBUTE XATTR PREFIX */
 #define DOS_ATTRIBUTE_PREFIX		"DOSATTRIB"
 #define DOS_ATTRIBUTE_PREFIX_LEN	(sizeof(DOS_ATTRIBUTE_PREFIX) - 1)
 #define XATTR_NAME_DOS_ATTRIBUTE	(XATTR_USER_PREFIX DOS_ATTRIBUTE_PREFIX)
-- 
2.53.0



