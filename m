Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6599E27453;
	Tue, 29 Apr 2025 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946881; cv=none; b=GG5doV5715gII9cJHR5sZj8mBM+WRd+LdBXDXWmsCLXqVtkoxMb4LDIHAmSP1Y/YZvybXSoHNC9ZJvN7M+OrGw7QLygItBVy4U4Ipk3AcR/ozU2L/A+F5G9c8omXDvuR9Fz1kIDz5/xUYmAQTPq3gpKENsqM1KBvttLeeDJkxHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946881; c=relaxed/simple;
	bh=+jlIpaCybw1sXJ7PnK/ZBurWCCi1SDDwIwN0avueieA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rk+tk+N4HzpsgiuYcnHMXOSklaNoDkMpCtdZjJDEC07eF42GvV7cGduzJHJLn2fxHQiK6R1y5jJ86fuSqIw2RDV9CYmEQTp+8yRpwIfPHb5hqCrNitrGFSFT3jBAkS72bKFR3fpCC4KWIzuHfj3uvO/mjYuDm488m3LSzmsEq9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9RkJvJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9RkJvJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C19C4CEE3;
	Tue, 29 Apr 2025 17:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946881;
	bh=+jlIpaCybw1sXJ7PnK/ZBurWCCi1SDDwIwN0avueieA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9RkJvJRRIyLPlpYQeBTRBPjPriVrMDJaNRsFtC8WoCiZhP4I1xdHWe0iXuKRIXui
	 XmsnnmCg3IuZMCmCiqdcl39R/r9ItSTtqS4lyFtsc7DW1FQ/LDEuv9tCIRjFHSIYSF
	 mL660vzWC4Pf90AnHiSh9hr1BabjrUQNYXWCvZHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 069/286] mtd: Replace kcalloc() with devm_kcalloc()
Date: Tue, 29 Apr 2025 18:39:33 +0200
Message-ID: <20250429161110.690032896@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 1b61a59876f0eafc19b23007c522ee407f55dbec upstream.

Replace kcalloc() with devm_kcalloc() to prevent memory leaks in case of
errors.

Fixes: 78c08247b9d3 ("mtd: Support kmsg dumper based on pstore/blk")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdpstore.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/mtd/mtdpstore.c
+++ b/drivers/mtd/mtdpstore.c
@@ -417,11 +417,11 @@ static void mtdpstore_notify_add(struct
 	}
 
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, info->kmsg_size));
-	cxt->rmmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
-	cxt->usedmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
+	cxt->rmmap = devm_kcalloc(&mtd->dev, longcnt, sizeof(long), GFP_KERNEL);
+	cxt->usedmap = devm_kcalloc(&mtd->dev, longcnt, sizeof(long), GFP_KERNEL);
 
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, mtd->erasesize));
-	cxt->badmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
+	cxt->badmap = devm_kcalloc(&mtd->dev, longcnt, sizeof(long), GFP_KERNEL);
 
 	cxt->dev.total_size = mtd->size;
 	/* just support dmesg right now */
@@ -527,9 +527,6 @@ static void mtdpstore_notify_remove(stru
 	mtdpstore_flush_removed(cxt);
 
 	unregister_pstore_device(&cxt->dev);
-	kfree(cxt->badmap);
-	kfree(cxt->usedmap);
-	kfree(cxt->rmmap);
 	cxt->mtd = NULL;
 	cxt->index = -1;
 }


