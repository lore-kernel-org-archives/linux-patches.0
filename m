Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD8C1E0083;
	Wed,  6 Nov 2024 13:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898104; cv=none; b=tRbd/kn33QtTbz3WubjaMYokqzRhZU4dZJakOrs+zVM0eqxnRV8EbPrlQM9szvPQLtDVnHgnAPByBkKdvbAmOKnlvkSrqa8aeaEqzvBGEsPZk857EqxPzMSY0GYBSt2U2KvLgpEHBrBJX/j7S7INwPmwR3GLPyLhTjROcdqRGbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898104; c=relaxed/simple;
	bh=p527/NeLyQ9Oty9fgPs6Vd8C5OfFBKvyqBxukBDHROY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pk9BGlERbarivP3RQFs78TgF5xGapatbfZ6QWtDbN2pJleApV7U/ffXzjxmQmYnv9IB1ELdEbrKux97vQJC/fuFUiCl9QfJcZcTX+dKK84Hp6kbWTloAWIe0hBb3nmygELTIu1FTzAdLRGt69LxjGCncnZ0bBX723WirS0pVLTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOMb2doe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOMb2doe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2A7C4CECD;
	Wed,  6 Nov 2024 13:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898103;
	bh=p527/NeLyQ9Oty9fgPs6Vd8C5OfFBKvyqBxukBDHROY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOMb2doe4hiIt1chuCkgtyXvlnOEWM9BfOPG0iYGdL40k4vp9975N/LRxMklkmUTT
	 07IfLbgZB4CD/AOLs8M7VLajvlnFs2HHxjzw6UCodBxoUAF6ZCa5Riv7h7hQX9N9sA
	 TYmFnCq3tA6/gKyyFsZi3WxEUdjvWS/ArtRFm6A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonggil Song <yonggil.song@samsung.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/462] f2fs: fix typo
Date: Wed,  6 Nov 2024 13:00:19 +0100
Message-ID: <20241106120334.619476427@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f75d256827346..2143b0f762d56 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -237,7 +237,7 @@ enum {
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



