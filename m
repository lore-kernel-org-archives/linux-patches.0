Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214842;
	b=0zMz1cvZpO+knMXf9Rl8IGyh3FNNz3PzECv9B04jthxuBpxFHaN2ZroOzvLNbuMMHs4O
	 YUsVGLUaX8p6g6MHhVMAKRAy5wgbZqx5x6TCGKSVGm93GYHTL2CZZZTFHYkMHTi2p/cgy
	 EDPXkkU+6krH7jVvc0cjeTCTGsGPJrp6NWnFpqefP+p/HYKajNNqI5CcdXwDKBNEMaSQS
	 co+U314YbhP0V+qJH4t9zsa6GVYD2GOVxK+DqHDTA6F7pDo5+MPld+HDR2a3nN+DgHTKr
	 5EBYa55eRcxkqCAheFKpUc5Jd49TNLha/xaa3GWTKCn/NjvWG8Bkt71nf00MYk9NkZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+GQSrigJWGoPTOLDsZ6BzxI6xJj9Ztj2UPylXcx87ZA=;
	b=L6aAVlk+xouautUf2cx5KMCIeGH8fb5cIyAdBA4tyVoHAN1RWaXQ/pzztk1bqE3oYOtM
	 qbDVZM7bqRMOH63lZEeqkOPRxZFv5XQsoa30pvFebl3EfOun0o6QZBTzVWTEXbfoanJUQ
	 ISo2Q9us7yr9E7xM6Onirbecvz0j0AJf0meMTICzCvC25zsunEasf9FJiRQ9RJYDyEepb
	 c0pT5L5d6KiFP5m40vGaXwai+qm+7EAI97hxZEy6YYp+UUE3ataJoU20MMMwAdMWa1Jus
	 JRbSR4eSBLN4r10ZH+xbN0VEaArMExf4/fcr/UvxcWCjo68x8Vw4s94a6SoNEZY6sSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGJrRjRa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D625B606A320;
	Wed, 28 Oct 2026 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGJrRjRa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21B11F01825;
	Wed, 28 Oct 2026 19:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214841;
	bh=+GQSrigJWGoPTOLDsZ6BzxI6xJj9Ztj2UPylXcx87ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGJrRjRaQ3NdFdO/jIzu6NpcQeCMRwj7IwoZy9niPhN6pbMfgenrolhuvmO2mceA0
	 FkBT0w/eEMasmoG57OGmc4u3tj8ApvL6j27nCSTVd/4u+tjyYPELeqOH8+D2tqvFUo
	 BRUq3yULkR3dVf+wqBRsPdyolGqebQ8AJycc/OWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0994/1887] wifi: rtw89: pci: validate sequence number of TX release report
Date: Wed, 28 Oct 2026 17:51:30 +0100
Message-ID: <20261028170522.033656896@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 957eda596c7665f2966970fd1dcc35fe299b38e8 ]

Hardware rarely reports abnormal sequence number in TX release report,
which will access out-of-bounds of wd_ring->pages array, causing NULL
pointer dereference.

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 1 PID: 1085 Comm: irq/129-rtw89_p Tainted: G S   U
             6.1.145-17510-g2f3369c91536 #1 (HASH:69e8 1)
  Call Trace:
   <IRQ>
   rtw89_pci_release_tx+0x18f/0x300 [rtw89_pci (HASH:4c83 2)]
   rtw89_pci_napi_poll+0xc2/0x190 [rtw89_pci (HASH:4c83 2)]
   net_rx_action+0xfc/0x460 net/core/dev.c:6578 net/core/dev.c:6645 net/core/dev.c:6759
   handle_softirqs+0xbe/0x290 kernel/softirq.c:601
   ? rtw89_pci_interrupt_threadfn+0xc5/0x350 [rtw89_pci (HASH:4c83 2)]
   __local_bh_enable_ip+0xeb/0x120 kernel/softirq.c:499 kernel/softirq.c:423
   </IRQ>
   <TASK>
   rtw89_pci_interrupt_threadfn+0xf8/0x350 [rtw89_pci (HASH:4c83 2)]
   ? irq_thread+0xa7/0x340 kernel/irq/manage.c:0
   irq_thread+0x177/0x340 kernel/irq/manage.c:1205 kernel/irq/manage.c:1314
   ? thaw_kernel_threads+0xb0/0xb0 kernel/irq/manage.c:1202
   ? irq_forced_thread_fn+0x80/0x80 kernel/irq/manage.c:1220
   kthread+0xea/0x110 kernel/kthread.c:376
   ? synchronize_irq+0x1a0/0x1a0 kernel/irq/manage.c:1287
   ? kthread_associate_blkcg+0x80/0x80 kernel/kthread.c:331
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
   </TASK>

To prevent crash, validate rpp_info.seq before using.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260110022019.2254969-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index ac76697dc4627..11634b6d40145 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -472,11 +472,16 @@ static void rtw89_pci_release_rpp(struct rtw89_dev *rtwdev,
 	tx_status = le32_get_bits(rpp->dword, RTW89_PCI_RPP_TX_STATUS);
 	txch = rtw89_core_get_ch_dma(rtwdev, qsel);
 
-	if (txch == RTW89_TXCH_CH12) {
+	if (unlikely(txch == RTW89_TXCH_CH12)) {
 		rtw89_warn(rtwdev, "should no fwcmd release report\n");
 		return;
 	}
 
+	if (unlikely(seq >= RTW89_PCI_TXWD_NUM_MAX)) {
+		rtw89_warn(rtwdev, "invalid seq %d\n", seq);
+		return;
+	}
+
 	tx_ring = &rtwpci->tx_rings[txch];
 	wd_ring = &tx_ring->wd_ring;
 	txwd = &wd_ring->pages[seq];
-- 
2.53.0



