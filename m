Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2193375AA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301614; cv=none; b=sxtLCmpmnSKuiL1KYZH84BMdnzk/ZzCBf05Ta+OU1PP0E6epH6pWenNJzjf9ltOesUWTLL0//z4uzTtYfJMu3aYlC18WQVwsX2c8NCCRZp1uMAO/7SXUmVWsvFFpcO0Ru8fNOaVCcJNDDx1l5Jmlfft0Uk2ba/AcplvGjbDUi7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301614; c=relaxed/simple;
	bh=Rz59efExZhiQTMHinvZSUFwo6eIDvGxTTSBMHBtMupw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=netctCK56pi6jVMsa4ybTh7+x2LOs2IKq80JvRC79QvwvjAFWObkT201Ra3JWwgaBlk90XZxto8tKw9XK2zTmPRma7GCxTvOv5iQoM23iypXd9o8RfWj7M88RrMeYi1jEaKytVatt5VAeSU0lzuo2I1nuEBxci+WpkMSubJaSXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tD+mkOy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tD+mkOy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB79C116D0;
	Sat, 28 Feb 2026 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301614;
	bh=Rz59efExZhiQTMHinvZSUFwo6eIDvGxTTSBMHBtMupw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tD+mkOy1YYL5VdYMBNI2OvlXoj+wnqISZs1jrkbK5Xh8tXkPSIvUnuN74F72FBEc3
	 /eF8xVYHgEQd9x+pwTbBu546IpDM7KidFCCaMMxS8IouapSubhOP4GEsm0bDsDLEHz
	 Huor79D65nNFDuT7BBesr2Ckzv4sj5YWeISZHrC9FkuXWBFjLhhyYeoG0DGoJ74SFI
	 jF0+xTkGa8cmCYaGPgBOTKvz6Uom+al/rYWovFHS3CD38842pKK0VpI/lcVbQu81BW
	 V4pu9/12f9LLj4AEOFSGx5nUVkfpY+U0U9vUjeHegXNTzqTEuCE49bMFZDSqvdyTdR
	 a16rrq+FfxBhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/385] auxdisplay: arm-charlcd: fix release_mem_region() size
Date: Sat, 28 Feb 2026 12:53:45 -0500
Message-ID: <20260228180011.1568201-3-sashal@kernel.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit b5c23a4d291d2ac1dfdd574a68a3a68c8da3069e ]

It seems like, after the request_mem_region(), the corresponding
release_mem_region() must take the same size. This was done
in (now removed due to previous refactoring) charlcd_remove()
but not in the error path in charlcd_probe().

Fixes: ce8962455e90 ("ARM: 6214/2: driver for the character LCD found in ARM refdesigns")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/arm-charlcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/auxdisplay/arm-charlcd.c b/drivers/auxdisplay/arm-charlcd.c
index a7eae99a48f77..4e22882f57c9c 100644
--- a/drivers/auxdisplay/arm-charlcd.c
+++ b/drivers/auxdisplay/arm-charlcd.c
@@ -323,7 +323,7 @@ static int __init charlcd_probe(struct platform_device *pdev)
 out_no_irq:
 	iounmap(lcd->virtbase);
 out_no_memregion:
-	release_mem_region(lcd->phybase, SZ_4K);
+	release_mem_region(lcd->phybase, lcd->physize);
 out_no_resource:
 	kfree(lcd);
 	return ret;
-- 
2.51.0

