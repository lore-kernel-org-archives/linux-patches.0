Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C45A255222;
	Mon, 23 Jun 2025 13:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684792; cv=none; b=uTkJ/DbgCpG51NWhBjHkTW7zpJohKJqWNb9G9pv8LO9O2nBVroORZwbXUHKpU7qZ1jPVRSid6jggpZChcOsHslUJqdFVntYzkZy5TZ2w9+zfoS5thBzrxI7TtDfg82rnK1MHV8IdVF4SzVvpRvXVxQpJuj+wUux/7ubdSeA9Xmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684792; c=relaxed/simple;
	bh=W/M3JQAPDEBDNgkgDvaCR+4QOLZu48dST1qfte/NK44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Df74jNPXjABmsP3WtwZEhcHWa2ME8KxRwqFHXeGpAZnHc2kGnCwtaFmMEk0ALQ+xYHV5BKrzDjhUlZ+Moho//jkxnEAu+/jtnnMVTUWVzNMsa0KAjKJvBlL9FdSiETs3Trv1CXZs5R9iuCTdF2zJJmTa43IZfC6SdC7Han+yr6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYkcamr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYkcamr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE728C4CEF0;
	Mon, 23 Jun 2025 13:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684792;
	bh=W/M3JQAPDEBDNgkgDvaCR+4QOLZu48dST1qfte/NK44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYkcamr4SyMdxmk2jTUC/t8eHUDyjSxMuuroy2N81FvXEX+I0kwFZegHZHGUu9tcg
	 L1i5nFyvLd0Cf7LhHEgCqwACKgKyGAs5gdLMQ8k6YG21Ee267cKbAavbhIXuAsS1m+
	 w/jIyF4CIMix3OrzVKvypaZV41+4tBvA4e/jliNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/222] f2fs: clean up w/ fscrypt_is_bounce_page()
Date: Mon, 23 Jun 2025 15:06:05 +0200
Message-ID: <20250623130612.801594344@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0c708e35cf26449ca317fcbfc274704660b6d269 ]

Just cleanup, no logic changes.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8f78050c935d7..e7aa23f098470 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -37,7 +37,7 @@ static bool __is_cp_guaranteed(struct page *page)
 	struct inode *inode;
 	struct f2fs_sb_info *sbi;
 
-	if (!mapping)
+	if (fscrypt_is_bounce_page(page))
 		return false;
 
 	inode = mapping->host;
-- 
2.39.5



