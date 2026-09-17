Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA794EF137;
	Thu, 17 Sep 2026 17:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667599; cv=none; b=E6rJ8xig9ZEY5korDY8z5GutOcxWKNvTNhfrl21C9T7LRGRwkG5f5TAIue8xEbAtEsj63uBm76467vyTSzU7+BzWuYiLIOv7rhtGKhAdFcK6RtSnUGaV53g/xnqFySIjv0y0TZ1AGtH6fj2roWZzsSIwFc6exWCcEOW7tvf/mEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667599; c=relaxed/simple;
	bh=MAoLaS+MHBY1cG7BGJ1C6CxmbiBDyDcfVx93V9A3DdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dszr6qUMEQvQNX7FagMciQpzTT/yaiC94nxzj1agmPAdmr4rzCTOg6DX2QUksIAqEW9NYycisoxyMjsStKa4RP39FuZB8BkEf21EoVV8WVtAaCEReaQtxwLsYjNrwXMOQaFnu/Xfsf5eyT1LhRfwMWYgetKozNifMAA+DajfYE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMWqlkyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMWqlkyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FB81F000FF;
	Thu, 17 Sep 2026 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667598;
	bh=CkWu+0k/OFlfp7ZuFGOKG148poGsaGsLz0KHKYpijpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMWqlkyy1H7f4txOn/QjHQPUEeOuKTBED5Dw94uGBJyqL7vnPkItiDBS/SGYd75/V
	 Hi56UVI00Q0Whsgw17CM3fmHFgxFvzR8Oo2o0jt7AbxhMUvtfaFSo9X5/oLyYbAjHC
	 VAwaXZJ0dCmBNIBSdlxuokMLIVXsao+pKgOK4cVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0146/1102] s390/zcore: Removed unused variables
Date: Thu, 17 Sep 2026 16:01:29 +0100
Message-ID: <20260917151543.192421162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 33cebb91b9338..e74f41f201099 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -47,8 +47,6 @@ struct ipib_info {
 static struct debug_info *zcore_dbf;
 static int hsa_available;
 static struct dentry *zcore_dir;
-static struct dentry *zcore_reipl_file;
-static struct dentry *zcore_hsa_file;
 static struct ipl_parameter_block *zcore_ipl_block;
 static unsigned long os_info_flags;
 
@@ -354,10 +352,8 @@ static int __init zcore_init(void)
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



