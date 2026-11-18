Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025991;
	b=P3eh7nLxX7stTPMcZWgn1+7+ctyadHgPqT5pjEnlRUcKtbCQMHnTFIXh8PsGG/l3iec5
	 SH/Uy+MFDlR+pbm2nY8z0l09vhLvakMPmNR0s8133mwYC3b9AKAgRcKORX4pLU4ficRU4
	 rTs1EHi8+XIdi39l6PV3OX6dvVSmTvBn5hPqOZp0NqPfgNvf9pX1Ey5XnkGLxLJCQIgb4
	 oGd7Qkn3bfQqupy8p+iMhbgQGFuzDEIyyp+tRqAcRkya4teOdx1hbUqEqZHANk134hEAW
	 ECjYb3+0hHzKYh7vMS8ORM3KNRjtPdRwKoeWhNd+dXXYTmsHR+DYtfaf4+4nUqh7BJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ZF/m5OyAVHuwkXM+WfoN69sm7lPbJdkoBwJBSPBdNc=;
	b=nCE1XI8hfh4GwOut4kQNPpWCilcOlqwtTu5svBYRp7NgdG2cPU8k9wpzeRWIPKmODt+M
	 R/h3p7VGq7NkXedqQin6a+sgkppIkv0cfqHavgdDipjsrdRiAZWS17A62ENuplKmsiZFV
	 MVb22oKlfHK24MBhYuRNuLMepYEYPDZ8hYKju/wRvuVcj4pcj0gWCJit/CVXI+lrk8d1y
	 p3w6KY9UrkZKKp6D4PnSDF+FIxaoi9cxdOLy1xvTSYLGQVx0q8E7wAsqQPnYlA5n8dghB
	 OE2wEmHceG0d1pf4XHLjONcRwyinGy6FuDMjHPISRrd6MoGXRGWwI2LNwSHsKC77ymg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Wiuwbw/z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE06606A325;
	Wed, 18 Nov 2026 18:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wiuwbw/z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92DC1F000C4;
	Wed, 18 Nov 2026 18:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025991;
	bh=4ZF/m5OyAVHuwkXM+WfoN69sm7lPbJdkoBwJBSPBdNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wiuwbw/zEB6YHBH8HYhMgiKLj6e9TuoHRcee4CbxGF/Fbj2wRapKZ3uHJXcQpul4a
	 jDFFO//W5IvYgEeDhzv+HQGnrKSJuKuctZNFhRnEX7ksLGBZ37F+HO1SzpOD7n9dKg
	 7ci4kSmfto2hV210tGDfez71xNd7aZF9UrQ+E1UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Labelle <southampton.jake.labelle@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1275/2151] nilfs2: reject non-regular inodes in dsync recovery
Date: Wed, 18 Nov 2026 15:50:10 +0100
Message-ID: <20261118150208.570334069@linuxfoundation.org>
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

From: Jake Labelle <southampton.jake.labelle@gmail.com>

[ Upstream commit ef2ccb1554df254eb4066171ce93e6d5fb1af2e3 ]

During roll-forward recovery, nilfs_recover_dsync_blocks() obtains the
inode designated by fi_ino of a dsync log without checking its type.
If a corrupted image designates a special inode (e.g. a device node)
there, the inode's embedded bmap was never initialized:
__nilfs_read_inode() calls nilfs_bmap_read() only for regular files,
directories and symlinks.  The subsequent nilfs_get_block() then
dereferences the uninitialized bmap->b_ops and jumps through it,
crashing the kernel or worse.

Regular files, directories, and symlinks are the only inode types
with data blocks to recover; reject anything else before touching
its block mapping.

[ryusuke: conformed AI tag to guidelines]

Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Assisted-by: Claude:claude-mythos-5
Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/recovery.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index dfff3bc84bcd3..88c7386c7a964 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -540,6 +540,23 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 			goto failed_inode;
 		}
 
+		/*
+		 * Regular files, directories, and symlinks are the only
+		 * inode types with data blocks and an initialized bmap;
+		 * a crafted image can reference some other inode type
+		 * here, whose i_bmap_data was never set up by
+		 * __nilfs_read_inode().
+		 */
+		if (!likely(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+			    S_ISLNK(inode->i_mode))) {
+			nilfs_warn(sb,
+				   "%s: invalid inode type (ino=%lu, mode=0%o)",
+				   __func__, (unsigned long)rb->ino,
+				   inode->i_mode);
+			err = -EINVAL;
+			goto failed_inode;
+		}
+
 		pos = rb->blkoff << inode->i_blkbits;
 		err = block_write_begin(inode->i_mapping, pos, blocksize,
 					&folio, nilfs_get_block);
-- 
2.53.0



