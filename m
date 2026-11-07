Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061405;
	b=jL83wLJJB0TpHfkQKHWl/b6SOfE9e4Y6g/m3bQu6WiroX3OYVaayxGtLUoif+mutHhjg
	 eSkzE8ghfsvwuFBg+w4Qd61v/FCxYH1afX7VxKpu4KtRzlmXu8WKV1wH2umQCgpyAOx6h
	 3K+W8vqxpZ+qpPbLu0hUJwGyOJADSp+CCB81ewgm6rH12D4eld7UcXHlOMrH+l6S7lgAp
	 Pj9qFQiPq/dCNef8WvXWG9vk2kfsucL1TdnEmGY2grxwgStilS0TG4IA+xnaIEPSCm49I
	 MBX6tW4TESaUcbk8/I+K5VDigO8QSDBO8ZReyUl+jPfX5Af98PQYkuczoObGCT6xwaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/U7tZ9OzOH4UKqnj5qAX3J0vLANZiiKsCoFh+d4Nebk=;
	b=gexiH7Kw7aXjcRSg//V2MARnhUN152O7eH+GP/ZcTCNJjalF0ciEexwdgRhO0mko3lTE
	 wVVbqvgmJb99DVm1JUrCJJ8k7Nvginn9WZaAJRZkQrSmgYcgv3SFdXruKK2Ypt/smnDI5
	 o9Ov/fuhCvnE7CutVrql6nRuHUcbKcjUuCzuErOwbkUNhP6YK8p6/I+YYWiCLyDuQVdwB
	 tLWO4O5tqIEc6bTKM4QXpxggcc/CqvS6CvejzIpuSPa6uuWyJIZaPtF8ghEFZ3OQ9gzVN
	 4YHXyE7Ryr5ZgI3n3rS3OPomts9DOEQQT2stS7Fh7fy1BcNhLlTuCTHV68bKdrkdlNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbceCjie;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AD9606A332;
	Sat,  7 Nov 2026 14:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbceCjie
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C0C1F0089F;
	Sat,  7 Nov 2026 14:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061404;
	bh=/U7tZ9OzOH4UKqnj5qAX3J0vLANZiiKsCoFh+d4Nebk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbceCjieJWcr3zbJaOULkE2qYJ9nrrZm2p8Dg24xFU0eraG152m4GhxWQch/cpQmX
	 rckRNLgEhAq8FnIdj10oB0IvDv7jY5iXBxD02ubjceipFTpcsgt+5OetHQWPQtCXpU
	 i0ScLWrW5slcZTIn7GZDOv7Savky7vORo6nZXWjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0522/1536] watchdog: rzv2h: Add support for configurable count clock source
Date: Sat,  7 Nov 2026 08:42:18 -0500
Message-ID: <20261107135012.090372214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit ef6080fec60af92fc00b96743e85779927baf87b ]

Add support for selecting the count clock source used by the watchdog
timer. The RZ/V2H(P) SoC uses the LOCO as the count source, whereas on
RZ/T2H and RZ/N2H SoCs, the count source is the peripheral clock (PCLKL).

Introduce a `count_source` field in the SoC-specific data structure and
refactor the clock rate selection logic accordingly. This prepares the
driver for supporting the RZ/T2H and RZ/N2H SoCs, which differ in their
watchdog clocking architecture from RZ/V2H(P).

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Stable-dep-of: 6274281c41ef ("watchdog: rzv2h: Avoid division by zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rzv2h_wdt.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/rzv2h_wdt.c b/drivers/watchdog/rzv2h_wdt.c
index a7f99a79c1e03..7df8b8e392410 100644
--- a/drivers/watchdog/rzv2h_wdt.c
+++ b/drivers/watchdog/rzv2h_wdt.c
@@ -42,12 +42,18 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+enum rzv2h_wdt_count_source {
+	COUNT_SOURCE_LOCO,
+	COUNT_SOURCE_PCLK,
+};
+
 struct rzv2h_of_data {
 	u8 cks_min;
 	u8 cks_max;
 	u16 cks_div;
 	u8 tops;
 	u16 timeout_cycles;
+	enum rzv2h_wdt_count_source count_source;
 };
 
 struct rzv2h_wdt_priv {
@@ -214,6 +220,7 @@ static int rzv2h_wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct rzv2h_wdt_priv *priv;
+	struct clk *count_clk;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -239,8 +246,19 @@ static int rzv2h_wdt_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(priv->rstc),
 				     "failed to get cpg reset");
 
+	switch (priv->of_data->count_source) {
+	case COUNT_SOURCE_LOCO:
+		count_clk = priv->oscclk;
+		break;
+	case COUNT_SOURCE_PCLK:
+		count_clk = priv->pclk;
+		break;
+	default:
+		return dev_err_probe(dev, -EINVAL, "Invalid count source\n");
+	}
+
 	priv->wdev.max_hw_heartbeat_ms = (MILLI * priv->of_data->timeout_cycles *
-					  priv->of_data->cks_div) / clk_get_rate(priv->oscclk);
+					  priv->of_data->cks_div) / clk_get_rate(count_clk);
 	dev_dbg(dev, "max hw timeout of %dms\n", priv->wdev.max_hw_heartbeat_ms);
 
 	ret = devm_pm_runtime_enable(&pdev->dev);
@@ -269,6 +287,7 @@ static const struct rzv2h_of_data rzv2h_wdt_of_data = {
 	.cks_div = 256,
 	.tops = WDTCR_TOPS_16384,
 	.timeout_cycles = 16384,
+	.count_source = COUNT_SOURCE_LOCO,
 };
 
 static const struct of_device_id rzv2h_wdt_ids[] = {
-- 
2.53.0



