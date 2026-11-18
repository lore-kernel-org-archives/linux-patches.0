Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045002;
	b=0scLYs4GB201IkXfaoJDRc+8SeQpGmvTuOBHawQGyWjiTPFYhmFSSl3kmXbsKr/Ib1R+
	 ltgrQJrotVS1tCNc7TGjoPZXQQ2qFrr3WwziAk7XQXrF7g/6uFhKk/Az3rpit7UkDLWu2
	 vD2Hv69Ygsjlau9orzVSX5WfQYiWFLinHqKm5k77UAfhXydx8CtQdcjMm9qRZtyyIy4xf
	 l0DD7zmcqgZksKMtaz4D9rnbegJzko1ZaOUOyP6jlH9K/ml0NwXfHwGG3Vhfy8nOFy1L2
	 VfORpZN0kJc4NaG4BmlISus77lkDafVvTzJtLhoqDQyNYfWszEVZT5zgvZQgcp1vfwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EbWcxVRpL7SM/10x7+1DapWCuCb/CxFVKz29O+YnHbw=;
	b=L+ilrHwe9xTIWRH8AjMrnEQ68HYNUbHPDtblUCqDdx3VsK9M8I0SfLaSNEGpfBjTys1c
	 9cXB1Ji9o9SoMELhXXo37oBv/E5ZqO1sVgQHT9uY21Bn2ZSfzxxzWt2WS40mX+jb/kwR3
	 3W2/eJ3GyXdhWifKSqtgAF9a/Z6V7VFTYH6Q4yQ3ALwmgJyPWpNGKlio87YMwXBUm17p7
	 q1y6Fc8dMBqxg5NVKqd8lVH5eGcSe3o5w1e06AvYUfICnSRM/lZYmsFd4objDE8G66QfD
	 ZiKX/2kLddDT1Ljo//SLoT0aS0tpe6jIJA7oIOLO9m42HP+PljeSN5IeSCs/NHsAHxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNrE9CE6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E712A606A32C;
	Wed, 18 Nov 2026 23:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNrE9CE6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480C31F000C4;
	Wed, 18 Nov 2026 23:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045001;
	bh=EbWcxVRpL7SM/10x7+1DapWCuCb/CxFVKz29O+YnHbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNrE9CE6/jLpaSudXtGu/4d8LRUlpdis+RpXlMUduiwMWaevbSWmZDD4UbCDcUrmk
	 osX7kP/fcG0iuzHRf+KXpHwQJibc2RaRLRxkffqE1/a7CQddvf/X/XoDgMmZqaV8Lq
	 XthRcPkconaQ9XCRyW37Rq+up+CClsXGFMXzeB6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0767/2857] affs: validate blocks before freeing them
Date: Wed, 18 Nov 2026 15:30:01 +0100
Message-ID: <20261118150229.174569549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 5ba9ef2742f6e..f400b28eea28d 100644
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



