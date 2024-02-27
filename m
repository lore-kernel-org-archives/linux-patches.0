Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02F613AA2F;
	Tue, 27 Feb 2024 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040851; cv=none; b=BuOBvmbbmqIuuU+oc624LaqtH/GbFsssOX6CwsjGkeHNTIkeYdxfCrUb70tgJDMYbgMzBfrBUTIfuCoPMQrJCtteQ1gtC2SKyTzkCfJM9uWldD6zH8DC+yHPhgw749hN7nJo2zcR+QcLzP+r6hpEFE1UwbnhFQYC5ZoDKBupQEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040851; c=relaxed/simple;
	bh=uGsuEtfimlP+ZKhrdUFNYhKk1JPtcHkab5YR9zz0Vl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVfe1qF2CxFCW+du2uCEH/3ZFOkF1JkppMcQEzZDqjtozsLg4xmUkxfW2bZbpu+LcHg/we1e6SXzGqozJUww8EB/jndQyN/BtrM2NnDywbFzKk7NHSV2isAE5l72+86My/kJk3K1h43lftoEhb5fPoh9Ee38pOm8/7azsl2RGXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDasN6OU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDasN6OU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30784C433C7;
	Tue, 27 Feb 2024 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040851;
	bh=uGsuEtfimlP+ZKhrdUFNYhKk1JPtcHkab5YR9zz0Vl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDasN6OUljf/eppAjua51uE6v+4hY0UMxGokQbAt8X8GE67ztvTSEcM5poEaEv8H5
	 BpqCxUZoqxo12yilvXDJeyEPxgyYFtkAG45P9jgQXpaEideQeIRpcYor47DNxvKaMB
	 JE/dOP46O3k3qhAOrQZHdMPwHQG652Z2CSk90RWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 132/334] smb3: clarify mount warning
Date: Tue, 27 Feb 2024 14:19:50 +0100
Message-ID: <20240227131634.718121600@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit a5cc98eba2592d6e3c5a4351319595ddde2a5901 ]

When a user tries to use the "sec=krb5p" mount parameter to encrypt
data on connection to a server (when authenticating with Kerberos), we
indicate that it is not supported, but do not note the equivalent
recommended mount parameter ("sec=krb5,seal") which turns on encryption
for that mount (and uses Kerberos for auth).  Update the warning message.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 75f2c8734ff56..6ecbf48d0f0c6 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -210,7 +210,7 @@ cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_c
 
 	switch (match_token(value, cifs_secflavor_tokens, args)) {
 	case Opt_sec_krb5p:
-		cifs_errorf(fc, "sec=krb5p is not supported!\n");
+		cifs_errorf(fc, "sec=krb5p is not supported. Use sec=krb5,seal instead\n");
 		return 1;
 	case Opt_sec_krb5i:
 		ctx->sign = true;
-- 
2.43.0



