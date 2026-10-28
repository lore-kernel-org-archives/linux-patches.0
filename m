Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214459;
	b=AmifrderSibbUKP/c1PFbj9WmSX9FuhBHNJF5KMLfdPSOHWnhG66FPVugBWHkUA2FsLM
	 RueuWKytnZrRtjzy7tAWJOimQ8kziZRD39iIiWcUDUFt5XQfEvxbaNa2x2NYeahfHGpS6
	 XZ8HpP9yI9Q5Ij3H9uBW0r4aLNC/yW37OaVE6AGJUn7WIoyUFb4HtrFKG34OisTXDv1NA
	 vX1ToUK6X0k5+CymA7IXBzaDujHAA26JuBMHiPAumwz+egha+IYehcIQYeswmeFrUq1EB
	 hDCTiyv0MKUTe6GMHzXkq+bjD/oGb33COIDrJATlMTFd3JpsOSgOTOTkC5LmbGquNIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2fTK8ogVDSQHOBQNUNXyP/mQ3Y+NElXFWtAKeTCITLs=;
	b=mXM4abFly1OpQxypl55BmkfcSYaYzkgo6ox7+KvXt/mDrAoNUfSMgEkHPcnJVi+KLW1S
	 PopsRsl7b50Q4ROyg/Cm4OfqFxbWxMW4ileX+y4IC00NXpynKF5gu6jvSFZRd/Y5ztT3F
	 J+zgjJUf9Qd5A2tC+Kh67R+Hy70QsdfsS+0PyrE4L8TYX4s8qR88EhrrO7MArl96BklwA
	 Lr6f8TZ7MASb6E1nmQT8Bo0i5EtSvhg/Ev7TNrU0oC7JnV1+FUseCOx3awec/kJm29nVS
	 Z9Edss/PVZeSEkJvl2ppqwnwYqwW3w/aXbs2j3UdyWbiRczSKf97Ij/MAfD0YbXQhQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5sBB05V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2380560A381A;
	Wed, 28 Oct 2026 19:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5sBB05V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7515F1F031E4;
	Wed, 28 Oct 2026 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214459;
	bh=2fTK8ogVDSQHOBQNUNXyP/mQ3Y+NElXFWtAKeTCITLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5sBB05V8Y7xHSvrLmWzAueF/3Ny3cBmD54Bj1vcYV6s2/OPXFDR4fGZBJ5XAcpUd
	 V5/9djS6UjTSkuXWPc0ug7mUT/avDWBi4erbXPp5pD47mNYAC79H/r1yYYYkFhDtii
	 W1jxpH8/3RMJLKrp4nRFOz0w/isswhb9fBE34o10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0867/1887] xen/events: remove some simple helpers from events_base.c
Date: Wed, 28 Oct 2026 17:49:23 +0100
Message-ID: <20261028170519.148818680@linuxfoundation.org>
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

[ Upstream commit 3bdb0ac350fe5e6301562143e4573971dd01ae0b ]

The helper functions type_from_irq() and cpu_from_irq() are just one
line functions used only internally.

Open code them where needed. At the same time modify and rename
get_evtchn_to_irq() to return a struct irq_info instead of the IRQ
number.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: 07ce121d93a5 ("xen/events: Return -EEXIST for bound VIRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 97 +++++++++++++-------------------
 1 file changed, 38 insertions(+), 59 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index a92b96b575757..72eace5842852 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -247,15 +247,6 @@ static int set_evtchn_to_irq(evtchn_port_t evtchn, unsigned int irq)
 	return 0;
 }
 
-static int get_evtchn_to_irq(evtchn_port_t evtchn)
-{
-	if (evtchn >= xen_evtchn_max_channels())
-		return -1;
-	if (evtchn_to_irq[EVTCHN_ROW(evtchn)] == NULL)
-		return -1;
-	return READ_ONCE(evtchn_to_irq[EVTCHN_ROW(evtchn)][EVTCHN_COL(evtchn)]);
-}
-
 /* Get info for IRQ */
 static struct irq_info *info_for_irq(unsigned irq)
 {
@@ -273,6 +264,19 @@ static void set_info_for_irq(unsigned int irq, struct irq_info *info)
 		irq_set_chip_data(irq, info);
 }
 
+static struct irq_info *evtchn_to_info(evtchn_port_t evtchn)
+{
+	int irq;
+
+	if (evtchn >= xen_evtchn_max_channels())
+		return NULL;
+	if (evtchn_to_irq[EVTCHN_ROW(evtchn)] == NULL)
+		return NULL;
+	irq = READ_ONCE(evtchn_to_irq[EVTCHN_ROW(evtchn)][EVTCHN_COL(evtchn)]);
+
+	return (irq < 0) ? NULL : info_for_irq(irq);
+}
+
 /* Per CPU channel accounting */
 static void channels_on_cpu_dec(struct irq_info *info)
 {
@@ -428,7 +432,9 @@ static evtchn_port_t evtchn_from_irq(unsigned int irq)
 
 unsigned int irq_from_evtchn(evtchn_port_t evtchn)
 {
-	return get_evtchn_to_irq(evtchn);
+	struct irq_info *info = evtchn_to_info(evtchn);
+
+	return info ? info->irq : -1;
 }
 EXPORT_SYMBOL_GPL(irq_from_evtchn);
 
@@ -472,25 +478,11 @@ static unsigned pirq_from_irq(unsigned irq)
 	return info->u.pirq.pirq;
 }
 
-static enum xen_irq_type type_from_irq(unsigned irq)
-{
-	return info_for_irq(irq)->type;
-}
-
-static unsigned cpu_from_irq(unsigned irq)
-{
-	return info_for_irq(irq)->cpu;
-}
-
 unsigned int cpu_from_evtchn(evtchn_port_t evtchn)
 {
-	int irq = get_evtchn_to_irq(evtchn);
-	unsigned ret = 0;
-
-	if (irq != -1)
-		ret = cpu_from_irq(irq);
+	struct irq_info *info = evtchn_to_info(evtchn);
 
-	return ret;
+	return info ? info->cpu : 0;
 }
 
 static void do_mask(struct irq_info *info, u8 reason)
@@ -539,13 +531,12 @@ static bool pirq_needs_eoi_flag(unsigned irq)
 static void bind_evtchn_to_cpu(evtchn_port_t evtchn, unsigned int cpu,
 			       bool force_affinity)
 {
-	int irq = get_evtchn_to_irq(evtchn);
-	struct irq_info *info = info_for_irq(irq);
+	struct irq_info *info = evtchn_to_info(evtchn);
 
-	BUG_ON(irq == -1);
+	BUG_ON(info == NULL);
 
 	if (IS_ENABLED(CONFIG_SMP) && force_affinity) {
-		struct irq_data *data = irq_get_irq_data(irq);
+		struct irq_data *data = irq_get_irq_data(info->irq);
 
 		irq_data_update_affinity(data, cpumask_of(cpu));
 		irq_data_update_effective_affinity(data, cpumask_of(cpu));
@@ -987,10 +978,10 @@ static void __unbind_from_irq(unsigned int irq)
 	}
 
 	if (VALID_EVTCHN(evtchn)) {
-		unsigned int cpu = cpu_from_irq(irq);
+		unsigned int cpu = info->cpu;
 		struct xenbus_device *dev;
 
-		switch (type_from_irq(irq)) {
+		switch (info->type) {
 		case IRQT_VIRQ:
 			per_cpu(virq_to_irq, cpu)[virq_from_irq(irq)] = -1;
 			break;
@@ -1214,15 +1205,16 @@ static int bind_evtchn_to_irq_chip(evtchn_port_t evtchn, struct irq_chip *chip,
 {
 	int irq;
 	int ret;
+	struct irq_info *info;
 
 	if (evtchn >= xen_evtchn_max_channels())
 		return -ENOMEM;
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	irq = get_evtchn_to_irq(evtchn);
+	info = evtchn_to_info(evtchn);
 
-	if (irq == -1) {
+	if (!info) {
 		irq = xen_allocate_irq_dynamic();
 		if (irq < 0)
 			goto out;
@@ -1245,8 +1237,8 @@ static int bind_evtchn_to_irq_chip(evtchn_port_t evtchn, struct irq_chip *chip,
 		 */
 		bind_evtchn_to_cpu(evtchn, 0, false);
 	} else {
-		struct irq_info *info = info_for_irq(irq);
-		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
+		WARN_ON(info->type != IRQT_EVTCHN);
+		irq = info->irq;
 	}
 
 out:
@@ -1585,13 +1577,7 @@ EXPORT_SYMBOL_GPL(xen_set_irq_priority);
 
 int evtchn_make_refcounted(evtchn_port_t evtchn)
 {
-	int irq = get_evtchn_to_irq(evtchn);
-	struct irq_info *info;
-
-	if (irq == -1)
-		return -ENOENT;
-
-	info = info_for_irq(irq);
+	struct irq_info *info = evtchn_to_info(evtchn);
 
 	if (!info)
 		return -ENOENT;
@@ -1606,7 +1592,6 @@ EXPORT_SYMBOL_GPL(evtchn_make_refcounted);
 
 int evtchn_get(evtchn_port_t evtchn)
 {
-	int irq;
 	struct irq_info *info;
 	int err = -ENOENT;
 
@@ -1615,11 +1600,7 @@ int evtchn_get(evtchn_port_t evtchn)
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	irq = get_evtchn_to_irq(evtchn);
-	if (irq == -1)
-		goto done;
-
-	info = info_for_irq(irq);
+	info = evtchn_to_info(evtchn);
 
 	if (!info)
 		goto done;
@@ -1639,10 +1620,11 @@ EXPORT_SYMBOL_GPL(evtchn_get);
 
 void evtchn_put(evtchn_port_t evtchn)
 {
-	int irq = get_evtchn_to_irq(evtchn);
-	if (WARN_ON(irq == -1))
+	struct irq_info *info = evtchn_to_info(evtchn);
+
+	if (WARN_ON(!info))
 		return;
-	unbind_from_irq(irq);
+	unbind_from_irq(info->irq);
 }
 EXPORT_SYMBOL_GPL(evtchn_put);
 
@@ -1672,12 +1654,10 @@ struct evtchn_loop_ctrl {
 
 void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl)
 {
-	int irq;
-	struct irq_info *info;
+	struct irq_info *info = evtchn_to_info(port);
 	struct xenbus_device *dev;
 
-	irq = get_evtchn_to_irq(port);
-	if (irq == -1)
+	if (!info)
 		return;
 
 	/*
@@ -1702,7 +1682,6 @@ void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl)
 		}
 	}
 
-	info = info_for_irq(irq);
 	if (xchg_acquire(&info->is_active, 1))
 		return;
 
@@ -1716,7 +1695,7 @@ void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl)
 		info->eoi_time = get_jiffies_64() + event_eoi_delay;
 	}
 
-	generic_handle_irq(irq);
+	generic_handle_irq(info->irq);
 }
 
 int xen_evtchn_do_upcall(void)
@@ -1774,7 +1753,7 @@ void rebind_evtchn_irq(evtchn_port_t evtchn, int irq)
 	mutex_lock(&irq_mapping_update_lock);
 
 	/* After resume the irq<->evtchn mappings are all cleared out */
-	BUG_ON(get_evtchn_to_irq(evtchn) != -1);
+	BUG_ON(evtchn_to_info(evtchn));
 	/* Expect irq to have been bound before,
 	   so there should be a proper type */
 	BUG_ON(info->type == IRQT_UNBOUND);
-- 
2.53.0



