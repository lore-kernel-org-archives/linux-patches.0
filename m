Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AB53A2AE6
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302659; cv=none; b=raYyVoWVi0b7Va3XZ4SF55NwikWWt3ICXAI3oobKpsnQH/0vGB9Cbcx2BdrZj9cNpPpLqCOT7Mkaj96/NqS1HiAhdZkvaYYSo0FyVR6IUrBKku+cEaYS8gY9/oS5kQgkZid55aumC1Dq9MsSzDC1eBp1g+va0SULyIUGasu34Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302659; c=relaxed/simple;
	bh=vc2MXFmhwzG9O6jwkKk3BJmryInIB0popl+gqWgn6ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLlw130y15YvGD5F/Hj4wqg6vl7PdiLf/Pd9M5B6LH7NJuKQyExiKja9QVy8nIshz8P6e8L8OXYtkUY9h38ARXnfioMbn2hH25ylVzazGa96iYB4Xc1wsK3r7CLhiHKkRLjzgz472chm8XfJaE0PRJA6ZWQ2cV4EAhC1uJSUMyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LGD0s+Rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGD0s+Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D66C4AF09;
	Sat, 28 Feb 2026 18:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302659;
	bh=vc2MXFmhwzG9O6jwkKk3BJmryInIB0popl+gqWgn6ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGD0s+Rh+UU6Tk29ueC21HNPu/07WVPrV3cTjgMg1adiX2jwm8U0ZPZTGgewgyMOm
	 5gORrzW/UnENNg/InH40wto+xV7rpTO9ckFqMAp1oLAZ1VvyiBWkAX0pBAP1aks1Dw
	 7u3ZNmAMKbe9lHePNVSbhIX85UOttpjAcAvasrrlEiHhtvtq8vAHlrplTipplB6G4X
	 lN1Ic8c3HOYTsmqk9vwJO0G61vU+B2BLi5TY2jlsH5U63AsKvlsd/utzNwIb3J1LOx
	 p7yeBz/hrZj1z9mSLygrH3rvkqjoFgHEg4cgvzKbwaOgdhnUAElt4XgRTl9TgDfZHQ
	 GQrmDRTnSThnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/147] auxdisplay: arm-charlcd: fix release_mem_region() size
Date: Sat, 28 Feb 2026 13:15:11 -0500
Message-ID: <20260228181736.1605592-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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

