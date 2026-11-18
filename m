Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034345;
	b=1VRzVRibUSVQV2B60LoL60qOERkqIgxVBzyCI5fP+Ip57hbddRcyznjpg8NdXzDl9FsT
	 ozbsfrakpZOjtZ8R/RqLeXraqNz31+lM1PkEmOtHjHfj5t2wHwDCLsex3KlGhYnH8Q3WM
	 +o4YcvPV3OgKtbm5OTGMyK8e25m6Vu/yKS7dZrY8nh2En4Rw4YWHC7WQWN06cxeEU1wlQ
	 3o0m9WjjwwmQhbq+o9mam6ivOQRcyUdYsbrXby6Gh2QaMISJX7P2bYi8f+h6fNklNNrIN
	 gXIBuRJOn4QD91FXflpk7QVcJ2uxma2iojV0ZLl0eSUCRMUUGnf9xjWjYxUeXHmZfvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=C4Bs0QToTGIpWLxGsUgvwhuGcTfIMAwMH4B5odrel54=;
	b=N1KuEwwNI6xlR21vchR3xC/MOTwv+eh3fpvQM8cJTZ6QOHLNrvJo538FIgcPSysw2Do/
	 wsj30mF8JXVgDuTvJs3NORH6XbIxSEi8ydxmGWn1IricszEzCYK5D0iKSbZTmitxatkHW
	 /qB4ArLTJQpH3gsCnJ6ILkXOTntb/MODMY4nhLhLa+ZtSnuq9xZE1s7HNwO5SHqXu8jiZ
	 +1Zw/mwb8fPkKhbmUN/5rUvZrS6SHomP99Y8tlAgivp0PdiFOt+iI5TcaqCiHBLWgPBn3
	 lXM1r65OqZMApYUNBti8zyp4U17VXd7xj5JpVUJ70pQMAiA8+hFYFWRo+OLg+zJ1cNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lIxW5EI6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68D7606A31C;
	Wed, 18 Nov 2026 20:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lIxW5EI6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44ACC1F000C4;
	Wed, 18 Nov 2026 20:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034344;
	bh=C4Bs0QToTGIpWLxGsUgvwhuGcTfIMAwMH4B5odrel54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lIxW5EI6new8wHeSEkFJIpsP7WzlsE50mGWop2nUWRscah5w9b51PtUZdrNwWdnqf
	 R7MD9cUJNlUBOcbVwr6z79ZdhV/puEq1maTtpGI+k6D0W6u/q3g1HHwZOIIb4/Ik9D
	 ZHWBXrzx7Ha8GJfrsd0ZxMJ9RFgMWc2SLkCx85BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andras Pataki <apataki@flatironinstitute.org>,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0329/3318] ceph: do not cache negative dentries for snapped directories
Date: Wed, 18 Nov 2026 15:15:51 +0100
Message-ID: <20261118150325.785675253@linuxfoundation.org>
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
index fe8a050cf7b90..83b3ae87a7d08 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -775,8 +775,13 @@ struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
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
@@ -841,6 +846,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 			    dentry->d_name.len) &&
 		    !is_root_ceph_dentry(dir, dentry) &&
 		    ceph_test_mount_opt(fsc, DCACHE) &&
+		    ceph_snap(dir) == CEPH_NOSNAP &&
 		    __ceph_dir_is_complete(ci) &&
 		    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
 			__ceph_touch_fmode(ci, mdsc, CEPH_FILE_MODE_RD);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index c4632a823a5b7..940ab16f7cfc8 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1722,7 +1722,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
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



