Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6BD43E06E;
	Tue, 21 Jul 2026 22:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672771; cv=none; b=i/EbwOOevpdT4FCW0/dthGLKh/9NGHrhADtoXb2yU5Pjc0UTnYoS1sZPB6b1pkxTfVTz5o9SkqFoSW7iq9GGWwssKo2o5Zrt4Rp1GUr8Ej9Khyv5R1xve/SWHac/TUEeDda3WqwI/YpvCLIq4ZoATJPw1ufg5Z4I+LWEJfTEjBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672771; c=relaxed/simple;
	bh=YdT3qN23OrEim1Qc7VV084XM02FhCpUSs6TWhA4e2cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ut4f5LE7cSlKHMAFWm+gm4hcQvfqZZEao8pMeysPs+w41rYO9jRaCfUK/z3AbifT7sT3nW04bXLwNSBa6ocUPK8eIcA87r18wmTzc3cQLi+GRGMJ54VdhjAzbS/bcvYX1Gy0vekqJ/oNhkU/Ul22WKaYHyq+ExpJrphi9fkzeWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g44BpTAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g44BpTAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5C61F000E9;
	Tue, 21 Jul 2026 22:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672770;
	bh=QxmRSNlKCa/p2KSGaiktBwywHXxx2+QF7PJzFw+RuD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g44BpTAs3P4B5XJwrTKhnXuJSeG3QkS0D1Dene2MXiwACjFGWmaPBwzV3tgo+YYcn
	 uO03K/QavV6+QXKkaOANBjJj807yLVJ/8OA+VRMGHG9FyZISlA2+LCE5VjVC1YihJN
	 mjglt2M7OMn5OICH53fmC5RxEeoY/+uRMSmIOlNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 750/843] cifs: remove unused server parameter from calc_smb_size()
Date: Tue, 21 Jul 2026 17:26:25 +0200
Message-ID: <20260721152422.922424372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 68ed14496b032b0c9ef21b38ee45c6c8f3a18ff1 ]

This parameter is unused by the called function

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 53b7c271f06b ("smb: client: restrict implied bcc[0] exemption to responses without data area")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_debug.c |    2 +-
 fs/cifs/cifsglob.h   |    2 +-
 fs/cifs/cifsproto.h  |    2 +-
 fs/cifs/misc.c       |    2 +-
 fs/cifs/netmisc.c    |    2 +-
 fs/cifs/readdir.c    |    6 ++----
 fs/cifs/smb2misc.c   |    4 ++--
 fs/cifs/smb2ops.c    |    2 +-
 fs/cifs/smb2proto.h  |    2 +-
 9 files changed, 11 insertions(+), 13 deletions(-)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -42,7 +42,7 @@ void cifs_dump_detail(void *buf, struct
 		 smb->Command, smb->Status.CifsError,
 		 smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
 	cifs_dbg(VFS, "smb buf %p len %u\n", smb,
-		 server->ops->calc_smb_size(smb, server));
+		 server->ops->calc_smb_size(smb));
 #endif /* CONFIG_CIFS_DEBUG2 */
 }
 
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -389,7 +389,7 @@ struct smb_version_operations {
 	int (*close_dir)(const unsigned int, struct cifs_tcon *,
 			 struct cifs_fid *);
 	/* calculate a size of SMB message */
-	unsigned int (*calc_smb_size)(void *buf, struct TCP_Server_Info *ptcpi);
+	unsigned int (*calc_smb_size)(void *buf);
 	/* check for STATUS_PENDING and process the response if yes */
 	bool (*is_status_pending)(char *buf, struct TCP_Server_Info *server);
 	/* check for STATUS_NETWORK_SESSION_EXPIRED */
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -148,7 +148,7 @@ extern int cifs_get_writable_path(struct
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 				  struct cifsFileInfo **ret_file);
-extern unsigned int smbCalcSize(void *buf, struct TCP_Server_Info *server);
+extern unsigned int smbCalcSize(void *buf);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
 			struct TCP_Server_Info *server);
 extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -357,7 +357,7 @@ checkSMB(char *buf, unsigned int total_r
 	/* otherwise, there is enough to get to the BCC */
 	if (check_smb_hdr(smb))
 		return -EIO;
-	clc_len = smbCalcSize(smb, server);
+	clc_len = smbCalcSize(smb);
 
 	if (4 + rfclen != total_read) {
 		cifs_dbg(VFS, "Length read does not match RFC1001 length %d\n",
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -912,7 +912,7 @@ map_and_check_smb_error(struct mid_q_ent
  * portion, the number of word parameters and the data portion of the message
  */
 unsigned int
-smbCalcSize(void *buf, struct TCP_Server_Info *server)
+smbCalcSize(void *buf)
 {
 	struct smb_hdr *ptr = (struct smb_hdr *)buf;
 	return (sizeof(struct smb_hdr) + (2 * ptr->WordCount) +
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -808,8 +808,7 @@ find_cifs_entry(const unsigned int xid,
 
 		end_of_smb = cfile->srch_inf.ntwrk_buf_start +
 			server->ops->calc_smb_size(
-					cfile->srch_inf.ntwrk_buf_start,
-					server);
+					cfile->srch_inf.ntwrk_buf_start);
 
 		cur_ent = cfile->srch_inf.srch_entries_start;
 		first_entry_in_buffer = cfile->srch_inf.index_of_last_entry
@@ -1008,8 +1007,7 @@ int cifs_readdir(struct file *file, stru
 	cifs_dbg(FYI, "loop through %d times filling dir for net buf %p\n",
 		 num_to_fill, cifsFile->srch_inf.ntwrk_buf_start);
 	max_len = tcon->ses->server->ops->calc_smb_size(
-			cifsFile->srch_inf.ntwrk_buf_start,
-			tcon->ses->server);
+			cifsFile->srch_inf.ntwrk_buf_start);
 	end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
 
 	tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -221,7 +221,7 @@ smb2_check_message(char *buf, unsigned i
 		}
 	}
 
-	calc_len = smb2_calc_size(buf, server);
+	calc_len = smb2_calc_size(buf);
 
 	/* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
 	 * be 0, and not a real miscalculation */
@@ -403,7 +403,7 @@ smb2_get_data_area_len(int *off, int *le
  * portion, the number of word parameters and the data portion of the message.
  */
 unsigned int
-smb2_calc_size(void *buf, struct TCP_Server_Info *srvr)
+smb2_calc_size(void *buf)
 {
 	struct smb2_pdu *pdu = (struct smb2_pdu *)buf;
 	struct smb2_hdr *shdr = &pdu->hdr;
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -374,7 +374,7 @@ smb2_dump_detail(void *buf, struct TCP_S
 		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
 		 shdr->Id.SyncId.ProcessId);
 	cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
-		 server->ops->calc_smb_size(buf, server));
+		 server->ops->calc_smb_size(buf));
 #endif
 }
 
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -23,7 +23,7 @@ struct smb_rqst;
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
 extern int smb2_check_message(char *buf, unsigned int length,
 			      struct TCP_Server_Info *server);
-extern unsigned int smb2_calc_size(void *buf, struct TCP_Server_Info *server);
+extern unsigned int smb2_calc_size(void *buf);
 extern char *smb2_get_data_area_len(int *off, int *len,
 				    struct smb2_hdr *shdr);
 extern __le16 *cifs_convert_path_to_utf16(const char *from,


