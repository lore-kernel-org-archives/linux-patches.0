Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774131;
	b=oLB1W54C9tsw4c36kaOBns1f2cZjw8PffPxjnmZkq3PnEQlLNIyv5T/KVea+TCk3DyT1
	 hF0Q3m55FL3WPhqwqRb7WwC7jA1671gTmUX1xDbWIRI/36RNmRLTwCeZ6aKXHRWV5/Iv7
	 v26XqWSJfPj3Pfbpifby1ZadZqLP/4Lx7aO5x6GcParU/Opi/jTL0xK1TzBddFqFcJJn2
	 Yupo2rCfsr5qF7W8DbGKiLqet0YmT1QRNVn1C/9H+h4V/DIGZHE+WKmc/IZP/u2z50Trh
	 MjFcVJTZv3WpI8hDU7smdB9K28fqT2f+aG3sSwH9B6sDBB+IUnXwBjEUy//DZFPh/Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dwfBUxH7xtpTWz6nVJ18i35a9w4i43k+U5hhBHhitgg=;
	b=HNsMtL2Ct7hd2F7NwuWI0tLhPgAbKHLhT5NtSkpucPJODl2hb8qCx7T76Nl1dUP9mtdx
	 0/4qbmfFh3rPyWTvRLYr2SLj/pw4sL5rIN08TSiEeuTQ0lOO84ND/ODgJgUfz6t+D0Bid
	 f4i3X6E9aH/rwaaGGu+oqW4BK643Z9lLRcsziHqsLzCWS06w1GeQ/MOWCm341R7KaOj7Y
	 GzSqh33143iS48wo8uMGCKdB/EPnTgIaZuwohKnVkWXiFiNIn6d3G7c80lWUPFyMXf5nW
	 KO9YYja80YSXACp4v3TlbN1JGbmWl3Fv9/KLsYdAUkoT8SlMS0ThZbUY8erYX2eNg5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dzwQQiAk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C47606A32A;
	Fri, 23 Oct 2026 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dzwQQiAk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227881F031E1;
	Fri, 23 Oct 2026 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774130;
	bh=dwfBUxH7xtpTWz6nVJ18i35a9w4i43k+U5hhBHhitgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzwQQiAkoK7Jz73ZHZANqC8isymx+xvNIfoVDsASrf0phfBZhUvMQQnE4GJunmimS
	 wEWWOK/FQS2KV1LnOibPoCeGjeCHjroXCD+aiM1927fMQLyWMejBeEOoipnjtKvjIS
	 mdbSCeV4v/Zh3RyPd4ijaWj8395ADt3/FVKzYRqA=
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
Subject: [PATCH 6.18 130/193] xfs: fix capability check in xfs
Date: Fri, 23 Oct 2026 18:36:47 +0200
Message-ID: <20261023163717.283371773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -619,7 +619,7 @@ xfs_ioctl_setattr_get_trans(
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
 


