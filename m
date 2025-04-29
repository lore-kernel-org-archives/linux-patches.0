Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8261D25335B;
	Tue, 29 Apr 2025 18:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950507; cv=none; b=UgBMEmGpnS9Z3zWi0vygJ4ZZrCBHmfTL6K4d2Py8laBJxAv0POu7DvliBhE9lhfR2fB982H6HIHxn/Ibzv+yEvHpY7XuGnSLRZKvrtGX+/N62Mzzwn2H8T6PyCadpNTYJPt3yLNZEwPjWfAq+mNHPIwEGefitwmv/9qQT9qlT58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950507; c=relaxed/simple;
	bh=ilciZuYDfmsxcTGm86QduraEIrAMuDL3Mx4cIqyt3vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2fjkboOGcm68RMFO8cAwDBu1XB2HVkF0tJVnZpsDWIU+8zX+H5MwW7IYrMCaKf1QSRm0Eshlop7qDXmeHMFxTLRPVx8EKEkKRuzt1torFyExzkcOY/uphEhSq+EPYAg6nzDCJVrkSA/cuG1OnZNFlm9wf5/LmGcryfmg8LJG50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8eujtEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8eujtEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E195DC4CEE3;
	Tue, 29 Apr 2025 18:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950507;
	bh=ilciZuYDfmsxcTGm86QduraEIrAMuDL3Mx4cIqyt3vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8eujtEx5sfqm8a8dlY3mUr9+/oLZGWjho20m36P2woYHyAQbUhuT5jPJ3+zAQ/0r
	 z1F81LuRakyXmfLLomeH3ChUIA0ojWf3xAM1ZFOAvKnBk9wdq91tg3LgQmfSCMQpzD
	 aEiKjBPM4RD0S3F2ey/9YjLJlFjGkvQtr88wMoNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/204] pinctrl: renesas: rza2: Fix potential NULL pointer dereference
Date: Tue, 29 Apr 2025 18:43:25 +0200
Message-ID: <20250429161104.224920894@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit f752ee5b5b86b5f88a5687c9eb0ef9b39859b908 ]

`chip.label` in rza2_gpio_register() could be NULL.
Add the missing check.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/20250210232552.1545887-1-chenyuan0y@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rza2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rza2.c b/drivers/pinctrl/renesas/pinctrl-rza2.c
index c5d733216508e..df660b7e1300c 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza2.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza2.c
@@ -243,6 +243,9 @@ static int rza2_gpio_register(struct rza2_pinctrl_priv *priv)
 	int ret;
 
 	chip.label = devm_kasprintf(priv->dev, GFP_KERNEL, "%pOFn", np);
+	if (!chip.label)
+		return -ENOMEM;
+
 	chip.parent = priv->dev;
 	chip.ngpio = priv->npins;
 
-- 
2.39.5



