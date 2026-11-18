Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044776;
	b=yuDQ3U/hrI1Q65Lmthg/UwQrdJPNM/mFx3d/CRNV5rc+cl268JvzsCSKBDh+yyF5Urk3
	 /6SbPvPHkPuRZ8KyWIaZjcXVrXqffYTvSYqXScUNrWRVE3EdtoYdnz+xdHCPpV4+Drt/N
	 AGQwi3786M0KvULIoxz2zLuDVJZYVG1gtEIDFj2Sr/0nE4Av26hESAwo/S7/EZt8m3+tQ
	 DfjBlkvNJRf/OQdV26bw5QboiJz9s+tu7RkVIwFNBmbVC2bGoXpk120v073yUjQ6MkBsT
	 dubCPY7KG0pvL9zPs4yPoSxNB+0Zuup5pWXBkOKWedISqwakPlCYUQt88A2nX5YxeFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=faVNDaqkuwhIZ55WE4U4LJJPaqRfHdeqUvdoqRk1TaY=;
	b=4Nz9elMrBbkJJ2E2ojAqL9Jv7GsbAR/HWYndHZL7zyJTcUYy6+ha8VdK+R6k/6eDwAz1
	 GCamacQLXNv8EXUlbejc6zo1QQDsOLtqni3ZiAJuBA7AC78ozs+j9g/wNMzir+F9pece/
	 8hFcWfmFa/hticFXpFYi84fvIuJTX2LryNbz4NYFhutUa86DSk86d6Nsf5UtiX7cMdRSg
	 PWdjFz1N1gd6lOPO+BQ6LGANAd2bTPH7so9rOqg1j+AadPb3OeAsEL7tCPq0I/RbH0d5Z
	 WM8tlEFSR3PpAkbzPwtRkum/5ggbu9JiKP55DXvXa9JuNsAh2pUj7b1FwTbNQrRxksQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSmnwazp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77E7606D65D;
	Wed, 18 Nov 2026 23:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSmnwazp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B29D1F000C6;
	Wed, 18 Nov 2026 23:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044776;
	bh=faVNDaqkuwhIZ55WE4U4LJJPaqRfHdeqUvdoqRk1TaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSmnwazpouiRJetwe+YKvLzNqIdO4wM1/ofrBWejs+ySFsPMxsDrBn5BVDua4ka9W
	 hA0lUBp4NBDfYndbYgv2mzksK0n+73e/Z/lBgkFGlLP9ZSmiTiiHRtKemrEZmDcP3W
	 n2J0V/50+10Iuc23LCeBRRSZdtFvtm3iu576DmSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0689/2857] smb: client: fix warning in CIFSFindFirst()
Date: Wed, 18 Nov 2026 15:28:43 +0100
Message-ID: <20261118150226.367716821@linuxfoundation.org>
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
 fs/smb/client/cifssmb.c |   98 +++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 54 deletions(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3904,11 +3904,12 @@ CIFSFindFirst(const unsigned int xid, st
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
 
@@ -3999,63 +4000,52 @@ findFirstRetry:
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
-
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
-
-			psrch_inf->last_entry = psrch_inf->srch_entries_start +
-							lnoff;
-
-			if (pnetfid)
-				*pnetfid = parms->SearchHandle;
-		} else {
-			cifs_buf_release(pSMB);
-		}
+		return rc;
+	}
+	/* decode response */
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	if (rc) {
+		cifs_buf_release(pSMB);
+		return rc;
 	}
 
-	return rc;
+	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
+	psrch_inf->ntwrk_buf_start = (char *)pSMBr;
+	psrch_inf->smallBuf = false;
+	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol +
+		le16_to_cpu(pSMBr->t2.DataOffset);
+
+	parms = (T2_FFIRST_RSP_PARMS *)((char *)&pSMBr->hdr.Protocol +
+					le16_to_cpu(pSMBr->t2.ParameterOffset));
+	psrch_inf->endOfSearch = !!parms->EndofSearch;
+
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
+	}
+	return 0;
 }
 
 int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,


