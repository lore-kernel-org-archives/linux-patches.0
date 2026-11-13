Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590054;
	b=c8D6ZAwiWbiu08r23f8qi1UiUFLjwJCSS9fbIZm28qSnWiXuhxRUqPFVlsPhYHfmiPGx
	 g0mCdLYuGESs1ZmgdwXhN5SUJmnWjDLLSmEYEiLTT4lXyxS7vskZkBHmw+YIq8v9pjg/F
	 0mHGVXpmj5xaET5Gv8UBTpSJupPXRNGM4f1AfLwy1YXgiVcw6ejAuvTaGZrBKF8BPy2eP
	 QEHm9CBOkgAhn7c0I1MPWEfVuBgSNwWalLq9uIV8tnoK/YHwVh+9ih+nqiEKedCLIEwVF
	 igggRi8rmds9GFE6h7uuG1X/jnRQuZuiN0rNf01NHTuOidu0AcQpgw4A/NosrH6GAnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dM+cZrLBBcLQpVXuK1vCUH1wIpAuRysxFPZco5lOIVI=;
	b=u/Aczmd6MMzMwDkgKSb9dl24RtsYZfiJFrXPyWiWnM9opmNCDZw93OHhOX7kqax65qyg
	 8knRiS6rNZq1Op4sxBufqQqd9j99oBsgT23Ei+qaUBUaiIysAApWmLG98XcEJ2nm8c46K
	 fN3GTu4txdolpqsNHQs7tB05/QpPtLm4kWMm+RBT7xy2DHCD7xAUX7ZySidGLWiv0WQb6
	 nDL37ypfBsagtInlfDz+2GS2Hh52Ei7Z6W71H9sQQb6l+ahCpGsx6M0D1sGnV9DPVIYNk
	 b3FmWX17p033FF7Q3gAD03fw5Tdv3xYdqITwNrxptfO6jWBk4gZ7zsmNJmv9knYD49w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCrilFYy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FD6606A880;
	Fri, 13 Nov 2026 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCrilFYy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBB41F000C6;
	Fri, 13 Nov 2026 17:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590054;
	bh=dM+cZrLBBcLQpVXuK1vCUH1wIpAuRysxFPZco5lOIVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCrilFYyxzCYbdFqBFPyQUieqIc9ZaOzpHjKavtOuVz88bISeBbYOODZdp4xVi+vT
	 3MdZfFGGLbYluP1384RavJDXpcplhLFaYzPcwxSwk01tbHz6DFarpe4w9anrGn5fvb
	 Ygkwc193VnYo1H4sRE3H6Dk4hGsUVmp/ULduGFTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/686] smb: client: reclaim credits for decrypted reads with no matching mid
Date: Fri, 13 Nov 2026 10:43:39 -0500
Message-ID: <20261113153823.792842625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 78f73985846465a25a7bd1d89904053661f3ca92 ]

When a decrypted SMB2 READ response carries a MessageId that matches no
outstanding request, both the inline receive_encrypted_read() and the
offloaded smb2_decrypt_offload() paths drop the frame without accounting
the credits the server granted in it.  The plaintext unknown-frame path in
cifs_demultiplex_thread() already reclaims them with
smb2_add_credits_from_hdr(), so encrypted reads leak credits that the
plaintext path would not.

This also happens for legitimate frames - e.g. a reply that arrives after
the client has timed out and dropped the mid - so over a long-lived
connection the client's credit count drifts down and can eventually starve
it of the ability to issue requests.  The frame is AEAD-authenticated, so
the granted credits in the decrypted header come from the real server and
are safe to apply.

Reclaim the credits from the decrypted header before dropping the frame,
and export smb2_add_credits_from_hdr() so the SMB2 receive paths can use it.

Fixes: c42a6abe3012 ("CIFS: Add capability to decrypt big read responses")
Fixes: 35cf94a39728 ("smb3: allow parallelizing decryption of reads")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: adjusted prototype insertion context to preserve existing declaration formatting and extern keywords ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h | 1 +
 fs/smb/client/connect.c   | 3 +--
 fs/smb/client/smb2ops.c   | 6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 325408073888e..d47ad5d86b4b1 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -161,6 +161,7 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 				      bool mark_smb_session);
 extern int cifs_reconnect(struct TCP_Server_Info *server,
 			  bool mark_smb_session);
+void smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server);
 extern int checkSMB(char *buf, unsigned int len, struct TCP_Server_Info *srvr);
 extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 0a60c411aba67..b4e139471e865 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1235,8 +1235,7 @@ cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return 0;
 }
 
-static void
-smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
+void smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buffer;
 	int scredits, in_flight;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 71cf42981ab04..f7f8e8b981f75 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5256,9 +5256,10 @@ static void smb2_decrypt_offload(struct work_struct *work)
 
 	dw->server->lstrp = jiffies;
 	mid = smb2_find_dequeue_mid(dw->server, dw->buf);
-	if (mid == NULL)
+	if (mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
-	else {
+		smb2_add_credits_from_hdr(dw->buf, dw->server);
+	} else {
 		mid->decrypted = true;
 		rc = handle_read_data(dw->server, mid, dw->buf,
 				      dw->server->vals->read_rsp_size,
@@ -5381,6 +5382,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 	*mid = smb2_find_mid(server, buf);
 	if (*mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
+		smb2_add_credits_from_hdr(buf, server);
 		rc = -1;
 	} else {
 		cifs_dbg(FYI, "mid found\n");
-- 
2.53.0



