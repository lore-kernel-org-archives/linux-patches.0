Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5214F3EAB;
	Wed, 30 Sep 2026 17:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790769; cv=none; b=ufet2FgIbgKLTtzVsjT2qMf+vnyZECUbgB2Gc9FX+cyjCi2FAr1FNtq1/aA2Bn3mADGnAkx0dvMBcmyoHBeZCrzqaGRKuBW/rTA6c4jFLJDeAFY2Sq1O1NzB+lCJWK0Oc4AIyhlQ0as5BVTo3V+euT6qxyhyXk721C5ZNcrFqc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790769; c=relaxed/simple;
	bh=6mCmZ7OoIVAFM/JkzZG03XnztgD4EK6+zzuA9InRGHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ol3zvokhJOCSSH6TIEDikPgtkvbdI3U25x32OLAcTMFU0U27pm7rdxGUS/AKD8/xvrvXeQZkew4wOkK+FfoToWWeFfZ5if9UW6npoEH9pEP9MCWWh/qcpddq8mk7lO7CEO4/X7x9ELLah4NqMfbPO5FeMQLebueEPjgdCtzVbqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHvNUnL0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHvNUnL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB9A1F000FF;
	Wed, 30 Sep 2026 17:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790767;
	bh=ZUkZ8Qog8abMP/04T/a5sjQ5a5EyUrmw55wmleca/UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHvNUnL0ENVtXZC4df2nZMvsLJG2I0mCCzzpl34bL8fzr7d5UZzGSJ9q+yHGOviR6
	 87r/9oTbtkVt6mDd5pez+t0CbmM+zhFeEdwC9FoNc3svXPUkX1RLF0Sbv/LO8eBd3d
	 /HGojZ7vpecBkDsXfOF98xMjoQorZEvfweOPp2R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/752] s390/zcore: Removed unused variables
Date: Wed, 30 Sep 2026 17:18:56 +0200
Message-ID: <20260930152359.593050724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 92b32ce645b95..535ef707b8587 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -46,8 +46,6 @@ struct ipib_info {
 static struct debug_info *zcore_dbf;
 static int hsa_available;
 static struct dentry *zcore_dir;
-static struct dentry *zcore_reipl_file;
-static struct dentry *zcore_hsa_file;
 static struct ipl_parameter_block *zcore_ipl_block;
 
 static DEFINE_MUTEX(hsa_buf_mutex);
@@ -325,10 +323,8 @@ static int __init zcore_init(void)
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



