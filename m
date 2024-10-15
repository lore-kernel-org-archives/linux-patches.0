Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD4C1AF0B2;
	Tue, 15 Oct 2024 13:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997455; cv=none; b=X7daIpHRoREn6X2g5Huaq4v4a+gwFs97DpHcKaqxsMXfYMWeAEjBH5lVo+71h1vsuQOEpAyeeSr7JOBzqunn8mTdwfQ4O5bxNn7f5Cv6JMURucyHaWoIzyA5Xx8RKQE2yRBxxHrcQmamTQIB9IHzSUGm63S8vhkNTatwaprqTQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997455; c=relaxed/simple;
	bh=SWYUrmzJccAf2e9WnDpcGni4JBzIgOuenqAbjyMiFGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmiKQ+v+zphKNUhRXvqkYKSay3qBkXozE8XaRHQO2vqRihHWrkfykMBqa6NdXAZC0r8OWcz+U3AJPedLTo1NP+jaWCfJTxweY+zaX0uqfHxaNEy9oeCSRf1uPSHBJTaL0362c4KCOiWWpM1jpi3w6V3UUA31xCy1YPP0JmlIuEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezgv187f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezgv187f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880D9C4CEC6;
	Tue, 15 Oct 2024 13:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997455;
	bh=SWYUrmzJccAf2e9WnDpcGni4JBzIgOuenqAbjyMiFGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezgv187fbtfVyH84E5FMs76E3vvX8m2M7kx8Blq8n6/THO619ncFvZ5DZp77hec1n
	 ADQi69FVozHrTtLu22f4CdPfRsy/h5sx2+Th1Kmp0ahpciP0U0FLCUCaYcXp4SL8OR
	 8hXKtKB7iATRawTUTlSaPYTqh0HJPGzAJl3Puwo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonggil Song <yonggil.song@samsung.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/518] f2fs: fix typo
Date: Tue, 15 Oct 2024 14:41:31 +0200
Message-ID: <20241015123924.203738505@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yonggil Song <yonggil.song@samsung.com>

[ Upstream commit d382e36970ecf8242921400db2afde15fb6ed49e ]

Fix typo in f2fs.h
Detected by Jaeyoon Choi

Signed-off-by: Yonggil Song <yonggil.song@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aaf8c0b9ae04 ("f2fs: reduce expensive checkpoint trigger frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 4380df9b2d70a..a858a1f7f53d0 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -249,7 +249,7 @@ enum {
 	ORPHAN_INO,		/* for orphan ino list */
 	APPEND_INO,		/* for append ino list */
 	UPDATE_INO,		/* for update ino list */
-	TRANS_DIR_INO,		/* for trasactions dir ino list */
+	TRANS_DIR_INO,		/* for transactions dir ino list */
 	FLUSH_INO,		/* for multiple device flushing */
 	MAX_INO_ENTRY,		/* max. list */
 };
-- 
2.43.0



