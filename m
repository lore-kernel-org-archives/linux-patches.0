Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043605;
	b=HK/GHCxvEj7K+yx67kfhJAhojgshG/q86YI3++Je/ez3K9ZBD7oXXcx0VZ1pi4p73KYt
	 DXf1Jp7lgPzm7etnG4rFeqWVnUctLqXlRJ3z0W6a9JDcYgyySc3dIhpRMlxuFHSWgJk2H
	 qcE87T7xII7hKa0QOZqusp0OYxLdiqe744zzXnD/3l7Et/8WgA7Dgd1PtMsXobHlbqRp4
	 5Gjx8MIUh84h8Sc7mg+xaR+9a5+ctrmNpPyuwSfkJMlyvF3l/R6ZrgyFG7B3o2qnaOZqY
	 huEAimjj+FouVARV0yy69N0FmNAt6GAqoECFNqkelTRBd8Qye2JCZ2NqJzdSfP3OHxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UE9KS4ZUcjrz+B2U5KUHpPm6FXBw1gCv/N/dAavk3yg=;
	b=QGrmdHi+qg5MCQN+9U57hnitjGdj28Aw4TMlIL8Zip18zn7Dwsr17pllGGlp4Ws+C+SL
	 xAQwpBijjsMqsS6eP8sG0ZoILCZpKZNADOOkrCFQvRor9aqsLYmuuNd2jcFJTix8oakoq
	 9Nju5e3I5k8c9jDjysa/OokOTjqWyaW+OUQgtT6mdyiSOdu3diWliTZIPIFN4ErKhaJqj
	 CjCIi1grhYjPga/niYbUdgSYJTvt2LIagatXYR512vipd1dMC/QTIYjNj11i6yE3tgm0V
	 gAspwcyN912lozttJLu6/M5w2GAUtd/XB0vlydeDw7eIgl9EVINIQGZXM0d5XSw5CNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZiOTUfdu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5283606A32C;
	Wed, 18 Nov 2026 23:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZiOTUfdu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EF11F000C4;
	Wed, 18 Nov 2026 23:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043605;
	bh=UE9KS4ZUcjrz+B2U5KUHpPm6FXBw1gCv/N/dAavk3yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiOTUfduFR9goM270mmt1g+nFKlenZhU1yyq3kyzLpUUVboly8qWxivk1cG0ap/DR
	 3M/EIlnP5kL5ygvi8ET3BFb1yGozkq8Vt6jh0o47uftysVWAj+gUcAmWKBj67lf+Ln
	 0uJNd4AluE0WnufN9tmS3fXVXLkEi2s2ri13v/Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0269/2857] f2fs: avoid setting SBI_NEED_FSCK on transient resize failure
Date: Wed, 18 Nov 2026 15:21:43 +0100
Message-ID: <20261118150211.112981438@linuxfoundation.org>
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
index 851f55aa37f4e..ce543f07e9eab 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2233,7 +2233,7 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	err = free_segment_range(sbi, secs, false);
 	if (err)
-		goto recover_out;
+		goto recover_user_blocks;
 
 	update_sb_metadata(sbi, -secs);
 
@@ -2254,11 +2254,14 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
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



