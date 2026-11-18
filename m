Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044748;
	b=sdfJy6W9bIDJQDPWsc20J6JI2LGqFQAnqL4yoQrhrhpo3vEIyeN2rmW2LZbPcMAe/sBL
	 1xq68MbPTp1/7z3lys9SetcUeedgaMJKOVmTenohSrJHn8dbPUtQl1NdiNy31el+2wsFJ
	 MjOcAT8YbVkyHKilL8IhpyzceGpR1oP8rUyqPcdI8/JWRkIap2s3ku6Soy30mxow9cXxU
	 PyucLk7ifSMyl0g5GF8x1aRtqG0d2Hk5fBmyPiaeBUkQJG4VUpwRGhDTXguut1fPZRK+B
	 +8Hho/6Dt9Yok7FqwYUlCxXABpLdV2uMjeBHvSXrRqigomLnQpHZVZTINl7bH5VnLQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8NAtA4H7iSwZiWUjMUaCkIrUqzt1FlmQCTETaFmZL90=;
	b=FdduhHedSRg8Hn3tuh4kXHNJy9mlkYBVerVYQhaH5A5rnskeBVgy/jPUd7834YwbvR4c
	 E222sENAadY+F6wmyGjJLJNudL+pfasxi1/ya+sxrqeTTH1Vw3mtlD1Z4xj5LmtvmhcVN
	 6ltVz4s50cY6BKW67FD4aUB+DCYTh3JU5ifmJTWKn/o+6LRz2d9dHjdK9W059E9qi0Zgf
	 1KJweHJHGbgIJS/Qg2MI2VnwuPMWUi3RtC7t9i5DzESVeGDI/Uzo/Jz9oLVuiuGlBJiXu
	 Z9oe6U8xB8Ey1Z4RUFAog5w4xR0ugojqagXqVf3KFEddkZkWjvC6VvlvMpTdSw4C7wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1vpT0j0R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44F260A3806;
	Wed, 18 Nov 2026 23:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1vpT0j0R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDD61F000C7;
	Wed, 18 Nov 2026 23:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044748;
	bh=8NAtA4H7iSwZiWUjMUaCkIrUqzt1FlmQCTETaFmZL90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vpT0j0R9NB3lt3fQ42vIB0ku2W0csjO+CjdYoObVgM4ARwr5YVW9w2pEmsiR/mEV
	 GrzqBS/973e6TJR1gAPLm0CtX2zXT98JboX2bXBNemYcbwCPuaGQrQW4o9g9aSvhau
	 9LJjppvIWvbjqa5N8LXZ+gGoFo5Y4weQJ0NCdUMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0675/2857] ksmbd: verify transform SessionId matches the decrypted header
Date: Wed, 18 Nov 2026 15:28:29 +0100
Message-ID: <20261118150225.866829038@linuxfoundation.org>
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

From: Dairui Zhang <zhangdairui@gmail.com>

[ Upstream commit 798214e6fafcdcc29f5ba2661a473232b5e70cfb ]

When an encrypted request comes in, the decryption key is picked by
the SessionId in the transform header, but the request is then
authorized under whatever session the decrypted inner header names.
Nothing ever compares the two, so on a connection with more than
one session a client can get a request decrypted with one session's
key and run it as another session. Encrypted requests are exempt
from signing too, so a valid AEAD tag is the only proof of session
identity, and it is checked against the wrong session.

MS-SMB2 says the server must check that the transform SessionId
matches the one in the decrypted SMB2 header and treat a mismatch
as a protocol error. Add that check in __handle_ksmbd_work() after
decryption, before dispatching: the message has to be at least one
fixed SMB2 header, the first operation must not set
SMB2_FLAGS_RELATED_OPERATIONS and its SessionId must match the
transform SessionId, and every following non-related operation in
a compound chain must carry the same SessionId. NextCommand
offsets must be 8-byte aligned and stay inside the message; the
bounds check is done by subtraction so it cannot wrap.

When the decrypted payload is a compression transform, the
existing decompression step runs first and the decompressed SMB2
message is checked instead, since a compression transform header
carries no SessionId.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Replaced ksmbd_conn_abort() calls with ksmbd_conn_set_exiting() followed by return. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/server.c  | 16 ++++++++++++
 fs/smb/server/smb2pdu.c | 54 +++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.h |  1 +
 3 files changed, 71 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 85edc24ca9cdc..d314e21b753b6 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -169,10 +169,26 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 
 	if (conn->ops->is_transform_hdr &&
 	    conn->ops->is_transform_hdr(work->request_buf)) {
+		u64 tr_sess_id;
+
+		if (get_rfc1002_len(work->request_buf) <
+		    sizeof(struct smb2_transform_hdr)) {
+			ksmbd_conn_set_exiting(conn);
+			return;
+		}
+		tr_sess_id = le64_to_cpu(((struct smb2_transform_hdr *)
+				smb_get_msg(work->request_buf))->SessionId);
+
 		rc = conn->ops->decrypt_req(work);
 		if (rc < 0)
 			return;
 		work->encrypted = true;
+
+		rc = ksmbd_check_transform_session(work, tr_sess_id);
+		if (rc < 0) {
+			ksmbd_conn_set_exiting(conn);
+			return;
+		}
 	}
 
 	if (conn->ops->allocate_rsp_buf(work))
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2e9e4d7581c0b..4d4271956492b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8968,6 +8968,60 @@ bool smb3_is_transform_hdr(void *buf)
 	return trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM;
 }
 
+/*
+ * The decryption key is selected by the transform SessionId, but
+ * the request is authorized under the session named in the
+ * decrypted SMB2 header. Per MS-SMB2 the two must match, so check
+ * the decrypted message and its compound chain before dispatch.
+ */
+int ksmbd_check_transform_session(struct ksmbd_work *work, u64 tr_sess_id)
+{
+	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
+	size_t msg_len = get_rfc1002_len(work->request_buf);
+	size_t off = 0;
+	bool first = true;
+
+	if (msg_len < sizeof(*hdr)) {
+		pr_err_ratelimited("Decrypted message is smaller than SMB2 header\n");
+		return -ECONNABORTED;
+	}
+
+	for (;;) {
+		u64 sid = le64_to_cpu(hdr->SessionId);
+		u32 next;
+
+		if (first) {
+			if (hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS) {
+				pr_err_ratelimited("RELATED_OPERATIONS set on first operation\n");
+				return -ECONNABORTED;
+			}
+			if (sid != tr_sess_id) {
+				pr_err_ratelimited("SessionId mismatch between transform and inner header\n");
+				return -ECONNABORTED;
+			}
+			first = false;
+		} else if (!(hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS) &&
+			   sid != tr_sess_id) {
+			pr_err_ratelimited("SessionId mismatch in compound chain\n");
+			return -ECONNABORTED;
+		}
+
+		next = le32_to_cpu(hdr->NextCommand);
+		if (!next)
+			return 0;
+		if (next % 8) {
+			pr_err_ratelimited("NextCommand %u is not 8-byte aligned\n", next);
+			return -ECONNABORTED;
+		}
+		if (next > msg_len - off - sizeof(*hdr)) {
+			pr_err_ratelimited("NextCommand %u is out of the message\n", next);
+			return -ECONNABORTED;
+		}
+		off += next;
+		hdr = (struct smb2_hdr *)((u8 *)smb_get_msg(work->request_buf) + off);
+	}
+}
+
 int smb3_decrypt_req(struct ksmbd_work *work)
 {
 	struct ksmbd_session *sess;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 7518aa42f11ed..1271557678e60 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -487,6 +487,7 @@ struct channel *lookup_chann_list(struct ksmbd_session *sess,
 void smb3_preauth_hash_rsp(struct ksmbd_work *work);
 bool smb3_is_transform_hdr(void *buf);
 int smb3_decrypt_req(struct ksmbd_work *work);
+int ksmbd_check_transform_session(struct ksmbd_work *work, u64 tr_sess_id);
 int smb3_encrypt_resp(struct ksmbd_work *work);
 bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work);
 int smb2_set_rsp_credits(struct ksmbd_work *work);
-- 
2.53.0



