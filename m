Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8180F140796;
	Tue, 23 Jan 2024 01:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972053; cv=none; b=ljGnQyc3kJ6/D/5YQSpvEwHUUk8JImCG9eljqHKSLABLU/OkZy3ZDk2sTkawBazZDCdjSKJcSNAfoQnZVzmLHmEHuU74l/OeQyCWfm7VnlGQ4G1r/M9bZP995QSZznypM6+iqI6t4TaWoGntB+6Z1i5/+twGzShJSApHMSN2LNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972053; c=relaxed/simple;
	bh=9aNwJjKAv6AQK96wNJym8C5Vj89U3kYfpYkCyqB6oQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jrh2aSog3DGunpTvx4+0kTmIg07ojx4783MeaOxprhQk5mqRuWv7z5C2+Hui8X4YemLpa7c+MCI/hvk2IF6qK4rAcW22O6koe4X1q/1bhZu5VZ7SCUMEyBw7+MuE9x5fMKxtWHhJLLPzkRXSsEOLJu+tu4gsueY1uwegJD2Sdb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqjcqExX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqjcqExX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3879CC433C7;
	Tue, 23 Jan 2024 01:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972053;
	bh=9aNwJjKAv6AQK96wNJym8C5Vj89U3kYfpYkCyqB6oQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqjcqExXptiFpxMQk411xGwqZk8SD1Km4kY+eoKIe6e8j+495jNADb2oRuVAQE6ew
	 3irJBc/YYG43qgLj6tVqnvl/QvEdqNONxALcGeeaGGUGu2jTbaf6kRx1G83YROAPLY
	 nK3lY4ohGcP75d7FIeV5Q/YorE3bDUHjhm7gPoco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 395/417] net: dsa: vsc73xx: Add null pointer check to vsc73xx_gpio_probe
Date: Mon, 22 Jan 2024 15:59:23 -0800
Message-ID: <20240122235805.433314738@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 776dac5a662774f07a876b650ba578d0a62d20db ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: 05bd97fc559d ("net: dsa: Add Vitesse VSC73xx DSA router driver")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240111072018.75971-1-chentao@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index ef1a4a7c47b2..3efd55669056 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -1119,6 +1119,8 @@ static int vsc73xx_gpio_probe(struct vsc73xx *vsc)
 
 	vsc->gc.label = devm_kasprintf(vsc->dev, GFP_KERNEL, "VSC%04x",
 				       vsc->chipid);
+	if (!vsc->gc.label)
+		return -ENOMEM;
 	vsc->gc.ngpio = 4;
 	vsc->gc.owner = THIS_MODULE;
 	vsc->gc.parent = vsc->dev;
-- 
2.43.0



