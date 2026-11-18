Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034236;
	b=hdK6aLmLVcIWXKst4m5QtEmBgD8kqE4+kmIRsv1gkYf26pU2xDFeNgB0YGIc+o8zX8/E
	 s87vrMfuwF7Ozfvu1TlEuA3HM1rK0jGSxKXY1MsCl2sWWIBCyYJ8mEqsTOgQd9aTXqvSB
	 QH9iil9P4PVUePtuFuFv0H5qYzLbPlHwGZ5F021Pb2GNhgy6OUVDqf0Uc0DTgNHYFx5wa
	 AUgLukw79qzvQJXMJtaziPo1z+69Xb0ki8QIIn5NWXJ8nJzxcjnBI9GqnchUVzz8ZcHfF
	 2KxMKZxZn7BoZU0greUCcvAeqU97X5BI+o9KdQLDm8uo3zMULbMkBuWuii+3pYxzEqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q8MpskcJnRMfZ0o7le2GngVQBlJjTuZVSauiAR9O6B0=;
	b=nNU4abV4v+QPsHpkO2qP5c8ZzribGJomPNg0PEIA0iniP4Y7/UmGXQvRmCmsYwroBeLZ
	 3MDiE5oTGMuhc0uuwA1HQGrjZ2yGjpe4U7CwOXAk1h6LSZKhAaoLvvV8h4s7nCMBNguwH
	 p8WJZwOAZ+1OomXYdN9vmz1OG8i79f6eC5jJQ12MzapEk7LqKljdQXXtgpglviRK+gTZl
	 tN/BmbHcyrxL0oumXv3yGDtQZY44TTYluuXibAkypsyokaOgrSQC2bTGMSNQdchuPTllI
	 CMRiOdppeUZKedUrPtQYFY3adtTkVx1KgVqLuOaV4Sis1eHF4BfRLcT8R3C4ubM82Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRia3rTO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCB660A2613;
	Wed, 18 Nov 2026 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRia3rTO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DED1F000C5;
	Wed, 18 Nov 2026 20:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034236;
	bh=q8MpskcJnRMfZ0o7le2GngVQBlJjTuZVSauiAR9O6B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRia3rTOBanSgquvwSdiZHcNNOwdZDCtHjWwf7IIjcx09zI86w3UeAfk8HnX8GvFZ
	 b26zSiETZSKU8M4+uhHDCY+alzeuHifSutwcqhn7YtLLS3E02bra5btBUnHXI5P8nm
	 GKVZMNY+yxjqLsE9mYYRrr9+mWyneBtW/712peuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0299/3318] ksmbd: honor client signing-required in all modes
Date: Wed, 18 Nov 2026 15:15:21 +0100
Message-ID: <20261118150324.664075782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0ccfc8d745d35..6cfc253f902bd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1252,11 +1252,9 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
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



