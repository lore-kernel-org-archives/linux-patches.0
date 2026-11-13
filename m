Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590900;
	b=rR0B0ARot3SPl0PJvUVC3y16FSi0QZZjIe5296BjDYaQOmipRCnKhi1H1uHxBMVWbs6T
	 mTIvPdvvXxQFWWea0o2bnZgitvteBzVMtZtVqO67Dzp6B0PFc4KoyUZTbN3SKmy2b9+8s
	 O8ZOYkTQ4yHGFh1dBTOGOg7H6PPvStK0XQQNDPnz4Sd2izHq7fPZob4bFHnRbmneEspM5
	 wMHOG2cI+Eu+z7VctCoCj6kBdUxgM0qXGXkLlq+sbyLmgaXmXuyE40GesjIbQefDIUfRa
	 SXI4RMALWUoVW32A1UJa47/1EjKhykBoAsLykI3YkNVK2FTOvSGClb/LSm+kz9i9WYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7TS1Z31ofE2J8LhOK+1XSdeYzRlHfS2OUiacgHd13cU=;
	b=g811R/Lji41Ps1mKdRu2BmtHZA0uV4HzWKcidyly+UIj+r9ukFm+RE24RLWghvR9nRrn
	 j64PTUck/gY6X4AwGCdGfUjZXYhnVC91BLKGLWI5ZhtCzltFSCtUGgfHtzdtCOxFaxYd8
	 MYzbg5oJ08hikGnWJZLXtjjOtBIETo+qbu9Qyk819mpNQzFGHvjZe639k8tNGnHQsUiES
	 IkiXdvtz04p7jJrbexyafFeL2ENoYg9Bfw8L1OsQUUShy5LkpqiSpQ+ZDi6EHmfwvDujy
	 4ENpo+9vMit2JXPaC0OFuugeJyQvfqROuw0XrtiDJgAnosUTpHUhLUU3y3Hdgr9keNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKHU68Sh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94AA606E223;
	Fri, 13 Nov 2026 17:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKHU68Sh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AA11F000C4;
	Fri, 13 Nov 2026 17:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590899;
	bh=7TS1Z31ofE2J8LhOK+1XSdeYzRlHfS2OUiacgHd13cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKHU68ShDGmiH1O4cJZe3/LF70Pmbe1k+S+Ykl/Mp77/TcHL0PLHhh7ZH8Gcw4hWu
	 x2x1VgfSl/EY0QzAHQVV0BgepT5V9lUIvWCDIA3J+OkF6kfK7SnyLOzkqo3r/X6r7F
	 AYxdxx/VrqnF+pEp0U7ZwfF/DyS/109dDQkzWm8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/670] nfsd: shorten extack string returned with dodgy listener
Date: Fri, 13 Nov 2026 10:44:14 -0500
Message-ID: <20261113153814.962661246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8d7859d165dbdf6e8d77b76500fc990f26c8310d ]

The kernel test robot reports:

>> fs/nfsd/nfsctl.c:2253:4: warning: 'snprintf' will always be truncated; specified size is 80, but format string expands to at least 94 [-Wformat-truncation]

Shorten the extack string in this case so that it will fit in 80 chars.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260904-nfsd-nl-hang-v1-1-8c8035b6294d@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 6ca903922fe9b..f2e1079bd0437 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2269,7 +2269,7 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 					   bad_xprt);
 		else if (skipped_rpcb)
 			NL_SET_ERR_MSG_FMT(info->extack,
-					   "cannot create %s listener; rpcbind did not answer earlier, so some listeners are not registered",
+					   "cannot create %s listener; rpcbind did not answer earlier",
 					   bad_xprt);
 		else
 			NL_SET_ERR_MSG_FMT(info->extack,
-- 
2.53.0



