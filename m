Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216026;
	b=TuLuv4il4FQFyMaRqbAWEzsQ8jAJKkI1PabN++kue4fhmXXki6Oo4Sf8lWCXV0rqTmMm
	 ggJ7wGPTjsxHXlcuNXFCAGbFDVSZoZurqtmOyctXRRmlUDMdjiy1FNapJX9GVfD4O8uzI
	 aDkfX380mE687k41bzjiMU/AlO7/HP8IQesUNbRwku83x7+O+PHoyaYU6lSZQO+fA9e34
	 jxQegdP2ud6Zp+F+zZjsb8q+hKfQszehOsyK3k8shR1PEj/CKEr12V7gkaXq1AlWMbRtD
	 zjaPGnK1jD/7Yn/sTG8E4wrEMAeJIOse5n6Q3X7fa8qYTaAA8QE/zWf2kS6svloH5qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bYpsyfqrQVkuvt3wPybsE1CsF6zWMCU2YZrPQQ0UG3I=;
	b=SyR39M/7fwsX7GYBQo8euD8AZnGWzZRmiCv+VsXQU+JEoenYByv4xL4eJX4bhVRx5qBA
	 9orSCL5v1T2lRDNJ6MU/7dwblcA+lDknlNV6JFwvGAbo6X2mymRvKH3+G1WZ4kk2Jj6N8
	 SjpT2HsTRnC6x4lg7SUKWn4ybvyBJHxC2GgglIznkRwGbvHC9AnkdTvsJrlPaTlk2z5+t
	 pJDWEKdS+3FeCc71fqBUPp6UYzW15uiATESx9agpI2rK8UcNl0OUHU+CSyGb+1lo9pbpO
	 /P0UJHcEbWh/wwZB6xL0Ud5B8ZIQyehUeEId9oz2ViX6tLPM2PBQojL8qo3j5LJ7sAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyLen4vc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531BF606A31A;
	Wed, 28 Oct 2026 19:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyLen4vc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17411F01825;
	Wed, 28 Oct 2026 19:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216026;
	bh=bYpsyfqrQVkuvt3wPybsE1CsF6zWMCU2YZrPQQ0UG3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyLen4vch79IWxrN93stozHmi6Xo8GoCRlWFhmLwAUFURrgbjmXsFGT4cYiA6GGfm
	 pWgVlnDmmRH3eWPbhTuNKB7x+J5QqlcLnC+znIN6fyHA8kqS98j3cNCZugNSc32c4B
	 sxtnvga5t1jys8leXnnfuV5BguKvNlXH3nJNc3WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1371/1887] mfd: sm501: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:57:47 +0100
Message-ID: <20261028170530.650148657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



