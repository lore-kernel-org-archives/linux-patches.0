Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057593;
	b=Sd87MGyu0si/ivs5EP0nu3F+SH00xIvLKbSgW2nLmxAZ0Ab7Sk1HYdYfMgpCQe7fdKQR
	 l8bP4pk8kHek/zLEeaI99y9Ga2Ha+KyuXuQUe4yAPDA/8T3u1GkFZOaE/iugsHlRbGBb7
	 9hwbmbEUr3c5yx1D3WNYEcbFtjZFp0zoHegYtM7k/h2RvVn386MBc6FcOpSbWUPDG4VmT
	 SYKyD0GageUFeftzV2hxwP7Vai7czs+ojOfo4CevSjZDnRKH8G6qEpdJPJvwgbOULv2FP
	 roKXkqWvyBdk3NLuAjpKixQns1k/8y7yCnYuFVD11K7RCzF6Ct+P9ETTOl1EUiVw1/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tnjCRcKB+KGC0lJiF4idbhcSZ+gN9LpiSnqy6GxNlRU=;
	b=zml1C9ONFdK/N1NN6MxhQIVUeGliOp3BONZGp+4jhVpdH6Fb1vxlwlnOIUrl1umSHFI5
	 npeY6IpEJPa9HBFOAhdnnYh8v/Aovdh3fuaRDsi+RXIGSPDhTDowPBe0AUZnU6/7oEoL+
	 cq1vAak+myj7cSVMgThunLYA6b7N7jqpnrCuhnqFEOslgdtuu+HWrO/bpn6avpFmu9hCV
	 Pr2EDG7J90nZJTuRLu/pyMa7Uv5uFvIlh7cov1Rqkoopi+sstfgsQ3cMq8D5hPN5Usyro
	 l2mK356syQmVU6BNo4O34so5oVm5ky96kegK3xWw/FzO9IDU4wgVkR6zMZjExd9ACQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cz2C3sKT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97941606A33E;
	Thu, 19 Nov 2026 03:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cz2C3sKT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E555D1F000C4;
	Thu, 19 Nov 2026 03:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057593;
	bh=tnjCRcKB+KGC0lJiF4idbhcSZ+gN9LpiSnqy6GxNlRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cz2C3sKTW2nFwpqowdIgF6H+8XcNNnzCUqJnEbU64HpEOVmhV/rwxQLeq7299lmME
	 T2M6YEOXDvEXqdHcNaZfjF6WrSvXEDxCxmrJjleHa1Pf9Hnksu+eaU9l4ZALlsHcJ1
	 jkS5oNqyf30CP0ALHkS11VW6EyGgGpeaFLglnjxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0186/1848] f2fs: avoid setting SBI_NEED_FSCK on transient resize failure
Date: Wed, 18 Nov 2026 15:37:04 +0100
Message-ID: <20261118145919.424298276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 258c95150c26a30db1896eacd3bdef26314f2ca1 ]

When free_segment_range() fails in f2fs_resize_fs(), no on-disk
superblock or filesystem metadata has been modified yet, and
free_segment_range() safely restores all in-memory counters before
returning.

However, the current error recovery path unconditionally sets the
SBI_NEED_FSCK flag and prints a scary error message on any error,
forcing an unnecessary and time-consuming fsck.f2fs repair on the
subsequent mount/reboot.

Fix this by separating the error recovery path with a dedicated
recover_user_blocks label to bypass setting SBI_NEED_FSCK on
free_segment_range() failures.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 651dd392b5b93..f136a6e5d7348 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2070,7 +2070,7 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	err = free_segment_range(sbi, secs, false);
 	if (err)
-		goto recover_out;
+		goto recover_user_blocks;
 
 	update_sb_metadata(sbi, -secs);
 
@@ -2091,11 +2091,14 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 		f2fs_commit_super(sbi, false);
 	}
 recover_out:
-	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	if (err) {
+		f2fs_bug_on(sbi, err == -EAGAIN);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_err(sbi, "resize_fs failed, should run fsck to repair!");
-
+	}
+recover_user_blocks:
+	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
+	if (err) {
 		spin_lock(&sbi->stat_lock);
 		sbi->user_block_count += shrunk_blocks;
 		spin_unlock(&sbi->stat_lock);
-- 
2.53.0



