Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A0F56C643;
	Wed,  9 Sep 2026 14:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962938; cv=none; b=oLlDrWNX6jdOEtGiv5lU42kfavBqI8VMnllAz615koFN1jBCyn1Lyn1xwKXbB2NW/nOmnIFY6+gw5bYPhSVM6jJxD7bFaToMUfJasWDiyX9ZWs03jNF+PWj4p1tdt729qQv0XyaLcqUQ2HwB5/rTyhv5z2pB+H54h0zImtrdTzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962938; c=relaxed/simple;
	bh=q/T74cfx8skyEeEDfxyUY7HEd3lJqLwEn2VQdrebe7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YD5MSO+8JAZ9p4Yxc2dyYtiXdYIlBi3tr49aALLISTAeteOmkoCTg9AFZHSB5Vw2DQzwSvN2sfJKsRoon8ISlAuhu1mFQ++nb0fhMglg/b/K2bYRbYCdHQ2llmjq5e1uKAVcrStScFsFsb6MghHi17Jja/RESPwF+Y7IHhpvmIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y08uBibx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y08uBibx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2271F00A3A;
	Wed,  9 Sep 2026 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962937;
	bh=GDNpQ/CE+XF3eVNlL++ZwnZgYLOuqNc4gJOSmxGdyUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y08uBibxgd9lLtyPFQGwk9SlhT6x4O321w6EacXVrpqVK9O1805YLLaWh+3WV5/h2
	 6HrHb2XKNcvfTT24WlsiDbwn/JlNyRLlMNLdDsQyvAf1uJd40ee6QTOPscqTRx+LhD
	 XzMntlPbfP6lyhXCZapTOc+B0t5Y59Aq/IQWmz7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 464/556] f2fs: fix to return -EFSCORRUPTED in f2fs_get_node_info() correctly
Date: Wed,  9 Sep 2026 15:42:24 +0200
Message-ID: <20260909134246.884046863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 026d7aeadf27291f961893165edb6079a7078f6f upstream.

Otherwise, it will cache wrong nat info in cache.

Cc: stable@kernel.org
Fixes: 3cb396a2c790 ("f2fs: fix to do sanity check on nat entry of quota inode")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 38917e4a7319..9775fa90636a 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -660,6 +660,7 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 			__builtin_return_address(0),
 			ni->ino, ni->nid, ni->blk_addr, ni->version, ni->flag);
 		f2fs_handle_error(sbi, ERROR_INCONSISTENT_NAT);
+		return -EFSCORRUPTED;
 	}
 
 	/* cache nat entry */
-- 
2.55.0



