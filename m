Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043004;
	b=pLmY9dwiSGcwODYB9uledEkBSBVQKa/0QdqgPVrsl7UlVsNHfXlWuyUYl7LW1TpHi+df
	 DmnJ8wbJL2noORRUfCMIWPZCbwnrRDBVqWKMVkomMUMIBRO5rR0WKC9QhYauvKkEsn3sH
	 D9x+rLZLY3UoBQcK5MiCGT0tnlsDebIw72Cktb/0Jx+2shQ71GxVJEgudq62sRmFJxgfc
	 SeUT8de5/TLLrd0Z0I2IMyXSK5blMp0ynmCK1zXYK6AGk0MsxLW7prtICK/uBE+iSdgzN
	 cyRR8+cXQgVKtm7PubJUDM9xt7SiNWYi/DYkHlWA25j8NhEzJyEWgEmUoTIt8np8plA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=byABo53eVvEsdTifyI0+YwVwp+zbqKG08payTVMwKFc=;
	b=wz27JLU5ASuoJTglK5gixWbq+d92V8xRGhNb73ZcgIzYpLTN7xjWEZ1lA3No63LWChLR
	 t9FMI79UVXIZy9GeLLnx5tAg0fZx/B6mc9oLhJZTnjke1gCPrgdAj2xafj6Q7k4nCGY97
	 +O1X3qIXd2ab1qPt5+6A7mKlo9r1jX9SlCxWhf9PCBjtcTJUp76/PrzJ6Vrq8A/8JjG1r
	 kYfvYOVA6K/1cYoyPmeyVspa/bamzQ+jW4J6BMwCHC5cW+5J6OZwXAiMsfJH/b8QDievI
	 OdOON8PEk5AgUe8sMMJ3redOp9drhYG/rOFKjCq4q489sHYsxPNnJM1Lf4ZbV0HFTQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RYwHu6xf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F28606A31C;
	Wed, 18 Nov 2026 23:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RYwHu6xf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086171F000C5;
	Wed, 18 Nov 2026 23:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043003;
	bh=byABo53eVvEsdTifyI0+YwVwp+zbqKG08payTVMwKFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYwHu6xf4BGT9HOm3DGkjTRLI06J/2rXOuP70iYBx8mNE6rPMFAS2MTHjLOE7cg/J
	 CJkNEur9mbwtM1kIZNFgFIxwwgDZOs7WmzrcbG2rbjxOkKrJIhqrj2io5On5xCs597
	 RlsJPQmvDEOaDQxFAwWKsLsVVIXfgsJhltroMtPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72fe3ea5814121fbc76e@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0054/2857] block: reject block device inodes with i_rdev == 0 in lookup_bdev()
Date: Wed, 18 Nov 2026 15:18:08 +0100
Message-ID: <20261118150203.257465219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 83887ad02f30c1814bed5da3ca999f7b0f3f337c ]

lookup_bdev() blindly returns inode->i_rdev without validating it.
When a FUSE filesystem exposes a root inode with S_IFBLK mode but
i_rdev == 0 (via rootmode=060000), any subsequent mount attempt using
that path as a block device source propagates dev_t 0 into the
superblock machinery.  After commit 9ee5f161a4db ("fs: maintain a
global device-to-superblock table") this triggers a WARNING in
super_dev_register().

Reject i_rdev == 0 early with -ENODEV since no real block device
driver registers major 0.

Reported-by: syzbot+72fe3ea5814121fbc76e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=72fe3ea5814121fbc76e
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Link: https://patch.msgid.link/20260703065548.1135125-1-yun.zhou@windriver.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index fe4848c77127c..0c1b8d3e80a37 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1005,6 +1005,18 @@ int lookup_bdev(const char *pathname, dev_t *dev)
 	if (!may_open_dev(&path))
 		goto out_path_put;
 
+	/*
+	 * Reject a block device inode with i_rdev == 0.  A dev_t of 0 is
+	 * never valid for a block device: no real block device driver
+	 * registers major 0.  Fake block device inodes (e.g. fuse with
+	 * rootmode=S_IFBLK) can expose i_rdev == 0, and letting that
+	 * propagate would confuse superblock lookup and trigger warnings
+	 * in the device-to-superblock table (super_dev_register).
+	 */
+	error = -ENODEV;
+	if (!inode->i_rdev)
+		goto out_path_put;
+
 	*dev = inode->i_rdev;
 	error = 0;
 out_path_put:
-- 
2.53.0



