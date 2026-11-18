Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044779;
	b=yygCGiGrDawyCjoyQc2nFD/9PBrvkG0S10Pos8TtGyPqbNp8LWSgsMh1MaO7kgY43VPl
	 cM+f/tHaecKkhPdP8yx4lzVHUYPlRUnNmasBVHqHN+F0E2TzWwX8LGjZwIMwNMMKseS3x
	 YkZ6fKchNld/n/FNwYDKoYoRNrM6a4PPH7BehfRdEJWnbK1JshAxWVj/LnCIBO7GuZzN3
	 rE2s45bdI+Bd6Pqpal1Va+1bTc8DpdMQgpzgdfSNsxCKGXEft7wWUyhaICVoGjyrwKYlA
	 bVBJmgD2giWV7jLxjhvnLW32KXpKZQe6xWVe6CPDa6bTU5c2G2K220gCuwxMNFiC/1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LmbUZ8Rm3ogctvgXaZBI3Me8Rv1MSPFiGu2xDtzsB78=;
	b=acSMcJSQnjRcAW+aqpk+v5/ajzz2uEvlJZUhTllbQ5xKThNWhB60zHP90sDkAouJBqQm
	 wFASJnYMHn7Bsp6kMn7R7c5HZzxm+78pX8+zo6vzCnKHsMFnIe+Cy+lGoPJOCgyewdrtt
	 S0O3InXE5Vb3KsTeSmA8aokBKyp94wjtTJHkmJDh+JStWTkDnXelTVcStsiGPNWkDaOZG
	 F27+39DT1ZUs6pRXYN34n8eUbXIOQIi3nxtk6SwnOyTVynqvvDYjCzVXF+ETe/S4x8W0g
	 c6r0jHyuvH5Zrsf7of4me8VMCZXhJ36/6VVPKeGH74x6mC1BEPg0c9Rz6z+J3plCxeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UvjwFsTa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD276606B9A5;
	Wed, 18 Nov 2026 23:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UvjwFsTa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0611F000C4;
	Wed, 18 Nov 2026 23:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044779;
	bh=LmbUZ8Rm3ogctvgXaZBI3Me8Rv1MSPFiGu2xDtzsB78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvjwFsTakFuMo+aHwKllOAy0E8Wnh2ehDB10/X92Mux5WOjUmQ2lUrnYgnYVrp7UO
	 gD/JG+RVushNJuEydAfzyFNT5I1kscRSxIc/CAcZLFkTj2zw1iZCOYiHOkOWI8uvnV
	 yLI2SlQIVV+zJ3CkxkKBBHVdIQI0o71Gyypd3zmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0690/2857] smb: client: fix warning in CIFSFindNext()
Date: Wed, 18 Nov 2026 15:28:44 +0100
Message-ID: <20261118150226.404445133@linuxfoundation.org>
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
 fs/smb/client/cifssmb.c |  113 ++++++++++++++++++++++--------------------------
 1 file changed, 52 insertions(+), 61 deletions(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4055,11 +4055,12 @@ int CIFSFindNext(const unsigned int xid,
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
 
@@ -4104,8 +4105,8 @@ int CIFSFindNext(const unsigned int xid,
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
@@ -4116,71 +4117,61 @@ int CIFSFindNext(const unsigned int xid,
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
-
+		return rc;
 	}
 
-	/* BB On error, should we leave previous search buf (and count and
-	last entry fields) intact or free the previous one? */
-
-	/* Note: On -EAGAIN error only caller can retry on handle based calls
-	since file handle passed in no longer valid */
-FNext2_err_exit:
-	if (rc != 0)
+	/* decode response */
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	if (rc) {
 		cifs_buf_release(pSMB);
-	return rc;
+		return rc;
+	}
+	/* BB fixme add lock for file (srch_info) struct here */
+	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
+	response_data = (char *)&pSMBr->hdr.Protocol +
+		le16_to_cpu(pSMBr->t2.ParameterOffset);
+	parms = (T2_FNEXT_RSP_PARMS *)response_data;
+	response_data = (char *)&pSMBr->hdr.Protocol +
+		le16_to_cpu(pSMBr->t2.DataOffset);
+
+	if (psrch_inf->smallBuf)
+		cifs_small_buf_release(psrch_inf->ntwrk_buf_start);
+	else
+		cifs_buf_release(psrch_inf->ntwrk_buf_start);
+
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


