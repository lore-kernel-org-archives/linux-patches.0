Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053235;
	b=ZuV9GGZXkq3/motxNHxx98uev4dkFiex3PDT52P0V4uPvtH9CHo8z51Mkj8/nCAA2JQZ
	 5YQ67sgXe03etum5I8uf55rBOm5Lbj9wLHnkRRfUMEwFK6raszG4Rs8YM8uEVX3u/yKA1
	 d/WbWg1G/lwdiqEq0rkkRceRTpanGAfI8IxamYR5RcX6J6c3cOQtAMK+djvcTv1iP1FjB
	 gyGaJIE/l9osRkn/7vaCPF3C+bPds8Urz0kgf0tjkGir+WO19BqbiGEBDloZQHuUh+NnM
	 6ulx6NQtBF2UtBIgKEZMiMuz0Pj9S1dx4E1MKhErYzlN2dtyrW1KYkPdJSwpSOKUAYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zaJtv+8wa+Yb6NS0oRJdwHoWs8rqazI2HwK/UgZV4e8=;
	b=Imdpod5+wld44xYnqbAeWPKbuHkTgqcA8pVHjAIz1cfYJlCEBndJ1gtcKaumweOVpM0W
	 Em7qquLbdi3+r3zN1Z9dxFBsljToGzP9Fx22eWI79iw7JgfCKgNJMQPjD0W825/VpXxq+
	 UFuz7pp4rh7wwjFxfu6LA9CeAZ9MLwe6fHdFWURDE7AlvQ4VBaLOyMMyNXM1jeilBm+Qr
	 R/3lDrXzH+O4J8qEOYOFTD0eSmckcO56s6yiHiKWJE6tVrD5X2aq8XW+L5ird7p3YkBMf
	 7AMOgtE3YLCTkMf8LubjawN/TKEIy6UfRWhyh3rjBTiCuKnCfTbd0x6s91LSEBQzf3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XuYJNkyw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7467460A2604;
	Thu, 19 Nov 2026 01:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XuYJNkyw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B541F000C6;
	Thu, 19 Nov 2026 01:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053235;
	bh=zaJtv+8wa+Yb6NS0oRJdwHoWs8rqazI2HwK/UgZV4e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XuYJNkywq6lxyHgH/BiQoB2CnkY02tJTnBiObQKv6PEO37HZuNv0bG3CJeVRZkh9V
	 SH49G6r09Dh11R3J94FJwtffZaPesPfkDSCwJe9MwXYtP/WkwNUJKhv1RV1R7kCBC7
	 jJh2nSXs/5++3dXMjnINHML9hEROSwNzJmImgGao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franck Baur <franck.baur.67@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0848/2214] net: jme: keep RX MAC clock enabled for WoL
Date: Wed, 18 Nov 2026 15:42:04 +0100
Message-ID: <20261118150046.095006422@linuxfoundation.org>
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

From: Franck Baur <franck.baur.67@gmail.com>

[ Upstream commit ed9179fc7228315fb745dc3b111bae446e6894d2 ]

On the JMicron JMC250 revision 03, the MAC reset performed during
suspend leaves GPREG1_RXCLKOFF set. Although the driver enables Magic
Packet detection, the gated RX MAC clock prevents wake-up from ACPI S3.

Keep the RX MAC clock enabled while WoL is armed. Restore the gated
clock state immediately after disabling WoL during resume, preserving
the RX engine initialization ordering.

Prevent concurrent link-change work from gating the clock again after
WoL has been armed. Quiesce interrupt-driven link-change scheduling,
synchronize pending interrupts, and cancel outstanding link-change
work before programming WoL in suspend and shutdown paths.

Restore the deferred processing state before requesting link
reinitialization on resume.

Tested on an ASUS K42JE with JMC250 [197b:0250] rev 03 using a
Debian 6.12.111 kernel and an externally built module. ACPI S3 wake
with a Magic Packet completed in 19 seconds, while a control without
a Magic Packet resumed through the RTC alarm after 123 seconds.
Ethernet and SSH recovered after resume.

S4 and S5 wake behaviour has not been validated with this revision.

Fixes: 854a2e7c331a ("jme: Safer MAC processor reset sequence")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Franck Baur <franck.baur.67@gmail.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/jme.c | 37 ++++++++++++++++++++++++++++++++-----
 drivers/net/ethernet/jme.h |  1 +
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 06890993662ad..05d2d6983a48c 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -1501,7 +1501,8 @@ jme_intr_msi(struct jme_adapter *jme, u32 intrstat)
 		 * all other events are ignored
 		 */
 		jwrite32(jme, JME_IEVE, intrstat);
-		schedule_work(&jme->linkch_task);
+		if (!test_bit(JME_FLAG_WOL_QUIESCE, &jme->flags))
+			schedule_work(&jme->linkch_task);
 		goto out_reenable;
 	}
 
@@ -1545,7 +1546,8 @@ jme_intr_msi(struct jme_adapter *jme, u32 intrstat)
 	/*
 	 * Re-enable interrupt
 	 */
-	jwrite32f(jme, JME_IENS, INTR_ENABLE);
+	if (!test_bit(JME_FLAG_WOL_QUIESCE, &jme->flags))
+		jwrite32f(jme, JME_IENS, INTR_ENABLE);
 }
 
 static irqreturn_t
@@ -1891,6 +1893,7 @@ jme_powersave_phy(struct jme_adapter *jme)
 		jme_set_100m_half(jme);
 		if (jme->reg_pmcs & (PMCS_LFEN | PMCS_LREN))
 			jme_wait_link(jme);
+		jme_mac_rxclk_on(jme);
 		jme_clear_pm_enable_wol(jme);
 	} else {
 		jme_phy_off(jme);
@@ -3157,6 +3160,21 @@ jme_shutdown(struct pci_dev *pdev)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct jme_adapter *jme = netdev_priv(netdev);
 
+	if (netif_running(netdev)) {
+		set_bit(JME_FLAG_WOL_QUIESCE, &jme->flags);
+		netif_device_detach(netdev);
+		netif_stop_queue(netdev);
+		jme_stop_irq(jme);
+		synchronize_irq(pdev->irq);
+		jme_stop_irq(jme);
+		cancel_work_sync(&jme->linkch_task);
+		tasklet_disable(&jme->pcc_task);
+		napi_disable(&jme->napi);
+		tasklet_disable(&jme->txclean_task);
+		tasklet_disable(&jme->rxclean_task);
+		tasklet_disable(&jme->rxempty_task);
+	}
+
 	jme_powersave_phy(jme);
 	pci_pme_active(pdev, true);
 }
@@ -3171,11 +3189,16 @@ jme_suspend(struct device *dev)
 	if (!netif_running(netdev))
 		return 0;
 
-	atomic_dec(&jme->link_changing);
-
+	set_bit(JME_FLAG_WOL_QUIESCE, &jme->flags);
 	netif_device_detach(netdev);
 	netif_stop_queue(netdev);
 	jme_stop_irq(jme);
+	synchronize_irq(jme->pdev->irq);
+	jme_stop_irq(jme);
+	cancel_work_sync(&jme->linkch_task);
+	tasklet_disable(&jme->pcc_task);
+	napi_disable(&jme->napi);
+	atomic_dec(&jme->link_changing);
 
 	tasklet_disable(&jme->txclean_task);
 	tasklet_disable(&jme->rxclean_task);
@@ -3214,6 +3237,7 @@ jme_resume(struct device *dev)
 		return 0;
 
 	jme_clear_pm_disable_wol(jme);
+	jme_mac_rxclk_off(jme);
 	jme_phy_on(jme);
 	if (test_bit(JME_FLAG_SSET, &jme->flags))
 		jme_set_link_ksettings(netdev, &jme->old_cmd);
@@ -3225,8 +3249,11 @@ jme_resume(struct device *dev)
 
 	atomic_inc(&jme->link_changing);
 
-	jme_reset_link(jme);
+	napi_enable(&jme->napi);
+	tasklet_enable(&jme->pcc_task);
+	clear_bit(JME_FLAG_WOL_QUIESCE, &jme->flags);
 
+	jme_reset_link(jme);
 	jme_start_irq(jme);
 
 	return 0;
diff --git a/drivers/net/ethernet/jme.h b/drivers/net/ethernet/jme.h
index 2af76329b4a27..a1c9f24cc7809 100644
--- a/drivers/net/ethernet/jme.h
+++ b/drivers/net/ethernet/jme.h
@@ -452,6 +452,7 @@ enum jme_flags_bits {
 	JME_FLAG_SSET		= 2,
 	JME_FLAG_POLL		= 5,
 	JME_FLAG_SHUTDOWN	= 6,
+	JME_FLAG_WOL_QUIESCE	= 7,
 };
 
 #define TX_TIMEOUT		(5 * HZ)
-- 
2.53.0



