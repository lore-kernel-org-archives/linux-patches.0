Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034290;
	b=wz+TfY+eOHJYOIdMXtQeZY5H/7TpQot+7fjqRddXKKkJUl7JuBFKLXihjO7ojC8l+FrX
	 VTcsszP1jubsn7XWgZqQV2lW55oxp85R5carhLhvDcKCs5fMicKk1ZpvtA1dmqFhVvtaA
	 H4azpVAHXhXGgEO6yQvTiv9VLz2scjxIv5uGFmE72AbP7ILYWXSMgCuDPT9rY88akL94b
	 5hGl6+AGQPjydIXM04mtT1OXsAc02cXIuyIUMsOBcMSDCX+hLP2ZR/nCJabF+CxmOauzl
	 vUFd7J0Q+F7MRIE+3/jlEU30BF+X6yJaDhU3+aM8v+S2tPR0JqV+wefpRfzF05bSfDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PGb1RSp8/7N/webbtTs87cb7sxQsQ7rt0xd8xmL2QO4=;
	b=myoBtKBGMoMof+cYLW8LM0gunzPTGOA7Ze8Tx3uRM/Lbkj5zRDtBNZ+iALJh0TDn8EWT
	 L9JlRgKmYFr0ltFTA9MBivboK92Vd1rAId9NomxOqDoderVMmo088akeSjOQTv2xKhKk1
	 q2vhR9m5Tg6c0sVYeEtr8UN4jkK4Y5z81js5+Hx2Jj9I8QEK5dejhCC07hHuVlcJOBQU8
	 5/GdUSXTeJis+fDb8S5xnJ0+3rgS0rBj1c24y5ED2rwN5Nao9F1dPcDLSPpzIMQCAuldK
	 eE49DZDA5ypAZaVCUK1xjC9k1mbj8QFd4nD6nDfqzXCpygi2mEiE8x2rP4OQ9DOE5sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLE7ltR8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE45A606A32C;
	Wed, 18 Nov 2026 20:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLE7ltR8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62DA1F000C5;
	Wed, 18 Nov 2026 20:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034290;
	bh=PGb1RSp8/7N/webbtTs87cb7sxQsQ7rt0xd8xmL2QO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLE7ltR8vuM3BHOBzZl43/vyzD3z/lwlyEgwzO93ImsjVVMnTLkbiEAdGt7ghTAhY
	 u7agbVuVbEz8Muz+pHugBbIeea4NWm0N5ZKtVk0Y4psZn+e6885NXszIU6a4M1Cia2
	 pNFicpvy4R6yDNn+1ixevslmDxusAyLnZ4pbeN3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0316/3318] f2fs: avoid setting SBI_NEED_FSCK on transient resize failure
Date: Wed, 18 Nov 2026 15:15:38 +0100
Message-ID: <20261118150325.310761476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 663050f4bc19c..e4edeca71c363 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2315,7 +2315,7 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	err = free_segment_range(sbi, secs, false);
 	if (err)
-		goto recover_out;
+		goto recover_user_blocks;
 
 	update_sb_metadata(sbi, -secs);
 
@@ -2337,11 +2337,14 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
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



