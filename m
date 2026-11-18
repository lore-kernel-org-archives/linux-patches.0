Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016679;
	b=UNSYaxeeoD/82dZcAeumpevHlEnCN2r7HvA13TuJh/weEuRelUQypBgV3P+Bdt5jFOLX
	 9HatxpuGibyUqDd50qFCUmGIYRGbLUyjiEpFcJvaXPe0usa6PdOYax27Z0pISf3Rqux4y
	 9JM7d8UKMmF+jfp/t1pZm4MVgRoZFgnnRgAu76elZM+P3JUat1kjFPjtdQR56NHNaetG7
	 7DLm6+ZqO7jv3qHTuCfdikvXgrb7ROit+NFFvXKrcKzrjN9p7+cXodnhVZmF5f3S8qbrp
	 qa/4z535JhNtvoftWYYNMr1hS/PIq42NrljnUjVpAI0v5sBJU1c2uiFXMDLP/w3KpOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1SN25nbCdfmaNZe7PTuSC1slznSMC6YkFQgCLimHmKM=;
	b=O/4KNMt65TLaTaLg3qwKE4QQXeNgAVosU2kD6DgbWpsq9luOcdoHnxwfUKp250q8MwD9
	 rL3m+2HVWEpeXejGGBv18AdUgCnlsCdzFctspC+gIfE5yCm6NReQ8Ia4Hs2eWz6Nw9E6E
	 9UI/pfTDq0mJOhUQpLymuJ700mW8dJI85AgaJa/o25e+OmGoXHdM8vbdqopmW0I7Ov8NZ
	 fNqHqyMHf8foISC7G908oDwb32FEXtjyzF7QGYLkLSPCO95C2CUuZrGv0QsyxKGA63kYD
	 iE96vbB97R8o0+xvJmKvMX1/+H2tAODQomN5CCtcF3SoDAqMK5tGiAtVb21VXLonzVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RuzJNVCm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA45606A325;
	Wed, 18 Nov 2026 15:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RuzJNVCm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF671F000C4;
	Wed, 18 Nov 2026 15:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016679;
	bh=1SN25nbCdfmaNZe7PTuSC1slznSMC6YkFQgCLimHmKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuzJNVCmGN61daeaoi+qJYk14Yk2Fj4ee2J717h7VlsPy7Fleq8wHDocin8F1kjl8
	 Gz5pOMSX3+uCHF/0291jU/qZS7Pqtg5mHUkN//BzK//V8nBpNCH/n3B8V7YoUcbQ/I
	 cSzEVS8iCd7WPmPrM3PgAdZqekA9mvNGEChXeTcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0615/2651] thermal/drivers/renesas/rzg3e: Fix runtime PM handling of compare irq
Date: Wed, 18 Nov 2026 15:30:55 +0100
Message-ID: <20261118150309.851282906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit aa1bc39e45f29a4f56d7e6be7164e100727df465 ]

The TSU hw is limited in the sense that lower and upper trip points can be
set, but the hw cannot raise interrupts on its own. It can only signal that
the thresholds were passed when the temperature is read, either during
polling or on a manual read. Therefore, the interrupt enable state
configured by set_trips() must remain active for the next read to trigger
an event.

Currently, runtime PM autosuspend puts the chip to sleep and clears the
compare interrupt that was enabled during set_trips(). On power up, the
compare interrupt enable is not restored, which means that it won't ever
fire.

Fix this by caching the contents of the SIER register during runtime power
off and restore it during runtime power on.

Fixes: dc67521c20b7 ("thermal/drivers/renesas/rzg3e: Fix add thermal driver for the Renesas RZ/G3E SoC")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260916120003.87018-3-ovidiu.panait.rb@renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/renesas/rzg3e_thermal.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/renesas/rzg3e_thermal.c b/drivers/thermal/renesas/rzg3e_thermal.c
index 4acee4eaff05d..45f67b2e11310 100644
--- a/drivers/thermal/renesas/rzg3e_thermal.c
+++ b/drivers/thermal/renesas/rzg3e_thermal.c
@@ -93,6 +93,7 @@ struct rzg3e_thermal_info {
  * @info: chip type specific information
  * @trmval0: calibration value 0 (b)
  * @trmval1: calibration value 1 (c)
+ * @sier: cached interrupt enable register
  * @lock: protects hardware access during conversions
  */
 struct rzg3e_thermal_priv {
@@ -103,6 +104,7 @@ struct rzg3e_thermal_priv {
 	const struct rzg3e_thermal_info *info;
 	u16 trmval0;
 	u16 trmval1;
+	u32 sier;
 	struct mutex lock;
 };
 
@@ -148,12 +150,16 @@ static int rzg3e_thermal_power_on(struct rzg3e_thermal_priv *priv)
 		return ret;
 	}
 
+	/* Restore interrupt enable state */
+	writel(priv->sier, priv->base + TSU_SIER);
+
 	return 0;
 }
 
 static void rzg3e_thermal_power_off(struct rzg3e_thermal_priv *priv)
 {
-	/* Disable all interrupts */
+	/* Save and disable all interrupts */
+	priv->sier = readl(priv->base + TSU_SIER);
 	writel(0, priv->base + TSU_SIER);
 
 	/* Clear pending interrupts */
-- 
2.53.0



