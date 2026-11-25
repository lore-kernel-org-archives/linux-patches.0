Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618897;
	b=HJ6al0x3u7NfuRaHhEQtETuqXWEN5OuoGlpo43Dl+TY3D7q0PiN0KpS+/k6trGfQ72fg
	 OmiR0G80ooKMyhUpNDWqnm73wqv1JJPj1LPQirYw45q4DnEj6ZJQ83ZKjk9tHUM1yFK2V
	 52q2EOrtjo7Ag/S92Ci55Obnx1ZywwEnfdS7GpitJvFZEsKASE8udw4s8pkbASP0WCSSP
	 CcTvq5gkk3lXS5mAJ7Efg7YMwZ8t//ReIpVCUEi/ob+QJWPSb0OJNG1GI370gjBJTI85v
	 yWEztpAjeVoIAeB6nsUtbNsT98td/Z3SS68wNe7gShwEUEUZqK1PvWZkONswDq0WYEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gfSf+1kevwm8Y6XimhYahM/CrKdekvBO5jMDzZlo+b8=;
	b=imSL+hc3p1MynsPeLmXmbVJLneJYnKhhb2pctgKOLthp4DZDHUd13Ukx+U4TOe7UqDCL
	 TAZQ5dEC0s7ZnvkKU8qbTfynxhqo7t7DCKl3p+csmiDnTMsY+aIvldwRGEGNScFD0bchu
	 KspAXR5pKHLia0H349VAz+dg185b7lup/Xq5PDt8HlgUSpfRrBdV4TqQbAcbcMxbF8GxM
	 tuy1LF0V3HIv1RMLeY34qRuD8xZNeLhO9wMdLzrS3p0XuICBDVMd7KCN30CNNSD3EwGrg
	 19VCPeV/AfLKzrKAFyXA8BOM6LHaRpTYeEdUBl5eT8F4PHGq4DfMcrlCgcgmzJ4HeJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKCkaFaO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6C4606A326;
	Wed, 25 Nov 2026 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKCkaFaO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915F41F000D1;
	Wed, 25 Nov 2026 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618896;
	bh=gfSf+1kevwm8Y6XimhYahM/CrKdekvBO5jMDzZlo+b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKCkaFaO3LQksiZ0zqEbAFzGBCGsWr7XZ8zQF5ezMNYue8VXs1NWrgKXVum6TEwmv
	 xRvF2oTf2VeKXLjrB/wg2YBz0hWkEC8P/l/WoWLjc0+rg2iZF9quj3BLLlO8mDbMRt
	 80U9FwxTNvsn0F8wr1pKxjDMJi8nL1y1A0bfzDu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Cheng Yongkang <teel4res@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0424/1005] btrfs: handle zero num_stripes in btrfs_chunk_item_size()
Date: Wed, 25 Nov 2026 15:29:22 +0100
Message-ID: <20261125143831.686880354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0415d74cad9ba..e516c874f349a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -711,9 +711,8 @@ static inline enum btrfs_map_op btrfs_op(const struct bio *bio)
 
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



