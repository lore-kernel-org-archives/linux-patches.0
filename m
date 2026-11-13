Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585974;
	b=4phMvTlEV+QjDxXJJMbis8me1vwuh2KXxJKA2XFb86AdVKS46WjKPKZjNCrRgYx+NyNY
	 WpSXKKOj90gOwyqc/elLEAAlPUp/7tXItZpnP+AKWPZKwHR9SXGpx/00Uk6Xecw0RA2Cj
	 dThJ/5J39zdxBhyAJKZompYwTcXmFYnSC9fDWxE+6HFz93TkJYC1DzftlyAl3q4B4+yfw
	 uw9oBtnw7YD7nBUEevAXVnWBlvaoFs6A1sKcM9b6/b/n6WS/Xrtzq8/gBqh+pj3qEvYCM
	 TblkiZhMD/Br7pKTiNvwnZRCaooiWlNk4E/XJ8xMwEJ4bu3C6oUwk6ce/SW9YsGPxXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yDS7t5RLKkrKX8BJbVP7+stXOJiIlP8kPtOtx5OLqsI=;
	b=Ojr2AZgKDaChzmEHNMeaKuryNqjL8Z3+rsntcD+m6BfnIsV5Mo6CNlFt/T4wD7mFHHEb
	 pq5F2JgSUbV+WQ9VGJaK5pJlnH3qWJHmmkmo1J5mkDUZ8TFEjNTn4iP1J+hc7wSlMrRWy
	 0WJ8RPURn7T1VWs4LkEp45742ctER0W7QdkNR2Fmaup3jOSnnkXkHQ731zTg5F3+AjUls
	 y9+UgmCboj/4L22nuSMmdHtKWrITsY6DPjIPgAbH84SKa8yco7pxzROCrhdpX1elo6Q0I
	 57rLf96/QB2qmYDNQZzQyOyOxg2xiSPrjN3dVYvcta8u398NgDhiVqABgL4ShV7KjHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v/0m2oKV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBB36072306;
	Fri, 13 Nov 2026 16:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v/0m2oKV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EBF1F000C4;
	Fri, 13 Nov 2026 16:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585974;
	bh=yDS7t5RLKkrKX8BJbVP7+stXOJiIlP8kPtOtx5OLqsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/0m2oKVE8Ti935k9A+Tvzc/og2IHNMfZPGdXQN5pBBRN2j3/QZGRxztPXIcD7Ktx
	 R9OOIWVXGWEhjnSLnxaEnRbRjf7c9kDpuX5z31pX+fgEixaHkjrZWsJg84T+W7BKNy
	 pkVjS1C0IoaFoVLD+n3wwvUILwp8Ttha0oWZx27c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/686] smb: client: reject short SESSION_SETUP responses
Date: Fri, 13 Nov 2026 10:42:35 -0500
Message-ID: <20261113153821.668612791@linuxfoundation.org>
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

From: Abdifatah Suruur <suruurism@gmail.com>

[ Upstream commit 4d8930afa3446041358a7db33e7b23a0bb9459b5 ]

smb2_check_message() accepts frames shorter than struct smb2_pdu when
the SMB2 status is non-zero, before the minimum-PDU check added by
b4694f269e66d. A 64-byte STATUS_MORE_PROCESSING_REQUIRED SESSION_SETUP
response is therefore accepted even though it cannot contain the
SecurityBufferOffset and SecurityBufferLength fields.

The parser then reads those fields from stale bytes left in the reused
receive buffer by an earlier frame. With a long stale
SecurityBufferLength, decode_ntlmssp_challenge() copies up to about
64 KB from beyond the receive object and sends the data back to the
server in the NTLMv2 AUTHENTICATE target info.

Reject short MPR SESSION_SETUP responses before the short-error path,
and validate SecurityBufferOffset + SecurityBufferLength against the
received response length before decoding the challenge.

The ordering bypass is not new: the short-error early return predates
b4694f269e66d, and the unvalidated SecurityBufferLength read predates
the 2016 raw NTLMSSP split in 166cea4dc3a4, so all supported stable
trees are affected. Reproduced on 6.6.87.2; the path is unchanged on
mainline.

Fixes: 5478f9ba9a34 ("CIFS: Add session setup/logoff capability for SMB2")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: Replaced the unavailable smb2_min_pdu_len lookup with sizeof(struct smb2_sess_setup_rsp). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2misc.c | 15 +++++++++++++++
 fs/smb/client/smb2pdu.c  | 18 ++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 34d2401c6c665..46c98d024f068 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -194,6 +194,21 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 		return 1;
 	}
 
+	/*
+	 * A SESSION_SETUP response that asks for more processing carries a
+	 * security blob and is parsed as a normal reply. Do not let the
+	 * short-error path below accept a frame that cannot hold the fixed
+	 * response fields.
+	 */
+	if (command == SMB2_SESSION_SETUP_HE &&
+	    shdr->Status == STATUS_MORE_PROCESSING_REQUIRED &&
+	    len < sizeof(struct smb2_sess_setup_rsp)) {
+		cifs_server_dbg(VFS,
+				"%s: session setup response too short: %u < %zu\n",
+				__func__, len, sizeof(struct smb2_sess_setup_rsp));
+		return 1;
+	}
+
 	if (len < pdu_size) {
 		if ((len >= hdr_size)
 		    && (shdr->Status != 0)) {
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d0c56caed1626..3302923f98893 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1757,15 +1757,21 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 	if (rc)
 		goto out;
 
-	if (offsetof(struct smb2_sess_setup_rsp, Buffer) !=
-			le16_to_cpu(rsp->SecurityBufferOffset)) {
-		cifs_dbg(VFS, "Invalid security buffer offset %d\n",
-			le16_to_cpu(rsp->SecurityBufferOffset));
+	u16 boff = le16_to_cpu(rsp->SecurityBufferOffset);
+	u16 blen = le16_to_cpu(rsp->SecurityBufferLength);
+
+	if (offsetof(struct smb2_sess_setup_rsp, Buffer) != boff) {
+		cifs_dbg(VFS, "Invalid security buffer offset %d\n", boff);
 		rc = -EIO;
 		goto out;
 	}
-	rc = decode_ntlmssp_challenge(rsp->Buffer,
-			le16_to_cpu(rsp->SecurityBufferLength), ses);
+	if ((u32)boff + blen > sess_data->iov[0].iov_len) {
+		cifs_dbg(VFS, "%s: invalid security buffer length: %u\n",
+			 __func__, blen);
+		rc = -EINVAL;
+		goto out;
+	}
+	rc = decode_ntlmssp_challenge(rsp->Buffer, blen, ses);
 	if (rc)
 		goto out;
 
-- 
2.53.0



