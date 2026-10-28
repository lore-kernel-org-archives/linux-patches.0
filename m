Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212795;
	b=eA0WQ5Dgz1bJhBDxn/eKSWypek79m0NwwFjLOUEiFgT2x6IAKVdykRcWszfPyhwbpSca
	 nSc5Vk3mAEkt92UtSeF+Kfq9/D4ug6XRgH6vK12aNYwqDonKp2bCluWevu8M19kjdEFQ6
	 5yVVbXgLOsA8HWQ282d/dNnMDnmSJm/Y57GN7vIsrMDovB9BLYCABhSNs1gzE138kTnhi
	 UHGIbooMb7A7hZaKq37oaOGO4HF50OXn/vRKssd3q2Z5/KQcEZssQKmeNsbMJGndhqbBY
	 AB/XGXzvcZfofyc17wcUr5l1SAXCAfd1m7gsOd/jPXSTf2QFppVi07xk2OAxr6VTB6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3rAsfQ6HquselH1lXYTyo5/XxBNl/4SoUFGJgNBEjtc=;
	b=fElQiLh8cbxHzXWwKYPudzY48yOMCb2MN+SHA/JEiFPk8B6omdpJwBZGvx2VE74e4uNj
	 o5+GK1daRJjz/jJGKDuO0/vNdJr2dyFQebPz2YCXgOJBll/kr0yQn5UVSRJxZQ/L+YzVl
	 DF+RPfAVAHFv1aRruvKdyuAB7XfVwoZIZlZFgukJvW1xvaLqwWLRZtx5IWTVRsm9j0vYa
	 hIwITlJ9+3A/Z2SDnq+PsGx0Wedqye9BVepS2TNgt+n8bp9KW2h2MUPAokbuhf1Y01tPx
	 dZgBIPKw1m4QkS60Z7qrYLh6L2l94KkdEaJ8moDGzHNGATfCueKiTQ/YVWPMX/KcivQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VqiPzXTN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C255B606A321;
	Wed, 28 Oct 2026 18:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VqiPzXTN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD041F01825;
	Wed, 28 Oct 2026 18:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212794;
	bh=3rAsfQ6HquselH1lXYTyo5/XxBNl/4SoUFGJgNBEjtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VqiPzXTND+3TUZxQdSPliVrmSL00ur0OVCiX2zVY2b3vM1+MsJYUIF6LCYBRycfWM
	 d0MNgmHi0ZAEt/Cja3Y8hdtEOXt8JHVDXPuy+8Z5xSqzfSE/vIcEWtb8MVJbw4AtsK
	 IPQ5yk9Q3OrmZnDy8aAHCWLSim7nFswry+6d46fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 6.1 0278/1887] usb: gadget: aspeed-vhub: cancel wake work on device removal
Date: Wed, 28 Oct 2026 17:39:34 +0100
Message-ID: <20261028170505.555838606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 20388c8d1d74c203fec8194c45cd31afdfab934e upstream.

wake_work is armed from the gadget .wakeup callback to resume suspended
downstream ports, and it is never cancelled in ast_vhub_remove(), so a
work item queued before or during removal can run after devm has freed
vhub and its ports, a use-after-free.

Cancelling the work alone is not sufficient: usb_gadget_wakeup() takes
no lock and the unbind path never clears wakeup_en, so a remote-wakeup
request in flight on another CPU can re-arm the work after the cancel
and before vhub is freed.

ast_vhub_del_dev() already clears d->registered under vhub->lock before
unregistering the gadget. Refuse the wakeup in ast_vhub_udc_wakeup()
once d->registered is clear: the check and the schedule_work() are then
atomic against the unbind, so a wakeup that passed before the flag was
cleared is drained by the cancel_work_sync() after the del_dev loop,
and one that arrives later returns without arming. Also move INIT_WORK()
to the top of ast_vhub_probe(), since the probe error path reuses
ast_vhub_remove() and would otherwise cancel a never-initialized work
item.

This issue was found by an in-house static analysis tool.

Fixes: 7ecca2a4080c ("usb/gadget: Add driver for Aspeed SoC virtual hub")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: https://patch.msgid.link/20260908041740.613713-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/aspeed-vhub/core.c |    4 ++++
 drivers/usb/gadget/udc/aspeed-vhub/dev.c  |    2 +-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c  |    5 +++--
 drivers/usb/gadget/udc/aspeed-vhub/vhub.h |    1 +
 4 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/aspeed-vhub/core.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/core.c
@@ -267,6 +267,9 @@ static int ast_vhub_remove(struct platfo
 	for (i = 0; i < vhub->max_ports; i++)
 		ast_vhub_del_dev(&vhub->ports[i].dev);
 
+	/* Final drain; the worker takes vhub->lock, so stay outside of it */
+	cancel_work_sync(&vhub->wake_work);
+
 	spin_lock_irqsave(&vhub->lock, flags);
 
 	/* Mask & ack all interrupts  */
@@ -327,6 +330,7 @@ static int ast_vhub_probe(struct platfor
 		return -ENOMEM;
 
 	spin_lock_init(&vhub->lock);
+	INIT_WORK(&vhub->wake_work, ast_vhub_wake_work);
 	vhub->pdev = pdev;
 	vhub->port_irq_mask = GENMASK(VHUB_IRQ_DEV1_BIT + vhub->max_ports - 1,
 				      VHUB_IRQ_DEV1_BIT);
--- a/drivers/usb/gadget/udc/aspeed-vhub/dev.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/dev.c
@@ -281,7 +281,7 @@ static int ast_vhub_udc_wakeup(struct us
 	int rc = -EINVAL;
 
 	spin_lock_irqsave(&d->vhub->lock, flags);
-	if (!d->wakeup_en)
+	if (!d->wakeup_en || !d->registered)
 		goto err;
 
 	DDBG(d, "Device initiated wakeup\n");
--- a/drivers/usb/gadget/udc/aspeed-vhub/hub.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/hub.c
@@ -558,7 +558,7 @@ void ast_vhub_device_connect(struct ast_
 		ast_vhub_send_host_wakeup(vhub);
 }
 
-static void ast_vhub_wake_work(struct work_struct *work)
+void ast_vhub_wake_work(struct work_struct *work)
 {
 	struct ast_vhub *vhub = container_of(work,
 					     struct ast_vhub,
@@ -588,6 +588,8 @@ static void ast_vhub_wake_work(struct wo
 
 void ast_vhub_hub_wake_all(struct ast_vhub *vhub)
 {
+	lockdep_assert_held(&vhub->lock);
+
 	/*
 	 * A device is trying to wake the world, because this
 	 * can recurse into the device, we break the call chain
@@ -1076,7 +1078,6 @@ static int ast_vhub_init_desc(struct ast
 int ast_vhub_init_hub(struct ast_vhub *vhub)
 {
 	vhub->speed = USB_SPEED_UNKNOWN;
-	INIT_WORK(&vhub->wake_work, ast_vhub_wake_work);
 
 	return ast_vhub_init_desc(vhub);
 }
--- a/drivers/usb/gadget/udc/aspeed-vhub/vhub.h
+++ b/drivers/usb/gadget/udc/aspeed-vhub/vhub.h
@@ -546,6 +546,7 @@ void ast_vhub_hub_suspend(struct ast_vhu
 void ast_vhub_hub_resume(struct ast_vhub *vhub);
 void ast_vhub_hub_reset(struct ast_vhub *vhub);
 void ast_vhub_hub_wake_all(struct ast_vhub *vhub);
+void ast_vhub_wake_work(struct work_struct *work);
 
 /* dev.c */
 int ast_vhub_init_dev(struct ast_vhub *vhub, unsigned int idx);


