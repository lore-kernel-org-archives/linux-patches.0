Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620469;
	b=F5lgOcyt2bGVrSWy96Cj+3qMsVm2eWUxddJeTDoPA0rC3DZtfWAELMvYNH6cQNt4IvRp
	 oMUzZe2wKK4DpaAjJK8LIVTqOYpZsMnE88wiIhuuZ4V6TIuLjXSgy4G6G1ao6tgxRYzUv
	 eu6wpitARxURDWk0TKsQo94p97Ic9oN5y8HGg5OLunwupdC33bXbq+vLAzRiMRMbMt6Bu
	 sYNzibHcDIbIWae4M/5RgJGYmQr8aBhocTNr9edAf4DQ8HgbWEhucsD0Shr8ApB+e75SD
	 cUF0yr/P04eCyi4ITHV6stI5ceyGeFLEMxHQaYaNXbdckgj1WULXBJ1pqibjkDJXz/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zoHkwpbwa9r8nc1vsf0CNZuVpMdgmer/6qlqZuTiRYI=;
	b=vK3YUA83lHWbLduua9UphsI6+M/+RszD62z0VtueAhA//+xnsk/Yfjs2kGEefjpX2pLd
	 BOoizomtZtY3uuUV4B1lfbJ4clrUsrXriydKECuZzO8fTXYs7ucF2+wl8IRAZLCINVt0K
	 Ia/YbkJ/0LMsR6VCWq4B7I6n9terjZ9BGc3mzJnYSL65KhdGsirHYLnXrVdAaF/0RF3EK
	 Ouw0BQpGcfoHBxuPvAcnndQ18zer17RVfKV2D6cdP+UTB8HSeyUrIQIeevdG6M3LHMG1j
	 dllZ9W0ypBqziEdrD4w9z2giw4Stb1PysR6ew8aelIYjKEsfPlfhucp9G81t1SoHV+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rMI1/AkK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12793606A321;
	Wed, 25 Nov 2026 15:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMI1/AkK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218671F000C0;
	Wed, 25 Nov 2026 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620468;
	bh=zoHkwpbwa9r8nc1vsf0CNZuVpMdgmer/6qlqZuTiRYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMI1/AkK0iLU2c60co6JPPPlBsZYr8a09YhYFTqbsnxdxiyd3DSyN/5OA6J3cgKjx
	 r2HP3ipqjOGRCOTMSzm16YQyfQdO01034jjDG6mAFA481VggwWuXglHQDYvNBUOH8h
	 Ft+FXCcps2ajx3iyYrfRdT/cV/Fq8a9QypOIFfdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Judt <h.judt@gmx.at>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	stable <stable@kernel.org>,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 7.3 0926/1005] usb: xhci: clear stale bandwidth data after hibernation
Date: Wed, 25 Nov 2026 15:37:44 +0100
Message-ID: <20261125143843.379470340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Niklas Neronin <niklas.neronin@linux.intel.com>

commit d1ec1859f3b8641e3e5c5953cc7dd8e63b54339f upstream.

Controllers using software managed bandwidth accounting maintain
periodic endpoint bandwidth information in struct 'xhci_interval_bw_table'.

Each root hub port owns a bandwidth table and a list of TT bandwidth
domains, where each TT has its own bandwidth table. Virtual devices
reference the bandwidth table of their current bandwidth domain through
'bw_table' or 'tt_info'.

Historically, resume from S4 reinitialized the entire xHCI driver state,
which implicitly cleared all bandwidth accounting data. After the
hibernation resume path was optimized to preserve parts of the driver
state, virtual devices and TT bandwidth information were freed and
recreated, but the root hub bandwidth tables were left intact.

As a result, stale bandwidth accounting data could remain in the root
hub bandwidth tables across hibernation resume, leading to incorrect
bandwidth calculations after devices were rediscovered.

Fix this by resetting all bandwidth accounting data in xhci_rh_bw_cleanup()
so that resume starts with a clean bandwidth state, and resetting the total
active endpoints count.

Fixes: 2a70e5dc0301 ("usb: xhci: optimize resuming from S4 (suspend-to-disk)")
Reported-by: Harald Judt <h.judt@gmx.at>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=222071
Suggested-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Tested-by: Harald Judt <h.judt@gmx.at>
Cc: stable <stable@kernel.org>
Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261105175106.241182-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mem.c | 16 +++++++++++++++-
 drivers/usb/host/xhci.c     |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index af8d4b74c4ba..75577f441cdd 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1903,24 +1903,38 @@ EXPORT_SYMBOL_GPL(xhci_remove_secondary_interrupter);
 void xhci_rh_bw_cleanup(struct xhci_hcd *xhci)
 {
 	struct xhci_root_port_bw_info *rh_bw;
+	struct xhci_interval_bw_table *bw_table;
+	struct xhci_interval_bw *interval_bw;
 	struct xhci_tt_bw_info *tt_info, *tt_next;
 	struct list_head *eps, *ep, *ep_next;
 
 	for (int i = 0; i < xhci->max_ports; i++) {
 		rh_bw = &xhci->rh_bw[i];
 
+		rh_bw->num_active_tts = 0;
 		/* Clear and free all TT bandwidth entries */
 		list_for_each_entry_safe(tt_info, tt_next, &rh_bw->tts, tt_list) {
 			list_del(&tt_info->tt_list);
 			kfree(tt_info);
 		}
 
+		bw_table = &rh_bw->bw_table;
+		bw_table->interval0_esit_payload = 0;
+		bw_table->bw_used = 0;
+		bw_table->ss_bw_in = 0;
+		bw_table->ss_bw_out = 0;
+
 		/* Clear per-interval endpoint lists */
 		for (int j = 0; j < XHCI_MAX_INTERVAL; j++) {
-			eps = &rh_bw->bw_table.interval_bw[j].endpoints;
+			interval_bw = &bw_table->interval_bw[j];
+			eps = &interval_bw->endpoints;
 
+			interval_bw->num_packets = 0;
 			list_for_each_safe(ep, ep_next, eps)
 				list_del_init(ep);
+			interval_bw->overhead[LS_OVERHEAD_TYPE] = 0;
+			interval_bw->overhead[FS_OVERHEAD_TYPE] = 0;
+			interval_bw->overhead[HS_OVERHEAD_TYPE] = 0;
 		}
 	}
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 94da0268b7b3..a762dd010e8d 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1185,6 +1185,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool power_lost, bool is_auto_resume)
 		for (int i = xhci->max_slots; i > 0; i--)
 			xhci_free_virt_devices_depth_first(xhci, i);
 
+		xhci->num_active_eps = 0;
 		xhci_rh_bw_cleanup(xhci);
 
 		xhci->cmd_ring_reserved_trbs = 0;
-- 
2.56.1



