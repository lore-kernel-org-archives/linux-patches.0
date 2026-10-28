Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214453;
	b=a7AhgPHW8cym7ZvRd+uNDoikmDaddULLPVEoI9zVv1uq73Oo0l6EYncRndS8fEj9EDBg
	 5pMj+55omR5uwuUpYZSpTS2+A+yaCM1Y3l/stnC3tSOlKUHDSg5uUMfmaBa9p5npcFS8y
	 5lD9cxcAYyhxX+dU+LFPZgVEzHgf22PRwgtrkNj5LiGPiQ1guvR2dU5RaR9V7821qzJym
	 p6aTKzzqP61lzacgO6LNjEVEVdhsa7LZugqSO6oAzpOevqdTWS+oCpCKOqKHkiROGSGcN
	 NQeGIOvYSdOvCBn4Vnq3RXjFKW91e1xj16xdTUOwJS+Zbx0Cj9dBkADJaoq1e/WaDdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g87ee+dFOk6UW5GnGFOEPtl6gGtMxjL6tzuxwURoMTw=;
	b=sJ+AhrejdBDXGg9FzKMU7CO1B2mEr7Bd+0SPN8H1EH+C/iDMSH0hc6Y1Tw7ZOhngrkMI
	 v8BDvU+BGAUXoVlNAgKaBL5B9k5QZVZIpVJUtsLLjbWWUsHhYThn7whYkhLLlCXsr7bdD
	 k28sbzubWq2i8ixRuANzd9AC6PxZ5Z8sQ7coex4ErNmJWmaVGTkcb3BvWIfy3E/8jmH8r
	 y57NapQcFxElGasIJodGZ4VA2uQXH75zirK+d0kBgdc4Eeec21YXyvGNAMe6dV4o/x3s4
	 aSL6fEQufnaY4kQKMVLvh7QYDdmGmF7BONw8B3YzHVuShafPPPrOelOKmhTYj64CRGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mzNBO3Cq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735CC60A260F;
	Wed, 28 Oct 2026 19:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mzNBO3Cq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35B21F01828;
	Wed, 28 Oct 2026 19:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214453;
	bh=g87ee+dFOk6UW5GnGFOEPtl6gGtMxjL6tzuxwURoMTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzNBO3CqhuBuyVJq8nHbX3GnoCd2qXOLlGDJGdKgc7uN6OknoAaEhNwsgfZBpt/5T
	 kfW/6xJ9uWXb639GUubGOtDgQNES0my5gSG4c3b6KKXlsL8Pf9zFEgAon/aBS0YtGy
	 fHsTgCYbqWNHKHbc3Ur4LzV8WA5mJEkIxfyMyuM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0865/1887] xen/events: avoid using info_for_irq() in xen_send_IPI_one()
Date: Wed, 28 Oct 2026 17:49:21 +0100
Message-ID: <20261028170519.101745930@linuxfoundation.org>
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

[ Upstream commit e64e7c74b99ec9e439abca75f522f4b98f220bd1 ]

xen_send_IPI_one() is being used by cpuhp_report_idle_dead() after
it calls rcu_report_dead(), meaning that any RCU usage by
xen_send_IPI_one() is a bad idea.

Unfortunately xen_send_IPI_one() is using notify_remote_via_irq()
today, which is using irq_get_chip_data() via info_for_irq(). And
irq_get_chip_data() in turn is using a maple-tree lookup requiring
RCU.

Avoid this problem by caching the ipi event channels in another
percpu variable, allowing the use notify_remote_via_evtchn() in
xen_send_IPI_one().

Fixes: 721255b9826b ("genirq: Use a maple tree for interrupt descriptor management")
Reported-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: 07ce121d93a5 ("xen/events: Return -EEXIST for bound VIRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 9052a4873bca8..b8dd604f82b41 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -163,6 +163,8 @@ static DEFINE_PER_CPU(int [NR_VIRQS], virq_to_irq) = {[0 ... NR_VIRQS-1] = -1};
 
 /* IRQ <-> IPI mapping */
 static DEFINE_PER_CPU(int [XEN_NR_IPIS], ipi_to_irq) = {[0 ... XEN_NR_IPIS-1] = -1};
+/* Cache for IPI event channels - needed for hot cpu unplug (avoid RCU usage). */
+static DEFINE_PER_CPU(evtchn_port_t [XEN_NR_IPIS], ipi_to_evtchn) = {[0 ... XEN_NR_IPIS-1] = 0};
 
 /* Event channel distribution data */
 static atomic_t channels_on_cpu[NR_CPUS];
@@ -365,6 +367,7 @@ static int xen_irq_info_ipi_setup(unsigned cpu,
 	info->u.ipi = ipi;
 
 	per_cpu(ipi_to_irq, cpu)[ipi] = irq;
+	per_cpu(ipi_to_evtchn, cpu)[ipi] = evtchn;
 
 	return xen_irq_info_common_setup(info, irq, IRQT_IPI, evtchn, 0);
 }
@@ -988,6 +991,7 @@ static void __unbind_from_irq(unsigned int irq)
 			break;
 		case IRQT_IPI:
 			per_cpu(ipi_to_irq, cpu)[ipi_from_irq(irq)] = -1;
+			per_cpu(ipi_to_evtchn, cpu)[ipi_from_irq(irq)] = 0;
 			break;
 		case IRQT_EVTCHN:
 			dev = info->u.interdomain;
@@ -1639,7 +1643,7 @@ EXPORT_SYMBOL_GPL(evtchn_put);
 
 void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector)
 {
-	int irq;
+	evtchn_port_t evtchn;
 
 #ifdef CONFIG_X86
 	if (unlikely(vector == XEN_NMI_VECTOR)) {
@@ -1650,9 +1654,9 @@ void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector)
 		return;
 	}
 #endif
-	irq = per_cpu(ipi_to_irq, cpu)[vector];
-	BUG_ON(irq < 0);
-	notify_remote_via_irq(irq);
+	evtchn = per_cpu(ipi_to_evtchn, cpu)[vector];
+	BUG_ON(evtchn == 0);
+	notify_remote_via_evtchn(evtchn);
 }
 
 struct evtchn_loop_ctrl {
-- 
2.53.0



