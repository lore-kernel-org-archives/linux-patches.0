Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212371;
	b=ieYD+TIC0jpkTGo9Jrup6ZKTAHDkXUmrlu0dNyqCJ+sXTtxsIQG5NmRmebDR/ZXp0oCn
	 9UW+1+oOfMEiIVmOaE07nfIWy9/OfhBXqmqW2Dy4YWIOh4xqDuWp8esdKaVDmWPeDdAv9
	 hJo+SGJjmPJ/vnf6zA5FnkiH4nc93rfDfEsOCzqXusor3ZOdaYz2IujAvHRkR9bIgoQwa
	 9sYC8ouwt4j7d3nqUxkl6gO89146w7gog1RvlygZ5rd7YEm3XE3ZzNLbGZktJCZl/cBDt
	 DCjmsCsr2Sb//NIv2rLo2/ZB0knRhYANGs5wrh9RaPlQJ43znhElsq6RShxhhZEZu6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jm6R8oQ8kLPAUqe9fc5OMsNZtCNj9Z9yvTHosddaxc4=;
	b=VL9oVVPOhcCOEsOVjLgHpDmEMzgB+FI+psoCtda1cmsHGfPeAqwYCzRsjCkeYDoyq4VQ
	 J2/o2l5iGG6dNWhuTblS5X5e8FJKLmMzR/+dWLiD0z/fLbLr1/luFxYxWKRA+oLoFBjpA
	 syDdM5vTpdE2T8ptmUDW7yIvMW0Rtz+IRbBy7RnLx1KM/1hn2tq/uh2WCbIp/w6o8qvLo
	 zDzvkMmAjZG1pbZk8WMuUM2I1RRWmXPTEcQettDX81CD9mcMPmGAPWYEFTj4YzCbJAv/J
	 vK2m1c51KFtI0J9eDpPZS7hSTxHYScHVII73K1Lbav85ybhUf/FObMVhneJhBHaT9jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZHbAfFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EE4606A31A;
	Wed, 28 Oct 2026 18:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZHbAfFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2771E1F01825;
	Wed, 28 Oct 2026 18:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212370;
	bh=Jm6R8oQ8kLPAUqe9fc5OMsNZtCNj9Z9yvTHosddaxc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZHbAfFKYDCaTIXJ5qa+RW/I1kSbeAygddD9XwZ3BGs7fe1Py8ch0ZEzpKAGDMZs/
	 OaMEmV2X/WtlOvGbvjxgcgnJdsRN2T1+ooBKVIxDUl0xq9yu9W5eDiGu6RmSPFz3uW
	 fH0C8GhJ4DzteD8KtuPDlwG6Aip/hKuHQnau3xxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0130/1887] btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()
Date: Wed, 28 Oct 2026 17:37:06 +0100
Message-ID: <20261028170502.197356456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 0594e3423f4ba3137c734371169491f9a98e9af4 ]

mark_block_group_to_copy() iterates over the commit root with
skip_locking=true. A concurrent transaction commit can swap and free
the commit root during iteration, causing use-after-free when
accessing extent buffers.

Fix it by using path->need_commit_sem to protect the commit root search.

Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
CC: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ changed path->need_commit_sem assignment from true to 1 to match the older unsigned bitfield representation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/dev-replace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9c856a73d5333..f9c43aadc78ad 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -520,6 +520,7 @@ static int mark_block_group_to_copy(struct btrfs_fs_info *fs_info,
 	path->reada = READA_FORWARD;
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
+	path->need_commit_sem = 1;
 
 	key.objectid = src_dev->devid;
 	key.type = BTRFS_DEV_EXTENT_KEY;
-- 
2.53.0



