Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2DD156C7C;
	Tue, 18 Jun 2024 13:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715686; cv=none; b=LCljfCR35WsXlefKXBQ86xMRJ2tXSxYmFsfXzmjfCw0SRNhQA38oHy0iCYVzBX45tJ7kcOBFg5H/jTTYu2J3HRRd1b/61/fsg8e9JJvB1R2aVID6+KS3COH5c7ceImXM6jz29uUWedORLtuwwLxRltEumFzEDua35jrKzGTUs9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715686; c=relaxed/simple;
	bh=QTPpjrFV5Q4ySfhFO5TW6rKfUakZdt1YLzOwVPVdgJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iN6/YBvbfH5QaXChxmBBTl5MxR3iMWRg9sUItBzXX6jYeohWjzdwYzlYEZrUaOkTvhx6NYe3WQ9iu1icC1x5xluGpUMPjcP/ecRNb9Ss5EE1ERwpuP8G7fZvsHy/JyaHCs7410Dxv+P7vujmETiV5z6C9LGL7TTNvsWz2M6834E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEiBv2+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEiBv2+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86097C3277B;
	Tue, 18 Jun 2024 13:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715685;
	bh=QTPpjrFV5Q4ySfhFO5TW6rKfUakZdt1YLzOwVPVdgJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEiBv2+MXBRr7AqxcWZEpcLMaIYrJtnOivSQh1wlG9AznI6MshG9mJ9GvbQwQDM6i
	 /qddMB6tsTl1r/Hp1WEmLQ6pU8ZorzuF2PQ7Emg+Czgo0qWhVNEd399G8YuONeRkbs
	 vVqNjwWsYvpheEJ05SIVoN8b6/3mQa/+uhlE8xgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.king@canonical.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 393/770] NFSD: Initialize pointer ni with NULL and not plain integer 0
Date: Tue, 18 Jun 2024 14:34:06 +0200
Message-ID: <20240618123422.448253674@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 8e70bf27fd20cc17e87150327a640e546bfbee64 ]

Pointer ni is being initialized with plain integer zero. Fix
this by initializing with NULL.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c  | 2 +-
 fs/nfsd/nfs4state.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index d55d9b9dbafb1..ebb6d8471e8d7 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1181,7 +1181,7 @@ extern void nfs_sb_deactive(struct super_block *sb);
 static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
 		struct nfsd4_ssc_umount_item **retwork, struct vfsmount **ss_mnt)
 {
-	struct nfsd4_ssc_umount_item *ni = 0;
+	struct nfsd4_ssc_umount_item *ni = NULL;
 	struct nfsd4_ssc_umount_item *work = NULL;
 	struct nfsd4_ssc_umount_item *tmp;
 	DEFINE_WAIT(wait);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 68562564be6b2..0b39ed1568d40 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5573,7 +5573,7 @@ static void nfsd4_ssc_shutdown_umount(struct nfsd_net *nn)
 static void nfsd4_ssc_expire_umount(struct nfsd_net *nn)
 {
 	bool do_wakeup = false;
-	struct nfsd4_ssc_umount_item *ni = 0;
+	struct nfsd4_ssc_umount_item *ni = NULL;
 	struct nfsd4_ssc_umount_item *tmp;
 
 	spin_lock(&nn->nfsd_ssc_lock);
-- 
2.43.0



