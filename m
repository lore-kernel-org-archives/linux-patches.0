Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E884B5B5;
	Wed, 20 Dec 2023 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oI8cGUtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45929C433C7;
	Wed, 20 Dec 2023 16:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088828;
	bh=Pe3IUVRoDggMqC+Zb/DAsiN4yyxHNN3hCWVTkhdBVBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oI8cGUtdKplczmw57QFrkC1h/xDTjh/gRvSCIBFZiFnE39wwhkH6pDCEPht0ObRfJ
	 R1X3RZJP87mbmHGeHqGS5qRuRt1qA4V/PZj0Qdlb2XNNA5kp3BdIyNTgm8ctMv0USI
	 WoHhrcbT4JmsVkyzdJ+aFu9fmY4ltDBpwwKSri0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 074/159] ksmbd: update Kconfig to note Kerberos support and fix indentation
Date: Wed, 20 Dec 2023 17:08:59 +0100
Message-ID: <20231220160934.835075200@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/Kconfig
+++ b/fs/ksmbd/Kconfig
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


