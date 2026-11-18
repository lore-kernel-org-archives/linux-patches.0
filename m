Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019828;
	b=LNbLSM4ybV50s44kwXxA7aUXzlUOdw0ft+Lhq63jdW/g5j5m9f8B+xuNqRUzJpQyS8Ls
	 dNRU80hd8Aa7Cre6nqeMjpvZNwl3XlY2B0ZVdipZZOHLb3W8poaybkrtCyeXCy7pZ/dtO
	 J8yjPO/oTylTGjVpeYbMY3lSl0aye8/le4jKEFM2X62+Cw0D9klxAQDSuIagUcFaqLw3N
	 Dwq8Tu7RqF3cg5P5Rb5WnN3obg5kr38Oa6Zkwp4ueFtSGA5okCeitqCTnwANhjsS8ztA0
	 6GjtTJosbbJ+Fc/ilU5b9VCOpujNGKtG3otqyp+0OROTgVKnI3JI61kY8JwxfzSbKgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z0JsQogMpnaJaGodrVn7+wzCEaHIsYB58Kc3aLQmiMU=;
	b=xFIr3DspHFSQNMAdbwQuPqvBpT6FjK/13eOSzfGK5uclHFBPfcPcRDoY5PT1ifnbQllo
	 brd64RnPSjBaoRBlaIbVhZOB4zqFQsuMDwx4WYEyzOBmaWiyKdq8mccYRoEnkXvH+ZX2g
	 UkIkt0PWs5ks5q0AnCf6DHGBmehiz+Zc97NsPod+ZkE22hB0pclSo8p8+jGD2JlAKM0eM
	 G3udkNoeY4n7tQmSjSr4m3gFIBoUmvgLLUpWCrvMp3YD+xRgmKirghBFtOeXL0dc4rXVT
	 9DYRqVpWPhPxHcazc+VxSIDys83p1n2HTapwmmdf+d/2VT0AhABboh8fCNk1zSygLJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QLntyHUS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B524D60A2616;
	Wed, 18 Nov 2026 16:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QLntyHUS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044531F000C4;
	Wed, 18 Nov 2026 16:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019828;
	bh=z0JsQogMpnaJaGodrVn7+wzCEaHIsYB58Kc3aLQmiMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLntyHUS0zdbOwoIR9XWrkqKFokKB3ycf6bLDdhBxSwSGbgeXkLd6WRqflrMTPbkW
	 uY/n6me4wCFAlfYCoPiVVAEMFPYfsn9qiQiFTanY+tx4zK4h6HT/7U5wywcgg92tT8
	 0XFBMQdAMuQU+i/+zr8EeEShYjoKPj+hRyVK0VX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Keerthy <j-keerthy@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1734/2651] thermal/drivers/ti-soc-thermal: Cancel pending alert work on remove
Date: Wed, 18 Nov 2026 15:49:34 +0100
Message-ID: <20261118150350.033040784@linuxfoundation.org>
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

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit aaa6c8dec49339710f9fd2a2af5646cf4111dbd4 ]

On a threshold crossing, the talert IRQ handler calls
ti_thermal_report_sensor_temperature(), which queues the work embedded
in the sensor's ti_thermal_data on the system workqueue. Nothing ever
cancels or flushes that work.

ti_bandgap_remove() frees the talert IRQ last. free_irq() waits for a
running handler, but not for the work the handler has queued. When
remove returns, devres unregisters and frees the thermal zones and then
frees the devm-allocated ti_thermal_data, so a work item that is still
pending runs ti_thermal_work() on freed memory:

	ti_thermal_work()
	  data = container_of(work, struct ti_thermal_data, thermal_wq);
	  thermal_zone_device_update(data->ti_thermal, ...);

Free the talert IRQ before removing the sensors, so that no new work
can be queued, and cancel the work in ti_thermal_remove_sensor().

This needs an OMAP4460/4470 or OMAP5 SoC (DRA7 has TALERT but no
->report_temperature, so it never queues the work), a threshold crossing
just before the driver is unbound or unloaded, and the work still
pending when devres frees the data.

Found by static analysis tool CodeQL.

Fixes: 445eaf871bf9 ("staging: omap-thermal: common code to expose driver to thermal framework")
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Acked-by: Keerthy <j-keerthy@ti.com>
Link: https://patch.msgid.link/20260926124931.3599746-1-geoffreyhe2@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c        | 7 ++++---
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 4 ++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index ba43399d0b384..507fe67eaffae 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1077,6 +1077,10 @@ void ti_bandgap_remove(struct platform_device *pdev)
 	if (!soc_device_match(soc_no_cpu_notifier))
 		cpu_pm_unregister_notifier(&bgp->nb);
 
+	/* Stop the alerts first: they queue work on the sensors' data */
+	if (TI_BANDGAP_HAS(bgp, TALERT))
+		free_irq(bgp->irq, bgp);
+
 	/* Remove sensor interfaces */
 	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		if (bgp->conf->sensors[i].unregister_cooling)
@@ -1093,9 +1097,6 @@ void ti_bandgap_remove(struct platform_device *pdev)
 	clk_put(bgp->fclock);
 	clk_put(bgp->div_clk);
 
-	if (TI_BANDGAP_HAS(bgp, TALERT))
-		free_irq(bgp->irq, bgp);
-
 	if (TI_BANDGAP_HAS(bgp, TSHUT))
 		free_irq(gpiod_to_irq(bgp->tshut_gpiod), NULL);
 }
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 0cf0826b805a9..4bf3b2e0fc682 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -195,6 +195,10 @@ int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
 
+	/* Work queued by the talert IRQ must not outlive the data */
+	if (!IS_ERR_OR_NULL(data))
+		cancel_work_sync(&data->thermal_wq);
+
 	if (!IS_ERR_OR_NULL(data) && data->ti_thermal) {
 		if (data->our_zone)
 			thermal_zone_device_unregister(data->ti_thermal);
-- 
2.53.0



