Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026476;
	b=s9NerCcOTOicDQkqdHmtfN66DfNF+H10dLHYKit9YhUfOj8GYO4OrAljqS+h1oJWWe2i
	 Q0+U+dTkHecGr22FPC0WJhUzD53mlVBEsT1kusLJhC1Ah3ogcTJH97i4tLp244GPkgbRF
	 AcKItXLfUGNQC04yUWgzlJFoVAPk7dE4CWu8qlB77YxPd6oG2tNHIHlTZqZXeazbzQnJV
	 lc+PdFSOkmyhGRvvNHB4oXuOVK5Sj3oOAPFd7yxpZJ3ffYrqt1xhxmElfDhVPqn08BKiP
	 kO8gA+Z7OsSPCKPK+SbaMB3F1KWhZeQqajmbL5U4/E/SbfMpB/EwwznAGQa+3d0dNsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4vs+/BnMZXe4K5glD0D7x8pfoWe6ZaXJQ0oqtvqbrSg=;
	b=IsrhQHpvaj+D5f9jZ7yNfeAEIFe/TcTKdrjfHDMIhj57a1Amnd5FNRZWP8L8JBQmM+Q6
	 GaF0ntbfbQtfr8fz0Ms23wmmDzMLHkNXw/DTcXfM4ILXidxWPTYet0DWNgmzM4W+K3m7+
	 +7x64s+e8yfLGYxarSCERdUR5kZHO8x6IFGi4cMuH/2laT+36wb3QdNLfwqm4RkMYIu0n
	 8yGWSaH1BuJNKnp+QnYPmvO7mTqI0VnlL8doa4w+COvXOKOF/X2OWja2580JwpWA8AdYK
	 ZdHSAz7BjfBLKFxE5j9OEa7wRju1opqzEahe/N8SzHqh1fYXWqxcageq+qhvhc7RIFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUbpwg5a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A6C606A325;
	Wed, 18 Nov 2026 18:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUbpwg5a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FD11F000C4;
	Wed, 18 Nov 2026 18:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026476;
	bh=4vs+/BnMZXe4K5glD0D7x8pfoWe6ZaXJQ0oqtvqbrSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUbpwg5aDZBegKk1B84jjMiVWteBwLVu6T+3jP5CQVsYbl1OJCm8JvwRDpaNU+OeG
	 XXj8n4Uw8V3J13ZWORUKXln9IWJB9JSWNIGQS85TMvQ/uxRkX1z47T3KfMEOl8gxmd
	 qsIisF0Y7V3l4peQ8flg3rLupNNteJAw2SvqcwX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Keerthy <j-keerthy@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1422/2151] thermal/drivers/ti-soc-thermal: Cancel pending alert work on remove
Date: Wed, 18 Nov 2026 15:52:37 +0100
Message-ID: <20261118150213.758453783@linuxfoundation.org>
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



