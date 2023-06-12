Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F594134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF54C433EF;
	Mon, 12 Jun 2023 10:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566711;
	bh=NcP1zggGf4ov0tf4Srn5QS1cPVLRa+s7b4dEXtOwQhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLN7AXE7IBQWgg9ZlyDX9uhjFESFmO0y+2Pm8vYGGxTNF3Xa3Z3vZ6XXhx2iDgOIg
	 1G+kZCdBz8PwwHDO3zSW8QdE4c53eNx2vADKaXCWrJJSQkR+7dEEtTeMAFVgPmWUCa
	 9T1I1bvIxiWh73gK6SA+njXAhELFeYvheG0SjJzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 128/132] Revert "ext4: dont clear SB_RDONLY when remounting r/w until quota is re-enabled"
Date: Mon, 12 Jun 2023 12:27:42 +0200
Message-ID: <20230612101716.022764251@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit 1b29243933098cdbc31b579b5616e183b4275e2f upstream.

This reverts commit a44be64bbecb15a452496f60db6eacfee2b59c79.

Link: https://lore.kernel.org/r/653b3359-2005-21b1-039d-c55ca4cffdcc@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6341,7 +6341,6 @@ static int __ext4_remount(struct fs_cont
 	struct ext4_mount_options old_opts;
 	ext4_group_t g;
 	int err = 0;
-	int enable_rw = 0;
 #ifdef CONFIG_QUOTA
 	int enable_quota = 0;
 	int i, j;
@@ -6528,7 +6527,7 @@ static int __ext4_remount(struct fs_cont
 			if (err)
 				goto restore_opts;
 
-			enable_rw = 1;
+			sb->s_flags &= ~SB_RDONLY;
 			if (ext4_has_feature_mmp(sb)) {
 				err = ext4_multi_mount_protect(sb,
 						le64_to_cpu(es->s_mmp_block));
@@ -6575,9 +6574,6 @@ static int __ext4_remount(struct fs_cont
 	if (!test_opt(sb, BLOCK_VALIDITY) && sbi->s_system_blks)
 		ext4_release_system_zone(sb);
 
-	if (enable_rw)
-		sb->s_flags &= ~SB_RDONLY;
-
 	/*
 	 * Reinitialize lazy itable initialization thread based on
 	 * current settings


