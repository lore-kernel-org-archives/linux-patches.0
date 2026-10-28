Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214462;
	b=gB0eNCGRWDr0t/riwP7ZondT3ty7RGpOGbmZFJ59hd7ONWs41zxTdvWxthCz7y/l1ezk
	 KwFipeMk7hWvRlECLyMt+prT5dYuaLQevJ5OcW6b2X7/OgQ4xVRwoIkQH9KTne8hvrNhs
	 R5cIKbgYscPU7f6WkEnUCh9qBXFmTOTFQnLrpuyk8zi9kD0+FtfUclKFF3Fs4Tjc4mOgG
	 7RgmSKyrkW1CIY3W7RH+jdfAkMaNncow6aKJvtE/jcsT2PLQjW6tFI4ISat6X42n1FEA9
	 UEOQJKUiornrdnELG0dS3KyAmnnJp6irDa8PjlEPmdqlOqJasMFbjdISY6vyZD0Kvpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WUCxNuNeDlfETojzxMM8Z4lg8A3oeJHpwpQ+mH4U8GE=;
	b=JxWDuwop3SGaX3jXCZwMxhZjZis7wr67thUfxRTWbjRIjgulO9UG/LocZzuggI7/MIVU
	 qnKRZUY//AR3+KhydyHzAyhoX6U49vDb1aqTJRCITib7lfrHCLsM5tjOrUWfRiBp0TMqJ
	 mCyy2zzeG5H3gV+k2texRTjFiRgXpfHurQXgtVc3wZyIssPIUXFHA2oeOIjcrNvJJrZfB
	 mxhBv/QzA7LYQrQtdL0YbjLCHteJYJGByaDQzPWUTMhCvQzKnRlimMZt7vo1XJ2sgP6Wr
	 g2zmEeXGwsgfvAyKgmzlPVWeJVYoYfNAgyCDW3M4xtIH3CHfoVc+pFcYjkV6BJs2jvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tx5pHzT9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A0A60A6F41;
	Wed, 28 Oct 2026 19:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tx5pHzT9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF6F1F031E7;
	Wed, 28 Oct 2026 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214461;
	bh=WUCxNuNeDlfETojzxMM8Z4lg8A3oeJHpwpQ+mH4U8GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tx5pHzT9qL55h32UFo2P1PyxQhaKCQuX70B1akXwjcZ8OFr5NEMtyS2bQuenGkrKv
	 esZMrG5VxYSgM/Q4p+48hYwE9mi3O2jQ1KM+o8mBQ4Sl/ZqRw1AqskMtNnJ9b/DOw0
	 Z5C1ds8MDRlFrkb9e2pQW6YK7nmzWi8Lpr5phqFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0868/1887] xen/events: drop xen_allocate_irqs_dynamic()
Date: Wed, 28 Oct 2026 17:49:24 +0100
Message-ID: <20261028170519.170973894@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 5dd9ad32d7758b1a76742f394acf0eb3ac8a636a ]

Instead of having a common function for allocating a single IRQ or a
consecutive number of IRQs, split up the functionality into the callers
of xen_allocate_irqs_dynamic().

This allows to handle any allocation error in xen_irq_init() gracefully
instead of panicing the system. Let xen_irq_init() return the irq_info
pointer or NULL in case of an allocation error.

Additionally set the IRQ into irq_info already at allocation time, as
otherwise the IRQ would be '0' (which is a valid IRQ number) until
being set.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: 07ce121d93a5 ("xen/events: Return -EEXIST for bound VIRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 74 +++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 72eace5842852..fa1c5d7f4aded 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -303,6 +303,13 @@ static void channels_on_cpu_inc(struct irq_info *info)
 	info->is_accounted = 1;
 }
 
+static void xen_irq_free_desc(unsigned int irq)
+{
+	/* Legacy IRQ descriptors are managed by the arch. */
+	if (irq >= nr_legacy_irqs())
+		irq_free_desc(irq);
+}
+
 static void delayed_free_irq(struct work_struct *work)
 {
 	struct irq_info *info = container_of(to_rcu_work(work), struct irq_info,
@@ -314,9 +321,7 @@ static void delayed_free_irq(struct work_struct *work)
 
 	kfree(info);
 
-	/* Legacy IRQ descriptors are managed by the arch. */
-	if (irq >= nr_legacy_irqs())
-		irq_free_desc(irq);
+	xen_irq_free_desc(irq);
 }
 
 /* Constructors for packed IRQ information. */
@@ -331,7 +336,6 @@ static int xen_irq_info_common_setup(struct irq_info *info,
 	BUG_ON(info->type != IRQT_UNBOUND && info->type != type);
 
 	info->type = type;
-	info->irq = irq;
 	info->evtchn = evtchn;
 	info->cpu = cpu;
 	info->mask_reason = EVT_MASK_REASON_EXPLICIT;
@@ -732,47 +736,45 @@ void xen_irq_lateeoi(unsigned int irq, unsigned int eoi_flags)
 }
 EXPORT_SYMBOL_GPL(xen_irq_lateeoi);
 
-static void xen_irq_init(unsigned irq)
+static struct irq_info *xen_irq_init(unsigned int irq)
 {
 	struct irq_info *info;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (info == NULL)
-		panic("Unable to allocate metadata for IRQ%d\n", irq);
+	if (info) {
+		info->irq = irq;
+		info->type = IRQT_UNBOUND;
+		info->refcnt = -1;
+		INIT_RCU_WORK(&info->rwork, delayed_free_irq);
 
-	info->type = IRQT_UNBOUND;
-	info->refcnt = -1;
-	INIT_RCU_WORK(&info->rwork, delayed_free_irq);
+		set_info_for_irq(irq, info);
+		/*
+		 * Interrupt affinity setting can be immediate. No point
+		 * in delaying it until an interrupt is handled.
+		 */
+		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 
-	set_info_for_irq(irq, info);
-	/*
-	 * Interrupt affinity setting can be immediate. No point
-	 * in delaying it until an interrupt is handled.
-	 */
-	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
+		INIT_LIST_HEAD(&info->eoi_list);
+		list_add_tail(&info->list, &xen_irq_list_head);
+	}
 
-	INIT_LIST_HEAD(&info->eoi_list);
-	list_add_tail(&info->list, &xen_irq_list_head);
+	return info;
 }
 
-static int __must_check xen_allocate_irqs_dynamic(int nvec)
+static inline int __must_check xen_allocate_irq_dynamic(void)
 {
-	int i, irq = irq_alloc_descs(-1, 0, nvec, -1);
+	int irq = irq_alloc_desc_from(0, -1);
 
 	if (irq >= 0) {
-		for (i = 0; i < nvec; i++)
-			xen_irq_init(irq + i);
+		if (!xen_irq_init(irq)) {
+			xen_irq_free_desc(irq);
+			irq = -1;
+		}
 	}
 
 	return irq;
 }
 
-static inline int __must_check xen_allocate_irq_dynamic(void)
-{
-
-	return xen_allocate_irqs_dynamic(1);
-}
-
 static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 {
 	int irq;
@@ -792,7 +794,10 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 	else
 		irq = irq_alloc_desc_at(gsi, -1);
 
-	xen_irq_init(irq);
+	if (!xen_irq_init(irq)) {
+		xen_irq_free_desc(irq);
+		irq = -1;
+	}
 
 	return irq;
 }
@@ -971,6 +976,11 @@ static void __unbind_from_irq(unsigned int irq)
 	evtchn_port_t evtchn = evtchn_from_irq(irq);
 	struct irq_info *info = info_for_irq(irq);
 
+	if (!info) {
+		xen_irq_free_desc(irq);
+		return;
+	}
+
 	if (info->refcnt > 0) {
 		info->refcnt--;
 		if (info->refcnt != 0)
@@ -1107,11 +1117,14 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	irq = xen_allocate_irqs_dynamic(nvec);
+	irq = irq_alloc_descs(-1, 0, nvec, -1);
 	if (irq < 0)
 		goto out;
 
 	for (i = 0; i < nvec; i++) {
+		if (!xen_irq_init(irq + i))
+			goto error_irq;
+
 		irq_set_chip_and_handler_name(irq + i, &xen_pirq_chip, handle_edge_irq, name);
 
 		ret = xen_irq_info_pirq_setup(irq + i, 0, pirq + i, 0, domid,
@@ -1758,6 +1771,7 @@ void rebind_evtchn_irq(evtchn_port_t evtchn, int irq)
 	   so there should be a proper type */
 	BUG_ON(info->type == IRQT_UNBOUND);
 
+	info->irq = irq;
 	(void)xen_irq_info_evtchn_setup(irq, evtchn, NULL);
 
 	mutex_unlock(&irq_mapping_update_lock);
-- 
2.53.0



