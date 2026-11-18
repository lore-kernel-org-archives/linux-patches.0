Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020255;
	b=fTdlBSQCOK15z+4wkaYxIb65K5c0fXo1Dk0FtP5jEdYs1mWEzeC+7zTd0yktIM+iMPHZ
	 Pq+gELfrI+hiQRdbVqyrJ9fwu1Uq/2VZGovkX2mYfd3ANLD0tLNc+D5R7R+22M3njgmJz
	 gu7b6ZoXrho0zGoOxb4OCmAvklmRHp0ZpESItqDq9irybK5jVXznD7gmUlr3KQhyVKAt+
	 aZA9MDvJBj9+eUnCegoT+6HN7J8YHuAG5fHZg/VoRGMDSFKB1UnA3daTSMZ856flmCdx1
	 InWv/EGkMXBRw5svu6cWJueO/v4OZTZpzVgy5p6Wq30dGtYJf+1BtftbWTC0iAk3laQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b/ynhDlnfSQ5bhRxjwNi/DmJEU+k8o0vZswyA82+m/k=;
	b=GmlSA41ZvKUhrFEfhfE0qHYcv2Otxt/Dv6hJJc9lZ+E43dhINnoZdbU/bqt5G7+s4VKs
	 iDc4gM+p+XOMncitsiUT5IRPqgDZBdbivP/NzdSdOPudE0sGRSBh+5BGitSsUtK77PlrW
	 IrppBfFHPTxhsHQ+dEmly3cipW6T9trzZODLXZqolth8eIDnE+RiJukpXGqTirQPBLXVt
	 wkzLHrrkLXtR8nxTopHWfgQtK5U5FBXF8B4Ku0T8ElQXyULGu/eijqZd7SPOfYFLOB8tg
	 U0sglkAFy8KQ5q7K0Ix+4pmATxzzBcUQgmoeHX0zv10Sl+WPIHuIZ1BGG+Vu3LH3Xrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3UxrbZG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC36606A32F;
	Wed, 18 Nov 2026 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3UxrbZG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30941F000C4;
	Wed, 18 Nov 2026 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020255;
	bh=b/ynhDlnfSQ5bhRxjwNi/DmJEU+k8o0vZswyA82+m/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3UxrbZG/p0NhahXidL0mZg/QTyjaqihkAU5KbrZRovoo0evPCOkirFn63su86WuR
	 Vx7zpCVgHLh7iRmXSTHN9kUmOZ3sKOvWFLWQnYrGegNu3CI4e1LYQUEPJgJcWwUZGu
	 6o2Ibvoa+U6pngCfmDSZAsSMIgVO1MDsk05WQD2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1887/2651] Bluetooth: btusb: Preserve event and ACL packet ordering
Date: Wed, 18 Nov 2026 15:52:07 +0100
Message-ID: <20261118150354.834690493@linuxfoundation.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit fa96916cfd05ceb1c26af0b2ea73daf5481cad2d ]

When force_poll_sync is enabled, commit 800fe5ec302e ("Bluetooth:
btusb: Add support for queuing during polling interval") defers ACL
delivery to the RX worker. The event path currently wakes that worker
before delivering the event, so queued ACL data can reach HCI first.

Deliver the event before waking the worker. This preserves the intended
event-first ordering and the event callback's return value.

Fixes: 800fe5ec302e ("Bluetooth: btusb: Add support for queuing during polling interval")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb_main.c b/drivers/bluetooth/btusb_main.c
index d0e5ab764e9dc..67b7271c9eb9d 100644
--- a/drivers/bluetooth/btusb_main.c
+++ b/drivers/bluetooth/btusb_main.c
@@ -1279,13 +1279,16 @@ static inline void btusb_free_frags(struct btusb_data *data)
 static int btusb_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct btusb_data *data = hci_get_drvdata(hdev);
+	int err;
+
+	err = data->recv_event(hdev, skb);
 
 	if (data->intr_interval) {
 		/* Trigger dequeue immediately if an event is received */
 		schedule_delayed_work(&data->rx_work, 0);
 	}
 
-	return data->recv_event(hdev, skb);
+	return err;
 }
 
 static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
-- 
2.53.0



