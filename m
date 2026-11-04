Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829088;
	b=upuEhOb5Vam/CGKlaz01EshtGlP3Ohd40mWJ3h++1bXHmvqIuRl/BX9JTB2zB8dyJ8lS
	 fCnU7HC/vMN7iKIPajOBY362nc3Uaj7H3HZJPKXHbOVlfwJii2zZolRDTlYbpy6wzhD+1
	 qwedTs3nvsP6hQ5Lo6Ybpqz9nWMuQXSzno6372qcbBh6+pahesalVCD/EMkbAx2beMmlD
	 aZILbjRlbY1u3O3p4kmlOOx7nd3fOPHM30s4k0ohGID2cog0hv2PU4RjntDXE4QUA7qIi
	 KdgQbUOna9N5UaavcGIV/rRRG7Rml8oDsq8DZQT3Czzk9G7dyF/v3wd19RQ0//ds7mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U7EjvRqKgkMsSmZ1a6VxPc5Ju4qWQhxbKybkfSTgSNQ=;
	b=VVBioPhRJTZtere/Tf3bZzV6Jv5g9fumnRjZmNBeUv90rVhXsvDk6yW/wka/VL+nS5Lo
	 fTYwBlNsZtBGLsgLcOW4Zxz9Jr2Dh6XJVqsB4Y5blqijQCbI+tyTGGu42pIu0SN5DlRMF
	 UUL17KH8k1eB1dd+QMEcm994bYFn7gAKKMWsTuLNVAQ2HmL+VXLKQwewHZYY/Sy4hs208
	 RtxQLYReCpAaMpCroxtuuT8TS6qQq3WQZcwgmEO5XLsKp+sogO8rpiQqTxL3xPQvny4o6
	 QAFh2V212LPufHin1Oxtzsn6lF3pMdSZJIFifQs6aZRe9eYMo3e8q0eGAlSSDau3UEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYRUZZ+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80D26072F96;
	Wed,  4 Nov 2026 21:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYRUZZ+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569221F000C1;
	Wed,  4 Nov 2026 21:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829087;
	bh=U7EjvRqKgkMsSmZ1a6VxPc5Ju4qWQhxbKybkfSTgSNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYRUZZ+XOIcNtubTYvJZ/RSmWBZp/Iq2EAjn2zXLf5oBUDsBUBokCOa79W7Yz15ah
	 IQpqLqzDFl1vuYVy0w5uwbU1nsHVRFtRSBeq05QeRy782O1mrhZcjjnlOEOrqCeEtR
	 j3IbEPSnQeGHUHa3Ye/ZLx1jaaut8JxFnzof0S7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 387/547] smb: client: reject short SESSION_SETUP responses
Date: Wed,  4 Nov 2026 16:09:31 -0500
Message-ID: <20261104211049.294526047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdifatah Suruur <suruurism@gmail.com>

commit 4d8930afa3446041358a7db33e7b23a0bb9459b5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2misc.c |   16 ++++++++++++++++
 fs/smb/client/smb2pdu.c  |   10 ++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -225,6 +225,22 @@ smb2_check_message(char *buf, unsigned i
 		return 1;
 	}
 
+	/*
+	 * A SESSION_SETUP response that asks for more processing carries a
+	 * security blob and is parsed as a normal reply. Do not let the
+	 * short-error path below accept a frame that cannot hold the fixed
+	 * response fields; the minimum-PDU check later is unreachable once
+	 * the early return has accepted the frame.
+	 */
+	if (command == SMB2_SESSION_SETUP_HE &&
+	    shdr->Status == STATUS_MORE_PROCESSING_REQUIRED &&
+	    len < smb2_min_pdu_len[command]) {
+		cifs_server_dbg(VFS,
+				"%s: session setup response too short: %u < %zu\n",
+				__func__, len, smb2_min_pdu_len[command]);
+		return 1;
+	}
+
 	if (len < pdu_size) {
 		if ((len >= hdr_size)
 		    && (shdr->Status != 0)) {
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1860,14 +1860,20 @@ SMB2_sess_auth_rawntlmssp_negotiate(stru
 		goto out;
 
 	u16 boff = le16_to_cpu(rsp->SecurityBufferOffset);
+	u16 blen = le16_to_cpu(rsp->SecurityBufferLength);
 
 	if (offsetof(struct smb2_sess_setup_rsp, Buffer) != boff) {
 		cifs_dbg(VFS, "Invalid security buffer offset %d\n", boff);
 		rc = smb_EIO1(smb_eio_trace_sess_buf_off, boff);
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
 


