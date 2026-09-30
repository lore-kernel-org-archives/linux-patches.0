Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059184F5E1A;
	Wed, 30 Sep 2026 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784252; cv=none; b=c/5q5FsqsRq4s3vMHMkZGAlVrriwthQtYP5fHX7hyTgZdVA4y1AzFxuJePAgPwqa8H+lmxTnFL1CXimdnPkw+IFoZSS4pfbbto0w79qdRzekicK6V+NdUWxRVQMg5acMtmDzCmE5+kJ9K/RLT/TtJWZVTrEJWHmCDmacz8KKA9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784252; c=relaxed/simple;
	bh=HoP4DLRJiWpOoJQeu91v/v2rAvuJvU3MH8DC+oA+KgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8FfbIOXk7UYsWlk/EnwHBdty18xylR7Er2QuyCnwhfaZRiGKWLxnbrKP4/+UDroRA59c6gEPiRvZM873ajJMxFyeBjWbON21NjkjvDdcfcFagyBetuXxzBhBLVX2/nZDdPO/QNc2agrz6xxfhdJvcImkkzkihE4d2IlRFVBb+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aicHC9cH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aicHC9cH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7E61F00898;
	Wed, 30 Sep 2026 16:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784246;
	bh=RoH8pvMosHCKO9XAtF/QsPJvOoPbIm8sy+RdYh4dU3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aicHC9cHfegYjx629hwNapK4tttZNnznjmWaNpv6pJeev2hJjAsetuLn4MWI+FwPP
	 m8GWw6ztQKYuL+24n2X+a0RXFRCfgvNXkaTSseWDrGDBJl+6tCfQciX79nvp2pU+Ty
	 HOxfKipqrNh3YRFe2JEWnkxK2OXUImbwT5BIaGTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/982] s390/zcore: Removed unused variables
Date: Wed, 30 Sep 2026 17:13:44 +0200
Message-ID: <20260930152418.699454943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index a41833557d550..166c0b04fe713 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -48,8 +48,6 @@ struct ipib_info {
 static struct debug_info *zcore_dbf;
 static int hsa_available;
 static struct dentry *zcore_dir;
-static struct dentry *zcore_reipl_file;
-static struct dentry *zcore_hsa_file;
 static struct ipl_parameter_block *zcore_ipl_block;
 
 static DEFINE_MUTEX(hsa_buf_mutex);
@@ -314,10 +312,8 @@ static int __init zcore_init(void)
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



