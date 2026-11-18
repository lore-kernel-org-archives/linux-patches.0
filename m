Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058038;
	b=ViCNd0/tcfcNcPY8uiChjKM9RQXh65pplely4EVIWcdcd/1j3tRmxumkZKDqJlvZ9x9F
	 Lg8E03KwH5T5xKh5peILfDvTcwjl3do/agHIeOdZX0WbwaNQHEwSRT9ejaCaa8cEi/Zhw
	 lGYVx6gvHvUOfTGaom8E/w/WHrmBQWSl9ZM4zYXU0dEGoe2MwO7jYW5QPMLJsFXchnqsl
	 N9cVwrTkoRMlyBIGPeX+iDNQRM3pY811g3AGs0VICCcUEMAHlEINWSYtmyclydDMTCC1/
	 EHcNRmLQrk+W6G+Vd3u6NSv8eqBg90E1FENimWV7vL4jA3Wp4GhZiAa40N3FSIIDsbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wfhp1xu5i9cOYp9RN47KNd0bcC/xI/dwpYqJm8i1uzo=;
	b=AMM5H2vkPQfaZxQtclFb9PixV26DRiVkArWml8Gl54PhdTDm6uxCPtoke/5Uf2/SmyB+
	 3+XAe+kjDqFu9fHldL9pv2yF1AsOUDvi2eeDkXqED/feXixRECE40tiGJ+MKwuQATpETi
	 tGNh5XFaEI4+A0f6IkBWVStAgJB502OyhrVkgUwtHnQl3HikkoTm+ZycB7D3g26FspKIs
	 jj2NDdRfvRH2wxdRlhLbRuT6w/fAJ93nzcFIJxSK8A64QeKmgirVt0zT7w7hECtx9e0O5
	 rUKMsWa7iyCcIgQ1gJspDzCHg+S+HJz0VQg3W4bJPGfNCODV/f9x/6cE/AG4D7xOViQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbe8uXuR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B67606A31C;
	Thu, 19 Nov 2026 03:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbe8uXuR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57871F000C4;
	Thu, 19 Nov 2026 03:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058037;
	bh=Wfhp1xu5i9cOYp9RN47KNd0bcC/xI/dwpYqJm8i1uzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbe8uXuRKo9cW3Ia/MCLw9OdOUctPPEgpFiX33Q11khZ7x675ngH3Bv1+mPYImkg6
	 cHIOdOlHyoReZbybmsG2xXlHgXYoLPBfHYkqLTtbD1E1oP4e7IWvTEBeVjLHft8bUm
	 XF2ibcN+rKqHUuUyyF6MvmS7TT/sTkEXuD/mAgpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0342/1848] ovl: set OVL_WHITEOUTS before publishing the upper dir
Date: Wed, 18 Nov 2026 15:39:40 +0100
Message-ID: <20261118145926.855317026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit cbec8610ec5aaf35df50094ff639febc23f20773 ]

Listing a directory while it is copied up causes a use-after-free of
the readdir cache.

A merge directory must never be iterated as a real upper directory:
that mode frees the cache in OVL_I(inode)->cache without looking at
its refcount, while files opened in merged mode still use it.
ovl_copy_up_workdir() publishes the upper dentry before it sets
OVL_WHITEOUTS, and ovl_dir_open() samples both without a lock, so an
open between the two stores finds the upper directory and takes it
for a real one.

With a delay between the two stores, an unprivileged process that
listed a directory during its copy-up saw only "." and "..", and its
next getdents freed the readdir cache of another descriptor.

Fix this by setting OVL_WHITEOUTS before ovl_inode_update(), so that
ovl_dir_reset() agrees with ovl_dir_open(), and by testing
OVL_TYPE_MERGE() of the path type in ovl_dir_open(), so that an open
that observes the upper dentry never iterates a merge dir as a real
dir, regardless of the order in which it observes the flag.

Fixes: b79e05aaa166 ("ovl: no direct iteration for dir with origin xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: test OVL_TYPE_MERGE() instead of smp_rmb() in ovl_dir_open()]
Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: adjusted context for dentry-based helper calls and later inode initialization ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 2 +-
 fs/overlayfs/readdir.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 018867303a93a..07772f54e24f2 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -630,9 +630,9 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (!c->metacopy)
 		ovl_set_upperdata(d_inode(c->dentry));
 	inode = d_inode(c->dentry);
-	ovl_inode_update(inode, temp);
 	if (S_ISDIR(inode->i_mode))
 		ovl_set_flag(OVL_WHITEOUTS, inode);
+	ovl_inode_update(inode, temp);
 unlock:
 	unlock_rename(c->workdir, c->destdir);
 
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 09a5542723787..6e13cad49ce54 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -937,7 +937,8 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = ovl_dir_is_real(file->f_path.dentry);
+	od->is_real = !OVL_TYPE_MERGE(type) &&
+		      !ovl_test_flag(OVL_WHITEOUTS, inode);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
-- 
2.53.0



