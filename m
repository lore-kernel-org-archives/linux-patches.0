Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4F7171BB
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40EAC433EF;
	Mon, 12 Jun 2023 10:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566088;
	bh=YN1bklJ9l4GaY/e0Lc6NtWObUCfUJHASn+Fx43m3zeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7ekizK/toyskzSB30hJYd2df2Hr4ux4EiCeaGRCGIxpivm7Afg8BJ5G7HOpZx3KK
	 qx7GNTQreNph7CU9kNU/thGH3exl9DKGSfih0sMwA+q09xWoOm3IhOPHrZZHukweom
	 AGYZlnd+6jFiDUodK7xf2CzTOvbAmCvSLzwK95Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 60/68] Revert "ext4: dont clear SB_RDONLY when remounting r/w until quota is re-enabled"
Date: Mon, 12 Jun 2023 12:26:52 +0200
Message-ID: <20230612101700.942454171@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
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
@@ -5799,7 +5799,6 @@ static int ext4_remount(struct super_blo
 	ext4_group_t g;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	int err = 0;
-	int enable_rw = 0;
 #ifdef CONFIG_QUOTA
 	int enable_quota = 0;
 	int i, j;
@@ -5992,7 +5991,7 @@ static int ext4_remount(struct super_blo
 			if (err)
 				goto restore_opts;
 
-			enable_rw = 1;
+			sb->s_flags &= ~SB_RDONLY;
 			if (ext4_has_feature_mmp(sb)) {
 				err = ext4_multi_mount_protect(sb,
 						le64_to_cpu(es->s_mmp_block));
@@ -6039,9 +6038,6 @@ static int ext4_remount(struct super_blo
 	if (!test_opt(sb, BLOCK_VALIDITY) && sbi->s_system_blks)
 		ext4_release_system_zone(sb);
 
-	if (enable_rw)
-		sb->s_flags &= ~SB_RDONLY;
-
 	/*
 	 * Reinitialize lazy itable initialization thread based on
 	 * current settings


