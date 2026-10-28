Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212473;
	b=Pm+jq+P1DUzI8OmBAOO0c9BO7aHXrRlRgtQC3keMjoSAaAEbln3Z+kYEd5a8OYro5rRv
	 F44FHxf+M8ISQvRnfI/q+OYMUaehjFWctjofMzqC6UcFNNFZo7ie1zLnddbt3Brkj53Sd
	 jdvUEehRyE1kBtJkn2HpldhoWW3+QqfoQkJ/waPZAC7bLwdMys+tlTpWFXSJvOPftegU6
	 p+Rjl919JvZ0iYXTp1XTkGneS1dvn/5hfU58BOSwt3lOlNStwJnLrKh1Ifo+mxEqaFm8+
	 E4lEpJixsMsR1PTc0AX5ZTFcJ+43lU/dlQkPYxAtWwqIqH7jAL4CazsAIPewWA+IXoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NPndgIsErQy+EBj370XDuYKa/36pVATmwqqOaatZ6nw=;
	b=mV0CPwHlKhkGooYCjLE5JHLIoXlWWbK8+k+6iWib6uDdM9lx5e7E2ootSUOF6hJUnTZa
	 ASHFCh5hVtxWdGYD/wvxp124cqSEUgx8aLFSzu/MOV8fOcO+mQ/+mMIYAxIIUfxhE3wPc
	 9HOmFcTFzFIlds+z8nKIgDphVa0bCnbUNSbmymR23a0zS29wDxn3sQLeE2p0eYNNRBBmX
	 ObS47gYCvSc/jw6Aps2xfS4iDWese4pePpwVdjqFxrHndeV9qDNDMhQnNOP3qN/6KLum3
	 pN+F/edld5Akn/sEE5QfJ7IeVzOkBbQ00L9zUn04cmwJGR7Tq1DJ1AsPp4GmANJbNwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjmLq6tS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A482606A31C;
	Wed, 28 Oct 2026 18:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjmLq6tS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACA61F01825;
	Wed, 28 Oct 2026 18:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212473;
	bh=NPndgIsErQy+EBj370XDuYKa/36pVATmwqqOaatZ6nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjmLq6tS/oPPSDTi7BbCdXYoe8BTUOOhmBkDEJtnBDqYgqEK40DzsUxlfn7v237Ju
	 Wx7AOYgZnfFRlNS30UM6n+1Z7rQJ3t+u50M7MNi2qNI135JPwDJHSmoo6/i7yUhEgq
	 MLQuZBvWhnkIfjsBW91ShGWWv2vJgOqHmJ+t9NSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0167/1887] smb/client: pass cifs_open_info_data to SMB2_open()
Date: Wed, 28 Oct 2026 17:37:43 +0100
Message-ID: <20261028170503.035603386@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 1f551e407bb49dce0bbd34ed6a499dad69e18020 ]

Let SMB2_open() fill the smb2_file_all_info embedded in cifs_open_info_data
directly. This removes the temporary smb2_file_all_info copy in
smb2_open_file().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>

[6.1 dependency adaptation]
Keep the stable branch's request setup and extern declarations while
passing cifs_open_info_data through SMB2_open() and its non-NULL callers.
Use the embedded fi directly, retaining the existing symlink retry reset.

Move the existing six-argument trace_smb3_open_done() call after
smb2_parse_contexts(), matching the layout needed for a clean three-way
application of 566820af017e ("smb: client: close handle after create-context
parsing failure"). Do not import upstream replay support or the newer
tracepoint signature. No functions are added.

Stable-dep-of: 566820af017e ("smb: client: close handle after create-context parsing failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/link.c      |  6 +++---
 fs/smb/client/smb2file.c  | 19 ++++++++-----------
 fs/smb/client/smb2pdu.c   | 31 ++++++++++++++++---------------
 fs/smb/client/smb2proto.h |  2 +-
 4 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index ce76807cfe915..cf90ef0404710 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -355,7 +355,7 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	int buf_type = CIFS_NO_BUFFER;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct smb2_file_all_info file_info = {};
+	struct cifs_open_info_data data = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -371,12 +371,12 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	if (utf16_path == NULL)
 		return -ENOMEM;
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &file_info, NULL,
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &data, NULL,
 		       NULL, NULL);
 	if (rc)
 		goto qmf_out_open_fail;
 
-	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+	if (data.fi.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		/* it's not a symlink */
 		rc = -ENOENT; /* Is there a better rc to return? */
 		goto qmf_out;
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 2d0dd87dae0dd..e3da8107bda45 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -112,8 +112,6 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	__le16 *smb2_path;
 	__u8 smb2_oplock;
 	struct cifs_open_info_data *data = buf;
-	struct smb2_file_all_info file_info = {};
-	struct smb2_file_all_info *smb2_data = data ? &file_info : NULL;
 	struct kvec err_iov = {};
 	int err_buftype = CIFS_NO_BUFFER;
 	struct cifs_fid *fid = oparms->fid;
@@ -130,14 +128,14 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	}
 	smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
-	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
+	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 		       &err_buftype);
 	if (rc == -EACCES && retry_without_read_attributes) {
 		free_rsp_buf(err_buftype, err_iov.iov_base);
 		memset(&err_iov, 0, sizeof(err_iov));
 		err_buftype = CIFS_NO_BUFFER;
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
-		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
+		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 			       &err_buftype);
 	}
 	if (rc && data) {
@@ -149,9 +147,9 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
 							 &data->symlink_target);
 			if (!rc) {
-				memset(smb2_data, 0, sizeof(*smb2_data));
+				memset(&data->fi, 0, sizeof(data->fi));
 				oparms->create_options |= OPEN_REPARSE_POINT;
-				rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data,
+				rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data,
 					       NULL, NULL, NULL);
 				oparms->create_options &= ~OPEN_REPARSE_POINT;
 			}
@@ -180,23 +178,22 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 		rc = 0;
 	}
 
-	if (smb2_data) {
+	if (data) {
 		/* if open response does not have IndexNumber field - get it */
-		if (smb2_data->IndexNumber == 0) {
+		if (data->fi.IndexNumber == 0) {
 			rc = SMB2_get_srv_num(xid, oparms->tcon,
 				      fid->persistent_fid,
 				      fid->volatile_fid,
-				      &smb2_data->IndexNumber);
+				      &data->fi.IndexNumber);
 			if (rc) {
 				/*
 				 * let get_inode_info disable server inode
 				 * numbers
 				 */
-				smb2_data->IndexNumber = 0;
+				data->fi.IndexNumber = 0;
 				rc = 0;
 			}
 		}
-		memcpy(&data->fi, smb2_data, sizeof(data->fi));
 	}
 
 	*oplock = smb2_oplock;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d55858a12b18a..6a75d36bc5402 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3121,7 +3121,7 @@ SMB2_open_free(struct smb_rqst *rqst)
 
 int
 SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
-	  __u8 *oplock, struct smb2_file_all_info *buf,
+	  __u8 *oplock, struct cifs_open_info_data *buf,
 	  struct create_posix_rsp *posix,
 	  struct kvec *err_iov, int *buftype)
 {
@@ -3135,6 +3135,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
+	struct smb2_file_all_info *file_info = buf ? &buf->fi : NULL;
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
@@ -3179,9 +3180,6 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		goto creat_exit;
 	} else if (rsp == NULL) /* unlikely to happen, but safer to check */
 		goto creat_exit;
-	else
-		trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
-				     oparms->create_options, oparms->desired_access);
 
 	atomic_inc(&tcon->num_remote_opens);
 	oparms->fid->persistent_fid = rsp->PersistentFileId;
@@ -3191,21 +3189,24 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	if (buf) {
-		buf->CreationTime = rsp->CreationTime;
-		buf->LastAccessTime = rsp->LastAccessTime;
-		buf->LastWriteTime = rsp->LastWriteTime;
-		buf->ChangeTime = rsp->ChangeTime;
-		buf->AllocationSize = rsp->AllocationSize;
-		buf->EndOfFile = rsp->EndofFile;
-		buf->Attributes = rsp->FileAttributes;
-		buf->NumberOfLinks = cpu_to_le32(1);
-		buf->DeletePending = 0;
+	if (file_info) {
+		file_info->CreationTime = rsp->CreationTime;
+		file_info->LastAccessTime = rsp->LastAccessTime;
+		file_info->LastWriteTime = rsp->LastWriteTime;
+		file_info->ChangeTime = rsp->ChangeTime;
+		file_info->AllocationSize = rsp->AllocationSize;
+		file_info->EndOfFile = rsp->EndofFile;
+		file_info->Attributes = rsp->FileAttributes;
+		file_info->NumberOfLinks = cpu_to_le32(1);
+		file_info->DeletePending = 0;
 	}
 
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
-				 oparms->fid->lease_key, oplock, buf, posix);
+				 oparms->fid->lease_key, oplock, file_info, posix);
+
+	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
+			     oparms->create_options, oparms->desired_access);
 creat_exit:
 	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 79e5e7764c3d9..2897fb6f5397e 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -122,7 +122,7 @@ extern int SMB2_tcon(const unsigned int xid, struct cifs_ses *ses,
 extern int SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon);
 extern int SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms,
 		     __le16 *path, __u8 *oplock,
-		     struct smb2_file_all_info *buf,
+		     struct cifs_open_info_data *buf,
 		     struct create_posix_rsp *posix,
 		     struct kvec *err_iov, int *resp_buftype);
 extern int SMB2_open_init(struct cifs_tcon *tcon,
-- 
2.53.0



