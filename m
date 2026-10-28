Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214159;
	b=oHgQLGjTgLW2FSQbIEQg/IFH0SvQGZsEMij5rreQ6N94i9khfMIvUHxZD0YU4dzKd/G2
	 YfjxtEbX5P4OxJhVQo6ZagJZyrgY5qUnQ6ekYMB5109aH5Lk3lq2wXMlbkIDLx1k4PyAA
	 SkoE1z3FZDvP+0JwDg2W8hU4Jxx6bRRmWKjBcaSDOz3BM1WvpXBPodzjKPL7EttF7ShtB
	 3gv5NrZv9xiV8PZzi81J8HASrLjBsgJVvvVcN/ib+Wx/JUVG0iOS3ocaVucZ/eUEdFgO+
	 4evz636k9jQXYldbY51hp9eQlqbBZROrBih+/GTzNaSS0Zf2i4mEao24+k+9P3iHUsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=brOfFkhe6YDO3N94jmaf5PDyWRJOpcZbl55rAVczOSY=;
	b=JobYmVUS5pCSUksPc1GFWDotnGOaB+kijOc2XIO9bfLxA1qBJrkKjRU0aKIypEYUofQ+
	 1gdfzWz4yTwdSYsLaf5s+cSL518gKWVqHEhWy6D5dmzy9DwsOjPwWuG/erPn23a9J2ANO
	 /7pFG+qgXzFk90EKI6BE2yQCr1qlfpZJhSIu3vWc5wiU+v5AZdP2YTlAAQxnG2OGrrwJz
	 Fu65uJ3zI7upqxtyh53kCckmjRlKa/gHhkDpwNQHzPDfG3oz8WWFo+RIk7Ql5zltoiWUp
	 ZnQf/pYYb6sKXPi+UA1zihtiIdbwxKb0HATZ7kGAWGoZPBHQRMcSCNG1kc8kkQqvVfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K4gylsOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC62606A31C;
	Wed, 28 Oct 2026 19:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K4gylsOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B281F01825;
	Wed, 28 Oct 2026 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214158;
	bh=brOfFkhe6YDO3N94jmaf5PDyWRJOpcZbl55rAVczOSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4gylsOjhVas7R6J/tIIHg6SojXPsIKlg3OpI2C1tmdB4hIAMTz9XFk3OSOW0RNcN
	 jI6mLheRuj0UGO3oU1bVAQKusVRSGC7PSBC5CyJBDG/qa+QZEgr6ixQNpplSxMRkPJ
	 HPkI4YA7X1iKyoe/IT9Uou31AHzEcnHGiLcNFBqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 0758/1887] ksmbd: fix null pointer dereference in alloc_preauth_hash()
Date: Wed, 28 Oct 2026 17:47:34 +0100
Message-ID: <20261028170516.692382162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c8b5b7c5da7d0c31c9b7190b4a7bba5281fc4780 ]

The Client send malformed smb2 negotiate request. ksmbd return error
response. Subsequently, the client can send smb2 session setup even
thought conn->preauth_info is not allocated.
This patch add KSMBD_SESS_NEED_SETUP status of connection to ignore
session setup request if smb2 negotiate phase is not complete.

Cc: stable@vger.kernel.org
Tested-by: Steve French <stfrench@microsoft.com>
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-26505
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.h | 11 +++++++++++
 fs/smb/server/smb2pdu.c    | 14 +++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 2a6628bb312d9..29b32486242cc 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -27,6 +27,7 @@ enum {
 	KSMBD_SESS_EXITING,
 	KSMBD_SESS_NEED_RECONNECT,
 	KSMBD_SESS_NEED_NEGOTIATE,
+	KSMBD_SESS_NEED_SETUP,
 	KSMBD_SESS_RELEASING
 };
 
@@ -200,6 +201,11 @@ static inline bool ksmbd_conn_need_negotiate(struct ksmbd_conn *conn)
 	return READ_ONCE(conn->status) == KSMBD_SESS_NEED_NEGOTIATE;
 }
 
+static inline bool ksmbd_conn_need_setup(struct ksmbd_conn *conn)
+{
+	return READ_ONCE(conn->status) == KSMBD_SESS_NEED_SETUP;
+}
+
 static inline bool ksmbd_conn_need_reconnect(struct ksmbd_conn *conn)
 {
 	return READ_ONCE(conn->status) == KSMBD_SESS_NEED_RECONNECT;
@@ -230,6 +236,11 @@ static inline void ksmbd_conn_set_need_negotiate(struct ksmbd_conn *conn)
 	WRITE_ONCE(conn->status, KSMBD_SESS_NEED_NEGOTIATE);
 }
 
+static inline void ksmbd_conn_set_need_setup(struct ksmbd_conn *conn)
+{
+	WRITE_ONCE(conn->status, KSMBD_SESS_NEED_SETUP);
+}
+
 static inline void ksmbd_conn_set_need_reconnect(struct ksmbd_conn *conn)
 {
 	WRITE_ONCE(conn->status, KSMBD_SESS_NEED_RECONNECT);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f30866efe2f4f..561581c0f26db 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1269,7 +1269,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	}
 
 	conn->srv_sec_mode = le16_to_cpu(rsp->SecurityMode);
-	ksmbd_conn_set_need_negotiate(conn);
+	ksmbd_conn_set_need_setup(conn);
 
 err_out:
 	if (rc && rsp->hdr.Status == STATUS_SUCCESS)
@@ -1290,6 +1290,9 @@ static int alloc_preauth_hash(struct ksmbd_session *sess,
 	if (sess->Preauth_HashValue)
 		return 0;
 
+	if (!conn->preauth_info)
+		return -ENOMEM;
+
 	sess->Preauth_HashValue = kmemdup(conn->preauth_info->Preauth_HashValue,
 					  PREAUTH_HASHVALUE_SIZE, GFP_KERNEL);
 	if (!sess->Preauth_HashValue)
@@ -1704,6 +1707,11 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "Received request for session setup\n");
 
+	if (!ksmbd_conn_need_setup(conn) && !ksmbd_conn_good(conn)) {
+		work->send_no_response = 1;
+		return rc;
+	}
+
 	WORK_BUFFERS(work, req, rsp);
 
 	rsp->StructureSize = cpu_to_le16(9);
@@ -1949,7 +1957,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			if (try_delay) {
 				ksmbd_conn_set_need_reconnect(conn);
 				ssleep(5);
-				ksmbd_conn_set_need_negotiate(conn);
+				ksmbd_conn_set_need_setup(conn);
 			}
 		}
 		smb2_set_err_rsp(work);
@@ -2268,7 +2276,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_NEGOTIATE);
+	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_SETUP);
 
 	rsp->StructureSize = cpu_to_le16(4);
 	err = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_logoff_rsp));
-- 
2.53.0



