Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064264;
	b=4huoOSHeD4t6IcRZYMPrGGnVyVLZ7M8nZvagOBi/9bPqk4ug+eLNi3qxF1tsv38uIeO6
	 RsJZFPtn+oVvbRmqu7LYKHGwMs5nm/husjxcBZAi5XpDVDw+pzzMxilqO4Y1W/meo1bmj
	 6cLByuS84BQhGY2/vwQhg24ZsTfTMVk5x57DSqXfXqJfEAHE7+m6Bzl+bOWgkgoetvCun
	 GD9EtpEfGCDHixWNA7HWfrvooPIQF6ShTClWTXgZiG8/7hbvvdavLaIw45cxGUiM9/FxD
	 ggZBvUZfu3do8Zn9vcWH1UOnrrtKw67zfqQvpTWAt21rfunltbWV3Y7XlyfXfwVO0VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n3sRxlq5T/rk5FTMrKQzPYmkt0ceS++llylVPFxkwUI=;
	b=0rlhYg0801bNwVv77DzzjwsYpHMOGh2Vy1sSFrYmHMljUPwAkcR8gOqVqoGc9vsKsbq6
	 IaQIUR88vcFnJmaNSxC/2hBSWkuJVa/UJyKnn8qPpAS0zCmLDBnBuLbHMZN6oDYDaFkzy
	 Zy+XaR0HEi62vZv5n/J3QhZyAp7H7ymdnElafGorSY6UZVpmCQYNfcR9oKq4Fi/HJFYpc
	 uZBv6MGNBL4cL7OLneiYr/3lhbZFOFgZnk62FhsURaUEEFWUTr/K4rfJ4swHOGkf1uucv
	 LoTOxCAsJgQQyGOfT2v/E8S5a2FqhomuouI7fY29hc9OIwbKXb/b6ynMeMO7zRWnPCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSKU17pQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A887606A9C9;
	Sat,  7 Nov 2026 15:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSKU17pQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF7E1F0089F;
	Sat,  7 Nov 2026 15:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064264;
	bh=n3sRxlq5T/rk5FTMrKQzPYmkt0ceS++llylVPFxkwUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSKU17pQTKLr+QV5JYXUWvcGMYOXOYc2VVgv5OimvSel2yr5dx1WrguICEfkHqP8o
	 Qbv/mbmR99E7g2fepYZaXOXbpZxTQS0v9kkuJ2xYtvvlQWdQseGyXYmxNZUB+wcta8
	 NI2bgQxi3TyV/aCGKrrCI/rYD5gVmFa9pVX7cAWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Birk Skyum <birk.skyum@pm.me>,
	Renjiang Han <renjiang.han@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0363/1257] media: iris: reset AHB bridge before enabling HW mode
Date: Sat,  7 Nov 2026 08:44:19 -0500
Message-ID: <20261107134949.566230189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikash Garodia <vikash.garodia@oss.qualcomm.com>

[ Upstream commit cc330f5589965bcf99307ee9c66deb8a0a53e0ee ]

When video power domain is switched from software-controlled mode to
hardware-controlled mode, the core may be powered down without the AHB
bridge going through the required reset sequence. This may leave the
bridge FIFO in a stale state.
Reset the CPU-to-VPU AHB bridge before switching the power domain to
hardware-controlled mode. This ensures that the bridge FIFO are in
reset state before going for mode switch.

Reported-by: Birk Skyum <birk.skyum@pm.me>
Link: https://lore.kernel.org/all/20260913194707.91885-1-birk.skyum@pm.me
Fixes: 95a337f92f0a ("media: iris: switch to hardware mode after firmware boot")
Cc: stable@vger.kernel.org
Co-developed-by: Renjiang Han <renjiang.han@oss.qualcomm.com>
Signed-off-by: Renjiang Han <renjiang.han@oss.qualcomm.com>
Signed-off-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Reviewed-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Tested-by: Birk Skyum <birk.skyum@pm.me> # Lenovo Yoga Slim 7x
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vpu_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/qcom/iris/iris_vpu_common.c b/drivers/media/platform/qcom/iris/iris_vpu_common.c
index e4847c1077097..2ef8004e976e3 100644
--- a/drivers/media/platform/qcom/iris/iris_vpu_common.c
+++ b/drivers/media/platform/qcom/iris/iris_vpu_common.c
@@ -311,6 +311,11 @@ int iris_vpu_power_on_hw(struct iris_core *core)
 
 int iris_vpu_set_hwmode(struct iris_core *core)
 {
+	writel(CORE_BRIDGE_SW_RESET | CORE_BRIDGE_HW_RESET_DISABLE,
+	       core->reg_base + CPU_CS_AHB_BRIDGE_SYNC_RESET);
+	writel(CORE_BRIDGE_HW_RESET_DISABLE, core->reg_base + CPU_CS_AHB_BRIDGE_SYNC_RESET);
+	writel(0x0, core->reg_base + CPU_CS_AHB_BRIDGE_SYNC_RESET);
+
 	return dev_pm_genpd_set_hwmode(core->pmdomain_tbl->pd_devs[IRIS_HW_POWER_DOMAIN], true);
 }
 
-- 
2.53.0



