Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831577;
	b=5IiWYC+nt/cR5aY4CflAWN4yuFumpwTFNbV5yDs864k8uI9j0zz+SOfBV8Hf9xgw5omd
	 zrYHDGPPdrd9qCm/uHvv3HOHoPZOVdd+wKheWeqYX7xgtTOQrPdiJlAZCtybc8pNNP3o/
	 IdAzwUeC1BDty4966/ZHSgsdNYzV5c2u1w+VlFqJIk1bsoJW0IhcBelDIFSJ/PwljhCZh
	 j7Q6JbM3sIEdCJgMKCSezKhCZM3G7Pw1/daoSYINnzXUUAhA2gw0V1ebEGzg0tCXU5oMi
	 1Jso0H1aLjQpdN9H6iPweywIQuY694aIkPq42NFwFjPCZNnfzBWkfEqZBwXlg0WItcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=du1/TJaK2lEB1wpL5QN1WtoWwUBKnyWPUdOEf4A+IBI=;
	b=RMEA3TNiXYLuEDn9l3w72uIa/EB+gaSp5CC0df7RVIHDd3uTheOp4EPLJbgGiTA3XTm6
	 bu/b3B1yn9aUjgqyRwPiMjLFYfRunmTcQwEzU7TgY7xMxGMQs3+JVIUgWrwMYk7zYugm0
	 rLwNG+RK+AU4ofuH0U6MCEo6iaaqaOLpzPGdqFPzP50JtFV2CB8I+NPQn75JvD28/bmPK
	 kQ71q2xApUMfosWpDBuXMPGzppGc8GOz3aks9cEHGAcMQdnaE1q1GjVqNrr4z+i9E/aqm
	 qNDcxmjzip6IO1uIh82WfW6kU0KneQ5YOdtv1DJGGURE3FyqGfa/6Od2xD1LeA0meqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Y2vI/BZD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EBB606AB0A;
	Wed,  4 Nov 2026 22:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2vI/BZD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB681F000C1;
	Wed,  4 Nov 2026 22:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831577;
	bh=du1/TJaK2lEB1wpL5QN1WtoWwUBKnyWPUdOEf4A+IBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2vI/BZDMDj8ztD4OfawQig9gCfm+k7u5s0BeeRda6xVVnrwaHTo/BC/UTtZmLp6K
	 rngnV7r8cMiVCwZvhGJNWDWUIsSdt/uT5kMKwXbQqqRBTHCzPsXgSWVhvni+TnnS4d
	 vBSHWEp8dON6AMeUnU5Qc3wD04+0dQqbpqmq7W4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0786/1005] xfs: fix inode btree repair when a cluster is larger than a chunk
Date: Wed,  4 Nov 2026 16:08:39 -0500
Message-ID: <20261104211105.365429625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 65b89ac3e8c2f041384f715a71b9d113edfa32e5 upstream.

LOLLM noticed that on filesystems where an inode cluster buffer is
larger than an inode chunk, we can run through the loop body in
xrep_ibt_process_cluster more than once, and the number of inodes that
we pass to xrep_ibt_cluster_record is incorrectly large.  In this case
we can run right off the end of the buffer.  Fix this by moving the
nr_inodes computation inside the loop.

Note that this is only likely to happen on filesystems with (say) 512b
inodes and 64k fsblocks.

Cc: stable@vger.kernel.org # v6.8
Fixes: dbfbf3bdf639a2 ("xfs: repair inode btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/ialloc_repair.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -294,12 +294,8 @@ xrep_ibt_process_cluster(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	xfs_agino_t		cluster_ag_base;
 	xfs_agino_t		irec_index;
-	unsigned int		nr_inodes;
 	int			error;
 
-	nr_inodes = min_t(unsigned int, igeo->inodes_per_cluster,
-			XFS_INODES_PER_CHUNK);
-
 	/*
 	 * Grab the inode cluster buffer.  This is safe to do with a broken
 	 * inobt because imap_to_bp directly maps the buffer without touching
@@ -320,6 +316,10 @@ xrep_ibt_process_cluster(
 	for (irec_index = 0;
 	     irec_index < igeo->inodes_per_cluster;
 	     irec_index += XFS_INODES_PER_CHUNK) {
+		unsigned int	nr_inodes =
+			min_t(unsigned int, XFS_INODES_PER_CHUNK,
+					igeo->inodes_per_cluster - irec_index);
+
 		error = xrep_ibt_cluster_record(ri,
 				cluster_ag_base + irec_index, cluster_bp,
 				nr_inodes);


