Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065196;
	b=uI5zXxtnM5clpVMHejCJURZm9QR6y7/GnqDvzSPpnVRzMNMSU+9ehOFPhurRRh6sch+I
	 iOKE4LB69s27iOgFYQeSlSidFGCIJDG17KIRdCyPWzupjmht9NCYY3bgSwnzbR6i39TUT
	 D6MU0kSgGn/pIlN3XEd1tK44Id6sh5Qnz2hxgul+4ySjlyCLDGV5Hgd6Cw+du2LlttRZC
	 sD/ZwPGIu0SbQFMPYhNdoUNR1u5uuVUVtNnCyKaIA3QhcB/gE4A7Ty7SNDObcGnBDH5G+
	 l5e+V8ojTtPxhDQk++KOuQRPAtSEX3jUd/96ONJk+KiPTE+JdudH4CuAvOQS1fXEpVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KLZrfBWq22G/vZ6wZIgqjJQB82HGpFz+8DNeE3o+SzY=;
	b=o1Q97X/LABhfsp/QL98KTuYc4Y79bcY7qoqXxVlelmufwgZKb/DR/Npe9hmZsvtbA1b7
	 PEFKKcZYlaFj7xCul8G5a5F98ar+3q0P6alSMFti4FMiRtSx3q4hRZKC+dYR5A5uJPrIm
	 Cz1FLPf8aU9XEXuV/cc6csV8gIpKCAmDYIaLjXbv0uHKBhIbwFSNjDB63/1NzaElFg/w2
	 B+NuUOh8ZR4kZ7GWipV5IWaVxd9Ke1I+O+BqXd9lY+fsWbdpmlubASaFOqO+9IiJB9U0J
	 Z2qBCKtaOgwwzlW+GdC1JgW11Mrrmle6fVQvxwcW/26hiCvbGxtC5Re8WvLYnaq7R2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MiPeMNK5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC05606A335;
	Sat,  7 Nov 2026 15:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MiPeMNK5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B37B1F0089F;
	Sat,  7 Nov 2026 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065196;
	bh=KLZrfBWq22G/vZ6wZIgqjJQB82HGpFz+8DNeE3o+SzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiPeMNK55FdTISSkTFXBNwbPP8GyOrytcaaoA5s3C2BEi2LoUY4LvK057XowbpRhD
	 wadssBNhLZeOH+5Y+11rq+llGg9tB+woVxwIjglVlNzHcKG74OHGpbmfQCmY5eW6yg
	 p+XlsLuzKPRbyNPKw/+48f3bkbO5ZJWo0uNGZpDA=
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
Subject: [PATCH 7.3 0996/1257] ocfs2: reserve value tree metadata when moving an xattr into the inode
Date: Sat,  7 Nov 2026 08:54:52 -0500
Message-ID: <20261107135006.869288785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index b133489282a4d..1beb4937fd19c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3381,6 +3381,14 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
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



