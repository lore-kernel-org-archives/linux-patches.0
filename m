Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA77B28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA8EC433EF;
	Mon, 30 Jan 2023 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088163;
	bh=rh6YdPCnnzwUAhXFkmFU17VRgN02RSBWmABVeMwQwYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3V2+ylpSz5gICm42hMtTbk7SYXPWaZBlQiPVKpaucig/2FA2t1l20Vl4OQ5HSYhA
	 BARHAe5dk11qQ9fpaFIFcQZfubEae14uEHu4v0dKQHXU2hcmGcMGAkDJhBWZqWkrSF
	 lJHYAvadmJEMq9FYAU1Hs58z6mlAVicN0C3FKS38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Chen <miles.chen@mediatek.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/204] cpufreq: armada-37xx: stop using 0 as NULL pointer
Date: Mon, 30 Jan 2023 14:51:12 +0100
Message-Id: <20230130134321.062215046@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miles Chen <miles.chen@mediatek.com>

[ Upstream commit 08f0adb193c008de640fde34a2e00a666c01d77c ]

Use NULL for NULL pointer to fix the following sparse warning:
drivers/cpufreq/armada-37xx-cpufreq.c:448:32: sparse: warning: Using plain integer as NULL pointer

Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/armada-37xx-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/armada-37xx-cpufreq.c b/drivers/cpufreq/armada-37xx-cpufreq.c
index c10fc33b29b1..b74289a95a17 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -445,7 +445,7 @@ static int __init armada37xx_cpufreq_driver_init(void)
 		return -ENODEV;
 	}
 
-	clk = clk_get(cpu_dev, 0);
+	clk = clk_get(cpu_dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(cpu_dev, "Cannot get clock for CPU0\n");
 		return PTR_ERR(clk);
-- 
2.39.0



