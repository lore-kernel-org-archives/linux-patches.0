Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025357;
	b=ncQdUU+joYAJ4jrlN3ZYlfSsiaR5UXYIdAf9k4Vi/z6gwiSyYFr3AODrYh0d2/Nls7Q6
	 sY8g+IBJjJfL1keMVO7o/Qt1pbeWN7YTNehuyeOuq+FkICDA13HsAHHbZ/AZx5cfElYMr
	 4Z/qg2q3VB4KcvdMVHLEjdUlgyQR/Bwk8hVc/08VoFmrtdzdW3h+ONRrIdL3V1APNIG6K
	 +NTb3Zms4tCt8nmfHY79FA00jE7Ulyo29vycTzZfTMrLWaf0+Ad4H8cXzeQ+Nj9iraxYG
	 cOz3pHUCgVe1lvcxd3jnWo6z+WwP5yJRln4qv8sChy95DtdqAIaD/q3jaigqzEbv7Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9hqB36xrOxqgGETc4wOeGuIdAbIrmtZDME0mLUfWPNo=;
	b=WEMaWXiqSIRT20CLkErmFh2QOfrlPX2if5uf6BnOFIz245geC6Dv+1GqfwfZUz/v52mf
	 gv2k/4q50r9vfyCZCbta81vh+lwyR0fCWcgS7ptQGYroi3Pl+5+lyD+o7a8uBPxlcdf8O
	 QgHVG4PaNhMPHrmMD+vJ12Mvt+vAH3a7KH1kxGx6ylkVfm7gPRAY4jJlU8xGxOP43D7PE
	 dDQDhC/OvJLULi5HIzZr3xH8Fiu+Q/RnVLuGvM2g0ZXv41UILmoVSCOLqnSpoay1oIIpq
	 97EywS50Wswy26MW3Vr8sCYHB6jyy1rAC4n/z5GBY44N/Aw4lYsGAy8l+YC1ME0h4iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dP72F8rO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C657560A2603;
	Wed, 18 Nov 2026 18:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dP72F8rO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA991F000C4;
	Wed, 18 Nov 2026 18:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025357;
	bh=9hqB36xrOxqgGETc4wOeGuIdAbIrmtZDME0mLUfWPNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dP72F8rObeWemridDLVlZPiA63x06LZkxqgLCk5r7Dq0PeVpi2gE9g2OiPXRuhc4n
	 /iqZcalt8z7vQ93SB1dNlK07UZFBm4qUISrCyJSWuSDYeOiGtxXaLEMQWk1mGZ8kKk
	 rDQi+Fe2PiB7aGd9mLO2CLmB5QlsooPnfyGMSWMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1050/2151] spi: bcm63xx-hsspi: Disable runtime PM on remove
Date: Wed, 18 Nov 2026 15:46:25 +0100
Message-ID: <20261118150200.566048653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 719f0dfd96c96..34bbce21a62a0 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -888,6 +888,7 @@ static void bcm63xx_hsspi_remove(struct platform_device *pdev)
 	clk_disable_unprepare(bs->pll_clk);
 	clk_disable_unprepare(bs->clk);
 	sysfs_remove_group(&pdev->dev.kobj, &bcm63xx_hsspi_group);
+	pm_runtime_disable(&pdev->dev);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.53.0



