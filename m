Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061070;
	b=oOkP3JPvPrblyPfyv2iPXLbv4RnbL09WpD8Cuntlc2/oQJj5WIJJBiPSZEnAJYIIRM0i
	 trjtF0pXBbIW4oSO1bNGomxDupAL/YMzZsuWCbuYIdlqjqUBkjwCtTsznmUX2W+ETL5/G
	 /dD3de55ygLxRh/dDfiGNtOCGuYELOGK/3sy/mt7FiE7GsjvwKrUaLZMzUhqxWAQT75Az
	 qHlN1orLrV0jmfOTWxYeHJIKDTdo2qGboOYIobNghKzZHNSxaYntZk6L197rp+JY34sw+
	 MaINJNXiIAUX7ODM+7uO3mvxnYyR7X2YwHpfcdzmCQwsLWuW3bbaA35iLeaBn4qKQnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HiNXxvND8fbAlPg04DnETYxu8p3UNii6FWN6+46pXIk=;
	b=CYnxus3D56Cz+XGOw9Ee+hlVZsexZETntvOw7SE5zZzwjtKT7XNQBGoKyOW9faD1B29O
	 9HMnr24pi32fygIYRYSRq9+/17j14ZT8UT5h6GHnIi5cuwsJx3Ip7NKMn7zG+zzPtOWmD
	 qcX2KTY4Z8HFmwte3+tAXGvoKQe43ynNtaoyNjizR113IPII+SmGz1OeAwxVxjr72FF7R
	 NZfbgCTLfrmPumPASFEhCF5NEIT3cAnHeh44vvGgpidF5NKR3gDtaB1DJBOoa3TDl0pDc
	 0pu/Y37S0TWXhZCGHIYlzJrZwO4UZ7k4qYxkVwaVkkfLaa1xck8G0+00GFpzb+Xrwrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R6xj666i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE55606A336;
	Sat,  7 Nov 2026 14:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R6xj666i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AE31F0089F;
	Sat,  7 Nov 2026 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061070;
	bh=HiNXxvND8fbAlPg04DnETYxu8p3UNii6FWN6+46pXIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6xj666i3GJ2GrvRYFiT3PhLilXYPK+rsJhJylBx5QM+PGPDBagcAkCz7BYvUUBSa
	 bZak1Azqe2X5chhU64BxVXhkKFKRlIE2/QyKVJ6RYI7/ybR+1Kf92MejJK5DTzv/k1
	 RL2cS3siXMx/3TUjVhIwKenWnaYBmK71wtGZqCgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andras Pataki <apataki@flatironinstitute.org>,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0397/1536] ceph: do not cache negative dentries for snapped directories
Date: Sat,  7 Nov 2026 08:40:13 -0500
Message-ID: <20261107135008.742706828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 90ab0d55d9478..4896e27583e1d 100644
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
index 92ea6085957c7..32f612934f839 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1782,7 +1782,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
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



