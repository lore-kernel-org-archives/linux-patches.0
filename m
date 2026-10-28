Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215212;
	b=XjKC8/wCbxUjYEf1gmXfXbycvTJ9wgqjaXem11flhQPMURsxUjwBOLCUgMzuBPGcm5MH
	 b3n6zH88EFynH+AWzcaMRTb/27jNOk8LPVbwnIwnZOnrWmyIUUQas/6058954dGc+Hpao
	 BOmw6jXjhRiWO3cCYxkDSiYdsIzMImyhys4dJojQrswybIm53LyF2sRjfsacfOMDXtUeH
	 EbPTEKKPZKyVnZE0RvpM0MS0dXeLeU7/bDu0ts869DyHACagX/IbFnT+PNSM+PIJ3Po3r
	 NySe93G1/jXtCC8ij+O/qPeRf0I18qBuJSuRnoUZQA5SiHGmICd2mcSklOVg+8v2nog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+DFhSZz7GtbOCb6xdjQWKpdsQAJX9RZNCteW2X7BYgE=;
	b=rFsoVitlPXL/uOn04OhOTDOnQ8Z8DB3SGeBo0uhB5yu0gkYpPTMHwiARrnllWR4pnZaz
	 VRL1ylfCsqAUe45L/npNNCrHmM2yxbV04E8hgPaVHBxkQsNEZKwcve+2hEmQrDG+r0uXr
	 tTeuiEz3Ou4RMGDZ/pFzABOdniLAPoY1MMunKcrO3W25XLNFp3mWQxsdB7S3uOOgmVUnY
	 x8VnfSNOT3euOrsc3wm7MYI4ln58HP+fGZPXs3NZmzYZz/TZEv6KYnt1YfLPZnXF986bg
	 gH8mA6fonzILwtAA6p1ueI87q1RnwZbF7gOufRdDRcSd6h702cu5/QlQZM54/V8sZBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpHyNwWc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CB2606A31A;
	Wed, 28 Oct 2026 19:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpHyNwWc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F345B1F01825;
	Wed, 28 Oct 2026 19:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215212;
	bh=+DFhSZz7GtbOCb6xdjQWKpdsQAJX9RZNCteW2X7BYgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpHyNwWcatSXfLdo2JzMC+08tYUoGSOU63sfzvelhourIbxTx/gc/HPigxztVYpJ0
	 sBvcOtQkAO8wWiRtwefDhuJ5EBEiM4aKoG5qFDRjWxPN/i/T4cXwiA+IQtzVuewLIY
	 zdCh0LRiB6v7pZBKgQbUS0EzVgMZdfusXi5XSRzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heitor Alves de Siqueira <halves@igalia.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1130/1887] Bluetooth: hci_sync: Set HCI_CMD_DRAIN_WORKQUEUE during device close
Date: Wed, 28 Oct 2026 17:53:46 +0100
Message-ID: <20261028170525.116873069@linuxfoundation.org>
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

From: Heitor Alves de Siqueira <halves@igalia.com>

[ Upstream commit 525daaea459fc215f432de1b8debbd9144bf97b0 ]

Since hci_dev_close_sync() can now be called during the reset path, we
should also set HCI_CMD_DRAIN_WORKQUEUE. This avoids queuing timeouts
while the hdev workqueue is being drained.

Fixes: 877afadad2dc ("Bluetooth: When HCI work queue is drained, only queue chained work")
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 9529dd7e2a352..c0c19abd92590 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5256,6 +5256,12 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	bt_dev_dbg(hdev, "");
 
+	/* Set HCI_DRAIN_WORKQUEUE flag to prevent queuing work during
+	 * reset/close. See hci_cmd_work() and handle_cmd_cnt_and_timer().
+	 */
+	hci_dev_set_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
+	synchronize_rcu();
+
 	cancel_delayed_work(&hdev->power_off);
 	cancel_delayed_work(&hdev->ncmd_timer);
 	cancel_delayed_work(&hdev->le_scan_disable);
@@ -5274,6 +5280,7 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
+		hci_dev_clear_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
 		return err;
 	}
 
@@ -5367,6 +5374,7 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 	/* Clear flags */
 	hdev->flags &= BIT(HCI_RAW);
 	hci_dev_clear_volatile_flags(hdev);
+	hci_dev_clear_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
 
 	memset(hdev->eir, 0, sizeof(hdev->eir));
 	memset(hdev->dev_class, 0, sizeof(hdev->dev_class));
-- 
2.53.0



