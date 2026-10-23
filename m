Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774886;
	b=zRf9bhYakh42TzNdducSamQvnBR5sz291ywvkjhnQPTKYIJ20+I432JMoHtpCs2mwSrA
	 lM0SrAJji/WLeoCnuEOy2G6kcf4htubqBvIOrdAo6I0owqCMLWsqyt80+NOYkhAEAKJrT
	 9is29ZD0Y7FVvYW+GAxUypuKJnOEomdpdEJj3R+ALpaKMukPBGVqS801akUv9igXw5pVq
	 gHrnPlC7GcBoNOctNqXlTIhkrAzKgBW5AWk+bLG0EKmKx8zxPOUW0eD+FC+ZIlKXbP/od
	 3jSHrRZgbMZzs4myz+Z0qJIaPzolTOjnGMiPxqrBGMPE08aY819H6l3xfNP/CkG2+CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mXH+yaI131eGeq8ypw/szkBj4F1iVxpQa3W2ZwpRWKY=;
	b=VaenPMTiV1DdOii/x/Tu65S+Xc8CrdZbG4+J1FjbxT9BluEJgVEmBDN+dOFZR+HOFwjO
	 GfKFikmtedvbGZ7Cbtu+LGxYi8f7gatVOzNyCdYWLtI30RjiyDHaY+euQ97d5a9QmC7d0
	 W5vfAAV8GNieyUVCqmI6PSm0IyEuO/vRLtvDB7EPiapYk+SWoCtsuRhpr23OAny1nteBM
	 9+Saq8A0z9Ih2ZFWf3kjsajzPYUxxOYJCcNX4/YDfVuY98dOlu87Vl9rAr8f186CmvxZU
	 Dal9Txi9LJxgpYT4ncR/jLwSuMa9w44QWwjFx/DQTnONB7VgbubHzCoQ14gZChlKVig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yl4bj1fm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7329E606A326;
	Fri, 23 Oct 2026 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yl4bj1fm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2E51F01825;
	Fri, 23 Oct 2026 17:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774886;
	bh=mXH+yaI131eGeq8ypw/szkBj4F1iVxpQa3W2ZwpRWKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yl4bj1fm/kl/C9iHE8Xfk0pLJDiHkV+pXRQkx4f4yCgDcvihhwUHo2hHY+9Z4Ay3i
	 UK2EWTO7hDoxfl2mWbdVww+PxHKwdIs8/tECfeSnGpTN+UtJRE2+jZ+V/xy7kyBD/6
	 Z8ORiYTTBxUYnxSHfI7Qw3Eori6PtKm5wSdog7V0=
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
Subject: [PATCH 7.2 191/242] xfs: fix capability check in xfs
Date: Fri, 23 Oct 2026 18:40:33 +0200
Message-ID: <20261023163718.308218247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1175,7 +1175,7 @@ xfs_getfsmap(
 		return -EINVAL;
 
 	use_rmap = xfs_has_rmapbt(mp) &&
-		   has_capability_noaudit(current, CAP_SYS_ADMIN);
+		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
 		goto out_error;
 
 	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
 	if (error)
 		goto out_error;
 
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -835,7 +835,7 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
 	if (error)
 		goto out_dqrele;
 


