Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A833B9922;
	Thu, 17 Sep 2026 19:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671622; cv=none; b=AanIJarC//IQSJKSrWsDiWy9nXk7/qkwNmYrdvafY1DAWI/SmWf2H8zaeKCmPo9SsFb4fWe5vmEcFh+S1eScXGWpTEpu1mgumu6mZutc1mC+m9OEo9hbRTD4Owc3nPxzfLVcOnv9dDXK64cNw7ISBZy0pKuex81w36rdR6mH7RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671622; c=relaxed/simple;
	bh=kcbjlMCm7BPcFEGcRrA6nP5CzaXYvKnhFa/Bt9uE0AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtUpmQt5K75CO++l9IFBQf0pwj+iIqikkIWWtWhfQakHG2ghY2rKRkq+x1jXRJrsyFiAucka58eHFD8PSs/tq7Omy/vKGEhniZCKiEXludmeRHl5phWZLD+5gA2NkmWzAJB6l+Wey9Y1ud/zIyDua12Hhxvlc/0U4niE7wsptgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTFkxAWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTFkxAWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A8A1F000FF;
	Thu, 17 Sep 2026 19:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671621;
	bh=0hWFJoGa/CVKkbeZp7diO7zYXI5c+AYcqjyGnfQBXJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTFkxAWq3HeKZMF2Agq38toNkVfgG/PkkVk+xD+26zxkrqhns8iTU7TIVjViMODUi
	 L+4gW2yC6MKGOYXLo8MFd/aLOJeWrMyRZixZjRgWFpEYm48oI6nwNRLFpLxeyFo6Fc
	 Nf7RsUCLgXQHkHWSM/G8jS+wE3jpnttQID0I0lOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1035/1102] ceph: Remove fs/ceph deadcode
Date: Thu, 17 Sep 2026 16:16:18 +0100
Message-ID: <20260917151606.767036840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Dr. David Alan Gilbert" <linux@treblig.org>

[ Upstream commit 6025b482e48041cd71111ab4f7cc28e0371b2e3e ]

ceph_caps_revoking() has been unused since 2017's commit
3fb99d483e61 ("ceph: nuke startsync op")

ceph_mdsc_open_export_target_sessions() has been unused since 2013's
commit 11df2dfb610d ("ceph: add imported caps when handling cap export message")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 8fdf94644573 ("ceph: force a cap message when a deferred revoke can't be acked immediately")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c       |   14 --------------
 fs/ceph/mds_client.c |    8 --------
 fs/ceph/mds_client.h |    2 --
 fs/ceph/super.h      |    1 -
 4 files changed, 25 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -978,20 +978,6 @@ int __ceph_caps_revoking_other(struct ce
 	return 0;
 }
 
-int ceph_caps_revoking(struct ceph_inode_info *ci, int mask)
-{
-	struct inode *inode = &ci->netfs.inode;
-	struct ceph_client *cl = ceph_inode_to_client(inode);
-	int ret;
-
-	spin_lock(&ci->i_ceph_lock);
-	ret = __ceph_caps_revoking_other(ci, NULL, mask);
-	spin_unlock(&ci->i_ceph_lock);
-	doutc(cl, "%p %llx.%llx %s = %d\n", inode, ceph_vinop(inode),
-	      ceph_cap_string(mask), ret);
-	return ret;
-}
-
 int __ceph_caps_used(struct ceph_inode_info *ci)
 {
 	int used = 0;
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1748,14 +1748,6 @@ static void __open_export_target_session
 	}
 }
 
-void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
-					   struct ceph_mds_session *session)
-{
-	mutex_lock(&mdsc->mutex);
-	__open_export_target_sessions(mdsc, session);
-	mutex_unlock(&mdsc->mutex);
-}
-
 /*
  * session caps
  */
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -646,8 +646,6 @@ extern void ceph_mdsc_handle_fsmap(struc
 
 extern struct ceph_mds_session *
 ceph_mdsc_open_export_target_session(struct ceph_mds_client *mdsc, int target);
-extern void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
-					  struct ceph_mds_session *session);
 
 extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
 			  struct ceph_mds_session *session,
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -822,7 +822,6 @@ extern int __ceph_mark_dirty_caps(struct
 
 extern int __ceph_caps_revoking_other(struct ceph_inode_info *ci,
 				      struct ceph_cap *ocap, int mask);
-extern int ceph_caps_revoking(struct ceph_inode_info *ci, int mask);
 extern int __ceph_caps_used(struct ceph_inode_info *ci);
 
 static inline bool __ceph_is_file_opened(struct ceph_inode_info *ci)


