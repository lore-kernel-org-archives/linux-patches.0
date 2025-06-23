Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37703239E63;
	Mon, 23 Jun 2025 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685042; cv=none; b=DaZENQWZ+JisYDowcWQZNQ/pOVMpnkpyb5jfNMX3XvSnyJNQmYFPfoEgFvU/GYXblKeRzrUy0l3AsWXSKdyfI7Yqv3SKspce3FC41+UxrQpOZp1OBB2UrB+lGvyD0N49g6v5I2xi1tI03oYbglw+4oYnqJ27EtjvJmIKJyKtQWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685042; c=relaxed/simple;
	bh=AScLikdxe+f5beaBX3Gg/aFr5xDnSkDoEis/Y3Ywg+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMUr12I19lSiXDXc243rcWxYwQYbPdAUndxi9TVnYs4KOX6ezvX58NfGIIIL3YEWK8/CuoO2rQcFHJoSFB8jxcYMGAFIuSTB+Y76KOC9pFAs3R6s3oWiz+aQRDBT1HppyaISMVDHGtupzGRqBQ4E57ueR6JRQyJtFyyr0fFMnao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0VrvwGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0VrvwGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DC0C4CEF0;
	Mon, 23 Jun 2025 13:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685041;
	bh=AScLikdxe+f5beaBX3Gg/aFr5xDnSkDoEis/Y3Ywg+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0VrvwGExWl8UHNrh54Ckp4hviYLvggGWwM6VjkqYrlZd72dTYPrM3a8RYKDF1X9W
	 4vKAZto1hWKk4vTlBtuV5b06G5xc1nKWhaN30Z52+gUq5w1sXPdTOGnZOWG1n4oCpG
	 xs1ni9d94DYWUkVPGGt+pS+dQWCg/Ma1I4KLuKWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 228/592] ASoC: tegra210_ahub: Add check to of_device_get_match_data()
Date: Mon, 23 Jun 2025 15:03:06 +0200
Message-ID: <20250623130705.714286662@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 04cb269c204398763a620d426cbee43064854000 ]

In tegra_ahub_probe(), check the result of function
of_device_get_match_data(), return an error code in case it fails.

Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://patch.msgid.link/20250513123744.3041724-1-ruc_gongyuanjun@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_ahub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/tegra/tegra210_ahub.c b/sound/soc/tegra/tegra210_ahub.c
index 99683f292b5d8..ae4965a9f7649 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -1359,6 +1359,8 @@ static int tegra_ahub_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ahub->soc_data = of_device_get_match_data(&pdev->dev);
+	if (!ahub->soc_data)
+		return -ENODEV;
 
 	platform_set_drvdata(pdev, ahub);
 
-- 
2.39.5



