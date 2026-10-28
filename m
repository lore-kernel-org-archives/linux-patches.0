Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214456;
	b=Z7+o5Y7yGoC1PrNVHEbxTO54A4mmhFa8edaNg7f5UWPCVPOlDiLAA+e1Lph7R0s3TeAD
	 5t0Y5KwTIbtdxPFAu+WU6XCdTMLpYVDNpK6Tf2DAszy0BhS2HkuSLfzmcdRuBJINzBN5A
	 hWOZPOeTlW7Ypp4ltUaelzkT/9SdPwO2JeR2MwObLcprKfYR/KjIBZBCC0IUMry4tFOxg
	 cBOiIWrX2LEePyEedbE4xbtcdkdLAbC5k/9vlqMDyXVo02WdGnS2LUfkSBtjLBDYLh/N2
	 PnFGbrVKdfmB9bf/YxNdL8u3pNwqQEzoQFc6k6v6LZ/ut/6Kp+JBo+nvg1wd8rhZxRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IZkFPGu10u3+pCKVdl710APhtzGoVvZKeYV/OtByecQ=;
	b=iczddiI+PXXljznfe3PQTLrqTbtaKuLnskUCex5EissTXQALOOcCjVuhyQXDXK925Vor
	 4iKZwAzzbwYC+DXN9wL6WbZQSum0MHQKazEYOQx+jxu1ULSSDuzscHX5jacFrkUpqgNoe
	 3BRFpa5w40MJw1m1EUy96UtX6Q98HewuekEcSxcZINWETeo5EX34hZ9m+BVt7mTC1cNHR
	 oGD30hqGTZvBKRDX8/t2H7cxPa8rbOMufYiVCOz0ah749htCUhBb/pZn9k8QTMEJxUnqG
	 sBQP6ABxaMZ68Pki55n7TBULdhpV24SQvhdL/kQnN8A4hTOL5lJkD+kOrotrHWvpiZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9Orpolv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C835606A32F;
	Wed, 28 Oct 2026 19:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9Orpolv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D27A1F01825;
	Wed, 28 Oct 2026 19:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214456;
	bh=IZkFPGu10u3+pCKVdl710APhtzGoVvZKeYV/OtByecQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9Orpolv055zRSZFokJgzPC3BXqwWbQXWcp4PPQ1Nc6KtrM1Q0TmVHFY+wI2TkPpk
	 SJ2J0as3YRH1Z+OTJ7yYANQFvxZr9Eza6nmAg0G+1ErPjgs7SMo6UU3IIEgXsO9Z3F
	 btZ5MP6l226LpRS8l7o4B5qydoST35/8ho1rIivo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0866/1887] xen/events: reduce externally visible helper functions
Date: Wed, 28 Oct 2026 17:49:22 +0100
Message-ID: <20261028170519.125292410@linuxfoundation.org>
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

[ Upstream commit 686464514fbebb6c8de4415238319e414c3500a4 ]

get_evtchn_to_irq() has only one external user while irq_from_evtchn()
provides the same functionality and is exported for a wider user base.
Modify the only external user of get_evtchn_to_irq() to use
irq_from_evtchn() instead and make get_evtchn_to_irq() static.

evtchn_from_irq() and irq_from_virq() have a single external user and
can easily be combined to a new helper irq_evtchn_from_virq() allowing
to drop irq_from_virq() and to make evtchn_from_irq() static.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: 07ce121d93a5 ("xen/events: Return -EEXIST for bound VIRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_2l.c       |  8 ++++----
 drivers/xen/events/events_base.c     | 13 +++++++++----
 drivers/xen/events/events_internal.h |  1 -
 include/xen/events.h                 |  4 ++--
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2l.c
index b8f2f971c2f0f..e3585330cf98b 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -171,11 +171,11 @@ static void evtchn_2l_handle_events(unsigned cpu, struct evtchn_loop_ctrl *ctrl)
 	int i;
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
+	evtchn_port_t evtchn;
 
 	/* Timer interrupt has highest priority. */
-	irq = irq_from_virq(cpu, VIRQ_TIMER);
+	irq = irq_evtchn_from_virq(cpu, VIRQ_TIMER, &evtchn);
 	if (irq != -1) {
-		evtchn_port_t evtchn = evtchn_from_irq(irq);
 		word_idx = evtchn / BITS_PER_LONG;
 		bit_idx = evtchn % BITS_PER_LONG;
 		if (active_evtchns(cpu, s, word_idx) & (1ULL << bit_idx))
@@ -328,9 +328,9 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
 	for (i = 0; i < EVTCHN_2L_NR_CHANNELS; i++) {
 		if (sync_test_bit(i, BM(sh->evtchn_pending))) {
 			int word_idx = i / BITS_PER_EVTCHN_WORD;
-			printk("  %d: event %d -> irq %d%s%s%s\n",
+			printk("  %d: event %d -> irq %u%s%s%s\n",
 			       cpu_from_evtchn(i), i,
-			       get_evtchn_to_irq(i),
+			       irq_from_evtchn(i),
 			       sync_test_bit(word_idx, BM(&v->evtchn_pending_sel))
 			       ? "" : " l2-clear",
 			       !sync_test_bit(i, BM(sh->evtchn_mask))
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index b8dd604f82b41..a92b96b575757 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -247,7 +247,7 @@ static int set_evtchn_to_irq(evtchn_port_t evtchn, unsigned int irq)
 	return 0;
 }
 
-int get_evtchn_to_irq(evtchn_port_t evtchn)
+static int get_evtchn_to_irq(evtchn_port_t evtchn)
 {
 	if (evtchn >= xen_evtchn_max_channels())
 		return -1;
@@ -414,7 +414,7 @@ static void xen_irq_info_cleanup(struct irq_info *info)
 /*
  * Accessors for packed IRQ information.
  */
-evtchn_port_t evtchn_from_irq(unsigned irq)
+static evtchn_port_t evtchn_from_irq(unsigned int irq)
 {
 	const struct irq_info *info = NULL;
 
@@ -432,9 +432,14 @@ unsigned int irq_from_evtchn(evtchn_port_t evtchn)
 }
 EXPORT_SYMBOL_GPL(irq_from_evtchn);
 
-int irq_from_virq(unsigned int cpu, unsigned int virq)
+int irq_evtchn_from_virq(unsigned int cpu, unsigned int virq,
+			 evtchn_port_t *evtchn)
 {
-	return per_cpu(virq_to_irq, cpu)[virq];
+	int irq = per_cpu(virq_to_irq, cpu)[virq];
+
+	*evtchn = evtchn_from_irq(irq);
+
+	return irq;
 }
 
 static enum ipi_vector ipi_from_irq(unsigned irq)
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/events_internal.h
index 4d3398eff9cdf..19ae31695edcf 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -33,7 +33,6 @@ struct evtchn_ops {
 
 extern const struct evtchn_ops *evtchn_ops;
 
-int get_evtchn_to_irq(evtchn_port_t evtchn);
 void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl);
 
 unsigned int cpu_from_evtchn(evtchn_port_t evtchn);
diff --git a/include/xen/events.h b/include/xen/events.h
index b303bd24e2a6c..07184beaa0a5c 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -102,8 +102,8 @@ void xen_poll_irq_timeout(int irq, u64 timeout);
 
 /* Determine the IRQ which is bound to an event channel */
 unsigned int irq_from_evtchn(evtchn_port_t evtchn);
-int irq_from_virq(unsigned int cpu, unsigned int virq);
-evtchn_port_t evtchn_from_irq(unsigned irq);
+int irq_evtchn_from_virq(unsigned int cpu, unsigned int virq,
+			 evtchn_port_t *evtchn);
 
 int xen_set_callback_via(uint64_t via);
 int xen_evtchn_do_upcall(void);
-- 
2.53.0



