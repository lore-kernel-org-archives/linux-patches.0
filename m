Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B034C7F;
	Mon, 23 Jun 2025 13:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685606; cv=none; b=S+JE4/fEhIvymrhmATHrwZqOLi4PfLNbI3cuUh+JoHNmynlHsMvLslkgbJS7owLnsbg/Ll3U0p6wiCKDSunVVvOp1HkY+fKgH5hUgP+4u+xZNilD9LgXSCrDLnd5jdehZCnW1KQu4Ekv/GZHHyD6WsU4reMzAIVVGfFyQzS9jQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685606; c=relaxed/simple;
	bh=LoX4SIzL+S6weSXCutQQ88VnBM34kua7YEfsW0FWHec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwcMhqwzrrXsK/1HkLL7yP3aEBp/pO2MZXVz/xhwT7IQUJqQ2AYnrLMUFTESleepPE/96e4Cf0Oi60/H2JZiAl8fGj/nVWarNGMkOIclhuJOKvV67PEMD68cDEi2Hn2hYZ+39lxO/it2s0pTEeleL8oE9bO/DJ2fYTaAe6JCOeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KF6at1x2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KF6at1x2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BACFC4CEEA;
	Mon, 23 Jun 2025 13:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685605;
	bh=LoX4SIzL+S6weSXCutQQ88VnBM34kua7YEfsW0FWHec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KF6at1x2pv4xWr2+GIAZXtKwLpUiSHPjrigHUG4EpOR1ow4K4vZWLbw9kdou2iIH5
	 Tfb1RFvr47+3/n/33UKRNL/m7n9PoWNMjKjz3/FNYEMVKwVgYg0dUF4BixeGFE5LBK
	 Y5llsBY0JApDCNwqJ/JJgsW5xX0aG0ZK4LhPIiVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/411] f2fs: clean up w/ fscrypt_is_bounce_page()
Date: Mon, 23 Jun 2025 15:03:10 +0200
Message-ID: <20250623130634.382051180@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3f8dae229d422..b5bcfb8288a13 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -56,7 +56,7 @@ static bool __is_cp_guaranteed(struct page *page)
 	struct inode *inode;
 	struct f2fs_sb_info *sbi;
 
-	if (!mapping)
+	if (fscrypt_is_bounce_page(page))
 		return false;
 
 	inode = mapping->host;
-- 
2.39.5



