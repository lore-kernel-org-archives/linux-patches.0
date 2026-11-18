Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045692;
	b=VAi3aaVr6iuTX+8a8NC1FUWfs6pjT46dXFfuUU/c5lqzanJxguYPdiOx9bCqsxRYQKfK
	 sDuRHMES3Swj1J3WL3o9BJcBT5KR9oYsdyvvheFN/WnZXAD/WLtKoly8D499X49ZKQsap
	 r3XZ+W5ZsmuSS82WHyQ+VqZwdzN5XvoUYLAFN8HP5mNdwQtCBflNcuAS1xvvT+TbrGioM
	 KvDGhdz30iB6XOMGLGQjvdd/IrewP4TLcd0Adx171/ULcVkn23Q6rzSRyCRNQH9pzmrIb
	 je45JkCBW8RY3vjYH3Uw9Lw3XbO5VGa7PE1neksTYYHHxNvXH+4pmI4EWTTrMHhr2lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=52wEDVJ8jylAHLSNFwJr8wjR0efOBAaBHD18BteykeY=;
	b=ETR9+x6UJeWfTiDMe4QEKcIA0Ydj+DhO820LYfA/mdr4xJl4vIo40oAONwaUZEdSzI2m
	 JuYlfgJmSJbJ6jxFqFVpYb0JecQHQHof5ukjRTwvEPYcZBhmvzIrE4REmTNGKYsAk0BIY
	 WS2rgltOUacNCnw3VtAaUgjdJqrKti023X6O45dCpZN5K71soWGvzjyLGZLE+gnD31CWa
	 SdldBiFi+oHapdzs+erUsERjcPlhl9RkNmsKMuq8RhvO1kj6kHVSmgULPRusg9vzhrAW6
	 BNlkVJtB7U57+UH+gWElZDnKwc7GgcWksnImJU6IzFspew129O+6DDA9QlHwP4JkVig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dm7oI8nW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35376606A320;
	Wed, 18 Nov 2026 23:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dm7oI8nW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEB81F000C4;
	Wed, 18 Nov 2026 23:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045691;
	bh=52wEDVJ8jylAHLSNFwJr8wjR0efOBAaBHD18BteykeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dm7oI8nW8ik6Nxdiikri1bwQrWgAOfAMJ3JDAR3KjDbQdgaXR/6V4OXCv+QS6lPsm
	 z0G69USumryDZ8rbJQ4kEQa/7l3oIA8BtgbNs4qGqgvzH0E8NRsLeV/omJ3LgYG1G1
	 iV7N38mwg+BP5hWA6wxwriAqV39w3EevL08TiaIw=
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
Subject: [PATCH 6.1 0987/2857] f2fs: flush SIT journal during filesystem resize
Date: Wed, 18 Nov 2026 15:33:41 +0100
Message-ID: <20261118150237.141018393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bf52ba8a32c04..0d002abbec3e7 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4082,7 +4082,7 @@ void f2fs_flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	down_write(&sit_i->sentry_lock);
 
-	if (!sit_i->dirty_sentries)
+	if (!sit_i->dirty_sentries && to_journal)
 		goto out;
 
 	/*
-- 
2.53.0



