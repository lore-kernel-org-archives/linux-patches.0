Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50832E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E9DC433CA;
	Wed, 20 Sep 2023 12:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212036;
	bh=anxcBiLWjIZmSTq11QkjBl0wM39cUk70UkvpJ5m75kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GO9WPFkMZ1OE6FznVokikt7Z8PdyKRmtxjfBsJpf5IebAY8x7z5nXYegPujzzCr3L
	 qzjyyzog73TVE30ik33JffHndyC/63/hxoeySe+Z71+4vZUox2Yr5MUggOdD+6gtr6
	 SN36DIJSPpFRgFhzyLh745GUF5UH+/hXnOqy31HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan Zhongjun <tanzhongjun@yulong.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/273] drm/tegra: Remove superfluous error messages around platform_get_irq()
Date: Wed, 20 Sep 2023 13:28:57 +0200
Message-ID: <20230920112849.439892305@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d84e81ff36ad0..bed9efe36a1eb 100644
--- a/drivers/gpu/drm/tegra/dpaux.c
+++ b/drivers/gpu/drm/tegra/dpaux.c
@@ -449,10 +449,8 @@ static int tegra_dpaux_probe(struct platform_device *pdev)
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



