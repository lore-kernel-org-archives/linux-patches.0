Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058439;
	b=4qjZck/IWSS+NrDHjKjjXm8WHvosGHrF1Z57l3nfyBP7Km+6+BSMUe8E54atXWoxUJj/
	 ikEmUmLjTye2dP4QGZNuuwH3Ci8hSiiSZ/hqpSG24NRe5owiUo1Lq6a7lMZ5ZKLZ67vdf
	 4JkrOmG2h5W5hRsycCHg5VVxvIT9tP4M8Cd4NXyO2zkR7lz8OXS5USiLtPR5YySs3UL+q
	 TWWGRv4LQDLo39urIVx5tOWWVNnCFC+lyRTcaAWplv73efR68VzgpId86MnBfzobgB07S
	 +NrgizL78JAvgSlUL5CLi/+WSNSa4+UamTinQOS9j3JUdI9sg5Q3PQRkvXUGpF7aD2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=75KBF4Q4ipbzDfv0Y8YyEhPlD9GHkl55M2+ReGQ+4v0=;
	b=MEUJI8lEr+Ypv5MzvorZrKQD/B/jXJzRwJA69EG+aGHOwSehq6tpO/9pEJr6WYEy3CD+
	 wHMQSEkVaPAJ9rvXS9ITrCUtGkodQWEEnkueqL69JX2zOYWBFM8d/5pvEze4urAUx6xK2
	 GvCn2/JfGWwMdM7JocYY/KTwCG/57QGE5uWgdF5I/v7kaH4C97iKHOO9kuwBPhGe6NSbb
	 qBrki/SoABaKYMSNOxlo1WVJfCJuFoEe8FpMgUUBmMGokaV7Xks/yWrz0gbGSqwsf8eSo
	 7noS5TToq08sajFhLJceCW98j53Aw3GMjd1K+627psJM7DbOi+4Gekk/hszNc7Ccyog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vXJQ3m9Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D97606A33B;
	Thu, 19 Nov 2026 03:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vXJQ3m9Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EC11F000C5;
	Thu, 19 Nov 2026 03:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058439;
	bh=75KBF4Q4ipbzDfv0Y8YyEhPlD9GHkl55M2+ReGQ+4v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXJQ3m9Y1epdRMVt2lrSIgHiWnSncYtxBF2pq3zRRftFfclsRwzU/e/l76FfsxhOL
	 JDRNkuGhJZ1GAgxXbz5fnKUVcO+AF/gYTTlXtFrWT4XzxdK/+DyKXNI3Mh1+9B3lxG
	 eKtopSecP6nVAQmk/A6U8FZ+GreU0Nnr3AxWlYLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0484/1848] clocksource/drivers/digicolor: Fix clk reference leak on request_irq failure
Date: Wed, 18 Nov 2026 15:42:02 +0100
Message-ID: <20261118145934.449492139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 9cc2e18b32f12d26ae6729c62a03640423956b17 ]

digicolor_timer_init() obtains the timer clock with of_clk_get() and
enables it, but the request_irq() failure path returns without releasing
the clock reference, leaking both the enable/prepare state and the
reference itself.

Disable and put the clock before returning on the request_irq() failure
path. The success path keeps the clock enabled for the lifetime of the
timer and is left untouched.

Fixes: 9b8bb7736b78 ("clocksource: Driver for Conexant Digicolor SoC timer")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Link: https://patch.msgid.link/20260915045242.1726702-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-digicolor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/timer-digicolor.c b/drivers/clocksource/timer-digicolor.c
index 1e984a4d8ad00..ae758b3059cc1 100644
--- a/drivers/clocksource/timer-digicolor.c
+++ b/drivers/clocksource/timer-digicolor.c
@@ -193,6 +193,8 @@ static int __init digicolor_timer_init(struct device_node *node)
 			  &dc_timer_dev.ce);
 	if (ret) {
 		pr_warn("request of timer irq %d failed (%d)\n", irq, ret);
+		clk_disable_unprepare(clk);
+		clk_put(clk);
 		return ret;
 	}
 
-- 
2.53.0



