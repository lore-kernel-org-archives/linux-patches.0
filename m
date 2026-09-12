Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94B847ACFB;
	Sat, 12 Sep 2026 12:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217377; cv=none; b=aXLSpQqgaoDwf5IPUo0x3R/hHZzS/X918O70rrf8eXO0YgK67sb0INjwnQgQrtKpTm3dmGYBM1cITHR1vzB59azXcgdlkwni28FLSNJ5dwydcuqidd75gfKE1kK9gnab6YRkCmSawQngc99ulxDURJ23G33XlSK7Dy0hl+as1BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217377; c=relaxed/simple;
	bh=bViCy0C/Bn1SjGMm+Q83sAP3J6KeYycbo39+HNOipfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzRF4vAf2iXOeMym/V5Qw+nj3xBUML/CoVoJO+1/qp2KzLzCQ+RxB5vjnoYAIstMoldjvIKX+IhSTnOStRlHajOXsdNEoRO2bxKbZjjbNE4+q2SosZBhwdCgrdS/AJsyNRJgQUZcsjJw502tcYgH51nxmubcAzQCBRTVuWsRauI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iw4Bi/6M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iw4Bi/6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE60C1F000FF;
	Sat, 12 Sep 2026 12:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217375;
	bh=KQMCzMSJpvWXCfAxZe46Xt0B9tIOt9QM0Iu0WZfiplA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iw4Bi/6MLDTA7rEaGMYVcLcDCD+P9bTZvM/Lmh+Y7JRCNoVdKbAdHsMTWh4pCph4C
	 OWQs3TBVNFDksJ91i0GpCPF2NtR+gw4yvidTFLn3FoF4/28zYRVXbLf4HJ5qU57+mg
	 zytScAhbAklW81iUoxknKfnq/+nXLG08KmgurR3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0886/1376] pps-gpio: remove dead capture_clear code
Date: Sat, 12 Sep 2026 08:55:12 +0200
Message-ID: <20260912065627.310588684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <calvin@wbinvd.org>

[ Upstream commit b899e0279f90c3ce4099d68b989dd27861cc5c4f ]

The capture_clear field is never set, and all code conditional on it being
set has been unreachable since the platform data logic was removed from
pps-gpio in ee89646619ba ("pps: clients: gpio: Get rid of legacy platform
data").

I think the only logical thing to do here is to remove it all, since no
in-tree code ever actually used it in the first place, and it has been
completely dead code for over five years (since v5.13).

Sashiko asked some questions about the gpiod_get_value() call which caused
me to look deeper and figure this out, but it did not actually notice
capture_clear is never set.

Link: https://lore.kernel.org/f70196bafcf75d9782dd36ed784e42345b6e8a1b.1783355507.git.calvin@wbinvd.org
Fixes: ee89646619ba ("pps: clients: gpio: Get rid of legacy platform data")
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Closes: https://sashiko.dev/#/patchset/cover.1779733602.git.calvin%40wbinvd.org?part=1
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps-gpio.c | 37 ++++------------------------------
 1 file changed, 4 insertions(+), 33 deletions(-)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 99b4ca57a3ab4..96e169a35cedb 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -32,7 +32,6 @@ struct pps_gpio_device_data {
 	struct gpio_desc *echo_pin;
 	struct timer_list echo_timer;	/* timer to reset echo active state */
 	bool assert_falling_edge;
-	bool capture_clear;
 	unsigned int echo_active_ms;	/* PPS echo active duration */
 	unsigned long echo_timeout;	/* timer timeout value in jiffies */
 	struct pps_event_time ts;	/* timestamp captured in hardirq */
@@ -62,19 +61,8 @@ static irqreturn_t pps_gpio_irq_hardirq(int irq, void *data)
 static irqreturn_t pps_gpio_irq_thread(int irq, void *data)
 {
 	struct pps_gpio_device_data *info = data;
-	int rising_edge;
-
-	rising_edge = info->capture_clear ?
-		      gpiod_get_value(info->gpio_pin) : !info->assert_falling_edge;
-	if ((rising_edge && !info->assert_falling_edge) ||
-			(!rising_edge && info->assert_falling_edge))
-		pps_event(info->pps, &info->ts, PPS_CAPTUREASSERT, data);
-	else if (info->capture_clear &&
-			((rising_edge && info->assert_falling_edge) ||
-			(!rising_edge && !info->assert_falling_edge)))
-		pps_event(info->pps, &info->ts, PPS_CAPTURECLEAR, data);
-	else
-		dev_warn_ratelimited(&info->pps->dev, "IRQ did not trigger any PPS event\n");
+
+	pps_event(info->pps, &info->ts, PPS_CAPTUREASSERT, data);
 
 	return IRQ_HANDLED;
 }
@@ -90,11 +78,6 @@ static void pps_gpio_echo(struct pps_device *pps, int event, void *data)
 		if (pps->params.mode & PPS_ECHOASSERT)
 			gpiod_set_value(info->echo_pin, 1);
 		break;
-
-	case PPS_CAPTURECLEAR:
-		if (pps->params.mode & PPS_ECHOCLEAR)
-			gpiod_set_value(info->echo_pin, 1);
-		break;
 	}
 
 	/* fire the timer */
@@ -156,15 +139,8 @@ static int pps_gpio_setup(struct device *dev)
 static unsigned long
 get_irqf_trigger_flags(const struct pps_gpio_device_data *data)
 {
-	unsigned long flags = data->assert_falling_edge ?
-		IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
-
-	if (data->capture_clear) {
-		flags |= ((flags & IRQF_TRIGGER_RISING) ?
-				IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING);
-	}
-
-	return flags;
+	return data->assert_falling_edge ? IRQF_TRIGGER_FALLING :
+					   IRQF_TRIGGER_RISING;
 }
 
 static int pps_gpio_probe(struct platform_device *pdev)
@@ -197,9 +173,6 @@ static int pps_gpio_probe(struct platform_device *pdev)
 	/* initialize PPS specific parts of the bookkeeping data structure. */
 	data->info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
 		PPS_ECHOASSERT | PPS_CANWAIT | PPS_TSFMT_TSPEC;
-	if (data->capture_clear)
-		data->info.mode |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR |
-			PPS_ECHOCLEAR;
 	data->info.owner = THIS_MODULE;
 	snprintf(data->info.name, PPS_MAX_NAME_LEN - 1, "%s.%d",
 		 pdev->name, pdev->id);
@@ -211,8 +184,6 @@ static int pps_gpio_probe(struct platform_device *pdev)
 
 	/* register PPS source */
 	pps_default_params = PPS_CAPTUREASSERT | PPS_OFFSETASSERT;
-	if (data->capture_clear)
-		pps_default_params |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR;
 	data->pps = pps_register_source(&data->info, pps_default_params);
 	if (IS_ERR(data->pps)) {
 		dev_err(dev, "failed to register IRQ %d as PPS source\n",
-- 
2.53.0



