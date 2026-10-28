Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207696;
	b=EMw5biVa7c6Yal8l3iIT/fceoLbU2EJYL6SC40WCznBpb/P/LzVXJUcUFXAXBBVi3H5f
	 0irP17vRjC1QojYfyP8u/jZ6KAC44oWXhUKB8PPs63IjmjLknjZ0Dja+B3w0YY5mVxzuB
	 d9iNYTRqcuaHDkBYkl6qvzpkIM5jsJyyVTDhs4+CQ8vebhgrgPQEnfFBe+9vnZBGMp3bb
	 QVtECOBSzb/41OzchQcbfjuP+o7wcwjXVnSKWnzsQmqYycZd7urHkIrNpQY4sG6m2ypBn
	 FDZPlF0dBrMiohL/QpGmbiiW1fkJs/9QGkFJr6mGfEWrLSuHT735ptqc7Lo4t6ZvCAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2AlXbWqa559+3TTkxyns8FfYTUa2tyImqZb72i7YwFI=;
	b=X3Kc+OrUZcmgJYNdRIcvtBQjoU2LVP2GZP208+6RWTbDf7re9GLvHuRijWvhljrGoQN5
	 J2HZgI/ok9AR/6V/1UM8dfGHNTbJ/pIx8CGJ3bliWsHesAFjtRWqBf3XPOrxFuq8cvnG5
	 2nsW7kNNyKs6P+AZikDKDVOcD3VsC+F69fJENa4UNRuPoB2aavIYME/Q3vD54ryGVCoPg
	 aibVZ5VyqbXhU1ZCdwuRGextveZjeA5+aDWNDpnn+7nYoc6vkafwrR4R16QGWyNRNgAi5
	 0nvILqdYHmmPfn4IhOJDO+9aLmCLDq4FzMP57ZBKYohIgtZTBO9D03/rJvvqiLKHR8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HPca/XrZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAB9606A320;
	Wed, 28 Oct 2026 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPca/XrZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801D21F01828;
	Wed, 28 Oct 2026 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207696;
	bh=2AlXbWqa559+3TTkxyns8FfYTUa2tyImqZb72i7YwFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPca/XrZeIWT1yvClOT13tvIHTxvmjcicoXrEIqyAAUVaBdTWa7C17ExdHybU5bNm
	 CZjDquH+1QdL2FGCCilcat8UfNsmMW47GmPi8+itYKLYaNUaEfjyImtdLEiIGYLKwT
	 r6+7snVUW8vBhBy9rBo00L8FyBJ36c0zI5LLAxSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 107/247] xfs: fix capability check in xfs
Date: Wed, 28 Oct 2026 17:58:30 +0100
Message-ID: <20261028165949.931076979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Maiolino <cem@kernel.org>

commit e2f62a9744ebad3bcb6347a648e615026e9efeff upstream.

An user reported a bug where he managed to evade group's quota
by changing a file's gid to a different group id the same user
belonged to, even though quotas were enforced on both gids and the
file's size was big enough to exceed the quota's hardlimit.

Commit eba0549bc7d1 replaced a capable() call by a
has_capability_noaudit() to prevent unnecessary selinux audit messages.
Turns out that both calls have slightly different semantics even though
their documentation seems similar. Where in a nutshell:

capable() - Tests the task's effective credentials
has_ns_capability_noaudit() - Tests the task's real credentials

This most of the time has no practical difference but in some cases like
changing attrs (specifically group id in this case) through a NFS client
this will allow the quota code to use XFS_QMOPT_FORCE_RES, effectively
bypassing quota accounting checks.

Using instead ns_capable_noaudit() should fix this issue and prevent
selinux audit messages.

This also fix the remaining calls to has_capability_noaudit()

Fixes: eba0549bc7d1 ("xfs: don't generate selinux audit messages for capability testing")
Cc: stable@vger.kernel.org # v5.18
Reported-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Serge Hallyn <sergeh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_fsmap.c |    2 +-
 fs/xfs/xfs_ioctl.c |    2 +-
 fs/xfs/xfs_iops.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -916,7 +916,7 @@ xfs_getfsmap(
 		return -EINVAL;
 
 	use_rmap = xfs_has_rmapbt(mp) &&
-		   has_capability_noaudit(current, CAP_SYS_ADMIN);
+		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -573,7 +573,7 @@ xfs_ioctl_setattr_get_trans(
 		goto out_error;
 
 	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
 	if (error)
 		goto out_error;
 
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -735,7 +735,7 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
 	if (error)
 		goto out_dqrele;
 


