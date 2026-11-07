Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062234;
	b=oZk9Fe+5E6cgA/LwyOaj1unNVlHXB4mvNkIk6akeUCkesGdkaqc+qJByNzI6S9aMWTRg
	 2HfH8X1PqTrV23Ro8XtalinkgML6nPx1IGN1Iz+DDhixqrwn1fXpD9aZ9d83m2YUokt+b
	 /bNLXPQvXGgNWtoB1aj27X6JXtMhjJReFQzW9AViCEVDuSLRF2JDNWRwf/J5uPj0RNATT
	 rdAK5el2Em6fYxA/yTRD3wN2ORLNBWkswcDlgs3kX6P5MRWejsGctCbsKWcBf47jT8HIn
	 fuuWcSQOBazvNf2K41P9G0kYaCjXQ34l7bT8qG88MrP+4ONbJir0LkF4dew37WwqO0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g9jqFgxpBUkdnDXDY6MTbJRPgsMF7+FdmUQK3hAxNBc=;
	b=CFKi9wLWjchliks7SzTqGFZUwAaHxaxETgcgnlztYtIK+kwJ28wXsFZtC3z8dxW+m/UK
	 TMy8NO2C3jgurNCibJXp7Iqcjeyg8eQmvLCRq/GlKDh/yrUjOi8PyxYFt3dU/KelPDWax
	 QEISvhiQBQ1J2gxWJWv6dEDx/0Q8p3m2Od0r8u/y3HSh9qFFccDdiWYMC2P3VmVdUcbi0
	 NZLLS59EdrKlGYL7GhwCFneB6CoU4MFKpISlCspS6deexF59g9CZ5UdwoqY4acAxtcNKo
	 XaI73oRocos8lABZNdJyjE2erOWZS6Fk364H8wRZnN3PkAOnDtDSqtCsPZWpw8X8rag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6Cy+wdz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67AF606D827;
	Sat,  7 Nov 2026 14:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6Cy+wdz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B061F0089F;
	Sat,  7 Nov 2026 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062233;
	bh=g9jqFgxpBUkdnDXDY6MTbJRPgsMF7+FdmUQK3hAxNBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6Cy+wdz6AAfiW5sIk5vRtuvDICkGkzCciorUYz3/7evy0MhrAT1f6A2HYYFRKyID
	 xbyJiVxCOWvv9joNADxBRJzE7uqf8RH1H1iwXNHSOxFZwYzqd/RjIpHa5tK9umzftM
	 X7Qyn9MhpqgX1AqMvaVGzNdFG24xEi0cXW4S9af8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1183/1536] wifi: mt76: mt7615: cancel reset work during unregister
Date: Sat,  7 Nov 2026 08:53:19 -0500
Message-ID: <20261107135030.970684671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 5b779c63fb1e20e6729d3241b78be7502759296d ]

The MCU error interrupt handler queues reset_work on the device workqueue.
Device removal can reach mt76_unregister_device() while that work is still
pending, since the workqueue is not destroyed until mt76_free_device().

If reset_work runs in this window, it operates on an unregistered hw and
can requeue mac_work after ieee80211_unregister_hw() has torn the device
down. Cancel it before unregistering the device so it cannot outlive the
registered hw.

Fixes: 61c4fa721968 ("mt76: mt7615: implement hardware reset support")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260927101041.957362-1-yaojiale02@163.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
index f607eee3fb479..5e09f43926e02 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -116,6 +116,7 @@ void mt7615_unregister_device(struct mt7615_dev *dev)
 	mcu_running = mt7615_wait_for_mcu_init(dev);
 
 	mt7615_unregister_ext_phy(dev);
+	cancel_work_sync(&dev->reset_work);
 	mt76_unregister_device(&dev->mt76);
 	if (mcu_running)
 		mt7615_mcu_exit(dev);
-- 
2.53.0



