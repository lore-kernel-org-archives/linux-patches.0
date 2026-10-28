Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213309;
	b=mgNj4YCLphbAbbcGcJZNpWrLO2+Bwv7PTjOOkJxe6T8OO3zbJdSl2a0oSnMEFtnnZkco
	 RjwheXHqGJvnfA/OJLKn2//iUu9oczx6Rv0T6VLgldMnsUz/1Pl/1BPL6l9s9lURLlPTV
	 sZl+RuHhAulZBxW/6QwJsHQEwGU3WAFvu14HEoJCd8tWKoE5oxcTeiZtZiBcMwqi5b2Q8
	 Sth1TVGrLg9USG5QSLR1gQuJW9eSJaJk5U3khnVG4nVsBLbkJwMquqiHVBuL5CCDXAecg
	 mcNmydy8XJoyX4XQyCo/SAzWiKWMXoiJ4sxu5VTffyKAPh53W/RdQzo2KB34nIdg2ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+/dZG6aNQah1jsoTqTacENa/mkH/enOl7fs2X0fNAyg=;
	b=jwAyKlVDUwA2j9ZZub44pNkxJN2P0sYD4zy5CQsClY+vX3tPGghFywmnTdkFxxjIJbEB
	 2K43q4pvs9HknwnSCcnK6tUfeYK2HTp0fTarhGEDv32hB6Hq4d2e4O0rAtPxEGbLxh7Nx
	 1NeqKl0pAiK6/UB1FNpVgTciUinUEanyjDOkuSQajPqlPZG6u9D8gmHrUUZkmWKfpUiI9
	 Ab3IF5MzzQJbdwgv8BNh74cfgue6EyxmWMyTdwHZj44LG5Uy7o+Pb+fqGucx/0pViQyCt
	 omkvx3lrY0qTSLqStk4WijvZfR17/rioYbHrZ5sJj6AaW+FiwhAjIp2dhkCQgm1DCYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A/P/xyER";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96E8606A31C;
	Wed, 28 Oct 2026 18:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A/P/xyER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001DB1F01825;
	Wed, 28 Oct 2026 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213308;
	bh=+/dZG6aNQah1jsoTqTacENa/mkH/enOl7fs2X0fNAyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/P/xyERedOg2vedvUBFfI04bT7V1dH0upCubbYPLFp+rPZsjZ0SIOvWC3fzKuxD6
	 N67CNs7CMsheOpxy5Zqp6c8rmBUustsXgn72y0DLJmEJ26WgRqMRNLuOC3k+oZIvZh
	 YA09PNWs0GSU9o4WACBFBCeEE7Xw3tNK4UL/Ramo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 0460/1887] mmc: sdhci-sprd: disable runtime PM on remove
Date: Wed, 28 Oct 2026 17:42:36 +0100
Message-ID: <20261028170509.700918434@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit e1c6c10a6a70a69e29b04fcc1ebe4b9bcbc7a49a upstream.

sdhci_sprd_probe() enables runtime PM, while sdhci_sprd_remove() does
not perform the corresponding runtime PM cleanup.

The probe failure path disables runtime PM before disabling the clocks,
but the normal remove path directly disables clocks that are also
managed by the runtime PM callbacks. If the device is runtime
suspended, those clocks may already be disabled.

Resume the device before removal, disable runtime PM and drop the
temporary runtime PM reference before disabling the clocks.

This issue was found by manual code inspection.

Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-sprd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -756,6 +756,10 @@ static int sdhci_sprd_remove(struct plat
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_sprd_host *sprd_host = TO_SPRD_HOST(host);
 
+	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+
 	sdhci_remove_host(host, 0);
 
 	clk_disable_unprepare(sprd_host->clk_sdio);


