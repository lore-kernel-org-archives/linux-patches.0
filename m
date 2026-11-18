Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043749;
	b=x8bVrJSrs/Qempkl38IgCUtAq0WN1+h0y5rk6v4H57rXqJWzKKRwa3ohKefwepvDh6h9
	 VpmyXqLaNM/JLMEBIjBs58TlS/9CnflUmGbRxOFzAGoSqFcqAYOYQwiVg3JBV6lZDEqs5
	 j/drX36imNVdf/XnWhpWVNQ7qNghCKgeq/XqOUH6yHp11zFTNROmEdp+WY10UCgsVdnxF
	 E/h2g5IjroRPOgHnWz2PXD3wdR9t5nzte8W5MblTf8PIZ5E0QAuBLtqKpCLAIrkQfptsE
	 eMEzDRcCMhdhFtZEPDm2aPP2IBlj19NTiZhBP814IPjbumR2nNX+g5et/DpkVIEFhqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=faD0PFJJLA7nw/EMbImDDBVgKVpc9b1emlZAMaFLfnQ=;
	b=bkOAYnKX86P5bz5rufVoRJ+UDkchO2adJ5QlqAIHULoliDsZF47P0A1CvxE/jWch8hBO
	 vkWx9/n+v2wkXBmZY5IS2e81RNmfHpUF2ymbuO/a29QgrbepBzk3Pj/1pJa+cBctsv3Ux
	 TBAerq3Jc0NDDYs2BJ2qEchm7Bi+ljLeTHz/bfipru7vfxZXnFLFnnZSAry6hXi6Eoo/J
	 8FxGNViIJ5CndVCHG2S1hrfoy8jwm98VZAqWHFw4+FUrxEW8XI+05uHsDNFykg49Ol5YG
	 VZ2TaDYmsPQWmYEws+liOPgw8pR/ES5Gi0R7oGK+Dolt55IH9g1rRsS7FKwpZ6RB4uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5gSiqKt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57128606A325;
	Wed, 18 Nov 2026 23:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5gSiqKt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51851F000C4;
	Wed, 18 Nov 2026 23:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043749;
	bh=faD0PFJJLA7nw/EMbImDDBVgKVpc9b1emlZAMaFLfnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5gSiqKtf3URP50Kplgde8XYsJg1QjtrwtL/E/OCZd7/7VZztfumn61lt4sR6kWHj
	 zzg3VT/m4FRjboYaC4+7nPFI7rcFfnexOxdMo5cY/jknmTZ/FbU+wCOamJWY4aLjl6
	 owAzoYilqgw3BxSAWribSmS27H4GjoJFXzHIRhoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andras Pataki <apataki@flatironinstitute.org>,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0280/2857] ceph: do not cache negative dentries for snapped directories
Date: Wed, 18 Nov 2026 15:21:54 +0100
Message-ID: <20261118150211.507604719@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6b189276d7662..031cc13087535 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -721,8 +721,13 @@ struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
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
@@ -773,6 +778,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 			    dentry->d_name.len) &&
 		    !is_root_ceph_dentry(dir, dentry) &&
 		    ceph_test_mount_opt(fsc, DCACHE) &&
+		    ceph_snap(dir) == CEPH_NOSNAP &&
 		    __ceph_dir_is_complete(ci) &&
 		    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
 			__ceph_touch_fmode(ci, mdsc, CEPH_FILE_MODE_RD);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9843dee709c14..86aa95736726f 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1462,7 +1462,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
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



