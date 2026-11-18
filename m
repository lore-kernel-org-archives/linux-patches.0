Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056127;
	b=eOqWUOgVfQgu64LmWd1WGO32b78wcSRsFX0fMn9fNkmJ4NF/cJg/TIKG5iXGN6zvUrdd
	 TGmdkdJv92xcAQyCHcHl3Q3y24deUk+pgxIGHB5qmoSqc8945Z9s9jsnpQmWD00T2NQ8v
	 /pe/xRGHJkmxPNgRp4Fip7Cy2Zu4DmgRpFopEkJXarjjWDp58xvGMTLNENrcuPid6eXEg
	 xIU3yUS3P8Ol1UVuqmAQFTXgTq7jT9cFXdgFiGfWOGt/8zoPz3saYFkKSXGhsrZQ1TxvT
	 QV6wZoZ23XkjYC3WImSjXxx+7GnevTvy4HMyCKSV65bW42bXXmxYVYPO1DQtOjYeFmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aId3qaTG33a33fog45AzS/Nbt2w1alMUqj1cCKDzkFE=;
	b=Fj5Do5T0zKrHlCzQRa1V1QPZFxNGLsNh0CwSkDz7rlWO5HuyuhuQluJZ4N04GPZKk83d
	 GfAGa2R+AIEM+/rQwcTUtAZ+MDzCwLZPtdbJtRseD7+EfGzjS28b7E6FEZyEdkjXQJDqZ
	 D+Q2A+8tTJtrFqHHQtjgDOzBJawuR52nb/kB5tBNEg7Rxr+fDdMkdYytwg87alieDA0cy
	 YDMU4JCfSyR0uDCcttIXddMSInI2/T6OR1g2UiuNGIyE2ckV0SDiBmBKNvJzXfMJdcCtg
	 46xCGVYt/njAORJCHZjt8OoC6V6e5PV5+daa/4DVsFLs3heS4R23Iznmkw5YKjWGVXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZQmGUieD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7BF606A320;
	Thu, 19 Nov 2026 02:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZQmGUieD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6361F000C4;
	Thu, 19 Nov 2026 02:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056127;
	bh=aId3qaTG33a33fog45AzS/Nbt2w1alMUqj1cCKDzkFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQmGUieDhEq9VHh+hpHbrlufrQoR3BgQye/QAh5u4NqAqbgjkfh6d077qBMbRARqe
	 WxPUP6pISYTZYRdKmZ1i8cjrC3FGvJr5+7Xcxwp7kVci+Cl2Ata7u36qmWn+Q3Ajwp
	 TxkH87hM/onA34HsFb1BvbOue4gN0pmz/frATq9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Keerthy <j-keerthy@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1877/2214] thermal/drivers/ti-soc-thermal: Cancel pending alert work on remove
Date: Wed, 18 Nov 2026 15:59:13 +0100
Message-ID: <20261118150126.355552765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ea0603b59309f..84e04fc4095bd 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1077,6 +1077,10 @@ int ti_bandgap_remove(struct platform_device *pdev)
 	if (!soc_device_match(soc_no_cpu_notifier))
 		cpu_pm_unregister_notifier(&bgp->nb);
 
+	/* Stop the alerts first: they queue work on the sensors' data */
+	if (TI_BANDGAP_HAS(bgp, TALERT))
+		free_irq(bgp->irq, bgp);
+
 	/* Remove sensor interfaces */
 	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		if (bgp->conf->sensors[i].unregister_cooling)
@@ -1093,9 +1097,6 @@ int ti_bandgap_remove(struct platform_device *pdev)
 	clk_put(bgp->fclock);
 	clk_put(bgp->div_clk);
 
-	if (TI_BANDGAP_HAS(bgp, TALERT))
-		free_irq(bgp->irq, bgp);
-
 	if (TI_BANDGAP_HAS(bgp, TSHUT))
 		free_irq(gpiod_to_irq(bgp->tshut_gpiod), NULL);
 
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index f84375865c976..b7e274da59aa1 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -198,6 +198,10 @@ int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
 
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



