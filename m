Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9185D20F090;
	Tue, 17 Jun 2025 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174688; cv=none; b=DH2WeoMd/2NLq0ciJNqgG/TnHd0AFUJucnQrJlbw9BFfjsN6FII7pMesYGxIvXFMmEdaI1w7kc7BtybLTLTIkTF+oQzxaKpvoOHiS7DJkuam/QUAworgKWl1C7psi0oMTeoil1stZVmnuttw62L5QsSVSHocQ98kRZNUnMG34WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174688; c=relaxed/simple;
	bh=xa9OP3rbg2+BjWpqcCA+vDrFJ//WYistmbC+/4T4pE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhqSZP/XM+At9BBwQyUmmtxZXueBjXxyiNqXdJ+TRbEryN6XesFxuZRFQlAix7xnm8lsR3rK7EYOIOZvqIl7FVCb0SrGOg794cyxXGLdfzCmOOkuKxxM064xoSQ9i6Aep6Hhc/vAaSRBazhzVzi2pH3o42N+INz+B0CCgBBF3hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBpfjVx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBpfjVx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9DAC4CEE7;
	Tue, 17 Jun 2025 15:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174688;
	bh=xa9OP3rbg2+BjWpqcCA+vDrFJ//WYistmbC+/4T4pE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBpfjVx8fKVHWS2U9NAMKU3giutMysTucxPgXk88PQywh5sjcJ7w6oco5gZIODlzX
	 LpNqNmRMJDYeoph267qVxyioV3UGi06V7bMrVGiFRLW172vJU4+16PxqgqNnsz9Lxm
	 zg1roNrRbTOWSRn+AFZimP69UzPoP5xSXuc9EcMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/356] f2fs: clean up w/ fscrypt_is_bounce_page()
Date: Tue, 17 Jun 2025 17:23:37 +0200
Message-ID: <20250617152342.332099236@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index acd0764b0286c..5a3fa2f887a79 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -54,7 +54,7 @@ bool f2fs_is_cp_guaranteed(struct page *page)
 	struct inode *inode;
 	struct f2fs_sb_info *sbi;
 
-	if (!mapping)
+	if (fscrypt_is_bounce_page(page))
 		return false;
 
 	inode = mapping->host;
-- 
2.39.5



