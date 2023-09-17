Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12647469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5443DC43395;
	Sun, 17 Sep 2023 20:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982146;
	bh=iybyEqFG5GqjZNPLw2EebawynhD8ViRTVE5aFaq5MjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjWmptj+Oekvsz2LC9+3uDbB631+Z4mopXSBRvYO/8QfnvdEW2h95DUMKPu/3Qoeo
	 LkpR1HyCEycMxLcMM2yXMh1FZyVajctcfDdzPjJ0OdIDWWSVEdLtCBuRjbeS24MpNz
	 HUn8QWdjnCiJ2laH70/gq6l7mHy6SZHqAPFE2nyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/511] drm/tegra: dpaux: Fix incorrect return value of platform_get_irq
Date: Sun, 17 Sep 2023 21:09:53 +0200
Message-ID: <20230917191117.851256248@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 2a1ca44b654346cadfc538c4fb32eecd8daf3140 ]

When platform_get_irq fails, we should return dpaux->irq
instead of -ENXIO.

Fixes: 6b6b604215c6 ("drm/tegra: Add eDP support")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230710032355.72914-13-frank.li@vivo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dpaux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dpaux.c b/drivers/gpu/drm/tegra/dpaux.c
index 1f96e416fa082..c96c07c6458c3 100644
--- a/drivers/gpu/drm/tegra/dpaux.c
+++ b/drivers/gpu/drm/tegra/dpaux.c
@@ -468,7 +468,7 @@ static int tegra_dpaux_probe(struct platform_device *pdev)
 
 	dpaux->irq = platform_get_irq(pdev, 0);
 	if (dpaux->irq < 0)
-		return -ENXIO;
+		return dpaux->irq;
 
 	if (!pdev->dev.pm_domain) {
 		dpaux->rst = devm_reset_control_get(&pdev->dev, "dpaux");
-- 
2.40.1



