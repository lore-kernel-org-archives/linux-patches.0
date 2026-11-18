Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033959;
	b=2wDxMlGHSR74JdNE+mcGSkBJuXEq+2xpPxlYmL2eILVTrF5o521tmudtwk8vSkti6V87
	 MC2R0b8bGf/iNozLZPoDyIzL4dq4EcIfL7ma9LNVN8bAvcwbyEsAasGgPCeUUUy8VpVL1
	 e4EDGCRl3/SlW3Y7PaPT/HJIHCEMVKvIWaeTGQ/gk88caohlhWdwAtlADIznrpw/WMx+/
	 co2HpWZ2An0cuEOWUhe5fmZq1ZWbicOtA8EXjRx4juNNl2GR3HKKsREnz3l06A3wHuAZb
	 mJabLgmgq6yQy22k5lR7CrnrAF6vuPP25sozZ8CWZg2rMzGtfHtWe8pdp9oYP1N+Ikw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Kb8uur01xic3BA9R4kziBoWtYK+QWMA7Cn1RE9+cIzI=;
	b=Y729/c3sw1mI7TGtRdu/8m5A5Mrvl19jEmftK/YhKOBRgH1do34OKKq4uH+VxCHzcxDB
	 XxSUfN+gjEr+6fETDc4aiL8g0DMy/2d1NqGecHC7mM6sEPSd0kNH3KjnRorrNXODbTHD0
	 I+QAARBZwiiEQ7jg1pfSxJO5fngW3pCJtZ0zOMXRZQrOxY2l7YZCbTBdMZZq9WYIg6u63
	 PRLIPj5UraysgckC0TMMchCMe7ixxfBkrvn/53YYPuzUMSyiSDSLv/9dV/bt8FamQJe5B
	 5l0FsjEiyM7EKyKjR/ga3z6dWJ+G+D7s911qKegeN5o/haN8ubpLlKCcyYdTHE1Av4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZqR/EWHF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59E660A2605;
	Wed, 18 Nov 2026 20:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqR/EWHF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3051F000C6;
	Wed, 18 Nov 2026 20:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033959;
	bh=Kb8uur01xic3BA9R4kziBoWtYK+QWMA7Cn1RE9+cIzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqR/EWHFY3YKBlYldxL55uDP+g/iTQp8pqUpwKWP+5RsPvS0IFms3ezC6EJ1YgyOt
	 iQzV95zqAzoqEn7C7hOIx4SNgywH/6peQvQn9NmWu455KPf1QuqEkl0iMNuv3jhaFy
	 asUPhFazWkGjwuY0PGISIvQHhvTo/xZ/KipssnT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=9D=B4=EC=83=81=ED=98=B8?= <kudo3228@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0198/3318] romfs: detect hard link cycles
Date: Wed, 18 Nov 2026 15:13:40 +0100
Message-ID: <20261118150320.785000151@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 82975173dcb04..b43b0f6e688da 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -250,6 +250,8 @@ static struct dentry *romfs_lookup(struct inode *dir, struct dentry *dentry,
 			if ((be32_to_cpu(ri.next) & ROMFH_TYPE) == ROMFH_HRD)
 				offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
 			inode = romfs_iget(dir->i_sb, offset);
+			if (IS_ERR(inode))
+				return ERR_CAST(inode);
 			break;
 		}
 
@@ -272,6 +274,8 @@ static const struct inode_operations romfs_dir_inode_operations = {
 	.lookup		= romfs_lookup,
 };
 
+#define ROMFS_MAX_HARDLINK_DEPTH 64
+
 /*
  * get a romfs inode based on its position in the image (which doubles as the
  * inode number)
@@ -283,6 +287,7 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 	struct inode *i;
 	unsigned long nlen;
 	unsigned nextfh;
+	unsigned int depth = 0;
 	int ret;
 	umode_t mode;
 
@@ -299,6 +304,9 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 		if ((nextfh & ROMFH_TYPE) != ROMFH_HRD)
 			break;
 
+		if (++depth > ROMFS_MAX_HARDLINK_DEPTH)
+			return ERR_PTR(-ELOOP);
+
 		pos = be32_to_cpu(ri.spec) & ROMFH_MASK;
 	}
 
-- 
2.53.0



