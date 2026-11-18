Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052227;
	b=ekH0P0eipei6Ew+p7Nxn1o42RTu3KNkpZde53DyGaE9r7JeQH7AJJc8qwpfShxvd7QkF
	 NIBywxzbikW65VTf5/6g10EQzrtXRt0W//7zcTwKtU+Gkfp4UDyZmUgwiJ2ylk3BZMqeW
	 utaZlGiKzxgAPc2bopHC4Lr0GR1kRQX57vhu0vkljPjW3yzrPlBjYb4/2ky7NvDIMd5Ml
	 jBKO7e1NgcmR8ThHfgcrEcxUYAaMkeykjNDmtQBooUtQq8FUZePhDLcAqP3QnhABKeaJD
	 ZAs/M2/RyxiPME7um7A+0NMla5FFx5nz+jaT1b1+Qpks0SwcZiPS7v84cgQokE2hojg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4LdKqnSVCHRJZFB44r+Eym+ugK2x5tyEEmw98lonOqo=;
	b=NPynjHTSUsT5a3sLrxiUPRj2V8sCpmAWfAlwEjqq4M5cqPAg9MtUiyCcxZuYuyXjs/Ny
	 U/7oH1+DOXtfOag1Vm/yp0QxR9PpnnJNLOnhJmUUz007s2c4z2VWPwbJFjMkZ/FfdRQXF
	 dAjoPiJPTPyfuEG95M/NPu/RwOZR9gUw/UQAHwxbQPIrxu3guCzL/X8ucpSrK+gR62ukR
	 mQA4Yo2jq/t/QGTA4RQ6a0dRIC9JJwa7v09YZJUPPQIc/pnoT/fsemP+bcrND1XiwitsQ
	 eKKUkfEQ6y4d3eTuQwXt2SplAPD9dC9w+hoLZELnVNYy3zBgpqbmAXn4Zl9VopDlZIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uw/zaxAb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CB8606A320;
	Thu, 19 Nov 2026 01:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uw/zaxAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788AF1F000C4;
	Thu, 19 Nov 2026 01:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052227;
	bh=4LdKqnSVCHRJZFB44r+Eym+ugK2x5tyEEmw98lonOqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uw/zaxAbqqsr2slBxfWn5GuMcLodbnktjd5G1OpkeTDcPYxKWXNhl9dMpOjs0Xt5A
	 UFOZRXNGV+ecHTvdh91ULRH3kr6lrqhzEED41BSe4cQbbqgS9lF0vipIGe1EfQaBrL
	 0yfoHd8f2q10cnFNFaSAx03WVWgaE6E/xJwdSkug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0488/2214] affs: validate blocks before freeing them
Date: Wed, 18 Nov 2026 15:36:04 +0100
Message-ID: <20261118150030.725491772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



