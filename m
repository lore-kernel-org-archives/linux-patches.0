Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063983;
	b=mcoo3xMwZCwUg0ME0fNy4mQlc7wNyLM/PMrNXvgGDwW7kUm+tW8NprHsF5IrlF3qpXHP
	 CyQOj+TrZKdUt1dvZk+XZsvoDdj//70yGeGT11pMesr/zGbyj59ZIAVUpsQMmnj0wJ2zU
	 hZ0d9ElASk9SePI04IrDKnURCQW4KteWdWT7tsZokJJlYefBxDZs5qFP2sjdwizHGHk13
	 mEp8f81E66L/mNmQuPJJqjxiDdwWgP9hGKBIDe4fyXqXUGZ1f+EdnTli4CQuTvr413IX3
	 QGSlP7GXsTBaMwS3WiXonKWDzC49Dzzy01xin/Pr3pbHzn5w9WuLrvnxg9kY/Adb5Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Chaa0ahCO0dCq1+FamEr6fh6gDxkMyv8s7TLD4e9bWE=;
	b=TsVadrg0p1t4twlSMZoVRNvMtury96khkMAsQqFaHVgw5EWI3tVulbybyqSP+4pB9T2k
	 RdZIXgK7nRzyppzUClkyHuIVirvd3Pp8gs2Cznm47/4EoV9eELoTR973Pr31a/yLpczKd
	 MqXx92XSkVpZ5VkzOus1rdFl7H4OHgC4mJng+G0KvDexTH6K7IFIhqchQcCWedYjNC6zW
	 sZzEVQhlsXMu2rQIoaldOzIVVSdwDyeOMuMhamyMjLH2SdWzPL21CejQAofeo+X7XqqGG
	 1ebCQU8BRNCwkfgkhAdWaTLiL4dAUujLePaV/41IZ1Wyo07q+5qz/Q1eNzTVZntv+lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNr+5jrw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084F660A260A;
	Sat,  7 Nov 2026 15:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNr+5jrw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA3F1F008A2;
	Sat,  7 Nov 2026 15:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063982;
	bh=Chaa0ahCO0dCq1+FamEr6fh6gDxkMyv8s7TLD4e9bWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNr+5jrwM1Pw/wnubxniAXBh5jiMqEp3vlZx+OLJxT2HjjWwN4LtDKVc91dbWN2Om
	 HZ5fHtfsU3NXzm9GjpTktiWIP0buKJkvX0JhzyUFTZ9MqMLCAg/L70HfpW9pNNNSra
	 nNyaTSRapnr6/Tc7buo5dRJL/7hIjIl7a7RNaVl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0129/1257] hte: tegra194-test: shut down timer before GPIO release
Date: Sat,  7 Nov 2026 08:40:25 -0500
Message-ID: <20261107134942.884623371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 30167fadbf87fa901a2fee49c30a5c5a506a43e8 ]

tegra_hte_test_remove() releases GPIO descriptors before stopping
hte.timer. gpio_timer_cb() accesses hte.gpio_out and rearms the timer, so
a callback concurrent with remove can use a released descriptor and rearm
after teardown.

Shut down the timer before releasing the GPIO descriptors.
timer_shutdown_sync() waits for a running callback and prevents it from
being rearmed.

Fixes: 9a75a7cd03c9 ("hte: Add Tegra HTE test driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hte/hte-tegra194-test.c b/drivers/hte/hte-tegra194-test.c
index 32907d951ec9a..cca33868fb03d 100644
--- a/drivers/hte/hte-tegra194-test.c
+++ b/drivers/hte/hte-tegra194-test.c
@@ -217,10 +217,10 @@ static void tegra_hte_test_remove(struct platform_device *pdev)
 {
 	(void)pdev;
 
+	timer_shutdown_sync(&hte.timer);
 	free_irq(hte.gpio_in_irq, &hte);
 	gpiod_put(hte.gpio_in);
 	gpiod_put(hte.gpio_out);
-	timer_delete_sync(&hte.timer);
 }
 
 static struct platform_driver tegra_hte_test_driver = {
-- 
2.53.0



