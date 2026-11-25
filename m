Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625147;
	b=Af73M5y4E/dyYhpfauTVma3faFfd3faxYF32niaLaWCze5/atdAyiOy5DGPyJINUrKjt
	 9v73uTKTQKbLsVp5fQ0MTUXt7Eh9v0StRR2hlLr1cKXFkdl+hxwXuiOSH/V/v0RLUdSn1
	 RAUZix+twZF1dSVIZ67fBNbdx3VoXWYJsmKXZcOBliIgdekBsxAm3N2Wk9nqw/83n3ARY
	 6xeQdWg3d8pSoONyL3M//ZGc1e9tuCqh00eZ37D2HXAr9xeI+n9cQ+wadMQb/IqeVXw9L
	 DQXLOPh2zYuArqBhCW+edCAIKopMW7uTrqkFRmoaAw3uWCBwTPXJLV+swf3AOuYcmYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zRqy4K4wIXueb/cygVwHFiFM60mm9ukbbthX8HOkWtg=;
	b=N0E+SiFBhGZclJRrq0IBnplFBtGWoWzNWk5AMTngc1fFH0LGeyTPwO/78EGA0radcVVa
	 zhxBQS/iWI27euBH/xRLG1eWKjPDqSl+hFmhO7XYuKFJ4wp/kbDVfaB1cB3yju5+D8cAl
	 A3tSyErI0JIfRLkupibsNE1sZRWmz/XsKNjEMGn6WwHC3sMJRL/E9i7zgIYOnAp9i3mfY
	 AkuM/M0H2KMnnL0hOtW9filPbZWSHHZ2arCTCrMO2muf+xuRCjG4kKuYHE8hQ6eZrKfQI
	 9DMfIfd06EeFk7Jj31PVJQPJFPPpYq4yKJMsWt2/e9dtaYLsOel4nfPThR64tx38A0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vXnDMaGB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42661606A33A;
	Wed, 25 Nov 2026 16:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vXnDMaGB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F46B1F000CF;
	Wed, 25 Nov 2026 16:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625146;
	bh=zRqy4K4wIXueb/cygVwHFiFM60mm9ukbbthX8HOkWtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXnDMaGBPsKwiA8zEPcFBRObSfaCh89HTgzMUkuGBFUNmgfOwpBk4edh/Bm4CIY26
	 vO+xk4U427JkuSbaM3Cr9wfEpc5F4XDb9crpIeDksE8aUmdcpEotOxeYta/lg57SkV
	 kFp6iie/hvUzcG8mG0FJHrBTlvQrGixiwPFMqHFM=
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
Subject: [PATCH 6.12 367/816] smb: client: reclaim credits for decrypted reads with no matching mid
Date: Wed, 25 Nov 2026 15:31:55 +0100
Message-ID: <20261125143857.693013990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context in cifsproto.h, since this tree still declares prototypes with extern, while the code changes match upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h | 1 +
 fs/smb/client/connect.c   | 3 +--
 fs/smb/client/smb2ops.c   | 6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index e2a7d55a2502d..4dfaa59b152b7 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -145,6 +145,7 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 				      bool mark_smb_session);
 extern int cifs_reconnect(struct TCP_Server_Info *server,
 			  bool mark_smb_session);
+void smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server);
 extern int checkSMB(char *buf, unsigned int len, struct TCP_Server_Info *srvr);
 extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 82a70370a60f8..162dededef392 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1153,8 +1153,7 @@ cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return 0;
 }
 
-static void
-smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
+void smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buffer;
 	int scredits, in_flight;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index b1a2ada2b5c77..8dadf5f1e20f0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5165,9 +5165,10 @@ static void smb2_decrypt_offload(struct work_struct *work)
 
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
@@ -5290,6 +5291,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 	*mid = smb2_find_mid(server, buf);
 	if (*mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
+		smb2_add_credits_from_hdr(buf, server);
 		rc = -1;
 	} else {
 		cifs_dbg(FYI, "mid found\n");
-- 
2.53.0



