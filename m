Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A277B3D8912;
	Wed, 30 Sep 2026 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794243; cv=none; b=FIDCPGpCFV+NdSibUKkoY3/Um9f5LTrNznThEbkV9itPE/yQmLN4pManT0YjI71X3AaKj7gau9wbPPDrCe1MQITtOie4HZVP3m2vZe6RleDiHqy5fymcKFxAmge9wUQBVBO8VNu7Y1TeEw7KtoS0lA4rMmkGJgOU3N5wOq37zlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794243; c=relaxed/simple;
	bh=TrItjW1GGnnEgWPYqvdMn5/8x8ylyn3h22j7/7aMdUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TG3RagdSjxU8tM9lNkqgHZx4uIZl7GYQ+re41PIS8dd9Mp9l+bVYri9r4+olK/TMTUzE2K+6dKxSU0zNeaFUvj/hFhC8YDsu3Z0h+W2ungKNQDkrLZIveOazzpfaCQv4jsly8lMQfg4uLMiF+NVTOfAIrB4TDhHzpnG9DnmA7vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSxH0DD5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSxH0DD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C6D1F000FF;
	Wed, 30 Sep 2026 18:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794242;
	bh=KnbbTkHwi2A33SwlK5lip4mNhZURv38wVmE8qOVSJXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSxH0DD5NfXFB7cbAAMk/SbFxs2TfEXDWK8BFUJPQaP7+TNDmpQYPFCnOMUtQVvd0
	 ylHM/ibp46zj5b8hIi5rc95Q1q0mJrwShdzKx6WQJ4io3D6vX0XsPFO/uoAJ6IIaH9
	 eoLtDB8r1nao5yN6ER9Q30A3LHZtxuuaB7mhpC9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0105/1193] s390/zcore: Removed unused variables
Date: Wed, 30 Sep 2026 17:13:09 +0200
Message-ID: <20260930152436.566035681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 0a2aa995c0a1d363b5f0803862e84834e3876ae2 ]

allmodconfig with clang W=1 points out unused global variables:

drivers/s390/char/zcore.c:49:23: error: variable
 'zcore_reipl_file' set but not used [-Werror,-Wunused-but-set-global]
drivers/s390/char/zcore.c:50:23: error: variable
 'zcore_hsa_file' set but not used [-Werror,-Wunused-but-set-global]

Remove both of them, since there is no point in keeping them.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/zcore.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index bc3be0330f1db..7188857e0f069 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -48,8 +48,6 @@ struct ipib_info {
 static struct debug_info *zcore_dbf;
 static int hsa_available;
 static struct dentry *zcore_dir;
-static struct dentry *zcore_reipl_file;
-static struct dentry *zcore_hsa_file;
 static struct ipl_parameter_block *zcore_ipl_block;
 static unsigned long os_info_flags;
 
@@ -357,10 +355,8 @@ static int __init zcore_init(void)
 		goto fail;
 
 	zcore_dir = debugfs_create_dir("zcore" , NULL);
-	zcore_reipl_file = debugfs_create_file("reipl", S_IRUSR, zcore_dir,
-						NULL, &zcore_reipl_fops);
-	zcore_hsa_file = debugfs_create_file("hsa", S_IRUSR|S_IWUSR, zcore_dir,
-					     NULL, &zcore_hsa_fops);
+	debugfs_create_file("reipl", S_IRUSR, zcore_dir, NULL, &zcore_reipl_fops);
+	debugfs_create_file("hsa", S_IRUSR|S_IWUSR, zcore_dir, NULL, &zcore_hsa_fops);
 
 	register_reboot_notifier(&zcore_reboot_notifier);
 	atomic_notifier_chain_register(&panic_notifier_list, &zcore_on_panic_notifier);
-- 
2.53.0



