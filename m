Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829707;
	b=XGWzSll0M8pHikzHKErtIdze7ZxNHGFuMIlciap0ms9+triy+RSaD21zV7Os47D9z+BP
	 8tmJcoPRX47g3xOYT/2Y2jcp6KcbaSPk/OL9D6xekkcrFGF/Bdk0g0o3LNS+8pNYicaOd
	 soUQZOiv+c+x5XUjIoH7CS/D56X6SevT0UOK4cttAfXwGf0sOmt6ndc4H9NrFxOVL8oyV
	 aVi2pUr2Zh8nOcPNWxUQgwA7tjX3JniDh5vFO/WueH5KGoUstJMltRBhFDyLrRnn4qHbg
	 xWTnShuF0bG6OyXghojK5ZC6wxoG0zPh16SC7L/d9+ospIRvsJOJbVluj9SiJm+ltZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=j5uuaQvE58Oz+Q1Mgq27pBsRJ4rkWkbwR8fWPMtuiR4=;
	b=QWYP9bdsbRnL9DY7MD582NVgGve4IDqObzOY5C9zQAlhH0y2S5JHx5ChEmFPktYgLLbB
	 GRov7evYys9yz3Z7sRivOYsjKveA1mdMif6JQFOwZ9QQt/7nM+Ct9Zkmp9u2xenng4yCw
	 ydE1Sek16TIN3hBHYh31tRZFbs0hYfq1PPMqeMPOt9u+EB1Fl5h/M/XXx4JVrqan2V4c+
	 1UtrfzYup6WcBF4evgkoBnqfidge+nk07vw6AW40Er8YBwWfMr2EY7FCf+WQ7LMm223tB
	 4mKRGjhJF7V/NIwUKdElATySp4P645MIkR6TiQ9Nlhe7SLGXHZ5OYeiuOLGMKEqgLZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MnoDxmWg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A0F606BA3C;
	Wed,  4 Nov 2026 22:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MnoDxmWg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3420E1F00919;
	Wed,  4 Nov 2026 22:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829706;
	bh=j5uuaQvE58Oz+Q1Mgq27pBsRJ4rkWkbwR8fWPMtuiR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnoDxmWgRDq+PRE2j0qeVopQ+L0b2evuJ4cWYOk7962M0rbG5tnw4tUp+y3Mmj6pa
	 3j9FB/wblCR2KXvpbgMYBQ5B8vJu3hVNtLQCaBGwRB5hR4yxCk2JrCtCZ3A8jvYAzu
	 Lac/XAh1LDCNa2t4SsWNpYFTtugFBiyQ5kKPSSXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=9D=B4=EC=83=81=ED=98=B8?= <kudo3228@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0291/1005] romfs: detect hard link cycles
Date: Wed,  4 Nov 2026 16:00:24 -0500
Message-ID: <20261104211052.062603044@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 이상호 <kudo3228@gmail.com>

[ Upstream commit d30b5a954e0a4dcc16bba9c310c13709a6169a52 ]

romfs_iget() follows on-disk hard link entries until it reaches a non-hard
link inode:

	pos = be32_to_cpu(ri.spec) & ROMFH_MASK;

The target position is image-controlled, and the loop does not detect
cycles. A crafted romfs image can make the root inode a hard link. The hard
link can point back to itself and leave mount(2) spinning in the kernel.

Reject excessive hard link indirection with -ELOOP. Normal romfs images do
not need long hard link chains. This bounds corrupted-image traversal.
Propagate romfs_iget() errors from lookup because hard link traversal can
now fail with -ELOOP.

Signed-off-by: 이상호 <kudo3228@gmail.com>
Link: https://patch.msgid.link/20260701220729.822112-1-kudo3228@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/romfs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index e83f9b78d7a16..9b997831a46bc 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -240,6 +240,8 @@ static struct dentry *romfs_lookup(struct inode *dir, struct dentry *dentry,
 			if ((be32_to_cpu(ri.next) & ROMFH_TYPE) == ROMFH_HRD)
 				offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
 			inode = romfs_iget(dir->i_sb, offset);
+			if (IS_ERR(inode))
+				return ERR_CAST(inode);
 			break;
 		}
 
@@ -262,6 +264,8 @@ static const struct inode_operations romfs_dir_inode_operations = {
 	.lookup		= romfs_lookup,
 };
 
+#define ROMFS_MAX_HARDLINK_DEPTH 64
+
 /*
  * get a romfs inode based on its position in the image (which doubles as the
  * inode number)
@@ -273,6 +277,7 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 	struct inode *i;
 	unsigned long nlen;
 	unsigned nextfh;
+	unsigned int depth = 0;
 	int ret;
 	umode_t mode;
 
@@ -289,6 +294,9 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 		if ((nextfh & ROMFH_TYPE) != ROMFH_HRD)
 			break;
 
+		if (++depth > ROMFS_MAX_HARDLINK_DEPTH)
+			return ERR_PTR(-ELOOP);
+
 		pos = be32_to_cpu(ri.spec) & ROMFH_MASK;
 	}
 
-- 
2.53.0



