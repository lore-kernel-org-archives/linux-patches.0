Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830955;
	b=Kj0PVfK/m7QtmUaNQSNcek+BnxK5FX5UQy1S8n9GIAnioi5KUPupYVXRQdx3QutSCw+J
	 ow82UCXhGjBwFXZYkqS9Dq0iz63JV5gxnPLM6ouaHAdURU+g/pFfkz+jy4qxIlPD/hpcN
	 ZTv2riQ8vWRRTlY+Vz8SBUlUgeSbgDYZv7FwWyatCIlKtnDc9KjHqUauujtWK//oeULx3
	 xdFjx0NEXjsCMSR/XaS5z3HnMGxv6vKDbZtexNgGkKSkoqbblyUkqzOESOP1u0swmWXCM
	 lrJZqrO4D7UeQS7rvRNUIEVsLMt8ap7jT+zxg117nKDsvCRCOKhGoEmLQKyALREgTYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8gJ438F/RxT3XOaVvmRtTkfHgzMmMzX/NshMjniR79Y=;
	b=Wij4Uuv7nvQs9yQFQVUh8tjdsgXcQ1sTnbvTed/Yok9w5K9HtoAM92ksXsHLzNgGdRsb
	 vJ8JYc7OGotipXsAIpAm8SLPkYUOzAAi0JO5ox3+wqFjs/ETQh9U/fzScEqtSeIi0plKV
	 PqeT8/ocE0CBqzhl7KL46Y6/Uiu7FwIBX/+3XQ/DIwHeWw21ZUxTXBQBCDR1MvNR9mFz1
	 czde9ShWlsM5ALnF8qbgUNlXwBDjQhzdR5hvcB86YE+8Jz+kYJN9zarpAiVg5esEafWRl
	 GXrYG4n8iUgcpVGkLsR1i9uE8oLp+PjsA6zQRWSBoU2WWA5U5e41c4kVOavkIYPIjbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f3zBEL5+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5989D606A844;
	Wed,  4 Nov 2026 22:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f3zBEL5+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F751F000C1;
	Wed,  4 Nov 2026 22:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830955;
	bh=8gJ438F/RxT3XOaVvmRtTkfHgzMmMzX/NshMjniR79Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f3zBEL5+ICENalTryIq2YfIcoVBDBDgVe7riySXgShmh9LO2qPxtuUVNRMJkU4Wpy
	 xBbBpmH7rR1SiuLn6HAMMkXp5XWE8u+t+jGWtLX3CHCEmhU9nDrOE24LbWW36Nuol5
	 SAu4WFsmT9IOH3Jtyby6kQEhrjT3Qpt/RHo1RAuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0420/1005] ksmbd: honor client signing-required in all modes
Date: Wed,  4 Nov 2026 16:02:33 -0500
Message-ID: <20261104211055.862015342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit bc2f3f3dd69424f76e2ed3dc53d29bfd6c9966d4 ]

The SMB2 NEGOTIATE request's SMB2_NEGOTIATE_SIGNING_REQUIRED bit requires
the server to set Connection.ShouldSign. KSMBD represents that state with
conn->sign, but previously set it only when its signing configuration was
auto or disabled.

Set conn->sign whenever the client requires signing, independently of the
server's signing mode. Keep the mandatory server-mode handling unchanged.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 40d7e3b6ed7e1..61f16f54a810b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1253,11 +1253,9 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	rsp->SecurityMode = SMB2_NEGOTIATE_SIGNING_ENABLED_LE;
 	conn->use_spnego = true;
 
-	if ((server_conf.signing == KSMBD_CONFIG_OPT_AUTO ||
-	     server_conf.signing == KSMBD_CONFIG_OPT_DISABLED) &&
-	    req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED_LE)
+	if (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED_LE)
 		conn->sign = true;
-	else if (server_conf.signing == KSMBD_CONFIG_OPT_MANDATORY) {
+	if (server_conf.signing == KSMBD_CONFIG_OPT_MANDATORY) {
 		server_conf.enforced_signing = true;
 		rsp->SecurityMode |= SMB2_NEGOTIATE_SIGNING_REQUIRED_LE;
 		conn->sign = true;
-- 
2.53.0



