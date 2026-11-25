Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621908;
	b=FsmjCPqEU0hH8parZ6q9gpQQY3VBqZgfz6fKoeobq7dgXlBQJIeR4+TZMH+b2oKLFrbt
	 t60+4dIqVDrJ7fHQhlfhtX/6qho+Fjow14yRas9O1hDJNqmXxyXQ3+qyZvqrF0MfSODp/
	 v9oPSj4J+pPTkbvwH+WAEphfD+wx7T5q1Vf+fTFqOxlsUjQo8H82ycQ9FKqcUiFX1l0jV
	 hHgk8vfN8AC/Z8BtCfGTVZgGiI+PXAC0NJDEhcTQYPIWC+g1XvXvzMQ4Z7/YNq6fjLLPX
	 OBut5zdqgM6eO+jT8Ksb5xumsEiaUzO/4inMf8v8knpflhwB/o8ibiwxI/4TV+Hc6Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WyJoGxeLWDbsdYu/HND4VVTFyj+H2LBnRiPWW9YetL0=;
	b=KNNb74Q2gw2n+TyEoTnYBGZlXKsLH6gDKeEY6Pn/kOX275+LBo2LCVitZjFcS+2jmGoE
	 4cCWTJYQwRdpjlq+N6GknbwMbOHH86jkCYqcU7Skw8tvOVvlXzTkAWr0T3JbCwMvlP6Ur
	 LhX9Uxj66AVKMCpCUQQEJcVfNVa0X5gQ/IVX4/QLvU5AS49YB1y+tTaEwP8gL5Ok4LuGv
	 jN2Z+x/+XBurFu7KC5howL3mlHumfzLUnllHC7goq7s3KfjaIaQyr7KYARIWTmT3YnOR8
	 B3618ozXgGvv2vFh5Ndnp+yhwLpku3t6YLoZk7Ng8LT1PucHYxvNbTXqsJWMBcv+tzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S7qZ7xrq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77088606A327;
	Wed, 25 Nov 2026 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S7qZ7xrq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06AE1F000D2;
	Wed, 25 Nov 2026 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621908;
	bh=WyJoGxeLWDbsdYu/HND4VVTFyj+H2LBnRiPWW9YetL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7qZ7xrqtDzXRYfQJ8v0Q5d7vmk3P3Scnjuw59z0zHP2D2kOtclzsdXmfVYClaZqm
	 odJhduustBZzxKbzL8arXF+n6GeVQ1K7WBhml5jL57g0q4HByzrBDf0w5g34vOW61c
	 a5D4Gw/fWxGdkIE5Xthlfa/K+Zp2gPtWFghXUxh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Cheng Yongkang <teel4res@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 371/990] btrfs: handle zero num_stripes in btrfs_chunk_item_size()
Date: Wed, 25 Nov 2026 15:28:58 +0100
Message-ID: <20261125143830.782428859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

[ Upstream commit 8416012aa6e794a6464e073ab236f4ff862935ac ]

validate_sys_chunk_array() calls btrfs_chunk_item_size() with the
on-disk num_stripes before btrfs_check_chunk_valid() has checked the
chunk. With CONFIG_BTRFS_ASSERT=y, a zero-stripe system chunk trips
ASSERT(num_stripes) instead of being rejected:

  assertion failed: num_stripes, in fs/btrfs/volumes.h:714
  kernel BUG at fs/btrfs/volumes.h:714!
  RIP: 0010:btrfs_validate_super+0x3ce7/0x4210
  Call Trace:
   open_ctree
   btrfs_get_tree
   vfs_get_tree
   do_new_mount

Drop the assertion and compute the size as the chunk header plus
num_stripes stripes. The size is unchanged for num_stripes > 0, and a
zero-stripe chunk now reaches btrfs_check_chunk_valid(), which rejects
it, so the mount fails with -EUCLEAN.

Suggested-by: Qu Wenruo <wqu@suse.com>
Link: https://lore.kernel.org/linux-btrfs/d2ee0cc1-674e-4447-88da-d346122a43a4@suse.com/
Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at btrfs_validate_super()")
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
[ Slightly rework the commit message. ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b3b9329f4cf9a..eeb0c506acfbb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -712,9 +712,8 @@ static inline enum btrfs_map_op btrfs_op(const struct bio *bio)
 
 static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 {
-	ASSERT(num_stripes);
-	return sizeof(struct btrfs_chunk) +
-		sizeof(struct btrfs_stripe) * (num_stripes - 1);
+	return offsetof(struct btrfs_chunk, stripe) +
+		sizeof(struct btrfs_stripe) * num_stripes;
 }
 
 /*
-- 
2.53.0



