Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045694;
	b=W32Vz7XV+jm6+TQ9edEI4zCs9kJpg9ee6BhCMZ2ryfob3MV794LrKnwccbxFZb0WZe/C
	 XhLpIl3Kz6uGrtXuf+BkhQkCEWrZuwm6i4HGDHF0VVUMpXjIWFj0te/lyHir8FiDARyEE
	 YmjCybl+v8MvTBio/yz2A7+6lhVf38xdUSCVHui0pqzK0RG2be/Hvs65Efoo6dPEonjZX
	 W1XaFycuWwTDVdUN8kfBxIsC+R8Ty22qGrA1RbG1flHLX4tQt+Eln4AbqkwZg9NUAYrUo
	 3SOpqZn3FcmH8MY1DPJ+LYESU7559+ha+3gG5Si9EMRjyiygbjLioQ8WGCXc7R6flsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rBr+0y1F3jUiewghbdpOiTndlD9GF2snnsA1cbsVSVo=;
	b=B0x/a6cmt8d/m6VGYK09ComfAqFm59R5QqSgImN/wPlAxhEksYMtGURwE1xnq6d0T8sr
	 WU/Xd2c0jOaH3lFDE0QICaumlU/Y63BFOHlAEr86/I0zZ5h3fhPk6sS7RrSCQi3YcYE3Y
	 us9bmLfrbUl2omL51UWMWNlt8Pb0Euk1zJNJZRJ5Ue5FDZg8T7D1ELOHz+YYXJr5yo/sy
	 mPZk/d7LAFcWcPrMXSlirRYOtcaykqYzCRNiHXeXjUEGhjfOkMWDiKZbR4Y6qtPaHe0Lf
	 h185fNzRAEPHCLcWe9hYqUuWpIjQ2ffGkx7HhBZfzplhx5TqFVSlzdlH8ndPandT3RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2S9qNgrE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD79D606A320;
	Wed, 18 Nov 2026 23:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2S9qNgrE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15D41F000C4;
	Wed, 18 Nov 2026 23:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045694;
	bh=rBr+0y1F3jUiewghbdpOiTndlD9GF2snnsA1cbsVSVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2S9qNgrE1dqk8cLlHMWZi6WxskZn/Q29VQM4UnhsoLwk6qIIRIXjAyVyXyFwkxeUS
	 MTTOIJM4Ho+jaZYG+3aaGNiPLVQSlzGoXG14LM3UB4I3TqTt7SPoYiii4ZDXunS3nj
	 /7ou4JVBvMbJNG61oa+MIRwPuSiUcG4flCKqCe2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1014/2857] ocfs2: reserve value tree metadata when moving an xattr into the inode
Date: Wed, 18 Nov 2026 15:34:08 +0100
Message-ID: <20261118150238.106489390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit f5aee8ae5f85f8dfa78160e5c4963494319cdd64 ]

ocfs2_calc_xattr_set_need() charges no metadata for the case where an
xattr living in an xattr block or bucket moves back into the inode:

        if (old_in_xb) {
                if (ocfs2_xattr_can_be_in_inode(inode, xi, xis)) {
                        clusters_add += new_clusters;
                        credits += ...;
                        if (!ocfs2_xattr_is_local(xe))
                                credits += ocfs2_calc_extend_credits(...);
                        goto out;
                }
        }

The credits for extending a value tree are there but the matching blocks
are not, so meta_add stays 0, ocfs2_init_xattr_set_ctxt() skips
ocfs2_reserve_new_metadata_blocks() and ctxt->meta_ac is left NULL.

This is the shape commit 0cdc7dde00ec ("ocfs2: fix missing metadata
reservation for large xattrs") fixed for the xattr block case, and it is
reached the same way: namevalue_size() charges a value larger than
OCFS2_XATTR_INLINE_SIZE as only OCFS2_XATTR_ROOT_SIZE, so
ocfs2_xattr_can_be_in_inode() accepts a new value that will be stored
outside.  ocfs2_xa_prepare_entry() installs a value root from def_xv and
grows it, and once the cluster allocator is fragmented enough to need a
second extent ocfs2_add_clusters_in_btree() finds the root full with no
meta_ac at all and answers RESTART_META.  ocfs2_xattr_extend_allocation()
turns that into -ENOSPC, or into a BUG_ON() without that commit, and
ocfs2_xa_cleanup_value_truncate() takes its !orig_clusters arm, dropping
the entry and leaking the clusters already handed out until fsck.ocfs2
reclaims them.

Reserve for the value tree here too.  The entry moves back into the inode
rather than into a new xattr block, so unlike the create side of
meta_guess this needs no block of its own.

Link: https://lore.kernel.org/20261010113454.1420939-3-joseph.qi@linux.alibaba.com
Fixes: 78f30c314a74 ("ocfs2/xattr: Reserve meta/data at the beginning of ocfs2_xattr_set.")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index bf4265e754a5b..dc6afdb669f18 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3147,6 +3147,14 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 				credits += ocfs2_calc_extend_credits(
 							inode->i_sb,
 							&def_xv.xv.xr_list);
+			/*
+			 * A value too big to stay inline is only charged as
+			 * OCFS2_XATTR_ROOT_SIZE above, so it can still need a
+			 * value tree of its own.  No xattr block is allocated
+			 * on this path, so the tree is all we reserve for.
+			 */
+			if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
+				meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
 			goto out;
 		}
 	}
-- 
2.53.0



