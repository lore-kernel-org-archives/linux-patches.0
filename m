Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047170;
	b=WqgrmsM8ND8fJNosDl9nxrnrxqEsLtuKPJ7v0R9Y+OLk0Tlu/70PAD9IGoPvuQWcYarG
	 wmnCe2k8jX84Ar9d3RnvdKfjjJ8lXERBcYE7AqiukZriy39J1Y/7LWW0Im/hpjETgBQ3r
	 1/dvncU1M7A5wgwWlMWgOLp59hq7EHzPqDMwvU7vECpXvM/LTE9+jrZRjn6wKorTawd/H
	 sk+nuFY6DO6y1JnwZDrcgkskxhIABA1pqtZ4KkJpIfWrYf7H/hkGzX8sMf5isckFGy0vV
	 ukUvbfI5ESCDf5J9F7w3ylZNocIWwrHKFJCTcHd0WByKqfBM0LrP6D25a70413DRN7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wUQt1WcITtvajTiBZDDH+PmtBh3RaTOyRoLLwzHQ5Kw=;
	b=VhpdkU5IZw3dfILT9ay+NtPBYhWIvP56bTJFRfiaNtrk5hECVhBj0hMlEiGm9FPFJ1BD
	 4iU5Ul7TLAYG06UWPjG/dpqr405cD+JhXgUUPLBVfz19ZlGC/Nl9iKqTbmXzScvVhh3Dp
	 p2GuWsATQVG1cDCtM9VKL9tSNzvz2cNdFSNhDrN8Jh0pJOSvsSO8+3LeQmIblAYXtl5b/
	 3QFZdgpibcI4S9U8AvWQDhov9e+zL1is1BXSpTkerqW3viPl0fuQy893fsVEkRz/8Q4HI
	 D9IqQ/tzphIp/Qp4EXlc7efsdrCs+h7gZ9FGMod03xwiSwBcnqZOCGg1bUBpXZAMz7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lwG3xpAF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258F8606A31C;
	Thu, 19 Nov 2026 00:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lwG3xpAF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760B71F000C4;
	Thu, 19 Nov 2026 00:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047170;
	bh=wUQt1WcITtvajTiBZDDH+PmtBh3RaTOyRoLLwzHQ5Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lwG3xpAFDLCxlpiB77PtrxGcwcjuU5LuAcZBFeBpkz4lUing8xD0R7VwqG1gqtfic
	 6pusTkcGp6E5ZVfzdJ5KDZynqrVj4rxVVRpy/AhJ1QobIO++aHFqDbRyIFfxuSLL9s
	 TRug010dwuDfaph/76BmB14Rb9/B4SxsrD1A/Dwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1542/2857] f2fs: fix defragment writeback range truncation on 32-bit
Date: Wed, 18 Nov 2026 15:42:56 +0100
Message-ID: <20261118150256.845304258@linuxfoundation.org>
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
index 6a43efe936d18..e94d30e397e2c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2769,8 +2769,8 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 
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



