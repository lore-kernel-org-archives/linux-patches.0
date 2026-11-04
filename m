Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831109;
	b=JuxaoZl4MxkWnqhub16sJ/L/jFMO7/tGHTMMlqCqKYWWIB5iXk2IhOonDpaixUtQmHd9
	 3l8B8z/TXuY5DT7m4MD5p87QqwDLjbOWw2w5C0of1DmtRXFKm8sAR57PwJp6tYVaoZ6nl
	 xe2AR7Q0jvzoOHV5ec3VydqWcWSzDz4Fjhm0wA5alOBAA4FtcolZjWxpXAVX0aXrw13Fs
	 5fF1ft+mkKts/ObG4SpqOexo13TJrKGoiegO9E7K/p3WL72/gSHkVEoyl2uP+SdeFtfMB
	 /6lSRFYutGF+WwkpDFxg+/k1JTcjIU2pWIkHdTFtqSIsXJnalEPXqxsAPPlJIn6IFsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qKsVITMKAmIjPk1rdn/XvZZWDKj8qfVTKT90XPn2u1o=;
	b=hWKd9qxbrYo2u/cQMCHr3WuGj0OSfWss+T70vv3/rO9TnCLucih2f75YSFd0feMmWyT2
	 sLSSjDmeaxZRMHo6/XU+kJCOS3+0bX6oL3C/dW/kBzZ89/LrbSrol7hAYmZbQyUDqbAdJ
	 3F6kfGwdRoYIYF2xqW2zBvdXq8Wi9oWa4cxMi723Dflom7T34kZDL07oXECfA5iYaD/Gx
	 ehhy7jvjGPy1DS6HOvtv6jX5Yo5F1vCiT7Pklu0GQc8aVVdFJb8OdDKWlwoHMupGRuo+v
	 Siwpc7HgaTotpe1YM8PDv/knpYigtVYwm0alsHdIoecfU8mAiv9nV106sA+jnCJ89KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJF8ZxhL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A1D606B2D8;
	Wed,  4 Nov 2026 22:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJF8ZxhL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F591F000C1;
	Wed,  4 Nov 2026 22:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831109;
	bh=qKsVITMKAmIjPk1rdn/XvZZWDKj8qfVTKT90XPn2u1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJF8ZxhLhnxBHRg6KpQdTy9ZjvF3pVICBsL0+A0NbHLYxaIlOC7me9k4i60GDp1wG
	 gGcBkUHbqbXSXgV46pLFpsQJNXVJ8ON8YFkPy9fqMPU2Ru4ZSdGvGmFgriNHvd6eq/
	 e4+kXcwzsoiY8dZq3WsU3PM6dp/ebK1KJ10nLHoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andras Pataki <apataki@flatironinstitute.org>,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0469/1005] ceph: do not cache negative dentries for snapped directories
Date: Wed,  4 Nov 2026 16:03:22 -0500
Message-ID: <20261104211057.150470092@linuxfoundation.org>
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

From: Xiubo Li <xiubo.li@clyso.com>

[ Upstream commit af59562a5b3d34fb3aa7753f2543393578d06dbf ]

When a LOOKUP/LOOKUPSNAP in a snapped directory returns ENOENT
without a trace, ceph_finish_lookup() creates a negative dentry
via d_add(dentry, NULL).  For live directories this is fine — the
dentry naturally expires.  But for snapped directories,
ceph_d_revalidate() unconditionally trusts all cached dentries
(valid = 1), so a negative dentry created by a transient error
persists forever, hiding entries that genuinely exist in the
snapshot.

Only cache negative dentries for live (non-snapshotted) parent
directories.  For snapped parents, skip the negative dentry so
that VFS retries the lookup on the next access.  Since the
conditions that trigger a negative dentry (MDS transient error,
local ENOENT shortcut, or MDS null dentry lease) are all rare in
snapped directories, the performance impact of this change is
negligible.

Link: https://tracker.ceph.com/issues/78529
Reported-by: Andras Pataki <apataki@flatironinstitute.org>
Signed-off-by: Xiubo Li <xiubo.li@clyso.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/dir.c   | 10 ++++++++--
 fs/ceph/inode.c |  3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 24abe4dbf774d..a253286214fee 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -774,8 +774,13 @@ struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
 				d_drop(dentry);
 				err = -ENOENT;
 			} else {
-				if (d_unhashed(dentry))
-					d_add(dentry, NULL);
+				if (d_unhashed(dentry)) {
+					struct inode *parent =
+						d_inode(dentry->d_parent);
+					if (!parent ||
+					    ceph_snap(parent) == CEPH_NOSNAP)
+						d_add(dentry, NULL);
+				}
 			}
 		}
 	}
@@ -840,6 +845,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 			    dentry->d_name.len) &&
 		    !is_root_ceph_dentry(dir, dentry) &&
 		    ceph_test_mount_opt(fsc, DCACHE) &&
+		    ceph_snap(dir) == CEPH_NOSNAP &&
 		    __ceph_dir_is_complete(ci) &&
 		    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
 			__ceph_touch_fmode(ci, mdsc, CEPH_FILE_MODE_RD);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b6c60d787692e..fddeeb9527fb3 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1783,7 +1783,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				ceph_dir_clear_ordered(dir);
 				d_delete(dn);
 			} else if (have_lease) {
-				if (d_unhashed(dn))
+				if (d_unhashed(dn) &&
+				    ceph_snap(dir) == CEPH_NOSNAP)
 					d_add(dn, NULL);
 			}
 
-- 
2.53.0



