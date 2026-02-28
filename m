Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45A2383C68
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302033; cv=none; b=U++3Etycl13Ub+kRDWFbk2rpvmN9Pd1A3aSMHVfkZmNsyfSyJL0luYUS3VTeUQHTLEAhhEx+6mAcitOyUYDvmqcZttoq3XUBOXOXl83U04mg86F9Da1VlocvxMlSAYCDKnT74/4QBHbFR9lBYeJaaPt5sPZxUgr/OorPbuuEL4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302033; c=relaxed/simple;
	bh=vc2MXFmhwzG9O6jwkKk3BJmryInIB0popl+gqWgn6ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7kqBw+hAixcxEBS6yj7Q/ZVfmwP/KqUEffJdU+F74V6f1+5oi/eoX32ZBmWoHdFlY43Qgb3UVsyc26Kj0PL1oWrE2LZ3cLs1M207g7Pqhf3EpXITc+vYX0UxVtc+2iVlTFvd06g6GUz/7huPIZ97kwoU3HSqeCd+AGSJYvI4bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFOlCiS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFOlCiS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC6EC116D0;
	Sat, 28 Feb 2026 18:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302032;
	bh=vc2MXFmhwzG9O6jwkKk3BJmryInIB0popl+gqWgn6ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFOlCiS9IP74cTyl8FciT7SJZwExepJvbKRB8AKXrby+gb5dVcCqhD7SxoOztG6AR
	 bVh/yfAWQSFENaAknJ7aM/dhXwBUZmIOP4GGMTqFznnvr3o+1Ed7WjlRqDeUrU+Vr+
	 A42snIn0jMBs+7jiYchqe4e5nYBIWBd5eTh6FbGTdWuNGZCXiZ609uQ218Xncu3lMJ
	 BNq8lwc1wWVL1kcaQPSl/fb5uBv/5G1TWeQH89ranKPMJM5q/Za7KuO/igYpzfODpc
	 eAK/+habqC1WR6AYhafx6ygRCivwdlXB+g7vxnsdE3d40BlbdVNQ/J+kxiGu6UJZF/
	 q0l/mj8AwoNLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/283] auxdisplay: arm-charlcd: fix release_mem_region() size
Date: Sat, 28 Feb 2026 13:02:25 -0500
Message-ID: <20260228180709.1583486-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

