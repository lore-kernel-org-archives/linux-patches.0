Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D0516D9BF;
	Mon, 23 Jun 2025 22:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717224; cv=none; b=d0JRpxbFGv9tIQE7nOaai7hCg07FxiUuFWuvonsfL+LMD1hjKeBerH3KI2K6QtGPcJnEI0WlVtiGW7UdLA2tonREfDgucrmWKAURaneKRtcvjT6R36eF+28egRzugrkMxLjwuT7CNNX5/uxmDsQnl6/aXTXJUwzD8DIQDG2Dh4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717224; c=relaxed/simple;
	bh=HtUUt892CiB2mT22u5AOyURCOMUs49c8k5IQB8KysAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dImbi4n7m2B97/uMLD9Wua8ZhebdjxFp8AmRd3Cd3JxtR9DZVQVnJ3BjuGUI78tq9FHLYMu4anKL7cxHkNKTYRDP5KrxP0ImNW5MseSY7u8dVY7tTDZDNeMHzjldsuda12OY6AtGnflcSwkkDhn2F6aNC6iZ8N9sGM8KZQQJWlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsP5z9Vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsP5z9Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070DFC4CEEA;
	Mon, 23 Jun 2025 22:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717224;
	bh=HtUUt892CiB2mT22u5AOyURCOMUs49c8k5IQB8KysAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsP5z9Vn2lCnFvMxvZj4VZ+ppoGLbaThMgNPV60b2OyxAYXwhJ47GaqSog9in9ugY
	 ItI+NGJGFzpGtgAO3O+pbzUZRx5jQZR4wjlCjNUPhETTlKI33iD7qn01AmgruLIJ4R
	 JGocL26jb3gYdo1e5Bf2tySYJCkZcuUYzOEyU2lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 384/508] ASoC: tegra210_ahub: Add check to of_device_get_match_data()
Date: Mon, 23 Jun 2025 15:07:09 +0200
Message-ID: <20250623130654.745139464@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dfdcb4580cd75..4be5683504154 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -1369,6 +1369,8 @@ static int tegra_ahub_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ahub->soc_data = of_device_get_match_data(&pdev->dev);
+	if (!ahub->soc_data)
+		return -ENODEV;
 
 	platform_set_drvdata(pdev, ahub);
 
-- 
2.39.5



