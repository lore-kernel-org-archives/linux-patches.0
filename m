Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6B4345736
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301863; cv=none; b=VskAwBYIj5qD7cruEkc7YA9uphRFI8qTAr1EVXDn/IOZfJdnV9YIgOX61iCxuejWDzR88pGuZYBMVH9wIv3+zmbFLr5uD2Ogn8F0BJjGFpurwT2y1grsvuy3Xu/BUzc4NpAWOETgdzEfwakeN8+6ykBe/j/5yXRDQA8b2jfLwFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301863; c=relaxed/simple;
	bh=3dlDQKzit/DrVDyBMNZZfGkQgiTse6KrFZEK9ZkNGk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAdBx6BQZ+IXe3tUcEcvGMcCC+KqXPTUcp3lLPp35fho6Nspu3sl8+JOdXjF0foIuv9IxvwvZaG6RKFd0dF6D79g9qIz2WkGw5B6bTtxQwxQ3HKzwbM39RQWwPPwwN+amLx+s9hVu8DEhHHU2+xEj2mzRhN/w2H0b6Zqdb30I08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbBA+/iU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbBA+/iU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EED0C19423;
	Sat, 28 Feb 2026 18:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301862;
	bh=3dlDQKzit/DrVDyBMNZZfGkQgiTse6KrFZEK9ZkNGk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbBA+/iU4sO8iKHKKo9U79iGlCTAW11cqe27FsZjhimXADjKmmG7TCMnq/OPpRctm
	 EDxr1Vu2jhc06fwIye9t9cSh+uCFm5yRiUBch9AD+K8E9CaKtaAFfmerE23kkdawhl
	 wEytQ77F15VjnzbePHSEFLrv42v9kZSqrnaULHgDLhmSyQ/ajL2EBJpZLKuSxDTMRd
	 FKYAaoKce+uDGnTtz0N4jk+HPbl5QVOGYD52ngXaEIgnzeZBLLJ+qRVRvamoEqwLwI
	 SAl77hcIgZxOEr2cIEvmFd3XPMF00ARvBGBo6snW3pQWoXvSiloMWzE2uKzETBDill
	 T8UQ33XM/bbGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 285/385] mtd: spinand: Fix kernel doc
Date: Sat, 28 Feb 2026 12:58:27 -0500
Message-ID: <20260228180011.1568201-285-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit a57b1f07d2d35843a7ada30c8cf9a215c0931868 ]

The @data buffer is 5 bytes, not 4, it has been extended for the need of
devices with an extra ID bytes.

Fixes: 34a956739d29 ("mtd: spinand: Add support for 5-byte IDs")
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mtd/spinand.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
index 702e5fb13dae7..4bf33cefbae5f 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -195,7 +195,7 @@ struct spinand_device;
 
 /**
  * struct spinand_id - SPI NAND id structure
- * @data: buffer containing the id bytes. Currently 4 bytes large, but can
+ * @data: buffer containing the id bytes. Currently 5 bytes large, but can
  *	  be extended if required
  * @len: ID length
  */
-- 
2.51.0

