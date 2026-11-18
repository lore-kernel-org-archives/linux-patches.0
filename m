Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023317;
	b=BBT18kNJQJQx57FKcGHVxSZNdatUwAZ+3lTqrbMEmZFYbXZlfknU8UdjmsXXEAXrarCY
	 qYHWEGJmgfv/e0ElkexGUtHWdHcw7HivahEFs9RUSPpuPUN++O+PFNNFNzJnveiTnfH5R
	 m91bkQDsIpmJVX8i7tdpM6BuA4Gi1DQ/eRVEp7svuHIxaRzArKSmPVHTHInCH7kCOsXUV
	 p+sTq5BhR7cbgOZptmJ9rPnlfvdkQi5FOHJaEbY/OkVKr0CZUYgK5mdkoK0YkNHkCkDji
	 fahG+ICL4GRLXmJuPxs/R+4XmRqOzSc6ibjFlEYTiIVVCOih5HHZxK87T74H5YefGYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0lLAZSUVhIOKi0plCsENVEtFrB68msNC7y+XJeNFlsE=;
	b=kuxug/56tZist0gnOAEmJhhSPqOCViMY2DCSPX2qRYwiE+Z5f9yqcfBmUouffW8uljnY
	 A8BesBgBzf5NSKxk9ZarHlo7BzfONlPCT1gYxpoYMLamMadwbQEh2/UDBt0ZpbQxtRYgs
	 1YQZ6VjEwxQh4Mx2IBKDrKbd1ks8QlmwmVKk4sGF6C+xhmmwu5P7L46QmfI8N7rS5igMN
	 aMDUayzqX/pNkkV5CvnpfPaYaPI57lhih5JEjF7U3AO0EJxB4Fzj+baPelPEdSBU1ikZU
	 /jegyJkUwPEHwskaPR3bGpTjf/Iif/se3pdTiFk2nUIbu9Zuyp/qIlNWpmtIeIwSWGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLFKbPwU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18906606A33A;
	Wed, 18 Nov 2026 17:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLFKbPwU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5791F000C4;
	Wed, 18 Nov 2026 17:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023317;
	bh=0lLAZSUVhIOKi0plCsENVEtFrB68msNC7y+XJeNFlsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLFKbPwUHJu37jUuPs2OjavR6ly4q7T+/D99gZBHsI1i3fkL7dQOViM2s9rmDHMwL
	 BQBf4M7IRRc8SG6TvZm5DdCj9ibXvt1ki//e/uqTUsp80vMDoucywgm2Nd661iyjv+
	 cZoKD1+XyUI6jMkFpdznUvYPsY/moyoL9buxX1WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0325/2151] power: supply: bq2515x: Propagate charge-enable read errors
Date: Wed, 18 Nov 2026 15:34:20 +0100
Message-ID: <20261118150133.794903215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 4a35810a847411c466a15d1737d11e8e818dc197 ]

bq2515x_get_charge_disable() returns bool even though reading the
charger-disable state can fail. A negative error is therefore converted to
true, so POWER_SUPPLY_PROP_STATUS reports NOT_CHARGING with success instead
of propagating the failure. The GPIO read is not checked for errors either.

Return an int from the helper, check both reads, and only convert a valid
charger-disable state to the charging-status boolean.

Fixes: 44908459275e ("power: supply: bq25150 introduce the bq25150")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260824084217.670213-1-lilinmao@kylinos.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq2515x_charger.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/power/supply/bq2515x_charger.c b/drivers/power/supply/bq2515x_charger.c
index 437bff5bc4206..9d2bd2bb9fa81 100644
--- a/drivers/power/supply/bq2515x_charger.c
+++ b/drivers/power/supply/bq2515x_charger.c
@@ -420,7 +420,7 @@ static int bq2515x_get_battery_current_now(struct bq2515x_device *bq2515x)
 							BQ2515X_ICHG_DIVISOR);
 }
 
-static bool bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
+static int bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
 {
 	int ret;
 	int ce_pin;
@@ -428,6 +428,8 @@ static bool bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
 	int charger_disable;
 
 	ce_pin = gpiod_get_value_cansleep(bq2515x->ce_gpio);
+	if (ce_pin < 0)
+		return ce_pin;
 
 	ret = regmap_read(bq2515x->regmap, BQ2515X_ICCTRL2, &icctrl2);
 	if (ret)
@@ -435,10 +437,7 @@ static bool bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
 
 	charger_disable = icctrl2 & BQ2515X_CHARGER_DISABLE;
 
-	if (charger_disable || ce_pin)
-		return true;
-
-	return false;
+	return charger_disable || ce_pin;
 }
 
 static int bq2515x_set_charge_disable(struct bq2515x_device *bq2515x, int val)
@@ -615,7 +614,11 @@ static int bq2515x_charging_status(struct bq2515x_device *bq2515x,
 	else
 		status1_no_fault = false;
 
-	ce_status = (!bq2515x_get_charge_disable(bq2515x));
+	ret = bq2515x_get_charge_disable(bq2515x);
+	if (ret < 0)
+		return ret;
+
+	ce_status = !ret;
 
 	/*
 	 * If there are no faults and charging is enabled, then status is
-- 
2.53.0



