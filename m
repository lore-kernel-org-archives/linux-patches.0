Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53B1D90D9;
	Wed, 19 Feb 2025 09:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957592; cv=none; b=ZVzaFCxuYAn3J0B0SV63aMQEHF/dLnoEOoXH5KHn64+vbcdO/u5RKmus2Q6I3b19Zr6ApoCjBVaMIkFCd6J7WileLOMFIPLK8VcyAHyUTzf64RfGngbZL4ZOG8Sf6ShWgqIwuPr1tHeKwwLghrcFPbvARG++k3+uaU5tEQ/z7M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957592; c=relaxed/simple;
	bh=MTOXqmggtxfR3mrIR98l31kfQR0f5MFkt5LLE6sk8LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYrwbiJUooVcIliVtEKT/I9m25nGQ7+/LlLxJIYrNvqfmLWzlT7Cj6fi8VmUo5Ic5PK+TjsoEx27bttKjR3QM2rE3tUy0TbWbGd7Kske8IBG0oKOFGUM/ezTXFDy0rxf19Q1F7N3xDGDdUAjLF0YFPU88+k7CpBF4paruYSaWe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbpKagsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbpKagsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEB9C4CEE6;
	Wed, 19 Feb 2025 09:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957592;
	bh=MTOXqmggtxfR3mrIR98l31kfQR0f5MFkt5LLE6sk8LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbpKagsyN6CCFJkbmZhd5XOtuVc+ZszN7bszvB6LZ4tEr1bDs1DZscN/Pv9icBYN+
	 7Ke1oz6GVyVviiNJOGOEjhlpYNMdZ7vTEXUqyfVq5sBaE2asdJrm1v324ZfVrr5Rz+
	 DoqDKo8u8Pomz72n058FZH2Sg4XqKeTgqOFK3gA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cormier <jcormier@criticallink.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.1 557/578] drm/tidss: Clear the interrupt status for interrupts being disabled
Date: Wed, 19 Feb 2025 09:29:21 +0100
Message-ID: <20250219082714.866086296@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devarsh Thakkar <devarsht@ti.com>

commit 361a2ebb5cad211732ec3c5d962de49b21895590 upstream.

The driver does not touch the irqstatus register when it is disabling
interrupts.  This might cause an interrupt to trigger for an interrupt
that was just disabled.

To fix the issue, clear the irqstatus registers right after disabling
the interrupts.

Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Cc: stable@vger.kernel.org
Reported-by: Jonathan Cormier <jcormier@criticallink.com>
Closes: https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1394222/am625-issue-about-tidss-rcu_preempt-self-detected-stall-on-cpu/5424479#5424479
Signed-off-by: Devarsh Thakkar <devarsht@ti.com>
[Tomi: mostly rewrote the patch]
Reviewed-by: Jonathan Cormier <jcormier@criticallink.com>
Tested-by: Jonathan Cormier <jcormier@criticallink.com>
Reviewed-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241021-tidss-irq-fix-v1-5-82ddaec94e4a@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -599,7 +599,7 @@ void dispc_k2g_set_irqenable(struct disp
 {
 	dispc_irq_t old_mask = dispc_k2g_read_irqenable(dispc);
 
-	/* clear the irqstatus for newly enabled irqs */
+	/* clear the irqstatus for irqs that will be enabled */
 	dispc_k2g_clear_irqstatus(dispc, (mask ^ old_mask) & mask);
 
 	dispc_k2g_vp_set_irqenable(dispc, 0, mask);
@@ -607,6 +607,9 @@ void dispc_k2g_set_irqenable(struct disp
 
 	dispc_write(dispc, DISPC_IRQENABLE_SET, (1 << 0) | (1 << 7));
 
+	/* clear the irqstatus for irqs that were disabled */
+	dispc_k2g_clear_irqstatus(dispc, (mask ^ old_mask) & old_mask);
+
 	/* flush posted write */
 	dispc_k2g_read_irqenable(dispc);
 }
@@ -738,7 +741,7 @@ static void dispc_k3_set_irqenable(struc
 
 	old_mask = dispc_k3_read_irqenable(dispc);
 
-	/* clear the irqstatus for newly enabled irqs */
+	/* clear the irqstatus for irqs that will be enabled */
 	dispc_k3_clear_irqstatus(dispc, (old_mask ^ mask) & mask);
 
 	for (i = 0; i < dispc->feat->num_vps; ++i) {
@@ -763,6 +766,9 @@ static void dispc_k3_set_irqenable(struc
 	if (main_disable)
 		dispc_write(dispc, DISPC_IRQENABLE_CLR, main_disable);
 
+	/* clear the irqstatus for irqs that were disabled */
+	dispc_k3_clear_irqstatus(dispc, (old_mask ^ mask) & old_mask);
+
 	/* Flush posted writes */
 	dispc_read(dispc, DISPC_IRQENABLE_SET);
 }


