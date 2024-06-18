Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DD713B7A3;
	Tue, 18 Jun 2024 12:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715402; cv=none; b=J+AxdFXx9VweuY/O5ECxUFtuEckhFgYY4do54/xbeG1qx4JIAVzp8Ge/P7lVrlJWiuLl+oZ1qPCwjna8IV5q8mjTgrbBRRSrFKHTgYpc5rdOP55rsGHCWXKqHUXVnXAcVMqijlzbmCfDMqPw82HIgLJwqV9p5st5B3m41fD0+zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715402; c=relaxed/simple;
	bh=y9l9D0FhyTN9f/4c///T/wrxTcoPKsP/x6ojfNyG7pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INQ182YfHFUAcncdtg7K+sVle58kM6ag3u4HLuEHmBxzWmOaNGN7hkMbaDf5LMMRSBVKiZOMPIV1cgarjvRwHELYtVA8rTDcoVD7K29/TKNjjmgba48XppsOM4IEhvifAKPrUoHEVtcIAdp98F/t9zfwhAmfIqpkEbxEgvYVUQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTxSjglc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTxSjglc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB72DC3277B;
	Tue, 18 Jun 2024 12:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715402;
	bh=y9l9D0FhyTN9f/4c///T/wrxTcoPKsP/x6ojfNyG7pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTxSjglcxvxb5yn9X/50kJgZp7aaraom5+c/6K/+hU2GZOHN+oZghz+e6JNPKkw/u
	 XIgZiXsuNsHgNrmGImBxD120hrg6Z7IYpiiFvSf+ls9Ftdn7UfL5pnrylgRMadaeCo
	 mwruDg4BNDl8hWQyIMJ3Ug1AGT8lrklgE+UiffUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dai Ngo <dai.ngo@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 296/770] nfsd: fix kernel test robot warning in SSC code
Date: Tue, 18 Jun 2024 14:32:29 +0200
Message-ID: <20240618123418.688784812@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit f47dc2d3013c65631bf8903becc7d88dc9d9966e ]

Fix by initializing pointer nfsd4_ssc_umount_item with NULL instead of 0.
Replace return value of nfsd4_ssc_setup_dul with __be32 instead of int.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c  | 4 ++--
 fs/nfsd/nfs4state.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 573c550e7aceb..598b54893f837 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1178,7 +1178,7 @@ extern void nfs_sb_deactive(struct super_block *sb);
 /*
  * setup a work entry in the ssc delayed unmount list.
  */
-static int nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
+static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
 		struct nfsd4_ssc_umount_item **retwork, struct vfsmount **ss_mnt)
 {
 	struct nfsd4_ssc_umount_item *ni = 0;
@@ -1395,7 +1395,7 @@ nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct nfsd_file *src,
 	bool found = false;
 	long timeout;
 	struct nfsd4_ssc_umount_item *tmp;
-	struct nfsd4_ssc_umount_item *ni = 0;
+	struct nfsd4_ssc_umount_item *ni = NULL;
 	struct nfsd_net *nn = net_generic(dst->nf_net, nfsd_net_id);
 
 	nfs42_ssc_close(src->nf_file);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index a20cdb1910048..401f0f2743717 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5556,7 +5556,7 @@ EXPORT_SYMBOL_GPL(nfsd4_ssc_init_umount_work);
  */
 static void nfsd4_ssc_shutdown_umount(struct nfsd_net *nn)
 {
-	struct nfsd4_ssc_umount_item *ni = 0;
+	struct nfsd4_ssc_umount_item *ni = NULL;
 	struct nfsd4_ssc_umount_item *tmp;
 
 	spin_lock(&nn->nfsd_ssc_lock);
-- 
2.43.0



