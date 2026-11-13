Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590118;
	b=ZJ3YB0lKtX3HICp72ebpNYZUxElchAVinjWriorz8Hv8DMVn24Yh6Wn7BdnA/cQvnDiQ
	 F3PONo5JbGBmm/J+kl+1dfRQXLwXqvTpFTxX7GQwTGZhKDl+cOKk/Q2cYUhcAIjdBVn4Q
	 YtUslGBYU+xGeVrvVIEbLc/i5S9jj6Ha9wQrftkNml1N7ucHUcyuUd0uNe4kMycGQX1O9
	 fvWf0epTmNWX3b+HL2XgwT2Xza2jIcs1NEUFRLM7lTC89feqaiyxBlj1T7+/4+mPYbVCj
	 UBZEhncNeRFUVSdg9rwFMTYwltqwUB0tOsPDiaZh+dawXmKxQe5I1DUpUvSZgxUfW/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T48y6eQO3fDqeRz5F1cMcdJ1WiGXDNXrDLuGFgQfOO4=;
	b=Bz+JTncTFizabcXx//WXjqcvsTLsyARnK1qBmQzfHck3ugGiwWJDIelYg4h0G8GnrK+l
	 n7gisRqFb+FUmBX7l2dhyNbZPxIPDDC8OzUFoJM890ElSuGS7+hThen9utH9eIeCwnIJR
	 l5+wHtb4+MOYQ9Qz6TIQvleILR38EoREP+Imp2w9jccGDRjOwB10nO4KRq0oo0EiXcGvf
	 zjAPwLfiBDlaVHQt2SBJ+f/A5P06QieUfsoJJlySt7gs33VZ9naIpQizSXmrLOT5BSxLt
	 /7cwcY3brkUSTtaaBQ2JJTM0TgRQcfioCfmDIZbGGSjKDMoxMfUmwI4nY6qlwpEyOGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1WpGdWHn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA07606B224;
	Fri, 13 Nov 2026 17:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1WpGdWHn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01F51F000C4;
	Fri, 13 Nov 2026 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590118;
	bh=T48y6eQO3fDqeRz5F1cMcdJ1WiGXDNXrDLuGFgQfOO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WpGdWHnWBDsEnNg2NGrItPmuAHcWYQcKaTgLS/p/xi5AJkVmFa4cT4y939ZIQOWY
	 HQF2/lYDJTwfLwMM2gaZtVvYQ7Tl6VgqTlBbryoBnLbLk3V+W92ka08LWmcCmHKzWd
	 bFbpZ8HPDES3U4yVwDvVM3sZQJ54wTDwgSOYH2Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/686] nfsd: shorten extack string returned with dodgy listener
Date: Fri, 13 Nov 2026 10:43:48 -0500
Message-ID: <20261113153824.086120069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 9ffa72c15aed2..15fb9ffc12a78 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2188,7 +2188,7 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
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



