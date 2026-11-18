Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041126;
	b=jRMuWMERcUxfaH8ob555IKyLHFBlu1K11PoSyFlsgOP20CK7uiRPcRjzGI56f9QC62yI
	 MphueBWZNWyIbm4qxepEN6RTicHhzXRsNYcpIRLPB8PD+dheMZSGtePWf24aBnzOJxeJa
	 Ki95K8aS1smIv/TUjKt0MSedf/vfOoKow1kx9A26iReJcUrSZX5y15bGQqRVRucTBIpa5
	 QataqHEYyQLYJarQN3LX/09DMAnmbbVim+xeZSqAuJkoIJAMlZvLXE2I6BhKOLSOH+Fb4
	 sVixwmG5traug60O2zJ7r48/UKZa6FIq+xR7nfDcnKUxaiCxtmdcggKIvKuIFxy8qDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LPZqqoli2qiJdMaQVKGbJ0eo7ADPnOp23v2+QZVg3nc=;
	b=i9cH2FsbayqU7HO+rf3JnPDX/GASUkscEo+gZKqGhgDZrySyY4jugfnC1PEvrgGeL8Du
	 lqf4+fSVn6ttg3F7Mm+4sjytdvUG3Jd5tuh/zk2JjSC9LHvIYFMBuF+juw4RZSp/ijTbV
	 GxWKLwVPEggiVHN6OzkDe/FTwEIYqNjcQNkIa4WCDYMhPW2o5QE+T8Ino59GacmpggbgE
	 DC4oJb7jSRdkUB5laJ7xN+QJNgifUFzWoKxoAj1L6+L7NKU8Krz9YY/2nrTOk31LiKm5m
	 EAgsNvcJXzOqIbbukgCzgN+T1wIQ68f8C5UUaxb05SMEnWyDjPDnJgjL4zkVxxRYYGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDyNm8Ps;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6F9606A325;
	Wed, 18 Nov 2026 22:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDyNm8Ps
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3951F000C4;
	Wed, 18 Nov 2026 22:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041125;
	bh=LPZqqoli2qiJdMaQVKGbJ0eo7ADPnOp23v2+QZVg3nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDyNm8Ps9nIR7CYqedtDr5Rlphd3yDgfygEnTpV9ppMIsaZPxP/P/5FYZJyUH2Qh9
	 uMKAK2jvJfMuOuwBRvZWUseUpYOTCDUk4oSRJNIm7ec8YfkN6z72LUbu2InWLqOhsK
	 9cZC8SAXT5ni+lK7Xu6g6cg4XMYzKjWdYk3P2r0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Labelle <southampton.jake.labelle@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2701/3318] nilfs2: reject non-regular inodes in dsync recovery
Date: Wed, 18 Nov 2026 15:55:23 +0100
Message-ID: <20261118150441.946521152@linuxfoundation.org>
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
index af1b2a6a93db7..5f648b3219893 100644
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
 					&page, nilfs_get_block);
-- 
2.53.0



