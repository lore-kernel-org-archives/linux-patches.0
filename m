Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061671;
	b=dARcgQnBoUO/vMzMXAUEXxdvZi8BeZUaQ0g+ZOtC0FRIA3FSWN5b6LjYT1cwuZFvEY0x
	 OT1+PJRsrjsbeqgO54ha5JEfmFGDL3NdCx5YE6Vz6LEllxDqdm+qiL9O+rIZYVqlUFVN3
	 Fl/zR8/bNUvApgTB6NMIypNmSxBPWWKE4njeQdjLngazS1z4MNByHcH3xSlyHNhR3w1Sg
	 tIf14R5yJzKijFyxHmb4sRLT3+oKiv64hRb2INlYYeV1pKkke4XkhXana9IYlCnrxiv/F
	 16jYNKRZAuPpjDWk1e96JrjLEoVRwlKjxKlJLWLyrDb2mbR/8YBr73O0TKgJe0QNmDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3OGB4D7J5DuIySt+k1U+mlwXdIGdSUGV5bcAGcFE+5E=;
	b=DmknR/Tsx9qRdRcZMM5zofs0SngCNEGwLhrywFx5z8TTnjiOhcHth63HBV1GuB83qTOv
	 qmOl5Xhynda99ioftXcHguDIm+kHVdvML0c0iH5ydDhpReH+VC9iRmdre5T1Ay9oPARci
	 4mvU7GdLFfWsJgE6vSTdH2szDiMIgC6S8HyrsiUVzxZp7dqJ0TUy6cB2WjyxO+5kp0SXu
	 BmEO4vzo3GCfW4TrNwFJVAcpg7IMPeF3pW0mR6DNE+pJ502IySOybPamkJuGOBx5F81RI
	 ML389xV73OOW3YGoaWEj79WVjeDEN3qMHZPJIEyg8/egKMJPoNGUorTLJ0sBbqvcvsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UywEzhiu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309B9606A330;
	Thu, 19 Nov 2026 04:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UywEzhiu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4661F000C5;
	Thu, 19 Nov 2026 04:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061671;
	bh=3OGB4D7J5DuIySt+k1U+mlwXdIGdSUGV5bcAGcFE+5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UywEzhiuRc0b7WXAL8tfg++t18gsbBxpwcD/4Z+KRQvWFvYoh9gQDe/Tuho8A3m+h
	 CMgAPB4aIy5RK++6ae9SMd6xgwl6FCzGx7qhyUXH3B8cRLt+CZ7brBEbhnko+FyCJD
	 X12OPTBBHKMMHisuQFwG/nj8vObHNK3XqxPv43f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Keerthy <j-keerthy@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1599/1848] thermal/drivers/ti-soc-thermal: Cancel pending alert work on remove
Date: Wed, 18 Nov 2026 16:00:37 +0100
Message-ID: <20261118150026.409285140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dcac99f327b08..24aa2160d2a6c 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1072,6 +1072,10 @@ int ti_bandgap_remove(struct platform_device *pdev)
 	if (!soc_device_match(soc_no_cpu_notifier))
 		cpu_pm_unregister_notifier(&bgp->nb);
 
+	/* Stop the alerts first: they queue work on the sensors' data */
+	if (TI_BANDGAP_HAS(bgp, TALERT))
+		free_irq(bgp->irq, bgp);
+
 	/* Remove sensor interfaces */
 	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		if (bgp->conf->sensors[i].unregister_cooling)
@@ -1088,9 +1092,6 @@ int ti_bandgap_remove(struct platform_device *pdev)
 	clk_put(bgp->fclock);
 	clk_put(bgp->div_clk);
 
-	if (TI_BANDGAP_HAS(bgp, TALERT))
-		free_irq(bgp->irq, bgp);
-
 	if (TI_BANDGAP_HAS(bgp, TSHUT))
 		free_irq(gpiod_to_irq(bgp->tshut_gpiod), NULL);
 
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 2ce4b19f312ac..da2beed006edd 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -196,6 +196,10 @@ int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
 
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



