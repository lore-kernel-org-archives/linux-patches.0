Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F391F582A;
	Mon, 23 Jun 2025 21:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712881; cv=none; b=kW514Ni1LSR5MjdcBDLJxk7OVdAa21nnkHz+P0B5tVyiMCtuMmsCw+nf7C7z2usKi5MAx+wTdGGpsAwr1FICmOQIns8KT2Gd3PFIVjOYZYCEIJ/PxwI7ZQawT9rEsQuq1pVgX7je3KH9xiJQyKSM1cN+a/PrxEhy9k3JPhAERRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712881; c=relaxed/simple;
	bh=k5Jc/9gwucAXKMZouEvHR2oeIpD1UZwZV9W+C8IQrbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toj2yJrA8dL/6+FJMfFarXW/Uw3DkHMBAXO9ed2XUiXJjDH43lsVDwV5UEo0HPvEA3WFNBkgOWSTMq2aqCH4y0xF7i/f3xmemF2gb3GUZLkQhP58u92Ln5plP0HDO8IKAwtSEMJYQT+BLdVj2nwFyxgfHYSe1DgwzgaRctqKTMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u17eQdVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u17eQdVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E320FC4CEEA;
	Mon, 23 Jun 2025 21:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712881;
	bh=k5Jc/9gwucAXKMZouEvHR2oeIpD1UZwZV9W+C8IQrbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u17eQdVqvl+hZ12km7pyk1nN7+jTO4IuVBSMXG6knAEOHJgWDbObd+wRiucqs18ev
	 hLYCKpWKBoV2NCP99aN/PVHdUbIfgrMNYBOQWUov7Og4Iy77D0N8GhrUavHdZdg6zb
	 IVNj4ydrIRMWEyQyc5mQgo1k6R5SSA2eidEfTNtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/508] f2fs: clean up w/ fscrypt_is_bounce_page()
Date: Mon, 23 Jun 2025 15:01:50 +0200
Message-ID: <20250623130646.841923352@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0b0e3d44e158e..2ae682f8d0c8e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -56,7 +56,7 @@ bool f2fs_is_cp_guaranteed(struct page *page)
 	struct inode *inode;
 	struct f2fs_sb_info *sbi;
 
-	if (!mapping)
+	if (fscrypt_is_bounce_page(page))
 		return false;
 
 	inode = mapping->host;
-- 
2.39.5



