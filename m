Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33E439B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302509; cv=none; b=iXRyJmGFECBVsJiG2poQ+4AjnRqWe0c4AHZkCNo27mcj7Sx/UJqJx8JomuEX289HZfQaw8PuMcZVbv6HaEs2ju6tMU72yPKMccEE9tE2LelM/A4vu802Z93ENuCEbS5yxZYXY81v0Eb5Nsq0x0zhyM/ubgIgN96q3i0lAZ4aE9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302509; c=relaxed/simple;
	bh=vc2MXFmhwzG9O6jwkKk3BJmryInIB0popl+gqWgn6ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlNhOJ9pgLaVbscQ0vnhSYT7ZHiBNVelxh3uKreQHxbrnpagfN/nQAHsaIIqTg63H7AgyiGzTLHI3vj++RkOmbjcQzx683qH45yxlHigkoj9cgf+s24AlQSRld6wMXDTyw1/Ga520w0WGAu09Rz8pWqfH40ih/aSa3gHZ+sOhqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6siIRjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6siIRjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD45C19424;
	Sat, 28 Feb 2026 18:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302508;
	bh=vc2MXFmhwzG9O6jwkKk3BJmryInIB0popl+gqWgn6ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6siIRjtPwIVAZSIva2efJE4KAezFPoawmJBXqBLa4QR2a2HTYCni5/A7FdzhzyzW
	 C2nxp6Q0M7gd0rhpentx5Wlfum3pYfKtJu4+bjod0r4HcDw4A1890tEMa4XHvxAK34
	 +ZniuTXVUmkYYze8eeU99J3hpKGef2IOjS0Zo9IQGCG2XhGJQ+aoppKGxJ2uonZGfR
	 QAy3BWbBwPRpGZx2c5RVV6an8fL7j8G2t1Az3T0fjCoMw4KVeHY+UKZXdEoRunXWAz
	 qeGadSr9TFd1gFOSe643y1UHrQ5YwWxyG+NGCUDGynl0dotV3VH0G1RdJKaMDD+n+R
	 dTR5n121w6DAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/164] auxdisplay: arm-charlcd: fix release_mem_region() size
Date: Sat, 28 Feb 2026 13:12:22 -0500
Message-ID: <20260228181505.1600663-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 0b1c99cca7334..f418b133ee752 100644
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

