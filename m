Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052072;
	b=GVAP+vfVdTFvHJMIcjvrrn0rpf4cijOWlpnjiXwbbMNnBOELsaR/2/oYso/6z/lWoYuA
	 08r8dym+vAi1Nai4pEfU1PwC4tOj0rqNP4xaTSof1/XP9Bcoqk13qQVx81egl62tAQ6cW
	 lTBn9diYCZSlcClPkC81hGwQGFZeDWytj68eEAR8qz1i4h+HCWWTyHuqhh09QPmMCRHzw
	 LYPCGoTRaL9OQX5A/pvVLTryFkA9HCRaZO1oUhwOTHI4JN2uU7A5mL5nrq2LlcbcrkraZ
	 Fv2UI845O8YnGXXk/iA3/IHhGxIZUorzhsLvBkpPPzjc3Y8tS/7OTGvPVGxBveviF2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7sOr08JGbKt7PZzdlnBUA2fQZBCigpICW/vJithZXLY=;
	b=dU76gbcvC568Swanlz9ELjtfMFtC24hAToA8fgw1IG5xq6XIH6ZOd7EgSRj85y521Chs
	 X7asl/sdHZAqiTxQoJXzutffDhpNQIebk/6I1wob3XGl5ges+4UgZa3GIP3MWFjwaCi57
	 pgTL0RwnIFC1P2evhYAcySvBcnEWFml7MQ8rQgVBZOZ/IK+RQl8vK2CHb2/fPn9bhNv49
	 2dR4Kne7Zcj+ga+Pu75ahyb665KkOtWrCjMjsGwNF0tWNns8FGMW0Y6NZA2VBam+Ua4mq
	 SpzkZHDbmt50zhfnv57X+Xi0BEUBcQzMMe8Y45fFfXbWrbVBWRWEf3DlQj3IO9ZwC5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lkrYAmIR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD901606A31C;
	Thu, 19 Nov 2026 01:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lkrYAmIR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCEC1F000C4;
	Thu, 19 Nov 2026 01:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052072;
	bh=7sOr08JGbKt7PZzdlnBUA2fQZBCigpICW/vJithZXLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkrYAmIRC/AjWDQvRDbStKSc7KvfpMjmoEFkdSNseC/HuJSck/su1I3Pfqv6zcFLA
	 Kl8VaBif0i42DyIctjkkbUfarsXVqXqmnBg/7JEFDDVGdBmoov0GZOFBANXfDSCVDJ
	 IgMCSf2BjjKUjnWdNph/bSLUgMMwaIf/rfQGdUQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0417/2214] smb: client: fix warning in CIFSFindFirst()
Date: Wed, 18 Nov 2026 15:34:53 +0100
Message-ID: <20261118150027.540309156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 032137fe136a6073dcc699ee15fa3fd05fd77f21 ]

This fixes the following warning reported by kernel test robot

  fs/smb/client/cifssmb.c:4089 CIFSFindFirst() warn: missing error
  code? 'rc'

Link: https://lore.kernel.org/all/202306170124.CtQqzf0I-lkp@intel.com/
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 59131dd72f62 ("smb: client: fix use-after-free infoleak via the readdir resume name")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 94 +++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 52 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 11a400663b9f2..36ed6906066ea 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4333,11 +4333,12 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	TRANSACTION2_FFIRST_REQ *pSMB = NULL;
 	TRANSACTION2_FFIRST_RSP *pSMBr = NULL;
 	T2_FFIRST_RSP_PARMS *parms;
-	int rc = 0;
+	struct nls_table *nls_codepage;
+	unsigned int lnoff;
+	__u16 params, byte_count;
 	int bytes_returned = 0;
 	int name_len, remap;
-	__u16 params, byte_count;
-	struct nls_table *nls_codepage;
+	int rc = 0;
 
 	cifs_dbg(FYI, "In FindFirst for %s\n", searchName);
 
@@ -4428,63 +4429,52 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_ffirst);
 
-	if (rc) {/* BB add logic to retry regular search if Unix search
-			rejected unexpectedly by server */
-		/* BB Add code to handle unsupported level rc */
+	if (rc) {
+		/*
+		 * BB: add logic to retry regular search if Unix search rejected
+		 * unexpectedly by server.
+		 */
+		/* BB: add code to handle unsupported level rc */
 		cifs_dbg(FYI, "Error in FindFirst = %d\n", rc);
-
 		cifs_buf_release(pSMB);
-
-		/* BB eventually could optimize out free and realloc of buf */
-		/*    for this case */
+		/*
+		 * BB: eventually could optimize out free and realloc of buf for
+		 * this case.
+		 */
 		if (rc == -EAGAIN)
 			goto findFirstRetry;
-	} else { /* decode response */
-		/* BB remember to free buffer if error BB */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-		if (rc == 0) {
-			unsigned int lnoff;
-
-			if (pSMBr->hdr.Flags2 & SMBFLG2_UNICODE)
-				psrch_inf->unicode = true;
-			else
-				psrch_inf->unicode = false;
-
-			psrch_inf->ntwrk_buf_start = (char *)pSMBr;
-			psrch_inf->smallBuf = false;
-			psrch_inf->srch_entries_start =
-				(char *) &pSMBr->hdr.Protocol +
-					le16_to_cpu(pSMBr->t2.DataOffset);
-			parms = (T2_FFIRST_RSP_PARMS *)((char *) &pSMBr->hdr.Protocol +
-			       le16_to_cpu(pSMBr->t2.ParameterOffset));
-
-			if (parms->EndofSearch)
-				psrch_inf->endOfSearch = true;
-			else
-				psrch_inf->endOfSearch = false;
+		return rc;
+	}
+	/* decode response */
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	if (rc) {
+		cifs_buf_release(pSMB);
+		return rc;
+	}
 
-			psrch_inf->entries_in_buffer =
-					le16_to_cpu(parms->SearchCount);
-			psrch_inf->index_of_last_entry = 2 /* skip . and .. */ +
-				psrch_inf->entries_in_buffer;
-			lnoff = le16_to_cpu(parms->LastNameOffset);
-			if (CIFSMaxBufSize < lnoff) {
-				cifs_dbg(VFS, "ignoring corrupt resume name\n");
-				psrch_inf->last_entry = NULL;
-				return rc;
-			}
+	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
+	psrch_inf->ntwrk_buf_start = (char *)pSMBr;
+	psrch_inf->smallBuf = false;
+	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol +
+		le16_to_cpu(pSMBr->t2.DataOffset);
 
-			psrch_inf->last_entry = psrch_inf->srch_entries_start +
-							lnoff;
+	parms = (T2_FFIRST_RSP_PARMS *)((char *)&pSMBr->hdr.Protocol +
+					le16_to_cpu(pSMBr->t2.ParameterOffset));
+	psrch_inf->endOfSearch = !!parms->EndofSearch;
 
-			if (pnetfid)
-				*pnetfid = parms->SearchHandle;
-		} else {
-			cifs_buf_release(pSMB);
-		}
+	psrch_inf->entries_in_buffer = le16_to_cpu(parms->SearchCount);
+	psrch_inf->index_of_last_entry = 2 /* skip . and .. */ +
+		psrch_inf->entries_in_buffer;
+	lnoff = le16_to_cpu(parms->LastNameOffset);
+	if (CIFSMaxBufSize < lnoff) {
+		cifs_dbg(VFS, "ignoring corrupt resume name\n");
+		psrch_inf->last_entry = NULL;
+	} else {
+		psrch_inf->last_entry = psrch_inf->srch_entries_start + lnoff;
+		if (pnetfid)
+			*pnetfid = parms->SearchHandle;
 	}
-
-	return rc;
+	return 0;
 }
 
 int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
-- 
2.53.0



