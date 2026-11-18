Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022366;
	b=QqQFWO6nvIlVKZQEuww0K9oqoi+9NXFQwLUoLdm69ycq9eQaLFGp6VhdBt6ETy7M2sDr
	 QvlYqy5u7Lnv5T0g3u1Ii/0fk/3SrbqIK6G7ke+f9vlUQQNWgQbhr/m1lKf9EltjFXzIo
	 i4LhY1vZWYgMM4cFbUqWUs8IlHefticnZu9HF4+h5Bm8Ky1PzpZTSXZ8/sO9ZPZ4avKV+
	 P+NnHkpD5R3JbusWcztOqcIihhb4U2pdlmADcw6J6GjeIcJ1z7AEtd8TXvbqL2sL8ZEC9
	 ThcGlQ+K6bTSpVaNbkYzw12hTrPGbYnZ0/onOd1Lh6My8+R3WroZiiUNDe/vbOrwOKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bPN1wmNG6iTqPOHlR0X5XqhvrVixQJQCdX4MOaiH3mY=;
	b=bFJM5D3tngEL5SvgW4pSnVlmwC26qDZWkasGGgqvu29ipADppDnH3ShSHjxA4TcQeQ6r
	 U2z8VoDTKG2Bkclf+o+zKeXnKK5Q8bB6SLv2Gi7PQE16RQP5JY6tjLayQwNbR+GH3Emo3
	 gtnHADi6uEveM+csMpLbeGx8Pm7txicdGPZu/5qQ+uq0KIHXkGJQ17XX2BO2sJZbfcQsi
	 OaIUSr891kSUeX1NVZyipUiQEc/3WDKFb3R/X+FqpxgO4Q0Q/9FahB3t4vbZNc6UsoFc3
	 EsvBe6anYmf2fPNZQp64EE+mmX1DZX/k5MUodNQvLH/vuBJHT8c2bU51BhTNG0JZwSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sj+LF3fk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA80A606A320;
	Wed, 18 Nov 2026 17:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sj+LF3fk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C02D1F000C8;
	Wed, 18 Nov 2026 17:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022366;
	bh=bPN1wmNG6iTqPOHlR0X5XqhvrVixQJQCdX4MOaiH3mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sj+LF3fkcZV0kDWZvtAMpseSJO0Yt8EprSE7EaUSgGNly7DoldCw+jp11Zo4mnRg3
	 zCdxzJcBOE4oa6rcQc9SjwANhYHbpjx/45gxFv20QQdfj1Y/a47TzAM9I/2Ov+d4qD
	 gB+VEjUSypG2uSJFLKyyjIK96QzFUoRaTY1+6XHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8420e667af06b1709c00@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2637/2651] minix: reject rmdir of a directory with a corrupted link count
Date: Wed, 18 Nov 2026 16:04:37 +0100
Message-ID: <20261118150419.069261995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5525ba367ed74..344cc70ba8786 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -172,6 +172,10 @@ static int minix_rmdir(struct inode * dir, struct dentry *dentry)
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



