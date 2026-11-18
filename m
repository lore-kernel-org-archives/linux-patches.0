Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023053;
	b=z/VTvwz/LDSnqnu/FR5ScwMC/w/82p/85WpmJq+emxmPw0xWvICbItPqwVsUP0Oruaf/
	 kRdhID6j3BLQ4WAs59YfIwKlytcv7yzJgpHo7jq/DtkkCWHFMVmnktys9rJlox5VUSyL1
	 MJ/GdzO5USuFIj/7VYzWgCmmQlw0OSpzQv5GCSA9znZL/hCQ0ihUOzI1UHbIPdhikjKWX
	 75q7q+NxeUp9NjlC2GgoKutkfSnCTW8pYnRuom/hV75tuyjlM4KxC7Ll0Hp6V43A0BOjh
	 JZcKE1cAnl88SFvo0EWcV9T757KLTekRaMh6xC6qTxvJkcn/E/8mEhqyL+4habWiy2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1oJZsvgJyGLhGXjDOCzCEnSErTZxAvwCPkpV7EqaLNM=;
	b=xE+HS/e/ZbNUqRvnJEq3jekOSVFMZxav0uEXHfRYU4/5DWbgVyVqFKeXDCMNuTvzHPKd
	 t28SFRwNDgcqlO4/9IEo+Qn1D2Au35g5Nsd7THzlsh9EW3PF/PrFlWyIPUYhsfostiAMB
	 HO8Du+uZiZaC5qbrouszZguab/mrs5aDhvERg046+Z9J/nTEj4l6jdezTdiVfbbFJpJxS
	 Q3g/pHDYJExeSFnKU/g469pIqxeGT2DlcJehRxQjMYrKiP3biHJ6+S9zpUJS9OkH22Kdm
	 hhJvSqCP/ulL0Uz8IWkR3rbdveWeNaBbe6BWmPF5eFaTaBpLAur0ndT9xAsmhsvYhng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=10XUuz2+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D800E606A320;
	Wed, 18 Nov 2026 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=10XUuz2+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399A71F000C4;
	Wed, 18 Nov 2026 17:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023053;
	bh=1oJZsvgJyGLhGXjDOCzCEnSErTZxAvwCPkpV7EqaLNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=10XUuz2+vSYKXe2Uyxk1q6cenv9U+wQ4e9kgOwhs7w5ODlSErTLuk9Txw/SgNTrI6
	 /7UZvsIIh4tWfhPM5ibo/dxZ1fyy29dn9YLG8YO+Idolr9HtQ2I5hTXeIUd1IcZBt0
	 nx5mTRS5POT9w4xqShTRdt9kM+eKcvcaQXTc8s8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerard Salvatella <gerard.salvatella@siemens.com>,
	Lukas Stockmann <lukas.stockmann@siemens.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0230/2151] wifi: wfx: fix possible device hang during init
Date: Wed, 18 Nov 2026 15:32:45 +0100
Message-ID: <20261118150130.158685682@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 102f54dc47be198e9310b18d41305a78d70a0796 ]

The WFxxx device provides an SDIO interface. In addition to the usual
in-band SDIO IRQ, the device also supports out-of-band IRQ line. OOB IRQ
requires a specific initialization described in commit f00dc1d789e1c
("staging: wfx: poll IRQ during init"):

    When the chip starts in SDIO mode, the external IRQ (aka Out-Of-Band
    IRQ) cannot be used before to configure it. Therefore, the first
    exchanges with the chip have to be done without the OOB IRQ.

    This patch allow to poll the data until the OOB IRQ is correctly
    setup. In order to keep the code simpler, this patch also poll data
    even if OOB IRQ is not used.

Commit 57aa557f110d9 ("staging: wfx: introduce a way to poll IRQ")
announce some limitation about the data polling mechanism:

    This function [wfx_bh_poll_irq()] must used with care: if an IRQ
    fires while the host reads control register, the IRQ can be lost.

However, with last analysis, it seems it does not only impact the IRQ.
When this condition happen the hardware is lost and won't reply the next
commands. The only way to recover the error is to pull the reset pin and
bind the device again.

Currently wfx_bh_poll_irq() is only used during the two first exchanges
with the hardware. Therefore, it has been reported to only happen after
a few hours of bind/rebind in a loop. This explain why it has not been
reported before.

Fortunately, wfx_bh_poll_irq() is only required for OOB IRQ, which is
probably very marginal. The In-Band IRQ case also uses this function,
but only to simplify the code.

This patch limits the use of wfx_bh_poll_irq() to the OOB IRQ. The bus
driver now tells wfx_probe() whether polling is necessary. When it is
not (in-band SDIO IRQ and SPI), the IRQ is subscribed before the first
exchange with the device and wfx_bh_poll_irq() is never called. When it
is (SDIO with OOB IRQ), the behavior is unchanged: the control register
is polled until the PDS file has configured the IRQ line.

To conclude, In-Band users are now safe. Users of OOB IRQ will be still
impacted by the bug, but there is nothing we can do (and nobody
complained during the last 6 years).

Fixes: f00dc1d789e1c ("staging: wfx: poll IRQ during init")
Reported-by: Gerard Salvatella <gerard.salvatella@siemens.com>
Reported-by: Lukas Stockmann <lukas.stockmann@siemens.com>
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Tested-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/20260901083548.113131-2-jerome.pouiller@silabs.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/silabs/wfx/bh.c       |  6 ++--
 drivers/net/wireless/silabs/wfx/bus_sdio.c |  1 +
 drivers/net/wireless/silabs/wfx/main.c     | 34 ++++++++++++++--------
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/silabs/wfx/bh.c b/drivers/net/wireless/silabs/wfx/bh.c
index 21dfdcf9cc273..0071659bc9c98 100644
--- a/drivers/net/wireless/silabs/wfx/bh.c
+++ b/drivers/net/wireless/silabs/wfx/bh.c
@@ -284,10 +284,10 @@ void wfx_bh_request_tx(struct wfx_dev *wdev)
 }
 
 /* If IRQ is not available, this function allow to manually poll the control register and simulate
- * an IRQ ahen an event happened.
+ * an IRQ when an event happened.
  *
- * Note that the device has a bug: If an IRQ raise while host read control register, the IRQ is
- * lost. So, use this function carefully (only duing device initialisation).
+ * Note that the device has a bug: If an IRQ raise while host read control register, the device is
+ * lost. Unfortunately, this is the only way to initialize the SDIO with out-of-band IRQ.
  */
 void wfx_bh_poll_irq(struct wfx_dev *wdev)
 {
diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/drivers/net/wireless/silabs/wfx/bus_sdio.c
index ab0793b9908f4..1ca2cc262feb2 100644
--- a/drivers/net/wireless/silabs/wfx/bus_sdio.c
+++ b/drivers/net/wireless/silabs/wfx/bus_sdio.c
@@ -279,6 +279,7 @@ static int wfx_sdio_probe(struct sdio_func *func, const struct sdio_device_id *i
 		goto sdio_release;
 	}
 
+	bus->core->poll_irq = !!bus->of_irq;
 	ret = wfx_probe(bus->core);
 	if (ret)
 		goto sdio_release;
diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wireless/silabs/wfx/main.c
index a61128debbadc..4ca874ad26433 100644
--- a/drivers/net/wireless/silabs/wfx/main.c
+++ b/drivers/net/wireless/silabs/wfx/main.c
@@ -362,7 +362,6 @@ int wfx_probe(struct wfx_dev *wdev)
 	 */
 	gpio_saved = wdev->pdata.gpio_wakeup;
 	wdev->pdata.gpio_wakeup = NULL;
-	wdev->poll_irq = true;
 
 	wdev->bh_wq = alloc_workqueue("wfx_bh_wq", WQ_HIGHPRI, 0);
 	if (!wdev->bh_wq)
@@ -370,16 +369,24 @@ int wfx_probe(struct wfx_dev *wdev)
 
 	wfx_bh_register(wdev);
 
+	if (!wdev->poll_irq) {
+		err = wdev->hwbus_ops->irq_subscribe(wdev->hwbus_priv);
+		if (err)
+			goto bh_unregister;
+	}
+
 	err = wfx_init_device(wdev);
 	if (err)
-		goto bh_unregister;
+		goto irq_unsubscribe;
+
+	if (wdev->poll_irq)
+		wfx_bh_poll_irq(wdev);
 
-	wfx_bh_poll_irq(wdev);
 	err = wait_for_completion_timeout(&wdev->firmware_ready, 1 * HZ);
 	if (err == 0) {
 		dev_err(wdev->dev, "timeout while waiting for startup indication\n");
 		err = -ETIMEDOUT;
-		goto bh_unregister;
+		goto irq_unsubscribe;
 	}
 
 	/* FIXME: fill wiphy::hw_version */
@@ -399,12 +406,12 @@ int wfx_probe(struct wfx_dev *wdev)
 		dev_err(wdev->dev, "unsupported firmware API version (expect 1 while firmware returns %d)\n",
 			wdev->hw_caps.api_version_major);
 		err = -EOPNOTSUPP;
-		goto bh_unregister;
+		goto irq_unsubscribe;
 	}
 
 	if (wdev->hw_caps.link_mode == SEC_LINK_ENFORCED) {
 		dev_err(wdev->dev, "chip require secure_link, but can't negotiate it\n");
-		goto bh_unregister;
+		goto irq_unsubscribe;
 	}
 
 	if (wdev->hw_caps.region_sel_mode) {
@@ -420,12 +427,14 @@ int wfx_probe(struct wfx_dev *wdev)
 	dev_dbg(wdev->dev, "sending configuration file %s\n", wdev->pdata.file_pds);
 	err = wfx_send_pdata_pds(wdev);
 	if (err < 0 && err != -ENOENT)
-		goto bh_unregister;
+		goto irq_unsubscribe;
 
-	wdev->poll_irq = false;
-	err = wdev->hwbus_ops->irq_subscribe(wdev->hwbus_priv);
-	if (err)
-		goto bh_unregister;
+	if (wdev->poll_irq) {
+		err = wdev->hwbus_ops->irq_subscribe(wdev->hwbus_priv);
+		if (err)
+			goto bh_unregister;
+		wdev->poll_irq = false;
+	}
 
 	err = wfx_hif_use_multi_tx_conf(wdev, true);
 	if (err)
@@ -474,7 +483,8 @@ int wfx_probe(struct wfx_dev *wdev)
 ieee80211_unregister:
 	ieee80211_unregister_hw(wdev->hw);
 irq_unsubscribe:
-	wdev->hwbus_ops->irq_unsubscribe(wdev->hwbus_priv);
+	if (!wdev->poll_irq)
+		wdev->hwbus_ops->irq_unsubscribe(wdev->hwbus_priv);
 bh_unregister:
 	wfx_bh_unregister(wdev);
 	destroy_workqueue(wdev->bh_wq);
-- 
2.53.0



