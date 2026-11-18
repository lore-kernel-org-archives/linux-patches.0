Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028387;
	b=ZvN7oqxSPzbTV5ys308ygi3qaejJ6UZetb0zwYDyC/xBbGOX5W8suGzNuHm6nJUoRong
	 /d5CHup3wx5MUNJTGbpY66XIYhD3TSl+SYSriO2lIbeYjLjH9XoneMqufvKKZVooNI4II
	 42KhuyWBIEhhaxZm/4WJWejb5n8HNpUR9tI8jIX1QMDoM3lWCpbEvrs7bRIywy1frvUEi
	 QWjQXyTn1BahcflKaCcxebqzut2zWY6saJHq8/T/YazCH9JMwc7xl2jYnVX6U1v5z7AFW
	 J3lrfYpELxHp2GaUK1fRVHsuiU6A38zxJ7XGktlgzwG2HpbbKMFtND8Vv6zTgmCu6Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cuTbQmd02iEQKN7KbJ6tEvsDKPvRH4xmQkXuCGaRusg=;
	b=x6ghdakXRY83aMwDZfjtRKHZsDebdrAUKWPcSjAcaOwjf8w9drG/O+DdKoqRzq1IIwYz
	 fcyVPKNndu+Naw1W/e7SX0BNgw28cAB72dWm3OW0b02WH6shy4LMCyYgZD+9ZcYWx8/R1
	 mOXv1/XtBo4Zd2vxye2qWjDMfwwk9Gqs2C9i7/HCVIGx213yzYsYPIno/ntkk5sXc8TIm
	 CrBP/5uuavxbtFE1BvGIbsYL4jicSQ9LizhPTDdsR5ODqymSKf0ymohLl/nzLrg7M3Y1m
	 QTFgiKy96VBH81RsrWOxxzNgL9JnOWXs3sx0sbQu0Cd/sqnbOigR8KM+7ReExNrNgkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjcVSM9+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114AA606A338;
	Wed, 18 Nov 2026 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjcVSM9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A2A1F000C4;
	Wed, 18 Nov 2026 18:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028386;
	bh=cuTbQmd02iEQKN7KbJ6tEvsDKPvRH4xmQkXuCGaRusg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjcVSM9+y8W3mUunZBLA9Kc0IH3kIPf0LOUGgyy4Xw4Gy2avgwBKxi6nDYOJW1bNG
	 2v8ijxKgebQlm9LDrzCj4jsIq4R4ADyFRFFhHNcXkhky3s5cda2kRT2Sgqo47d+IDx
	 GtnL3LzYUPDuiNEUASYdTrIW2fHRGjTIVyWuLRn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8420e667af06b1709c00@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2126/2151] minix: reject rmdir of a directory with a corrupted link count
Date: Wed, 18 Nov 2026 16:04:21 +0100
Message-ID: <20261118150239.131825650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit fc9577079df8a44ccbf39d2f06634017d286e4f0 ]

minix_rmdir() calls minix_unlink(), which drops the victim's link
count once, and then drops it a second time for the "." entry. An
image where an empty directory has i_nlink < 2 makes the second drop
hit drop_nlink() with i_nlink == 0:

  WARNING: fs/inode.c:408 at drop_nlink
   minix_rmdir+0xe9/0x150
   vfs_rmdir
   filename_rmdir
   __do_sys_unlinkat

The parent's link count is already validated; do the same for the
directory being removed and fail with -EFSCORRUPTED.

Reported-by: syzbot+8420e667af06b1709c00@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8420e667af06b1709c00
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Link: https://patch.msgid.link/20261016115851.14276-1-ngocthang2710.1999@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/namei.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 68d2dd75b97fb..89aa05f29c669 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -167,6 +167,10 @@ static int minix_rmdir(struct inode * dir, struct dentry *dentry)
 		minix_error_inode(dir, "inode has corrupted nlink");
 		goto out;
 	}
+	if (inode->i_nlink < 2) {
+		minix_error_inode(inode, "inode has corrupted nlink");
+		goto out;
+	}
 
 	err = -ENOTEMPTY;
 	if (!minix_empty_dir(inode))
-- 
2.53.0



