Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0418C3B960C;
	Wed,  8 Apr 2026 18:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672414; cv=none; b=p3u1LM22QIxUngrD9qewZ0L9CXPt5ABOkzIp4v7GE6HN+uicof/hGLCdMOWBcffQOEKxaBecXf6X0yQLP8kJnuUzIv96COTeCu5Mkaf+gM5n93HVtYIqpCDR+PSaZx1hcb2jonf1rk5iVgIC59IIhzzHylFFzVGyxL2dXqO8nAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672414; c=relaxed/simple;
	bh=tWGTr0r7Wxuiwgp5u6NJ3fS2tLgIaDqN/Tif9qkX5GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGiLmd289o0WetwP2kplH4OrwpiONTQ+9vRHEYZ9Wizusj3cFAyOFNX0sqb/UUDYk3r5VFduPWPc+CRivnw6oDezwUfoJb5k/WZCxUgBnJfyiR9lcW3zp1dtGhg0DEGJRcS/MBk/+P43nVJACm10IgfW/pKkNG4VMYDT3F2NN/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8b/tWDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8b/tWDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E680C19421;
	Wed,  8 Apr 2026 18:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672413;
	bh=tWGTr0r7Wxuiwgp5u6NJ3fS2tLgIaDqN/Tif9qkX5GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8b/tWDPe5Xw4bjFp/7FmVYQkQFJvivLWwkBHSj8UTjNsK7mDXKTvMPfcbRaRScAl
	 GuMeaCrsoBjNXx0S34FyXXRRN1LecDR2ZIsnmt1RUc/sXmSuyI0IPrWlNNOATBmO3y
	 6xTDQWpzzeEMNCax4u8w1Tu8g/ALUunmk6iobAdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jan Kara <jack@suse.cz>,
	Jason Yan <yanaijie@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 311/312] ext4: fix unused iterator variable warnings
Date: Wed,  8 Apr 2026 20:03:48 +0200
Message-ID: <20260408175945.388343530@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 856dd6c5981260b4d1aa84b78373ad54a203db48 upstream.

When CONFIG_QUOTA is disabled, there are warnings around unused iterator
variables:

  fs/ext4/super.c: In function 'ext4_put_super':
  fs/ext4/super.c:1262:13: error: unused variable 'i' [-Werror=unused-variable]
   1262 |         int i, err;
        |             ^
  fs/ext4/super.c: In function '__ext4_fill_super':
  fs/ext4/super.c:5200:22: error: unused variable 'i' [-Werror=unused-variable]
   5200 |         unsigned int i;
        |                      ^
  cc1: all warnings being treated as errors

The kernel has updated to GNU11, allowing the variables to be declared
within the for loop.  Do so to clear up the warnings.

Fixes: dcbf87589d90 ("ext4: factor out ext4_flex_groups_free()")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Link: https://lore.kernel.org/r/20230420-ext4-unused-variables-super-c-v1-1-138b6db6c21c@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1265,7 +1265,7 @@ static void ext4_put_super(struct super_
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	int aborted = 0;
-	int i, err;
+	int err;
 
 	/*
 	 * Unregister sysfs before destroying jbd2 journal.
@@ -1316,7 +1316,7 @@ static void ext4_put_super(struct super_
 	ext4_flex_groups_free(sbi);
 	ext4_percpu_param_destroy(sbi);
 #ifdef CONFIG_QUOTA
-	for (i = 0; i < EXT4_MAXQUOTAS; i++)
+	for (int i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(get_qf_name(sb, sbi, i));
 #endif
 
@@ -5127,7 +5127,6 @@ static int __ext4_fill_super(struct fs_c
 	ext4_fsblk_t logical_sb_block;
 	struct inode *root;
 	int ret = -ENOMEM;
-	unsigned int i;
 	int needs_recovery, has_huge_files;
 	int err = 0;
 	ext4_group_t first_not_zeroed;
@@ -5658,7 +5657,7 @@ failed_mount:
 #endif
 
 #ifdef CONFIG_QUOTA
-	for (i = 0; i < EXT4_MAXQUOTAS; i++)
+	for (unsigned int i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(get_qf_name(sb, sbi, i));
 #endif
 	fscrypt_free_dummy_policy(&sbi->s_dummy_enc_policy);


