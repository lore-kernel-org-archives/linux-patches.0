Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018622;
	b=HHByQpsmeXXKOzeM09BJyvf8KEbYAET3rBEVFIgfyMO0zm52Akwf7u5fjXheU2CEf1Ka
	 Cibfo6KIxjMdY6B3bPngxVKSjzqMw7sAR9Iuado2Wy++BpsKUg9qVrjEPql2Iu0u9gZqH
	 SxCS6Q727O9spoZE4vII7FJnX04dMYEe4A/dx9asJQvn74ltcGXFmpj2oHdmsZUvDb3T2
	 LEQTLiuMDwkkNZhSDeXubi2anKPXeqEbfj9xNNG2VFQEKJR4ODWjBzui3LXSnPOl6fCbn
	 s2gqe9uEhpCKX/RUOOpOyvtYGDhP07Wjb1PSvbNONpAxFsKonhe8sCavmOHLLNyhJMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vrp24pzwnR8+EW5ZnSK125rlWQIyax1NoEW0tr8g34g=;
	b=JpMu0l9g7ASkbFNJeFcwuo+5axlk76CdzRGITYobm5xCsKvZArgZw3J5C5hrW6ofOTi1
	 L0MmhT3DvSq4KO+fyLnWSRK/NadtPbvPSryAy8CEXmOlRTtssovUX9zDrQZ46lwiRdjhu
	 1NMmvQPS+Xl4iyGd2oVYscRooUE7p34TybiWRHhSmtJtGfdAdxn/NUzQEPJaN8TYWsdzl
	 MQk0wh6k6SWXoZKKdRAG8uN1aWfTihUF9ZofJFs21Kj2jp2zqc11J6ZTQLeXqm9dh76to
	 gSeGANDZXu1p2dHyNwJXZta0FHR/aSJPByU8q0nQJPC31hF4jff7GHBTqDt+mV0e+Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M44dqBMz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD36606A31C;
	Wed, 18 Nov 2026 16:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M44dqBMz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392201F000D4;
	Wed, 18 Nov 2026 16:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018622;
	bh=Vrp24pzwnR8+EW5ZnSK125rlWQIyax1NoEW0tr8g34g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M44dqBMznwX4P3Ai9tByGO3Da5jyJbYtRQYogIaeqjSbbZb3iTQBtPeMxoRQbJXGT
	 JjFZdDOTWiUpwTmz/MkLv/vQIMnQKbCGRF5I58Lfebi5rA2P4zjFBLOWRM0OaGY3m+
	 LnfmboLK+ONzYvV2s0TRVIOeNKvuLNhJkRAnIC8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1264/2651] spi: bcm63xx-hsspi: Disable runtime PM on remove
Date: Wed, 18 Nov 2026 15:41:44 +0100
Message-ID: <20261118150333.474111905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 38232bd3cea74845c2064eb9f7eac77fa5a21d85 ]

bcm63xx_hsspi_probe() enables runtime PM before creating the sysfs
 group, but bcm63xx_hsspi_remove() does not perform the matching
pm_runtime_disable() after a successful probe.

The probe error paths already disable runtime PM when sysfs group
creation or controller registration fails.

Add pm_runtime_disable() to the remove path after removing the sysfs
group to balance pm_runtime_enable() from bcm63xx_hsspi_probe().

Fixes: fb8695e3749e ("spi: bcm63xx-hsspi: fix pm_runtime")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260924112329.1566051-4-lgs201920130244@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 25f169a2a81d7..80bf02bc324ae 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -882,6 +882,7 @@ static void bcm63xx_hsspi_remove(struct platform_device *pdev)
 	/* reset the hardware and block queue progress */
 	__raw_writel(0, bs->regs + HSSPI_INT_MASK_REG);
 	sysfs_remove_group(&pdev->dev.kobj, &bcm63xx_hsspi_group);
+	pm_runtime_disable(&pdev->dev);
 }
 
 static int bcm63xx_hsspi_suspend(struct device *dev)
-- 
2.53.0



