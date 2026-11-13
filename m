Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591545;
	b=RV2eod8G/Y7h6KFY4Y7f0Wfw8HCEk4Tno/dcCUn82QamRnVbHY7rGklsOoihTr6UlrmF
	 CTem5Dqnt7UTHI/yf/mcUqmksIlEMtmnZ7j0yQ9K/if2t3Z36xHeagVCM41mW2i7o4a/V
	 yNqwTK6EXlnpHwqhSCSjDAQcet1XryXZGqF6LSsf4/+Aif6pgOlc7BUriXU54mWsIUjCk
	 lPIYK1vOEYAhsY2wE2gV/kFMP9Nx2RhZUnUubhD9RjU8SnQasWjTXyynXTUfFZfSLAcvC
	 lMtZeMzi9VlPv2UQthhNahmnZIo8Db3Jn/8X0mFP52MmQDTvVC5vrT+Ygg/jg2W3UkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0tZEggGw+FelTg+YSLJwVG1u8Qn/UzWGybP+wG7tGWU=;
	b=bJQWF3+3nmHDze32Zj863A/mw7FPqCpJO3kcpIy7Qd/jMC3URVcHl4aZm0SdY91FsMyl
	 MdczGQB85Rz0+iBITMxfw/WR2rPsXElZLUBX2s/HgTRplhkzonhlsuFOC2Jn5BDwEDIg8
	 u88iPgOtLas/j6NqVIPC4pn6Z5+yKU3i06tQZ1NHVycDI+Sy/y9ZqfP9yegCnPZk2Up9A
	 jSx5eGh9hpDjQ2imJxTQJsbfxre+8cKi9/vSTsJNC+65gS0SCYKMWkTgp8xt9h4xasxIQ
	 iWROtxKARO4eNgb9mSQJnB4PzXzYX9RYErEKRrXTnrQWXtPwQN+6Oq29rHB1Dwk7qXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3BLqIfA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB285606D4BC;
	Fri, 13 Nov 2026 17:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3BLqIfA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED1D1F000C4;
	Fri, 13 Nov 2026 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591545;
	bh=0tZEggGw+FelTg+YSLJwVG1u8Qn/UzWGybP+wG7tGWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3BLqIfAk1nqJDGg3yI0pdyvlE9tkKlWQJEFoVd5pxaL84b2Qkg0p+3+GZRLhApy/
	 qK1HWI6VYWiBtq+ZwApi42BNG60cUioJ3C7oHyBco9mF1zKRK0HOGlEZzYUIPr9x30
	 pNsfdUZJgoQAeFjsVX8VAPr7UsjweSu0s7FaAd10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 598/670] power: supply: core: add wakeup source inhibit by power_supply_config
Date: Fri, 13 Nov 2026 10:52:42 -0500
Message-ID: <20261113153832.087597318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 49000fee9e639f62ba1f965ed2ae4c5ad18d19e2 ]

To inhibit wakeup users currently have to use dedicated functions to
register the power supply: {,devm_}power_supply_register_no_ws().
This is inconsistent to other runtime settings which can be configured
through struct power_supply_config.
It's also not obvious what _no_ws() is meant to mean.

Extend power_supply_config to also be able to inhibit the wakeup source.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20241005-power-supply-no-wakeup-source-v1-1-1d62bf9bcb1d@weissschuh.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: db560f4b1c52 ("power: supply: bq27xxx: Ensure poll work is cancelled on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 3 +++
 include/linux/power_supply.h             | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index edc7b3bd9b5c8..e51ad6dadc165 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1403,6 +1403,9 @@ __power_supply_register(struct device *parent,
 	if (rc)
 		goto device_add_failed;
 
+	if (cfg && cfg->no_wakeup_source)
+		ws = false;
+
 	rc = device_init_wakeup(dev, ws);
 	if (rc)
 		goto wakeup_init_failed;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index b03991a29a65e..36275c37f1f2f 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -236,6 +236,8 @@ struct power_supply_config {
 
 	char **supplied_to;
 	size_t num_supplicants;
+
+	bool no_wakeup_source;
 };
 
 /* Description of power supply */
-- 
2.53.0



