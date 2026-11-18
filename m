Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020104;
	b=HHTQLw4WfF+7Eg2IU78BipwdKMlx8YVXU8Y1q6WncOv6c8cmLkrxySSCXPa1h3MVAf4R
	 Uw9nPq5Z1xaRR5jWnSDgmICDpa8ruUZ3Mn1oTiXQjJ0LpA+3Rh49OvAr5DI0D+iZIaD76
	 Ojy/HdIStuq2vpejC9U+WX+nVZmKagV1+4wHXlm2oaziXdaZ3bWILrpeJ5MF+4NF5JZFj
	 Svz6mlxZETLCM2YXRr3s/GbbIUXYTFYWkboZgFNv/+CLQrPj8imzLubSpom3hmSKdS3+N
	 shER1MPbvbzLfKhgQX889VqZpoHBbFRqpr8iWJUyIU8TkX2MZ4QF6Q30snNut15fR2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LrXeZdXE7DxLzjcIqr6pdAuUnZ//ezMAN8g3qH2d0/c=;
	b=AQpuKGw/zv/8W4exagB8H+nS0kIy0kd9c2+oIM2CtdJ7ePQqxcDlVsfb1KLqo8mJG3A/
	 Qbmgqr1Ov9EzZtRQo2wp7AcD9YdCZeHGaw5BGzqPrwLCCQa0dumifghRgYEBSMDpIvxrM
	 yFk6b1hQFN5wOwdCIuiRuzb5occzl/JOwpeiYFhDWL7Z/w+7IMS51RJRUqg0YAPmlDDvk
	 +CnB3DF0jx9UgJPCYY4Bt/nilDs3XZUkRPBV2OZKXMni8c84y0oRWIAkXIbqNxVLDztu9
	 4bZoexzQcMxAoUe3oxmFpUr3LB0oSoPvipXttB9Ijpu8M/IRg2H/AxUnaH7Hbp8ApGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJ0Qg5GF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6E2606A31C;
	Wed, 18 Nov 2026 16:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJ0Qg5GF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53B51F000C5;
	Wed, 18 Nov 2026 16:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020104;
	bh=LrXeZdXE7DxLzjcIqr6pdAuUnZ//ezMAN8g3qH2d0/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJ0Qg5GFXs9UMcz/XBkq70aCrxspGYLH6W0ofu585rTWX3PrXGG23zTd2SazVgwvc
	 TtL+v0FdMK8WhN8w2iT5LJlzGYFuNa2NzXPkzwrfEDa5ai5vAXpUI0Ovoybuh5QzQ7
	 NyqAVYNE7bb2dhKlh4j9jnw4oKOLLeFAS/QE45ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1831/2651] thermal/drivers/rzg3e: Propagate reset assertion failure from suspend
Date: Wed, 18 Nov 2026 15:51:11 +0100
Message-ID: <20261118150353.043240367@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 2dc1f296b5754dd2441fc8b6613a362a47f6b98f ]

rzg3e_thermal_suspend() powers off an active sensor and then ignores
failure to assert its reset. System sleep can therefore continue without
the clean reset state expected by resume.

Return the reset error and, when the sensor had been active, try to
restore power before failing suspend. This is best-effort recovery:
reset assertion failure may leave partial hardware state, so restoring
power is not guaranteed to succeed. Preserve the original reset error.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: dc67521c20b7 ("thermal/drivers/renesas/rzg3e: Fix add thermal driver for the Renesas RZ/G3E SoC")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20261014031814.7230-1-hppiscas@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/renesas/rzg3e_thermal.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/renesas/rzg3e_thermal.c b/drivers/thermal/renesas/rzg3e_thermal.c
index 58fdcc66456a0..8b89cdaa76031 100644
--- a/drivers/thermal/renesas/rzg3e_thermal.c
+++ b/drivers/thermal/renesas/rzg3e_thermal.c
@@ -519,15 +519,19 @@ static int rzg3e_thermal_runtime_resume(struct device *dev)
 static int rzg3e_thermal_suspend(struct device *dev)
 {
 	struct rzg3e_thermal_priv *priv = dev_get_drvdata(dev);
+	bool active = pm_runtime_active(dev);
+	int ret;
 
 	/* If device is active, power it off */
-	if (pm_runtime_active(dev))
+	if (active)
 		rzg3e_thermal_power_off(priv);
 
 	/* Assert reset to ensure clean state after resume */
-	reset_control_assert(priv->rstc);
+	ret = reset_control_assert(priv->rstc);
+	if (ret && active)
+		rzg3e_thermal_power_on(priv);
 
-	return 0;
+	return ret;
 }
 
 static int rzg3e_thermal_resume(struct device *dev)
-- 
2.53.0



