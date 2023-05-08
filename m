Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9141168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F645C433D2;
	Mon,  8 May 2023 10:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540857;
	bh=Z1nXqxFNUKRWTLICumPnwlkqPjsoIMIj2M1bXdCYmBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGnZWe9cxVqNMnhQ4cE4LQQnUlyLmGgc0UqkNAtdwUWuknvKnT8SIZQX76Rqj9n5W
	 GfbI6A5Lq2PHXmHRKhMkIDwQYFEEG1ZH5/rlYw4DO3OHnoBhyxJlj3Sm4R2jEfa/ob
	 qHgnJhSU9j4CC9CVlI+7ROqhGta2YtQLnrnk/Iw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 484/611] rtc: k3: handle errors while enabling wake irq
Date: Mon,  8 May 2023 11:45:26 +0200
Message-Id: <20230508094437.810732254@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dhruva Gole <d-gole@ti.com>

[ Upstream commit d31d7300ebc0c43021ec48c0e6a3a427386f4617 ]

Due to the potential failure of enable_irq_wake(), it would be better to
return error if it fails.

Fixes: b09d633575e5 ("rtc: Introduce ti-k3-rtc")
Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20230323085904.957999-1-d-gole@ti.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ti-k3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ti-k3.c b/drivers/rtc/rtc-ti-k3.c
index ba23163cc0428..0d90fe9233550 100644
--- a/drivers/rtc/rtc-ti-k3.c
+++ b/drivers/rtc/rtc-ti-k3.c
@@ -632,7 +632,8 @@ static int __maybe_unused ti_k3_rtc_suspend(struct device *dev)
 	struct ti_k3_rtc *priv = dev_get_drvdata(dev);
 
 	if (device_may_wakeup(dev))
-		enable_irq_wake(priv->irq);
+		return enable_irq_wake(priv->irq);
+
 	return 0;
 }
 
-- 
2.39.2



