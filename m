Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8FF1BDF0;
	Wed,  3 Jan 2024 16:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIuCMd0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F20BC433C7;
	Wed,  3 Jan 2024 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301141;
	bh=Y9vy5IWjWJOCa81NjIU7fk4AtF4KtMg+NjFg1Ujak3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIuCMd0l33yREc+35x1745KmMHeF8RSJOsY3dBFtqJ6c7duTM8n5Xs0U8yqaubBWC
	 OVOVKRmvyW819wket/q7JJd32yRMGZekbxXnpt5BpPClub7rPJFNqYOVerQV6KjvMy
	 UbpjjWKHsZwXsqCTSIg84N2WTqt5eDthN8nQivtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/100] ksmbd: update Kconfig to note Kerberos support and fix indentation
Date: Wed,  3 Jan 2024 17:53:58 +0100
Message-ID: <20240103164857.580213189@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit d280a958f8b2b62610c280ecdf35d780e7922620 ]

Fix indentation of server config options, and also since
support for very old, less secure, NTLM authentication was removed
(and quite a while ago), remove the mention of that in Kconfig, but
do note Kerberos (not just NTLMv2) which are supported and much
more secure.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/Kconfig | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index e1fe17747ed69..7055cb5d28800 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -33,14 +33,16 @@ config SMB_SERVER
 	  in ksmbd-tools, available from
 	  https://github.com/cifsd-team/ksmbd-tools.
 	  More detail about how to run the ksmbd kernel server is
-	  available via README file
+	  available via the README file
 	  (https://github.com/cifsd-team/ksmbd-tools/blob/master/README).
 
 	  ksmbd kernel server includes support for auto-negotiation,
 	  Secure negotiate, Pre-authentication integrity, oplock/lease,
 	  compound requests, multi-credit, packet signing, RDMA(smbdirect),
 	  smb3 encryption, copy-offload, secure per-user session
-	  establishment via NTLM or NTLMv2.
+	  establishment via Kerberos or NTLMv2.
+
+if SMB_SERVER
 
 config SMB_SERVER_SMBDIRECT
 	bool "Support for SMB Direct protocol"
@@ -54,6 +56,8 @@ config SMB_SERVER_SMBDIRECT
 	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
 	  say N.
 
+endif
+
 config SMB_SERVER_CHECK_CAP_NET_ADMIN
 	bool "Enable check network administration capability"
 	depends on SMB_SERVER
-- 
2.43.0



