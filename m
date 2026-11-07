Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061012;
	b=NZxXP0gnGtcwS+ZJIptaswt+qzLDRmvQa7kj6xqcxdHGc/C+W5Qo90H4f0P16LARxMrR
	 VA0TeoQoqZkHFqHpCgesbiK/Iija42EETa8IFitJ+OVU6W29JkrKAYhBugogwBHpKnJDe
	 TFGEGiYx/s+T48l1U+THqYR6pKn8hjbe+KvpqEm88i2T6CXnBOaQJ+aZN5GgtU3BsGgGP
	 SQ/G26X2sRUlFozer7/8lUMMX09Flbbi0sfjJbFI6243Qh8n/p7cJi103fylzt3/LlIm6
	 hckpycm370Sud+aulXfcHcE9fzWYcbCLEU21CyHWhTvCSntdJAywPR/59r3djLk9xAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8YjGmLjUFPbiHIt46X18/cYfPSH0YHcVAtDzNo9t4BI=;
	b=iI2uVJjCt7inUtIMrHEBNlmGOCpYy0VaHgD3loC/biLHbYSwLiN9dFCEkNzIgRcweKaU
	 s6wZ3IYeUw2KKRdnq3fH00mCgbryCuGfOB7tiWrBTUf6nhRtbGDJetAcRtt/4gDqGZ2Gm
	 Vz+SIzv2YttXyEQ3vxyTZOW+luAc8tEj6+7/5j2uucpQEmP3fGrXPkJPez0PFhjJv4LMA
	 XvxFauQxPNzfLBR424sjtjmLelzzrftjVv+e34CvsvJDl/KnuJjt9vi8hmwnVa99GfhEs
	 gHYn7ZTLbyW/d7bhYlrJkDUYrpfMjnZznskjeaqfphOtvfTUzxFJaQh+q1bmSGkhRwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlnvIKcO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA422606D80E;
	Sat,  7 Nov 2026 14:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlnvIKcO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6E71F0089F;
	Sat,  7 Nov 2026 14:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061011;
	bh=8YjGmLjUFPbiHIt46X18/cYfPSH0YHcVAtDzNo9t4BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlnvIKcO06hRnvrHHlFhLWuLVUm7rPoAyxgPfHnVIreAhSmwZuqoO3qwZIIxFYr2W
	 09ufSYhFU8AslRLbKc0DdS6ZJqE5W+OXWi70AO5s03pzirDQMYMC5sSSan0PMTjLuq
	 ptzBdT/uUHYbUCtPT+r7Vesz7getD9s1Cxg3WGlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0354/1536] ksmbd: honor client signing-required in all modes
Date: Sat,  7 Nov 2026 08:39:30 -0500
Message-ID: <20261107135007.611477469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 4bbff7f413003..06f1c82ba42d2 100644
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



