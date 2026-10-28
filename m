Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208494;
	b=WiqYrUx+rPZxSdZp654/CZde9k9TCjYJR52XLHRvGTcGT1DNMvOe61dW5qzLCMuEIOuF
	 TXpPZl4dmOs6ULNhK3M2Hh2+/yNFLOwMQwSXUrFU/Bm/4c9/jW2lbkEjZO4u3tB/VokLv
	 g1UoUQZCh/pOtrNtYGUONoMRx96JeVyL46EnwdeOxKYe2fQO7tHG4+KCXMRHr30Y6+Tjt
	 Nnm8YmWnFTF32V47nL6iwhuDNPbxReLZFCOEKOnx2U73NE+2UdMHDji7oXPzgq7Sigkm7
	 Yd/laMc/u5YO4zqOd1943Aoj+iY2n9YF6tvpm/4BYcaA/xrDRiPMGzL0L+mii44Zk5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=orC65NmW6soQt6SIbDhYdKzMCGVlX7TPGR7VgPXMMqc=;
	b=xR7DlzpF7tQy+DisYRYBOlXYH2TF/gh+8mofwF7ZrRma4AypLJ9ohaMyufIxGuvY+b5L
	 vRJCcNfSxZSfpbbN8z3Bi85vEN2t/fpn8oJTtT3A7XpIJ4f/pykjhRhIV6gA6RlOQRLls
	 rbUisQlL+AQqIK+3uUwLFZYJyzLYT9Lei05Nl4aBvKltaVy7VCjhL+tkMPjDcXo6ltK+h
	 qT3U9TgCxtUnN9NIRt91D3BNTB4YjU9hGWPutff8gOfInPrRFvoeALqG/AfXIMgGoqZuA
	 GCbjWnn6e8vbHUaYCyt7MFSowz/pJUb15QdOQYkDfSJyfNjSCLO9S/vYwcH/sPm9XHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYn4+CFE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F983606A31A;
	Wed, 28 Oct 2026 17:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYn4+CFE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FB51F01825;
	Wed, 28 Oct 2026 17:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208494;
	bh=orC65NmW6soQt6SIbDhYdKzMCGVlX7TPGR7VgPXMMqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYn4+CFERu48m0WIF0Dg5uuxbaPhFS37yh8KWnU9FM2jA8jOKjY3sorLu+OnxfMTn
	 Xffto8Wsa90zmb/lzJUNnGRzMgD/Dsp8cOaLD2jV0Tbja3n0gGPNX0RwRzZKHe/rdv
	 wLZqpsKa70DwQEYDKhbGQSYjhzKmKFBaNFb+vKWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/516] smb: client: close completed creates on compound wait errors
Date: Wed, 28 Oct 2026 17:54:49 +0100
Message-ID: <20261028170006.756352534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit 6c5c547f037bc18f0b8d0b5db5a648f8f630ce85 ]

compound_send_recv() waits for responses in order. If a later wait is
interrupted, or if a later MID fails during response synchronization, an
earlier CREATE may already have opened a remote handle. The earlier mid
is then released without invoking handle_cancelled_mid(), leaving the
remote handle open because no FID was copied to the caller.

Mark completed earlier mids as cancelled when a compound wait or MID
synchronization aborts. Keep their response buffers attached while the
MIDs are synchronized, and transfer them only after synchronization of
the processed responses, so the release path can inspect successful
CREATE responses and queue SMB2_close() after a later failure. Account for
a remote open only after the close work is allocated and before it is
queued, since the caller has not yet updated num_remote_opens. Mark the
create+close compound used by smb2_unlink() so it is not closed again.
Non-CREATE responses and compounds that already include a close keep their
existing behavior.

Fixes: e0bba0b85481 ("cifs: add compound_send_recv()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ adapted MID cancellation to use 5.10’s GlobalMid_Lock and MID_WAIT_CANCELLED flag. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2misc.c  |  9 ++++--
 fs/cifs/transport.c | 70 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 2013489431ac1..76670fb299859 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -803,7 +803,8 @@ smb2_cancelled_close_fid(struct work_struct *work)
  */
 static int
 __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
-			    __u64 persistent_fid, __u64 volatile_fid)
+			    __u64 persistent_fid, __u64 volatile_fid,
+			    bool account_remote_open)
 {
 	struct close_cancelled_open *cancelled;
 
@@ -817,6 +818,8 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
 	cancelled->cmd = cmd;
 	cancelled->mid = mid;
 	INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
+	if (account_remote_open)
+		atomic_inc(&tcon->num_remote_opens);
 	WARN_ON(queue_work(cifsiod_wq, &cancelled->work) == false);
 
 	return 0;
@@ -849,7 +852,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	rc = __smb2_handle_cancelled_cmd(tcon, SMB2_CLOSE_HE, 0,
-					 persistent_fid, volatile_fid);
+					 persistent_fid, volatile_fid, false);
 	if (rc)
 		cifs_put_tcon(tcon);
 
@@ -877,7 +880,7 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
 					 le16_to_cpu(hdr->Command),
 					 le64_to_cpu(hdr->MessageId),
 					 rsp->PersistentFileId,
-					 rsp->VolatileFileId);
+					 rsp->VolatileFileId, true);
 	if (rc)
 		cifs_put_tcon(tcon);
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 9b0fa5fd965a2..3332e1b232b1f 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1033,6 +1033,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   int *resp_buf_type, struct kvec *resp_iov)
 {
 	int i, j, optype, rc = 0;
+	int num_processed = 0;
 	struct mid_q_entry *midQ[MAX_COMPOUND];
 	bool cancelled_mid[MAX_COMPOUND] = {false};
 	struct cifs_credits credits[MAX_COMPOUND] = {
@@ -1166,6 +1167,17 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			break;
 	}
 	if (rc != 0) {
+		/*
+		 * A completed CREATE earlier in the compound chain may have
+		 * opened a remote handle even though a later wait was
+		 * interrupted. Mark it cancelled so the mid release path
+		 * invokes the existing unmatched-open cleanup.
+		 */
+		spin_lock(&GlobalMid_Lock);
+		for (j = 0; j < i; j++)
+			midQ[j]->mid_flags |= MID_WAIT_CANCELLED;
+		spin_unlock(&GlobalMid_Lock);
+
 		for (; i < num_rqst; i++) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
 				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
@@ -1188,6 +1200,17 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 		rc = cifs_sync_mid_result(midQ[i], server);
 		if (rc != 0) {
+			/*
+			 * A previous CREATE may have completed before this
+			 * response failed. Mark it cancelled so its remote
+			 * handle is closed when the mid is released.
+			 */
+			spin_lock(&GlobalMid_Lock);
+			for (j = 0; j < i; j++)
+				midQ[j]->mid_flags |= MID_WAIT_CANCELLED;
+			spin_unlock(&GlobalMid_Lock);
+			/* Keep their response buffers for cancelled-mid cleanup. */
+			num_processed = 0;
 			/* mark this mid as cancelled to not free it below */
 			cancelled_mid[i] = true;
 			goto out;
@@ -1197,32 +1220,48 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		    midQ[i]->mid_state != MID_RESPONSE_READY) {
 			rc = -EIO;
 			cifs_dbg(FYI, "Bad MID state?\n");
+			spin_lock(&GlobalMid_Lock);
+			for (j = 0; j < i; j++)
+				midQ[j]->mid_flags |= MID_WAIT_CANCELLED;
+			spin_unlock(&GlobalMid_Lock);
+			num_processed = 0;
 			goto out;
 		}
 
-		buf = (char *)midQ[i]->resp_buf;
-		resp_iov[i].iov_base = buf;
-		resp_iov[i].iov_len = midQ[i]->resp_buf_size +
-			server->vals->header_preamble_size;
-
-		if (midQ[i]->large_buf)
-			resp_buf_type[i] = CIFS_LARGE_BUFFER;
-		else
-			resp_buf_type[i] = CIFS_SMALL_BUFFER;
-
 		rc = server->ops->check_receive(midQ[i], server,
 						     flags & CIFS_LOG_ERROR);
+		num_processed = i + 1;
+	}
 
-		/* mark it so buf will not be freed by cifs_delete_mid */
-		if ((flags & CIFS_NO_RSP_BUF) == 0)
-			midQ[i]->resp_buf = NULL;
-
+out:
+	/*
+	 * Delay moving response buffers out of their mids until response
+	 * synchronization completes. This lets cancelled-mid cleanup inspect
+	 * an earlier CREATE response if a later MID fails.
+	 */
+	if (resp_iov) {
+		for (i = 0; i < num_processed; i++) {
+			buf = (char *)midQ[i]->resp_buf;
+			resp_iov[i].iov_base = buf;
+			resp_iov[i].iov_len = midQ[i]->resp_buf_size +
+				server->vals->header_preamble_size;
+
+			if (midQ[i]->large_buf)
+				resp_buf_type[i] = CIFS_LARGE_BUFFER;
+			else
+				resp_buf_type[i] = CIFS_SMALL_BUFFER;
+
+			/* mark it so buf will not be freed by cifs_delete_mid */
+			if ((flags & CIFS_NO_RSP_BUF) == 0)
+				midQ[i]->resp_buf = NULL;
+		}
 	}
 
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP)) {
+	if (num_processed == num_rqst &&
+	    ((ses->status == CifsNew) || (optype & CIFS_NEG_OP))) {
 		struct kvec iov = {
 			.iov_base = resp_iov[0].iov_base,
 			.iov_len = resp_iov[0].iov_len
@@ -1232,7 +1271,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&server->srv_mutex);
 	}
 
-out:
 	/*
 	 * This will dequeue all mids. After this it is important that the
 	 * demultiplex_thread will not process any of these mids any futher.
-- 
2.53.0



