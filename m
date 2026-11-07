Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061390;
	b=mX5I3WWYG+R/pceqiT9qcAEcDmB7H138oWTpsEUIRESi1/WVtb8PNjMO+cTnLdd3qeEp
	 mgymvYHopPACMFW2skPkz6U8Nl7LYhOhkg6W+8WgHrJ9EYOV/+KTr7d/EMYaAFmad05vP
	 FVMd563+PAnx6PX/rsPLdwuGdmylYHt4k0f8AvAG7HiWKvIEKhr4USY5nt5D26SczozQ7
	 pNCcI2999d2mplnvxPuzXImm7o1OmElXOygGbaPXhHtFYoFA+pUMAKLc9BhHkAR7MwzUd
	 Vc1Rql7MPB+x69hlLw7UuYR88jKVwnFxpL3W+FYHkC2c1P7FT6hIAbYoU0kw/Kpv5Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FOKhp/hh1xlzHwbmYtU2hDX3DkLoQsObz1hnYNGj04c=;
	b=Y174GyNkD6wRE7OvqrobBBOl0RlXLI3mrWQM2F4G1jAi9wShWaeYH+/Ztzz+3CjnFqDr
	 6WdJ7nPpN4b+QFQTg/7orFvOC9jHkZdAyRE9KKzmrNon8JQbjq+tZe2ZDjuIEAyIX6NPH
	 PJ6HSeYrRdZluMyE9NoP+Rf61tPtAKYsH5IEhhUac2CtvGsXptDn4sCWTQwVZWjpfZT0z
	 6hU9DVoCX7WzqGljDy0uLf1Wnd58SUhPG+9zfroZz+tM/Avb6kA1HmmFgnSmGUxw5JlHP
	 FCrs0DqtCnZjG/su1lon7zSdV5qOWQoPUE2HdmlQjSWqmYO3Hks6HDG0fYTxNBU/pDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4CISInM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273AA606A333;
	Sat,  7 Nov 2026 14:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4CISInM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB01E1F0089F;
	Sat,  7 Nov 2026 14:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061390;
	bh=FOKhp/hh1xlzHwbmYtU2hDX3DkLoQsObz1hnYNGj04c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4CISInMTGdxBJ4xVmwhFdKTHCmBK/PtsLFEnl0UitbB4CVbyIwtLomQDTNam6hLG
	 8+jBzqN1DLCgzO8pGnGJmkXfTPrCO0tZ9yBUYJhXSkBX5qnVrz8YkE1WSSMFQSm8xO
	 zQGVHV42dL86HXy14laWDfmG0w3S/qn3Ao5yUbJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0511/1536] cifs: Rename struct reparse_posix_data to reparse_nfs_data_buffer and move to common/smb2pdu.h
Date: Sat,  7 Nov 2026 08:42:07 -0500
Message-ID: <20261107135011.790379950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit b6d002f0a345218edbe9de049693004482a81327 ]

Function parse_reparse_posix() parses NFS-style reparse points, which are
used only by Windows NFS server since Windows Server 2012 version. This
style is not understood by Microsoft POSIX/Interix/SFU/SUA subsystems.

So make it clear that parse_reparse_posix() function and reparse_posix_data
structure are not POSIX general, but rather NFS specific.

All reparse buffer structures are defined in common/smb2pdu.h and have
_buffer suffix. So move struct reparse_posix_data from client/cifspdu.h to
common/smb2pdu.h and rename it to reparse_nfs_data_buffer for consistency.
Note that also SMB specification in [MS-FSCC] document, section 2.1.2.6
defines it under name "Network File System (NFS) Reparse Data Buffer".
So use this name for consistency.

Having this structure in common/smb2pdu.h can be useful for ksmbd server
code as NFS-style reparse points is the preferred way for implementing
support for special files.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 65d5dbdc089b ("smb: client: fix file type corruption in posix_reparse_to_fattr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifspdu.h | 14 --------------
 fs/smb/client/reparse.c | 12 ++++++------
 fs/smb/common/smb2pdu.h | 14 +++++++++++++-
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 30bdb424c81f2..55514393acdfb 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1475,20 +1475,6 @@ struct file_notify_information {
 	__u8  FileName[];
 } __attribute__((packed));
 
-/* For IO_REPARSE_TAG_NFS */
-#define NFS_SPECFILE_LNK	0x00000000014B4E4C
-#define NFS_SPECFILE_CHR	0x0000000000524843
-#define NFS_SPECFILE_BLK	0x00000000004B4C42
-#define NFS_SPECFILE_FIFO	0x000000004F464946
-#define NFS_SPECFILE_SOCK	0x000000004B434F53
-struct reparse_posix_data {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le64	InodeType; /* LNK, FIFO, CHR etc. */
-	__u8	DataBuffer[];
-} __attribute__((packed));
-
 struct cifs_quota_data {
 	__u32	rsrvd1;  /* 0 */
 	__u32	sid_size;
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index de070b108180b..53ed9bae23a86 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -242,7 +242,7 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 	return 0;
 }
 
-static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
+static int nfs_set_reparse_buf(struct reparse_nfs_data_buffer *buf,
 			       mode_t mode, dev_t dev,
 			       struct kvec *iov)
 {
@@ -281,13 +281,13 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 		     const char *full_path, umode_t mode, dev_t dev)
 {
 	struct cifs_open_info_data data;
-	struct reparse_posix_data *p;
+	struct reparse_nfs_data_buffer *p;
 	struct inode *new;
 	struct kvec iov;
 	__u8 buf[sizeof(*p) + sizeof(__le64)];
 	int rc;
 
-	p = (struct reparse_posix_data *)buf;
+	p = (struct reparse_nfs_data_buffer *)buf;
 	rc = nfs_set_reparse_buf(p, mode, dev, &iov);
 	if (rc)
 		return rc;
@@ -474,7 +474,7 @@ int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
 }
 
 /* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
-static int parse_reparse_posix(struct reparse_posix_data *buf,
+static int parse_reparse_nfs(struct reparse_nfs_data_buffer *buf,
 			       struct cifs_sb_info *cifs_sb,
 			       struct cifs_open_info_data *data)
 {
@@ -639,7 +639,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	/* See MS-FSCC 2.1.2 */
 	switch (le32_to_cpu(buf->ReparseTag)) {
 	case IO_REPARSE_TAG_NFS:
-		return parse_reparse_posix((struct reparse_posix_data *)buf,
+		return parse_reparse_nfs((struct reparse_nfs_data_buffer *)buf,
 					   cifs_sb, data);
 	case IO_REPARSE_TAG_SYMLINK:
 		return parse_reparse_symlink(
@@ -753,7 +753,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 				   struct cifs_fattr *fattr,
 				   struct cifs_open_info_data *data)
 {
-	struct reparse_posix_data *buf = (struct reparse_posix_data *)data->reparse.buf;
+	struct reparse_nfs_data_buffer *buf = (struct reparse_nfs_data_buffer *)data->reparse.buf;
 
 	if (buf == NULL)
 		return true;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 6fab72b5b60d7..e4211f871370f 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1582,7 +1582,19 @@ struct reparse_symlink_data_buffer {
 	__u8	PathBuffer[]; /* Variable Length */
 } __packed;
 
-/* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
+/* For IO_REPARSE_TAG_NFS - see MS-FSCC 2.1.2.6 */
+#define NFS_SPECFILE_LNK	0x00000000014B4E4C
+#define NFS_SPECFILE_CHR	0x0000000000524843
+#define NFS_SPECFILE_BLK	0x00000000004B4C42
+#define NFS_SPECFILE_FIFO	0x000000004F464946
+#define NFS_SPECFILE_SOCK	0x000000004B434F53
+struct reparse_nfs_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__u16	Reserved;
+	__le64	InodeType; /* NFS_SPECFILE_* */
+	__u8	DataBuffer[];
+} __packed;
 
 struct validate_negotiate_info_req {
 	__le32 Capabilities;
-- 
2.53.0



