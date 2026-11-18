Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016710;
	b=gMso6iHDZePyJ2E1sBNCdgrgvZOEvOIbc7SqkxsZfag9OvCbOuUVrWyant28ApS1SlTS
	 k05kOuE2eHqYrEGsX/3WjKD4J95gRg6NgKwpEeTx5Va9pKH5FY2s/PCgw7gNNpj0Zk5hF
	 5BQG7p19BB+km0DTkkk+wU0Rvu8emkc4oGw2vDkWfsegJDqwk/xyLpmvA6dJTItEKMgoL
	 WUrMR5V4F2DEDuQnGTchCppNdcFWhrrvLdZQTlSrL7cWROIJlefepHxu5sZzJrE66yu60
	 BlTJycMvQurSqAcC/wdefxVARG2qb0zKv4FwtWuXtGm0IcGzFPv10InYCycJB+vmOsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ucawSdqz3pEFssckPvWH/GJzfzwOvISadVehPOuEzq4=;
	b=jPwLqGrLVvPcnuxmGxDaQoTx/vQjq+VS3lhgDQibtjUxJQ8neyCfLUHljtgJzELR71gk
	 B8it/w6mPUJf3eCCY0y/5PYdcQmuFNDDPhCNOBSkXgE+t9kxql4mgIp6O8ocbjWEkW/G9
	 G98kCN3Kzioj7tnSf+e6ET/XbU8i9SywwvWfCU+hW5PZPsHGhnljv2EBLhfZh1O/pxcx/
	 o872iKeDtTMFHvizFP34Wo5KOm0h17l+aqTWVrJ96aonhNjJ/Aq3pFYB/8N/NoAyn59IH
	 UODP83qb7yrNkAtJT0vT55e1S8NKENKbPLY1QrAmoJonqz0/HM0L9GRm/UuG5bKQQ5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVc3rg7k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51401606A336;
	Wed, 18 Nov 2026 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVc3rg7k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6A41F000C4;
	Wed, 18 Nov 2026 15:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016709;
	bh=ucawSdqz3pEFssckPvWH/GJzfzwOvISadVehPOuEzq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVc3rg7kXv12UgyQLhdEmKQqOXL7NdfxUfdFoWrFBA5lWX/yxAYmgl1mN+uuVpskq
	 Ze3PkPk0WRETmbDLKwxJSEYubHDsH6opesxUeJGRgclI5a5STGYJmnHurfOZGDW8DW
	 9m9UoeTRW7g6/9QxJ6rCxPwr910ECSdXV6NF7FtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0625/2651] i3c: mipi-i3c-hci: Stop rings gracefully when suspending
Date: Wed, 18 Nov 2026 15:31:05 +0100
Message-ID: <20261118150310.194263299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 9796ccba1254f6bd3b7e6b650ad28ffc56daf6e9 ]

hci_dma_suspend() tore the rings down with a single write of zero to
RH_RING_CONTROL, clearing the RS and ENABLE fields together and without
waiting for the ring to stop.  I3C HCI v1.1 section 6.1.2 separates those
steps: clear RS for all running Ring Bundles, and only then clear ENABLE
for all enabled Ring Bundles.

The ring registers were also written outside hci->lock, while the
interrupt handler, which takes that lock, could still be running on
another CPU.  i3c_hci_sync_irq_inactive() was called only afterwards.

Finally, an IBI can still be sitting in the IBI Status Ring when suspend
runs.  Clearing HC_CONTROL.BUS_ENABLE is deferred: per the description of
that field, if a disable request occurs while receiving an IBI, the
actual disabling does not occur until reception of the IBI is complete.

Instead, clear RS under hci->lock, wait for RING_STATUS_RUNNING to clear,
and make the interrupt handler inactive.  Only then disable the ring
interrupt signals, drain anything left in the IBI ring, and clear ENABLE.

Fixes: 816958720443 ("i3c: mipi-i3c-hci: Add DMA suspend and resume support")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-12-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 57 +++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index ec4b469abd337..b8fcea0870ab5 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/i3c/master.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 
 #include "hci.h"
 #include "cmd.h"
@@ -1052,19 +1053,67 @@ static bool hci_dma_irq_handler(struct i3c_hci *hci)
 	return handled;
 }
 
+/*
+ * With the bus disabled, a ring should stop within a few microseconds. The
+ * timeout is therefore only expected to expire if the hardware is stuck.
+ * Allow sufficient margin for slow systems, but keep the delay acceptable
+ * during suspend.
+ */
+#define RING_STOP_TIMEOUT_US	(100 * USEC_PER_MSEC)
+/*
+ * The ring is usually already stopped, so polling typically completes on the
+ * first iteration. Use a modest sleep interval to avoid busy-waiting without
+ * adding excessive latency.
+ */
+#define RING_STOP_SLEEP_US	100
+
 static void hci_dma_suspend(struct i3c_hci *hci)
 {
 	struct hci_rings_data *rings = hci->io_data;
 	int n = rings ? rings->total : 0;
+	struct hci_rh_data *rh;
+	u32 regval;
 
-	for (int i = 0; i < n; i++) {
-		struct hci_rh_data *rh = &rings->headers[i];
+	/* Gracefully stop the rings */
+	scoped_guard(spinlock_irqsave, &hci->lock) {
+		for (int i = 0; i < n; i++) {
+			rh = &rings->headers[i];
+			regval = rh_reg_read(RING_CONTROL);
+			if (regval & RING_CTRL_RUN_STOP)
+				rh_reg_write(RING_CONTROL, regval & ~RING_CTRL_RUN_STOP);
+		}
+	}
 
-		rh_reg_write(INTR_SIGNAL_ENABLE, 0);
-		rh_reg_write(RING_CONTROL, 0);
+	/* Wait for actual stop */
+	for (int i = 0; i < n; i++) {
+		rh = &rings->headers[i];
+		if (readx_poll_timeout(readl, rh->regs + RH_RING_STATUS, regval,
+				       !(regval & RING_STATUS_RUNNING),
+				       RING_STOP_SLEEP_US, RING_STOP_TIMEOUT_US))
+			dev_err(&hci->master.dev, "%s: Ring did not stop, status %#x\n",
+				__func__, regval);
 	}
 
+	/*
+	 * With the rings stopped, no more IBIs can be received. Flush and make
+	 * the interrupt handler inactive.
+	 */
 	i3c_hci_sync_irq_inactive(hci);
+
+	/* Disable interrupt signals and disable the rings */
+	scoped_guard(spinlock_irqsave, &hci->lock)
+		for (int i = 0; i < n; i++) {
+			rh = &rings->headers[i];
+			rh_reg_write(INTR_SIGNAL_ENABLE, 0);
+			/*
+			 * Be absolutely certain there is no unprocessed IBI.
+			 * hci_dma_drain_ibi_ring() will do nothing if there is
+			 * none.
+			 */
+			if (i < IBI_RINGS)
+				hci_dma_drain_ibi_ring(hci, rh);
+			rh_reg_write(RING_CONTROL, 0);
+		}
 }
 
 static void hci_dma_resume(struct i3c_hci *hci)
-- 
2.53.0



