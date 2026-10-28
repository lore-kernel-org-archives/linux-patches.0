Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213612;
	b=QqqfWIsdP1EXtPsAosXYz2aQ1xScctQhFnfPQpJ2W4SR0IW1OjmRJAoJs/jXyiZqJR+O
	 R/nWM7KJfKCgtNRfVDxqUB24kDk1jfznolVv5wnxxFS22R9uzGbzoR1mweJv83xcqooUW
	 DRMDOfTW4ormy0ZAU/zlQ2VIsg0W5CyuOz5n7ZdPwrxfYzw0gknMyumnjy3eayJIt06j/
	 wYWD551iaQ2zo+FouG1IVuwnKnlDknhgm7UDBkv7CKSCfVVh1yTj0jeilgrr3974hIxQ2
	 k6SvKaiZRlbflW1KJpSyqZnfbXHVSUaslDg+jF/+8ijrA3pTnLiTn1yNnMj7x1zSkvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+BIv/KHTx8o/+Ek5sm2BfOX2kmvevg17Uc8AqajxEFU=;
	b=vntjLHCesHLWd8vFJhhDgVr6ssVMDyiK7+lLFo1/sZXxxEgSScKVwL3Ae1OKR9MUo7ZR
	 fiG9uAadKNQLEUk68Ud+WIiouyhbETry0ezXaDs8RDo5jOQ/D6tTwHxT+WIxyAj0LI50p
	 jXkG070uj/VL7HoD8NRVRJf5t1nzqb+Jd/YREtfn6jpK2l2jqAVeq3ambduc1D+i6XDD1
	 Q0aGanBXxLpC58UYyZnptFsbPxItNPrt88hUfYWa9nZaJFrWbPfEXmojd7gqLTfiktmzY
	 kZxdQ5JtAPUSWvMXQMdBcmAaNpVgpqV/UEgM30gWCCy4PtYMtpOfn302Hf2eckUrkpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sjlvGg41;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3498A606A31A;
	Wed, 28 Oct 2026 18:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sjlvGg41
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22431F01828;
	Wed, 28 Oct 2026 18:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213611;
	bh=+BIv/KHTx8o/+Ek5sm2BfOX2kmvevg17Uc8AqajxEFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjlvGg41RNVclkT8i4X0oDoCeZLGMEB3+2MRpI+pa0U1k1fI7wH/evryrCM7P7SIS
	 IfCBQFmZmh6P7vTTufTTsaHO5m3FBEdWvzi56iu0gHCheBie5Msvm9P9Bcar8EauUQ
	 vCJgnvnVHkfiKPi9v0PSYA3Qx63ve489IaFEH6u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Yangtao Li <frank.li@vivo.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0566/1887] f2fs: fix to set flush_merge opt and show noflush_merge
Date: Wed, 28 Oct 2026 17:44:22 +0100
Message-ID: <20261028170512.275999520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 967eaad1fed5f6335ea97a47d45214744dc57925 ]

Some minor modifications to flush_merge and related parameters:

  1.The FLUSH_MERGE opt is set by default only in non-ro mode.
  2.When ro and merge are set at the same time, an error is reported.
  3.Display noflush_merge mount opt.

Suggested-by: Chao Yu <chao@kernel.org>
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 458c15dfbce6 ("f2fs: don't reset unchangable mount option in f2fs_remount()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index dc06771fb1e9e..83b376afcd420 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1400,6 +1400,12 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 		return -EINVAL;
 	}
 
+	if ((f2fs_sb_has_readonly(sbi) || f2fs_readonly(sbi->sb)) &&
+		test_opt(sbi, FLUSH_MERGE)) {
+		f2fs_err(sbi, "FLUSH_MERGE not compatible with readonly mode");
+		return -EINVAL;
+	}
+
 	if (f2fs_sb_has_readonly(sbi) && !f2fs_readonly(sbi->sb)) {
 		f2fs_err(sbi, "Allow to mount readonly mode only");
 		return -EROFS;
@@ -1997,8 +2003,10 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",inline_dentry");
 	else
 		seq_puts(seq, ",noinline_dentry");
-	if (!f2fs_readonly(sbi->sb) && test_opt(sbi, FLUSH_MERGE))
+	if (test_opt(sbi, FLUSH_MERGE))
 		seq_puts(seq, ",flush_merge");
+	else
+		seq_puts(seq, ",noflush_merge");
 	if (test_opt(sbi, NOBARRIER))
 		seq_puts(seq, ",nobarrier");
 	if (test_opt(sbi, FASTBOOT))
@@ -2125,7 +2133,8 @@ static void default_options(struct f2fs_sb_info *sbi)
 	set_opt(sbi, MERGE_CHECKPOINT);
 	F2FS_OPTION(sbi).unusable_cap = 0;
 	sbi->sb->s_flags |= SB_LAZYTIME;
-	set_opt(sbi, FLUSH_MERGE);
+	if (!f2fs_sb_has_readonly(sbi) && !f2fs_readonly(sbi->sb))
+		set_opt(sbi, FLUSH_MERGE);
 	if (f2fs_hw_support_discard(sbi) || f2fs_hw_should_discard(sbi))
 		set_opt(sbi, DISCARD);
 	if (f2fs_sb_has_blkzoned(sbi)) {
-- 
2.53.0



