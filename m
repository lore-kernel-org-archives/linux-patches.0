Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057613;
	b=BhydvpVjaV7hqPvFvj5u/wyIJnU+KwMJg03sZulYCtNdyIKACA/0kevQ9JS/OBc6fO4m
	 3MT+6yKyBhalBoaGKqGKV8dxAQtaR/LVszdyhT904wmheZWyRCz7OdUG6Ery1I8l/A/Fw
	 xahvbilqV4+eRQatOeuuqV06dTyH0F+SpGaa2guSS6zRfhlJRJ8+qzuuIMcTRxGo7pUFy
	 B6n+IiI8aB04ZwwHNlHAeKLMXlG7fv1WB6A3uP+NXPjLoYAVrPA6ct8/Pzu4Nk0f3mcpK
	 Q94XGzrHxnY4/EKIr1nsZQroUj6OtNtxMsNxZwy8FZa42VYBTlv11GCCwcKb39Lkldg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JmMA/yvvdYOHr5PndTRpKxLnxxmUyTkVPKabofa05+8=;
	b=Td7K55rThhmbI7zETWZJLgVNYyYSydsac1h9nSXN2L8e/mZfF+a2R8WtlGlCHaVK68wG
	 YrheGFXXzUgTzXejygTBk5lYAshB976XdFlov9hn+ECGuuFJf0umm0OrClhOVP05Xa+NE
	 cywoq2fknR6KO3pXHMuqbV/ej7+QEwReAEYQ2EiwiwHLdQHjj/AUhM8MhYoQI/uv9HYjr
	 /GrXL/wfgxnOyKRos2fOFmmpLlHkrDtxI69524Yu0o2+CcheWv4TVMDSBlGspHnBHHF56
	 zoOYFt8E51rNkoM1Vn4NJW63ReiQqyKGTUERyYYAYBdMJHc3iZEm8gXoQj6Q9SlYsWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwtWBE3Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF23606A33F;
	Thu, 19 Nov 2026 03:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwtWBE3Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E91C1F000C4;
	Thu, 19 Nov 2026 03:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057613;
	bh=JmMA/yvvdYOHr5PndTRpKxLnxxmUyTkVPKabofa05+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwtWBE3ZJtRR0sj4OelpMkY6z7i3/EV7Wo51A0t3TsPsWordHuWPLnQj31vi+ctAm
	 +1T+w1rv4fcYiMDDaWI8cxwg8y2RTa8e4kU6hjpb/c9u+qIjuIsJkf3LTigubUCgZe
	 JWn3vQPl5mpUwn+HyJ7z1oxruZPWKSXJYZtEY+0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andras Pataki <apataki@flatironinstitute.org>,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0193/1848] ceph: do not cache negative dentries for snapped directories
Date: Wed, 18 Nov 2026 15:37:11 +0100
Message-ID: <20261118145919.820376747@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 52a441f86ee39..de12c27513024 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -719,8 +719,13 @@ struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
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
@@ -771,6 +776,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 			    dentry->d_name.len) &&
 		    !is_root_ceph_dentry(dir, dentry) &&
 		    ceph_test_mount_opt(fsc, DCACHE) &&
+		    ceph_snap(dir) == CEPH_NOSNAP &&
 		    __ceph_dir_is_complete(ci) &&
 		    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
 			__ceph_touch_fmode(ci, mdsc, CEPH_FILE_MODE_RD);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 57132f8331ebe..8528903302c66 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1429,7 +1429,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				ceph_dir_clear_ordered(dir);
 				d_delete(dn);
 			} else if (have_lease) {
-				if (d_unhashed(dn))
+				if (d_unhashed(dn) &&
+				    ceph_snap(dir) == CEPH_NOSNAP)
 					d_add(dn, NULL);
 				update_dentry_lease(dir, dn,
 						    rinfo->dlease, session,
-- 
2.53.0



