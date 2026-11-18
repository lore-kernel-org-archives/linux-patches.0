Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043563;
	b=W6c+BiooLEzADG5SfyUKC+eS27vc+EvfMoZ1vnCUMpUfPNVa3siTJlAaI4wBHIj5oL/V
	 YJBwKKqYrRuPLqAgbUYjgISy3SxIl/wkq4Px9jXxA+Zn0k2sSpYJq+ZikNNix+tXSx/2s
	 jZ66QPuJrwrGz2jre/p6QCirXS5EtE9xK3pOWGjNkbVz4NQ1TpZKr6DAXduq1IUU2OwES
	 +RXFHI0FUo2SD0o9bW21F2gV4kwNODLBxMTaCovsescHYuICTyNjpK8xNbaHDI8mzPOTN
	 6lTnWyqxGzjlzWnGTvum4oDEBzPPLY3LJTkE4FY5HjEWW8GY9EGiFemXBWq9AN6a9rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W8kBeHcI9XM1kX/uXOmTg3uCgooTwsfSgMZmde/v0RA=;
	b=vLIBSARjL9Njs+LlXzmifqsAqef6/Zp3q0LQbaQkEDOmKL880dL8Dh5+rguxyxPW3JsN
	 5iFbVqMi8vDHQxFRS1zeYS/cyR3l+N+ZWxYVC2z2xathO0NyUG7cJjyKn/sXtZTYiIPc6
	 qANmodCZhhUkKO5nwdEqkNMQ5u5GEzJIhNtiiflDtWl1lbIkINHImlfTh3O3MPE0zWkos
	 bN7ZeS/RgoCkXYX71Qivwc1UOr775J9pWr7OkLaS9cwperLXa21HmFuuOyTkLt9KvPO7p
	 T//E7pyqj6D4PM3FQ5jWcRDlJxuP85rhOltDN6SepzQ1P6keZBA6/w39I1dCPp0CLjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6GxlaVl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A892606A31C;
	Wed, 18 Nov 2026 23:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6GxlaVl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00251F000C7;
	Wed, 18 Nov 2026 23:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043563;
	bh=W8kBeHcI9XM1kX/uXOmTg3uCgooTwsfSgMZmde/v0RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6GxlaVlzk7BfIuxCrQsmk5Xc56im6TVvnlrrSgXlRK/4O+kW8Lxxt5MXm95n04aj
	 jGkWG6p/AkSVOw3FqvQQcZz+OsXnnK3RE7rylSgIq0sUm/J8E6m/I2+x1zNTwU/dU4
	 pcCMTnHQ7wBBUMhOYVXqlcQdcyvIMfpgFRWMcmWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0255/2857] ksmbd: honor client signing-required in all modes
Date: Wed, 18 Nov 2026 15:21:29 +0100
Message-ID: <20261118150210.617344829@linuxfoundation.org>
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
index 6402a378ef6c3..33e0316fe9182 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1269,11 +1269,9 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
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



