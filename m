Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061421;
	b=BMGn/OqRqIX4xPw+4ShkdiivUwmW/FRKVI3dioDnW1yXs+9ImYDXyG8WXPEzgLsVjshZ
	 btT56U8b/aXMhkBdmcZI6vkTC3WVLMZWJKyrT2TJthTSat0x9yYSSQdQJ4+7/QHMpjSsr
	 D1PdlpdrVumOq5LOHQBEI9qxatYj5kpOLF6+0iNdMVBrN7S/Q5vPbD3O+9v3Jn1lRjMZr
	 BkrmM2b3tchr4MXSStp7EQKJQA1mxbB+xkEMzkyZfJN0WwutPLkE8ikPmmlVGnPi/nOx+
	 v/pEdsxMprcMyTGWiusHsPq5dH/8PDsBnywgTEXFYXd8uZWG4fVxsgzCsgmPN85aYNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xqOvGWpaGgQ9mfiHPdQKazDW2i2khQNnNIUo9U6ny+Y=;
	b=wvmJHVLkOqz2c/03QEB1yseCt4gRklNa9R24X0sJRkEXHWeFybddueIvdx9ttH+TmVlz
	 U+F6B8gs7PZxwO2zKV0vyQskAj+894nmlfegRT679nAJPvHzHWVCNGKqlD4O3FzgCXkcp
	 imn1GNCW+zCVESzwKL3jiacPvGorDbqIG/pMVJUQi/3cSGeYdNtqnyC5BubahW8FWxMmb
	 0rIUxfNhdDSI9hi3XSJuAhInlv+0mh3mBSJZxT/9QqnpsuLs81eJsdYqY7ZQOy+ZbBx4j
	 C4RGuE2CNfTt41xjH8CRrmtqG+VBtwZvvsivxXqHCLo1ZtcKooghVEOwCV73ujnFjaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cz0YDsID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A5B606A320;
	Thu, 19 Nov 2026 04:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cz0YDsID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8AE1F000C5;
	Thu, 19 Nov 2026 04:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061420;
	bh=xqOvGWpaGgQ9mfiHPdQKazDW2i2khQNnNIUo9U6ny+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cz0YDsIDC8aRHnOGbG9Uav6Ov0jg4L1DM/zMIYc13gQQdOlsxJxOd0j9MlQpp6loc
	 2l0h+f/WYcJJFRYpH46gmQUjIi5L7IuGDcQ8n2i/+lM0bZdx7rTbK8wC5hisLGpX0Z
	 6Zlj0Jh5BS84v+FeSbQZNXCLmBQkJALiu4aLwgxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Labelle <southampton.jake.labelle@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1545/1848] nilfs2: reject non-regular inodes in dsync recovery
Date: Wed, 18 Nov 2026 15:59:43 +0100
Message-ID: <20261118150024.259757690@linuxfoundation.org>
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
index bf64a9eff4d15..273052298da46 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -510,6 +510,23 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
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
 					0, &page, nilfs_get_block);
-- 
2.53.0



