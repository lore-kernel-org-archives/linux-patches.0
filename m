Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590213;
	b=wLTJzrJp0lyzJDaxANbYfTd+zwP8KG5Q2rl8AZ8QPY0LyKakPTmOEXhLBWO96lCxmJDX
	 jI1DhK7Pv4T7CkA1Vm9E2n4Ad62imXliEnANO/MzW1XmCEY/Ijfpe8RKNnWix2xj87Ylw
	 0K5crfBoQu+Rysysv8riAw8pivPCaSEGHI1kF47Y72wnnAslq/Sf27lpmlKeTT9+yYWf1
	 zjR9rgOQGaimZlLl3rdcJl1jc9INKbaBgImQiZJ4uk4XRGYN9mYm7l/Mh+YVo8ldrMIRV
	 XqVvAGDm1r+0M+QGvOfv/W/JXmCHq4PbllmFc7ElWLu7huJTHEuV0n4moWbHk4LoS7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2uZdACkfQNb5+QSZstDG2osSLw/pRzU+A5fNU9TdaA=;
	b=EliepH8l6LASLbXYoLgFp0OEGXRaw1TbWGkOmGG4oNUAWNvUYQmy1+R/w0ZnHsQemCsM
	 u29jdDIVXIfhfG3XQB2trufZIg+VuPcUXaBdUKrx6wvhe/O3tCivdOXH1UFOVJwL7dhHE
	 09/fWiWARYaZ2QCIJIeeuZGvDOaqK5l3LoJDpfrmvf30GyFbULOSj2JT7NUZowDMxlFvy
	 s1LUmvsdvODDCbO0kAe+YpRdB64AtJdCYVnra52cZyLm9Cd2WIdO2S/kW+B+/y2roERkJ
	 Mkp4/uPgUyyqTlEnL3dGSwVSWorRvwr7knjmp3XPyZrGdvRRu9ojQO4Pr+MQxzv6Ebg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gya1v8oR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726DA606BD1D;
	Fri, 13 Nov 2026 17:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gya1v8oR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5E51F000C5;
	Fri, 13 Nov 2026 17:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590213;
	bh=s2uZdACkfQNb5+QSZstDG2osSLw/pRzU+A5fNU9TdaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gya1v8oReJ6NBg7Oz2nzRXFpNZzXfjxjAafmRrwMXzlOIU6nWDO5jjDcXH32toYdj
	 wNFRCGTlkQTE2bSC8pp18GZhv+5S1tIwgU3DxrPX/GvlBlle6aK521oit2UaeoKe4O
	 tUczAB0ECYIUM6NzdNte3ziLP/pONzVSUAaBPL14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franck Baur <franck.baur.67@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 215/686] net: jme: keep RX MAC clock enabled for WoL
Date: Fri, 13 Nov 2026 10:45:48 -0500
Message-ID: <20261113153828.317730377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index d8be0e4dcb072..6cfcfda055545 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -1502,7 +1502,8 @@ jme_intr_msi(struct jme_adapter *jme, u32 intrstat)
 		 * all other events are ignored
 		 */
 		jwrite32(jme, JME_IEVE, intrstat);
-		schedule_work(&jme->linkch_task);
+		if (!test_bit(JME_FLAG_WOL_QUIESCE, &jme->flags))
+			schedule_work(&jme->linkch_task);
 		goto out_reenable;
 	}
 
@@ -1546,7 +1547,8 @@ jme_intr_msi(struct jme_adapter *jme, u32 intrstat)
 	/*
 	 * Re-enable interrupt
 	 */
-	jwrite32f(jme, JME_IENS, INTR_ENABLE);
+	if (!test_bit(JME_FLAG_WOL_QUIESCE, &jme->flags))
+		jwrite32f(jme, JME_IENS, INTR_ENABLE);
 }
 
 static irqreturn_t
@@ -1892,6 +1894,7 @@ jme_powersave_phy(struct jme_adapter *jme)
 		jme_set_100m_half(jme);
 		if (jme->reg_pmcs & (PMCS_LFEN | PMCS_LREN))
 			jme_wait_link(jme);
+		jme_mac_rxclk_on(jme);
 		jme_clear_pm_enable_wol(jme);
 	} else {
 		jme_phy_off(jme);
@@ -3158,6 +3161,21 @@ jme_shutdown(struct pci_dev *pdev)
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
@@ -3172,11 +3190,16 @@ jme_suspend(struct device *dev)
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
@@ -3215,6 +3238,7 @@ jme_resume(struct device *dev)
 		return 0;
 
 	jme_clear_pm_disable_wol(jme);
+	jme_mac_rxclk_off(jme);
 	jme_phy_on(jme);
 	if (test_bit(JME_FLAG_SSET, &jme->flags))
 		jme_set_link_ksettings(netdev, &jme->old_cmd);
@@ -3226,8 +3250,11 @@ jme_resume(struct device *dev)
 
 	atomic_inc(&jme->link_changing);
 
-	jme_reset_link(jme);
+	napi_enable(&jme->napi);
+	tasklet_enable(&jme->pcc_task);
+	clear_bit(JME_FLAG_WOL_QUIESCE, &jme->flags);
 
+	jme_reset_link(jme);
 	jme_start_irq(jme);
 
 	return 0;
diff --git a/drivers/net/ethernet/jme.h b/drivers/net/ethernet/jme.h
index 860494ff37144..ec5dfddf73227 100644
--- a/drivers/net/ethernet/jme.h
+++ b/drivers/net/ethernet/jme.h
@@ -450,6 +450,7 @@ enum jme_flags_bits {
 	JME_FLAG_SSET		= 2,
 	JME_FLAG_POLL		= 5,
 	JME_FLAG_SHUTDOWN	= 6,
+	JME_FLAG_WOL_QUIESCE	= 7,
 };
 
 #define TX_TIMEOUT		(5 * HZ)
-- 
2.53.0



