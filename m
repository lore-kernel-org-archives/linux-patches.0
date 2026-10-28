Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210090;
	b=TRYd9wZcQT+VDvziXhyu59PdlZxxzHOHQ67pyJHjX9YMOjsQ2vSuFzdVggtPCfG7ve55
	 l0Hd+irmcKcNJfGXL251daCoi6WfkHVbATyGAfZVXr2/t36KDEYaOk/1IrNvunk0hvJ4i
	 VCGJJOa+BcFxEAfSbFnFcuwk5tJZ+ewX09FhVA8wHo5sYWpGfmfrw2zID2On+cKMm3JWG
	 Enmu3xg0seOZV4vcSe1LeAePdHKChHl0oj25JWel5s87dzEfmgrRC7F6Y0H8gYf7JRdyt
	 uj27AhXBWe3INb+aN+ewofcs4F5bGbXTFAi8J9XAmKKLrchmI8MTQVOdg2CntlU59Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=frLMbWVBnyIRWbIRj/zfqqgGvFsyJWu2/1g7XXDr3jY=;
	b=WpP9G+6j6mxacufyu/36YOGGGQ/ZKdHpKi3RO9n3o31JsLoGntr5ZhE69WYDUbkrGg5C
	 OcdYO2+/s1KeL1TnXHLOFtYjNJyAFSL7tGRsANd4358knMBsoOLWWtWwMjvM5rI9+9VxF
	 nX65WLI9TaiJdJvNFI0Xlh6iwvLlEd173ASI2OGJTfTpcLLCHiGkN90B+VVTf6bW8Bxpi
	 QAsFX9dtOk0MqKGOWG2AtHvGwU08h9CEDV57K9yVh0dKXPxsA7MNRT7wX59R3Ddx1wVKY
	 EmSf/SSXZjVq9NPrQz2Vgl+jB2CrKi1XJ+8hVH2HWrD9JfOdddi3oCu96HRc8VvQXXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SUwu4s22;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF7F606A31C;
	Wed, 28 Oct 2026 17:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SUwu4s22
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F0F1F01825;
	Wed, 28 Oct 2026 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210090;
	bh=frLMbWVBnyIRWbIRj/zfqqgGvFsyJWu2/1g7XXDr3jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUwu4s224805il3ue1XecvUfJsRc2gccvIhMOMFaaMPle1BQzgF3eoGpkMcy23R6I
	 UU7HL7EjSpCIDVzBua9/SVWIt5xiI3iELnPtmVHwcO50PS4xXWFhDrsKyiy08nuPAW
	 kznNDYESsJafH6IVptxo5VSc+2h2LLod5HnW7wKE=
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
Subject: [PATCH 6.6 073/168] xfs: fix capability check in xfs
Date: Wed, 28 Oct 2026 18:00:09 +0100
Message-ID: <20261028165944.812921884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -902,7 +902,7 @@ xfs_getfsmap(
 		return -EINVAL;
 
 	use_rmap = xfs_has_rmapbt(mp) &&
-		   has_capability_noaudit(current, CAP_SYS_ADMIN);
+		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1218,7 +1218,7 @@ xfs_ioctl_setattr_get_trans(
 		goto out_error;
 
 	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
 	if (error)
 		goto out_error;
 
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -712,7 +712,7 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
 	if (error)
 		goto out_dqrele;
 


