Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F2B2F236B;
	Tue, 17 Jun 2025 15:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175553; cv=none; b=n7ACJTaKGl0pVCLvE43mdGLMIQUJr8/2XB6JkbqHINpDknyxAZIyrH891BQO5aKCWW0pB3Kwxmg+BAtYCkYJEk/xauw8dZ8UC6FPc/QW89X1NIZiDYmGQZDWW4z5yWC39ps0qAEg1F7/4wFhkLdncPPy9HUU/y58Vm259Z9UY6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175553; c=relaxed/simple;
	bh=IrvGHO8yEfEpow7CCIWVOkTjPKDzyn+4ZVbOyYzP6Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnSKBGzEKgTtJIHYur5ncR3yuF+h+ykrB82s7AaX/yYI8C2vGR+bVkV8OTMrGUScZHsIk5ZJh7KYYU/5xGsEwtyVi7wuoAAAY8pGlmPGtj4dle8kPMwpGNHkWqj9dBXx9p74KFV1pQMxZPcYb8vOecNTaat5nF2rRCMqJxQZzHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2j3wVt5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2j3wVt5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAE5C4CEE3;
	Tue, 17 Jun 2025 15:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175552;
	bh=IrvGHO8yEfEpow7CCIWVOkTjPKDzyn+4ZVbOyYzP6Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2j3wVt5lDYdjIQhj9obfstBa9d2xytmq7CChvb6P2BeahTzrtmVTQn55w15qjt3rk
	 DleBIijINaweMtopb5N4OKcx0aOU2+j24JXuZaaMaeW69B1SToF3Z0ot7ujJDwN06x
	 LYMkK0ssfqyBfSelbl8+RVV1vfVc4xoDtvIAiMFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/512] f2fs: clean up w/ fscrypt_is_bounce_page()
Date: Tue, 17 Jun 2025 17:21:47 +0200
Message-ID: <20250617152425.314816903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1b0050b8421d8..8564441cef9bc 100644
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



