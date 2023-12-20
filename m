Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB9C4779A;
	Wed, 20 Dec 2023 16:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n76bP2Bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC380C433C8;
	Wed, 20 Dec 2023 16:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088705;
	bh=tPPCImsIg9Xhqd+UqrcwuTzeKpbtEHl4a8S+F9E0MrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n76bP2BcOZXJwe5wRbRCMbSp2tsPu0MnEIEl88iVVk78KNufyYC3vXisZ+IP4eqhM
	 0zYkBb44gK1x1yJrEOoB1sSa27wbE9uGFYpYPMsHUD/zO6VfspQJ10Yy3zbk9z6bvP
	 6AVRRe4Cx9KUlv5ypiF/JOEWG+pkEFRKCvJJsa/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 004/159] ksmbd: remove md4 leftovers
Date: Wed, 20 Dec 2023 17:07:49 +0100
Message-ID: <20231220160931.474824965@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 561a1cf57535154f094f31167a9170197caae686 ]

As NTLM authentication is removed, md4 is no longer used.
ksmbd remove md4 leftovers, i.e. select CRYPTO_MD4, MODULE_SOFTDEP md4.

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/Kconfig  |    1 -
 fs/ksmbd/server.c |    1 -
 2 files changed, 2 deletions(-)

--- a/fs/ksmbd/Kconfig
+++ b/fs/ksmbd/Kconfig
@@ -6,7 +6,6 @@ config SMB_SERVER
 	select NLS
 	select NLS_UTF8
 	select CRYPTO
-	select CRYPTO_MD4
 	select CRYPTO_MD5
 	select CRYPTO_HMAC
 	select CRYPTO_ECB
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -628,7 +628,6 @@ MODULE_DESCRIPTION("Linux kernel CIFS/SM
 MODULE_LICENSE("GPL");
 MODULE_SOFTDEP("pre: ecb");
 MODULE_SOFTDEP("pre: hmac");
-MODULE_SOFTDEP("pre: md4");
 MODULE_SOFTDEP("pre: md5");
 MODULE_SOFTDEP("pre: nls");
 MODULE_SOFTDEP("pre: aes");


