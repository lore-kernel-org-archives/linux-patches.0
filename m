Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829412;
	b=tvRTBDisnec/AAxs5MjyTuAWAa5mdO3WT6dwX3XWEp2iY3S8wy4gAlC9gnyliNB/NSmT
	 6UU4P9WmtG7FX98J9ukU/W0p7Ib3cf3oUO6tXfTwSPNQSADorSrBck3uZyRyJpJNT8Sej
	 mjKqk0JBIoFXGoyIfTh0HC3c3dpNmi+KT49NCHhKOaMp/MFSXJMpsQ+mCGGcBJq7JX2BQ
	 sAN5gcsE/KyEZEW7sNFarMF6FcDYXgC7h61stQBBv/E/AgPMNf8zziGsSGPcfKkEELBne
	 JWlW2tVC54bUY4idhmVp37lsmzRgLwKpaeXHwJoTAdzjsBXYIWwRDrXIzQpMSvBs7xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FavvVyyKzoyiVIyy1j5Nxszu94qhgV+sPUdx+QmXJb8=;
	b=tB/QO/KuyQR/kLDRih1+Mxkl4wzYLIRDnfTBI4yy6Ii8Jaz26hIMgvUKZNIyZRiSVLPm
	 MnacagY0MiYPENQfeJH6dS2t1/KNBmmYWfwtqXpCjVdMVIH32OYBTGoLqY4yY2ISrTfW6
	 HLBGlxgt6qG7Y30QHweX4MDcvtV+N+u+7NhfnomTPhFWqKH63t+kzdGeIV2+24K7BKpVt
	 1JX/giQMlXNgiKJjG6cYmOTeg9JqJ4FUOe68DRouEgTGg3EFuQxnaULwElufV5r6QIavp
	 P/4ZTlRzU3EibeW8d1YlVpREtpS2UZCDO+O9DKCp0xmoKKHhUFA5B1IqdEIO7Dzr19g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTECREh2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33389606A865;
	Wed,  4 Nov 2026 21:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTECREh2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1021F000C1;
	Wed,  4 Nov 2026 21:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829412;
	bh=FavvVyyKzoyiVIyy1j5Nxszu94qhgV+sPUdx+QmXJb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTECREh2akMTDPBBshG6GgdxP74STdq1Z+Evv1zEloyWCQ6iTIyz8f+j6K/QwE96E
	 ab1LIF6GHJM3ESeOD2CEsgWB1N6n+1Kq6CUdJ8VtUgnFfB4kBoKXv/fCnYJ4fEb6p3
	 eOmnFZUpowsbvNwRu96AocTsMadseURq+D89XeFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72fe3ea5814121fbc76e@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0093/1005] block: reject block device inodes with i_rdev == 0 in lookup_bdev()
Date: Wed,  4 Nov 2026 15:57:06 -0500
Message-ID: <20261104211046.233789349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 02d7503e7c2c4..00345746e34f8 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1209,6 +1209,18 @@ int lookup_bdev(const char *pathname, dev_t *dev)
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



