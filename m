Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829574;
	b=1czm1Z1iHx2hZYNTXKAIG/C2Lyz0pseu+6iyn6UHFnHmzDtp3JsW2D9dsq//shL3IvdH
	 ARJY/jNVvE9UeClNFW9bU/+KFZV3psqf08nHOujEIVxXlZZ96ny4am0LBRiG6WKaYQIxx
	 DqsEu57GCBVV/oYJq4yKWBBduKuqw5pZrbKYkfonawZhICfY1Nxk+3pVzHoZm5d8mcxU4
	 0SK+oChY1MlJua9ss3vKc9B+owhARFanh4K6uOqcvLQpqaZLnuG4J5OtqOYjCLpKKurNO
	 ku7dDHydVi57PFMI2n+jZA3DfTIHHaj1IZpkg5UJRh4jGN5WkohnoqgBJRDHqz6TODQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xlwylqMmF3iNeeOVEdL34lruc/Ykox0Vo+uo/q+sEdA=;
	b=Q8vR9sAvc0iRm2EqzsmnlGwPDEhE0rUvIj7AJhZCGRMExK++VVlRSHasbKqPkERJky6n
	 FZaODewonb8B7k3fk5oxSVm1Vv0BlK/j3MPqv37IHd73OwMH5EVIKSXS/p5oJ9zPSqGdj
	 YWoTuiv5UDp6rTiEt+7pNUuxAzdTw2GHDmDjQh8wUkRL6m48yF0WeH8NHFhSq0RkbIjUv
	 6LeJ9Sy9EuM5Veomlc7jNJaBjYPMA9gK8zT66JHj7CmW71FcOUnIYqNB0VfCjWtId6Rxh
	 T6kaTNRb5GcILrEFP0wM2CZAuBDsKe3ztL1tsEBq/9Ov0dg7o7ACD18CtQH9RibZjsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WTUrDYZ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAFA606A33E;
	Wed,  4 Nov 2026 21:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WTUrDYZ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730E31F00A18;
	Wed,  4 Nov 2026 21:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829573;
	bh=xlwylqMmF3iNeeOVEdL34lruc/Ykox0Vo+uo/q+sEdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTUrDYZ0pfjmMoKdfeYI2sh1DfUAnONxT3HlQdSDkfV6OI0UJMlwz+9t0rZzqXkma
	 FGwliLOo3ESJEIfuzp9rk0jtfXrvmnyFXPTHqh4MWcx671pVdJVUZJAnBNKfaxvBme
	 gxKQOp7GmtHUtG0m9zUQAam4mIjRg0btcsKjHKjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0210/1005] ext4: reduce max cluster size to match documented 256MB limit
Date: Wed,  4 Nov 2026 15:59:03 -0500
Message-ID: <20261104211049.693476140@linuxfoundation.org>
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

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit afa3caf2fbc417f755f36e271c4b3c2d45ccda9d ]

The mke2fs man page documents:

  Valid cluster-size values are from 2048 to 256M bytes per cluster.

but EXT4_MAX_CLUSTER_LOG_SIZE was set to 30 (1GB), allowing crafted
filesystem images to specify cluster sizes up to 1GB.

On 32-bit systems with bigalloc enabled, the consistency check in
ext4_handle_clustersize():

  s_blocks_per_group == s_clusters_per_group * (clustersize / blocksize)

can overflow when the cluster ratio is large enough. Since
s_blocks_per_group is not range-checked in the bigalloc path, the
wrapped product can pass the consistency check, leading to inconsistent
group geometry and potential out-of-bounds block allocation.

Reduce EXT4_MAX_CLUSTER_LOG_SIZE to 28 to match the documented 256MB
limit. With this cap, the maximum product is:

  (blocksize * 8) * (256M / blocksize) = 2^31

which fits safely in a 32-bit unsigned long for all block sizes.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.alibaba.com
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://patch.msgid.link/20260608111150.827117-3-libaokun@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index dae7fb8bc598e..ed546c52ebc32 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -334,7 +334,7 @@ struct ext4_io_submit {
 #define	EXT4_MAX_BLOCK_SIZE		65536
 #define EXT4_MIN_BLOCK_LOG_SIZE		10
 #define EXT4_MAX_BLOCK_LOG_SIZE		16
-#define EXT4_MAX_CLUSTER_LOG_SIZE	30
+#define EXT4_MAX_CLUSTER_LOG_SIZE	28
 #ifdef __KERNEL__
 # define EXT4_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
-- 
2.53.0



