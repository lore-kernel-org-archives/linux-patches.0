Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60FF4E9C24;
	Wed, 30 Sep 2026 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782477; cv=none; b=o/bwVcGeJDO4mgJBxmgnFnMg6Zij6yK3WImvV/xvw46Fzs/7eiRFLVZYWdPqVvDSGxXvDIqqdJPU/2yD1wr6pZnBg62iQCHVecLLP4/epmOPMnSYQFW9GqOln3UlJtKA3UHUosl9gJ5LVugvanTHXP52UwY2Ij4wcTDc9u3FzmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782477; c=relaxed/simple;
	bh=KBVFAUNW6NE9NQxhaTRcLdwW5cjID8NBFMYyCYaRvT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtszSbfApaL3d4uLYe6t4E5KQRRgujywdsqRd1kipt+ZZ5Clp7/utvGkECcXr3vcjpwJSEHLnKRpEBptrZ9S6NeFGvJiSTGl9f7UUyQB9lPPh+KEymBnH1wzIPns1KHgt8VGwG0Y7vlsvT5+8KN1/habjbengM23FP29h15QyBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiClVboX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiClVboX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224211F000FF;
	Wed, 30 Sep 2026 15:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782470;
	bh=wZBMMDnQlF5Xn3EL298pzcRcW7MoR7GMMqtTn+luoKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DiClVboX9trD6X4vBUkMF5Cu93PfJvHboC0LCF6DC4X8XrR3ZJuVbFj6C9MoWxOIt
	 N7rhjqIuOWI00p3RWQ2iA8NwYYMIBmY5yhfBJGG0YsRObQvZj1n7TvowNLginAqvy9
	 QPamQgORRUkDj8RMW/pRoONyhcoQPqbzm0HuWhxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/595] netlabel: fix IPv6 unlabeled address add error handling
Date: Wed, 30 Sep 2026 17:19:09 +0200
Message-ID: <20260930152348.937451038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 56872b930feee7ae07b9720ca950dd9fa65596ee ]

netlbl_unlhsh_add_addr6() always returned zero after
netlbl_af6list_add(), masking failures such as duplicate
IPv6 static label entries.

Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/20260522022910.398416-1-zhaochenguang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_unlabeled.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index e6b34be6fc283..145545e627e33 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -295,7 +295,7 @@ static int netlbl_unlhsh_add_addr6(struct netlbl_unlhsh_iface *iface,
 
 	if (ret_val != 0)
 		kfree(entry);
-	return 0;
+	return ret_val;
 }
 #endif /* IPv6 */
 
-- 
2.53.0



