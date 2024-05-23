Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7828214AD3B;
	Thu, 23 May 2024 13:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470593; cv=none; b=Dw86jvhxkbJIMxlHHla3jIVrGw+HRcxjhEz+6JIS5ZtLJRzmtNhFnLyR0wOVy6cDll4drZ63QLuocbbPVdHGicdeVjZTABQeLbCh29JTk4hXseLo8Oi+VYp3iuo1VBNDfU4+YEZRq+E5CSvN4g8B8IPR2Nd4PuLdloCHZs2sUvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470593; c=relaxed/simple;
	bh=+00Z/lijG9kekpYS47u9uJGyrmpEPyN55sPClBBO8wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrfDIMMd49Af8KnnOaguRrR6lIJy8PYi/3x4PO+PtHB71Cd1k2MStr5+qs5lJ+kSAmSHSX9bstR7oZO8nhxXnN0S3X+thx25Ybgga8NTlVw00ltRG1Z50QD5ajTLEdID7SwLloIom9PkwBfmkjcyKgs9QclHIm+jJxiFkwOtwrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czVwYtIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czVwYtIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0400AC4AF0A;
	Thu, 23 May 2024 13:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470593;
	bh=+00Z/lijG9kekpYS47u9uJGyrmpEPyN55sPClBBO8wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czVwYtIHuHlAp8eYes6+5uWmFWaqSPYh1k57oseimRPft4Vf2VvKenJwr9ZEZhNYo
	 YIjP72lgHVG9/g/7l7eqOUaNKo3x7ZDGmdfBWSZ9fn/oNNNGdDBgCytS2lPKWwzK5P
	 jTNhs0VLdS0cZLFG9/NMGO0pZmhXhOmWEEfeyqLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/102] smb3: minor cleanup of session handling code
Date: Thu, 23 May 2024 15:12:33 +0200
Message-ID: <20240523130342.779742281@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit f72d96507640835726d4f5ba26c1c11acbe1bc97 ]

Minor cleanup of style issues found by checkpatch

Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 70a53dde83eec..09bb30610a901 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -108,6 +108,7 @@ cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+
 	if (chan_index == CIFS_INVAL_CHAN_INDEX)
 		return;
 
@@ -119,6 +120,7 @@ cifs_chan_in_reconnect(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+
 	if (chan_index == CIFS_INVAL_CHAN_INDEX)
 		return true;	/* err on the safer side */
 
@@ -130,6 +132,7 @@ cifs_chan_set_need_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+
 	if (chan_index == CIFS_INVAL_CHAN_INDEX)
 		return;
 
@@ -143,6 +146,7 @@ cifs_chan_clear_need_reconnect(struct cifs_ses *ses,
 			       struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+
 	if (chan_index == CIFS_INVAL_CHAN_INDEX)
 		return;
 
@@ -156,6 +160,7 @@ cifs_chan_needs_reconnect(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+
 	if (chan_index == CIFS_INVAL_CHAN_INDEX)
 		return true;	/* err on the safer side */
 
@@ -167,6 +172,7 @@ cifs_chan_is_iface_active(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+
 	if (chan_index == CIFS_INVAL_CHAN_INDEX)
 		return true;	/* err on the safer side */
 
@@ -677,8 +683,7 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses,
 
 	/* Now no need to set SMBFLG_CASELESS or obsolete CANONICAL PATH */
 
-	/* BB verify whether signing required on neg or just on auth frame
-	   (and NTLM case) */
+	/* BB verify whether signing required on neg or just auth frame (and NTLM case) */
 
 	capabilities = CAP_LARGE_FILES | CAP_NT_SMBS | CAP_LEVEL_II_OPLOCKS |
 			CAP_LARGE_WRITE_X | CAP_LARGE_READ_X;
@@ -735,8 +740,10 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
 
 	/* copy domain */
 	if (ses->domainName == NULL) {
-		/* Sending null domain better than using a bogus domain name (as
-		we did briefly in 2.6.18) since server will use its default */
+		/*
+		 * Sending null domain better than using a bogus domain name (as
+		 * we did briefly in 2.6.18) since server will use its default
+		 */
 		*bcc_ptr = 0;
 		*(bcc_ptr+1) = 0;
 		bytes_ret = 0;
@@ -755,8 +762,7 @@ static void unicode_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
 	char *bcc_ptr = *pbcc_area;
 	int bytes_ret = 0;
 
-	/* BB FIXME add check that strings total less
-	than 335 or will need to send them as arrays */
+	/* BB FIXME add check that strings less than 335 or will need to send as arrays */
 
 	/* copy user */
 	if (ses->user_name == NULL) {
-- 
2.43.0



