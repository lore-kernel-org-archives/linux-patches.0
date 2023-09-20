Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0378C30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79646C433C7;
	Wed, 20 Sep 2023 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212972;
	bh=jqUf5PhogO+Vj80Rp6nomTq8AS8Xbhw3mu8IEu12oew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qo4rdeLTiW8sZyDAQhAUxZbErDByVpmNOlxkCXbNOic3Up9oHdE9w+SYQbSoIpUux
	 Lz4zq+0afxkExX9E/jNttnZZHaOs5fjmSc2tb1hxRV+VnHa/tOLrHvw+Q6W13sPZ0/
	 v+ArbR5VpS3EH5Hmjwmt+0zCKsvHUqjHSrpOBLVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan Zhongjun <tanzhongjun@yulong.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/367] drm/tegra: Remove superfluous error messages around platform_get_irq()
Date: Wed, 20 Sep 2023 13:28:10 +0200
Message-ID: <20230920112901.537502295@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tan Zhongjun <tanzhongjun@yulong.com>

[ Upstream commit d12919bb5da571ec50588ef97683d37e36dc2de5 ]

The platform_get_irq() prints error message telling that interrupt is
missing,hence there is no need to duplicated that message in the
drivers.

Signed-off-by: Tan Zhongjun <tanzhongjun@yulong.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Stable-dep-of: 2a1ca44b6543 ("drm/tegra: dpaux: Fix incorrect return value of platform_get_irq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dpaux.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dpaux.c b/drivers/gpu/drm/tegra/dpaux.c
index a0f6f9b0d2585..304434bf10814 100644
--- a/drivers/gpu/drm/tegra/dpaux.c
+++ b/drivers/gpu/drm/tegra/dpaux.c
@@ -447,10 +447,8 @@ static int tegra_dpaux_probe(struct platform_device *pdev)
 		return PTR_ERR(dpaux->regs);
 
 	dpaux->irq = platform_get_irq(pdev, 0);
-	if (dpaux->irq < 0) {
-		dev_err(&pdev->dev, "failed to get IRQ\n");
+	if (dpaux->irq < 0)
 		return -ENXIO;
-	}
 
 	if (!pdev->dev.pm_domain) {
 		dpaux->rst = devm_reset_control_get(&pdev->dev, "dpaux");
-- 
2.40.1



