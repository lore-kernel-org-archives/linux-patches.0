Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5612F347BB8;
	Tue, 16 Dec 2025 12:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888552; cv=none; b=e72o/fThNbzxb967Yhxo6v/n0l3zXhjIenhg4s0AOJWUTYzIT3JI2Pc9+NiNIbruf0HZ8E2qbUxp2KZ5zGUR5rAkG3QxV37I1XvSlSQYRiAHVvpF6vR/BJoUjtGOXoYRWyLICI7I2hslemDEIrlE5z8WbarYvSEwG2KtHWdcylo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888552; c=relaxed/simple;
	bh=PsPbuP5LNpXhMQjHp1mFQHPSKRSUABMP2CRkdUb19/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJGENAtOZ9yyT9M9EvIuaLFhLmL8OO8gHinMVbXMUU2U7WNhF0/32P3MPCajP30YEaufZScgL1OqA0+okk98JVnGHCk2bJPVt9vp/hNdXXsWodlb7kFP1EDvRO3w+/1T+R3tDf8aw8N5VxKrCtjgfAH0Ftjz4AfRX/ZaZeFgGQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGVFcKJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGVFcKJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43BDC4CEF1;
	Tue, 16 Dec 2025 12:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888552;
	bh=PsPbuP5LNpXhMQjHp1mFQHPSKRSUABMP2CRkdUb19/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGVFcKJ1ZA7Ji6dY6Z3hnU06y7vzf1fPPxS8d/LQEoyxcwyw8sMhLBQxLl8AvtTws
	 7X0cK3dUpn8g7bv7MgmGTtMia+GNTtDK2VhSRz/4u3hm2D46oZZbYOwsu7ydDy0YhW
	 1ng7Wp2p3rBxY78/yDLL8P427tRMXnsWA9h16wpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shechenglong <shechenglong@xfusion.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 561/614] block: fix comment for op_is_zone_mgmt() to include RESET_ALL
Date: Tue, 16 Dec 2025 12:15:28 +0100
Message-ID: <20251216111421.707477642@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: shechenglong <shechenglong@xfusion.com>

[ Upstream commit 8a32282175c964eb15638e8dfe199fc13c060f67 ]

REQ_OP_ZONE_RESET_ALL is a zone management request, and op_is_zone_mgmt()
has returned true for it.

Update the comment to remove the misleading exception note so
the documentation matches the implementation.

Fixes: 12a1c9353c47 ("block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL")
Signed-off-by: shechenglong <shechenglong@xfusion.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blk_types.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 44c30183ecc34..4e2e3aed32f5f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -469,10 +469,7 @@ static inline bool op_is_discard(blk_opf_t op)
 }
 
 /*
- * Check if a bio or request operation is a zone management operation, with
- * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a special case
- * due to its different handling in the block layer and device response in
- * case of command failure.
+ * Check if a bio or request operation is a zone management operation.
  */
 static inline bool op_is_zone_mgmt(enum req_op op)
 {
-- 
2.51.0



