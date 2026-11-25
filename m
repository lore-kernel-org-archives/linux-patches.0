Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624052;
	b=3MvfEygXPCLGXEs5NUC99EUpCwKMjQ3oi4gYmkfNuluMxB+ElA3jyHLs+61/r0BbLvn+
	 eaV3nFEqrO3BcnkhL0Rc4/2uv3+IFqbIwlOIhP/uQhV+7NOYZV8lPxPybxu229VvjGmcm
	 s8yc+7BGmq4+dlpSOGbE4CcRP7gfKX8OpEQpXQjta7lwhOcef8Y/AnZFZE9kYJJmsusuX
	 VCNlHY6Sk9o3xIeEgo/GpEEvmHn0sxUNubWaLUwMJEVrBaHlDKmL1aQzfb/ENsRK9NF85
	 UpBAwaI8rcmd9tkjcgEJNqcg6mK4JyL0LALA+LGs9OKTFfFoZ8+WUI0yJOV1KZdc4og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86JJxIZ/ou1YtRqMg9M1Ai2lXee4qkR4wVmN9+8MSDQ=;
	b=mLK4gKUa3gr0sAOFLRbtRaWTnXywmZRazDm3zay2OyYV5eqgQQt4y+78SvADgb3zT70s
	 FNa0U496UVZQhFlbfjj43wY1jesM3TDChtwx7mTiZbQZg/FTb2iXl1tuWksvXwIQAhhBH
	 E6X88Bbbni+5T6Ng8SKegN9IMDaBemfpcmNAsNScyfwgLFmPt2qW5p8VJUtnr0i1+QB3q
	 E+yEQg7PI2aOT8hSqQXHCV2b9rVvxI+3zaUHJvG3X6VxQVJhSvyXvpPeWcqJ+xpEtgVh3
	 tyA88dbf8Ovt9Er9oXj2By0ynI4yZJLC71S//HBrJUe4Xmx4Rn5h7wAY7+tK+RwFlhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWgUM2y8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08811606A31E;
	Wed, 25 Nov 2026 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWgUM2y8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42FF1F000C4;
	Wed, 25 Nov 2026 16:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624051;
	bh=86JJxIZ/ou1YtRqMg9M1Ai2lXee4qkR4wVmN9+8MSDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWgUM2y8Saywkm3DkOYFt86f61DCr87jGeFewf5jcnTEbFEbhYVCVDoYVAbqB877/
	 Lljej0m2DS0wtNVk/DLs9T3t8E7XPsdjnG9ZUZID+Dd0QUlpCht13vkd7HGxx0ISf2
	 QMWACptiHtGrg/t+gw2NhhMWs0UaJOwbypq/JxlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/816] btrfs: verity: propagate orphan insertion errors when enabling verity
Date: Wed, 25 Nov 2026 15:26:57 +0100
Message-ID: <20261125143850.819478212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guolingxing <guolingxing@tju.edu.cn>

[ Upstream commit 45a686dff6b91c3667cd8188d3a02c69f62f4d00 ]

btrfs_begin_enable_verity() ignores the return value of
btrfs_orphan_add() and unconditionally returns 0. If orphan insertion
fails, btrfs_orphan_add() aborts the transaction, but the generic
fs-verity code still proceeds with Merkle tree construction because
the begin_enable_verity callback reported success.

Return the error so that fs-verity stops immediately instead of
continuing after the initialization failure.

The transaction is already aborted by btrfs_orphan_add() and the
handle is released by btrfs_end_transaction(), so no additional
cleanup is needed.

Fixes: 705242538ff3 ("btrfs: verity metadata orphan items")
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/verity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index fb0eb6c4fd221..65a17d7e4e53f 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -604,7 +604,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
 		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_end_transaction(trans);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.53.0



