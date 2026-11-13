Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590855;
	b=XtGMcR/vQVR9U5Rrb8h/6DWb1lYBdqTLrAGjhYw6lIDmcgvxHXxuCcqpdyJpxEdpy2pK
	 bExYWcvSCgDeuzVzAW0a4MfjpqqFhpmsHbKx5edcnjRAerjIvfRuIymtIpTYDleHewpWf
	 CJhhPosEQZWafBUgpxFfw/rYYAkGocT5vwXnFI2eiynDa8y80bE0B60Ne3iCx9LK7GysV
	 TVKugPmy3o1xK3nR5p6z7g02MYvM5n1ZVXQjhCrIqJGgauQ12hxEIh91rLBCGAaXWclym
	 l+Wlb+3zJBlJk80+UrFCGDof3RGXsAV/UWdKreDxW1Q5l/yiJGKzuE/uYCgl0dPDXyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/8igJt5UeA1A4KkE660umj9v80LD6y/xuRDEuA+wWW0=;
	b=3i1/+PvbjfnwO7GZBNKoozWQQYNw3qjQGgF1CGJwUl9t12fBgMInAhNHoXw2dVxwK+je
	 hlsf2/4KvWTxwiuddzQGyl3iLVpTmMG+4wfA4J+517enREzCmE/3ZhiYsYNgwQVo+nc3n
	 /7AcezXR4JwcCpHxVHn3FazkcuKtg9HNsQhCKcYYwhDQBh+Bdl0EWGaEXSJ9Kg19wwkMK
	 t0JzrCN97TuVDrr0PXy34cOsM2XHctGFCgiSXdcEqkakMdEQk7A9kJFrRfJjx1BrdJY1a
	 TQ232BW97VpJUqOkvXgOiyKfTVjywSStVVs0meLyQ+QT4qzQAEyrqcAfGeOmTaL6M8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSPZhNRc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBD8606D482;
	Fri, 13 Nov 2026 17:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSPZhNRc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D151F000C4;
	Fri, 13 Nov 2026 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590855;
	bh=/8igJt5UeA1A4KkE660umj9v80LD6y/xuRDEuA+wWW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSPZhNRc7BOmJfgCP3oekmiSlCR/wAqxJW8PssRDuuwweQCm9MWaPfFlU9Hn9aUtq
	 fba5IrXOqDuHFvY8JQjVv91bN71+MLYm1TtbVaYMTIaSt5KAKMddQC/g8mPQnp5805
	 DVLBdBxLE72Fz18qGf/gpEUnXpUkfQxGNlmBpTwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/670] smb: client: reject short SESSION_SETUP responses
Date: Fri, 13 Nov 2026 10:42:58 -0500
Message-ID: <20261113153811.667228042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2misc.c | 15 +++++++++++++++
 fs/smb/client/smb2pdu.c  | 18 ++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 23320b794b177..7be338ad755b1 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -193,6 +193,21 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
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
index bcfb75fab2c72..8e72506a24099 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1773,15 +1773,21 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
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



