Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826999;
	b=5Af9WV8hrja5wXqT8rSRCVuZjbfjlYM1jk+T0gO2FYVkdreESAfQPlLg1CKFO3omoKq0
	 iKrZdWySq6saEt/r3VgAdr2WHqe2xnJM4bsOJa4G1xatqncSHz1cuun/Lj5vq8j8VunOW
	 tdmiB9CPAAYnIyODvNiU3rOFtJ2Mp2nFtRgHY4uZwaLLSWo2jZL9aK9OFLaLC52tAfVmx
	 bd16tJ2sLZghcydVje+KnPuscc0n3VJAR7pFWv+M/QLRMCKH0HfSoCMvagjy01738F5xM
	 88K/h2TcsgDcgNWSYhAFsWES/CcqVqdmxiWRt4AUdMxhcBhMtSb4dQC24ZA0eIumIFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6tKL1xJQWNyareFwGvHYQBQw2ZbK4Vm8x+G6y/4iJyw=;
	b=Xj8+py51MB1qk6Jlc88JrnkGCjE6zkgL6ie3oOfXiQDzMWS3hQFCLxeEyXU0tuZXWLRq
	 cs2dne/YaX+/k1ftACVEmia+a74iQTAZhFzlZaFqsnmDGv/xdKkuh1PwPqy23zv5bgGP3
	 jn11es6hzDQXCr1W7zGJexedlWa9GvWg96AM9zePPtHtYvX2tX9HMZ8b3PKTdLjbgMf2E
	 uAgWydv9ztJrZbSi/dyM7u7z3ThK2ZbdMzk13l1wGkCG9wEEmeGRxC+F4mHhRertyE8rD
	 xhKoXQRjoEqoJCPy2TH0KGNWdiZRs81BQ5l8AZXIttpezioQxXwxxZIGD3f2xC1PTbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BB5iyWc0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2286086616;
	Wed,  4 Nov 2026 21:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BB5iyWc0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D631F00A16;
	Wed,  4 Nov 2026 21:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826998;
	bh=6tKL1xJQWNyareFwGvHYQBQw2ZbK4Vm8x+G6y/4iJyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BB5iyWc0UW3WqOVGBYSgtcfhSle5jdy6oF3Mqm+U9kUwc4gVAC3teCmh63JjHpR4z
	 S901XJ39dfmcf4h0exzQPmgOkkPJoswBG1tJzpksbky9q2QCbWh8A27OsQsJWF79mD
	 UQb/e/sBFZJsWS4efIREmPlqRiW9EXh9rJ/uRo3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 132/547] ksmbd: restore Kerberos logins with released ksmbd-tools
Date: Wed,  4 Nov 2026 16:05:16 -0500
Message-ID: <20261104211041.925611321@linuxfoundation.org>
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

From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

commit 0fec4c24e1979032d7b7c159d9e5c45c7444e0f2 upstream.

Commit a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets
expire") added a __u64 session_expiry field to struct
ksmbd_spnego_authen_response, growing it from 156 to 168 bytes.
ipc_validate_msg() requires the response to have exactly that size, so
the 156-byte response of every released ksmbd-tools, up to 3.5.7, is
dropped and Kerberos session setup fails with STATUS_LOGON_FAILURE.
The other way round, kernels without that commit, including the stable
trees, drop the 168-byte response of current ksmbd-tools master, and
ksmbd-tools has no way to tell which layout a kernel expects.

Pass the expiry in the reserved area of the embedded struct
ksmbd_login_response instead. ksmbd-tools releases with that area
(3.4.4 and later) allocate the response zeroed and never write to it,
so they send an expiry of 0, which ksmbd already treats as no expiry.
The response is 156 bytes again, so it works with those releases, and
every kernel also accepts a response that sets the expiry. Use two
__u32 halves, as the reserved area is only 4-byte aligned.

Fixes: a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets expire")
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/all/CAO+rqLhpPvY0NLrAnZjFXz0gOXnA6zsXxK8xCgtA42XUkSsAeg@mail.gmail.com/
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/auth.c          | 3 ++-
 fs/smb/server/ksmbd_netlink.h | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 88953315b160..0c51ca0cb14d 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -463,7 +463,8 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 	memcpy(out_blob, resp->payload + resp->session_key_len,
 	       resp->spnego_blob_len);
 	*out_len = resp->spnego_blob_len;
-	sess->kerberos_expiry = resp->session_expiry;
+	sess->kerberos_expiry = (u64)resp->login_response.session_expiry_hi << 32 |
+				resp->login_response.session_expiry_lo;
 	retval = 0;
 out:
 	kvfree_sensitive(resp, sizeof(*resp) + resp->session_key_len +
diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 93ebf3f6fbef..ad050988659e 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -149,7 +149,9 @@ struct ksmbd_login_response {
 	__u16	status;
 	__u16	hash_sz;			/* hash size */
 	__s8	hash[KSMBD_REQ_MAX_HASH_SZ];	/* password hash */
-	__u32	reserved[16];			/* Reserved room */
+	__u32	session_expiry_lo;	/* Kerberos ticket expiry, SPNEGO only */
+	__u32	session_expiry_hi;
+	__u32	reserved[14];			/* Reserved room */
 };
 
 /*
@@ -287,7 +289,6 @@ struct ksmbd_spnego_authen_response {
 				  * stored in SecurityBuffer of SMB2 SESSION
 				  * SETUP response
 				  */
-	__u64	session_expiry;	/* Kerberos ticket expiry time */
 	__u8	payload[]; /* session key + AP_REP */
 };
 
-- 
2.56.0



