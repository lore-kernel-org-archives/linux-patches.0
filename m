Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831006;
	b=PBVHlR+E4sEYQpKI/tODOofMPsr86FxBImvpYTjDy3DQ8gk7cN7MosmvAjBlDZNtGy+/
	 zrwZdZNriQ97ZMdr2r2xtDgocCJdHXSj4qJNhD9JQFh5BH2zVSOvDsp5fh3VmAEZcgZ9D
	 kDMOrG0/jk3Xf/v80OeMK0SsmfXgkc68qivqL8AfY/SKSM0DpMJ5dQiStscq8QsJ2j+pT
	 lIKx0R2oVhjKjrkMPd249dHBmRzgnmiWuujkTmoOl+sSWhS9n1i911Rdlpagg8UPxKvUN
	 fKj8HY67ipL2smQrT++l2/kppckLpp7V5Grtqg6oXtoz5EhmKcimVcPB1xtH3xcOCOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yqjp6zPUBBWpOzgJnE7O0pTfVCd4SLf17ggK9MWh8w4=;
	b=WLY8SVjDxXCbQxRYWhl1kTFrbyAXWPihebRix/7Gd6mvlmamkREmlT1AThM0dc2VxKHz
	 m3S2fzZXnKGdr7Xqitl72Fpgk9BVlntUvJFVWskVgG4xCQ4hhRyOyxz2Kbp4tPXfeSFmy
	 tojo6922AmXMJhPFaW9XSS67sH3/tJWSRAFF1P3AsL/n+msysu8f14No7fJZYbgFIp2X/
	 GeR7imkLEQW7qyNz/oWx5E0SNks3kLzLbWTLn54m4dUicS5eB1W9FR0Jd07FlLiolso5E
	 HbSAbwJvLqNXWZk5eqxMHELsyQ1cdXIfUIjGQ/iO7w+ABMzpfr5vZ4yQ4zNyxnqDWsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=St7zyENH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0979606AB22;
	Wed,  4 Nov 2026 22:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=St7zyENH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492B51F000C1;
	Wed,  4 Nov 2026 22:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831005;
	bh=yqjp6zPUBBWpOzgJnE7O0pTfVCd4SLf17ggK9MWh8w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=St7zyENHfWgoS/tIdTWOnagbj1KbgTC1BqnonJK1ku1lKn7faeu6vKkqrVWW+MlY+
	 pj3aYDcGjcpYlVjTN1dnwLBn7/14p+DX0aiGeWbZ5bMYZFna1O3U2rL5EuEJFGfPyq
	 CegAjML0D6HN7vG1vPbfxT4I81xSk3BEfzXmIEXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0451/1005] f2fs: avoid setting SBI_NEED_FSCK on transient resize failure
Date: Wed,  4 Nov 2026 16:03:04 -0500
Message-ID: <20261104211056.680317397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 02bd008d79b5c..e85d7f239e7d0 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2415,7 +2415,7 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	err = free_segment_range(sbi, secs, false);
 	if (err)
-		goto recover_out;
+		goto recover_user_blocks;
 
 	update_sb_metadata(sbi, -secs);
 
@@ -2437,11 +2437,14 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
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



