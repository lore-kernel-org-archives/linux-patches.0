Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DFC265630;
	Tue,  8 Apr 2025 11:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110745; cv=none; b=NgGIZa3doCKbUrYSP7epp/b8ZAoqcSV7cLU3/qJdoTE1i9IGKtBSX894SA8difUTgiZhH883ELtWuDxYrEtnjq1c4yCJua1+uPhLX8wxWk7zJYW9sdQP/+FNpS30g3dyOSFvVkrcTEQpHk60mL2VvdhXGK7RatHCshb75bqprc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110745; c=relaxed/simple;
	bh=g2DzmKSyQV1XcUNJvnTcZxHzgT9reUymJlvoO0vbZYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlqc7Opeel9vFXpbT7RkmKztsOROaekWMsxkdsnGPzqm2Q3QUubhNvHaSnm74zKcOUDp9K7dqoaDF0F8FyRPYLXpFvW+jiiuqR99hW4zV69bprLwwp+v5+rw+ouE4xYk18aEz4ifxiFRa/U4XoNO69/XlnnTCWJtXT6FSe4DHhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPCQaEZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPCQaEZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600F3C4CEE5;
	Tue,  8 Apr 2025 11:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110745;
	bh=g2DzmKSyQV1XcUNJvnTcZxHzgT9reUymJlvoO0vbZYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPCQaEZna0k2ZStw6LkNOPK5zxzIKsiMcPI+j65230Sq6qjP/3/Tb38DWjUnY4jTo
	 clxAwWKjCVhecaMtR9qpZLL2sc7v0suWfvqJmchcvL4GKsGuufOfjk/wn4ZfHylUj3
	 oqkVff7ECHFR0unXWlZxvSopF28rDbOARLVv8cZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 179/731] ext4: convert EXT4_FLAGS_* defines to enum
Date: Tue,  8 Apr 2025 12:41:16 +0200
Message-ID: <20250408104918.439901377@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 99708f8a9d30081a71638d6f4e216350a4340cc3 ]

Do away with the defines and use an enum as it's cleaner.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250122114130.229709-2-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 8f984530c242 ("ext4: correct behavior under errors=remount-ro mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4e7de7eaa374a..b3528e4eba180 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2232,9 +2232,11 @@ extern int ext4_feature_set_ok(struct super_block *sb, int readonly);
 /*
  * Superblock flags
  */
-#define EXT4_FLAGS_RESIZING	0
-#define EXT4_FLAGS_SHUTDOWN	1
-#define EXT4_FLAGS_BDEV_IS_DAX	2
+enum {
+	EXT4_FLAGS_RESIZING,	/* Avoid superblock update and resize race */
+	EXT4_FLAGS_SHUTDOWN,	/* Prevent access to the file system */
+	EXT4_FLAGS_BDEV_IS_DAX,	/* Current block device support DAX */
+};
 
 static inline int ext4_forced_shutdown(struct super_block *sb)
 {
-- 
2.39.5



