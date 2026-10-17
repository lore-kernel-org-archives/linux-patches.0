Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE1F39EF2C;
	Sat, 17 Oct 2026 17:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259578; cv=none; b=nAlL9fof5k0Tnb+g826sVaFa4A6fqlfJFdUYIB7ZTN0gKwG9cdT/bi/w6Huwg1Mbv2ScQsKg7QZvmslo9UCn1lLFGb/+dxz4rS05hgoK463FaSXwShYjAhVS2cFdMZblgUVvjRc4ucxhouKongUiHe/10loljh+YD1RyCwmdtTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259578; c=relaxed/simple;
	bh=JdWsLjAtycmh+aAd+NHITgYSEe2FrTazdXk5hCZJK4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mbRuNZg6KLUxBRRE3QYfvtt+pVwgeIHnA6pFpOq8PxoRQzIQ8T8ufYEJfA6qWEu/Pil3JnyIVvMurVpPkBfsyJJxOpu4WUweq0ywWYGHEfpmdyLX6JGQDs4034DmkWHXcRxVsBp7+147G7Vdc1e27JOIDGsxs/ax/sFghrHEFLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gxt5GnG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gxt5GnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6EB1F000C4;
	Sat, 17 Oct 2026 17:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259577;
	bh=mpeVI54P0MnKj1vCAWTlb93Xl212x4ZthbwtvnzDrz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gxt5GnGuE46oh/HyheRxa8+IrNx+7VUJbmrpJ+jrSOWlZI887Go2AeKNuQRazLwT
	 4Yasf5tHSofGkjy3M44Cb35j+QG0X89X5aUnLU2LUAnldaAihtSdP5ziyvgf84q8Cg
	 O9tpRU6+KSXEz1uQQwHV4cwK7YWW3YD6Hkd09Spw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1260/1674] mfd: sm501: Convert to platform remove callback returning void
Date: Sat, 17 Oct 2026 17:58:52 +0200
Message-ID: <20261017160503.483809905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c20fddf7acfb54d856c34208926701d32c25eb18 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231123165627.492259-15-u.kleine-koenig@pengutronix.de
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 83feedd9d83c ("mfd: sm501: Fix potential memory leaks during remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/sm501.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 1865621d62f27..06e796883189e 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1669,7 +1669,7 @@ static void sm501_pci_remove(struct pci_dev *dev)
 	pci_disable_device(dev);
 }
 
-static int sm501_plat_remove(struct platform_device *dev)
+static void sm501_plat_remove(struct platform_device *dev)
 {
 	struct sm501_devdata *sm = platform_get_drvdata(dev);
 
@@ -1677,8 +1677,6 @@ static int sm501_plat_remove(struct platform_device *dev)
 	iounmap(sm->regs);
 
 	release_mem_region(sm->io_res->start, 0x100);
-
-	return 0;
 }
 
 static const struct pci_device_id sm501_pci_tbl[] = {
@@ -1709,7 +1707,7 @@ static struct platform_driver sm501_plat_driver = {
 		.of_match_table = of_sm501_match_tbl,
 	},
 	.probe		= sm501_plat_probe,
-	.remove		= sm501_plat_remove,
+	.remove_new	= sm501_plat_remove,
 	.suspend	= pm_sleep_ptr(sm501_plat_suspend),
 	.resume		= pm_sleep_ptr(sm501_plat_resume),
 };
-- 
2.53.0



