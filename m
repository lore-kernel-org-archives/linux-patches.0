Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051003;
	b=TSi4WKL4HObbJT60xzSp3rU6OPaKjwFHTwn1nUwLY/siS/phYog1nU964DUnDDwt2YL+
	 lo22a86K+PUEWareaI5ocoifbYGHXzbhB/RVd1KKpMME9OukHZUZSA1qH79CIuvb0HQdU
	 sm9j5xq6Dxs+k1zrsYOPbfDsSamcRRvl345TBvDGs5c1qPSJQ7q81+eC6MgAEGB6uKKX9
	 0RNxsD5KyJ/QMM5IDUsggqwm+gLwqetLluLNuDikTkRPsqcVV6uezOpKxsgiNDXttk/nm
	 zJLx5nX/ppK0eSnsitO4ml9FenMos7BOztI/PZP5bQAIThgBzz1JZVMkfX/oorJHAKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XbEoeY+H31jMY43XXmPbvTgtdE4YxXNIQjIWaLqjAPo=;
	b=DzLjNO0J6hc7c9/9BZuneEEqrb8lKU4/yzYmnDloDDeTEumPdI6p7zULS5F4EVro3vZS
	 FS9sKzTn1EjP9Zj8bcTaoAk3/5X90vYmmWQKXcY55MPvfpyQboEeSJWXESKlU1iQ9txrI
	 pdo0YPj5ZgD9WtW3lWSq5gCpMNynCbTepFeSL6AwzGswbcovnGQz7x4iNncErEX6u91Pd
	 ko5wktymGA/+pLo7+JrWk3fGEQ1R2lBA9icT1yF0Vmi39ajWxBTP4CG3fPtFvC+ktVrSG
	 d3e6vrmqZM2CNXa+hMJeLyof5rlECB1qxGOOZDvfeYHcBUxU6UY4REHl3TFCCR8W67Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QHjLzLb+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C23606A320;
	Thu, 19 Nov 2026 01:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QHjLzLb+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B512A1F000C4;
	Thu, 19 Nov 2026 01:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051003;
	bh=XbEoeY+H31jMY43XXmPbvTgtdE4YxXNIQjIWaLqjAPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHjLzLb+SmeWojjbAk2e/FEcMbstKWY32M2KcmGaC5lThrwxsmE3S3DyctRu038TF
	 IqzkaTanRwqI/4D4DbgbvFgDw5kzxc77kKzdlD+Ez9MYaX1Syutfityl14t8GhkywL
	 JyykDPvZ2RDx1JJElN0zCcZN8aIKONphmR7Y854w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72fe3ea5814121fbc76e@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0055/2214] block: reject block device inodes with i_rdev == 0 in lookup_bdev()
Date: Wed, 18 Nov 2026 15:28:51 +0100
Message-ID: <20261118150012.227775307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e015fea1521e2..8f64f3ce27711 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -987,6 +987,18 @@ int lookup_bdev(const char *pathname, dev_t *dev)
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



