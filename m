Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536122AE96;
	Tue, 29 Apr 2025 18:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950009; cv=none; b=ifacgBZ4jE2DQ1bmJORu0E8UT+0XrYPwZcL60dGirYFwXe5fzihxQ7jFSJVjWkyY5V6D5S8NTZeZF8LwYROJDBKCrVY1g569sJU+M9uCOWNZJjOgH5AMwjR/xTqmVLNw2k1qH7fTVNC5ahyY8TXgmX/H509J+gOBSrf4li/bMOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950009; c=relaxed/simple;
	bh=KeEHWttNwzuONz8rfPjWz7iZdxMcjlg5Yi69QUhqn+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnaf8VH7NI7RwP1gFzw3cWPUS098jtZpQiflI91PwjSdY0WT3Fmm/9wzixjDdYtnNs06YFhaJzKE91g6e9GJqtFfSvrI39Qhy1dp70f0toERMsy7jFnQ2B2Q4sdR0IQmAZc3FaHXeQrXfFUdTJvtLHgfrTnSECff9DtABUe2ldM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctwSe2Uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctwSe2Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CC4C4CEE3;
	Tue, 29 Apr 2025 18:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950009;
	bh=KeEHWttNwzuONz8rfPjWz7iZdxMcjlg5Yi69QUhqn+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctwSe2UvVnMxE+iIRM/jAAORMSzM4QOoxv8jHDmum5mTLMG0RcqJge30eQymsKkWm
	 UdPPlzUoK6TPO68bXhFBhMX/boeTGXHW3KsdBdGFqeAiivJJBf3YAfnc0jq1rU1ysy
	 TpayDs+npcETJnOoneJnQavbh9p934PltShrU0tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/167] pinctrl: renesas: rza2: Fix potential NULL pointer dereference
Date: Tue, 29 Apr 2025 18:43:25 +0200
Message-ID: <20250429161055.678277557@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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
index 2d6072e9f5a87..6f0d3fda61c24 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza2.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza2.c
@@ -242,6 +242,9 @@ static int rza2_gpio_register(struct rza2_pinctrl_priv *priv)
 	int ret;
 
 	chip.label = devm_kasprintf(priv->dev, GFP_KERNEL, "%pOFn", np);
+	if (!chip.label)
+		return -ENOMEM;
+
 	chip.parent = priv->dev;
 	chip.ngpio = priv->npins;
 
-- 
2.39.5



