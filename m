Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058012;
	b=ZGw7VqsSeQSzI2+Ua5bDUDskp0XUi4B/KNPPq6JIYrit4+gzaunR6N5PbyOr0gWMgQb8
	 2lO+Y0WEKxmg7RcpXPeC/GA2DL9rJ7NEEa6blI/9KsI800BdAEeLPBLlkZnbVI2zZ/HF9
	 /tr4ToV7lHFemzrRa+bCS4rD6yO5i07q1UPgba7md3VWbdyfdyHUzfvEaC29iL30VUka+
	 BlcpshUy1P1HGgMQ0pyFyNbwQdnvGLwXVH9LUgu+XK8dD6KfJiA2ZJsorJgZA5Gh8Zc/Q
	 +Bw7k9Hzv7Za896PaEH8J1zdy1CMTXbWCPvZEalCgwS4M+05tBPF8lPXs3CNKgMzskw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FRHe9UDLVP+LBEm/2lW+7dcOwKm+iJOfKQMFVMefr3Y=;
	b=Yygry/UI5QAQxLuNxLyAsujJNE9+IhuehorvGE1nbaWd/On038XbRiU8AB10IoQNNffS
	 IBba6gAaZecT7EH9gf20IEZehUoSSi1o4AEV6Q10xBJYuR+13wRXUINygYC9ks6hBCcCZ
	 fG9bN+RUymKkPzchozobNSQaooRV7NDR3IvK4Gr8V6DoeE/C2K7Ss45tnv1g6L14UtY2z
	 Vn9uy4916ZzO9Qx7W+IBqUOgm1vLSmueWjzfsRhT3GXEnA+y5ZWzZ5e5DLvtDNMJpHZqu
	 P8tDs3ruKGgogc/qS4royNCFtiUiXC4R+4DBdhxrhjwL+lusILF1Subb6m51nlbD78A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ujy2jJT+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3E8606A31C;
	Thu, 19 Nov 2026 03:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ujy2jJT+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE741F000C4;
	Thu, 19 Nov 2026 03:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058011;
	bh=FRHe9UDLVP+LBEm/2lW+7dcOwKm+iJOfKQMFVMefr3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ujy2jJT+uIZBd5RyS61Zpq4kCmuikCXT8stwaUiEz16iTgCvLJDWlFykmoPDWN0Rh
	 mJfYY9Zu2F0sv0dHxpjHeWWJ/Gj3xdQMw81kR/lNyezKEJ9rvTYVXPqri1Enl7p+B/
	 VzqmjHPW6Zzgb+vheiVN+Bit60HifpkBXU6QZZ8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0334/1848] smb: client: fix warning in CIFSFindNext()
Date: Wed, 18 Nov 2026 15:39:32 +0100
Message-ID: <20261118145926.272966527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 215533f888dcf18f7cfbbf520bdd52e67ac6265a ]

This fixes the following warning reported by kernel test robot

  fs/smb/client/cifssmb.c:4216 CIFSFindNext() warn: missing error
  code? 'rc'

Link: https://lore.kernel.org/all/202306170124.CtQqzf0I-lkp@intel.com/
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 59131dd72f62 ("smb: client: fix use-after-free infoleak via the readdir resume name")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 111 +++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 60 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 7712ba6d0dee7..7f0839d5c6db7 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4592,11 +4592,12 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	TRANSACTION2_FNEXT_REQ *pSMB = NULL;
 	TRANSACTION2_FNEXT_RSP *pSMBr = NULL;
 	T2_FNEXT_RSP_PARMS *parms;
-	char *response_data;
-	int rc = 0;
-	int bytes_returned;
 	unsigned int name_len;
+	unsigned int lnoff;
 	__u16 params, byte_count;
+	char *response_data;
+	int bytes_returned;
+	int rc = 0;
 
 	cifs_dbg(FYI, "In FindNext\n");
 
@@ -4641,8 +4642,8 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 		pSMB->ResumeFileName[name_len] = 0;
 		pSMB->ResumeFileName[name_len+1] = 0;
 	} else {
-		rc = -EINVAL;
-		goto FNext2_err_exit;
+		cifs_buf_release(pSMB);
+		return -EINVAL;
 	}
 	byte_count = params + 1 /* pad */ ;
 	pSMB->TotalParameterCount = cpu_to_le16(params);
@@ -4653,71 +4654,61 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_fnext);
+
 	if (rc) {
+		cifs_buf_release(pSMB);
 		if (rc == -EBADF) {
 			psrch_inf->endOfSearch = true;
-			cifs_buf_release(pSMB);
 			rc = 0; /* search probably was closed at end of search*/
-		} else
+		} else {
 			cifs_dbg(FYI, "FindNext returned = %d\n", rc);
-	} else {                /* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc == 0) {
-			unsigned int lnoff;
-
-			/* BB fixme add lock for file (srch_info) struct here */
-			if (pSMBr->hdr.Flags2 & SMBFLG2_UNICODE)
-				psrch_inf->unicode = true;
-			else
-				psrch_inf->unicode = false;
-			response_data = (char *) &pSMBr->hdr.Protocol +
-			       le16_to_cpu(pSMBr->t2.ParameterOffset);
-			parms = (T2_FNEXT_RSP_PARMS *)response_data;
-			response_data = (char *)&pSMBr->hdr.Protocol +
-				le16_to_cpu(pSMBr->t2.DataOffset);
-			if (psrch_inf->smallBuf)
-				cifs_small_buf_release(
-					psrch_inf->ntwrk_buf_start);
-			else
-				cifs_buf_release(psrch_inf->ntwrk_buf_start);
-			psrch_inf->srch_entries_start = response_data;
-			psrch_inf->ntwrk_buf_start = (char *)pSMB;
-			psrch_inf->smallBuf = false;
-			if (parms->EndofSearch)
-				psrch_inf->endOfSearch = true;
-			else
-				psrch_inf->endOfSearch = false;
-			psrch_inf->entries_in_buffer =
-						le16_to_cpu(parms->SearchCount);
-			psrch_inf->index_of_last_entry +=
-				psrch_inf->entries_in_buffer;
-			lnoff = le16_to_cpu(parms->LastNameOffset);
-			if (CIFSMaxBufSize < lnoff) {
-				cifs_dbg(VFS, "ignoring corrupt resume name\n");
-				psrch_inf->last_entry = NULL;
-				return rc;
-			} else
-				psrch_inf->last_entry =
-					psrch_inf->srch_entries_start + lnoff;
-
-/*  cifs_dbg(FYI, "fnxt2 entries in buf %d index_of_last %d\n",
-    psrch_inf->entries_in_buffer, psrch_inf->index_of_last_entry); */
-
-			/* BB fixme add unlock here */
 		}
+		return rc;
+	}
 
+	/* decode response */
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	if (rc) {
+		cifs_buf_release(pSMB);
+		return rc;
 	}
+	/* BB fixme add lock for file (srch_info) struct here */
+	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
+	response_data = (char *)&pSMBr->hdr.Protocol +
+		le16_to_cpu(pSMBr->t2.ParameterOffset);
+	parms = (T2_FNEXT_RSP_PARMS *)response_data;
+	response_data = (char *)&pSMBr->hdr.Protocol +
+		le16_to_cpu(pSMBr->t2.DataOffset);
 
-	/* BB On error, should we leave previous search buf (and count and
-	last entry fields) intact or free the previous one? */
+	if (psrch_inf->smallBuf)
+		cifs_small_buf_release(psrch_inf->ntwrk_buf_start);
+	else
+		cifs_buf_release(psrch_inf->ntwrk_buf_start);
 
-	/* Note: On -EAGAIN error only caller can retry on handle based calls
-	since file handle passed in no longer valid */
-FNext2_err_exit:
-	if (rc != 0)
-		cifs_buf_release(pSMB);
-	return rc;
+	psrch_inf->srch_entries_start = response_data;
+	psrch_inf->ntwrk_buf_start = (char *)pSMB;
+	psrch_inf->smallBuf = false;
+	psrch_inf->endOfSearch = !!parms->EndofSearch;
+	psrch_inf->entries_in_buffer = le16_to_cpu(parms->SearchCount);
+	psrch_inf->index_of_last_entry += psrch_inf->entries_in_buffer;
+	lnoff = le16_to_cpu(parms->LastNameOffset);
+	if (CIFSMaxBufSize < lnoff) {
+		cifs_dbg(VFS, "ignoring corrupt resume name\n");
+		psrch_inf->last_entry = NULL;
+	} else {
+		psrch_inf->last_entry =
+			psrch_inf->srch_entries_start + lnoff;
+	}
+	/* BB fixme add unlock here */
+
+	/*
+	 * BB: On error, should we leave previous search buf
+	 * (and count and last entry fields) intact or free the previous one?
+	 *
+	 * Note: On -EAGAIN error only caller can retry on handle based calls
+	 * since file handle passed in no longer valid.
+	 */
+	return 0;
 }
 
 int
-- 
2.53.0



