Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052728;
	b=eGaoFvqF50LKLwabhCqOmLGAsdqvsVzZ9FWNYpvzHsJaMbro+BKwS17hxgySECjguPTL
	 s9PtpjsjU9CtquBWPVsHjeWadhJOw2ImuXafmI6BweX1GKThLi3N+J0unAyN6YyYSuM8Y
	 w9GIFkGpTXFDZ9qIbtunoc5YIBjkquDG4Qizu33Xv4eFSl1hIeELrJqIC6knas1FNs3Rq
	 3YzCEuS372v602NagebS4C/UyjFUDmnfy3Htym+jwFsq1X2ubscBUN44tDHS1tHDifYq9
	 AgbvchPMsxB4+joNX3K9m5ekfYFd3Lx7TFmOihCVUa/ckIcBNAKRfsEEzm/e5U4I/Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hbgXz2RhuKB/fldB8gP8/kKOqA8DKBaV0G1OdDraFww=;
	b=0gvRab2eqiuKLkM8SND7lJeQVGoKbiQVB6Y4eBtBa47o5c5idMyvknz03Tzqvmb4X2EV
	 GkHx6Hz6HDrJjMZlJgE7TOS5R+r6kOArpXNpzs0NX5ST0EjLZdh9XUF9zF44cct77KqVy
	 WsPRYxKfVKPhsUBD/JiQQqK3+7dxMqBAD3PadtFLZwJryMC1tC+8lXY7AqAM2va9DDv3g
	 LIWYoJ6UoTQUpFO4uPIm2tfgEYOPutA27FgOYKVXlNyQ45oGMU+VpT09OzKHrk78FuoGX
	 lc4mJRnhb0+/TbKxthuKentmVymGIw1wgcx2YYlFDIGMN7SLILwa6xl6M+vZa/AVjVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BxZ7Gom;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A97F606A320;
	Thu, 19 Nov 2026 01:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BxZ7Gom
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEFD1F000C4;
	Thu, 19 Nov 2026 01:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052727;
	bh=hbgXz2RhuKB/fldB8gP8/kKOqA8DKBaV0G1OdDraFww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BxZ7Gomc8EO/ulC8xT0kQQdY5V3AlzPdi7evY5hTqVPtTbPh5xHwDh9gF7YW0c6R
	 AWUKzxSSAmQSDwFsn1YN3O4xu8ujBXWim9YKBxZTt7cWen6uGKi7kFW6b/ZNbYt/J/
	 TjcSZEvvu8JS3MvEZpT3G0RG3ndJofgIYERHfQBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0666/2214] f2fs: flush SIT journal during filesystem resize
Date: Wed, 18 Nov 2026 15:39:02 +0100
Message-ID: <20261118150038.482174675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit a6ede405455106bf42164ec96fd84008c5aabdd9 ]

During a filesystem resize, SBI_IS_RESIZEFS prevents new SIT entries
from being added to the journal and forces existing entries to the SIT
area. However, f2fs_flush_sit_entries() returns early when there are no
new dirty sentries, leaving existing journal entries behind.

After the main area shrinks, a later checkpoint can access a journal
entry whose segment number is outside the new geometry and trigger
f2fs_bug_on().

Only take the zero-dirty fast path when entries may be written back to
the journal. This lets resize drain existing entries through
remove_sits_in_journal() even when there are no new dirty sentries.

Cc: stable@kernel.org
Fixes: 04f0b2eaa3b3 ("f2fs: ioctl for removing a range from F2FS")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 0d10bea639372..f070ec5995a92 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4232,7 +4232,7 @@ void f2fs_flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	down_write(&sit_i->sentry_lock);
 
-	if (!sit_i->dirty_sentries)
+	if (!sit_i->dirty_sentries && to_journal)
 		goto out;
 
 	/*
-- 
2.53.0



