Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033586;
	b=pSEaPouqZ80004wYZGtH3Qm7ErQgiRIuD32QrG8pNkULmHWVj3O5p6kqOapbY3SHjkpo
	 CxeeNoW2PKVbf9akSH+pPVA6EDo8s3ztRyKDPSCMJkKsQQJjzjOMFGO4Qqs1uR7b9j3u0
	 YJoUinYB0qTmzJhblIVAJT1JMysFVuaYMRA5x6zm4W9WGXCgmSp+ZqoAQXgBaYqp07iPf
	 RaiGUOWkczUovOeh0fs7S2r1GjWfuZYEtWrsFtyMZeRj11bakCBe5cg7WVFi58vG8HgUf
	 NO+qBhk7j4hCMheaSkwaSt7VOxUDLIDGKdUfvDgiaaf8vOPZtUoMqOoDAJGLKdOy3BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lwhkbtqGRU2pSz7WSaqGnYhl2LqERDfkRr6Y0oK3JMY=;
	b=lHHg89fMPmEgESH7K1Bvmiavh64y0iNR0zB/5dO/H29nEr83LjF8QNsgLRtFet5CUnh7
	 MvGZQXmWECISbYhcdR6g3UHeFgZVi5YVGTKsrJKLEpgQ8IrRaWRTxBtxDOKMLSatroYPL
	 tVXxiFumZBpNzz2Q1MFSF6hvQrhxa0Ca9iBvSWCOz3zeiarRgRsbw/WUG+VKN6aMwCLuk
	 dk+YZGcl+mb+MEADp/CdCVffNLlPt1pNCsV048SPd+1cSNgcpMZgukX27Zu+sQj31alZA
	 oJy3mxY3ONhe8hUO58NKX/o4digrxRGEcsDbEPfDaNST4iCHe6+5jjQXxfgS/9ldEMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3fLzMih;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6135606A320;
	Wed, 18 Nov 2026 20:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3fLzMih
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C554E1F000C4;
	Wed, 18 Nov 2026 20:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033586;
	bh=lwhkbtqGRU2pSz7WSaqGnYhl2LqERDfkRr6Y0oK3JMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3fLzMih77zzTlUt5ph8tbFZmo0xmzEELHppUAFgSZyscA61v0UEj2uIdkcEIDbL4
	 MTk6IhRddevyyJRPag00n1TwFY54EGqttPbugZeGdNikP5/G2d5qJe1ZW2CEI6YkJR
	 1Ja6b9qrTFW74VQQQQSF2H9wSiNGFLoerh6niUfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72fe3ea5814121fbc76e@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0065/3318] block: reject block device inodes with i_rdev == 0 in lookup_bdev()
Date: Wed, 18 Nov 2026 15:11:27 +0100
Message-ID: <20261118150315.950055487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a255492ba8265..c458d6097cf58 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -998,6 +998,18 @@ int lookup_bdev(const char *pathname, dev_t *dev)
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



