Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F35923BF9F;
	Mon, 23 Jun 2025 13:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685257; cv=none; b=iIcfep7gtoDVbWo5vAWAW10BSlBR1EY8iTEhZ6DIczbWd/Zjv3Eik5FYMowOVgohmo6rAYppySscZtI+2NFEmo4971D2mSEz+8F/oMKeNKAHcvE6rTjOsPq1AGP4cfalG/+iQas1WxBbLRzPKeN2iecvxuomY7tOvBCNNXRcqM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685257; c=relaxed/simple;
	bh=HMdhQYN8FYv///ESf/rkkDHGFOWzplzjizIQfnfwueg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwN6WT68IYlD4HGBSW78xpw39xjv2VD/nbSk5uUnxGvTz9ZDeu9U1fBIz2jUxIv1r5QWKfJVNwU9WE51AOFWSBE/7XQ8rFgujIMuEC5m4iVcNpCFXc6NHII1XI9BkuTUf6DGFFjuBSyh0CZIFBkQozBl+ILl8YfPUJNCxRoXwzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UYmdtJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UYmdtJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B616C4CEF0;
	Mon, 23 Jun 2025 13:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685257;
	bh=HMdhQYN8FYv///ESf/rkkDHGFOWzplzjizIQfnfwueg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UYmdtJ5snHemRnXvj5UKyOyW3xFwxN1RwPiel72usG2Mu7e5cVd2zFlAjd3/jyVn
	 sCA/N60I+DUGfmNhFTrZjktk+CHh60aSKobyrifeLHIyA+0QhrMZ2RZXrWxhrMutuo
	 aR6EFz9wyqEEM4vQiQMsr/sTIV+la5ufaiHhkfhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/355] f2fs: clean up w/ fscrypt_is_bounce_page()
Date: Mon, 23 Jun 2025 15:04:00 +0200
Message-ID: <20250623130628.001580060@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1b764f70b70ed..9eb20211619d3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -77,7 +77,7 @@ static bool __is_cp_guaranteed(struct page *page)
 	struct inode *inode;
 	struct f2fs_sb_info *sbi;
 
-	if (!mapping)
+	if (fscrypt_is_bounce_page(page))
 		return false;
 
 	if (f2fs_is_compressed_page(page))
-- 
2.39.5



