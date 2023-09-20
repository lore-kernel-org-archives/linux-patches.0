Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15FC2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C01C433C9;
	Wed, 20 Sep 2023 12:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211955;
	bh=Y00IBHvA36RSKTkB1MMb09J/+5YPlpXUHZzM26Snco8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFb2ebJNJGeFhPFcfKZYhxPjbyA/smd4sGcrGbtO5jj29Ue4xZWIjYf3XQFmXSYE0
	 XWUn8b+3eBAw7a4NHLu8mzIMuBxM0JNowEEkza+D1iS5N6ZuvIWU0HBMecp1/LEMZW
	 oqi0HyZPh0wyAolm7VtzcdxiwuHrcv4iIraeurVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/273] drm/tegra: dpaux: Fix incorrect return value of platform_get_irq
Date: Wed, 20 Sep 2023 13:28:58 +0200
Message-ID: <20230920112849.470640440@linuxfoundation.org>
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
index bed9efe36a1eb..7d9be2f56ab1e 100644
--- a/drivers/gpu/drm/tegra/dpaux.c
+++ b/drivers/gpu/drm/tegra/dpaux.c
@@ -450,7 +450,7 @@ static int tegra_dpaux_probe(struct platform_device *pdev)
 
 	dpaux->irq = platform_get_irq(pdev, 0);
 	if (dpaux->irq < 0)
-		return -ENXIO;
+		return dpaux->irq;
 
 	if (!pdev->dev.pm_domain) {
 		dpaux->rst = devm_reset_control_get(&pdev->dev, "dpaux");
-- 
2.40.1



