Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7AF2EB5CE;
	Tue, 17 Jun 2025 16:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176791; cv=none; b=DqNRjgZ8ZJ4sGWD6bFC+sZ3dGIaaD2AXg2lVmIo4dLUgVeTwP34nT44GMd3echEdzGd1Yw88Z/SstYmxNvrVfXCXFRjinDTw9+33BW+H2A40JM8EMP12/HwI1v39BdINKsp93HXJOCi6vDZtfTdes84Xt0ppe8h4BKaLF63P3kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176791; c=relaxed/simple;
	bh=e9X2iPjQSgyDeLEtaFGsLTsu5lwrGuPYxhCm5+1N8KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5y1KtbXgq0j/45/XZf69yfrQfi3RhSg3/Kv+w8cTMYsdekHcccUh+OgJ94PTaaFREV8SIcIX+bd+MgAFS0jzTu/DVFRIa51ZjNKcegS/EnF1QaZcA1/lLPgTIKwLy//dTDMD5sdunK0sR/+byDUzcuaJb0cs70/CRmEqa+eMQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBiTwpHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBiTwpHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F8DC4CEE3;
	Tue, 17 Jun 2025 16:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176790;
	bh=e9X2iPjQSgyDeLEtaFGsLTsu5lwrGuPYxhCm5+1N8KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBiTwpHMiDOJJjF00au8q4ktxp+GelmfsoGs1xie1cwI0pSZ+Y1CHkYFgoX8J4/Oe
	 yRrbtTYfV4G4G9x4u5CdosdprP3v0dCXzB6GVg8+/RtHgYsr7d0Ude4BqwY9vdGle/
	 jU5tP2I22dt/1uvKt3asUDtVjEU/Y4C06sCYiTq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 226/780] f2fs: clean up w/ fscrypt_is_bounce_page()
Date: Tue, 17 Jun 2025 17:18:54 +0200
Message-ID: <20250617152500.661872568@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0c708e35cf26449ca317fcbfc274704660b6d269 ]

Just cleanup, no logic changes.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aa1be8dd6416 ("f2fs: fix to detect gcing page in f2fs_is_cp_guaranteed()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 54f89f0ee69b1..5a7888a5923ca 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -53,7 +53,7 @@ bool f2fs_is_cp_guaranteed(struct page *page)
 	struct inode *inode;
 	struct f2fs_sb_info *sbi;
 
-	if (!mapping)
+	if (fscrypt_is_bounce_page(page))
 		return false;
 
 	inode = mapping->host;
-- 
2.39.5



