Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A618746D091;
	Thu, 20 Aug 2026 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243772; cv=none; b=XLLJa1ni4XETkQNUKDMV/mPALKz6Zrn8Ed+JNdyXz3yZeKHUxCz8JWMUMd7/UyCpzPLC51v6N4+oX8vy6whktncxXWGp1owEx0NQ1XpFl+Nui2ECQQtyzk9ECFiimP7OXKGlGGKMz0uMYkgBaMsCaP+Jr1igjR6SZnLMqwVAXYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243772; c=relaxed/simple;
	bh=ijCkvHOAKfpOd1uh6RbgJAXiXyuz4bZPdKS1CMgIk+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Op/tCTDnq8KOPpQvWpamhXTrhPiGA9g3eZEXpgqAIMLRJeWzKnwXQBgJYOIjrFnockib52Dksom6bi6dlh+jjE6gzIWXt/9MVFa0Mtb3ekcodrhiXZ8tm3K5S/B1et1fKcYSdY8tc424sHK7K9O/dnD+dD2sjpsoQILPKFc+AhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPBVmxXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPBVmxXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA011F00A3A;
	Thu, 20 Aug 2026 16:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243770;
	bh=lMuRZlJyNO2B++1K7cBk3QnuukyQMFjgm6u9tkc5eBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPBVmxXDGuJO6Q4X0exw1RCVF/kuRWLHUCzB42A6WguenMxVR8yBSMLYeviIqWdGg
	 IA7SQG6zOpZhfa9lDa7d/qAV36eReGJG9AX1qexbYtS6pg4oiYbchqvrmWqjj63RmX
	 4JJ+r2NVl+WF4lcqAhp1AbeZt/3GIljXv7zEUITo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 211/272] ceph: print cluster fsid and client global_id in all debug logs
Date: Thu, 20 Aug 2026 16:56:35 +0200
Message-ID: <20260820145237.848851855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 38d46409c4639a1d659ebfa70e27a8bed6b8ee1d ]

Multiple CephFS mounts on a host is increasingly common so
disambiguating messages like this is necessary and will make it easier
to debug issues.

At the same this will improve the debug logs to make them easier to
troubleshooting issues, such as print the ino# instead only printing
the memory addresses of the corresponding inodes and print the dentry
names instead of the corresponding memory addresses for the dentry,etc.

Link: https://tracker.ceph.com/issues/61590
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 50958bb928ba ("ceph: fix hanging __ceph_get_caps() with stale mds_wanted")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/acl.c    |    6 ++++--
 fs/ceph/file.c   |    9 ++++++---
 fs/ceph/metric.c |    5 +++--
 fs/ceph/super.h  |    6 ++++++
 4 files changed, 19 insertions(+), 7 deletions(-)

--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 
 #include "super.h"
+#include "mds_client.h"
 
 static inline void ceph_set_cached_acl(struct inode *inode,
 					int type, struct posix_acl *acl)
@@ -31,6 +32,7 @@ static inline void ceph_set_cached_acl(s
 
 struct posix_acl *ceph_get_acl(struct inode *inode, int type, bool rcu)
 {
+	struct ceph_client *cl = ceph_inode_to_client(inode);
 	int size;
 	unsigned int retry_cnt = 0;
 	const char *name;
@@ -72,8 +74,8 @@ retry:
 	} else if (size == -ENODATA || size == 0) {
 		acl = NULL;
 	} else {
-		pr_err_ratelimited("get acl %llx.%llx failed, err=%d\n",
-				   ceph_vinop(inode), size);
+		pr_err_ratelimited_client(cl, "%llx.%llx failed, err=%d\n",
+					  ceph_vinop(inode), size);
 		acl = ERR_PTR(-EIO);
 	}
 
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -282,6 +282,7 @@ static int ceph_init_file(struct inode *
 int ceph_renew_caps(struct inode *inode, int fmode)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
+	struct ceph_client *cl = mdsc->fsc->client;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req;
 	int err, flags, wanted;
@@ -293,8 +294,9 @@ int ceph_renew_caps(struct inode *inode,
 	    (!(wanted & CEPH_CAP_ANY_WR) || ci->i_auth_cap)) {
 		int issued = __ceph_caps_issued(ci, NULL);
 		spin_unlock(&ci->i_ceph_lock);
-		dout("renew caps %p want %s issued %s updating mds_wanted\n",
-		     inode, ceph_cap_string(wanted), ceph_cap_string(issued));
+		doutc(cl, "%p %llx.%llx want %s issued %s updating mds_wanted\n",
+		      inode, ceph_vinop(inode), ceph_cap_string(wanted),
+		      ceph_cap_string(issued));
 		ceph_check_caps(ci, 0, NULL);
 		return 0;
 	}
@@ -325,7 +327,8 @@ int ceph_renew_caps(struct inode *inode,
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
 	ceph_mdsc_put_request(req);
 out:
-	dout("renew caps %p open result=%d\n", inode, err);
+	doutc(cl, "%p %llx.%llx open result=%d\n", inode, ceph_vinop(inode),
+	      err);
 	return err < 0 ? err : 0;
 }
 
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -25,6 +25,7 @@ static bool ceph_mdsc_send_metrics(struc
 	struct ceph_client_metric *m = &mdsc->metric;
 	u64 nr_caps = atomic64_read(&m->total_caps);
 	u32 header_len = sizeof(struct ceph_metric_header);
+	struct ceph_client *cl = mdsc->fsc->client;
 	struct ceph_msg *msg;
 	struct timespec64 ts;
 	s64 sum;
@@ -38,8 +39,8 @@ static bool ceph_mdsc_send_metrics(struc
 
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
 	if (!msg) {
-		pr_err("send metrics to mds%d, failed to allocate message\n",
-		       s->s_mds);
+		pr_err_client(cl, "to mds%d, failed to allocate message\n",
+			      s->s_mds);
 		return false;
 	}
 
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -456,6 +456,12 @@ ceph_sb_to_mdsc(const struct super_block
 	return (struct ceph_mds_client *)ceph_sb_to_fs_client(sb)->mdsc;
 }
 
+static inline struct ceph_client *
+ceph_inode_to_client(const struct inode *inode)
+{
+	return (struct ceph_client *)ceph_inode_to_fs_client(inode)->client;
+}
+
 static inline struct ceph_vino
 ceph_vino(const struct inode *inode)
 {


