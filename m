Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215267;
	b=DnuBnXqLKThB/es1VbHv6v49mFHpXmlAlb2IZcdDQvpfMzEm+3BfcpMDtQQL5tiCKHZx
	 DfcIBQEqtVcLJO4osAO+0o41rKpeXSgfriw9Q5VK8XeNh7mYC30b4LIztOl3QFLge42w0
	 oZPgfA9YkDx5tKGtPekDOB7tzMI30qxaprfOiHZntKhRIojRbOOrJnGcy+isv8FBGbX7j
	 uXwJ5HXGBs/lPyuFCAhDvSqOydCyLZkj9c8NKxmb6WwC3nGi+uyuZ1xzq00zg7A5PQw5+
	 e+elK/qaJOXcsDa3IoSu5Kbf7hXzrgfRHZliLWk1PNMuzmLZjAV3YgNiTikEeInNGKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CLBL3mM3rGIaRHdnqwrncXCzKspsu55JV8taVRPfP88=;
	b=LScI/91wSWRME0kwXuQVMf8oMkTYgU8z12qbqJ0V3IqwS8QW5FWaUuY0J/dImrxxOt3c
	 rAMRp+nSU0oUTYLh1ZTVfBTRe84ah5beR7pI2MJSQPN1uKNhgSobIYNEQ42HHtwjCnf/9
	 l8lExksB+yTVGW8vRi5vCMgvwjdZgAtzfnal1Y+E7vp06tz02AhaebrgvFn0FetF9DwOg
	 vqA5mLx0iIUu4yaPrjUFRD+96ylVVacIAcGv+x28S6LsWZfzNxihcmhIOOdtDUH7PsqeZ
	 HbnEUHn15WwqPg8VjtdbSxUDZSzlv+HEPVZ3pQXkBDEdUBrUyRzZMPDqv1kWD4s3Qig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e9fA+efy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B232606A31A;
	Wed, 28 Oct 2026 19:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e9fA+efy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7CF1F01825;
	Wed, 28 Oct 2026 19:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215267;
	bh=CLBL3mM3rGIaRHdnqwrncXCzKspsu55JV8taVRPfP88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9fA+efyrrRlOyGc1TMGV66puCCd4KOM/yQzOXsqqyegnoyrCglOTQCQ+ATaAWXbq
	 kZnITXs9E8O+Ayw4ZlMMOgExI+LaVbzcVHB70UAHUp6hQ4BODkFZ9Ld2It8iAfaCCl
	 WuqQGt3zKq5JNRPVnbSldzzmjzH0TrA9gJG/LEuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1152/1887] ksmbd: validate NTLMv2 response before updating session key
Date: Wed, 28 Oct 2026 17:54:08 +0100
Message-ID: <20261028170525.620470721@linuxfoundation.org>
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

From: Haofeng Li <lihaofeng@kylinos.cn>

[ Upstream commit 954d196bebb2b50151cb96454c72dc113b2af1ac ]

ksmbd_auth_ntlmv2() derives the NTLMv2 session key into
sess->sess_key before it verifies the NTLMv2 response.
ksmbd_decode_ntlmssp_auth_blob() then continues into KEY_XCH even
when ksmbd_auth_ntlmv2() failed.

With SMB3 multichannel binding, the failed authentication operates on
an existing session and the session setup error path does not expire
binding sessions. A client can send a binding session setup with a
bad NT proof and KEY_XCH and still modify sess->sess_key before
STATUS_LOGON_FAILURE is returned.

Relevant path:

  smb2_sess_setup()
    -> conn->binding = true
    -> ntlm_authenticate()
       -> session_user()
       -> ksmbd_decode_ntlmssp_auth_blob()
          -> ksmbd_auth_ntlmv2()
             -> calc_ntlmv2_hash()
             -> hmac_md5_usingrawkey(..., sess->sess_key)
             -> crypto_memneq() returns mismatch
          -> KEY_XCH arc4_crypt(..., sess->sess_key, ...)
    -> out_err without expiring the binding session

Derive the base session key into a local buffer and copy it to
sess->sess_key only after the proof matches. Return immediately on
authentication failure so KEY_XCH is only processed after successful
authentication.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: f9929ef6a2a5 ("ksmbd: add support for key exchange")
Cc: stable@vger.kernel.org
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/auth.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 6509814770938..57be9520f8790 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -72,13 +72,12 @@ void ksmbd_copy_gss_neg_header(void *buf)
 
 /**
  * ksmbd_gen_sess_key() - function to generate session key
- * @sess:	session of connection
+ * @sess_key:	output buffer for the session key
  * @hash:	source hash value to be used for find session key
  * @hmac:	source hmac value to be used for finding session key
  *
  */
-static int ksmbd_gen_sess_key(struct ksmbd_session *sess, char *hash,
-			      char *hmac)
+static int ksmbd_gen_sess_key(char *sess_key, char *hash, char *hmac)
 {
 	struct ksmbd_crypto_ctx *ctx;
 	int rc;
@@ -111,7 +110,7 @@ static int ksmbd_gen_sess_key(struct ksmbd_session *sess, char *hash,
 		goto out;
 	}
 
-	rc = crypto_shash_final(CRYPTO_HMACMD5(ctx), sess->sess_key);
+	rc = crypto_shash_final(CRYPTO_HMACMD5(ctx), sess_key);
 	if (rc) {
 		ksmbd_debug(AUTH, "Could not generate hmacmd5 hash error %d\n", rc);
 		goto out;
@@ -222,6 +221,7 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 {
 	char ntlmv2_hash[CIFS_ENCPWD_SIZE];
 	char ntlmv2_rsp[CIFS_HMAC_MD5_HASH_SIZE];
+	char sess_key[SMB2_NTLMV2_SESSKEY_SIZE];
 	struct ksmbd_crypto_ctx *ctx = NULL;
 	char *construct = NULL;
 	int rc, len;
@@ -276,19 +276,27 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 	ksmbd_release_crypto_ctx(ctx);
 	ctx = NULL;
 
-	rc = ksmbd_gen_sess_key(sess, ntlmv2_hash, ntlmv2_rsp);
+	rc = ksmbd_gen_sess_key(sess_key, ntlmv2_hash, ntlmv2_rsp);
 	if (rc) {
 		ksmbd_debug(AUTH, "Could not generate sess key\n");
 		goto out;
 	}
 
 	if (crypto_memneq(ntlmv2->ntlmv2_hash, ntlmv2_rsp,
-			  CIFS_HMAC_MD5_HASH_SIZE))
+			  CIFS_HMAC_MD5_HASH_SIZE)) {
 		rc = -EINVAL;
+		goto out;
+	}
+
+	memcpy(sess->sess_key, sess_key, sizeof(sess_key));
+	rc = 0;
 out:
 	if (ctx)
 		ksmbd_release_crypto_ctx(ctx);
 	kfree(construct);
+	memzero_explicit(ntlmv2_hash, sizeof(ntlmv2_hash));
+	memzero_explicit(ntlmv2_rsp, sizeof(ntlmv2_rsp));
+	memzero_explicit(sess_key, sizeof(sess_key));
 	return rc;
 }
 
@@ -345,6 +353,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 				nt_len - CIFS_ENCPWD_SIZE,
 				domain_name, conn->ntlmssp.cryptkey);
 	kfree(domain_name);
+	if (ret)
+		return ret;
 
 	/* The recovered secondary session key */
 	if (conn->ntlmssp.client_flags & NTLMSSP_NEGOTIATE_KEY_XCH) {
-- 
2.53.0



