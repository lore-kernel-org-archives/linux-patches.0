Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063973;
	b=1VUaCKbcIxozUlj39pxw3r4MqYksumQPX+XXOkuoIZaNZgIzjWfEigADQS6yj2FhIEhG
	 2PTo6X2Vhpfk+W6cgIgCVtXxd7DDMUiRnqU7KksDbAq+C5ulfbNEZPBG6XzKyVLTzOQci
	 OznpjYrjdQybRb5+nCIE1sAnbwFlIBv7dVyLjNub5+K5wo8D0P1UFjBQClcdKfpegWTrX
	 fJoxxDEIdwFohCj5B3fVAR6SDE49EpwF3UdjOe4ysVi/idPrmbWBsSiIxMEb4H3lmm1NH
	 8hXPlxPYZ6gF4ZlxjpTEWK7PwTUbeSwuwtMi7hkfEJaHYnvhprp7YRm2txiTOcjaAdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v/BuhDr4XwueqzYjwBQOuDWtEHr/2unm2ftgqWRWQnw=;
	b=Y0PhTKzJ8agc9wpTypM2UDrjucaxd0h5J4x6EXDAtQncLZrIErgnYxvBycct4QkK5YQD
	 Tgs4cTcB4Xn6ned6eA4ALFXw1kFZexSOxh6qq1fblOqmpxbeGRItcfO8q1HkO47Rwfx9k
	 msziDa5QkgYS3E3KUbNLZB5zfAIq6PhcrvQbw2vlJMJssA9qjF8qdVK/0ZVdG6DZdmivX
	 fCZQ/rOtpF1BbMXSIlhDu9FI0I2p8jJSbQ1eAHgZ/mhz70eUHXIoYNWxyD2dmQyOFTnix
	 FGAmtx3WEObXMTaikpQtwmXz8S7NgYj9gjYhSUQUXNQTCBXqSED7+S2ouRP7UcEYzaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BMLhWYpS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02E7606EE97;
	Sat,  7 Nov 2026 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BMLhWYpS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2AB1F008A4;
	Sat,  7 Nov 2026 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063972;
	bh=v/BuhDr4XwueqzYjwBQOuDWtEHr/2unm2ftgqWRWQnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMLhWYpSm2yiDeot8XZNEujz1IvE5L+pVOjkJ2ByP9EWIXNLNVXNil3tCXqRVBcDu
	 O/gCbgOUd9pXCH0Yle1qvpUThTlC+yDY66eXdrldXgbxdbOpDlJzA/9bxrF1yfQRUs
	 mzS01GHlU0hkzda6rLzySKHw2PDPVibkS1asxgGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0157/1257] affs: validate blocks before freeing them
Date: Sat,  7 Nov 2026 08:40:53 -0500
Message-ID: <20261107134943.657632217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 78ea2058abf3ee053c0bd9c1b9a77304cb4ae58b ]

affs_free_block() accepts block numbers from on-disk file block tables
when truncating or unlinking files. The function currently rejects only
block numbers greater than s_partition_size before subtracting
s_reserved and using the result to index the in-memory bitmap descriptor
array.

That check still accepts reserved blocks and the one-past-end block at
s_partition_size. A crafted image can therefore make the subtraction
underflow or make the computed bitmap index equal to s_bmap_count,
leading to an out-of-bounds access on s_bitmap before the bitmap block is
read and updated.

Use the existing AFFS block validity helper so freeing uses the same
range as block reads and writes: s_reserved <= block < s_partition_size.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
CC: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 40bc4ce6af4ac..f013a2a94d4d4 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -46,7 +46,7 @@ affs_free_block(struct super_block *sb, u32 block)
 
 	pr_debug("%s(%u)\n", __func__, block);
 
-	if (block > sbi->s_partition_size)
+	if (!affs_validblock(sb, block))
 		goto err_range;
 
 	blk     = block - sbi->s_reserved;
-- 
2.53.0



