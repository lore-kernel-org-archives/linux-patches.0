Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064752;
	b=WOnb0mjcIzwczc5xyAaWbjGdjT//pctTg5IgsJfcYORVWG8rx0Nw52Cx77uZqZVIn5xm
	 xIXhV/DsYRPX43uRR88NnWpkbtGFg6TJqDaGDI65l13QlzFzMAakOClPJVlBIUfEOLzrf
	 CF31La1+UoaUatFmeDyBbUudcLNuypJWdj0miO4Iai/ybKX2kULJV2bDRwsgLzwCU6JN4
	 3tvj2GvCpMMF/3hNQWXcXPZZjU/LvEFQLRyyqPJW3vu0/jgsI2y+iC3+LYltYhVxQQ3AZ
	 sYXpd1yAq3HKO+JvEVWwe1oOxyDoDBEbuLaECAaKf6P5HHHXqmjDDRkb1F3Tjkg2XUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s9iAWRukTfci2j7hA3bGVh1UhCzlJBeDC8F3YqKFrIQ=;
	b=rhtnq1LjLSRheQkC/XpYrX7ToZBbX1cP7wDXdaHfGa0do7RUlCVZ0/+JuReDiCUJu25v
	 CEV7C5Q4jMjnaTV1qrMJEhTJbqVXQLaCDpHcEWdrgwJ8n/WwL6xrX57cT5iMlGQyMyfOu
	 NxGTSlmBWXfJLgeXZsYmkwEk7HUSOV2qY+a8Pw8agxKgfwLBGMm9YB/7jMBElbYvnAf5r
	 s1bVh+1qY2GQYyYwMcaCL6g1U+IRcxJByy4jNwkAKVuTk/ouMuUsJBUehK8ddh7pASpEy
	 E1CcBUei+jsst8fCy+bzaP+mFQPoHtBzXlHk4e2VJPUmfYny0nv+803oQo1xn1ehfqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbIES1Te;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79B5606A334;
	Sat,  7 Nov 2026 15:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbIES1Te
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548581F008A1;
	Sat,  7 Nov 2026 15:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064751;
	bh=s9iAWRukTfci2j7hA3bGVh1UhCzlJBeDC8F3YqKFrIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbIES1TexXo5ZHLVykW4MAKNr8FyoqU5c3FKw5P4vbVuM7xB57BcNeuSL4/En/CKv
	 LgSEWue2selInrbFLITtOfEnO6/iBLEGM6cqnMBXw4/8SO2SUmddjFHBSorEUB7Zi5
	 p3lnDcNiG2ujJJUDGK6F1LTwXmYOzFifzwYnD6V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0725/1257] f2fs: fix defragment writeback range truncation on 32-bit
Date: Sat,  7 Nov 2026 08:50:21 -0500
Message-ID: <20261107134959.287247667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 92154fe28c3701bebf75176dc5522bec62519a8f ]

f2fs_defragment_range() flushes the range it is about to defragment:

	filemap_write_and_wait_range(inode->i_mapping,
				pg_start << PAGE_SHIFT,
				(pg_end << PAGE_SHIFT) - 1);

pg_start and pg_end are pgoff_t, 32 bits on 32-bit kernels, so both
shifts are evaluated in 32 bits and truncated before they are widened to
the loff_t parameters.  pg_end is only capped by the file's page count,
so for a file larger than 4 GiB the shift wraps.

For a 5 GiB file pg_end is 1310720 and the range collapses from
[0, 5 GiB) to [0, 1 GiB), leaving the rest of the dirty pages unwritten
before the blocks are moved.  For 8 GiB the shift yields 0, the minus one
makes it (loff_t)-1, and the range becomes [0, LLONG_MAX].

The matching call in f2fs_collapse_range() already casts:

	filemap_write_and_wait_range(inode->i_mapping,
				(loff_t)index << PAGE_SHIFT,
				((loff_t)pg_end << PAGE_SHIFT) - 1);

Do the same here.  On i386 the shift changes from "shl $0xc,%ecx" to
"shld", i.e. from a 32-bit shift to a double-precision one.

Cc: stable@kernel.org
Fixes: d323d005ac4a ("f2fs: support file defragment")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6843c2aa67444..da7564e4904f0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3029,8 +3029,8 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 
 	/* writeback all dirty pages in the range */
 	err = filemap_write_and_wait_range(inode->i_mapping,
-						pg_start << PAGE_SHIFT,
-						(pg_end << PAGE_SHIFT) - 1);
+						(loff_t)pg_start << PAGE_SHIFT,
+						((loff_t)pg_end << PAGE_SHIFT) - 1);
 	if (err)
 		goto out;
 
-- 
2.53.0



