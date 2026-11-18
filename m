Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030465;
	b=WwG28Zc0ftM8yFGpPnZhN9u8/t9ZW9Z9Vp0E2vDepwqOdsTmYa88FFCUWoKrLep4DNeZ
	 QUa7skNJ1VoQ9IEefpPCubupQyU3BkxTqcaJLStuGp8DQOea8b3pc/mLqgPZizyY+NIv+
	 wplYc2gYWrtBu7VpYTlP9wJxnhIM6OIfPbdB5s0QKlJqmBNQoiKGix1z+53JPo+AHvxyk
	 zaBvf74t1viyjgL1L3nwzpS/5h8FkyUvqO5lxST2FTN9x9XvSTa+xW8mdGnke8sOqgAaJ
	 /IaMu+NIoelBjQRWq1RQvIywkk/x1xvlzVjnCgIU+98biaNCNqWvB+tMNgV4Fgn9rhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=66iEa52aKoEwr3Jol2tWm/0WkVak4IBy0IqmWArwqhM=;
	b=rDAWvHkE4Le1DGQmTKMtnL7uj98DjbiZ/6dUm6/RiBLLLg/jj32yA0FRjLmS8GtM6Mv6
	 e50eifgCyjWiJRyK52/aYfFINI9SYxX3kPDkoDdLagozhVw10vqJ4xJaw51kKUN3xSuhL
	 AIIQLFyq+CiUVsynOTzK/0C871dTQkYjnVv77utC6Qd6A8Ih7MjUf2gllgfIaolT4AaDD
	 HgsmtcrIwxtYdCqBVAtZUSkMnUtCHI9eHU9EZ3eAIjpNrYYNUiHwJOkpVj3GKNKYmErby
	 dllf7d27LVAsYiNB0DBLLVIQAmgeXZScsf+TAXGwcvlqrbtCLPtguTlP+RfEJANwdNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SLHC03Tr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750B2606A33D;
	Wed, 18 Nov 2026 19:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SLHC03Tr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C68D1F000C4;
	Wed, 18 Nov 2026 19:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030465;
	bh=66iEa52aKoEwr3Jol2tWm/0WkVak4IBy0IqmWArwqhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLHC03TrgduJ/HUjYnnkFsr96L2wDj00EGPihmnq1mISPLz4d3yDC8BwTaPOrxxGP
	 hGaf3JfwOpXzAh/xIpHZoA97l+3g1QgZbWqxLQRly6Xja69x3RorjtaAIb0X93ObBq
	 tkpAjke0mZzADrJCyOd84J///VFTLyCDabUdPrHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0714/1756] rtc: bd70528: properly enable wakeup
Date: Wed, 18 Nov 2026 15:47:21 +0100
Message-ID: <20261118150037.850491073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit cb8a6249236fd970fc3418d5d2b27dc37376f3ff ]

Wakeup on RTC alarm now only accidentially works when wakeup for the power
button connected to the same PMIC is also enabled. Fix that by properly
specifying the wakeup irq.

Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 32a4a4ebf768 ("rtc: bd70528: Initial support for ROHM bd70528 RTC")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260922-rtc-bd-v3-1-7f2580c55d58@kemnade.info
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-bd70528.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/rtc/rtc-bd70528.c b/drivers/rtc/rtc-bd70528.c
index 59b627fc1ecfa..7f10f2f4f468b 100644
--- a/drivers/rtc/rtc-bd70528.c
+++ b/drivers/rtc/rtc-bd70528.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_wakeirq.h>
 #include <linux/regmap.h>
 #include <linux/rtc.h>
 
@@ -318,6 +319,10 @@ static int bd70528_probe(struct platform_device *pdev)
 	device_set_wakeup_capable(&pdev->dev, true);
 	device_wakeup_enable(&pdev->dev);
 
+	ret = devm_pm_set_wake_irq(&pdev->dev, irq);
+	if (ret)
+		return ret;
+
 	rtc = devm_rtc_allocate_device(&pdev->dev);
 	if (IS_ERR(rtc)) {
 		dev_err(&pdev->dev, "RTC device creation failed\n");
-- 
2.53.0



