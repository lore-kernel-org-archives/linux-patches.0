Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2365340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301048; cv=none; b=LcO05sGSnizT+fAg+BirqWk52Na6xD6Jf6gpHduM9Br/P7n5ovPfStDKdEmDH3iApCZ5d1Pu2dLUIRl3xikTleTljWGMVdMHiyK/iw7v/kFgoUo2KkZF+KFW/1oKir0KSFWRtZwm+SsE1Z4qxH3xjzGVDp2AhCOssfpZfCfXIZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301048; c=relaxed/simple;
	bh=QBh4SxHLt1xI6PMRW4JLJQxEAh+26aoB97GHXl5dVXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyNAtWe1eXie0o1OCctBHapU7NWVJJPSZV2OKO/e05P54djBzrxTPsh3tusTyp3LEkODha+ZhO03eZEaXxLBZAwETLzXle3ZmJ82cjTmjTqPHEyY/hBJwMpT30W5aM/PGdoEsCR08v+XTTqDbavFE19chPOMM9yPUvlUrLRNgho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uIhiY3ji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uIhiY3ji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D76CC2BC87;
	Sat, 28 Feb 2026 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301048;
	bh=QBh4SxHLt1xI6PMRW4JLJQxEAh+26aoB97GHXl5dVXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIhiY3jiD0WkeA7ZjKuwbqE7xVcjtG7XEdJjFXSipCO0t3RPp29YIPng5TGVXCrCz
	 dgzllW1YpKaXAt+EOYb86xvAUYKnHY9w97JiXjb6K8cDW5XLKHWTGBextr5riJ/iuq
	 CPu+qjNaDAXhXGYGdmnGAXjIAW2ew/hMn5agx4AqKryd5qtsANM6EWHcGjI4NB6jTg
	 dpEWpL2yMfSGCBB+OeTynFBdza9CdwNvFC3Li3NPhD2T/5kRYd+JZm3E7TlXaioNU/
	 b2hrBGZDjCdp4UGIgsg8biyEpGhOkkvOnFQEKQ4ZawT6wwBZGx+hWHidnxCwIrihoM
	 ztWXb/fWPeUsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/752] ASoC: sunxi: sun50i-dmic: Add missing check for devm_regmap_init_mmio
Date: Sat, 28 Feb 2026 12:38:19 -0500
Message-ID: <20260228174750.1542406-188-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 74823db9ba2e13f3ec007b354759b3d8125e462c ]

Add check for the return value of devm_regmap_init_mmio() and return the
error if it fails in order to catch the error.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260127033250.2044608-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun50i-dmic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sunxi/sun50i-dmic.c b/sound/soc/sunxi/sun50i-dmic.c
index bab1e29c99887..eddfebe166169 100644
--- a/sound/soc/sunxi/sun50i-dmic.c
+++ b/sound/soc/sunxi/sun50i-dmic.c
@@ -358,6 +358,9 @@ static int sun50i_dmic_probe(struct platform_device *pdev)
 
 	host->regmap = devm_regmap_init_mmio(&pdev->dev, base,
 					     &sun50i_dmic_regmap_config);
+	if (IS_ERR(host->regmap))
+		return dev_err_probe(&pdev->dev, PTR_ERR(host->regmap),
+				     "failed to initialise regmap\n");
 
 	/* Clocks */
 	host->bus_clk = devm_clk_get(&pdev->dev, "bus");
-- 
2.51.0

