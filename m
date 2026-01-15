Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9752D9494;
	Thu, 15 Jan 2026 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497719; cv=none; b=hHgG/X7Mp92cF+iiynDF4MYRfKeoLMooQWiujQXAHl0UXM1Q8gRIuGDMJ5d5cwIElgh9fHw3AaiWA2zRvWJcFUaw+77HQRbYVGX1br0ZzqE3NGB2x+k0mSBFrcOLIivFNnltMLFaRZCwdYF8Yagbrll6aoSQgrTKrYkRc8E3S1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497719; c=relaxed/simple;
	bh=Vbnnd3yxByoZpnbe5zDmjzznDfXpn9H9dLDU9aMb0UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvXyv/aTpw3AflETwbRbLG86dx3fBKp6Z3Ha8zQhJ0O1Ajse8on3GFmo9yDwCuTO49cleKUW17AwxGe7wx1WvOxI08sZ0IrhSAP9yqaHQvdj3Z883hzullD/3opqwM+1hcvsj/DIcoqOW5/Gv62hZUIpCUNj6LmgyHUZwDmpI3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2ezfixF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2ezfixF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA680C116D0;
	Thu, 15 Jan 2026 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497719;
	bh=Vbnnd3yxByoZpnbe5zDmjzznDfXpn9H9dLDU9aMb0UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2ezfixFV6Xp47xiYPoUBkNluxRCtK7RVsrzzqp1gmRgYWRJO19cYjjNawi3jtakr
	 dTvANVGXM76Rbx/nVLe8pwAfwJhDLnvkXDG7RQXDHJNZHqg6gmLfSwAF2TE/Zpq1yu
	 43tGWC9W8v4S4rh3hjog6477/CnlPs32RotYiyck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/554] fs_context: drop the unused lsm_flags member
Date: Thu, 15 Jan 2026 17:44:06 +0100
Message-ID: <20260115164252.780460399@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 4e04143c869c5b6d499fbd5083caa860d5c942c3 ]

This isn't ever used by VFS now, and it couldn't even work. Any FS that
uses the SECURITY_LSM_NATIVE_LABELS flag needs to also process the
value returned back from the LSM, so it needs to do its
security_sb_set_mnt_opts() call on its own anyway.

Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Stable-dep-of: 8675c69816e4 ("NFS: Automounted filesystems should inherit ro,noexec,nodev,sync flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/mount_api.rst | 1 -
 fs/nfs/super.c                          | 3 ---
 include/linux/fs_context.h              | 1 -
 include/linux/security.h                | 2 +-
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/Documentation/filesystems/mount_api.rst b/Documentation/filesystems/mount_api.rst
index 12e30da6a511c..1dc90a83b5fd0 100644
--- a/Documentation/filesystems/mount_api.rst
+++ b/Documentation/filesystems/mount_api.rst
@@ -79,7 +79,6 @@ context.  This is represented by the fs_context structure::
 		unsigned int		sb_flags;
 		unsigned int		sb_flags_mask;
 		unsigned int		s_iflags;
-		unsigned int		lsm_flags;
 		enum fs_context_purpose	purpose:8;
 		...
 	};
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index f91cb1267b44e..0faed67d61bde 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1280,9 +1280,6 @@ int nfs_get_tree_common(struct fs_context *fc)
 		if (ctx->clone_data.sb->s_flags & SB_SYNCHRONOUS)
 			fc->sb_flags |= SB_SYNCHRONOUS;
 
-	if (server->caps & NFS_CAP_SECURITY_LABEL)
-		fc->lsm_flags |= SECURITY_LSM_NATIVE_LABELS;
-
 	/* Get a superblock - note that we may end up sharing one that already exists */
 	fc->s_fs_info = server;
 	s = sget_fc(fc, compare_super, nfs_set_super);
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index c861b2c894ba3..0b386c5c03342 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -104,7 +104,6 @@ struct fs_context {
 	unsigned int		sb_flags;	/* Proposed superblock flags (SB_*) */
 	unsigned int		sb_flags_mask;	/* Superblock flags that were changed */
 	unsigned int		s_iflags;	/* OR'd with sb->s_iflags */
-	unsigned int		lsm_flags;	/* Information flags from the fs to the LSM */
 	enum fs_context_purpose	purpose:8;
 	enum fs_context_phase	phase:8;	/* The phase the context is in */
 	bool			need_free:1;	/* Need to call ops->free() */
diff --git a/include/linux/security.h b/include/linux/security.h
index 946fa58eb05a4..95102b9f75c98 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -67,7 +67,7 @@ struct watch_notification;
 /* If capable is being called by a setid function */
 #define CAP_OPT_INSETID BIT(2)
 
-/* LSM Agnostic defines for fs_context::lsm_flags */
+/* LSM Agnostic defines for security_sb_set_mnt_opts() flags */
 #define SECURITY_LSM_NATIVE_LABELS	1
 
 struct ctl_table;
-- 
2.51.0



